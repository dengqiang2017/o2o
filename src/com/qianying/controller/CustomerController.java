package com.qianying.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alipay.config.AlipayConfig;
import com.alipay.util.AlipayNotify;
import com.alipay.util.AlipaySubmit;
import com.qianying.bean.ResultInfo;
import com.qianying.bean.VerificationCode;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PageList;
import com.qianying.page.ProductQuery;
import com.qianying.service.IClientService;
import com.qianying.service.ICustomerService;
import com.qianying.service.IManagerService;
import com.qianying.service.IOperatorsService;
import com.qianying.service.IProductService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.InitConfig;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.SendSmsUtil;
import com.qianying.util.VerifyCodeUtils;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;

@Controller
@RequestMapping("/customer")
public class CustomerController extends FilePathController {
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private IClientService clientService;
	@Autowired
	private IManagerService managerService;
	@Autowired///注意先后顺序
	private IProductService productService;
	@Autowired
	private IOperatorsService operatorsService;
	@Autowired
	private ISystemParamsService systemParams;
	@Scheduled(fixedRate = 1000*5000)
	public void setAccessToken() {
//		WeixinUtil wei=new WeixinUtil();
//		WeixinUtil.access_token=null;
//		WeixinUtil.access_token_chat=null;
//		WeixinUtil.jsapi_ticket=null;
//		wei.getAccessToken(); 
//		wei.getChatAccessToken();
//		wei.jsapi_ticket();
		WeixinUtil weicom=new WeixinUtil();
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		 List<Map<String,Object>> list= operatorsService.getAll(); 
		 for (Map<String, Object> map : list) {
			 String com_id=map.get("com_id").toString().trim();
			 weicom.delAccessFile(com_id); 
			 weicom.getAccessToken(com_id);
			 weicom.getChatAccessToken(com_id);
			 weicom.jsapi_ticket(com_id);
			 ws.getAccessToken(com_id);
		 }
	}
	
