package com.qianying.controller;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.bean.VerificationCode;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PageList;
import com.qianying.page.ProductClassQuery;
import com.qianying.page.WarehouseQuery;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IOperatorsService;
import com.qianying.service.IProductService;
import com.qianying.service.ISystemParamsService;
import com.qianying.service.IUserService;
import com.qianying.util.ConfigFile;
import com.qianying.util.InitConfig;
import com.qianying.util.Kit;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;

@Controller
@RequestMapping("/manager")
public class ManagerController extends FilePathController {

	@Autowired
	private IProductService productService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private IEmployeeService employeeService;
	@Autowired
	private IUserService userService;
	@Autowired
	private IOperatorsService operatorsService;
	@Autowired
	private ISystemParamsService systemParams;
	/**
	 * 跳转到管理者菜单页面
	 * @param request
	 * @return
	 */
	@RequestMapping("/manager")
	public String manager(HttpServletRequest request) {
		return "redirect:employee.do";
	}
	//////////////////////////////////////////
	/**
	 * 管理模式驾驶舱--系统参数页面
	 * @return
	 */
	@RequestMapping("systemParams")
	public String systemParams(HttpServletRequest request) {
		File imgfile=new File(getRealPath(request)+"weixinimg/");
		List<String> list=new ArrayList<String>();
		if(imgfile.exists()){
			File[] files=imgfile.listFiles();
			for (File file : files) {
				list.add(file.getName());
			}
		}
		request.setAttribute("imgs", list);
		return "pc/manager/systemParamsNew";
	}
	@RequestMapping("getSystemParams")
	@ResponseBody
	public Map<String,Object> getSystemParams(HttpServletRequest request) {
		Map<String,Object> map=managerService.getSystemParamsByComIdSet(getComId());
		if(map==null||isMapKeyNull(map, "corpid")){
		ClassLoader loader = InitConfig.class.getClassLoader();
		try {
			map= Kit.getTxtKeyVal(loader.getResourceAsStream("initConfig.txt"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		}
		map.put("ProductionSection", getProductionSection(request));
		map.put("workType", getWorkType(request));
//		map.put("processNameList",JSONArray.fromObject(getFileTextContent(getSalesOrderProcessNamePath(request))));map.remove("processName");
		map.put("emplName", ConfigFile.emplName.toLowerCase());
		return map;
	}
	
	@RequestMapping("saveSystemParams")
	@ResponseBody
	public ResultInfo saveSystemParams(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			request.getSession().setAttribute("o2o", map.get("o2o"));
			if (StringUtils.isNotBlank(ConfigFile.urlPrefix)&&!ConfigFile.urlPrefix.startsWith("http://")) {
				ConfigFile.urlPrefix="http://"+ConfigFile.urlPrefix;
				map.put("urlPrefix", ConfigFile.urlPrefix);
			}
		    //////存储生成工段定义/////////////
			String ProductionSection=getString(map, "ProductionSection");
			saveFile(getProductionSectionPath(request), ProductionSection);
			map.remove("ProductionSection");
			//////存储生成工序类别定义/////////////
			String workType=getString(map, "workType");
			saveFile(getWorkTypePath(request), workType);
			map.remove("workType");
			//////////////////
			ClassLoader loader = InitConfig.class.getClassLoader();
			String path=loader.getResource("initConfig.txt").getPath();
			Object[] keys =  map.keySet().toArray();
			StringBuffer buffer=new StringBuffer();
			for (int i = 0; i < keys.length; i++) {
				buffer.append(keys[i]).append("=").append(map.get(keys[i])).append("\n");
			}
			buffer.append("appBase=webapps");
			///保存配置到配置文件中
			saveFile(path, buffer.toString());
			File systemName=new File(BaseController.getRealPath(request)+getComId()+"/systemName.txt");
			saveFile(systemName, map.get("systemName").toString());
			InitConfig.init();
			WeixinUtil weicom=new WeixinUtil();
			weicom.delAccessFile(getComId());
			////////////写入配置参数到配置文件中////////////
			String corpid=MapUtils.getString(map, "corpid");
			 if(StringUtils.isNotBlank(corpid)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"corpid"), corpid);
			 }
			 String mch_id=MapUtils.getString(map, "mch_id");
			 if(StringUtils.isNotBlank(mch_id)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"mch_id"), mch_id);
			 }
			 String corpsecret=MapUtils.getString(map, "corpsecret");
			 if(StringUtils.isNotBlank(corpsecret)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"corpsecret"), corpsecret);
			 }
			 String corpsecret_chat=MapUtils.getString(map, "corpsecret_chat");
			 if(StringUtils.isNotBlank(corpsecret_chat)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"corpsecret_chat"), corpsecret_chat);
			 }
			 String appid_service=MapUtils.getString(map, "appid_service");
			 if(StringUtils.isNotBlank(appid_service)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"appid_service"), appid_service);
			 }
			 String secret_service=MapUtils.getString(map, "secret_service");
			 if(StringUtils.isNotBlank(secret_service)){
				 BaseController.saveFile(WeixinUtil.getWeixinParamFile(getComId(),"secret_service"), secret_service);
			 }
			 weicom.getDeptList(map.get("agentDeptId"),getComId());
			 //保存微信角色对应
			 saveFile(WeixinUtil.getWeixinParamFile(getComId(), "agentJsons"), map.get("agentList").toString());
			//////////////////////
			managerService.saveSystemParams(map);
			writeLog(request,getEmployeeId(request), getEmployee(request).get("clerk_name")+"", "修改系统参数");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	private String getString(Map<String,Object> map,String name){
		if (map.get(name)!=null) {
			return MapUtils.getString(map, name);// map.get(name).toString();
		}else{
			return "";
		}
	} 
	///////////
	/**
	 * 添加或者修改产品页面
	 * @param request
	 * @return 跳转到添加或者修改产品页面
	 */
	@RequestMapping("product")
	public String product(HttpServletRequest request) {
		if(!checkAuthority(request,"product","_maintenance")){
			return null;
		}
		String item_id=request.getParameter("item_id");
//		if (StringUtils.isNotBlank(item_id)) {
//			Map<String,Object> map=productService.getByItemId(item_id);
//			if (map.get("store_struct_id")!=null) {
//				Object store_struct_name=managerService.getOneFiledNameByID("Ivt01001", "store_struct_name", "sort_id='"+map.get("store_struct_id").toString()+"'",getComId(request));
//				if (store_struct_name!=null) {
//					map.put("store_struct_name", store_struct_name);
//				}
//			}
//			File slfile=new File(getComIdPath(request)+"img/"+item_id+"/sl.jpg");
//			if(slfile.exists()){
//				map.put("sl", getComId()+"/img/"+item_id+"/sl.jpg");
//			}
//			request.setAttribute("product", map);
//		}
		request.setAttribute("item_id", item_id); 
		request.setAttribute("com_id", getComId()); 
		request.setAttribute("info", request.getParameter("info"));
		File file=new File(getCpTempPath(request));
		File filexj=new File(getXjTempPath(request));
		try {
			if (file.getPath().contains("cp")) {
			FileUtils.deleteDirectory(file);
			}
			if (filexj.getPath().contains("xj")) {
				FileUtils.deleteDirectory(file);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("work_type", getWorkType(request));
		request.setAttribute("fileds", getShowFiledList(request,"product"));
		return "pc/manager/product";
	}

	/**
	 *  获取产品详情
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductInfo")
	@ResponseBody
	public Map<String,Object> getProductInfo(HttpServletRequest request) {
		String item_id=request.getParameter("id");
		if (StringUtils.isNotBlank(item_id)) {
			Map<String,Object> map=productService.getByItemId(item_id);
 			File slfile=new File(getComIdPath(request)+"img/"+item_id+"/sl.jpg");
			if(slfile.exists()){
				map.put("sl", getComId()+"/img/"+item_id+"/sl.jpg");
			}
			return map;
		}
		return null;
	}
	
	
	/**
	 * 产品分页列表页面
	 * @param request
	 * @return 调整产品分页页面
	 */
	@RequestMapping("productlist")
	public String productlist(HttpServletRequest request) {
//		proPageList(productService, request);
		List<Map<String, Object>> clss= productService.getProductClass(request);
		request.setAttribute("clss",clss);
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"product"));
		return  "pc/manager/productlist";
	}
	
	/**
	 *  获取指定数据表的所有字段
	 * @param request
	 * @return
	 */
	@RequestMapping("getTableFiled")
	@ResponseBody
	public Map<String,Object> getTableFiled(HttpServletRequest request) {
		String table=request.getParameter("table");
		return managerService.getTableFiled(table);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("definitionTable")
	public String definitionTable(HttpServletRequest request) {
		return "pc/manager/definitionTable";
	}
	
	/**
	 * 保存定义表
	 * @param request
	 * @return
	 */
	@RequestMapping("saveDefinitionTable")
	@ResponseBody
	public ResultInfo saveDefinitionTable(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			saveFile(getShowFiledPath(request, map.get("fileName")), map.get("content").toString());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取产品分页列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getProductList")
	@ResponseBody
	public PageList<Map<String, Object>> getProductList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "item_spec")) {
			map.put("item_spec", "%"+map.get("item_spec")+"%");
		}
		PageList<Map<String, Object>> pages= productService.findQuery(map);
