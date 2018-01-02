package com.qianying.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.page.PageList;
import com.qianying.page.PersonnelQuery;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IProductService;

@RequestMapping("tree")
@Controller
public class TreeController extends BaseController{
	
	@Autowired
	private IProductService productService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private IEmployeeService employeeService;
	
	/**
	 * 加载选择树页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getDeptTree")
	public String getDeptTree(HttpServletRequest request) {
		String type=request.getParameter("type");
		List<Map<String, Object>> listMap=null;
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("com_id", getComId());
		if (StringUtils.isBlank(type)||"dept".equals(type)) {//部门树
			listMap=getDeptByUpper_dept_id(request,null);
			request.setAttribute("depts", listMap);
			return  "pc/tree/deptTree";
		}else if("employee".equals(type)){//员工树
			listMap= managerService.getDeptEmployee(map);
			request.setAttribute("employees", listMap);
			return  "pc/tree/employeeTree";
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
		}else if ("client".equals(type)) { //客户
			listMap=customerService.getCustomerTreeByEmployeeId(map);
			request.setAttribute("clients", listMap);
			return "pc/tree/clientTree";
		}else if("vendor".equals(type)){//供应商
			listMap= managerService.getGysTree(map);
			request.setAttribute("vendors", listMap);
			return "pc/tree/vendorTree";
		}else if("operate".equals(type)){//运营商
			listMap= managerService.getOperateTree(map);
			request.setAttribute("operates", listMap);
			return "pc/tree/operateTree";
		}else if("driver".equals(type)){//司机
			map.put("type", "1");
			listMap= managerService.getThirdPartyPersonnelTree(map);
			request.setAttribute("drivers", listMap);
			return "pc/tree/driverTree";
		}else if("electrican".equals(type)){//电工
			map.put("type", "0");
			listMap= managerService.getThirdPartyPersonnelTree(map);
			request.setAttribute("electricans", listMap);
			return "pc/tree/electricanTree";
		}else{
			return "";
		}
	}
	
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
		String employeeId=request.getParameter("employeeId");
		List<Map<String, Object>> list=null;
		Map<String,Object> map=getKeyAndValue(request);
		map.put("com_id", getComId(request));
		String name=request.getParameter("name");
		if (StringUtils.isNotBlank(name)) {
			map.put("name","%"+name+"%");
		}
		if (StringUtils.isBlank(type)||"dept".equals(type)) {
			list=getDeptByUpper_dept_id(request,treeId);
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
			if (StringUtils.isNotBlank(treeId)) {
				map.put("sort_id", treeId);
			}
			list=productService.getProductClass(request);
		}else if ("client".equals(type)) {
			map.put("treeId", treeId);
			if (getEmployee(request)==null||!"001".equals(getEmployee(request).get("user_id"))) {
				map.put("clerk_id", employeeId);
			}
			if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
				if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			list=customerService.getCustomerTreeByEmployeeId(map);
		}else if (type.contains("clientNext")) { //
//			map.put("treeId", type.split("&")[1]);
			if (getEmployee(request)!=null&&!"001".equals(getEmployee(request).get("user_id"))) {
				if ("是".equals(getEmployee(request).get("mySelf_Info"))) {
					map.put("clerk_id", getEmployeeId(request));
				}
			}
			list=customerService.getCustomerTreeByEmployeeId(map);
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
		}else if("driver".equals(type)){
			map.put("type", "1");
			list= managerService.getThirdPartyPersonnelTree(map);
		}else if("electrican".equals(type)){
			map.put("type", "0");
			list= managerService.getThirdPartyPersonnelTree(map);
		}
		return list;
	}
	public List<Map<String, Object>> getDeptByUpper_dept_id(HttpServletRequest request, String upper_dept_id) {
		String dept_name=request.getParameter("dept_name");
		String name=request.getParameter("name");
		String dept_manager=request.getParameter("dept_manager");
		String m_flag=request.getParameter("m_flag");
		String easy_id=request.getParameter("easy_id");
		String find=request.getParameter("find");
		Map<String,Object> map=new HashMap<String, Object>();
		if (StringUtils.isNotBlank(upper_dept_id)) {
			map.put("upper_dept_id", upper_dept_id);
		}
		if (StringUtils.isNotBlank(m_flag)) {
			map.put("m_flag", m_flag);
		}
		if (StringUtils.isNotBlank(dept_name)) {
			map.put("dept_name", "%"+dept_name+"%");
		}
		if (StringUtils.isNotBlank(name)) {
			map.put("name", "%"+name+"%");
		}
		if (StringUtils.isNotBlank(dept_manager)) {
			map.put("dept_manager", "%"+dept_manager+"%");
		}
		if (StringUtils.isNotBlank(easy_id)) {
			map.put("easy_id", "%"+easy_id+"%");
		}
		if (StringUtils.isBlank(easy_id)&&StringUtils.isBlank(m_flag)
				&&StringUtils.isBlank(dept_name)&&StringUtils.isBlank(dept_manager)) {
			find=null;
		}
		if (StringUtils.isNotBlank(find)) {
			map.put("find", find);
		}
		map.put("com_id", getComId());
		return managerService.getDeptByUpper_dept_id(map);
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerTree")
	@ResponseBody
	public List<Map<String,Object>> getCustomerTree(HttpServletRequest request) {
		String customer_id=request.getParameter("customer_id");
		String employeeId=request.getParameter("employeeId");
		Map<String,Object> mapparam=new HashMap<String, Object>();
		mapparam.put("table", "Ctl00801");
		mapparam.put("upperName", "regionalism_id");
		mapparam.put("idName", "clerk_id");
		mapparam.put("idVal", employeeId);
		mapparam.put("com_id", getComId(request));
		String regionalism_id=managerService.getUpperId(mapparam);
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("customer_id", customer_id);
		map.put("regionalism_id", regionalism_id);
		map.put("com_id", getComId());
		return customerService.getCustomerAndEmployeeTree(map);
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerPage")
	@ResponseBody
	public PageList<Map<String,Object>> getCustomerPage(HttpServletRequest request,PersonnelQuery query) {
		String customer_id=request.getParameter("type_id");
		String employeeId=request.getParameter("employeeId");
//		String regionalism_id=managerService.getUpperId("Ctl00801", "regionalism_id", "clerk_id", employeeId);
//		query.setRegionalism_id(regionalism_id);
		query.setCustomer_id(customer_id);
		if (!"001".equals(getEmployee(request).get("user_id"))) {
			query.setClerk_id(employeeId);
		}
		return customerService.getCustomerAndEmployeePage(query);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("productSelect")
	public String productSelect(HttpServletRequest request) {
		return "pc/tree/productSelect";
	}
	
	
}