	/**
	 *  根据用户名和密码获取该客户有哪些运营商
	 * @param request
	 * @return
	 */
	@RequestMapping("loginEwmList")
	@ResponseBody
	public List<Map<String,Object>> loginEwmList(HttpServletRequest request, String name, String pwd) {
		if (StringUtils.isBlank(name)) {
			return null;
		}
		if(pwd==null){
			pwd="";
		}
		Map<String,Object> map=getKeyAndValue(request);
		String com_id=request.getParameter("com_id");
		if (StringUtils.isBlank(com_id)) {
			map.remove("com_id");
		}
		List<Map<String,Object>> list=customerService.checkLoginEwm(map);
		if(list.size()==0){
			return null;
		}
		for (Iterator<Map<String,Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			Object password = MD5Util.MD5(map2.get("pwd"));
			if (!pwd.equalsIgnoreCase(password.toString())) {
				iterator.remove();
			}else{
				map2.put("pwd", password);
			}
		}
		return list;
	}
	/**
	 * 选择运营商确认登录
	 * @param request
	 * @return
	 */
	@RequestMapping("checkedLogin")
	@ResponseBody
	public ResultInfo checkedLogin(HttpServletRequest request, String name, String com_id,String com_name,String pwd) {
		boolean success = false;
		String msg = null;
		try {
			if(StringUtils.isNotBlank(name)&&StringUtils.isNotBlank(com_id)){
				Map<String,Object> map=customerService.checkedLogin(name,com_id);
				if(map!=null){
					Object password = MD5Util.MD5(map.get("user_password"));
					if (!pwd.equalsIgnoreCase(password.toString())) {
						msg="用户名或者密码错误!";
					}else{
						if (getEmployee(request) != null ) {
							 request.getSession().removeAttribute(ConfigFile.SESSION_USER_INFO);
						}
						if (StringUtils.isBlank(com_name)) {
							setComId(request, managerService);
						}else{
							setComId(request);
						}
						request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, com_id);
						request.getSession().setAttribute(ConfigFile.SYSTEM_NAME, com_name);
						request.getSession().setAttribute(
								ConfigFile.CUSTOMER_SESSION_LOGIN, map);
						Object o2o=systemParams.checkSystem("o2o");
						request.getSession().setAttribute("o2o", o2o);
						request.getSession().setAttribute("prefix", getPrefix());
						request.setAttribute("ver",InitConfig.getNewVer());
						msg=map.get("upper_corp_name")+"";
						customerService.noticeEmployee(map);
						customerService.updateLoginTime(map);
						success = true;
					}
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 客户登录
	 * @param request
	 * @param name
	 * @param pwd
	 * @return
	 */
	@RequestMapping("login")
	@ResponseBody
	public ResultInfo login(HttpServletRequest request, String name, String pwd) {
		String msg = null;
		boolean success = false;
		if (getEmployee(request) != null ) {
			 request.getSession().removeAttribute(ConfigFile.SESSION_USER_INFO);
		}
		if (StringUtils.isBlank(name)) {
			msg = "请输入用户名!";
		} else if (StringUtils.isBlank(pwd)) {
			msg = "请输入密码!";
		} 
		else {
			String comId = setComId(request,managerService);
			Map<String, Object> map = null;
			if ("001".equals(name)) {
				map = managerService.checkLogin(name, comId);
				map.put("customer_id", map.get("clerk_id"));
			} else {
				map = customerService.checkLogin(name, comId);
			}
			if (map == null) {
				msg = "用户不存在!";
			} else {
				Object password = map.get("user_password");
				if (password != null && password.toString().length() < 32) {
					password = MD5Util.MD5(password.toString());
				}
				if (password == null
						|| !pwd.equalsIgnoreCase(password.toString())) {
					msg = "用户名或密码错误!";
				} else {
					map.remove("user_password");
					request.getSession().setAttribute(
							ConfigFile.CUSTOMER_SESSION_LOGIN, map); 
					String operatorType=systemParams.checkSystem("operatorType", "b-b");
					request.getSession().setAttribute("operatorType", operatorType); 
					map.put("com_id",comId);
					String openid=request.getParameter("openid");
					if(StringUtils.isNotBlank(openid)&&openid.length()>=20){
						map.put("openid", openid);
					}
					customerService.updateLoginTime(map);
					customerService.noticeEmployee(map);
					success = true;
				}
			}
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 客户中心
	 * 
	 * @return
	 */
	@RequestMapping("customer")
	public String customer(HttpServletRequest request) {
		getSystemAndIndexName(request);
		if(getCustomerId(request)!=null){
			if(getCustomerId(request).startsWith("G")){//是G开头到供应商页面
				return "redirect:/supplier/supplier.do";
			}
		}
		String url=tourl(request);
		if (url!=null) {
			return url;
		}
		return ConfigFile.PC_OR_PHONE + "customer/customer";
	}
	/**
	 * 客户中心-详细信息
	 * 
	 * @return
	 */
	@RequestMapping("customerInfo")
	public String customerInfo(HttpServletRequest request) {
		request.setAttribute("client", customerService.getCustomerByCustomer_id(getCustomerId(request),getComId(request)));
		return  "pc/customer/customerInfo";
	}
	/**
	 *  从seesion中获取客户,用于判断客户是否登录
	 * @param request
	 * @return 登录后返回客户信息,没有登录返回null
	 */
	@RequestMapping("getCustomer")
	@ResponseBody
	public Map<String,Object> getCustomerDo(HttpServletRequest request) {
		if (super.getCustomer(request)!=null) {
			Map<String,Object> map=new HashMap<>();
			String name=customerService.getCustomerName(getCustomerId(request), getComId(request));
			if(StringUtils.isNotBlank(name)){
				String zeroStockOrder=systemParams.checkSystem("zeroStockOrder", "true");
				map.put("zeroStockOrder", zeroStockOrder);
				map.put("name", name);
			}
			return map;
 		}
		return null;
	}
	/**
	 *  获取客户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerInfo")
	@ResponseBody
	public Map<String,Object> getCustomerInfo(HttpServletRequest request) {
		if(getCustomer(request)==null){
			return null;
		}
		Map<String,Object> map=customerService.getCustomerByCustomer_id(getCustomerId(request), getComId());
//		String weixinType=systemParams.checkSystem("weixinType", "0");
		if(isNotMapKeyNull(map, "weixinID")){
			WeixinUtil wx=new WeixinUtil();
			String msg=wx.getEmployeeInfo(map.get("weixinID").toString(), getComId());
			if (StringUtils.isNotBlank(msg)) {
				JSONObject json=JSONObject.fromObject(msg);
				map.put("weixin_name",getJsonVal(json, "name"));
				map.put("weixin_img",getJsonVal(json,"avatar"));
			}
		}else if(isNotMapKeyNull(map, "openid")){
				WeiXinServiceUtil wx=new WeiXinServiceUtil();
				JSONObject json=wx.getUserInfoByOpenid(map.get("openid").toString(), getComId());
				if (json!=null) {
					map.put("weixin_name",getJsonVal(json, "nickname"));
					map.put("weixin_img",getJsonVal(json,"headimgurl"));
				}
			}
		return map;
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerSimpleInfo")
	@ResponseBody
	public Map<String,Object> getCustomerSimpleInfo(HttpServletRequest request) {
		if(getCustomer(request)==null){
			return null;
		}
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getCustomerId(request));
		map=customerService.getCustomerSimpleInfo(map);
		if(isNotMapKeyNull(map, "weixinID")){
			WeixinUtil wx=new WeixinUtil();
			String msg=wx.getEmployeeInfo(map.get("weixinID").toString(), getComId());
			if (StringUtils.isNotBlank(msg)) {
				JSONObject json=JSONObject.fromObject(msg);
				map.put("weixin_name",getJsonVal(json, "name"));
				map.put("weixin_img",getJsonVal(json,"avatar"));
			}
		}else if(isNotMapKeyNull(map, "openid")){
				WeiXinServiceUtil wx=new WeiXinServiceUtil();
				JSONObject json=wx.getUserInfoByOpenid(map.get("openid").toString(), getComId());
				if (json!=null) {
					map.put("weixin_name",getJsonVal(json, "nickname"));
					map.put("weixin_img",getJsonVal(json,"headimgurl"));
				}
			}
		return map;
	}
	/**
	 * 客户自助增加品种
	 * @param request
	 * @return
	 */
	@RequestMapping("add")
	public String add(HttpServletRequest request) {
		Map<String,Object> maparam=getKeyAndValueQuery(request);
		PageList<Map<String, Object>> pages = productService.findQuery(maparam);
		List<String> proIds = customerService.getCustomerAddedProduct(
				getCustomer(request).get("customer_id"), getComId(request));
		for (Iterator<Map<String, Object>> iterator = pages.getRows()
				.iterator(); iterator.hasNext();) {
			Map<String, Object> map = iterator.next();
			if (proIds.contains(map.get("item_id"))) {// 已经添加过的就不能再次添加
				map.put("added", 1);
			} else {
				map.put("added", 0);
			}
		}
		request.setAttribute("pages", pages);
		request.setAttribute("moreMemo", systemParams.checkSystem("moreMemo"));
		return "pc/customer/add";
	}

	/**
	 * 订单选择品种
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("order")
	public String order(HttpServletRequest request) {
//		Map<String, Object> map = getCustomer(request);
		// 1.1客户如果是经销商就使用自己的customer_id
//		Object customer_id = map.get("customer_id");
//		if (map.get("ditch_type") != null
//				&& "消费者".equals(map.get("ditch_type").toString())) {// /需要去掉!
//			// 1.2客户如果是终端客户就查找到他的经销商customer_id
//			customer_id = map.get("upper_customer_id");
//		}
//		List<Map<String, Object>> products = customerService
//				.getCustomerProduct(customer_id);
//		request.setAttribute("products", products);
		Map<String,Object> map=systemParams.getSystemParamsByComId(getComId());
		request.setAttribute("order", "order");
		request.setAttribute("beginTime",DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), - MapUtils.getIntValue(map, "dayN1_SdOutStore_Of_SdPlan"))));
		request.setAttribute("begin", map.get("dayN1_SdOutStore_Of_SdPlan"));
		request.setAttribute("endTime",map.get("dayN2_SdOutStore_Of_SdPlan"));
		request.setAttribute("time",map.get("dayTime_Of_SdPlan"));
		request.setAttribute("orderplan", map.get("orderplan"));
		request.setAttribute("accnIvt", map.get("accnIvt"));
		request.setAttribute("moreMemo", map.get("moreMemo"));
		return "pc/customer/order";
	}

	@RequestMapping("myorder")
	public String myorder(HttpServletRequest request) {
		setProcessName(request);
		request.setAttribute("seeds", request.getParameter("seeds_id"));
		return "pc/customer/myorder";
	}

	@RequestMapping("orderRecord")
	@ResponseBody
	public PageList<Map<String, Object>> orderRecord(
			HttpServletRequest request, ProductQuery query) {
		String type = request.getParameter("type");
		if (StringUtils.isBlank(type)) {
			type = "0";
//		Map<String, Object> map = getKeyAndValue(request, "type");
		}
//		// ////////////////
//		map.remove("quality_class");// 质量等级
//		map.remove("serve_id");//
//		map.remove("easy_id");//
//		map.remove("goods_origin");// 用途
//		map.remove("item_spec");// 规格getOrderParams(map
//		query.setQueryParams(getOrderParams(map));
		String customerId = getCustomerId(request);
		query.setCom_id(getComId(request));
		PageList<Map<String, Object>> list = customerService.getOrderRecord(
				type, customerId, query);
		return list;
	}
	/**
	 * 订单跟踪记录
	 * @param request
	 * @return
	 */
	@RequestMapping("orderTrackingRecord")
	@ResponseBody
	public PageList<Map<String,Object>> orderTrackingRecord(HttpServletRequest request ) {
		Map<String,Object> map=getKeyAndValueQuery(request);
//		map.remove("com_id");
		map.put("customer_id", getUpperCustomerId(request));
		if(isMapKeyNull(map, "orderstate")){//淮安通威下分tab页
			map.put("orderstate", "orderstate");
		}
		if("00".equals(map.get("type"))){
			map.remove("type");
		}
		if(isMapKeyNull(map, "page")){
			map.put("page", 0);
		}
		return customerService.orderTrackingRecord(map);
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderStateRecord")
	@ResponseBody
	public List<Map<String,Object>> getOrderStateRecord(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		return customerService.getOrderStateRecord(map);
	}
	
//	/**
//	 * 获取订单页面查询数据
//	 * 
//	 * @param map
//	 * @return
//	 */
//	private String getOrderParams(Map<String, Object> map) {
//		map.remove("page");
//		map.remove("rows");
//		Object[] keys = map.keySet().toArray();
//		Collection<Object> c = map.values();
//		Object[] vals = c.toArray();
//		StringBuffer wheresql = new StringBuffer();
//		for (int i = 0; i < vals.length; i++) {
//			if (vals[i] != null &&vals[i] !="" && keys[i] != null && keys[i] != ""
//					&& keys[i].toString().length() > 2) {
//				if ("goods_origin".equals(keys[i])
//						|| "item_style".equals(keys[i])
//						|| "type_id".equals(keys[i])
//						|| "com_id".equals(keys[i])) {
//					wheresql.append(" and t1.").append(keys[i]).append("=")
//							.append("'").append(vals[i]).append("'");
//				} else {
//					wheresql.append(" and t1.").append(keys[i])
//							.append(" like ").append("'%").append(vals[i])
//							.append("%'");
//				}
//			}
//		}
//		return wheresql.toString();
//	}

	/**
	 * 订单确认页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderConfirm")
	public String orderConfirm(HttpServletRequest request) {
		String systemType=systemParams.checkSystem("systemType", "b-b");
		if("b-c".equals(systemType)){
			return "pc/customer/orderConfirmToc";
		}else{
			Cookie[] c = request.getCookies();
			for (int i = 0; i < c.length; i++) {
				Cookie cookie = c[i];
				if (cookie.getName().equalsIgnoreCase("itemIds")) {
					String[] itemIds = cookie.getValue().split("-");
					request.setAttribute("HJJS", itemIds.length);
					break;
				}
			}
			String no = customerService.getOrderNo("销售开单", getComId(request));
			request.setAttribute("no", no);
			return "pc/customer/orderConfirm";
		}
	}

	/**
	 * 用于在未支付页面对订单的支付
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderSelectConfirm")
	@ResponseBody
	public ResultInfo orderSelectConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] sd_order_ids = request.getParameterValues("seeds_ids[]");
			customerService.orderSelectConfirm(sd_order_ids);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 获取待支付订单数据,汇总,客户信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getPayOderRecord")
	@ResponseBody
	public Map<String, Object> getPayOderRecord(HttpServletRequest request) {
		String customerId = getUpperCustomerId(request);
		return customerService.getPayOderRecord(customerId, getComId(request));
	}
	
	/**
	 *  获取支付中的订单信息,用于结算支付
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderStatusPaying")
	@ResponseBody
	public List<Map<String,Object>> getOrderStatusPaying(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		return customerService.getOrderStatusPaying(map);
	}
	
	/**
	 * 订单进入支付状态
	 * 
	 * @return
	 */
	@RequestMapping("orderPay")
	@ResponseBody
	public ResultInfo orderPay(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] seeds_ids = request.getParameterValues("seeds_ids[]");
			customerService.orderPay(seeds_ids);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 订单支付提交
	 * @param request
	 * @return 
	 */
	@RequestMapping("orderPayment")
	@ResponseBody
	public ResultInfo orderPayment(HttpServletRequest request) {
		String msg=null;
		boolean success=false;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id", getCustomerId(request));
			map.put("orderlist", request.getParameterValues("orderlist[]"));
			map.put("jiesList", request.getParameterValues("jiesList[]"));
			map.put("jiesListYCK", request.getParameterValues("jiesListYCK[]"));
			map.put("customerName", getCustomer(request).get("clerk_name"));
			///从系统中获取流程
			if (map.get("jiesListYCK")!=null) {
				map.put("Status_OutStore", "预存款审批");
			}else{
				map.put("Status_OutStore", getProcessName(request)[0]);
			}
			map.put("clerk_idAccountApprover", getCustomer(request).get("clerk_idAccountApprover"));
			writeLog(request,getCustomerId(request),map.get("customerName"), Arrays.toString(request.getParameterValues("orderlist[]"))+request.getParameterValues("jiesList[]"));
			map.put("yfk", "yfk");
			customerService.orderPayment(map);
			success = true;
		} catch (Exception e) {
			e.printStackTrace();
			e.getMessage();
		}		
		return new ResultInfo(success, msg);
	}
	/**
	 * 订单提交,货到付款
	 * @param request
	 * @return
	 */
	@RequestMapping("cashDelivery")
	@ResponseBody
	public ResultInfo cashDelivery(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			//1.获取第二步订单流程名称
			map.put("customer_id", getUpperCustomerId(request));
			map.put("customerName", super.getCustomer(request).get("clerk_name"));
			msg=customerService.cashDelivery(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 保存订单
	 * 
	 * @param request
	 * @return 执行结果
	 * @throws Exception
	 */
	@RequestMapping("saveOrder")
	@ResponseBody
	public ResultInfo saveOrder(HttpServletRequest request) throws Exception {
		String msg = null;
		boolean success = false;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("com_id", getComId(request));
		map.put("ivt_oper_listing", request.getParameter("ivt_oper_listing"));
		map.put("sd_order_id", request.getParameter("ivt_oper_listing"));
		map.put("comfirm_flag", "N");
		map.put("customer_id", request.getParameter("customer_id"));
		map.put("so_effect_datetime", getNow());
		map.put("sum_si", request.getParameter("sum_si"));
		map.put("acceptsum", request.getParameter("sum_si"));
		map.put("send_sum_all", 0);
		map.put("delivery_Add", request.getParameter("delivery_Add"));
		map.put("settlement_type_id",
				request.getParameter("settlement_type_id"));
		map.put("settlement_sim_name",
				request.getParameter("settlement_type_id"));
		map.put("HYJE", request.getParameter("HYJE"));
		map.put("HJJS", request.getParameter("HJJS"));
		map.put("transport_AgentClerk_Reciever",
				request.getParameter("transport_AgentClerk_Reciever"));
		// map.put(" ", request.getParameter(""));
		// map.put(" ", request.getParameter(""));
		// map.put(" ", request.getParameter(""));
		customerService.saveOrder(map);
		success = true;
		return new ResultInfo(success, msg);
	}
	/**
	 * 客户注册
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUser")
	@ResponseBody
	public synchronized ResultInfo saveUser(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		String user_id = request.getParameter("userId");
		String user_password = request.getParameter("pwd");
		String FHDZ = request.getParameter("FHDZ");
		String corp_name=request.getParameter("corp_name");
		String upper_customer_id=request.getParameter("upper_customer_id");
		String fenxiangid=request.getParameter("fenxiangid");
		String quhua=request.getParameter("quhua");
		String clerk_id=request.getParameter("clerk_id");
		String openid=request.getParameter("openid");
		Map<String,Object> check=checkRegisterParam(request, user_id);
		if (MapUtils.getBoolean(check, "b")) {
			if (customerService.checkPhone(user_id,request.getParameter("com_id"))) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("user_id", user_id);
				map.put("movtel", user_id);
				if(StringUtils.isBlank(upper_customer_id)){
					map.put("upper_customer_id", "CS1");
				}else{
					map.put("upper_customer_id", upper_customer_id);
				}
				if (StringUtils.isNotBlank(fenxiangid)) {
					if(fenxiangid.startsWith("CS1")||fenxiangid.startsWith("C")){
						map.put("upper_customer_id", fenxiangid);
					}else{
						map.put("clerk_id", fenxiangid);
					}
				}
				map.put("clerk_id", clerk_id);
				map.put("com_id", setComId(request));
				map.put("type_id", "1");
				map.put("working_status", "是");
				map.put("user_password", MD5Util.MD5(user_password));
				map.put("weixinID",user_id);
				map.put("regionalism_id",quhua);
				map.put("ditch_type", "消费者");
				map.put("customer_type", "终端客户");
				map.put("market_type", "终端客户");
				String clerk_idAccountApprover=customerService.getClerk_idAccountApprover(getComId());
				map.put("clerk_idAccountApprover", clerk_idAccountApprover);
				if(StringUtils.isBlank(corp_name)){
					corp_name=user_id;
				}
				map.put("corp_name", corp_name);
				map.put("corp_sim_name", corp_name);
				map.put("FHDZ", FHDZ);
				map.put("openid", openid);
				customerService.save(map);
				//////注册自动登录//////
				map = customerService.checkLogin(user_id, getComId());
				map.remove("user_password");
				request.getSession().setAttribute(
						ConfigFile.CUSTOMER_SESSION_LOGIN, map);
				request.getSession().setAttribute("o2o", systemParams.checkSystem("o2o"));
				request.getSession().setAttribute("prefix", getPrefix());
				request.setAttribute("ver",InitConfig.getNewVer());
				///////////保存收货地址到文本文件中begin///
				//1.调用getCustomerId获取customer_id,获取前台传过来的FHDZ,
				//调用saveFile(getFHDZPath(request, getCustomerId(request)), FHDZ)
				//2.将收货地址信息已JSON格式保存
				JSONObject obj=new JSONObject();
				obj.put("lxr",corp_name);
				obj.put("lxPhone", user_id);
				obj.put("FHDZ",FHDZ);
				//3.调用saveFile方法
				saveFile(getFHDZPath(request, getCustomerId(request)), obj.toString());
				///////////保存收货地址到文本文件中end///
				//非默认收货地址保存到外部文件
				////提交客户数据到微信企业号///
				String key=request.getParameter("type");
				if(StringUtils.isBlank(key)){
					key="客户";
				}
				if (StringUtils.isNotBlank(corp_name)) {
					map.put("name", corp_name);
				}
				Object agentDeptId=systemParams.checkSystem("agentDeptId");
				postInfoToweixinComId(map,key,agentDeptId);
				writeLog(request,map.get("customer_id")+"",corp_name,"客户注册");
				success = true;
			} else {
				error_code = 105;// 手机号已经存在
			}
		}else{
			msg=MapUtils.getString(check, "msg");
			error_code=MapUtils.getInteger(check, "error_code");
		}
		return new ResultInfo(success, msg, error_code);
	}
	/**
	 * 保存用户信息
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
			map.put("customer_id", getCustomerId(request));
			boolean b=false;
			if (isNotMapKeyNull(map, "movtel")) {
				if(MapUtils.getString(map, "movtel").length()==11){
					Object code=map.get("code");
					if("1111".equals(code)){
						b=true;
					}else {
						String vercode=getFileTextContent(getTxtVerificationCode(request, MapUtils.getString(map, "movtel")));
						VerificationCode erificationCode = (VerificationCode) request
								.getSession().getAttribute("editVerificationCode");
						if(erificationCode!=null){
							if(StringUtils.isNotBlank(erificationCode.getCode())){
								if(erificationCode.getCode().equals(code)){
									b=true;
								}
							}
						}else if(StringUtils.isNotBlank(vercode)){
							if(vercode.equals(code)){
								b=true;
							}
						}
					}
					if(!b){
						msg="验证码错误";
					}
				}else{
					msg="手机号码长度不足!";
				}
			}else{
				b=true;
			}
			if(b){
				map.remove("code");
				map.put("user_id", map.get("movtel"));
				customerService.update(map);
				map = customerService.checkLogin(getCustomer(request).get("user_id")+"", getComId());
				map.remove("user_password");
				request.getSession().setAttribute(
						ConfigFile.CUSTOMER_SESSION_LOGIN, map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 检查客户手机号是否存在
	 * 
	 * @param request
	 * @param phone
	 * @return 存在返回false,不存在返回true
	 */
	@RequestMapping("checkPhone")
	@ResponseBody
	public ResultInfo checkPhone(HttpServletRequest request, String phone) {
		boolean success = false;
		String msg = null;
		if (StringUtils.isBlank(phone)) {
			msg = "请输入手机号!";
		} else {
			success = customerService.checkPhone(phone,getComId());
		}
		return new ResultInfo(success, msg);
	}

	// ///////////账户充值/////
	@RequestMapping("paymoney")
	public String paymoney(HttpServletRequest request) {
		 
		return "pc/customer/paymoney";
	}
	
	@RequestMapping("getSettlementList")
	@ResponseBody
	public List<Map<String,Object>> getSettlementList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return customerService.getSettlementList(map);
	}
	
	@RequestMapping("getPaymoneyNo")
	@ResponseBody
	public String getPaymoneyNo(HttpServletRequest request) {
		return customerService.getOrderNo("销售收款", getComId(request));
	}
	/**
	 * 代办事项
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("todo")
	public String todo(HttpServletRequest request) {
	
		return ConfigFile.PC_OR_PHONE + "todo";
	}
	/**
	 * 客户充值数据保存
	 * @param request
	 * @return
	 */
	@RequestMapping("savePaymoney")
	@ResponseBody
	public ResultInfo savePaymoney(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if(getCustomer(request)==null){
				msg="请重新登录客户!";
				return new ResultInfo(success, msg);
			}
			Calendar c = Calendar.getInstance();
			Map<String, Object> map =getKeyAndValue(request);
			Object orderNo=map.get("orderNo");
			if (orderNo==null) {
				orderNo=customerService.getOrderNo("销售收款", getComId(request));
			}
			String customer_id=getUpperCustomerId(request);
//			if(!"消费者".equals(getCustomer(request).get("ditch_type"))){
//				customer_id=getUpperCustomerId(request);
//			}
			map.put("finacial_y", c.get(Calendar.YEAR));
			map.put("finacial_m", c.get(Calendar.MONTH));
			map.put("finacial_d", getNow());
			map.put("recieved_direct", "收款");
			map.put("recieved_auto_id",orderNo);
			map.put("recieved_id", orderNo);
			map.put("customer_id",customer_id);
			map.put("customerName", getCustomer(request).get("clerk_name"));
			if (!getCustomerId(request).equals(getUpperCustomerId(request))) {
				map.put("upper_corp_name", getCustomer(request).get("upper_corp_name").toString());
			}
			map.put("recieve_type", map.get("account"));
			map.put("rcv_hw_no", map.get("paystyle"));
			
			StringBuffer buffer=new StringBuffer(getCustomer(request).get("clerk_name").toString());
			buffer.append(getNow().split(" ")[0]).append("收款单号");
			buffer.append("[").append(orderNo).append("]").append(map.get("paystyletxt"));
			StringBuffer rejg_hw_no=new StringBuffer();
			if(map.get("orderlist")!=null){
				Object orderlist=map.get("orderlist");
				if(!orderlist.toString().startsWith("[")){
					orderlist="["+orderlist+"]";
				}
				JSONArray jsons=JSONArray.fromObject(orderlist);
				for (int i = 0; i < jsons.size(); i++) {
					if(jsons.getJSONObject(i).get("ivt_oper_listing")!=null){
						rejg_hw_no.append(",").append(jsons.getJSONObject(i).get("ivt_oper_listing"));
					}
				}
				buffer.append(",订单编号:").append(map.get("orderlist"));
			}
			map.put("rejg_hw_no", rejg_hw_no);//订单编号
//			map.put("c_memo", buffer.toString());
			map.put("sum_si", map.get("amount"));
//			map.put("sum_si_origin",map.get("sum_si_origin"));
			map.put("comfirm_flag", "N");
			map.put("mainten_clerk_id", getCustomerId(request));
			map.put("mainten_datetime", getNow());
			Map<String,Object> maporder=null;
			if (map.get("orderlist")!=null) {
				maporder=new HashMap<String, Object>();
				maporder.put("com_id", getComId(request));
				maporder.put("beizhu", orderNo);
				maporder.put("customerName", getCustomer(request).get("clerk_name"));
				maporder.put("customer_id", customer_id);
				maporder.put("clerk_idAccountApprover", getCustomer(request).get("clerk_idAccountApprover"));
				maporder.put("orderlist", map.get("orderlist"));
				maporder.put("jiesList", map.get("jiesList"));
				maporder.put("jiesListYCK", map.get("jiesListYCK"));
				maporder.put("transport_AgentClerk_Reciever", map.get("transport_AgentClerk_Reciever"));
				maporder.put("Kar_Driver", map.get("Kar_Driver"));
				maporder.put("Kar_Driver_Msg_Mobile", map.get("Kar_Driver_Msg_Mobile"));
				maporder.put("Kar_paizhao", map.get("Kar_paizhao"));
				maporder.put("FHDZ", map.get("FHDZ"));
				maporder.put("Status_OutStore",getProcessName(request,0));
//				maporder.put("Status_OutStore","核款");
				writeLog(request,getCustomerId(request),maporder.get("customerName"),map.toString());
			}
			////////////////
			map.remove("orderNo");
			map.remove("account");
			map.remove("paystyle");
//			map.remove("paystyletxt");
			map.remove("amount");
			Object orderlist=map.get("orderlist");
			if (orderlist!=null) {
				map.remove("jiesListYCK");
				map.remove("jiesList");
				map.remove("orderlist");
				map.remove("transport_AgentClerk_Reciever");
				map.remove("Kar_Driver");
				map.remove("Kar_Driver_Msg_Mobile");
				map.remove("Kar_paizhao");
				map.remove("FHDZ");
			}
			/////////////////
			Object weixin=map.get("weixin");map.remove("weixin");
			map.remove("imgurl");
			customerService.savePaymoney(map,maporder);
			////////保存备注信息到文件中
			File file=getRecievedMemo(request, orderNo,getUpperCustomerId(request));
			saveFile(file, buffer.toString());
			////保存支付凭证图片/////
			if (weixin!=null) {
				msg=getComId()+"/certificate/"+orderNo+".jpg";
				File destFile=new File(getRealPath(request)+msg);
				mkdirsDirectory(destFile);
				if("0".equals(weixin)){
					String imgurl=request.getParameter("imgurl");
					if (StringUtils.isNotBlank(imgurl)) {
						File srcFile=new File(getRealPath(request)+imgurl); 
						if (srcFile.exists()) {
							FileUtils.moveFile(srcFile, destFile);
						}
					}
				}else{
					WeixinUtil wei=new WeixinUtil();
					String media_id=request.getParameter("imgurl");
					String url="https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="+wei.getAccessToken(getComId())
							+"&media_id="+media_id;
			        mkdirsDirectory(destFile);
					wei.getDataImage(url,destFile);
				}
			}
			String clerk_id=getEmployeeId(request);
			if (clerk_id==null) {
				clerk_id=getCustomerId(request);
			}
			writeLog(request,clerk_id,map.get("customerName"), "添加订单"+ buffer.toString().replaceAll(",", "_"));
			success = true;
			msg=orderNo.toString();
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取上传凭证图片
	 * @param request
	 * @return
	 */
	@RequestMapping("getCertificateImg")
	@ResponseBody
	public List<String> getCertificateImg(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String com_id=request.getParameter("com_id");
		if(StringUtils.isBlank(com_id)){
			com_id=getComId();
		}
		File destFile=new File(getRealPath(request)+com_id+"/certificate/"+orderNo);
		if(destFile.exists()){
			File[] fs=destFile.listFiles();
			if(fs!=null&&fs.length>0){
				List<String> list=new ArrayList<String>();
				for (File item : fs) {
					String[] path=item.getPath().split("\\\\"+com_id);
					String pathimg=com_id+path[1];
					pathimg=pathimg.replaceAll("\\\\", "/");
					list.add(pathimg);
				}
				return list;
			}
		}
		return null;
	}
	@RequestMapping("customerPageList")
	@ResponseBody
	public PageList<Map<String, Object>> customerPageList(
			HttpServletRequest request, CustomerQuery query) {
		query.setCom_id(getComId(request));
		return customerService.findQuery(query);
	}
	/**
	 *  我的客户
	 * @param request
	 * @return
	 */
	@RequestMapping("myClient")
	public String myClient(HttpServletRequest request) {
		return "pc/customer/myClient";
	}
	/**
	 *  客户计划
	 * @param request
	 * @return
	 */
	@RequestMapping("clientPlan")
	public String clientPlan(HttpServletRequest request) {
		request.setAttribute("order", "plan");
//		CustomerQuery query = new CustomerQuery();
//		request.setAttribute("customers", customerService.findQuery(query));
//		request.setAttribute("type", request.getParameter("type"));
		///计划页面默认显示的时间
		Map<String,Object> map=systemParams.getSystemParamsByComId(getComId());
		Date now=new Date();
		Date anotherDate=DateTimeUtils.strToDateTime(DateTimeUtils.dateToStr()+" "+map.get("dayTime_Of_SdPlan"));
		String N1Time=null;
		if (now.compareTo(anotherDate)!=1) {///anotherDate大于now为1开始日期减1
			N1Time=DateTimeUtils.dateToStr(DateUtils.addDays(new Date(),MapUtils.getIntValue(map, "dayN1_SdOutStore_Of_SdPlan")));
		}else{//结束日期加1
			N1Time=DateTimeUtils.dateToStr(DateUtils.addDays(new Date(),MapUtils.getIntValue(map, "dayN1_SdOutStore_Of_SdPlan")+1));
		}
		request.setAttribute("N1Time", N1Time);
		request.setAttribute("time",map.get("dayTime_Of_SdPlan"));
		return "pc/customer/clientPlan";
	}
	/**
	 * 销售计划报表
	 * @param request
	 * @return
	 */
	@RequestMapping("salePlanReport")
	public String salePlanReport(HttpServletRequest request) {
		
		return "pc/customer/salePlanReport";
	}
	/**
	 * 客户对账单
	 * @param request
	 * @return
	 */
	@RequestMapping("accountStatement")
	public String accountStatement(HttpServletRequest request) {
		
		return "pc/customer/accountStatement";
	}
	/**
	 * 额度申请
	 * @param request
	 * @return
	 */
	@RequestMapping("quotaApplication")
	public String quotaApplication(HttpServletRequest request) {
		
		return "pc/customer/quotaApplication";
	}
	/**
	 * 欠条
	 * @param request
	 * @return
	 */
	@RequestMapping("iou")
	public String iou(HttpServletRequest request) {
		String contentpath="";
		if (StringUtils.isNotBlank(request.getContextPath()) ) {
			contentpath=request.getContextPath()+"/";
		}
		request.setAttribute("contentpath",contentpath);
		request.setAttribute("iouPath", getIouPath(request,getCustomerId(request)));
		return "pc/customer/IOU";
	}
	
	/**
	 * 保存欠条
	 * @param request
	 * @return
	 */
	@RequestMapping("saveIou")
	@ResponseBody
	public ResultInfo saveIou(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String printdiv=request.getParameter("printdiv");
			Map<String,Object> map=getKeyAndValue(request, "printdiv");
			map.put("customer_id", getCustomerId(request));
			map.put("clerk_idAccountApprover", getCustomer(request).get("clerk_idAccountApprover"));
			map.put("com_id", getComId(request));
			map.put("customerName", getCustomer(request).get("clerk_name"));
			String op_id=customerService.saveIouOA_ctl03001_approval(map);
			StringBuffer buffer=getIouPath(request, getCustomerId(request));
			buffer.append(op_id).append(".html");
			saveFile(buffer.toString(), "<!DOCTYPE html>"+printdiv);
			success = true;
			writeLog(request,getCustomerId(request),map.get("customerName"), map.toString());
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  跳转欠条列表页面
	 * @param request
	 * @return
	 */
	@RequestMapping("ioulist")
	public String ioulist(HttpServletRequest request) {
		return "pc/ioulist";
	}
	/**
	 * 获取欠条列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getIouList")
	@ResponseBody
	public List<String> getIouList(HttpServletRequest request) {
		return getIouList(request, getCustomerId(request));
	}
	
	//////////////////////////////////////
	/**
	 * 手机验证码判断
	 * 
	 * @param mobiles
	 *            手机号
	 * @return
	 */
	public boolean isMobileNO(String mobiles) {
		String regExp = "^[0-9]*[1-9][0-9]*$";
		Pattern p = Pattern.compile(regExp);
		// .compile("^((1[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}
//	private static int code_fwcs=0;//验证码接口单次访问
//	private static int code_fwcs_sum=0;//验证码
	
	@RequestMapping("getVerificationCode")
	@ResponseBody
	public ResultInfo getVerificationCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer errorCode=null;
		try {
			String phone=request.getParameter("phone");
			if(getCustomer(request)!=null){
				if(StringUtils.isNotBlank(phone)&&phone.length()==11){
					String str=getNow()+"-->>"+LogUtil.getIpAddr(request)+"-->>"+phone+"\r\n";
					String path1=getRealPath(request)+"temp/VerificationCode.txt";
					saveFile(path1, str, true);
					// 生成验证码
					VerificationCode erificationCode = (VerificationCode) request
							.getSession().getAttribute("editVerificationCode");
					Long jiange = isObsolete(100, request);
					if (jiange != null) {
						msg = jiange.toString();
						errorCode = 101;
					} else {
						erificationCode = new VerificationCode(
								generateVerificationCode());
						erificationCode.setPhone(phone);
						// /发送手机验证码
						Map<String,Object> mapsms=systemParams.getSystemParamsByComId(getComId());
						SendSmsUtil.sendSms2(phone,erificationCode.getCode(),null,mapsms);
					}
					StringBuffer path=new StringBuffer(getComIdPath(request));
					path.append("VerificationCode/")
					.append(erificationCode.getPhone().trim()).append(".txt");
					saveFile(path.toString(), erificationCode.getCode(), true);
					// 将验证码放入到session中
					request.getSession().setAttribute("editVerificationCode", erificationCode);
					success = true;
				}else{
					msg="手机号格式不正确!";
				}
			}else{
				msg="请登录客户后再操作!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg, errorCode);
	}
	
	/**
	 * 获取验证码
	 * @param request
	 * @param phone 手机号
	 * @return
	 */
	@RequestMapping("/getVerification_code")
	@ResponseBody
	public ResultInfo getVerificationCode(HttpServletRequest request,
			String phone) {
		boolean flag = false;
		String msg = null;
		Integer errorCode = 0;
		///1.判断图形验证码是否正确//////
		String verifycode=request.getParameter("verifycode");
		Object imgverifycode=request.getSession().getAttribute(VerifyCodeUtils.imgverifyCode);
		if (StringUtils.isBlank(phone)) {
			msg = "手机号不能为空!";
		} else if (phone.length() != 11) {
			msg = "手机号位数不正确!";
		} else if (!isMobileNO(phone)) {
			msg = "手机格式不正确!";
		} else if (StringUtils.isBlank(verifycode)||imgverifycode==null||!imgverifycode.toString().equalsIgnoreCase(verifycode)) {
			msg="页面已过期,请刷新页面!";
		}else{
			String str=getNow()+"-->>"+LogUtil.getIpAddr(request)+"-->>"+phone+"\r\n";
			String path1=getRealPath(request)+"temp/VerificationCode.txt";
			saveFile(path1, str, true);
			////判断接口访问次数 
			// 生成验证码
			VerificationCode erificationCode = (VerificationCode) request
					.getSession().getAttribute(ConfigFile.registerVerificationCode);
			Long jiange = isObsolete(100, request);
			if (jiange != null) {
				msg = jiange.toString();
				errorCode = 101;
			} else {
				erificationCode = new VerificationCode(
						generateVerificationCode());
				erificationCode.setPhone(phone);
				// /发送手机验证码
				if (!ConfigFile.DEBUG) {
					Map<String,Object> mapsms=systemParams.getSystemParamsByComId(getComId());
					SendSmsUtil.sendSms2(phone,erificationCode.getCode(),null,mapsms);
				}
			}
			StringBuffer path=new StringBuffer(getComIdPath(request));
			path.append("VerificationCode/")
			.append(erificationCode.getPhone().trim()).append(".txt");
			saveFile(path.toString(), erificationCode.getCode(), true);
			// 将验证码放入到session中
			request.getSession().setAttribute(
					ConfigFile.registerVerificationCode, erificationCode);
			String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
			request.getSession().setAttribute(VerifyCodeUtils.imgverifyCode, verifyCode);
			flag = true;
		}
		return new ResultInfo(flag, msg, errorCode);
	}
	// //////////////////支付宝支付接口///////////////////////////////////
	@RequestMapping("notifyUrl")
	public String notifyUrl(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 获取支付宝POST过来反馈信息
		Map<String, String> params = new HashMap<String, String>();
		Map<String, String[]> requestParams = request.getParameterMap();
		for (Iterator<String> iter = requestParams.keySet().iterator(); iter
				.hasNext();) {
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			// 乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			// valueStr = new String(valueStr.getBytes("ISO-8859-1"), "gbk");
			params.put(name, valueStr);
		}
		// 获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
		// 商户订单号
		String out_trade_no = new String(request.getParameter("out_trade_no")
				.getBytes("ISO-8859-1"), "UTF-8");
		LoggerUtils.info(out_trade_no);
		// 支付宝交易号
		String trade_no = new String(request.getParameter("trade_no").getBytes(
				"ISO-8859-1"), "UTF-8");
		LoggerUtils.info(trade_no);
		// 交易状态
		String trade_status = new String(request.getParameter("trade_status")
				.getBytes("ISO-8859-1"), "UTF-8");
		LoggerUtils.info(trade_status);

		// 获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//

		if (AlipayNotify.verify(params)) {// 验证成功
			// ////////////////////////////////////////////////////////////////////////////////////////
			// 请在这里加上商户的业务逻辑程序代码
			// ——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
			if (trade_status.equals("TRADE_FINISHED")) {
				// 判断该笔订单是否在商户网站中已经做过处理
				// 如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
				// 如果有做过处理，不执行商户的业务程序
				// 注意：
				// 退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
			} else if (trade_status.equals("TRADE_SUCCESS")) {
				// 判断该笔订单是否在商户网站中已经做过处理
				// 如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
				// 如果有做过处理，不执行商户的业务程序
				// 注意：
				// 付款完成后，支付宝系统发送该交易状态通知
				// updateOrder(request);
			}
			// ——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
			return "success"; // 请不要修改或删除
			// ////////////////////////////////////////////////////////////////////////////////////////
		} else {// 验证失败
			return "fail";
		}
	}

	@RequestMapping("returnUrl")
	public String returnUrl(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// 获取支付宝GET过来反馈信息
		Map<String, String> params = new HashMap<String, String>();
		Map<String, String[]> requestParams = request.getParameterMap();
		for (Iterator<String> iter = requestParams.keySet().iterator(); iter
				.hasNext();) {
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			// 乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
			params.put(name, valueStr);
		}
		// 计算得出通知验证结果
		boolean verify_result = AlipayNotify.verify(params);
		if (verify_result) {// 验证成功
			// ////////////////////////////////////////////////////////////////////////////////////////
			// 请在这里加上商户的业务逻辑程序代码
			Map<String,Object> map=getKeyAndValue(request);
			LoggerUtils.error(map);
			// 获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
			// 该页面可做页面美工编辑
			response.getOutputStream().println("success<br />");
			// ——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
//			 updateOrder(request);
			// ////////////////////////////////////////////////////////////////////////////////////////
		} else {
			// 该页面可做页面美工编辑
			response.getOutputStream().println("error");
		}
		request.setAttribute("params", params);
		return "redirect:pc/pay_result.jsp";
	}

	@RequestMapping("alipayapi")
	public String alipayapi(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		// 支付类型
		String payment_type = "1";
		// 必填，不能修改
		// 服务器异步通知页面路径
		String notify_url =ConfigFile.urlPrefix+ "/member/notifyUrl.do";
		// 需http://格式的完整路径，不能加?id=123这类自定义参数
		// 页面跳转同步通知页面路径
		String return_url =ConfigFile.urlPrefix+  "/member/returnUrl.do";
		// 需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/
		// 商户订单号
		String out_trade_no = new String(request
				.getParameter("WIDout_trade_no").getBytes("ISO-8859-1"),
				"UTF-8");
		// 商户网站订单系统中唯一订单号，必填
		// 订单名称
		String subject = new String(request.getParameter("WIDsubject")
				.getBytes("ISO-8859-1"), "UTF-8");
		// 必填 
		// 付款金额
		String amount=request.getParameter("WIDtotal_fee");
		java.text.DecimalFormat myformat=new java.text.DecimalFormat("0.00");
		amount= myformat.format(Double.parseDouble(amount));
		String total_fee = new String(amount.getBytes("ISO-8859-1"), "UTF-8");
		// 必填
		// 订单描述
		String body = new String(request.getParameter("WIDbody").getBytes(
				"ISO-8859-1"), "UTF-8");
		// 商品展示地址
		String show_url = new String(request.getParameter("WIDshow_url")
				.getBytes("ISO-8859-1"), "UTF-8");
		// 需以http://开头的完整路径，例如：http://www.商户网址.com/myorder.html

		// 防钓鱼时间戳
		String anti_phishing_key = "";
		// 若要使用请调用类文件submit中的query_timestamp函数

		// ////////////////////////////////////////////////////////////////////////////////

		// 把请求参数打包成数组
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("service", "create_direct_pay_by_user");
		sParaTemp.put("partner", AlipayConfig.partner);
		sParaTemp.put("seller_email", AlipayConfig.seller_email);
		sParaTemp.put("_input_charset", AlipayConfig.input_charset);
		sParaTemp.put("payment_type", payment_type);
		sParaTemp.put("notify_url", notify_url);
		sParaTemp.put("return_url", return_url);
		sParaTemp.put("out_trade_no", out_trade_no);
		sParaTemp.put("subject", subject);
		sParaTemp.put("total_fee", total_fee);
		sParaTemp.put("body", body);
		sParaTemp.put("show_url", show_url);
		sParaTemp.put("anti_phishing_key", anti_phishing_key);
		sParaTemp.put("exter_invoke_ip",  LogUtil.getIpAddr(request));

		// 建立请求
		String sHtmlText = AlipaySubmit.buildRequest(sParaTemp, "get",
				new String("确认".getBytes("ISO-8859-1"), "UTF-8"));
		response.getWriter().println(
				"<!DOCTYPE html><html><head><meta charset='UTF-8'><title>支付宝</title></head>"
						+ sHtmlText + "</html>");
		// out.println(sHtmlText);
		return null;
	}

	@RequestMapping("alipay")
	public void alipay(HttpServletRequest request, HttpServletResponse response, String orderNo,
			String amount) throws Exception {
		// 支付类型
		String payment_type = "1";
		// 必填，不能修改
		// 服务器异步通知页面路径
		String notify_url =ConfigFile.urlPrefix+"/customer/notifyUrl.do"; 
		// 需http://格式的完整路径，不能加?id=123这类自定义参数
		// 页面跳转同步通知页面路径
		String return_url = ConfigFile.urlPrefix+"/customer/returnUrl.do"; 
		// 需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/
		// 商户订单号
		String out_trade_no = new String(orderNo.getBytes("ISO-8859-1"),
				"UTF-8");
		// 商户网站订单系统中唯一订单号，必填
		// 订单名称
		String subject =  request.getParameter("attach");
		// 必填
		// 付款金额 
		java.text.DecimalFormat myformat=new java.text.DecimalFormat("0.00");
		amount= myformat.format(Double.parseDouble(amount));
		String total_fee = new String(amount.getBytes("ISO-8859-1"), "UTF-8");
		// 必填
		// 订单描述
		String body = request.getParameter("body");
		// 商品展示地址
		String show_url =ConfigFile.urlPrefix+"/pc/index.html";
		// 需以http://开头的完整路径，例如：http://www.商户网址.com/myorder.html

		// 防钓鱼时间戳
		String anti_phishing_key = AlipaySubmit.query_timestamp();
		// 若要使用请调用类文件submit中的query_timestamp函数

		// 把请求参数打包成数组
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("service", "create_direct_pay_by_user");
		sParaTemp.put("partner", AlipayConfig.partner);
		sParaTemp.put("seller_email", AlipayConfig.seller_email);
		sParaTemp.put("_input_charset", AlipayConfig.input_charset);
		sParaTemp.put("payment_type", payment_type);
		sParaTemp.put("notify_url", notify_url);
		sParaTemp.put("return_url", return_url);
		sParaTemp.put("out_trade_no", out_trade_no);
		sParaTemp.put("subject", subject);
		sParaTemp.put("total_fee", total_fee);
		sParaTemp.put("body",body);
		sParaTemp.put("show_url", show_url);
		sParaTemp.put("anti_phishing_key", anti_phishing_key);
		sParaTemp.put("exter_invoke_ip",  LogUtil.getIpAddr(request));
		// 建立请求
		String sHtmlText = AlipaySubmit.buildRequest(sParaTemp, "get",
				new String("确认".getBytes("ISO-8859-1"), "UTF-8"));
		response.getWriter().println(
				"<!DOCTYPE html><html><head><meta charset='UTF-8'><title>支付宝</title></head>"
						+ sHtmlText + "</html>");
	}
	// ////////////////////支付结束////////////
	/**
	 * 从首页产品直接下采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("orderpay")
	@ResponseBody
	public ResultInfo orderpay(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
				LoggerUtils.info(DateTimeUtils.getNowDateTimeS());
				Map<String,String> map=getQueryKeyAndValue(request);
				if (getCustomer(request)!=null) {
					map.put("customer_id", getUpperCustomerId(request));
					map.put("laiyuan", "cping");//标识是从产品选择的订单
					if("shopping".equals(map.get("type"))){
						if(StringUtils.isBlank(map.get("list"))){
							msg="没有获取到产品相关参数";
						}else if(map.get("list").startsWith("[")&&map.get("type").endsWith("]")){
							msg="参数格式错误!";
						}else{
							customerService.saveOrderBYShopping(map);
							success = true;
						}
					}else{
						customerService.saveOrderAndPay(map);
						success = true;
					}
				}else{
					msg="请登录后再操作!";
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
	@RequestMapping("shopping")
	@ResponseBody
	public ResultInfo shopping(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			LoggerUtils.error("shopping-->"+DateTimeUtils.getNowDateTimeS());
			Map<String,String> map=getQueryKeyAndValue(request);
			if(getCustomer(request)!=null){
				map.put("customer_id", getUpperCustomerId(request));
				map.put("customer_id2", LogUtil.getIpAddr(request));
			}else{
				map.put("customer_id", LogUtil.getIpAddr(request));
			}
			map.put("laiyuan", "cping");//标识是从产品选择的订单
			customerService.saveOrderToShopping(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  客户收货页面
	 * @param request
	 * @return
	 */
	@RequestMapping("shouhuo")
	public String shouhuo(HttpServletRequest request) {
		String seeds_ids=request.getParameter("seeds_id");
		List<Map<String,Object>> listinfo= customerService.findOrderBySeeds_id(seeds_ids);
		request.setAttribute("listinfo", listinfo);
		return "pc/customer/shouhuo";
	}
	/**
	 * 获取签名信息
	 * @param request
	 * @return
	 */
	@RequestMapping("shouhuoed")
	public String shouhuoed(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String seeds_ids=request.getParameter("seeds_id");
		String item_id=request.getParameter("item_id");
//		for (String item_id: item_ids.split(",")) {
			String img=getQianmingImgPath(orderNo, item_id);
			request.setAttribute("img", img);
			if(img!=null){
//				String seeds=FilenameUtils.getBaseName(img);
//				seeds=seeds.replaceAll("\\[", "").replaceAll("\\]", "");
				List<Map<String,Object>> listinfo= customerService.findOrderBySeeds_id(seeds_ids);
				request.setAttribute("listinfo", listinfo);
				img= getFileTextContent(img);
				request.setAttribute("img", img);
//				break;
			}
//		}
		request.setAttribute("show", "show");
		return "/pc/customer/shouhuo";
	}
	/**
	 *  客户评价
	 * @param request
	 * @return
	 */
	@RequestMapping("pingjia")
	public String pingjia(HttpServletRequest request) {
//		Map<String,Object> map=getKeyAndValue(request);
//		String orderNo=map.get("orderNo")+"/"+map.get("item_id");
//		String type=request.getParameter("type");
//		if(StringUtils.isNotBlank(type)){
//			type=type+"/";
//		}else{
//			type="";
//		}
//		String content=getFileTextContent(getOrderEvalFilePath(request, orderNo,type));
//		if(StringUtils.isNotBlank(content)){
//			JSONObject json=JSONObject.fromObject(content);
//			request.setAttribute("map", json);
//		}
//		File dest=new File(getComIdPath(request)+"eval/"+type+map.get("orderNo")+"/"+map.get("item_id"));
//		if(dest.exists()){
//			File[] files=dest.listFiles();
//			List<String> list=new ArrayList<String>();
//			for (File item : files) {
//				String[] path=item.getPath().split("\\\\"+getComId());
//				String pathimg=getComId()+path[1];
//				pathimg=pathimg.replaceAll("\\\\", "/");
//				list.add(pathimg);
//			}
//			request.setAttribute("list", list);
//		}
		return "pc/customer/pingjia";
	}
	/**
	 * 客户确认收货
	 * @param request
	 * @return
	 */
	@RequestMapping("confimShouhuo")
	@ResponseBody
	public ResultInfo confimShouhuo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getCustomer(request).get("clerk_name"));
			map.put("customer_id", getUpperCustomerId(request));
			customerService.confimShouhuo(map);
			if (isMapKeyNull(map, "orders")) {
				String path=getQianmingImgPath(map.get("orderNo"), map.get("item_id"));
				saveFile(path, map.get("img").toString());
			}else{
				JSONArray jsons=JSONArray.fromObject(map.get("orders"));
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json= jsons.getJSONObject(i);
					String path=getQianmingImgPath(json.get("orderNo"), json.get("item_id"));
					saveFile(path, map.get("img").toString());
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
	 * 对账单签字确认
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmQianming")
	@ResponseBody
	public ResultInfo confirmQianming(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isNotMapKeyNull(map, "list")) {
				if (isNotMapKeyNull(map, "img")) {
					map.put("customer_id", getCustomerId(request));
					map.put("customerName", getCustomer(request).get("clerk_name"));
					JSONArray jsons=JSONArray.fromObject(map.get("list"));
					String filename=customerService.confirmQianming(jsons,map);
					StringBuffer path=new StringBuffer(getComIdPath(request));
					path.append("qianming/ard/").append(filename).append(".log");
					saveFile(path.toString(), map.get("img").toString());
					success = true;
				}else{
					msg="没有获取到签名数据!";
				}
			}else{
				msg="没有获取到对账数据!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 获取订单支付状态 用于微信二维码的时候能够识别用户已经支付成功
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderPayState")
	@ResponseBody
	public ResultInfo getOrderPayState(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=customerService.getOrderPayState(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取com_id根据地址从
	 * @param request
	 * @return
	 */
	@RequestMapping("getComIdByAddress")
	@ResponseBody
	public Map<String,Object> getComIdByAddress(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return customerService.getComIdByAddress(map);
	}
	/**
	 *  获取发货地址列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getFHDZList")
	@ResponseBody
	public JSONArray getFHDZList(HttpServletRequest request) {
		Map<String,Object> map= customerService.getCustomerByCustomer_id(getUpperCustomerId(request), getComId());
		
		JSONArray jsons=new JSONArray();
		String content=getFileTextContent(getFHDZPath(request,getUpperCustomerId(request)));
		if (StringUtils.isNotBlank(content)) {
			if (!content.startsWith("[")) {
				content="["+content+"]";
			}
			jsons=JSONArray.fromObject(content);
		}else{
			JSONObject json=new JSONObject();
			json.put("lxr", map.get("corp_sim_name"));
			json.put("lxPhone", map.get("user_id"));
			json.put("fhdz", map.get("FHDZ"));
			jsons.add(json);
		}
		return jsons;
	}
	/**
	 * 保存发货地址
	 * @param fhdzlist 发货地址列表
	 * @return
	 */
	@RequestMapping("saveFHDZList")
	@ResponseBody
	public ResultInfo saveFHDZList(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String fhdzlist=request.getParameter("fhdzlist");
			if (fhdzlist==null) {
				fhdzlist="";
			}
			//非默认收货地址保存到外部文件
			saveFile(getFHDZPath(request, getUpperCustomerId(request)), fhdzlist);
			JSONArray jsons=JSONArray.fromObject(fhdzlist);
			//取出默认项,将其数据存入到数据库中
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				if (json.getBoolean("mr")) {
					json.put("customer_id", getUpperCustomerId(request));
					json.put("com_id", getComId());
					customerService.updateFhdz(json);
					break;
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
	 * 获取流程名称列表
	 */
	@RequestMapping("getProcessNameList")
	@ResponseBody
	public List<String> getProcessNameList(HttpServletRequest request) {
		
		return super.getProcessNameList(request);
	}
	/**
	 * 客户通知拉货司机
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeDrive")
	@ResponseBody
	public ResultInfo noticeDrive(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getCustomer(request).get("clerk_name"));
			String[] pros=getProcessName(request);
			int index=0;
			for (int i = 0; i < pros.length; i++) {
				if (pros[i].contains("安排司机")) {
					index=i;
					break;
				}
			}
			map.put("Status_OutStore", pros[index+1]);
			customerService.noticeDrive(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 提交对账单备注信息
	 * @param request
	 * @return
	 */
	@RequestMapping("postdzdMemo")
	@ResponseBody
	public ResultInfo postdzdMemo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			customerService.postdzdMemo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 更新订单状态
	 * @param request
	 * @return
	 */
	@RequestMapping("updateOrderStatus")
	@ResponseBody
	public ResultInfo updateOrderStatus(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			customerService.updateOrderStatus(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 更新订单数量
	 * @param request
	 * @return
	 */
	@RequestMapping("updateOrderSdOq")
	@ResponseBody
	public ResultInfo updateOrderSdOq(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "memo_color")) {
				map.remove("memo_color");
			}
			msg=customerService.updateOrderSdOq(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	///////////
	/**
	 *  客户下计划页面
	 * @param request
	 * @return
	 */
	@RequestMapping("plan")
	public String plan(HttpServletRequest request) {
		Object planEndTime=systemParams.checkSystem("planEndTime");
		if(planEndTime==null||planEndTime==""){
			planEndTime="21:00:00";
		}
		planEndTime.toString().replaceAll(":", "");
		request.setAttribute("planEndTime",planEndTime);
		return "pc/customer/plan";
	}
	
	/**
	 *  计划历史查询
	 * @param request
	 * @return
	 */
	@RequestMapping("historyPlan")
	public String historyPlan(HttpServletRequest request) {
		return "pc/qingyuan/historyPlan";
	}
	
	/**
	 *  获取带计划数的产品分页列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getPlanProductPage")
	@ResponseBody
	public PageList<Map<String,Object>> getPlanProductPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
//		String sourceBegin=DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), 1))+" 00:00:00.000";
//		map.put("beginTime", sourceBegin);
//		String sourceEnd=DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), 1))+" 23:59:59.999";
//		map.put("endTime",  sourceEnd); 
		map.put("beginTime", DateTimeUtils.dateToStr(DateUtils.addDays(new Date(), 1)));
		map.put("customer_id", getUpperCustomerId(request));
		return customerService.getPlanProductPage(map);
	}
	
	/**
	 *  获取带有昨日计划数和零售价的产品详细
	 * @param request
	 * @return
	 */
	@RequestMapping("getPlanProductInfo")
	@ResponseBody
	public Map<String,Object> getPlanProductInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
//		String sourceBegin=DateTimeUtils.dateToStr()+" 00:00:00.000";
//		map.put("beginTime", sourceBegin);
//		String sourceEnd=DateTimeUtils.dateToStr()+" 23:59:59.999";
//		map.put("endTime",  sourceEnd); 
		map.put("beginTime",  DateTimeUtils.dateToStr()); 
		map.put("one", 1);
		map.put("customer_id", getUpperCustomerId(request));
		return customerService.getPlanProductInfo(map);
	}
	
	@RequestMapping("generateRegisterQRCode")
	@ResponseBody
	public ResultInfo generateRegisterQRCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if (getCustomer(request)==null) {
				msg="请先登录!";
			}else{
				Map<String,Object> map=getKeyAndValue(request);
				Integer width=MapUtils.getInteger(map, "width");
				Integer height=MapUtils.getInteger(map, "height");
				Integer image_width=MapUtils.getInteger(map, "image_width");
				Integer image_height=MapUtils.getInteger(map, "image_height");
				String type=MapUtils.getString(map,"type");
				if (getCustomerId(request).startsWith("CS1C001")) {
					 type="sell";
				}else if(getCustomerId(request).startsWith("CS1C002")){
					 type="buy";
				}else{
					if (StringUtils.isBlank(type)) {
						type="";
					}
				}
				String qrurl=systemParams.checkSystem("urlPrefix").toString();
				qrurl=qrurl+"/login/register.do?type="+type+"&com_id="+getComId()+"&ver="+Math.random();
				Object upper=map.get("upper");
				if (upper!=null) {
					qrurl=qrurl+"&upper_customer_id="+getCustomerId(request);
				}
				String logopath=getComIdPath(request)+"image/logo.png";
				File file=new File(logopath);
				if (!file.exists()) {
					String logo=request.getParameter("logo");
					if (StringUtils.isBlank(logo)) {
						logo="pc/image/logo.png";
					}
					logopath=getRealPath(request)+logo;
				}
				msg="/"+getComId()+"/register/"+getCustomerId(request)+"/register.jpg";
				QRCodeUtil.generateQRCode(qrurl, width, height,logopath, image_width, image_height,getRealPath(request)+msg);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取支付中订单的seeds_id,用于在微信支付调用结束后生成付款单数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getSimpleOrderPayInfo")
	@ResponseBody
	public Map<String,Object> getSimpleOrderPayInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("customer_id", getUpperCustomerId(request));
		List<String> list=customerService.getPayOrderProductName(map);
		List<Integer> infos=customerService.getPayOrderSeeds_id(map);
		map= customerService.getSimpleOrderPayInfo(map);
		if (map!=null&&!map.isEmpty()) {
			//检查金币表中是否有金币与订单相关并已抵扣,有就删除掉
			map.put("customer_id", getUpperCustomerId(request));
			map.put("com_id", getComId());
			clientService.checkJinbiDikou(map);
			//更新客户优惠券中锁定优惠券为未使用
			clientService.checkYhq(map);
			String orderNo=customerService.getOrderNo("销售收款", getComId(request));
			map.put("orderNo", orderNo);
			saveFile(getPayOrderInfo(request, orderNo), infos.toString());
			StringBuffer names=new StringBuffer();
			for (String name : list) {
				names.append(name).append(",");
			}
			map.put("item_name", names.substring(0, names.length()-1));
		}
		return map;
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("updateFHDZToOrder")
	@ResponseBody
	public ResultInfo updateFHDZToOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("type", "消费");
			map.put("customer_id", getUpperCustomerId(request));
			if(isNotMapKeyNull(map, "jinbi")){
				msg=clientService.saveJinbiInfo(map);
			}
			if(isNotMapKeyNull(map, "yhqNo")){
				msg=clientService.saveUseYhqInfo(map);
			}
			msg=customerService.updateFHDZToOrder(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	
	/**
	 * 获取客户自己的付款列表
	 * @param request
	 * @return
	 */
	@RequestMapping("collectionConfirmList")
	@ResponseBody
	public PageList<Map<String,Object>> collectionConfirmList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("customer_id", getUpperCustomerId(request));
		PageList<Map<String,Object>> pages= customerService.collectionConfirmList(map);
		for (Iterator<Map<String, Object>> iterator = pages.getRows()
				.iterator(); iterator.hasNext();) {
			Map<String, Object> item = iterator.next();
			String img=getComId()+"/certificate/"+item.get("recieved_id")+".jpg";
			File destFile=new File(getRealPath(request)+img);
			if (destFile.exists()) {
				item.put("img","../"+img);
			}
		}
		return pages;
	}
	/**
	 * 删除付款记录
	 * @param request
	 * @return
	 */
	@RequestMapping("delPayInfo")
	@ResponseBody
	public ResultInfo delPayInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=customerService.delPayInfo(map);
			if(msg==null){
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 保存编辑后的支付信息
	 * @param request
	 * @return
	 */
	@RequestMapping("saveEditPayInfo")
	@ResponseBody
	public ResultInfo saveEditPayInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=customerService.saveEditPayInfo(map);
			if(msg==null){
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取客户订单附件列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getAddFileList")
	@ResponseBody
	public List<Map<String,Object>> getAddFileList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		File file=new File(getComIdPath(request)+"addFile/"+getUpperCustomerId(request));
		if (file.exists()&&file.isDirectory()) {
			String[] files=file.list();
			if(files!=null&&files.length>0){
				List<Map<String,Object>> list=new ArrayList<>();
				long begin=0;
				long end=0;
				if (isNotMapKeyNull(map, "beginTime")) {
					begin=DateTimeUtils.strToDate(map.get("beginTime").toString()).getTime();
				}
				if (isNotMapKeyNull(map, "endTime")) {
					end=DateTimeUtils.strToDateTime(map.get("endTime").toString()).getTime();
				}
				for (String path : files) {
					String time=path.split("\\.")[0];
					Map<String,Object> info=new HashMap<>();
					Date date=new Date(Long.parseLong(time));
					if (date.getTime()>begin||date.getTime()<end) {
						info.put("time", DateTimeUtils.dateTimeToStr(date));
						info.put("url", "/"+map.get("com_id")+"/addFile/"+getCustomerId(request)+"/"+path);
						list.add(info);
					}
				}
				return list;
			}
		}
		return null;
	}
	
	@RequestMapping("noticeSales")
	@ResponseBody
	public ResultInfo noticeSales(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("customer_id",getUpperCustomerId(request));
			Map<String,String> info=customerService.getSalesInfo(map);
			writeLog(request,getUpperCustomerId(request), getCustomer(request).get("clerk_name")+"", "客户上传订单附件");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 写操作日志
	 * @param request
	 * @param content 操作内容
	 * @return
	 */
	@RequestMapping("writeOperatingLog")
	@ResponseBody
	public ResultInfo writeOperatingLog(HttpServletRequest request,String content) {
		boolean success = false;
		String msg = null;
		try {
			if (StringUtils.isNotBlank(content)) {
				writeLog(request,getCustomerId(request), getCustomer(request).get("clerk_name")+"", content);
				success = true;
			}else{
				msg="没有操作内容!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}
