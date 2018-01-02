package com.qianying.controller;

import java.io.File;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.excelutils.ExcelUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.PageList;
import com.qianying.service.IClientService;
import com.qianying.service.IEmployeeService;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;

@Controller
@RequestMapping("/client")
public class ClientController extends FilePathController {
	@Autowired
	private IClientService clientService;
	@Autowired
	private IEmployeeService employeeService;
	
	/**
	 *  客户感知记录查询
	 * @param request
	 * @return
	 */
	@RequestMapping("ganzhiRecord")
	@ResponseBody
	public JSONArray ganzhiRecord(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if(isMapKeyNull(map, "beginDate")){
			map.put("beginDate", DateTimeUtils.dateToStr());
		}
		if(isNotMapKeyNull(map, "beginDate")){
			Integer begin=Integer.parseInt(map.get("beginDate").toString().replaceAll("-", "").trim());
			if(isMapKeyNull(map, "endDate")){
				map.put("endDate", DateTimeUtils.dateToStr());
			}
			Integer end=Integer.parseInt(map.get("endDate").toString().replaceAll("-", "").trim());
			Integer len=end-begin;
			if(len==0){
				len=1;
			}
			JSONArray jsons=new JSONArray();
			for (int i = 0; i < len; i++) {
				String beginDate=DateTimeUtils.dateToStr(DateUtils.addDays(DateTimeUtils.strToDate(map.get("beginDate").toString()), i));
				String path=getRealPath(request)+map.get("com_id")+"/ganzhi/"+beginDate+".log";
				String msg=getFileTextContent(path);
				if (StringUtils.isNotBlank(msg)) {
					jsons.addAll(strToJSONArray(msg));
				}
			}
			if (isNotMapKeyNull(map, "searchKey")) {
				String searchKey=map.get("searchKey").toString();
				for (Iterator<JSONObject> iterator = jsons.iterator(); iterator.hasNext();) {
					JSONObject json = iterator.next();
					if(json.getString("name").contains(searchKey)||json.getString("corp_name").contains(searchKey)){
					}else{
						iterator.remove();
					}
				}
			}
			return jsons;
		}else{
			throw new RuntimeException("开始时间不为空!");
		}
	}
	
	/**
	 *  阅读记录分页
	 * @param request
	 * @return
	 */
	@RequestMapping("ganzhiRecordPage")
	@ResponseBody
	public PageList<Map<String,Object>> ganzhiRecordPage(HttpServletRequest request) throws Exception {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return clientService.ganzhiRecordPage(map);
	}
	
