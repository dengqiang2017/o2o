package com.qianying.controller.business;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.controller.FilePathController;
import com.qianying.page.PageList;
import com.qianying.service.IProductionManagementService;
import com.qianying.util.ConfigFile;
/**
 * 生产管理控制
 * @author dengqiang
 *
 */
@Controller
@RequestMapping("pm")
@Component
public class ProductionManagementController extends FilePathController{
	@Autowired
	private IProductionManagementService productionManagement;

	@RequestMapping("sp_baseinitStore")
	@ResponseBody
	public ResultInfo sp_baseinitStore(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			productionManagement.sp_baseinitStore(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 *  生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("productionPlan")
	public String productionPlan (HttpServletRequest request) {
//		Map<String, Object> map = getKeyAndValueQuery(request);
//		map.put("sd_order_id", productionManagement.productionPlanSdOrderID(map));
//		request.setAttribute("parameters", map);
		Integer prop = ConfigFile.PlanSource;
		String str = "";
		if(prop == 0){
			str = "pc/pm/productionPlan0";//生产计划数据来源-产品
		}else if(prop == 1){
			str = "pc/pm/productionPlan1";//生产计划数据来源-订单
		}else{
			str = "pc/pm/productionPlan2";//生产计划数据来源-客户+产品
		}
		return str;
	}
	
	/**
	 *  生产流程定义
	 * @param request
	 * @return
	 */
	@RequestMapping("productionProcess")
	public String productionProcess (HttpServletRequest request) {
		request.setAttribute("working_procedure_section", getProductionSection(request));
		return "pc/pm/productionProcess";
	}
	
	/**
	 *  生产派工查询
	 * @param request
	 * @return
	 */
	@RequestMapping("dispatchingWorkQry")
	public String dispatchingWorkQry (HttpServletRequest request) {
		return "pc/pm/dispatchingWorkQry";
	}
	
	/**
	 * 派工
	 * @param request
	 * @return
	 */
	@RequestMapping("toDispatchingWork")
	public String toDispatchingWork(HttpServletRequest request){
		Map<String, Object> map = getKeyAndValueQuery(request);
		map.put("paigong_id", productionManagement.getPaiGongID(map));
		map.put("PlanPush", ConfigFile.PlanPush);
		request.setAttribute("parameters", map);
		Integer prop = ConfigFile.PlanSource;
		String str = "";
		if(prop == 0){
			str = "pc/pm/dispatchingWork0";//生产计划数据来源-产品
		}else{
			str = "pc/pm/dispatchingWork1";//生产计划数据来源-客户+产品或者按订单
		}
		return str;
	}
	
	/**
	 * 提请质检
	 * @param request
	 * @return
	 */
	@RequestMapping("informQC")
	public String informQC(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		Object userInfo = request.getSession().getAttribute("userInfo");
		map.put("userInfo", userInfo);
		map.put("PlanSource", ConfigFile.PlanSource);
		request.setAttribute("parameters", map);
		return "pc/pm/informQC";
	}
	
	/**
	 * 质检查询
	 * @param request
	 * @return
	 */
	@RequestMapping("qualityTestingQry")
	public String qualityTestingQry(HttpServletRequest request){
		return "pc/pm/qualityTestingQry";
	}
	
	/**
	 * 质检
	 * @param request
	 * @return
	 */
	@RequestMapping("qualityTesting")
	public String qualityTesting(HttpServletRequest request){
		Map<String, Object> map = getKeyAndValueQuery(request);
		request.setAttribute("parameters", map);
		return "pc/pm/qualityTesting";
	}
	
	/**
	 * 生产计划跟踪查询
	 * @param request
	 * @return 
	 */
	@RequestMapping("productionTrackingQry")
	public String productionTrackingQry(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValue(request);
		//获取工序类别
		request.setAttribute("working_procedure_section", getProductionSection(request));
		//获取工序名称
		List<Map<String, Object>> list = productionManagement.getProductionProcessInfo(map);
		request.setAttribute("list", list);
		return "pc/pm/productionTrackingQry";
	}
	
	/**
	 * 获取工序列表页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkProcessTree")
	public String getClientTree(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		String[] ps=getProductionSection(request);
		request.setAttribute("working_procedure_section", ps);
		map.put("working_procedure_section", ps[0]);
		List<Map<String, Object>> list=productionManagement.getWorkProcessTree(map);
		request.setAttribute("workProcess", list);
		return  "pc/tree/getWorkProcessTree";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkProcessTreeList")
	@ResponseBody
	public List<Map<String, Object>> getWorkProcessTreeList(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return productionManagement.getWorkProcessTree(map);
	}
	
	/**
	 * 获取工人列表页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkerTree")
	public String getWorkerTree(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		String modal_searchKey = request.getParameter("modal_searchKey");
		if(modal_searchKey!=null){
			map.put("modal_searchKey", "%"+modal_searchKey+"%");
		}
		List<Object> list=productionManagement.getWorkerTree(map);
		request.setAttribute("worker", list);
		return  "pc/tree/getWorkerTree";
	}
	
	/**
	 *  获取指定工序下面的员工
	 * @param work_id
	 * @param modal_searchKey
	 * @return
	 */
	@RequestMapping("getWorkerList")
	@ResponseBody
	public List<Object> getWorkerList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if(isNotMapKeyNull(map, "modal_searchKey")){
			map.put("modal_searchKey", "%"+map.get("modal_searchKey")+"%");
		}
		if(isNotMapKeyNull(map, "work_id")){
			map.put("work_id", "%"+map.get("work_id")+"%");
		}
		return  productionManagement.getWorkerTree(map);
	}
	
	/**
	 * 获取工段
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkingProcedureSection")
	@ResponseBody
	public String[] getWorkingProcedureSection(HttpServletRequest request) {
		return getProductionSection(request);
	}
	
	/**
	 * 查询所有状态为使用的产品信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getProductInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("item_status", "使用");
		PageList<Map<String,Object>> pages = productionManagement.getProductInfo(map); 
		return pages;
	}
	
	/**
	 * 查询所有状态不为待支付、支付中的订单
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getOrderInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		PageList<Map<String,Object>> pages = productionManagement.getOrderInfo(map);
		return pages;
	}
	
	/**
	 * 新增生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("addProductionPlan")
	@ResponseBody
	public ResultInfo addProductionPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map =getKeyAndValue(request);
			//计划日期
			map.put("send_date",getNow());
			//计划结束时间
			map.put("plan_end_date", map.get("plan_end_date")+" 23:59:59.000");
			JSONArray jsons=JSONArray.fromObject(map.get("orderlist"));
			if (getEmployeeId(request)!=null) {
				map.put("clerk_id", getEmployeeId(request));
//				map.put("dept_id", getEmployee(request).get("dept_id"));
			}else{
				map.put("clerk_id", getComId(request));
			}
			productionManagement.addProductionPlan(jsons,map);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
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
		PageList<Map<String,Object>> pages = productionManagement.getProductionPlanInfo(map); 
		return pages;
	}
	/**
	 * 分页查询定制订单已下生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionPlanTailorInfo")
	@ResponseBody
	public PageList<Map<String, Object>> getProductionPlanTailorInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (map.get("memo")!=null&&map.get("memo")!="") {
			map.put("c_memo", "%"+map.get("memo")+"%");
		}
		PageList<Map<String,Object>> pages = productionManagement.getProductionPlanTailorInfo(map); 
		for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
			Map<String,Object> itemmap = iterator.next();
			if (isNotMapKeyNull(itemmap, "item_id")) {
				try {
					String orderNo=MapUtils.getString(itemmap, "item_id");
					List<String> imgs= getTailorInfoImgs(request, orderNo);
					itemmap.put("imgs", imgs);
					String txt=getFileTextContent(getTailorInfoJsonPath(request, orderNo));
					if (StringUtils.isNotBlank(txt)) {//需求信息
						itemmap.put("info", JSONObject.fromObject(txt));
					}
				} catch (Exception e) {}
			}
		}
		return pages;
	}
	
	/**
	 * 删除生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("delProductionPlan")
	@ResponseBody
	public ResultInfo delProductionPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("com_id", getComId(request));
			String[] dataArr = request.getParameterValues("dataArr[]");
			JSONArray jsons=JSONArray.fromObject(dataArr);
			productionManagement.delProductionPlan(jsons,map);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 作废生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("unuseProductionPlan")
	@ResponseBody
	public ResultInfo unuseProductionPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map = getKeyAndValueQuery(request);
			productionManagement.unuseProductionPlan(map);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 查询工序
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionProcessInfo")
	@ResponseBody
	public List<Map<String, Object>> getProductionProcessInfo(HttpServletRequest request) {
		Map<String,Object> map = getKeyAndValueQuery(request);
		return productionManagement.getProductionProcessInfo(map);
	}
	
	/**
	 * 获取当前工段最大工序号
	 * @param request
	 * @return
	 */
	@RequestMapping("getMaxNoSerial")
	@ResponseBody
	public Double getMaxNoSerial(HttpServletRequest request) {
		Map<String,Object> map = getKeyAndValueQuery(request);
		return productionManagement.getMaxNoSerial(map);
	}
	
	/**
	 * 增加工序
	 * @param request
	 * @return
	 */
	@RequestMapping("addProductionProcessInfo")
	@ResponseBody
	public ResultInfo addProductionProcessInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map = getKeyAndValue(request);
			map.remove("_");
			String work_id = productionManagement.addProductionProcessInfo(map);
			map.put("work_id", work_id);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 删除工序
	 * @param request
	 * @return
	 */
	@RequestMapping("delProductionProcessInfo")
	@ResponseBody
	public ResultInfo delProductionProcessInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map = getKeyAndValueQuery(request);
			productionManagement.delProductionProcessInfo(map);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 移动工序
	 * @param request
	 * @return
	 */
	@RequestMapping("moveProductionProcessInfo")
	@ResponseBody
	public ResultInfo moveProductionProcessInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map = getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.moveProductionProcessInfo(map);
			success = true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取生产计划
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductionPlanning")
	@ResponseBody
	Map<String, Object> getProductionPlanning(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("com_id", getComId(request));
		return productionManagement.getProductionPlanning(map);
	}
	
	/**
	 * 查询已派工信息by排产编号
	 * @param request
	 * @return
	 */
	@RequestMapping("getDispatchingWork")
	@ResponseBody
	List<Object> getDispatchingWork(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("com_id", getComId(request));
		List<Object> list = productionManagement.getDispatchingWork(map);
		return list;
	}
	
	/**
	 * 生产派工
	 * @param request
	 * @return
	 */
	@RequestMapping("dispatchingWork")
	@ResponseBody
	ResultInfo dispatchingWork(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			if (getEmployeeId(request)!=null) {
				map.put("clerk_id", getEmployeeId(request));
				map.put("dept_id", getEmployee(request).get("dept_id"));
			}else{
				map.put("clerk_id", getComId(request));
			}
			productionManagement.addProductionProcess(map);
			
			//工艺图纸保存
			String imgUrl=request.getParameter("imgUrl");
			if (StringUtils.isNotBlank(imgUrl)) {
				//删除已存在工艺图纸
				StringBuffer sPath = new StringBuffer(getRealPath(request));
				sPath.append(map.get("com_id")).append("/img/SCPG/")
				.append(map.get("PH")).append("/")
				.append(map.get("JHGR"));
//				productionManagement.deleteDirectory(sPath.toString());
				File file=new File(sPath.toString());
				if (file.exists()&&file.isDirectory()) {
					FileUtils.deleteDirectory(file);
				}
				//增加工艺图纸
				String[] imgUrlArr=imgUrl.split("_");
				for(int i=0;i<imgUrlArr.length;i++){
					File srcFile = new File(getRealPath(request)+imgUrlArr[i]);
					
					StringBuffer buffer=new StringBuffer(getRealPath(request));
					buffer.append(map.get("com_id")).append("/img/SCPG/")
					.append(map.get("PH")).append("/")
					.append(map.get("JHGR")).append("/").append(i)
					.append(".jpg");
					File destFile=new File(buffer.toString());
					if (srcFile.exists()&&srcFile.isFile()) {
						try {
							if (destFile.exists()&&destFile.isFile()) {
								destFile.delete();
							}
							FileUtils.moveFile(srcFile, destFile);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 查看工艺图纸
	 * @param request
	 * @return
	 */
	@RequestMapping("seegytz")
	@ResponseBody
	List<String> seegytz(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("com_id", getComId(request));
		List<String> list = new ArrayList<String>();
		try {
			StringBuffer sPath = new StringBuffer(getRealPath(request));
			sPath.append("/"+map.get("com_id")+"/")
			.append("img/")
			.append("SCPG/")
			.append(map.get("PH")+"/")
			.append(map.get("JHGR"));
			list = productionManagement.getFileName(sPath.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/**
	 * 删除派工
	 * @param request
	 * @return
	 */
	@RequestMapping("delDispatchingWork")
	@ResponseBody
	ResultInfo delDispatchingWork(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.delDispatchingWork(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 作废派工
	 * @param request
	 * @return
	 */
	@RequestMapping("unusedDispatchingWork")
	@ResponseBody
	ResultInfo unusedDispatchingWork(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.unusedDispatchingWork(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 生产派工微信通知
	 * @param request
	 * @return
	 */
	@RequestMapping("dispatchingWorkSendInfo")
	@ResponseBody
	ResultInfo dispatchingWorkSendInfo(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.dispatchingWorkSendInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 待通知质检项查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getInformQC")
	@ResponseBody
	List<Object> getInformQC(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return productionManagement.getInformQC(map);
	}
	
	/**
	 * 开始生产
	 * @param request
	 * @return
	 */
	@RequestMapping("beginWork")
	@ResponseBody
	ResultInfo beginWork(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.beginWork(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 通知质检
	 * @param request
	 * @return
	 */
	@RequestMapping("sendInformQC")
	@ResponseBody
	ResultInfo sendInformQC(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.sendInformQC(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 质检查询
	 * @param request
	 * @return
	 */
	@RequestMapping("getQualityTesting")
	@ResponseBody
	List<Object> getQualityTesting(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return productionManagement.getQualityTesting(map);
	}
	
	/**
	 * 通过com_id、seeds_id获取派工信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getDispatchingWorkBySeedsID")
	@ResponseBody
	Map<String, Object> getDispatchingWorkBySeedsID(HttpServletRequest request){
		Map<String, Object> map = getKeyAndValueQuery(request);
		return productionManagement.getDispatchingWorkBySeedsID(map); 
	}
	
	/**
	 * 质检
	 * @param request
	 * @return
	 */
	@RequestMapping("qualityTest")
	@ResponseBody
	ResultInfo qualityTest(HttpServletRequest request){
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("com_id", getComId(request));
			productionManagement.qualityTest(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 计算各工序完工数量
	 * @param request
	 * @return
	 */
	@RequestMapping("getEachProcessJJSLALL")
	@ResponseBody
	List<Map<String, Object>> getEachProcessJJSLALL(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return productionManagement.getEachProcessJJSLALL(map);
	}
	//////////////////////////////生产计划数据来源2016-05-13//////////////////////////////////////////


}