//		getProductImgNum(pages.getRows());
		return pages;
	}
	/**
	 * 产品类别页面
	 * @param request
	 * @return
	 */
	@RequestMapping("productClass")
	public String productClass(HttpServletRequest request) {
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"productClass"));
		return "pc/manager/productClass";
	}
	@RequestMapping("getProductClass")
	@ResponseBody
	public List<Map<String, Object>> getProductClass(HttpServletRequest request) {
		return productService.getProductClass(request);
	}
	@RequestMapping("getProductClassPage")
	@ResponseBody
	public PageList<Map<String, Object>> getProductClassPage(HttpServletRequest request,ProductClassQuery query) {
		 return productService.getProductClassPage(query);
	}
	///////////////////////////////////////////////
	/**
	 * 调整到审批流程类型选择页面
	 * @param request
	 * @return
	 */
	@RequestMapping("approvalmenu")
	public String approvalmenu(HttpServletRequest request) {
		
		return ConfigFile.PC_OR_PHONE+"manager/approvalmenu";
	}
	/**
	 * 跳转到审批流程列表页面
	 * @param request
	 * @return
	 */
	@RequestMapping("approvallist")
	public String approvallist(HttpServletRequest request) {
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("name", request.getParameter("name"));
		return ConfigFile.PC_OR_PHONE+"manager/approvallist";
	}
	/**
	 * 调整到审批流程添加或者修改页面
	 * @param request
	 * @return
	 */
	@RequestMapping("approval")
	public String approval(HttpServletRequest request) {
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("name", request.getParameter("name"));
		return ConfigFile.PC_OR_PHONE+"manager/approval";
	}
	/////////////////////////部门维护//////////////////
	/**
	 * 到部门维护页面
	 * @return
	 */
	@RequestMapping("dept")
	public String dept(HttpServletRequest request) {
//		request.setAttribute("depts", managerService.getDeptByUpper_dept_id(null));
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"dept"));
		return "pc/manager/dept";
	}
	/**
	 * 部门编辑
	 * @param request
	 * @return
	 */
	@RequestMapping("deptEdit")
	public String deptEdit(HttpServletRequest request) {
		String sort_id=request.getParameter("sort_id");
		request.setAttribute("sort_id", sort_id);
		request.setAttribute("info", request.getParameter("info"));
		request.setAttribute("fileds", getShowFiledList(request,"dept"));
		return "pc/manager/deptEdit";
	}
	@RequestMapping("getDeptInfo")
	@ResponseBody
	public Map<String,Object> getDeptInfo(HttpServletRequest request) {
		String sort_id=request.getParameter("id");
		Map<String,Object> map=managerService.getDeptBySortId(sort_id);
//		Map<String,Object> newmap=new HashMap<String, Object>();
//		Object[] keys =  map.keySet().toArray();
//		for (int i = 0; i < keys.length; i++) {
//			if (map.get("upper_dept_id")!=null&&!"".equals(map.get("upper_dept_id"))) {
//				Map<String,Object> mapupper=managerService.getDeptBySortId(map.get("upper_dept_id").toString());
//				newmap.put("upper_dept_name", mapupper.get("dept_sim_name"));
//			}
//			newmap.put(getPreFixBySession(request)+keys[i], map.get(keys[i]));
//		}
		return map;
	}
	/**
	 * 获取部门列表信息
	 * @param upper_dept_id 上级部门内码
	 * @return 部门列表
	 */
	@RequestMapping("getDeptByUpper_dept_id")
	@ResponseBody
	public List<Map<String, Object>> getDeptByUpper_dept_id(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "treeId")) {
			map.put("upper_dept_id", map.get("treeId"));
		}
		String id=request.getParameter("id");
		if (StringUtils.isNotBlank(id)) {
			map.put("id", id);
		}
		map.put("filed", getFiledNameBYJson(request, "dept","sort_id",null));
		return managerService.getDeptByUpper_dept_id(map);
	}
	/**
	 * 保存或者更新部门
	 * @param request
	 * @return 执行结果
	 */
	@RequestMapping("saveDept")
	@ResponseBody
	public ResultInfo saveDept(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
		int type=1;
		String table="Ctl00701";
		String sortName="sort_id";//内码名称
		String upperName="upper_dept_id";//上级内码名称
		/////////////////////////////////
		Map<String, Object> map=getKeyAndValue(request, sortName);
		//1.1获取上级编码
		String upper_dept_id=request.getParameter(upperName);
		//1.2获取产品类别编码
		String sort_id=request.getParameter(sortName);
		//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
		if (StringUtils.isBlank(sort_id)) {//新增加
			//1.4不存在生成新编码
			sort_id = getSortId(table,"DE",managerService);
			//1.4.1判断是否有上级编码
			if (StringUtils.isNotBlank(upper_dept_id)) {
				//1.4.2将新编码前加入新的上级编码
				sort_id=upper_dept_id+sort_id;
			}
			type=0;
		}
		if (isMapKeyNull(map, "dept_id")||MapUtils.getString(map, "dept_id").startsWith("DE")) {
			map.put("dept_id", sort_id);
		}
		map.put(sortName, sort_id);
		managerService.insertSql(map, type, table,  sortName, sort_id); 
		msg=map.get(sortName).toString();
		success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 获取指定部门下的员工信息
	 * @param request
	 * @param sort_id 部门内码
	 * @return
	 */
	@RequestMapping("getDeptEmployee")
	@ResponseBody
	public List<Map<String, Object>> getDeptEmployee(HttpServletRequest request,String sort_id) {
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("name", request.getParameter("sort_name"));
		if (StringUtils.isNotBlank(sort_id)) {
			map.put("sort_id", sort_id);
		}
		return managerService.getDeptEmployee(map);
	}
	/**
	 * 加载选择树页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getDeptTree")
	public String getDeptTree(HttpServletRequest request) {
		String type=request.getParameter("type");
		String id=request.getParameter("id");
		List<Map<String, Object>> listMap=null;
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", getComId());
		if (StringUtils.isNotBlank(id)) {
			map.put("id", id);
		}
		if (StringUtils.isBlank(type)||"dept".equals(type)) {//部门树
			listMap=getDeptByUpper_dept_id(request);
			request.setAttribute("depts", listMap);
			return  "pc/tree/deptTree";
		}else if("employee".equals(type)){//员工树
			listMap= managerService.getDeptEmployee(map);
			request.setAttribute("employees", listMap);
			return  "pc/tree/employeeTree";
		}else if("personnel".equals(type)){
			listMap= managerService.getDeptEmployee(map);
			request.setAttribute("employees", listMap);
			return  "pc/tree/personnelTree";
		}else if("regionalism".equals(type)){//行政区划树
			listMap= managerService.getRegionalismTree(map);
			request.setAttribute("regionalismTrees", listMap);
			return "pc/tree/regionalismTree";
		}else if ("cls".equals(type)) {//产品类型树
			listMap= productService.getProductClass(request);
			request.setAttribute("clss", listMap);
			return "pc/tree/classTree";
		}else if("warehouse".equals(type)){//库房树
			listMap= managerService.getWarehouseTree(map);
			request.setAttribute("wares", listMap);
			return "pc/tree/warehouseTree";
		}else if ("settlement".equals(type)) {//结算方式树
			listMap= managerService.getSettlementList(map);
			request.setAttribute("settlements", listMap);
			return "pc/tree/settlementTree";
		}else if ("client".equals(type)) {//客户
			if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
				if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			listMap=customerService.getCustomerTree(map);
			request.setAttribute("clients", listMap);
			return "pc/tree/clientTree";
		}
		else if("vendor".equals(type)){//供应商
			listMap= managerService.getGysTree(map);
			request.setAttribute("vendors", listMap);
			return "pc/tree/vendorTree";
		}else if("operate".equals(type)){
			listMap= managerService.getOperateTree(map);
			request.setAttribute("operates", listMap);
			return "pc/tree/operateTree";
		}else{
			return "";
		}
	}
	////////////////////////////////////
	/**
	 * 获取树形列表
	 * @param request
	 * @param type 树形类型
	 * @param treeId 父级ID
	 * @return
	 */
	@RequestMapping("getTree")
	@ResponseBody
	public List<Map<String, Object>> getTree(HttpServletRequest request) {
		String type=request.getParameter("type");
		String treeId=request.getParameter("treeId");
		String searchKey=request.getParameter("searchKey");
		List<Map<String, Object>> list=null;
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", getComId());
		if(StringUtils.isNotBlank(searchKey)){
			map.put("searchKey", "%"+searchKey+"%");
		}
		String name=request.getParameter("name");
		if (StringUtils.isNotBlank(name)) {
			map.put("name","%"+name+"%");
		}
		if (StringUtils.isBlank(type)||"dept".equals(type)) {
			list=getDeptByUpper_dept_id(request);
		}else if ("employee".equals(type)) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("sort_id", treeId);
			}
			list= managerService.getDeptEmployee(map);
		}else if ("regionalism".equals(type)) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("regionalism_id", treeId);
			}
			list=managerService.getRegionalismTree(map);
		}else if ("productClass".equals(type)) {
			list=productService.getProductClass(request);
		}else if (type.contains("client")) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("customer_id", treeId);
			}
			if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
				if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			list=customerService.getCustomerTree(map);
		}else if ("settlement".equals(type)) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("sort_id", treeId);
			}
			list=managerService.getSettlementList(map);
		}else if ("warehouse".equals(type)) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("sort_id", treeId);
			}
			list=managerService.getWarehouseTree(map);
		}else if("vendor".equals(type)){
			if (StringUtils.isNotBlank(treeId)) {
				map.put("corp_id", treeId);
			}
			list= managerService.getGysTree(map);
		}else if ("operate".equals(type)) {
			if (StringUtils.isNotBlank(treeId)) {
				map.put("comId", treeId);
			}
			list= managerService.getOperateTree(map);
		}
		return list;
	}
	
	/////////////客户维护//////////////////////
	/**
	 * 到客户维护页面
	 * @param request
	 * @return
	 */
	@RequestMapping("client")
	public String client(HttpServletRequest request) {
		//////判断是否有使用权限
		if(!checkAuthority(request,"client","_maintenance")){
			return null;
		}
		Map<String,Object> mapparam=getKeyAndValue(request);
		if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
			if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
				mapparam.put("clerk_id", getEmployeeId(request));
			}
		}
		List<Map<String, Object>> clients=customerService.getCustomerTree(mapparam);
		request.setAttribute("clients", clients);
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		if(StringUtils.isNotBlank(ConfigFile.emplName)){
			request.setAttribute("emplName", ConfigFile.emplName.toLowerCase());
		}else{
			request.setAttribute("emplName", "");
		}
		request.setAttribute("fileds", getShowFiledList(request,"client"));
		request.setAttribute("smsType", systemParams.checkSystem("smsType", "0"));
		
		return  "pc/manager/client";
	}
	/**
	 * 获取客户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerInfo")
	@ResponseBody
	public Map<String,Object> getCustomerInfo(HttpServletRequest request) {
		String customer_id=request.getParameter("id");
		Map<String,Object> map= customerService.getCustomerByCustomer_id(customer_id,getComId(request));
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
	 * 到客户维护页面
	 * @param request
	 * @return
	 */
	@RequestMapping("clientEdit")
	public String clientEdit(HttpServletRequest request) {
		if(!checkAuthority(request,"client","_maintenance")){
			return null;
		}
		String customer_id=request.getParameter("customer_id");
		if ("CS1".equals(customer_id)||"CS1_ZEROM".equals(customer_id)||"CS1_ERROR".equals(customer_id)) {
			return "pc/manager/back";
		}
		String next=request.getParameter("next");
		String corp_name=request.getParameter("item_name");
		if (StringUtils.isNotBlank(next)) { 
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("upper_customer_id", customer_id);
			map.put("upper_corp_name", corp_name);
			request.setAttribute("client", map);
		}else{
//			if (StringUtils.isNotBlank(customer_id)) {
//				Map<String,Object> map=customerService.getCustomerByCustomer_id(customer_id,getComId(request));
//				if (!isMapKeyNull(map, "driveId")) {
//					map.put("driveNum", map.get("driveId").toString().split(",").length);
//				}
//				request.setAttribute("client",map );
//			}
			request.setAttribute("info", request.getParameter("info"));
		}
		request.setAttribute("customer_id", request.getParameter("customer_id"));
		request.setAttribute("com_id", getComId(request));
		request.setAttribute("processNames", getProcessName(request));
		request.setAttribute("fileds", getShowFiledList(request,"client"));
		return "pc/manager/clientEdit";
	}
	
	/**
	 * 获取树形列表页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getClientTree")
	public String getClientTree(HttpServletRequest request) {
//		CustomerQuery query=new CustomerQuery();
		Map<String,Object> mapparam=getKeyAndValue(request);
		if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
			if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
				mapparam.put("clerk_id", getEmployeeId(request));
			}
		}
		List<Map<String, Object>> map=customerService.getCustomerTree(mapparam);
		request.setAttribute("clients", map);
		if (mapparam.get("next")!=null) {
			return  "pc/tree/clientNextTree";
		}else{
			return  "pc/tree/clientTree";
		}
	}
	/**
	 * 获取客户列表
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping("getCustomer")
	@ResponseBody
	public PageList<Map<String, Object>> getCustomer(HttpServletRequest request,CustomerQuery query) {
		query.setCom_id(getComId(request));
		if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
			if("是".equals(getEmployee(request).get("mySelf_Info"))){
				query.setClerk_id(getEmployeeId(request));
			}
		}
		return customerService.findQuery(query);
	}
	
	
	
	
	@RequestMapping("getCustomerTree")
	@ResponseBody
	public List<Map<String, Object>> getCustomerTree(HttpServletRequest request,String customer_id) {
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("customer_id", customer_id);
		if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
			if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
				map.put("clerk_id", getEmployeeId(request));
			}
		}
		return customerService.getCustomerTree(map);
	}
	/**
	 * 保存客户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveClient")
	@ResponseBody
	public synchronized ResultInfo saveClient(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			int type=1;
			String table="SDf00504";
			String sortName="customer_id";//内码名称
			String upperName="upper_customer_id";//上级内码名称getPreFixBySession(request)+getPreFixBySession(request)+
			String customer_id=request.getParameter(sortName);
			String upper_dept_id=request.getParameter(upperName);
			//////////////////////////////////////////////////////////////////
			Map<String, Object> map=getKeyAndValue(request, sortName);
			//1.1获取上级编码
			//1.2获取产品类别编码
			String sort_id=request.getParameter(sortName);
			//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
			if (StringUtils.isBlank(sort_id)) {//新增加
				//1.4不存在生成新编码
				sort_id = getSortId(table,"C",managerService);
				//1.4.1判断是否有上级编码
				if (StringUtils.isNotBlank(upper_dept_id)) {
					//1.4.2将新编码前加入新的上级编码
					sort_id=upper_dept_id+sort_id;
				}
				type=0;
			}
			if (!sort_id.startsWith("CS1")) {
				sort_id="CS1"+sort_id;
			}
			map.put(sortName, sort_id);
			/////////////////////////
//			if (map.get("user_password")!=null) {
//				if (map.get("user_password").toString().length()<32) {
//					map.put("user_password", MD5Util.MD5(map.get("user_password").toString()));
//				}
//			}
			if (isMapKeyNull(map, "movtel")) {
				map.put("movtel", map.get("user_id"));
			}
			//将销售订单流程存入文件中
			map.remove("salesOrder_Process_Name");
			map.remove("type");
			managerService.insertSql(map, type, table, sortName, customer_id);
			msg=map.get(sortName).toString();
			////提交客户数据到微信企业号///
			map.put("name", map.get("corp_name"));
			String key=request.getParameter("type");
			if(StringUtils.isBlank(key)){
				 key="客户";
			}
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
			postInfoToweixin(map, key,agentDeptId);
			/////////////////////处理上传图片/////////////
			File srcDir=new File(getUserpicTempPath(request));
			if (srcDir.exists()) {
				File destDir=new File(getComIdPath(request)+"userpic/"+sort_id);
				for (File srcFile : srcDir.listFiles()) {
					if (srcFile.exists()) {
					File destFile=new File(destDir.getPath()+"/"+srcFile.getName());
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					if(!destFile.getParentFile().exists()){
						destFile.getParentFile().mkdirs();
					}
//					imgResize(srcFile, destFile,500, 0.5f); 
//					srcFile.delete();
					FileUtils.moveFile(srcFile, destFile);
					}
				}
			}
			success=true;
 		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}                                           
		return new ResultInfo(success, msg);       	
	}

	/**
	 * 检查客户手机号是否存在
	 * @param request
	 * @param phone
	 * @return 存在返回false,不存在返回true
	 */
	@RequestMapping("checkPhone")
	@ResponseBody
	public ResultInfo  checkPhone(HttpServletRequest request,String phone) {
		boolean success = false;
		String msg = null;
		if (StringUtils.isBlank(phone)) {
			msg="请输入手机号!";
		}else{
			String type=request.getParameter("type");
			if (StringUtils.isBlank(type)) {
				success=customerService.checkPhone(phone,getComId());
			}else if("vendor".equals(type)){
				success=managerService.checkPhone(phone,"Ctl00504"," and ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"'");
			}else if("driver".equals(type)){
				success=managerService.checkPhone(phone,"Sdf00504_saiyu"," and isclient='1' and ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"'");
			}else if("dian".equals(type)){
				success=managerService.checkPhone(phone,"Sdf00504_saiyu"," and isclient='0' and ltrim(rtrim(isnull(com_id,'')))='"+getComId()+"'");
			}else{
				success=employeeService.checkPhone(phone,getComId());
			}
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 检查外码是否存在
	 * @param request
	 * @return
	 */
	@RequestMapping("checkSelfId")
	@ResponseBody
	public ResultInfo checkSelfId(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		String self_id=request.getParameter("self_id");
		if (StringUtils.isBlank(self_id)) {
			msg="请输入外码!";
		}else{
			String type=request.getParameter("type");
			Object obj=null;
			 if("vendor".equals(type)){
				obj= managerService.getOneFiledNameByID("Ctl00504", "self_id", "self_id="+self_id, getComId());
			}else if("driver".equals(type)){
				obj= managerService.getOneFiledNameByID("Sdf00504_saiyu", "self_id", "isclient='1' and self_id='"+self_id+"'", getComId());
			}else if("dian".equals(type)){
				obj= managerService.getOneFiledNameByID("Sdf00504_saiyu", "self_id", "isclient='0' and self_id='"+self_id+"'", getComId());
			}else{
				obj= managerService.getOneFiledNameByID("ctl00801", "self_id", "self_id="+self_id, getComId());
			}
			 if (obj!=null) {
				 success=true;
			}else{
				success=false;
			}
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 * 检查客户外码是否已经存在
	 * @param request
	 * @return 存在返回true,不存在返回false
	 */
	@RequestMapping("checkClientSelfId")
	@ResponseBody
	public ResultInfo checkClientSelfId(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String self_id=request.getParameter("self_id");
			if (StringUtils.isNotBlank(self_id)) {
				success = customerService.checkClientSelfId(getComId(request),self_id);
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 判断删除项是否被引用
	 * @param com_id
	 * @param sort_id
	 * @param flag
	 * @return
	 * @throws Exception
	 */
	public boolean sp_BaseIsUsed(String com_id,String sort_id,int flag)throws Exception {
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", com_id);
		map.put("sort_id",sort_id);
		map.put("i_Flag",flag);
		String res= managerService.sp_BaseIsUsed(map);
		if (StringUtils.isNotBlank(res)) {
			throw new RuntimeException(res);
		}else{
			Integer i=0;
			try {
				i=managerService.checkDelCilent(map);
				if(i==null){
					i=0;
				}
			} catch (Exception e) {}
			if (i>0) {
				throw new RuntimeException("该客户已经产生数据,不能删除!");
			}else{
				return true;
			}
		}
	}
	
	@RequestMapping("delClient")
	@ResponseBody
	 public ResultInfo delClient(HttpServletRequest request,String customer_id) {
		boolean success=false;
		String msg=null;
		try {
			String type=request.getParameter("type");
			String treeId=request.getParameter("treeId");
			String ivt_num_detail=request.getParameter("ivt_num_detail");
			String seeds_id=request.getParameter("seeds_id");
			if (StringUtils.isNotBlank(treeId)) {
				treeId=treeId.toString();
			}
			String com_id=getComId();
			if (StringUtils.isBlank(type)||"dept".equals(type)) {
				if (sp_BaseIsUsed(com_id, treeId, 3)) {
					managerService.deleteRecord("ctl00701","sort_id","upper_dept_id",treeId,com_id);
				}
			}else if ("employee".equals(type)) {
				if (sp_BaseIsUsed(com_id, treeId,4)) {
					managerService.deleteRecord("ctl00801","clerk_id",null,treeId,com_id);
					managerService.deleteRecord("ctl09003","clerk_id",null,treeId,com_id);
					///删除对应的权限文件
					File file=getAuthorityPath(request, treeId);
					if(file.exists()&&file.isFile()){
						FileUtils.deleteDirectory(file.getParentFile());
					}
				}
			}else if ("regionalism".equals(type)) {
//				if (sp_BaseIsUsed(com_id, treeId,4)) {
				managerService.deleteRecord("Ctl01001","sort_id","upper_regionalism_id",treeId,com_id);
//				}
			}else if ("productClass".equals(type)) {
				managerService.deleteRecord("ctl03200","sort_id","upper_sort_id",treeId,com_id);
			}else if ("product".equals(type)) {
				if (sp_BaseIsUsed(com_id, treeId,0)) {
				managerService.deleteRecord("Ctl03001","item_id",null,treeId,com_id);
				}
			}else if ("client".equals(type)) {
				if (sp_BaseIsUsed(com_id, treeId,1)) {
				managerService.deleteRecord("SDf00504","customer_id","upper_customer_id",treeId,com_id);
					File file=new File(getComIdPath(request)+"userpic/"+treeId);
					if(file.exists()){
						FileUtils.deleteDirectory(file);
					}
				}
			}else if ("settlement".equals(type)) {
				if (!ConfigFile.JS000SYS.contains(treeId)) {
					if (sp_BaseIsUsed(com_id, treeId,5)) {
					managerService.deleteRecord("ctl02107","sort_id","upper_settlement_id",treeId,com_id);
					}
				}else{
					throw new RuntimeException("系统默认结算方式不能删除!");
				}
			}else if ("warehouse".equals(type)) {
				if (sp_BaseIsUsed(com_id, treeId,5)) {
				managerService.deleteRecord("Ivt01001","sort_id","upper_storestruct",treeId,com_id);
				}
			}else if("vendor".equals(type)){
				if (sp_BaseIsUsed(com_id, treeId,2)) {
					managerService.deleteRecord("ctl00504", "corp_id", "direct_upper_corp_id", treeId, com_id);
					File file=new File(getComIdPath(request)+"userpic/"+treeId);
					if(file.exists()){
						FileUtils.deleteDirectory(file);
					}
				}
			}else if("operate".equals(type)){
				managerService.deleteRecord("ctl00501", "com_id", "upper_com_id", treeId, com_id);
			}else if("dian".equals(type)){
				managerService.deleteRecord("Sdf00504_saiyu", "com_id", "customer_id", treeId, com_id);
			}else if("drive".equals(type)){
				managerService.deleteRecord("Sdf00504_saiyu", "com_id", "customer_id", treeId, com_id);
				File file=new File(getComIdPath(request)+"evalimg/"+treeId);
				if(file.exists()){
					FileUtils.deleteDirectory(file);
				}
			}else if("inventory".equals(type)){
				managerService.deleteRecord("IVTd01300", "ivt_num_detail", null, ivt_num_detail, com_id);
			}else if("receivable".equals(type)){
				managerService.deleteRecord("ARf02030", "seeds_id", null, seeds_id, com_id);
			}else if("handle".equals(type)){
				managerService.deleteRecord("stfM0201", "seeds_id", null, seeds_id, com_id);
			}
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
//			e.printStackTrace();
			LoggerUtils.error(e.getMessage());
		}
		return new ResultInfo(success, msg);
	}                                           
	///////////////////员工/////////////////////
	@RequestMapping("personnel")
	 public String personnel(HttpServletRequest request) {
		if(!checkAuthority(request,"personnel","_maintenance")){
			return null;
		}
		request.setAttribute("depts",getDeptByUpper_dept_id(request));
//		PersonnelQuery query=new PersonnelQuery();
//		request.setAttribute("personnels", employeeService.getPersonnelByClerk_id(request,query));
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		return "pc/manager/personnel";
	}
	
	@RequestMapping("updateInfo")
	@ResponseBody
	public ResultInfo updateInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String clerk_id=request.getParameter("clerk_id");
			String mySelf_Info=request.getParameter("mySelf_Info");
			String regionalism_id=request.getParameter("regionalism_id");
			Map<String,Object> map=new HashMap<String, Object>();
			if (StringUtils.isNotBlank(regionalism_id)) {
				map.put("regionalism_id", regionalism_id);
			}
			if (StringUtils.isNotBlank(mySelf_Info)) {
				map.put("mySelf_Info", mySelf_Info);
			}
			managerService.insertSql(map, 1, "ctl00801", "clerk_id", clerk_id);
			
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("getEmployeeInfo")
	public String getEmployeeInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("info", "info");
		map.put("clerk_id", request.getParameter("clerk_id"));
		getDept_idInfoQuery(request, map, "dept_idInfo", "deptIdInfo.sql", "dept_id","t1.", employeeService);
		if (map.get("dept_idInfo")!=null) {
			map.put("dept_idInfo" , map.get("dept_idInfo").toString().replaceAll("dept_id", "sort_id"));
			map.put("dept_idInfo" , map.get("dept_idInfo").toString().replaceAll("like", "="));
			map.put("dept_idInfo" , map.get("dept_idInfo").toString().replaceAll("%", ""));
		}
		getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql","customer_id", "t1.", employeeService);
		if (map.get("customer_id")!=null) {
			map.put("customer_id" , map.get("customer_id").toString().replaceAll("customer_id", "customer_id")) ;
		}
		getDept_idInfoQuery(request, map, "type_id", "type_id.sql","type_id", "t1.", employeeService);
		if (map.get("type_id")!=null) {
			map.put("type_id" , map.get("type_id").toString().replaceAll("type_id", "sort_id")) ;
		}
		getDept_idInfoQuery(request, map, "store_struct_id_Info", "store_struct_id_Info.sql","store_struct_id_Info", "t1.", employeeService);
		if (map.get("store_struct_id_Info")!=null) {
				map.put("store_struct_id_Info" , map.get("store_struct_id_Info").toString().replaceAll("store_struct_id_Info", "sort_id")) ;
		}
		String type=request.getParameter("type");
		if ("dept".equals(type)&&map.get("dept_idInfo")!=null) {
			List<Map<String,Object>> list= managerService.getEmployeeInfo(map);
			list.remove(null);
			if (list!=null&&list.size()>0) {
				request.setAttribute("list", list);
				request.setAttribute("type", type);
			}
		}else if ("client".equals(type)&&map.get("customer_id")!=null) {
			List<Map<String,Object>> list= managerService.getEmployeeInfo(map);
			list.remove(null);
			if (list!=null&&list.size()>0) {
				request.setAttribute("list", list);
				request.setAttribute("type", type);
			}
		}else if ("cls".equals(type)&&map.get("type_id")!=null) {
			List<Map<String,Object>> list= managerService.getEmployeeInfo(map);
			list.remove(null);
			if (list!=null&&list.size()>0) {
				request.setAttribute("list", list);
				request.setAttribute("type", type);
			}
		}else if ("warehouse".equals(type)&&map.get("store_struct_id_Info")!=null) {
			List<Map<String,Object>> list= managerService.getEmployeeInfo(map);
			list.remove(null);
			if (list!=null&&list.size()>0) {
				request.setAttribute("list", list);
				request.setAttribute("type", type);
			}
		}else if("mySelf_Info".equals(type)){
			request.setAttribute("type", type);
			request.setAttribute("clerk_id", request.getParameter("clerk_id"));
			return "pc/manager/modal/modal_radio";
		}
		return "pc/manager/modal/infosee";
	}
	@RequestMapping("getEmployeeRelevantSelect")
	@ResponseBody
	public List<Map<String,Object>> getEmployeeRelevantSelect(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		String type=request.getParameter("type");
		if (map.get("queryName")!=null) {
			map.put("queryName", "%"+map.get("queryName")+"%");
		}
		List<Map<String,Object>> list=null;
		if ("dept".equals(type)){
			list=managerService.getDeptByUpper_dept_id(map);
		}else if ("client".equals(type)){
			
		}else if ("cls".equals(type)){
			
		}else if ("warehouse".equals(type)){
			
		}
		return list;
	}
	
	@RequestMapping("getPersonnels")
	@ResponseBody
	public PageList<Map<String, Object>> getPersonnels(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getPersonnelByClerk_id(request,map);
	}
	/**
	 * 获取名称根据内编码
	 * @param map
	 * @param name 内编码名称
	 * @param upperName 查询字段的名称
	 * @param scname 生成字段的名称
	 * @param com_id 
	 * @param table 表名
	 */
	public void setNameToMap(Map<String,Object> map,String name,String idName,String upperName,String scname,String com_id,String table) {
		if (isNotMapKeyNull(map, name)) {
			Map<String,Object> mapcus=new HashMap<String, Object>();
			mapcus.put("com_id", com_id);
			String[] dept_idInfos=map.get(name).toString().split(",");
			if (dept_idInfos!=null) {
				StringBuffer buffer=new StringBuffer();
				for (String cusid : dept_idInfos) {
					////////////
					mapcus.put("idName",idName);
					mapcus.put("upperName",upperName);
					mapcus.put("idVal",cusid);
					mapcus.put("table",table);
					///////////
					String cusname=managerService.getUpperId(mapcus);
					buffer.append(cusname).append(",");
				}
				map.put(scname, buffer.toString());
			}
		}
	}
	@RequestMapping("personnelEdit")
	public String personnelEdit(HttpServletRequest request) {
		String clerk_id=request.getParameter("clerk_id");
		File file=new File(getEmployeeImgPath(request, clerk_id).toString());
		if (file.exists()&&file.listFiles()!=null&&file.listFiles().length>0) {
			for (File item : file.listFiles()) {
				if (item.isFile()) {
					StringBuffer path=new StringBuffer("/").append(getComId()).append("/");// getEmployeeImgPath(request, clerk_id).append(item.getName());
					path.append(clerk_id).append("/img/").append(item.getName());
					request.setAttribute("sfzpath", path.toString());
				}
			}
		}
		request.setAttribute("info", request.getParameter("info"));
		request.setAttribute("clerk_id", clerk_id);
		request.setAttribute("auth",getTxtKeyVal(request,clerk_id));
		request.setAttribute("processNames", getProcessName(request));
		request.setAttribute("fileds", getShowFiledList(request,"employee"));
		return "pc/manager/personnelEdit"; 
	}

	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getPersonnelInfo")
	@ResponseBody
	public Map<String,Object> getPersonnelInfo(HttpServletRequest request) {
		String clerk_id=request.getParameter("id");
		if (StringUtils.isNotBlank(clerk_id)) {
			String com_id=getComId(request);
			Map<String,Object> map=employeeService.getPersonnel(clerk_id,com_id);
			setNameToMap(map, "type_id","sort_id", "sort_name", "type_name", com_id, "ctl03200");
			setNameToMap(map, "work_id","sort_id", "work_name", "work_name", com_id, "B_001");
			setNameToMap(map, "customer_id","customer_id", "corp_sim_name", "customer_name", com_id, "sdf00504");
			setNameToMap(map, "dept_idInfo","sort_id", "dept_name", "dept_idInfoName", com_id, "Ctl00701");
			setNameToMap(map, "store_struct_id_Info","store_struct_id", "store_struct_name", "store_struct_id_InfoName", com_id, "Ivt01001");
			map.put("describe", getFileTextContent(getPlanquery(request, clerk_id, "describe.txt")));
			return map;
		}
		return null;
	}
	
	/**
	 * 获取员工权限
	 * @param request
	 * @return
	 * @throws FileNotFoundException
	 */
	@RequestMapping("authority")
	public String authority(HttpServletRequest request) throws FileNotFoundException {
		//1.获取员工内码
//		String clerk_id=request.getParameter("clerk_id");
//		//2.获取权限文件中对应的权限
//		request.setAttribute("auth",getTxtKeyVal(request,clerk_id));
		String type=request.getParameter("type");
		File file=new File(getComIdPath(request)+"filed/auth.json");
		String info=getFileTextContent(file);
		 if (StringUtils.isNotBlank(info)) {
			 request.setAttribute("auths",JSONArray.fromObject(info));
		}
		if (StringUtils.isNotBlank(type)) {
			return "pc/manager/emlpoyee_authority";
		}else{
			return "pc/manager/authority";
		}
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getAuth")
	@ResponseBody
	public Map<String,Object> getAuth(HttpServletRequest request) {
		String clerk_id=request.getParameter("clerk_id");
		return getTxtKeyVal(request,clerk_id);
	}
	
	/**
	 * 保存权限
	 * @param request
	 * @return
	 */
	@RequestMapping("saveAuthority")
	@ResponseBody
	public ResultInfo saveAuthority(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String qxlist=request.getParameter("qxlist");
			String clerk_id=request.getParameter("clerk_id");
			qxlist=qxlist.replaceAll(",", "\n");
			StringBuffer qxBuffer=new StringBuffer(getComIdPath(request));
			qxBuffer.append("planquery/").append(clerk_id).append("/authority.txt");
			File qxFile=new File(qxBuffer.toString());
			saveFile(qxFile, qxlist);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 员工权限复制
	 * @param request
	 * @return
	 */
	@RequestMapping("authorityCopy")
	@ResponseBody
	public ResultInfo authorityCopy(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String treeSelectId=request.getParameter("treeSelectId");
			String clerk_id=request.getParameter("clerk_id");
			if (StringUtils.isBlank(treeSelectId)) {
				msg="没有指定员工!";
			}else if (StringUtils.isBlank(clerk_id)) {
				msg="没有指定复制来源员工";
			}else{
				StringBuffer buffer=new StringBuffer(getComIdPath(request));
				buffer.append("planquery/");
				buffer.append(clerk_id).append("/authority.txt");
				File file=new File(buffer.toString());
				if (file.exists()&&file.isFile()) {
					File selectFile=new File(file.getParentFile().getParent()+"/"+treeSelectId+"/authority.txt");
					if (selectFile.exists()&&selectFile.isFile()) {
						selectFile.delete();
					}
					FileUtils.copyFile(file, selectFile);
					success=true;
				}else{
					msg="没有员工的权限文件可复制!";
				}
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
	@RequestMapping("saveUserInfo")
	@ResponseBody
	public ResultInfo saveUserInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Object filePath=map.get("filePath");
			String clerk_id=map.get("clerk_id").toString();
			map.remove("filePath");
//			msg=managerService.saveUserInfo(map);
			managerService.insertSql(map, 1, "ctl00801", "clerk_id",map.get("clerk_id").toString());
			if (filePath!=null&&StringUtils.isNotBlank(filePath.toString())) {
				File srcFile=new File(getRealPath(request)+filePath);
				String dest=getEmployeeImgPath(request, clerk_id).append("sfz.")
				.append(FilenameUtils.getExtension(filePath+"")).toString();
				File destFile=new File(dest);
				if(srcFile.exists()){
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					if (!destFile.exists()) {
						destFile.getParentFile().mkdirs();
					}
					FileUtils.moveFile(srcFile, destFile);
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
	 * 保存员工维护信息
	 * @param request
	 * @return
	 */
	@RequestMapping("savePersonnel")
	@ResponseBody
	public ResultInfo savePersonnel(HttpServletRequest request) {
		String msg = null;
		boolean success = false;
		try {
			int type=1;
			String table="Ctl00801";
			String sortName="clerk_id";//内码名称
//			String upperName="upper_dept_id";//上级内码名称getPreFixBySession(request)+
			String clerk_id=request.getParameter(sortName);
			if (StringUtils.isBlank(clerk_id)) {
				Integer  seedsId=managerService.getMaxSeeds_id(table, "seed_id");
				clerk_id = String.format("E%06d", seedsId+1);
				type=0;
			}
			Map<String,Object> map=getKeyAndValue(request, sortName);
//			Object qxfpcontent=map.get("qxfpcontent");
			map.remove("qxfpcontent");
			Object filePath=map.get("filePath");
			map.remove("filePath");
			map.put(sortName, clerk_id);
			if (isMapKeyNull(map, "self_id")) {
				map.put("self_id", clerk_id);
			}
//			String working_status=map.get("working_status").toString();
			map.remove("user_id");
			if (isNotMapKeyNull(map, "describe")) {
				File file=new File(getPlanquery(request, clerk_id, "describe.txt"));
				saveFile(file, map.get("describe").toString());
			}
			map.remove("describe");
			managerService.insertSql(map, type, table, sortName, clerk_id);
			msg=map.get("clerk_id").toString();
			Map<String,Object> mapc=new HashMap<String, Object>();
			mapc.put("com_id", map.get("com_id"));
			mapc.put("user_id", map.get("movtel"));
			mapc.put(sortName, clerk_id);
			if (map.get("user_password")!=null) {
				if (map.get("user_password").toString().length()<32) {
					map.put("user_password", MD5Util.MD5(map.get("user_password").toString()));
				}
			}
			mapc.put("if_O2O", 2);
//			mapc.put("working_status","Y");
			mapc.put("i_browse","Y");
			mapc.put("usr_grp_id", 0);
			mapc.put("user_password", map.get("user_password"));
			//从ctl09003获取是否有该记录根据用户名
			Map<String,Object> map9003= managerService.checkLogin(map.get("movtel").toString(),getComId(request));
			if (map9003==null) {//没有就插入//默认为更新
				type=0;
			}else{
				//如果存在但是内编码不一致将原有的数据删除掉并插入新的数据
				if (!clerk_id.equals(map9003.get("clerk_id"))) {
					managerService.deleteRecord("ctl09003","clerk_id",null,map9003.get("clerk_id").toString(),getComId(request));
					type=0;
				}else{
					type=1;
				}
			}
			LoggerUtils.info(mapc);
			managerService.insertSql(mapc, type, "ctl09003", sortName, clerk_id);
		////提交客户数据到微信企业号///
			map.put("name", map.get("clerk_name"));
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
			postInfoToweixin(map, "员工",agentDeptId);
			/////将图片移动到正式文件夹////////////
			if (filePath!=null&&StringUtils.isNotBlank(filePath.toString())) {
				File srcFile=new File(getRealPath(request)+filePath);
				String dest=getEmployeeImgPath(request, clerk_id).append("sfz.")
				.append(FilenameUtils.getExtension(filePath+"")).toString();
				File destFile=new File(dest);
				if(srcFile.exists()){
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					if (!destFile.exists()) {
						destFile.getParentFile().mkdirs();
					}
					FileUtils.moveFile(srcFile, destFile);
				}
			}
			///生成部门来源sql
			if (map.get("mySelf_Info")==null||"是".equals(map.get("mySelf_Info").toString())) {//等于空或者是,不能查看自己部门下所有人
			}
			moreSourcesSql(request, map, "dept_idInfo", "deptIdInfo.sql", "dept_id");
			moreSourcesSql(request, map, "customer_id", "customer_id.sql", "customer_id");
			moreSourcesSql(request, map, "type_id", "type_id.sql", "type_id");
			moreSourcesSql(request, map, "store_struct_id_Info", "store_struct_id_Info.sql", "store_struct_id_Info");
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 多来源拼装sql
	 * @param request
	 * @param map
	 * @param srcName 来源字段名称
	 * @param filename 生成的文件名
	 * @param queryName 查询字段名称
	 */
	private void moreSourcesSql(HttpServletRequest request, Map<String, Object> map,String srcName,String filename,String queryName) {
		if (map.get(srcName)==null||map.get(srcName)=="") {
			return;
		}		
		StringBuffer sql=new StringBuffer(" and (");
		String[] deptIdInfos=map.get(srcName).toString().split(",");
		for (int i = 0; i < deptIdInfos.length; i++) {
			if (!"".equals(deptIdInfos[i])) {
				if (i==(deptIdInfos.length-1)) {
					sql.append(" ltrim(rtrim(isnull("+queryName+",''))) like '").append(deptIdInfos[i]).append("%'");
				}else{
					sql.append(" ltrim(rtrim(isnull("+queryName+",''))) like '").append(deptIdInfos[i]).append("%' or ");
				}
			}
		}
		writeSql(getPlanquery(request, map.get("clerk_id"), filename), sql);
	}
	private void writeSql(String buffer,StringBuffer sql){
		try {
			File file=new File(buffer);
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			if (file.exists()&&file.isFile()) {
				file.delete();
			}
			saveFile(file, sql.append(")").toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/////////////////库房////////////////////////
	/**
	 * 跳转到库房列表
	 * @param request
	 * @return
	 */
	@RequestMapping("warehouse")
	public String warehouse(HttpServletRequest request) {
		//1.获取上级库房
		Map<String,Object> map=getKeyAndValueQuery(request);
		request.setAttribute("warehouses", managerService.getWarehouseTree(map));
		WarehouseQuery query=new WarehouseQuery();
		query.setCom_id(getComId());
		request.setAttribute("fileds", getShowFiledList(request,"warehouse"));
		request.setAttribute("pages",  managerService.getWarehouseByPage(map));
		return "pc/manager/warehouse";
	}
	/**
	 * 跳转到库房编辑页面
	 * @param request
	 * @param sort_id
	 * @return
	 */
	@RequestMapping("warehouseEdit")
	public String warehouseEdit(HttpServletRequest request,String sort_id) {
		request.setAttribute("ware", managerService.getWarehouse(sort_id,getComId()));
		request.setAttribute("info", request.getParameter("info"));
		return "pc/manager/warehouseEdit";
	}
	/**
	 * 获取库房列表
	 * @param request
	 * @param query
	 * @return
	 */
	@RequestMapping("getWarehouse")
	@ResponseBody
	public PageList<Map<String, Object>> getWarehouse(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (isNotMapKeyNull(map, "dept_name")) {
			map.put("dept_name", "%"+map.get("dept_name")+"%");
		}
		if (isNotMapKeyNull(map, "store_struct_name")) {
			map.put("store_struct_name", "%"+map.get("store_struct_name")+"%");
		}
		if (isNotMapKeyNull(map, "easy_id")) {
			map.put("easy_id", "%"+map.get("easy_id")+"%");
		}
		return managerService.getWarehouseByPage(map);
	}
	/**
	 * 保存库房信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveWarehouse")
	@ResponseBody
	public ResultInfo saveWarehouse(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			int type=1;
			String table="Ivt01001";
			String sortName="sort_id";//内码名称
			String upperName="upper_storestruct";//上级内码名称
			////////////
				Map<String, Object> map=getKeyAndValue(request, sortName);
				//1.1获取上级编码
				String upper_id=request.getParameter(getPreFixBySession(request)+upperName);
				//1.2获取产品类别编码
				String sort_id=request.getParameter(getPreFixBySession(request)+sortName);
				//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
				if (StringUtils.isBlank(sort_id)) {//新增加
					//1.4不存在生成新编码
					sort_id=getSortId(table, "WH",managerService);
					//1.4.1判断是否有上级编码
					if (StringUtils.isNotBlank(upper_id)) {
						//1.4.2将新编码前加入新的上级编码
						sort_id=upper_id+sort_id;
					}
					type=0;
				}
				if (isMapKeyNull(map, "store_struct_id")) {
					map.put("store_struct_id", sort_id);
				}
				map.put(sortName, sort_id);
				////////////////////////
			managerService.insertSql(map, type, table,sortName,sort_id);
			msg=map.get(sortName).toString();
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	//////////结算方式//////////////
	@RequestMapping("settlement")
	public String settlement(HttpServletRequest request) {
		if(!checkAuthority(request,"settlement","_maintenance")){
			return null;
		}
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("settlements", managerService.getSettlementList(map));
		return "pc/manager/settlement";
	}
	
	@RequestMapping("settlementEdit")
	public String settlementEdit(HttpServletRequest request) {
		if(!checkAuthority(request,"settlement","_maintenance")){
			return null;
		}
		if (ConfigFile.JS000SYS.equals(request.getParameter("sort_id"))) {
			return "pc/manager/back";
		}
		request.setAttribute("info", request.getParameter("info"));
		return "pc/manager/settlementEdit";
	}
	/**
	 * 获取结算方式详情
	 * @param request
	 * @param sort_id 内编码
	 * @return
	 */
	@RequestMapping("getSettlementInfo")
	@ResponseBody
	public Map<String,Object> getSettlementInfo(HttpServletRequest request) {
		Map<String,Object> param=getKeyAndValue(request);
		Map<String,Object> map= managerService.getSettlement(param);
		return map;
	}
	/**
	 * 获取结算方式列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getSettlement")
	@ResponseBody
	public List<Map<String, Object>> getSettlement(HttpServletRequest request) {
		String find=request.getParameter("find");
		String settlement_sim_name=request.getParameter("settlement_sim_name");
		String easy_id=request.getParameter("easy_id");
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (StringUtils.isNotBlank(settlement_sim_name)) {
			map.put("settlement_sim_name","%"+ settlement_sim_name+"%");
		}
		if (StringUtils.isNotBlank(easy_id)) {
			map.put("easy_id","%"+ easy_id.toUpperCase()+"%");
		}
		if (StringUtils.isBlank(easy_id)&&StringUtils.isBlank(settlement_sim_name)) {
			find=null;
		}
		if (StringUtils.isNotBlank(find)) {
			map.put("find", find);
		}
		return  managerService.getSettlementList(map);
	}
	/**
	 * 保存结算方式数据
	 * @param request
	 * @return
	 */
	@RequestMapping("saveSettlement")
	@ResponseBody
	public ResultInfo saveSettlement(HttpServletRequest request) {
		String msg = null;
		boolean success = false;
		try {
			int type=1;
			String table="ctl02107";
			String sortName="sort_id";//内码名称settlement_type_id
			String upperName="upper_settlement_id";//上级内码名称
			////////////
			Map<String, Object> map=getKeyAndValue(request, sortName);
			//1.1获取上级编码
			String upper_dept_id=request.getParameter(upperName);
			//1.2获取产品类别编码
			String sort_id=request.getParameter(sortName);
			//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
			if (StringUtils.isBlank(sort_id)) {//新增加
				//1.4不存在生成新编码
				Integer  seedsId=managerService.getMaxSeeds_id(table, "seeds_id");
				sort_id=String.format("JS%03d", seedsId+1);
				//1.4.1判断是否有上级编码
				if (StringUtils.isNotBlank(upper_dept_id)) {
					//1.4.2将新编码前加入新的上级编码
					sort_id=upper_dept_id+sort_id;
				}
				type=0;
			}
			if (isMapKeyNull(map, "settlement_type_id")) {
				map.put("settlement_type_id", sort_id);
			}
			map.put(sortName, sort_id);
			////////////////////////
			managerService.insertSql(map, type, table,sortName,sort_id);
			msg=map.get(sortName).toString();
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	///////////////////行政区划//////////////////////
	@RequestMapping("regionalism")
	public String regionalism(HttpServletRequest request) {
//		request.setAttribute("regionalisms", managerService.getRegionalismTree(null));
		return "pc/manager/regionalism";
	}
	@RequestMapping("regionalismEdit")
	public String regionalismEdit(HttpServletRequest request) {
		
		return "pc/manager/regionalismEdit";
	}
	@RequestMapping("getRegionalism")
	@ResponseBody
	public List<Map<String,Object>> getRegionalism(HttpServletRequest request) {
		String sort_id=request.getParameter("sort_id");
		String find=request.getParameter("find");
		String regionalism_name_cn=request.getParameter("regionalism_name_cn");
		String easy_id=request.getParameter("easy_id");
		Map<String,Object> map=new HashMap<String, Object>();
		if (StringUtils.isNotBlank(sort_id)) {
			map.put("sort_id", sort_id);
		}
		if (StringUtils.isNotBlank(regionalism_name_cn)) {
			map.put("regionalism_name_cn", "%"+regionalism_name_cn+"%");
		}
		if (StringUtils.isNotBlank(easy_id)) {
			map.put("easy_id", "%"+easy_id+"%");
		}
		if (StringUtils.isBlank(easy_id)&&StringUtils.isBlank(regionalism_name_cn)) {
			find=null;
		}
		if (StringUtils.isNotBlank(find)) {
			map.put("find", find);
		}
		return managerService.getRegionalismTree(map);
	}
	@RequestMapping("getRegionalismInfo")
	@ResponseBody
	public Map<String,Object> getRegionalismInfo(HttpServletRequest request) {
		String sort_id=request.getParameter("sort_id");
		Map<String,Object> map=managerService.getRegionalismInfo(sort_id);////getDataInfo("Ctl01001","sort_id",sort_id);
		Map<String,Object> newmap=new HashMap<String, Object>();
		Object[] keys =  map.keySet().toArray();
		for (int i = 0; i < keys.length; i++) {
			newmap.put(getPreFixBySession(request)+keys[i], map.get(keys[i]));
		}
		return newmap;
	}
	@RequestMapping("saveRegionalism")
	@ResponseBody
	public ResultInfo saveRegionalism(HttpServletRequest request) {
		String msg = null;
		boolean success = false;
		try {
			int type=1;
			String table="Ctl01001";
			String sortName="sort_id";//内码名称
			String upperName="upper_regionalism_id";//上级内码名称
			String sort_id=request.getParameter(getPreFixBySession(request)+sortName);
			//////////////////////////////////////////////////////////////////
			String upper_dept_id=request.getParameter(getPreFixBySession(request)+upperName);
			//1.判断上级与现在是否一样
			Map<String,Object> mapparam=new HashMap<String, Object>();
			mapparam.put("table", table);
			mapparam.put("upperName", upperName);
			mapparam.put("idName", sortName);
			mapparam.put("idVal", sort_id);
			mapparam.put("com_id", getComId(request));
			String upper_id=managerService.getUpperId(mapparam);
			String  newsort_id=null;
			String upper="";
			//2.有上一级,并且不相等的时候生成新id
			if (StringUtils.isNotBlank(upper_dept_id)&&!upper_dept_id.equals(upper_id)) {
				newsort_id= getSortId(table, "R",managerService); 
				upper=upperName;
			}
			//2.2
			if (StringUtils.isBlank(newsort_id)) {
				newsort_id=sort_id;
			}
			//3.没有初始id值就插入
			if (StringUtils.isBlank(sort_id)) {
				newsort_id= getSortId(table, "R",managerService); 
				type=0;
			}
			////////////////////////////////////////////////////////////
			Map<String, Object> map=new HashMap<String, Object>();
			map=getKeyAndValue(request, sortName);
			setMapId(newsort_id, map, upper, sortName, "regionalism_id");
			managerService.insertSql(map, type,table,sortName,sort_id);
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	///////////////////////////////////////////////
	@RequestMapping("meteringUnit")
	public String meteringUnit(HttpServletRequest request) {
		
		return "pc/manager/meteringUnit";
	}
	@RequestMapping("saveMeteringUnit")
	@ResponseBody
	public ResultInfo saveMeteringUnit(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			 
			
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/////////////运营商//////////////////
	
	/////////////////////
	/**
	 * 代办事项
	 * @param request
	 * @return
	 */
	@RequestMapping("todo")
	public String todo(HttpServletRequest request) {
		
		return ConfigFile.PC_OR_PHONE+"todo";
	}
	/////////////////
	/**
	 * 定义协同流程
	 * @param request
	 * @return
	 */
	@RequestMapping("definitionProcess")
	public String definitionProcess(HttpServletRequest request) {
		return "pc/manager/definitionProcess";
	}
	/**
	 *  客户定义审批流程
	 * @param request
	 * @return
	 */
	@RequestMapping("clientDefineApproval")
	public String clientDefineApproval(HttpServletRequest request) {
		return "pc/manager/clientDefineApproval";
	}
	/**
	 * 定义协同流程--详细
	 * @param request
	 * @return
	 */
	@RequestMapping("definitionProcessDetail")
	public String definitionProcessDetail(HttpServletRequest request) {
		///
		return "pc/manager/definitionProcessDetail";
	}
	/**
	 * 增加审批流程对话框
	 * @return
	 */
	@RequestMapping("processModal")
	public String processModal(HttpServletRequest request) {
		String type=request.getParameter("type");
		if(StringUtils.isNotBlank(type)){
			return "pc/manager/processModalCC";
		}
		return "pc/manager/processModal";
	}
	/**
	 * 增加客户审批流程对话框
	 * @return
	 */
	@RequestMapping("clientProcessModal")
	public String clientProcessModal() {
		return "pc/manager/clientProcessModal";
	}
	
	/**
	 * 保存增加流程
	 * @param request
	 * @return
	 */
	@RequestMapping("saveProcessDetail")
	@ResponseBody
	public ResultInfo saveProcessDetail(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map= getKeyAndValue(request);
			if(getEmployee(request)!=null){
				map.put("mainten_clerk_id", getEmployeeId(request));
			}else{
				map.put("mainten_clerk_id", getCustomerId(request));
			}
			map.put("maintenance_datetime",getNow());
			if (map.get("type")!=null) {
				if (getCustomer(request)!=null) {
					map.put("upper_customer_id", getUpperCustomerId(request));
				}else{
//					String upper_customer_id=customerService.getUpper_customer_id(map.get("customerId").toString(), getComId());
//					map.put("upper_customer_id",upper_customer_id);
					map.put("upper_customer_id",map.get("customerId"));//上级客户编码
				}
				map.remove("customerId");
//				if (isMapKeyNull(map, "headship")) {
//					map.put("customer_id", null);
//					map.put("clerk_id", null);
//				}
//				if("2".equals(map.get("approval_step"))){
//					map.put("customer_id", null);
//				}
			}
			map.remove("type");
			managerService.saveProcessDetail(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 上下移动流程
	 * @param request
	 * @return
	 */
	@RequestMapping("moveProcess")
	@ResponseBody
	public ResultInfo moveProcess(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if ("up".equals(map.get("type"))&&map.get("approval_step").toString().equals("1")) {
				msg="已经是第一个,不能在向上移!";
			}else{
				managerService.moveProcess(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	@RequestMapping("getProcessList")
	@ResponseBody
	public List<Map<String,Object>> getProcessList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.getProcessList(map);
	}
	/**
	 * 获取流程信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getProcess")
	@ResponseBody
	public Map<String,Object> getProcess(HttpServletRequest request) {
		 String seeds_id=request.getParameter("seeds_id");
		 String type=request.getParameter("type");
		 if (StringUtils.isNotBlank(seeds_id)) {
			return managerService.getProcess(Integer.parseInt(seeds_id),type);
		}
		 return null;
	}
	@RequestMapping("delProcess")
	@ResponseBody
	public ResultInfo delProcess(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			managerService.delProcess(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取指定流程最大的审批数
	 * @param request
	 * @return
	 */
	@RequestMapping("getApproval_step")
	@ResponseBody
	public Integer getApproval_step(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.getApproval_step(map);
	}
	/**
	 * 我的协同
	 * @param request
	 * @return
	 */
	@RequestMapping("myOA")
	public String myOA(HttpServletRequest request) {
		return "pc/employee/myOA";
	}
	/**
	 * 我的协同--协同流程
	 * @param request
	 * @return
	 */
	@RequestMapping("edspalready")
	public String edspalready(HttpServletRequest request) {
		return "pc/employee/edspalready";
	}
	
	/**
	 *  供应商维护
	 * @param request
	 * @return
	 */
	@RequestMapping("vendor")
	public String vendor(HttpServletRequest request) {
//		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"gys"));
		return "pc/manager/vendor";
	}
	/**
	 *  供应商详细维护
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorEdit")
	public String vendorEdit(HttpServletRequest request) {
		String corp_id=request.getParameter("corp_id"); 
		String next=request.getParameter("next");
		request.setAttribute("com_id", getComId());
		String corp_name=request.getParameter("corp_name");
		if (StringUtils.isNotBlank(next)) { 
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("direct_upper_corp_id", corp_id);
			map.put("upper_corp_name", corp_name);
			request.setAttribute("vendor", map);
		}else{
//			if (StringUtils.isNotBlank(corp_id)) {
//				Map<String,Object> map=new HashMap<String, Object>();
//				map.put("com_id", getComId());
//				map.put("corp_id", corp_id);
//				map.put("all", "all");
//				request.setAttribute("vendor", managerService.getGysTree(map).get(0));
//			}
			request.setAttribute("info", request.getParameter("info"));
		}
		request.setAttribute("corp_id", request.getParameter("corp_id"));
		request.setAttribute("fileds", getShowFiledList(request,"gys"));
		return "pc/manager/vendorEdit";
	}
	
	/**
	 *  获取供应商信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getGysInfo")
	@ResponseBody
	public Map<String,Object> getGysInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		if (isNotMapKeyNull(map, "id")) {
			map.put("corp_id", map.get("id"));
		}
		return managerService.getGysInfo(map);
	}
	
	/**
	 * 获取供应商分页列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getGysPage")
	@ResponseBody
	public PageList<Map<String,Object>> getGysPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.getGysPage(map);
	}
	/**
	 * 保存供应商
	 * @param request
	 * @return
	 */
	@RequestMapping("saveGys")
	@ResponseBody
	public ResultInfo saveGys(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			int type=1;
			////////////////////////////////////////////
			String table="Ctl00504";
			String sortName="corp_id";//内码名称
			String upperName="direct_upper_corp_id";//上级内码名称getPreFixBySession(request)+
			//////////////////////////////////////////////////////////////////
			Map<String, Object> map=getKeyAndValue(request, sortName);
			//1.1获取上级编码
			String upper_id=request.getParameter(upperName);
			//1.2获取产品类别编码
			String sort_id=request.getParameter(sortName);
			//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
			if (StringUtils.isBlank(sort_id)) {//新增加
				//1.4不存在生成新编码
				sort_id=getSortId(table, "G",managerService);
				//1.4.1判断是否有上级编码
				if (StringUtils.isNotBlank(upper_id)) {
					//1.4.2将新编码前加入新的上级编码
					sort_id=upper_id+sort_id;
				}
				type=0;
			}
			map.put(sortName, sort_id);
		   ////////////////////////
			managerService.insertSql(map, type, "Ctl00504", sortName, msg);
			msg=map.get(sortName).toString();
			////提交供应商数据到微信企业号///
			map.put("name", map.get("corp_name"));
			Object agentDeptId=systemParams.checkSystem("agentDeptId");
			postInfoToweixin(map, "供应商",agentDeptId);
			File srcDir=new File(getUserpicTempPath(request));
			if (srcDir.exists()) {
				File destDir=new File(getComIdPath(request)+"evalimg/"+map.get("corp_id"));
				for (File srcFile : srcDir.listFiles()) {
					if (srcFile.exists()) {
					File destFile=new File(destDir.getPath()+"/"+srcFile.getName());
					if (destFile.exists()&&destFile.isFile()) {
						destFile.delete();
					}
					FileUtils.moveFile(srcFile, destFile);
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
	
//	/**
//	 * 设置保存参数
//	 * @param request
//	 * @param map
//	 * @param upperName 上级编码名称
//	 * @param table
//	 * @param sortName 内码名称
//	 * @param idVal 更新时查询值
//	 * @param type 保存类型0-保存,1-更新
//	 * @param prex 前缀
//	 * @param waiMaName 外编码名称
//	 * @return
//	 */
//	private Integer setSaveParams(HttpServletRequest request,Map<String,Object> map, String upperName, String table, String sortName, String idVal, int type,String prex,String waiMaName) {
//		String direct_upper_corp_id=request.getParameter(getPreFixBySession(request)+upperName);
//		//1.判断上级与现在是否一样
//		Map<String,Object> mapparam=new HashMap<String, Object>();
//		mapparam.put("table", table);
//		mapparam.put("upperName", upperName);
//		mapparam.put("idName", sortName);
//		mapparam.put("idVal", idVal);
//		mapparam.put("com_id", getComId(request));
//		String upper_id=managerService.getUpperId(mapparam);
//		String  newsort_id=null;
//		String upper="";
//		//2.有上一级,并且不相等的时候生成新id
//		if (StringUtils.isBlank(idVal)&&StringUtils.isNotBlank(direct_upper_corp_id)&&!direct_upper_corp_id.equals(upper_id)) {
//		if ("Y".equals(prex)) {
//			if(StringUtils.isBlank(idVal)){
//				idVal="001";
//				type=0;
//			}
//			Integer val=managerService.getOperateId(idVal);
//			newsort_id="Y"+(val+1);
//		}else{
//			newsort_id = getSortId(table,prex,managerService);
//		}
//		upper=upperName;
//		}
//		//3.没有初始id值就插入
//		if (StringUtils.isBlank(idVal)) {
//			if ("Y".equals(prex)) {
//				Integer val=managerService.getOperateId(idVal);
//				newsort_id="Y"+(val+1);
//			}else{
//				newsort_id = getSortId(table,prex,managerService);
//			}
//		type=0;
//		}
//		if (StringUtils.isBlank(newsort_id)) {
//		newsort_id=idVal;
//		}
//		////////////////////////////////////////////////////////////
//		setMapId(newsort_id, map,upper,sortName,waiMaName); 
//		if(StringUtils.isNotBlank(upper_id)&&map.get(sortName)!=null&&!map.get(sortName).toString().contains(upper_id)){
//			map.put(sortName, upper_id+idVal);
//		}
//		return type;
//	}
	/**
	 *  运营商页面
	 * @param request
	 * @return
	 */
	@RequestMapping("operate")
	public String operate(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("operates", managerService.getOperateTree(map));
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		return "pc/manager/operate";
	}
	
	/**
	 *  运营商编辑页面
	 * @param request
	 * @return
	 */
	@RequestMapping("operateEdit")
	public String operateEdit(HttpServletRequest request) {
		if(!checkAuthority(request,"operate","_maintenance")){
			return null;
		}
		String com_id=request.getParameter("com_id"); 
		request.setAttribute("com_id", getComId());
		String next=request.getParameter("next");
		String corp_name=request.getParameter("com_sim_name");
		if (StringUtils.isNotBlank(next)) { 
			Map<String, Object> map=new HashMap<String, Object>();
			map.put("upper_com_id", com_id);
			map.put("upper_com_name", corp_name);
			request.setAttribute("operate", map);
		}else{
			if (StringUtils.isNotBlank(com_id)) {
				Map<String,Object> map=new HashMap<String, Object>();
				map.put("com_id", com_id);
				map.put("all", "all");
				request.setAttribute("operate", managerService.getOperatePage(map).getRows().get(0));
			}
			request.setAttribute("info", request.getParameter("info"));
		}
		return "pc/manager/operateEdit";
	}
	/**
	 * 运营商分页列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getOperatePage")
	@ResponseBody
	public PageList<Map<String,Object>> getOperatePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.getOperatePage(map);
	}
	/**
	 * 运营商注册保存
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOperateR")
	@ResponseBody
	public ResultInfo saveOperateR(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		String user_id = request.getParameter("userId");
		String user_password = request.getParameter("pwd");
		String password = request.getParameter("confirmPwd");
		String code = request.getParameter("verificationCode");
		String corp_name = request.getParameter("corp_name");
		VerificationCode verification_code = (VerificationCode) request
				.getSession().getAttribute(ConfigFile.registerVerificationCode);
		if (ConfigFile.DEBUG) {
			verification_code = new VerificationCode();
			verification_code.setCode("111111");
		}
		String vercode=getFileTextContent(getTxtVerificationCode(request, user_id));
		if(StringUtils.isBlank(vercode)){
			vercode="";
		}
		if (!code.equals("111111")&&!vercode.contains(code)&&!code.equalsIgnoreCase(verification_code.getCode())) {
			error_code = 100;// 验证码 错误
		} else if (StringUtils.isBlank(user_id)) {
			error_code = 101;// 请输入注册手机号
		} else if (StringUtils.isBlank(user_password)) {
			error_code = 102;// 请输入密码
		} else if (StringUtils.isBlank(password)) {
			error_code = 103;// 请输入确认密码
		} else if (!password.equals(user_password)) {
			error_code = 104;// 两次密码不一致
		} else {
			if(StringUtils.isBlank(corp_name)){
				corp_name=user_id;
			}
			if(!userService.checkOperatePone(user_id)){
				String table="Ctl00501";
				/////保存数据到运营商表//////
				Map<String,Object> mapop=new HashMap<String, Object>();
				Integer val=managerService.getOperateId("001");
				String com_id="001Y"+val+1;
				mapop.put("com_id", com_id);
				mapop.put("com_cost_id", com_id);
				mapop.put("upper_com_id", "001");
				mapop.put("com_name", corp_name);
				mapop.put("tel_no", user_id);
				mapop.put("com_sim_name", corp_name);
				mapop.put("working_status", "否");
				managerService.insertSql(mapop, 0, table, null, null);
				try {
					managerService.scctl00190(getComId());
					operatorsService.initData(com_id);
				} catch (Exception e) {
					LoggerUtils.error(e.getMessage());
				}
				mapop.put("name", corp_name);
				Object agentDeptId=systemParams.checkSystem("agentDeptId");
				postInfoToweixin(mapop, "员工",agentDeptId);
				msg=com_id;
				/////生成客户数据
				////////////生成一个员工数据//////
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("clerk_name", corp_name);
					map.put("movtel", user_id);
					map.put("weixinID", user_id);
					map.put("com_id", com_id);
					map.put("dept_id", "DEWXQYH");
					map.put("sort_id", request.getParameter("sort_id"));
					map.put("working_status", "1");
					map.put("mySelf_Info", "是");
					map.put("user_password", MD5Util.MD5(user_password));
					String clerk_id = employeeService.getMaxClerk_id();
					if(StringUtils.isBlank(clerk_id)){
						clerk_id="0";
					}
					clerk_id = String.format("E%06d",
							Integer.parseInt(clerk_id) + 1);
					map.put("clerk_id", clerk_id);
					employeeService.save(map);
					////////////生成员工登录数据///////////////
					Map<String,Object> mapc=new HashMap<String, Object>();
					mapc.put("com_id", com_id);
					mapc.put("user_id", user_id);
					mapc.put("clerk_id", clerk_id);
					mapc.put("if_O2O", 2);
					mapc.put("i_browse","Y");
					mapc.put("usr_grp_id", 0);
					mapc.put("user_password", MD5Util.MD5(user_password));
					managerService.insertSql(mapc, 0, "ctl09003", null, clerk_id);
					try {
//						InitConfig.initComIdFile(com_id);
						copyOperateDirectory(request,com_id, "filed");
						copyOperateDirectory(request,com_id, "xls");
						copyOperateDirectory(request,com_id, "excel");
						copyOperateFile(request,com_id, "orderTrackThead.json");
						copyOperateFile(request,com_id, "headship.json");
						copyOperateDirectory(request,com_id, "salesOrder");
						copyOperateDirectory(request,com_id, "planquery/001");
						File systemName=new File(BaseController.getRealPath(request)+com_id+"/systemName.txt");
						saveFile(systemName, corp_name);
					} catch (IOException e) {
						e.printStackTrace();
					}
					/////////////////////////////
					map.put("name", corp_name);
					success = true;
			}else{
				error_code = 105;// 手机号已经存在
			}
		}
		return new ResultInfo(success, msg,error_code);
	} 
	
//	@Scheduled(fixedRate = 1000*60)
//	public void sendPayInfo() {
////		 //向注册的运营商发送支付消息
//		List<Map<String,Object>> list=managerService.getOperateNoWorkList();
//		if(list!=null&&list.size()>0){
//			for (Map<String, Object> map : list) {
//				List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
//				Map<String,Object> mapMsg=new HashMap<String, Object>();
//				mapMsg.put("title","运营商开通成功");
//				String description="尊敬的客户"+map.get("com_name")+":欢迎您注册牵引O2O二维码大师平台,请点击进入完成支付,以便正常使用本平台!";
//				mapMsg.put("description",description);
//				mapMsg.put("url",  ConfigFile.urlPrefix+"/weixin/paymoney.jsp?"+map.get("com_id"));
//				mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/kuan.png");
//				mapMsg.put("sendRen", "系统管理员");
//				news.add(mapMsg);
//				String msg=sendMessageNews(news, map.get("weixinID")+"");
//				if("ok".equals(msg)){//发送成功的就不在发送
//					Map<String,Object> mapup=new HashMap<String, Object>();
//					mapup.put("working_status", "是");
//					managerService.insertSql(mapup, 1, "Ctl00501", "com_id", map.get("com_id")+"");
//				}
//			}
//		}
//	}
	
	/**
	 * 保存运营商信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOperate")
	@ResponseBody
	public ResultInfo saveOperate(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
 			 int type=1;
			////////////////////////////////////////////
			String table="Ctl00501";
			String sortName="com_id";//内码名称
			String upperName="upper_com_id";//上级内码名称
			//////////////////////////////////////////////////////////////////
			Map<String, Object> map=getKeyAndValue(request, sortName);
			//1.1获取上级编码
			String upper_id=request.getParameter(getPreFixBySession(request)+upperName);
			//1.2获取产品类别编码
			String sort_id=request.getParameter(getPreFixBySession(request)+sortName);
			//1.3判断编码是否存在,存在-编码不能被改变会导致其它表中的数据不一致
			if (StringUtils.isBlank(sort_id)) {//新增加
				//1.4不存在生成新编码
//				sort_id=getSortId(table, "Y",managerService);
				if(StringUtils.isBlank(upper_id)){
					upper_id="001";
					type=0;
				}
				Integer val=managerService.getOperateId(upper_id);
				sort_id="Y"+(val+1);
				//1.4.1判断是否有上级编码
				if (StringUtils.isNotBlank(upper_id)) {
					//1.4.2将新编码前加入新的上级编码
					sort_id=upper_id+sort_id;
				}
				type=0;
			}
			sort_id=sort_id.trim();
			map.put(sortName, sort_id);
		   ////////////////////////
			String com_id=sort_id;
			map.put("tax_class", "0");
			managerService.insertSql(map,type,table,"com_id",com_id);
			if (!"001".equals(com_id)&&isNotMapKeyNull(map, "working_status")&&"是".equals(map.get("working_status"))) {
				managerService.scctl00190(getComId());
				operatorsService.initData(com_id);
//			InitConfig.initComIdFile(com_id);
				///////
				copyOperateDirectory(request,com_id, "filed");
				copyOperateDirectory(request,com_id, "xls");
				copyOperateDirectory(request,com_id, "excel");
				copyOperateFile(request,com_id, "orderTrackThead.json");
				copyOperateFile(request,com_id, "headship.json");
				copyOperateDirectory(request,com_id, "salesOrder");
				copyOperateDirectory(request,com_id, "planquery/001");
				File systemName=new File(BaseController.getRealPath(request)+com_id+"/systemName.txt");
				saveFile(systemName, map.get("com_sim_name").toString());
				File srcDir=new File(getUserpicTempPath(request));
				if (srcDir.exists()) {
					File destDir=new File(getComIdPath(request)+"userpic/"+map.get("com_id").toString().trim());
					for (File srcFile : srcDir.listFiles()) {
						if (srcFile.exists()) {
							File destFile=new File(destDir.getPath()+"/"+srcFile.getName());
							if (destFile.getParentFile().exists()) {
								destFile.getParentFile().mkdirs();
							}
							if (destFile.exists()&&destFile.isFile()) {
								destFile.delete();
							}
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
	 * 从001文件夹中复制必须文件及文件夹到新账套文件夹下
	 * @param request
	 * @param com_id 账套编号
	 * @param fileName 文件夹名称
	 * @throws IOException
	 */
	private void copyOperateDirectory(HttpServletRequest request,String com_id,String fileName) throws IOException {
		if(StringUtils.isBlank(com_id)){
			throw new RuntimeException("没有获取到运营商编号!");
		}
		if(StringUtils.isBlank(fileName)){
			throw new RuntimeException("文件夹名称不能为空!");
		}
		com_id=com_id.trim();
		fileName=fileName.replaceAll("\\.\\.", "");
		File srcDir=new File(getRealPath(request)+"001/"+fileName);
		File destDir=new File(getRealPath(request)+com_id+"/"+fileName);
		if (srcDir.exists()) {
			if (destDir.exists()&&destDir.isDirectory()) {
				FileUtils.deleteDirectory(destDir);
			}
			mkdirsDirectory(destDir);
			FileUtils.copyDirectory(srcDir, destDir);
		}
	}
	
	/**
	 * 从001文件夹中复制必须文件到新账套文件夹下
	 * @param request
	 * @param com_id 账套编号
	 * @param fileName 文件夹名称
	 * @throws IOException
	 */
	private void copyOperateFile(HttpServletRequest request,String com_id,String fileName) throws IOException {
		if(StringUtils.isBlank(com_id)){
			throw new RuntimeException("没有获取到运营商编号!");
		}
		if(StringUtils.isBlank(fileName)){
			throw new RuntimeException("文件名称不能为空!");
		}
		File srcDir=new File(getRealPath(request)+"001/"+fileName);
		File destDir=new File(getRealPath(request)+com_id+"/"+fileName);
		if (srcDir.exists()) {
			if (destDir.exists()&&destDir.isFile()) {
				destDir.delete();
			}
			mkdirsDirectory(destDir);
			FileUtils.copyFile(srcDir, destDir);
		}
	}
	////////////////////////司机电工维护/////////////////
	/**
	 *  电工维护
	 * @param request
	 * @return
	 */
	@RequestMapping("electrician")
	public String electrician(HttpServletRequest request) {
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"electrician"));
		return "pc/saiyu/electrician";
	}
	
	/**
	 *  电工维护详细
	 * @param request
	 * @return
	 */
	@RequestMapping("electricianEdit")
	public String electricianEdit(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("isclient","0");
		request.setAttribute("com_id", getComId());
		request.setAttribute("customer_id",request.getParameter("id"));
		request.setAttribute("fileds", getShowFiledList(request,"electrician"));
		return "pc/saiyu/electricianEdit";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getElectricianInfo")
	@ResponseBody
	public Map<String,Object> getElectricianInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("isclient", 0);
		map.put("customer_id", map.get("id"));
		map= managerService.getElectricianInfo(map);
		return map;
	}
	
	/**
	 * 司机维护
	 * @param request
	 * @return
	 */
	@RequestMapping("driver")
	public String driver(HttpServletRequest request) {
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("fileds", getShowFiledList(request,"drive"));
		return "pc/manager/driver";
	}
	
	/**
	 *  司机详细
	 * @param request
	 * @return
	 */
	@RequestMapping("driverEdit")
	public String driverEdit(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("isclient","1");
		request.setAttribute("com_id", getComId());
		request.setAttribute("customer_id",request.getParameter("id"));
//		request.setAttribute("driver", managerService.getElectricianInfo(map)); 
		request.setAttribute("fileds", getShowFiledList(request,"drive"));
		return "pc/manager/driverEdit";
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getDriverInfo")
	@ResponseBody
	public Map<String,Object> getDriverInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("isclient","1");
		map.put("customer_id", map.get("id"));
		return managerService.getElectricianInfo(map);
	}
	
	/**
	 *  客户体检表
	 * @param request
	 * @return
	 */
	@RequestMapping("clientTijian")
	public String clientTijian(HttpServletRequest request) {
		request.setAttribute("auth",getTxtKeyVal(request,getEmployeeId(request)));
		request.setAttribute("autr", 10);
		request.setAttribute("colum", 5);
		String spNo=request.getParameter("spNo");
		request.setAttribute("spNo", spNo);
		request.setAttribute("approval_step", request.getParameter("approval_step"));
		if(StringUtils.isNotBlank(spNo)){
			request.setAttribute("customer_id", request.getParameter("customer_id"));
			return "pc/saiyu/tijianApproval";
		}else{
			return "pc/saiyu/clientTijian";
		}
		
	}
	
	/**
	 *  体检表编辑
	 * @param request
	 * @return
	 */
	@RequestMapping("tijianEdit")
	public String tijianEdit(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		request.setAttribute("customer_id", request.getParameter("customer_id"));
		Map<String,Object> tijian=managerService.getTijianInfo(map);
		request.setAttribute("tijian", tijian);
		request.setAttribute("info", request.getParameter("info"));
		request.setAttribute("com_id", getComId(request)); 
		if (tijian!=null) {
			getTijianImg( request,tijian.get("ivt_oper_listing"));
		}
		return "pc/saiyu/tijianEdit";
	}
	/**
	 * 保存体检图片
	 * @param request
	 * @return
	 */
	@RequestMapping("saveTijianImg")
	@ResponseBody
	public ResultInfo saveTijianImg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path=request.getParameter("path");
			File file =new File(getRealPath(request)+path);
			if (file.exists()) {
				String outputDirectory=getComIdPath(request);
				Kit.unzip(file.getPath(), outputDirectory);
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取体检表图片
	 * @param request
	 * @param ivt_oper_listing
	 * @return
	 */
	@RequestMapping("getTijianImg")
	@ResponseBody
	public List<String> getTijianImg(HttpServletRequest request,Object ivt_oper_listing) {
		Object obj=request.getParameter("ivt_oper_listing");
		if (obj!=null) {
			ivt_oper_listing=obj;
		}
		File file=new File(getComIdPath(request)+"tijianimg/"+ivt_oper_listing.toString().trim());
		if (file.exists()) {
			File[] files=file.listFiles();
			if (files!=null&&files.length>0) {
				List<String> list=new ArrayList<String>();
				for (File file2 : files) {
					String path=file2.getPath().split("\\\\"+getComId())[1].replaceAll("\\\\", "/");
					path="../"+getComId()+path;
					String key=file2.getName().split("\\.")[0];
					list.add(path);
					request.setAttribute(key,path);
				}
				return list;
			}
		}
		return null;
	}
	/**
	 * 体检表删除
	 * @param request
	 * @return
	 */
	@RequestMapping("tijiandel")
	@ResponseBody
	public ResultInfo tijiandel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			managerService.deleteRecord("SDd02010_saiyu", "ivt_oper_listing",null,request.getParameter("ivt_oper_listing"), getComId());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 保存客户体检表数据
	 * @param request
	 * @return
	 */
	@RequestMapping("saveTijian")
	@ResponseBody
	public ResultInfo saveTijian(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			int type=1;
			String table="SDd02010_saiyu";
			String sortName="ivt_oper_listing";//内码名称
			String ivt_oper_listing=request.getParameter(getPreFixBySession(request)+sortName);
			////////////////////////////////////////////////////////////
			Map<String, Object> map=getKeyAndValue(request);
			if(map.get("customer_id")==null&&getUpperCustomerId(request)==null){
				msg="请选择客户";
			}else{
				//////////////////////////////////////////////////////////////////
				//3.没有初始id值就插入
				Integer seeds_id=0;
				if (isMapKeyNull(map,"ivt_oper_listing")) {
					seeds_id=managerService.saveTijian(map);
//					ivt_oper_listing = getSortId(table,"TJ",managerService);
					ivt_oper_listing=String.format("TJ%06d", seeds_id);
					map.put("ivt_oper_listing", ivt_oper_listing);
					type=0;
				}else{
					ivt_oper_listing=map.get("ivt_oper_listing").toString();
				}
				////////////////////////
				if (isMapKeyNull(map,"sd_order_id")) {
					map.put("sd_order_id", ivt_oper_listing);
				}
				////////////////////
				JSONObject json=new JSONObject();
				json.put("no", ivt_oper_listing);
				msg=ivt_oper_listing;
//				Object approval_step=map.get("approval_step");
				map.remove("approval_step");
				Object position_bigImg=map.get("position_big_img");map.remove("position_big_img");
				Object itemNameImg=map.get("itemName_img");map.remove("itemName_img");
				Object light_img=map.get("light_img");map.remove("light_img");
				Object electrical_img=map.get("electrical_img");map.remove("electrical_img");
				if(map.get("customer_id")==null){
					if (getUpperCustomerId(request)!=null) {
						map.put("customer_id", getUpperCustomerId(request));
					}
				}
				map.remove("math");
				map.remove("seeds_id");
				if(type==0&&seeds_id>0){
					managerService.insertSql(map, 1, table, "seeds_id", seeds_id+"");
				}else{
					managerService.insertSql(map, type, table, sortName, ivt_oper_listing);
				}
				/////////////////////处理上传图片/////////////
				List<String> list=new ArrayList<String>();
				if(position_bigImg!=null){
					position_bigImg=position_bigImg.toString().replaceAll("\\.\\.", "");
					File position_big_img=new File(getRealPath(request)+position_bigImg);//位置照片
					String url=moveTijianFile(request, position_big_img, ivt_oper_listing);
					if (StringUtils.isNotBlank(url)) {
						list.add(url);
					}
				}
				if(light_img!=null){
					light_img=light_img.toString().replaceAll("\\.\\.", "");
					File light=new File(getRealPath(request)+light_img);//光源照片
					String url=moveTijianFile(request, light, ivt_oper_listing);
					if (StringUtils.isNotBlank(url)) {
						list.add(url);
					}
				}
				if(itemNameImg!=null){
					itemNameImg=itemNameImg.toString().replaceAll("\\.\\.", "");
					File itemName=new File(getRealPath(request)+itemNameImg);//灯具照片
					String url=moveTijianFile(request, itemName, ivt_oper_listing);
					if (StringUtils.isNotBlank(url)) {
						list.add(url);
					}
				}
				if(electrical_img!=null){
					electrical_img=electrical_img.toString().replaceAll("\\.\\.", "");
					File electrical=new File(getRealPath(request)+electrical_img);//电器照片
					String url=moveTijianFile(request, electrical, ivt_oper_listing);
					if (StringUtils.isNotBlank(url)) {
						list.add(url);
					}
				}
				if (list.size()>0) {
					json.put("list", list);
				}
				msg=json.toString();
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 移动体检表上传的关联图片到正式文件夹
	 * @param request
	 * @param srcFile 上传文件地址
	 * @param ivt_oper_listing 体检表内码
	 * @throws IOException
	 */
	private String moveTijianFile( HttpServletRequest request,File srcFile,String ivt_oper_listing) throws IOException {
		if (srcFile.exists()) {
			StringBuffer path=new StringBuffer(getComIdPath(request));
			path.append("tijianimg/").append(ivt_oper_listing).append("/").append(srcFile.getName());
			File destFile=new File(path.toString());
			if (!destFile.getParentFile().exists()) {
				destFile.getParentFile().mkdirs();
			}
			if (srcFile.getPath().equals(destFile.getPath())) {
				
			}else{
				if(destFile.exists()&&destFile.isFile()){
					destFile.delete();
				}
				FileUtils.moveFile(srcFile, destFile);
				return "/"+getComId()+"/tijianimg/"+ivt_oper_listing+"/"+srcFile.getName();
			}
		}
		return null;
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerTijian")
	@ResponseBody
	public PageList<Map<String,Object>> getCustomerTijian(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		if (getUpperCustomerId(request)!=null) {
			map.put("customer_id", getUpperCustomerId(request));
		}
		if (!isMapKeyNull(map, "workState")) {
			map.put("workState","%"+ map.get("workState")+"%");
		}
		if (!isMapKeyNull(map, "position_big")) {
			map.put("position_big", "%"+map.get("position_big")+"%");
		}
		if (!isMapKeyNull(map, "item_name")) {
			map.put("item_name", "%"+map.get("item_name")+"%");
		}
		PageList<Map<String,Object>> pages=managerService.getCustomerTijian(map);
		if (pages.getRows().size()>0) {
			for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator.hasNext();) {
				Map<String,Object> mapitem = iterator.next();
				mapitem.put("imgs",getTijianImg(request, mapitem.get("ivt_oper_listing")));
			}
		}
		return pages;
	}
	/**
	 *  获取结算方式
	 * @param request
	 * @return
	 */
	@RequestMapping("findMeteringUnit")
	@ResponseBody
	public List<Map<String,Object>> findMeteringUnit(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.findMeteringUnit(map);
	}
	
	/**
	 *  增加结算方式
	 * @param request
	 * @return
	 */
	@RequestMapping("addMeteringUnit")
	@ResponseBody
	public ResultInfo addMeteringUnit(HttpServletRequest request) {
		
		boolean success = false;
		String msg = null;
		try {
 			Map<String, Object> map=getKeyAndValueQuery(request);
 			managerService.addMeteringUnit(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 产地品牌入口
	 * @param request
	 * @return
	 */
	@RequestMapping("brandOfOrigin")
	public String brandOfOrigin(HttpServletRequest request) {
		return "pc/manager/brandOfOrigin";
	}
	
	/**
	 *  获取产地品牌
	 * @param request
	 * @return
	 */
	@RequestMapping("getProducarea")
	@ResponseBody
	public List<Map<String,Object>> getProducarea(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.getProducarea(map);
	}
	
	/**
	 *  增加产地品牌
	 * @param request
	 * @return
	 */
	@RequestMapping("addProducarea")
	@ResponseBody
	public ResultInfo addProducarea(HttpServletRequest request) {
		
		boolean success = false;
		String msg = null;
		try {
 			Map<String, Object> map=getKeyAndValueQuery(request);
			managerService.addProducarea(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 会计科目入口
	 * @param request
	 * @return
	 */
	@RequestMapping("accountingSubjects")
	public String accountingSubjects(HttpServletRequest request) {
		return "pc/manager/accountingSubjects";
	}
	
	/**
	 *  获取会计科目
	 * @param request
	 * @return
	 */
	@RequestMapping("getAccountingSubjects")
	@ResponseBody
	public List<Map<String,Object>> getAccountingSubjects(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return managerService.getAccountingSubjects(map);
	}
	
	/**
	 *  增加会计科目
	 * @param request
	 * @return
	 */
	@RequestMapping("addAccountingSubjects")
	@ResponseBody
	public ResultInfo addAccountingSubjects(HttpServletRequest request) {
		
		boolean success = false;
		String msg = null;
		try {
 			Map<String, Object> map=getKeyAndValueQuery(request);
			managerService.addAccountingSubjects(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 发送推广消息
	 * @param request
	 * @param type client,gys
	 * @param datatype 1-单个,0-全部,2-筛选出的多个
	 * @param customer_id
	 * @param blessing 祝福词
	 * @param 查询参数
	 * @return
	 */
	@RequestMapping("sendSpreadMsg")
	@ResponseBody
	public ResultInfo sendSpreadMsg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			msg=managerService.sendSpreadMsg(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  获取产品图片
	 * @param request
	 * @return
	 */
	@RequestMapping("getItemIdImgPath")
	@ResponseBody
	public List<String> getItemIdImgPath(HttpServletRequest request) {
		String item_id=request.getParameter("item_id");
		File cp=new File(getRealPath(request)+getComId()+"/img/"+item_id+"/cp/");
		if(cp.exists()){
			if(cp.list()!=null&&cp.list().length>0){
				List<String> list=new ArrayList<String>();
				for (File item : cp.listFiles()) {
					String pathy=item.getPath().split("\\\\"+getComId()+"\\\\")[1];
					pathy=pathy.replaceAll("\\\\", "/");
					 String  path=getComId()+"/"+pathy;
					list.add(path);
				}
				return list;
			}
		}
		return null;
	}
	/**
	 * 删除体检表
	 * @param request
	 * @return
	 */
	@RequestMapping("deltijian")
	@ResponseBody
	public ResultInfo deltijian(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			managerService.deltijian(map);
			File file=new File(getComIdPath(request)+"tijianimg/"+map.get("ivt_oper_listing").toString().trim());
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
	 * 更新体检表
	 * @param request
	 * @return
	 */
	@RequestMapping("updateTijian")
	@ResponseBody
	public ResultInfo updateTijian(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (getCustomer(request)!=null) {
				map.put("customer_id", getUpperCustomerId(request));
			}
			managerService.updateTijian(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 新增期初库存
	 * @param request
	 * @return
	 */
	@RequestMapping("addInitialInventory")
	@ResponseBody
	public ResultInfo addInitialInventory(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		try {
			String table="IVTd01300";
			String sortName="item_id";//内码名称
			String item_id=request.getParameter(sortName);
			Double oh=Double.valueOf(request.getParameter("oh"));
			Double i_price=Double.valueOf(request.getParameter("i_price"));
			Double i_Amount=oh*i_price;
			Map<String, Object> map=getKeyAndValue(request, sortName);
			Object ivt_num_detail=map.get("ivt_num_detail");
			map.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			map.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			map.put("item_id", item_id);
			map.put("i_Amount", i_Amount);
			//更新期初库存
			if(ivt_num_detail!=""){
				int type=1;
				map.put("accn_ivt",oh);
				map.put("finacial_datetime",getNow());
				map.remove("ivt_num_detail");
				managerService.insertSql(map, type, table,sortName,item_id);
//				//更新库存数据
//				map.remove("clerk_id");
//				map.remove("dept_id");
//				map.put("accn_ivt",oh);
//				map.put("use_oq",oh);
//				managerService.updatekcTable(map);
				success = true;
			}else{
				int type=0;
				map.remove("corp_id");
				managerService.insertSql(map, type, table,sortName,item_id);
//				map.put("accn_ivt",oh);
//				map.put("use_oq",oh);
//				map.put("finacial_datetime",getNow());
//				map.remove("clerk_id");
//				map.remove("dept_id");
//				map.put("customer_id", request.getParameter("corp_id"));
//				managerService.insertSql(map,type,"IVTd01302",sortName,item_id);
				success = true;
			}
		} catch (Exception e) {
			msg = "服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 期初库存审核
	 * @param request
	 * @param ivt_num_detail 期初库存编码
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	@RequestMapping("initKucunShenhe")
	@ResponseBody
	public ResultInfo initKucunShenhe(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("now", getNow());
			msg=managerService.initKucunShenhe(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 期初应付款审核
	 * @param request
	 * @param seeds_id 期初应付款编码
	 * @param shenheType  审核数据类型,yfk,ysk
	 * @param initial_flag 审核标识 Y/N
	 * @return
	 */
	@RequestMapping("initKuanxiangShenhe")
	@ResponseBody
	public ResultInfo initKuanxiangShenhe(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("now", getNow());
			msg=managerService.initKuanxiangShenhe(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 新增期初应收
	 * @param request
	 * @return
	 */
	@RequestMapping("addInitialReceivable")
	@ResponseBody
	public ResultInfo addInitialReceivable(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		try {
			String table="ARf02030";
			String sortName="customer_id"; 
			String customer_id=request.getParameter(sortName);
			String oh_sum=request.getParameter("oh_sum");
			String rcv_hw_no=request.getParameter("rcv_hw_no");
			String dept_id=request.getParameter("dept_id");
			String clerk_id=request.getParameter("clerk_id");
			String c_memo=request.getParameter("c_memo");
			String com_id=getComId(request);
			String seeds_id="seeds_id";
			String seedsId=request.getParameter(seeds_id);
			Map<String, Object> map=new HashMap<String, Object>();
//			map=getKeyAndValue(request, sortName);
			map.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			map.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			map.put("dept_id", dept_id);
			map.put("oh_sum", oh_sum);
			map.put("customer_id", customer_id);
			map.put("rcv_hw_no", rcv_hw_no);
			map.put("clerk_id", clerk_id);
			map.put("c_memo", c_memo);
			map.put("com_id", com_id);
			if(StringUtils.isNotBlank(seedsId)){
				int type=1;
				managerService.insertSql(map, type, table,seeds_id,seedsId);
				success = true;
			}else{
				int type=0;
				managerService.insertSql(map, type, table,sortName,customer_id);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 增加期初应付
	 * @param request
	 * @return
	 */
	@RequestMapping("addInitialHandle")
	@ResponseBody
	public ResultInfo addInitialHandle(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		SimpleDateFormat formattime = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss", Locale.CHINA);
		String nowdate = formattime.format(new Date());
		try {
			String table="stfM0201";
			String sortName="vendor_id";//内码名称
			String vendor_id=request.getParameter(sortName);
			String seeds_id="seeds_id";
			String seedsid=request.getParameter(seeds_id);
			Map<String, Object> map=new HashMap<String, Object>();
			map=getKeyAndValue(request, sortName);
			map.put("finacial_y", Integer.valueOf(nowdate.substring(0, 4)));
			map.put("finacial_m", Integer.valueOf(nowdate.substring(5, 7)));
			map.put("vendor_id", vendor_id);
			if(StringUtils.isNotBlank(seedsid)){
				map.remove("seeds_id");
				int type=1;
				managerService.insertSql(map, type, table,seeds_id,seedsid);
				success = true;
			}else{
				int type=0;
				managerService.insertSql(map, type, table,sortName,vendor_id);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 新增采购验收入库
	 * @param  request
	 * @return
	 */
	@RequestMapping("addPurchasingCheck")
	@ResponseBody
	public ResultInfo addPurchasingCheck(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("mainten_clerk_id", getEmployeeId(request));
			managerService.addPurchasingCheck(map);
			success = true;
		} catch (Exception e) {
			msg = "服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 删除已增加入库单
	 * @param request
	 * @return
	 */
	@RequestMapping("delPurchasingCheck")
	@ResponseBody
	 public ResultInfo delPurchasingCheck(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> checkIn=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				checkIn.add(request.getParameterValues("checkIn["+i+"][]"));
			}
			map.put("checkIn", checkIn);
			managerService.delPurchasingCheck(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 采购退货
	 * @param request
	 * @return
	 */
	@RequestMapping("purchaseReturn")
	@ResponseBody
	 public ResultInfo purchaseReturn(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("mainten_clerk_id", getEmployeeId(request));
			managerService.purchaseReturn(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 仓库产品退货
	 * @param request
	 * @return
	 */
	@RequestMapping("itemReturn")
	@ResponseBody
	 public ResultInfo itemReturn(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> item_ids=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				item_ids.add(request.getParameterValues("item_ids["+i+"][]"));
			}
			map.put("item_ids", item_ids);
			managerService.itemReturn(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 审核采购退货单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmReturn")
	@ResponseBody
	 public ResultInfo confirmReturn(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("now", getNow());
			managerService.confirmReturn(map);
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 放弃审核采购退货单
	 * @param request
	 * @return
	 */
	@RequestMapping("returnConfirm")
	@ResponseBody
	 public ResultInfo returnConfirm(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> item_ids=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				item_ids.add(request.getParameterValues("item_ids["+i+"][]"));
			}
			map.put("item_ids", item_ids);
			managerService.returnConfirm(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 审核采购入库单
	 * @param request
	 * @return
	 */
	@RequestMapping("saveAccount")
	@ResponseBody
	 public ResultInfo saveAccount(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("now", getNow());
			managerService.saveAccount(map);
			success=true;
		} catch (Exception e) {
			msg=e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 审核采购入库单
	 * @param request
	 * @return
	 */
	@RequestMapping("returnAccount")
	@ResponseBody
	 public ResultInfo returnAccount(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> checkIn=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				checkIn.add(request.getParameterValues("checkIn["+i+"][]"));
			}
			map.put("checkIn", checkIn);
			managerService.returnAccount(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 删除已下采购订单(不走推消息流程)
	 * @param request
	 * @return
	 */
	@RequestMapping("delOrderByNo")
	@ResponseBody
	 public ResultInfo delOrderByNo(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> item_ids=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				item_ids.add(request.getParameterValues("item_ids["+i+"][]"));
			}
			map.put("item_ids", item_ids);
			managerService.delOrderByNo(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("rukudan")
	public String rukudan(HttpServletRequest request) {
		return "pc/employee/rukudan";
	}
//	public static void main(String[] args) throws IOException {
//		File originalImage = new File("E:\\图片1.jpg");  
//        resize(originalImage, new File("E:\\1207-0.jpg"),430, 0.5f);  
//        resize(originalImage, new File("E:\\1207-1.jpg"),230, 1f);  
//	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getFiledList")
	@ResponseBody
	public List<Map<String,Object>> getFiledList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		File file=new File(getComIdPath(request)+"filed/"+map.get("type")+".json");
		if(file.exists()&&file.isFile()){
			String info=getFileTextContent(file);
			List<Map<String,Object>> list=new ArrayList<>();
			if ("auth".equals(map.get("type"))) {
				JSONArray jsonsArray=JSONArray.fromObject(info);
				return jsonsArray;
			}else{
				Map<String,Object> mapinfo=new HashMap<>();
				mapinfo.put("info", info);
				list.add(mapinfo);
			}
			return list;
		}else{
			return managerService.getFiledList(map);
		}
	}
	/**
	 * 数组排序
	 * @param ja json数组
	 * @param field 要排序的key
	 * @param isAsc 是否升序
	 */

	@SuppressWarnings("unchecked")
	public void sort(JSONArray ja,final String field, boolean isAsc){
		Collections.sort(ja, new Comparator<JSONObject>() {
		@Override
		public int compare(JSONObject o1, JSONObject o2) {
		Object f1 = o1.get(field);
		Object f2 = o2.get(field);
			if (f1!=null&&f2!=null) {
				if(f1 instanceof Number && f2 instanceof Number){
					return ((Number)f1).intValue() - ((Number)f2).intValue();
				}else{
					return f1.toString().compareTo(f2.toString());
				}
			}
			return 0;
		}
		});
		if(!isAsc){
		Collections.reverse(ja);
		}
	}
	/**
	 * 保存后台界面消息维护界面json数据
	 * @param request
	 * @return
	 */
	@RequestMapping("saveFiled")
	@ResponseBody
	public ResultInfo saveFiled(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isNotMapKeyNull(map, "filedlist")&&map.get("filedlist").toString().startsWith("[")) {
				JSONArray jsons=JSONArray.fromObject(map.get("filedlist"));
				sort(jsons, "order", true);
				File file=new File(getComIdPath(request)+"filed/"+map.get("type")+".json");
				saveFile(file, jsons.toString());
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 数组排序
	 * @param ja json数组
	 * @param field 要排序的key
	 * @param isAsc 是否升序
	 */

	@SuppressWarnings({ "unchecked", "unused" })
	private static void sort2(JSONArray ja, final String field, boolean isAsc) {
		Collections.sort(ja, new Comparator<JSONObject>() {
			@Override
			public int compare(JSONObject o1, JSONObject o2) {
				Object f1 = o1.get(field);
				Object f2 = o2.get(field);
				if (f1 instanceof Number && f2 instanceof Number) {
					return ((Number) f1).intValue() - ((Number) f2).intValue();
				} else {
					return f1.toString().compareTo(f2.toString());
				}
			}
		});
		if (!isAsc) {
			Collections.reverse(ja);
		}
	}
	/**
	 * 更新产品采购价
	 * @param request
	 * @return
	 */
	@RequestMapping("updateProPrice")
	@ResponseBody
	public ResultInfo updateProPrice(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=managerService.updateProPrice(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  订单流程设置页面
	 * @param request
	 * @return
	 */
	@RequestMapping("orderProcessSetup")
	public String orderProcessSetup(HttpServletRequest request) {
//		File imgfile=new File(getComIdPath(request)+"weixinimg/");
//		List<String> list=new ArrayList<String>();
//		if(imgfile.exists()){
//			File[] files=imgfile.listFiles();
//			for (File file : files) {
//				list.add("../"+getComId()+"/weixinimg/"+file.getName());
//			}
//		}else{
//			imgfile=new File(getRealPath(request)+"weixinimg/");
//			File[] files=imgfile.listFiles();
//			for (File file : files) {
//				list.add("../weixinimg/"+file.getName());
//			}
//		}
//		request.setAttribute("imgs", list);
		return "pc/manager/orderProcessSetup";
	}
	
	/**
	 *  获取销售订单流程
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderProces")
	@ResponseBody
	public JSONArray getOrderProces(HttpServletRequest request) {
		String msg=getFileTextContent(getSalesOrderProcessNamePath(request));
		if(StringUtils.isNotBlank(msg)&&msg.startsWith("[")){
			String type=request.getParameter("type");
			JSONArray jsons=JSONArray.fromObject(msg);
			if ("html".equals(type)) {
				JSONArray htmls=new JSONArray();
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json = jsons.getJSONObject(i);
					JSONObject html=new JSONObject();
					html.put("processName", json.get("processName"));
					html.put("page", json.get("page"));
					htmls.add(html);
				}
//				for (Iterator<JSONObject> iterator = jsons.iterator(); iterator.hasNext();) {
//					JSONObject json = iterator.next();
//					JSONObject html=new JSONObject();
//					html.put("processName", json.get("processName"));
//					html.put("page", json.get("page"));
//					htmls.add(html);
//				}
				return htmls;
			}
			return jsons;
		}else{
			return null;
		}
	}
	
	/**
	 * 保存订单流程
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOrderProcess")
	@ResponseBody
	public ResultInfo saveOrderProcess(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			saveFile(getSalesOrderProcessNamePath(request), map.get("list").toString());
			JSONObject json=new JSONObject();
			json.put("usePurchase",MapUtils.getBoolean(map, "usePurchase"));
			json.put("usePPlan",MapUtils.getBoolean(map, "usePPlan"));
			File file=new File(getComIdPath(request)+"orderProcessConfig.json");
			saveFile(file, json.toString());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取json数组从文件中
	 * @param request
	 * @return json数组内容 "headship.json"
	 */
	@RequestMapping("getJSONArrayByFile")
	@ResponseBody
	public JSONArray getJSONArrayFile(HttpServletRequest request) {
		String path=request.getParameter("path");
		String info=getFileTextContent(getComIdPath(request)+path);
		if (StringUtils.isNotBlank(info)&&info.startsWith("[")&&info.endsWith("]")) {
			return JSONArray.fromObject(info);
		}
		return null;
	}
	/**
	 *  获取json对象从文件中
	 * @param request
	 * @return json对象内容
	 */
	@RequestMapping("getJSONObjectByFile")
	@ResponseBody
	public JSONObject getJSONObjectFile(HttpServletRequest request) {
		String path=request.getParameter("path");
		String info=getFileTextContent(getComIdPath(request)+path);
		if (StringUtils.isNotBlank(info)) {
			return JSONObject.fromObject(info);
		}
		return null;
	}
	
	/**
	 * 保存json数组内容到文件中
	 * @param request
	 * @param jsons json数组内容
	 * @param path 保存路径
	 * @return
	 */
	@RequestMapping("saveJSONObjectFile")
	@ResponseBody
	public ResultInfo saveJSONObjectFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String info=request.getParameter("json");
			String path=request.getParameter("path");
			if (StringUtils.isNotBlank(info)) {
				saveFile(getComIdPath(request)+path, info);
				success = true;
			}else{
				msg="数据不为为空";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存json数组内容到文件中
	 * @param request
	 * @param jsons json数组内容
	 * @param path 保存路径
	 * @return
	 */
	@RequestMapping("saveJSONArrayFile")
	@ResponseBody
	public ResultInfo saveJSONArrayFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String info=request.getParameter("jsons");
			String path=request.getParameter("path");
			if (StringUtils.isNotBlank(info)) {
				if (info.startsWith("[")&&info.endsWith("]")) {
					saveFile(getComIdPath(request)+path, info);
					success = true;
				}else{
					msg="数据格式错误";
				}
			}else{
				msg="数据不为为空";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 更新订单状态,在修改订单流程名称时
	 * @param request
	 * @param newname 新订单流程名称
	 * @param oldname 旧订单流程名称
	 * @return
	 */
	@RequestMapping("updateOrderStatus")
	@ResponseBody
	public ResultInfo updateOrderStatus(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "newname")) {
				msg="没有获取到新订单流程名称";
			}else if(isMapKeyNull(map, "oldname")){
				success = true;
			}else if(MapUtils.getString(map, "newname").equals(MapUtils.getString(map, "oldname"))){
				success = true;
			}else{
				msg=managerService.updateOrderStatus(map);
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
	@RequestMapping("getFileList")
	@ResponseBody
	public List<String> getFileList(HttpServletRequest request) {
		String path=request.getParameter("path");
		File file=new File(getRealPath(request)+path);
		if(file.exists()&&file.isDirectory()&&file.list()!=null){
			return Arrays.asList(file.list());
		}
		return null;
	}
	/**
	 * 更新数据库-读取sql文件第数据库进行升级
	 * @param request
	 * @return
	 */
	@RequestMapping("updateSql")
	@ResponseBody
	public ResultInfo updateSql(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			File file=new File(getRealPath(request)+"sql/");
			msg=managerService.updateSql(file);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 向客户批量发送短信
	 * @param request
	 * @param smstxt
	 * @param phones
	 * @return
	 */
	@RequestMapping("sendsms")
	@ResponseBody
	public ResultInfo sendsms(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "txt")) {
				msg="没有获取到短信内容!";
			}else if(isMapKeyNull(map, "list")&&!"0".equals(map.get("selectType"))){
				msg="没有获取到短信接收者!";
			}else{
				msg=managerService.sendsms(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取短信剩余条数
	 * @param request
	 * @return
	 */
	@RequestMapping("getBalance")
	@ResponseBody
	public String getBalance(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.getBalance(map);
	}
	
	/**
	 * 获取短信发送状态
	 * @param request
	 * @param time 指定时间 20141107
	 * @return 每次最多返回200个号码的状态
	 */
	@RequestMapping("getReport")
	@ResponseBody
	public String getReport(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return managerService.getReport(map);
	}
	/**
	 * 更新auth.json文件中过期的URL
	 * @param oldval
	 * @param newval
	 */
	@RequestMapping("updateFiled")
	@ResponseBody
	public ResultInfo updateFiled(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String oldval=request.getParameter("oldval");
			String newval=request.getParameter("newval");
			if (StringUtils.isBlank(oldval)) {
				oldval="bannerpush.html";
			}
			if (StringUtils.isBlank(newval)) {
				newval="bannerpush.jsp";
			}
			List<Map<String,Object>> list=operatorsService.getNextComs(null);
			for (Map<String, Object> map : list) {
				File path=new File(getRealPath(request)+map.get("com_id")+"/filed/auth.json");
				String info=getFileTextContent(path);
				if (StringUtils.isNotBlank(info)) {
					info=info.replaceAll(oldval, newval);
					saveFile(path, info);
				}
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("updateClientType")
	@ResponseBody
	public ResultInfo updateClientType(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
//			managerService.updateClientType();
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
}