	/**
	 * 保存客户感知与微信菜单关联设置
	 * @param request
	 * @return
	 */
	@RequestMapping("saveMenu")
	@ResponseBody
	public ResultInfo saveMenu(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String list=request.getParameter("list");
			if (StringUtils.isNotBlank(list)) {
				File file=new File(getRealPath(request)+"menu.json");
				saveFile(file, list);
				success = true;
			}else{
				msg="数据不能空!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取客户简单信息列表
	 * @param request
	 * @return 客户名称,记忆码,内码,userid,微信id
	 */
	@RequestMapping("getClientSimpleList")
	@ResponseBody
	public List<Map<String,Object>> getClientSimpleList(HttpServletRequest request)throws Exception {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "searchKey")) {
			map.put("keyname", map.get("searchKey"));
		}
		getMySelf_Info(request, map);
		return clientService.getClientSimpleList(map);
	}
	/**
	 * 保存客户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUserInfo")
	@ResponseBody
	public ResultInfo saveUserInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=clientService.saveUserInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取足迹
	 * @param request
	 * @param id 客户编码/供应商编码/员工编码
	 * @param date 日期
	 * @return
	 */
	@RequestMapping("getFootmark")
	@ResponseBody
	public ResultInfo getFootmark(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			if (isMapKeyNull(map, "id")) {
				msg="没有编码";
			}else{
				if (isMapKeyNull(map, "date")) {
					StringBuffer path=new StringBuffer(getComIdPath(request));
					path.append("log/").append(map.get("id")).append("/");
					File f=new File(path.toString());
					if (f.exists()) {
						if (f.isDirectory()) {
							File[] fs=f.listFiles();
							if (fs.length>0) {
								List<File> list=Arrays.asList(fs);
								Collections.reverse(list);
								msg=getFileTextContent(list.get(0));
								success = true;
							}
						}
					}
				}else{
					Long date=DateTimeUtils.strToDate(map.get("date").toString()).getTime();
					File path=getLogPath(request, map.get("id").toString(), date);
					msg=getFileTextContent(path);
					success = true;
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取客户拜访记录
	 * @param request
	 * @return 
	 */
	@RequestMapping("getVisitPage")
	@ResponseBody
	public PageList<Map<String,Object>> getVisitPage(HttpServletRequest request)throws Exception {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(isMapKeyNull(map, "all")){
			map.put("clerk_id", getEmployeeId(request));
		}else{
			Map<String,Object> mapper =(Map<String, Object>) getEmployee(request).get("personnel");
			if (mapper==null||mapper.get("mySelf_Info") == null
					|| "是".equals(mapper.get("mySelf_Info"))) {
				map.put("clerk_id", getEmployeeId(request));
			}
		}
		return clientService.getVisitPage(map);
	}
	/**
	 * 客户拜访记录导出
	 * @param request
	 * @return
	 */
	@RequestMapping("getVisitExcel")
	@ResponseBody
	public ResultInfo getVisitExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			if(isMapKeyNull(map, "all")){
				map.put("clerk_id", getEmployeeId(request));
			}else{
				Map<String,Object> mapper =(Map<String, Object>) getEmployee(request).get("personnel");
				if (mapper==null||mapper.get("mySelf_Info") == null
						|| "是".equals(mapper.get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			//获取要导出的数据
			List<Map<String,Object>> list =clientService.getVisitExcel(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/客户拜访.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("客户拜访.xls");
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 删除客户拜访记录
	 * @param request
	 * @return
	 */
	@RequestMapping("delVisit")
	@ResponseBody
	public ResultInfo delVisit(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=clientService.delVisit(map);
			File file=getVisitPath(request, getEmployeeId(request), map.get("customer_id"), map.get("ivt_oper_listing"));
			if (file.exists()) {
				FileUtils.deleteDirectory(file);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存客户拜访信息
	 * @param request
	 * @param urlList 附件地址列表
	 * @return
	 */
	@RequestMapping("saveVisitInfo")
	@ResponseBody
	public ResultInfo saveVisitInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			//1.保存数据
			Object urlList=map.get("urlList");
			map.remove("urlList");
			map.put("mainten_clerk_id", getEmployeeId(request));
			map.put("maintenance_datetime", getNow());
			if (isMapKeyNull(map, "ivt_oper_listing")) {//增加
				map.put("clerk_id", getEmployeeId(request));
			}
			msg=clientService.saveVisitInfo(map);
			//2.保存附件到相应文件夹
			if (urlList!=null) {
				JSONArray jsons=JSONArray.fromObject(urlList);
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					if (json.getString("url").contains("temp")) {
						File srcFile=new File(getRealPath(request)+json.get("url"));
						if (srcFile.exists()) {
							File destFile=new File(getVisitPath(request, getEmployeeId(request), 
									map.get("customer_id"), msg).getPath()+"/"+srcFile.getName());
							mkdirsDirectory(destFile);
							FileUtils.moveFile(srcFile, destFile);
						}
					}
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取拜访记录附件文件夹路径
	 * @param request
	 * @param clerk_id 业务员编码
	 * @param customer_id 客户编码
	 * @param ivt_oper_listing 记录编码
	 * @return
	 */
	private File getVisitPath(HttpServletRequest request, Object clerk_id,Object customer_id,Object ivt_oper_listing) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("visit/").append(clerk_id)
		.append("/").append(customer_id).append("/").append(ivt_oper_listing).append("/");
		File file =new File(path.toString());
		mkdirsDirectory(file);
		return file;
	}
	
	/**
	 *  获取拜访记录
	 * @param request
	 * @return
	 */
	@RequestMapping("getVisitInfo")
	@ResponseBody
	public Map<String,Object> getVisitInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		Map<String,Object> mapinfo= clientService.getVisitInfo(map);
		File file=getVisitPath(request, getEmployeeId(request), map.get("customer_id"), map.get("ivt_oper_listing"));
		if (file.exists()&&file.isDirectory()) {
			String[] ps=file.list();
			JSONArray urlList=new JSONArray();
			for (int i = 0; i < ps.length; i++) {
				JSONObject json=new JSONObject();
				StringBuffer path=new StringBuffer("/");
				path.append(getComId()).append("/visit/").append(getEmployeeId(request)).append("/").
				append(map.get("customer_id")).append("/").append(map.get("ivt_oper_listing")).append("/").append(ps[i]);
				json.put("url", path.toString());
				json.put("name", ps[i]);
				urlList.add(json);
			}
			mapinfo.put("urlList", urlList.toString());
		}
		return mapinfo;
	}
	/**
	 * 删除工作计划
	 * @param request
	 * @return
	 */
	@RequestMapping("delWorkPlan")
	@ResponseBody
	public ResultInfo delWorkPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=clientService.delWorkPlan(map); 
			File file= getWorkPlanPath(request, getEmployeeId(request), map.get("ivt_oper_listing"));
			if (file.exists()) {
				FileUtils.deleteDirectory(file);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取工作计划
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkPlanInfo")
	@ResponseBody
	public Map<String,Object> getWorkPlanInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		Map<String,Object> mapinfo= clientService.getWorkPlanInfo(map);
		File file=getWorkPlanPath(request, getEmployeeId(request), map.get("ivt_oper_listing"));
		if (file.exists()&&file.isDirectory()) {
			String[] ps=file.list();
			JSONArray urlList=new JSONArray();
			for (int i = 0; i < ps.length; i++) {
				JSONObject json=new JSONObject();
				StringBuffer path=new StringBuffer("/");
				path.append(getComId()).append("/workplan/").append(getEmployeeId(request)).append("/").
				append(map.get("ivt_oper_listing")).append("/").append(ps[i]);
				json.put("url", path.toString());
				json.put("name",ps[i]);
				urlList.add(json);
			}
			mapinfo.put("urlList", urlList.toString());
		}
		return mapinfo;
	}
	/**
	 * 获取工作计划附件文件夹
	 * @param request
	 * @param employeeId 员工编码
	 * @param ivt_oper_listing 计划编码
	 * @return
	 */
	private File getWorkPlanPath(HttpServletRequest request, String employeeId,
			Object ivt_oper_listing) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("/workplan/").append(employeeId).append("/").
		append(ivt_oper_listing).append("/");
		File file=new File(path.toString());
		mkdirsDirectory(file);
		return file;
	}

	/**
	 *  获取工作计划分页数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkPlanPage")
	@ResponseBody
	public PageList<Map<String,Object>> getWorkPlanPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isMapKeyNull(map, "all")) {
			map.put("clerk_id", getEmployeeId(request));
		}else{
			Map<String,Object> mapper =(Map<String, Object>) getEmployee(request).get("personnel");
			if (mapper==null||mapper.get("mySelf_Info") == null
					|| "是".equals(mapper.get("mySelf_Info"))) {
				map.put("clerk_id", getEmployeeId(request));
			}
		}
		return clientService.getWorkPlanPage(map);
	}
	/**
	 * 营销计划记录导出
	 * @param request
	 * @return
	 */
	@RequestMapping("getWorkPlanExcel")
	@ResponseBody
	public ResultInfo getWorkPlanExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			if (isMapKeyNull(map, "all")) {
				map.put("clerk_id", getEmployeeId(request));
			}else{
				Map<String,Object> mapper =(Map<String, Object>) getEmployee(request).get("personnel");
				if (mapper==null||mapper.get("mySelf_Info") == null
						|| "是".equals(mapper.get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			//获取要导出的数据
			List<Map<String,Object>> list =clientService.getWorkPlanExcel(map);
			//将数据集合放入导出中
			ExcelUtils.addValue("listmap", list);
			//Excel模块相对路径
			String config ="/"+getComId(request)+"/xls/营销计划.xls";
			//生成的Excel存放地址
			StringBuffer buffer=new StringBuffer("temp/");
		    buffer.append(getEmployeeId(request)).append("/").append(getNow().split(" ")[0]);
		    buffer.append("营销计划.xls");
		    //生成Excel文件并将路径返回到页面以供下载
		    msg=getExcelPath(request, buffer, config);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存员工工作计划
	 * @param request
	 * @return
	 */
	@RequestMapping("saveWorkPlan")
	@ResponseBody
	public ResultInfo saveWorkPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			//1.保存数据
			Object urlList=map.get("urlList");
			map.remove("urlList");
			map.put("mainten_clerk_id", getEmployeeId(request));
			map.put("maintenance_datetime", getNow());
			if (isMapKeyNull(map, "clerk_id")) {
				map.put("clerk_id", getEmployeeId(request));
			}
			msg=clientService.saveWorkPlanInfo(map);
			//2.保存附件到相应文件夹
			if (urlList!=null) {
				JSONArray jsons=JSONArray.fromObject(urlList);
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					if (json.getString("url").contains("temp")) {
						File srcFile=new File(getRealPath(request)+json.get("url"));
						if (srcFile.exists()) {
							File destFile=new File(getWorkPlanPath(request, getEmployeeId(request), msg).getPath()+"/"+srcFile.getName());
							mkdirsDirectory(destFile);
							FileUtils.moveFile(srcFile, destFile);
						}
					}
				}
			}
			success = true;
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
	@RequestMapping("getEmployeeInfo")
	@ResponseBody
	public Map<String,Object> getEmployeeInfo(HttpServletRequest request) {
		String clerk_id=request.getParameter("clerk_id");
		if (StringUtils.isBlank(clerk_id)) {
			clerk_id=getEmployeeId(request);
		}
		Map<String,Object> map= employeeService.getPersonnel(clerk_id, getComId());
		if(isNotMapKeyNull(map, "weixinID")){
			WeixinUtil wx=new WeixinUtil();
			String msg=wx.getEmployeeInfo(map.get("weixinID").toString(), getComId());
			if (StringUtils.isNotBlank(msg)) {
				JSONObject json=JSONObject.fromObject(msg);
				map.put("weixin_name",json.getString("name"));
				if (json.has("avatar")) {
					map.put("weixin_img",json.getString("avatar"));
				}
			}
		}else if (isNotMapKeyNull(map, "openid")) {
			WeiXinServiceUtil ws=new WeiXinServiceUtil();
			JSONObject json=ws.getUserInfoByOpenid(map.get("openid").toString(), getComId());
			if (json!=null) {
				map.put("weixin_name",getJsonVal(json, "nickname"));
				map.put("weixin_img",getJsonVal(json,"headimgurl"));
			}
		}
		return map;
	}
	/**
	 * 获取json文件内容
	 * @param path  路径或者文件名
	 * @param clerk_id 所属员工
	 * @return 文件内容
	 */
	@RequestMapping("getJsonFile")
	@ResponseBody
	public ResultInfo getJsonFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path=request.getParameter("path");
			String clerk_id=request.getParameter("clerk_id");
			if (StringUtils.isBlank(clerk_id)) {
				clerk_id=getEmployeeId(request);
			}
			File file=new File(getComIdPath(request)+clerk_id+"/"+path);
			msg=getFileTextContent(file);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存
	 * @param path 路径或者文件名
	 * @param clerk_id 所属员工
	 * @param json 内容
	 * @return
	 */
	@RequestMapping("saveJsonFile")
	@ResponseBody
	public ResultInfo saveJsonFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path=request.getParameter("path");
			String clerk_id=request.getParameter("clerk_id");
			String json=request.getParameter("json");
			if (StringUtils.isBlank(clerk_id)) {
				clerk_id=getEmployeeId(request);
			}
			File file=new File(getComIdPath(request)+clerk_id+"/"+path);
			saveFile(file, json);
			success = true;
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
	@RequestMapping("getClientInfoById")
	@ResponseBody
	public List<Map<String,Object>> getClientInfoById(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isNotMapKeyNull(map, "selectClient")) {
			return clientService.getClientInfoById(map);
		}
		return null;
	}
	
	/**
	 * 获取签到信息
	 * @param request
	 * @return false-未签到
	 */
	@RequestMapping("getQiandaoInfo")
	@ResponseBody
	public Map<String,Object> getQiandaoInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
			map.put("nowdate", DateTimeUtils.dateToStr());
			map.put("customer_id", getUpperCustomerId(request));
			return clientService.getQiandaoInfo(map);
		}
		return null;
	}
	
	/**
	 *  生成签到信息
	 * @param request
	 * @return 签到后的结果
	 */
	@RequestMapping("qiandao")
	@ResponseBody
	public Map<String,Object> qiandao(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
			map.put("nowdate", DateTimeUtils.dateToStr());
			map.put("customer_id", getUpperCustomerId(request));
			return clientService.saveQiandaoInfo(map);
		}else{
			return null;
		}
	}
	/**
	 * 保存获取的金币
	 * @param request
	 * @return
	 */
	@RequestMapping("saveJinbiInfo")
	@ResponseBody
	public ResultInfo saveJinbiInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
				map.put("nowdate", DateTimeUtils.dateToStr());
				map.put("customer_id", getUpperCustomerId(request));
				msg=clientService.saveJinbiInfo(map);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取客户总金币数
	 * @param request
	 * @return
	 */
	@RequestMapping("getTotalJinbi")
	@ResponseBody
	public Integer getTotalJinbi(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
			map.put("customer_id", getCustomerId(request));
			return clientService.getTotalJinbi(map);
		}
		return 0;
	}
	
	/**
	 * 获取金币分页列表
	 * @param request
	 */
	@RequestMapping("getJinbiPage")
	@ResponseBody
	public PageList<Map<String,Object>> getJinbiPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
			map.put("customer_id", getCustomerId(request));
		}
		return clientService.getJinbiPage(map);
	}
	
	/**
	 *  获取客户产品浏览分页
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductViewPage")
	@ResponseBody
	public PageList<Map<String,Object>> getProductViewPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(StringUtils.isNotBlank(getCustomerId(request))&&!"001".equals(getCustomerId(request))){
			map.put("customer_id", getCustomerId(request));
		}
		return clientService.getProductViewPage(map);
	}
	
	/**
	 *  获取金币总数,优惠券总数,浏览记录总数
	 * @param request
	 * @return
	 */
	@RequestMapping("getOtherTotal")
	@ResponseBody
	public Map<String,Object> getOtherTotal(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if(StringUtils.isNotBlank(getCustomerId(request))){
			map.put("customer_id", getCustomerId(request));
			map.put("date", DateTimeUtils.dateToStr());
			return clientService.getOtherTotal(map);
		}
		return null;
	}
	//////////////
	/**
	 * 保存优惠券
	 * @param request
	 * @return
	 */
	@RequestMapping("saveCouponRelease")
	@ResponseBody
	public ResultInfo saveCouponRelease(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)!=null){
				Map<String,Object> map=getKeyAndValue(request);
				map.put("create_time", getNow());
				map.remove("typeid");
				if(isMapKeyNull(map, "type_id")){
					map.put("type_id", "");
				}
				msg=clientService.saveCoupon(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 删除发布的优惠券
	 * @param request
	 * @return
	 */
	@RequestMapping("delCoupon")
	@ResponseBody
	public ResultInfo delCoupon(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getEmployee(request)!=null){
				Map<String,Object> auth= (Map<String, Object>) getRequest().getSession().getAttribute("auth");
				if(isNotMapKeyNull(auth, "coupon_del")){
					Map<String,Object> map=getKeyAndValue(request);
					msg=clientService.delCoupon(map);
					success = true;
				}else{
					msg="无操作权限!";
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 优惠券分页展示
	 * @param request
	 * @return
	 */
	@RequestMapping("getCouponPage")
	@ResponseBody
	public PageList<Map<String,Object>> getCouponPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getCustomer(request)!=null) {
			map.put("customer_id", getCustomerId(request));
		}
		return clientService.getCouponPage(map);
	}
	
	/**
	 * 客户领取优惠券
	 * @param request
	 * @return
	 */
	@RequestMapping("receiveCoupon")
	@ResponseBody
	public ResultInfo receiveCoupon(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getCustomerId(request));
			msg=clientService.receiveCoupon(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取客户的优惠券
	 * @param request
	 * @return
	 */
	@RequestMapping("getClientCoupon")
	@ResponseBody
	public PageList<Map<String,Object>> getClientCoupon(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("customer_id", getCustomerId(request));
		return clientService.getClientCoupon(map);
	}
	
	/**
	 * 获取当前支付可使用优惠券
	 * @param request
	 * @return
	 */
	@RequestMapping("getCanUseCoupon")
	@ResponseBody
	public List<Map<String,Object>> getCanUseCoupon(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getCustomerId(request));
		map.put("flag", "0");
		map.put("date", DateTimeUtils.dateToStr());
		return clientService.getCanUseCoupon(map);
	}
}