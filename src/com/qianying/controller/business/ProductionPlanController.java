package com.qianying.controller.business;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.controller.FilePathController;
import com.qianying.page.PageList;
import com.qianying.page.ProductQuery;
import com.qianying.service.IProductService;
import com.qianying.service.IProductionPlanService;
import com.qianying.util.ConfigFile;

@Controller
@RequestMapping("/pPlan")
public class ProductionPlanController extends FilePathController{

	@Autowired
	private IProductionPlanService productionPlanService;
	@Autowired
	protected IProductService productService;
	/**
	 *  生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("productionPlan")
	public String productionPlan(HttpServletRequest request) {
		request.setAttribute("PlanSource", ConfigFile.PlanSource);
		return "pc/pmPlan/productionPlan";
	}
	/**
	 * 查询下生产计划数据来源
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getProductInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(ConfigFile.PlanSource==0){//预测表,产品
			return productService.findAddQuery(map);
		}else{
			
			String[] names=getProcessName(request);
			String processName=getProcessName(request, 0);
			for (int i = 0; i < names.length; i++) {
				if(names[i].contains("生产")){
					processName=getProcessName(request,i);
					break;
				}
			}
			map.put("processName", processName);
			PageList<Map<String,Object>> pages=productionPlanService.getProductInfo(map); 
			for (Iterator<Map<String, Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
				Map<String, Object> itemmap = iterator.next();
				if (isNotMapKeyNull(itemmap, "item_id")) {
					String orderNo=MapUtils.getString(itemmap, "item_id").trim();
					if(orderNo.startsWith("NO")){
						try {
							List<String> imgs= getTailorInfoImgs(request, orderNo);
							itemmap.put("imgs", imgs);
							String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
							if (StringUtils.isNotBlank(txt)) {//需求信息
								itemmap.put("info", JSONObject.fromObject(txt));
							}
						} catch (Exception e) {}
					}
				}
			}
			return pages;
		}
	}
	/**
	 * 分页查询已下生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionPlanInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getProductionPlanInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("memo")!=null&&map.get("memo")!="") {
			map.put("c_memo", "%"+map.get("memo")+"%");
		}
		PageList<Map<String,Object>> pages = productionPlanService.getProductionPlanInfo(map); 
		for (Iterator<Map<String, Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
			Map<String, Object> itemmap = iterator.next();
			if (isNotMapKeyNull(itemmap, "item_id")) {
				String orderNo=MapUtils.getString(itemmap, "item_id").trim();
				if(orderNo.startsWith("NO")){
					try {
						List<String> imgs= getTailorInfoImgs(request, orderNo);
						itemmap.put("imgs", imgs);
						String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
						if (StringUtils.isNotBlank(txt)) {//需求信息
							itemmap.put("info", JSONObject.fromObject(txt));
						}
					} catch (Exception e) {}
				}
			}
		}
		return pages;
	}
	/**
	 * 保存生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("saveProductionPlan")
	@ResponseBody
	public ResultInfo saveProductionPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)==null){
				msg="页面已过期,请重新登录员工!";
			}else{
				Map<String,Object> map=getKeyAndValue(request);
				map.put("clerk_name", getEmployee(request).get("clerk_name"));
				map.put("clerk_id", getEmployeeId(request));
				map.put("dept_id", getEmployee(request).get("dept_id"));
				productionPlanService.saveProductionPlan(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 生产计划跟踪查询
	 * @param request
	 * @return 
	 */
	@RequestMapping("productionTrackingQry")
	public String productionTrackingQry(HttpServletRequest request){
		if(getEmployee(request)==null){
			return "redirect:../pc/login-yuangong.html";
		}
//		Map<String,Object> map=getKeyAndValue(request);
		//获取工序类别
		String[] ps=getProductionSection(request);
//		if(ps!=null){
//			map.put("working_procedure_section", ps[0]);
//		}
		request.setAttribute("working_procedure_section", ps);
		//获取工序名称
//		List<Map<String,Object>> productionProcess = productionPlanService.getProductionProcessInfo(map);
//		request.setAttribute("productionProcess", productionProcess);
//		List<Map<String,Object>> grens=productionPlanService.getGongRenList(map);
//		request.setAttribute("grens", grens);
//		String pgdh =productionPlanService.getOrderNo("生产作业单", getComId(request));
//		request.setAttribute("pgdh", pgdh);
		return "pc/pmPlan/productionTrackingQry";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionProcessInfo")
	@ResponseBody
	public List<Map<String,Object>> getProductionProcessInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productionPlanService.getProductionProcessInfo(map);
	}
	
	
	/**
	 *  获取生产计划跟踪报表分页数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionTrackingPage")
	@ResponseBody
	public PageList<Map<String,Object>> getProductionTrackingPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		
		return productionPlanService.getProductionTrackingPage(map);
	}
	/**
	 * 
	 * @param request
	 * @return 返回派工单号
	 */
	@RequestMapping("savePaigong")
	@ResponseBody
	public ResultInfo savePaigong(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)==null){
				msg="页面过期请重新登录";
				return new ResultInfo(success, msg);
			}
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			if(isMapKeyNull(map, "work_id")){
				msg="没有找到派工编码!";
			}else if(isMapKeyNull(map, "JSGR")){
				msg="请选择工人!";
			}else if(isMapKeyNull(map, "PGSL")||"0".equals(map.get("PGSL"))){
				msg="请输入派工数量!";
			}else{
				msg=productionPlanService.savePaigong(map);
				//
				if(isNotMapKeyNull(map, "imgPath")){
					String[] imgPath=MapUtils.getString(map, "imgPath").split(",");
					for (String path : imgPath) {
						path=path.replaceAll("\\.\\.","");
						File srcFile=new File(getRealPath(request)+path);
						File destFile=new File(getComIdPath(request)+"sctz/"+msg+"/"+map.get("work_id")+"/"+map.get("item_id")+"/"+srcFile.getName());
						if (!destFile.getParentFile().exists()) {
							destFile.getParentFile().mkdirs();
						}
						if(srcFile.exists()){
						FileUtils.moveFile(srcFile, destFile);
						}
					}
				}
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkImg")
	@ResponseBody
	public List<String> getWorkImg(HttpServletRequest request) {
		List<String> list=new ArrayList<String>();
		Map<String,Object> map=getKeyAndValue(request);
		String path=map.get("ivt_oper_listing")+"/"+map.get("work_id")+"/"+map.get("item_id")+"/";
		File destFile=new File(getComIdPath(request)+"sctz/"+path);
		File[] fs=destFile.listFiles();
		if(fs!=null&&fs.length>0){
			for (File file : fs) {
				list.add("/"+getComId()+file.getPath().split("\\\\"+getComId())[1].replaceAll("\\\\", "/"));
			}
		}
		return list;
	}
	
	/**
	 * 通知工人开始生产
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeProduction")
	@ResponseBody
	public ResultInfo noticeProduction(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			productionPlanService.noticeProduction(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  工人派工单
	 * @param request
	 * @return
	 */
	@RequestMapping("paigongdan")
	public String paigongdan(HttpServletRequest request) {
		return "pc/pmPlan/paigongdan";
	}
	/**
	 *  获取工人生产列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkerProductionList")
	@ResponseBody
	public PageList<Map<String,Object>> getWorkerProductionList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (!"001".equals(getEmployeeId(request))) {
			if(!"质检".equals(map.get("type"))){
				map.put("clerk_id", getEmployeeId(request));
			}
		}
		return productionPlanService.getWorkerProductionList(map);
	}
	/**
	 * 开始生产
	 * @param request
	 * @return
	 */
	@RequestMapping("beginProduction")
	@ResponseBody
	public ResultInfo beginProduction(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)==null){
				return new ResultInfo(success, "页面已过期,请重新登录!");
			}
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			productionPlanService.beginProduction(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 通知质检
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeQualityCheck")
	@ResponseBody
	public ResultInfo noticeQualityCheck(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			productionPlanService.noticeQualityCheck(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  质检页面
	 * @param request
	 * @return
	 */
	@RequestMapping("qualityCheck")
	public String qualityCheck(HttpServletRequest request) {
		return "pc/pmPlan/qualityCheck";
	}
	
	/**
	 *  获取待质检数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getQualityCheckList")
	@ResponseBody
	public List<Map<String,Object>> getQualityCheckList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("clerk_id", getEmployeeId(request));
		return productionPlanService.getQualityCheckList(map);
	}
	
	/**
	 * 质检通过接口
	 * @param request
	 * @return
	 */
	@RequestMapping("qualityChecked")
	@ResponseBody
	public ResultInfo qualityChecked(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)==null){
				return new ResultInfo(success, "页面过期,请重新登录!");
			}
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			msg=productionPlanService.qualityChecked(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  工人工价表
	 * @param request
	 * @return
	 */
	@RequestMapping("workPrice")
	public String workPrice(HttpServletRequest request) {
		return "pc/pmPlan/workPrice";
	}
	/**
	 *  工人工价表查询记录
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkPriceList")
	@ResponseBody
	public Map<String,Object> getWorkPriceList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionPlanService.getWorkPriceList(map);
	}
	/**
	 *  工价汇总表
	 * @param request
	 * @return
	 */
	@RequestMapping("workSumPrice")
	public String workSumPrice(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		//获取工序类别
		String[] ps=getProductionSection(request);
		if(ps!=null){
			map.put("working_procedure_section", ps[0]);
		}
		request.setAttribute("working_procedure_section", ps);
		//获取工序名称
		List<Map<String,Object>> productionProcess = productionPlanService.getProductionProcessInfo(map);
		request.setAttribute("productionProcess", productionProcess);
		return "pc/pmPlan/workSumPrice";
	}
	/**
	 *  工价汇总表查询记录
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkSumPriceList")
	@ResponseBody
	public Map<String,Object> getWorkSumPriceList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionPlanService.getWorkSumPriceList(map);
	}
}
