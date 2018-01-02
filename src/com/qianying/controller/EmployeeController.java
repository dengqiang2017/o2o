package com.qianying.controller;

import java.io.File;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
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
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.page.CustomerQuery;
import com.qianying.page.PageList;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IProductService;
import com.qianying.service.IProductionManagementService;
import com.qianying.service.ISystemParamsService;
import com.qianying.service.IUserService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.InitConfig;
import com.qianying.util.Kit;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;
import com.qianying.util.QRCodeUtil;
import com.qianying.util.Sign;
import com.qianying.util.WeixinUtil;
import com.qq.weixin.mp.aes.AesException;
import com.qq.weixin.mp.aes.WXBizMsgCrypt;

@Controller
@RequestMapping("/employee")
public class EmployeeController extends FilePathController {
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
	private IProductionManagementService productionManagementService;
	@Autowired
	private ISystemParamsService systemParamsService;
	
	/**
	 * 跳转到员工菜单页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/employee")
	public String employee(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		map.put("clerk_id", getEmployeeId(request));
		Integer oa = employeeService.getOACount(map);
		request.setAttribute("oa", oa);
		// 从配置文件中读取该员工有哪些模块可以使用
		// 2.获取权限文件中对应的权限
		Map<String, Object> mapval = getTxtKeyVal(request,
				getEmployeeId(request));
		request.setAttribute("auth", mapval);
		request.getSession().setAttribute("auth", mapval);
		if("001".equals(getComId())){
			request.setAttribute("systemSet", true);
		}
		getSystemAndIndexName(request);
		//需要先给登录者设置权限
		String url=tourl(request);
		if (StringUtils.isNotBlank(url)) {
			return url;
		}
		return "pc/employee/employeeNew";
	}
	/**
	 *  
	 * @param request
	 * @return
	 * @throws AesException 
	 */
	@RequestMapping("weixinfw")
	@ResponseBody
	public String weixinfw(HttpServletRequest request) throws AesException {
		Map<String, Object> map = getKeyAndValue(request);
		LoggerUtils.error(map);
//		WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(WeiXinServiceUtil.sToken,
//				WeiXinServiceUtil.sEncodingAESKey, WeiXinServiceUtil.getWeixinParam(map.get("com_id")+"", "corpid"));
		// 解析出url上的参数值如下：
//		String msg_signature = request.getParameter("msg_signature");// "5c45ff5e21c57e6ad56bac8758b79b1d9ac89fd3";
//		if (StringUtils.isBlank(msg_signature)) {
//			msg_signature=request.getParameter("signature");
//		}
//		String timestamp = request.getParameter("timestamp");// "1409659589";
//		String nonce = request.getParameter("nonce");// "263014780";
		String sEchoStr = request.getParameter("echostr");// "P9nAzCzyDtyTWESHep1vC5X9xho/qYX3Zpb4yKa9SKld1DsH3Iyt3tP3zNdtp+4RPcs8TgAE7OaBO+FZXvnaqQ==";
		return sEchoStr;
	}
	
	@RequestMapping("weixin")
	@ResponseBody
	public String weixin(HttpServletRequest request) throws Exception {
		// String sToken = "dengqiang";
		// String sCorpID = "wx85d539a0dd7dd4d9";
		// String sEncodingAESKey =
		// "ZCXEBykpurC1V54VOmRnDvyJM1LUwEmIgwxhmQujG1r";///消息发送-回调模式-回调URL及密钥
		Map<String, Object> map = getKeyAndValue(request);
		LoggerUtils.info(map);
		WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(WeixinUtil.sToken,
				WeixinUtil.sEncodingAESKey, WeixinUtil.getWeixinParam(map.get("com_id")+"", "corpid"));
		// wxcpt.VerifyURL(msgSignature, new Date().getTime(),
		// WeixinUtil.sToken, WeixinUtil.sEncodingAESKey);
		/*
		 * ------------使用示例一：验证回调URL---------------企业开启回调模式时，企业号会向验证url发送一个get请求
		 * 假设点击验证时，企业收到类似请求： GET
		 * /cgi-bin/wxpush?msg_signature=5c45ff5e21c57e6ad56bac8758b79b1d9ac89fd3
		 * &
		 * timestamp=1409659589&nonce=263014780&echostr=P9nAzCzyDtyTWESHep1vC5X9xho
		 * %
		 * 2FqYX3Zpb4yKa9SKld1DsH3Iyt3tP3zNdtp%2B4RPcs8TgAE7OaBO%2BFZXvnaqQ%3D%
		 * 3D HTTP/1.1 Host: qy.weixin.qq.com
		 * 
		 * 接收到该请求时，企业应
		 * 1.解析出Get请求的参数，包括消息体签名(msg_signature)，时间戳(timestamp)，随机数字串(
		 * nonce)以及公众平台推送过来的随机加密字符串(echostr), 这一步注意作URL解码。 2.验证消息体签名的正确性 3.
		 * 解密出echostr原文，将原文当作Get请求的response，返回给公众平台
		 * 第2，3步可以用公众平台提供的库函数VerifyURL来实现。
		 */
		// 解析出url上的参数值如下：
		String msg_signature = request.getParameter("msg_signature");// "5c45ff5e21c57e6ad56bac8758b79b1d9ac89fd3";
		if (StringUtils.isBlank(msg_signature)) {
			msg_signature=request.getParameter("signature");
		}
		String timestamp = request.getParameter("timestamp");// "1409659589";
		String nonce = request.getParameter("nonce");// "263014780";
		String echostr = request.getParameter("echostr");// "P9nAzCzyDtyTWESHep1vC5X9xho/qYX3Zpb4yKa9SKld1DsH3Iyt3tP3zNdtp+4RPcs8TgAE7OaBO+FZXvnaqQ==";
		String sEchoStr = null; // 需要返回的明文
		String PackageId = null; // 需要返回的明文
		try {
			String xml=wxcpt.DecryptMsg(msg_signature, timestamp, nonce, getXmlToRequest(request));
			PackageId=saveChatInfo(xml, request);
		} catch (Exception e) {
			LoggerUtils.info("[DecryptMsg]"+e.getMessage());
		}
		try {
			if (echostr != null && nonce != null) {
				sEchoStr =echostr;// wxcpt.VerifyURL(msg_signature, timestamp,nonce, echostr);
				LoggerUtils.info("verifyurl echostr: " + sEchoStr);
			}
			// 验证URL成功，将sEchoStr返回
			// HttpUtils.SetResponse(sEchoStr);
		} catch (Exception e) {
			// 验证URL失败，错误原因请查看异常
			LoggerUtils.info("VerifyURL"+e.getMessage());
		}
		if (StringUtils.isNotBlank(PackageId)) {
			return PackageId;
		}else{
			return sEchoStr;
		}
	}
	/**
	 * 保存会话信息
	 * @param json
	 * @param request
	 */
	private void saveChatLog(JSONObject json, HttpServletRequest request) {
		String Event=json.getString("Event");
		if ("create_chat".equals(Event)) {
			JSONObject ChatInfo=json.getJSONObject("ChatInfo");
			String UserList=ChatInfo.getString("UserList");
			String[] users=UserList.split("|");
			ChatInfo.put("UserList",Arrays.toString(users));
			saveCreate_chat(request,ChatInfo);
		}else{
			updateJsonFile(json.getString("ChatId"), request, new WeixinUtil());
		}
	}
	/**
	 * 保存会话相关事件信息
	 * @param xml
	 * @param request
	 * @return 回调包ID  PackageId
	 */
	private String saveChatInfo(String xml, HttpServletRequest request) {
		JSONObject json=xml2JSON(xml);
		LoggerUtils.info(json);
		if (json.has("PackageId")) {
			if (json.has("Event")) {
				saveChatLog(json, request);
			}else{
				saveChatMsgLog(json, request);
			}
			return json.getString("PackageId");
		}
		return null;
	}
//	  
//	 public static void main(String[] args) {
//		String xml="<xml>"+
//"<AgentType><![CDATA[chat]]></AgentType>                "+
//"<ToUserName><![CDATA[wx582baadfc7c9859b]]></ToUserName>"+
//"<ItemCount>2</ItemCount>                               "+
//"<PackageId>429496768422634516</PackageId>              "+
//"<Item>                                                 "+
//"<FromUserName><![CDATA[dvdq]]></FromUserName>          "+
//"<CreateTime>1448252027</CreateTime>                    "+
//"<MsgType><![CDATA[text]]></MsgType>                    "+
//"<Content><![CDATA[中午好]]></Content>                     "+
//"<MsgId>67456518272</MsgId>                             "+
//"<Receiver>                                             "+
//"<Type>group</Type>                                     "+
//"<Id>bf68d</Id>                                         "+
//"</Receiver>                                            "+
//"</Item>                                                "+
//"<Item>                                                 "+
//"<FromUserName><![CDATA[dvdq]]></FromUserName>          "+
//"<CreateTime>1448252027</CreateTime>                    "+
//"<MsgType><![CDATA[text]]></MsgType>                    "+
//"<Content><![CDATA[中午好]]></Content>                     "+
//"<MsgId>67456518272</MsgId>                             "+
//"<Receiver>                                             "+
//"<Type>group</Type>                                     "+
//"<Id>bf68d</Id>                                         "+
//"</Receiver>                                            "+
//"</Item>                                                "+
//"</xml>";
//		saveCreate_chat(xml2JSON(xml));
//	}
	 
	/**
	 * 取得签名signature
	 * 
	 * @param timestamp
	 * @param nonceStr
	 * @param url
	 * @return
	 */
	@RequestMapping("getSignature")
	@ResponseBody
	public String getSignature(HttpServletRequest request) {
		String timestamp =null;// request.getParameter("timestamp");
		String nonceStr = "dengqiang";
		String url = request.getParameter("url");
		WeixinUtil wei=new WeixinUtil();
		if (StringUtils.isBlank(timestamp)) {
			timestamp = new Date().getTime() + "";
			timestamp=timestamp.substring(0, timestamp.length()-3);
		}
		String jsapi_ticket=wei.jsapi_ticket(getComId());
		String da=request.getParameter("type");
		Map<String,String> map=null;
		if (da!=null) {
			  map=Sign.signDa(jsapi_ticket, nonceStr, timestamp, url);
		}else{
			  map=Sign.sign(jsapi_ticket, nonceStr, timestamp, url);
		}
		return map.get("signature")+","+map.get("timestamp")+","+WeixinUtil.getWeixinParam(getComId(), "corpid")+","+nonceStr;
	}
	/**
	 *  身份验证接口
	 * @param request
	 * @return
	 */
	@RequestMapping("getOatuh")
	@ResponseBody
	public String getOatuh(HttpServletRequest request) {
		String code=request.getParameter("code");
		WeixinUtil wei=new WeixinUtil();
		String result=wei.getOatuh(code,getComId());
		JSONObject json=JSONObject.fromObject(result);
		try {
			String url="https://qyapi.weixin.qq.com/cgi-bin/user/convert_to_userid?access_token="+wei.getAccessToken(getComId());
			JSONObject jsonu=new JSONObject();
			jsonu.put("openid", json.getString("OpenId"));
			result=wei.postData(url, jsonu);
		} catch (Exception e) {
		}
		LoggerUtils.error(result);
		return result;
	}
////////////////////////////
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
	map.put("name", name);
	List<Map<String,Object>> list=employeeService.loginList(map);
	if(list.size()==0){
		return null;
	}
	for (Iterator<Map<String,Object>> iterator = list.iterator(); iterator.hasNext();) {
		Map<String, Object> map2 = iterator.next();
		Object password = map2.get("pwd");
		if (password != null && password.toString().length() < 32) {//小于32位密码未加密存储
			password = MD5Util.MD5(password.toString());
		}
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
Map<String,Object> map=employeeService.checkLogin(name,com_id);
if(map!=null){
Object password = map.get("user_password");
if (password != null && password.toString().length() < 32) {//小于32位密码未加密存储
	password = MD5Util.MD5(password.toString());
}
if (!pwd.equalsIgnoreCase(password.toString())) {
	msg="用户名或者密码错误!";
}else{
	if (getCustomer(request) != null ) {
		 request.getSession().removeAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
	}
	if (StringUtils.isBlank(com_name)) {
		setComId(request, managerService);
	}else{
		setComId(request);
	}
	map.remove("user_password");
	Map<String, Object> mapPersonnel = employeeService
			.getPersonnel(map.get("clerk_id").toString(),
					com_id);
	if (mapPersonnel != null) {
		if (mapPersonnel.get("dept_id") != null) {
			String dept_id = mapPersonnel.get("dept_id")
					.toString();
			map.put("dept_id", dept_id);
		}
		map.put("weixinID", mapPersonnel.get("weixinID"));
		map.put("type_id", mapPersonnel.get("type_id"));
		if(isNotMapKeyNull(mapPersonnel, "headship")){
			map.put("headship", mapPersonnel.get("headship"));
		}
		map.put("personnel", mapPersonnel);
		map.put("com_id", com_id);
		map.put("clerk_name",
				mapPersonnel.get("clerk_name"));// clerk_name
	}
	if ("001".equals(name)) {
		map.put("clerk_id", "001");
		mapPersonnel = new HashMap<String, Object>();
		mapPersonnel.put("clerk_name", "001");
		map.put("personnel", mapPersonnel);// clerk_name
		map.put("clerk_name", "001");// clerk_name
	}
	request.getSession().setAttribute(
			ConfigFile.SESSION_USER_INFO, map);
	Map<String,Object> mapsms=systemParamsService.getSystemParamsByComId(getComId());
	request.getSession().setAttribute("isAutoFind",mapsms.get("isAutoFind"));
	request.getSession().setAttribute("o2o", mapsms.get("o2o"));
	request.getSession()
			.setAttribute("prefix", getPrefix());
	request.setAttribute("ver", InitConfig.getNewVer());
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
///////////////////////////
	/**
	 * 员工登录
	 * 
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
		if (getCustomer(request) != null ) {
			 request.getSession().removeAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
		} 
		if (StringUtils.isBlank(name)) {
			msg = "请输入用户名!";
		} else if (StringUtils.isBlank(pwd)) {
			msg = "请输入密码!";
		}else {
			String comId = setComId(request, managerService);
			name = name.trim();
			int i = 1;
			if (!"001".equals(name)) {
				i = userService.getWorking_status(name, comId);// 检查员工是否离职
			}
			if (i > 0) {
				Map<String, Object> map = employeeService.checkLogin(name,
						comId);
				if (map == null) {
					msg = "用户不存在!";
				} else {
					String password = null;
					try {
						password = map.get("user_password").toString();
						if (password.length() < 32) {
							password = MD5Util.MD5(password);
						}
					} catch (Exception e) {
					}
					if (password == null || !pwd.equalsIgnoreCase(password)) {
						msg = "用户名或密码错误!";
					} else {
						Map<String, Object> mapPersonnel = employeeService
								.getPersonnel(map.get("clerk_id").toString(),
										comId);
						if (mapPersonnel != null) {
							if (mapPersonnel.get("dept_id") != null) {
								String dept_id = mapPersonnel.get("dept_id")
										.toString();
								map.put("dept_id", dept_id);
							}
							map.put("weixinID", mapPersonnel.get("weixinID"));
							map.put("type_id", mapPersonnel.get("type_id"));
							map.put("mySelf_Info", mapPersonnel.get("mySelf_Info"));
							if(isNotMapKeyNull(mapPersonnel, "headship")){
								map.put("headship", mapPersonnel.get("headship"));
							}
							map.put("clerk_name",
									mapPersonnel.get("clerk_name"));// clerk_name
							mapPersonnel.remove("user_password");
							mapPersonnel.remove("weixinID");
							mapPersonnel.remove("type_id");
							mapPersonnel.remove("headship");
							mapPersonnel.remove("dept_id");
							mapPersonnel.remove("com_id");
//							mapPersonnel.remove("clerk_name");
							mapPersonnel.remove("clerk_id");
							mapPersonnel.remove("user_id");
							map.put("personnel", mapPersonnel);
						}
						map.put("com_id", comId);
						map.remove("user_password");
						if ("001".equals(name)) {
							map.put("clerk_id", "001");
							mapPersonnel = new HashMap<String, Object>();
							mapPersonnel.put("clerk_name", "001");
							map.put("personnel", mapPersonnel);// clerk_name
							map.put("clerk_name", "001");// clerk_name
						}
						String openid=request.getParameter("openid");
						if(StringUtils.isNotBlank(openid)&&openid.length()>=20){
							map.put("openid", openid);
							managerService.updateOpenid(map);
						}
						request.getSession().setAttribute(
								ConfigFile.SESSION_USER_INFO, map);
						Map<String,Object> mapsms=systemParamsService.getSystemParamsByComId(getComId());
						request.getSession().setAttribute("isAutoFind",mapsms.get("isAutoFind"));
						request.getSession().setAttribute("o2o", mapsms.get("o2o"));
						request.getSession()
								.setAttribute("prefix", getPrefix());
						success = true;
					}
				}
			} else {
				msg = "你已经离职不能再继续使用本系统!";
			}
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
			success = employeeService.checkPhone(phone,request.getParameter("com_id"));
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 保存员工注册信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveUser")
	@ResponseBody
	public ResultInfo saveUser(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		Integer error_code = 0;
		String user_id = request.getParameter("userId");
		String user_password = request.getParameter("pwd");
		String corp_name=request.getParameter("corp_name");
		String openid=request.getParameter("openid");
		// String dept_id=request.getParameter("dept_id");
		Map<String,Object> check=checkRegisterParam(request, user_id);
		if (MapUtils.getBoolean(check, "b")) {
			if (employeeService.checkPhone(user_id,request.getParameter("com_id"))) {
				Map<String, Object> map = new HashMap<String, Object>();
				if (StringUtils.isNotBlank(corp_name)) {
					map.put("clerk_name", corp_name);
				}else{
					map.put("clerk_name", user_id);
				}
				map.put("movtel", user_id);
				map.put("weixinID", user_id);
				map.put("com_id", setComId(request));
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
				map.put("openid", openid);
				employeeService.save(map);
				/////////////////////////////
				Map<String,Object> mapc=new HashMap<String, Object>();
				mapc.put("com_id", getComId());
				mapc.put("user_id", user_id);
				mapc.put("clerk_id", clerk_id);
				mapc.put("if_O2O", 2);
				mapc.put("i_browse","Y");
				mapc.put("usr_grp_id", 0);
				mapc.put("user_password", MD5Util.MD5(user_password));
				LoggerUtils.info(mapc);
				managerService.insertSql(mapc, 0, "ctl09003", null, clerk_id);
				/////////////////////////////
				Object agentDeptId=systemParamsService.checkSystem("agentDeptId","1");
				postInfoToweixinComId(map, "员工",agentDeptId);
				success = true;
			} else {
				error_code = 105;// 手机号已经存在
			}
		}
		return new ResultInfo(success, msg, error_code);
	}

	/**
	 * 选择客户页面
	 * 
	 * @param request
	 * @param type
	 *            操作类型 0-代客户选择产品,1-代下订单,2-销售合同
	 * @return 选择客户页面
	 */
	@RequestMapping("selectClient")
	public String selectClient(HttpServletRequest request, Integer type) {
		CustomerQuery query = new CustomerQuery();
		query.setCom_id(getComId(request));
		request.setAttribute("customers", customerService.findQuery(query));
		request.setAttribute("type", type);
		// productService.getProductClassPage(new ProductClassQuery());
		if (type == 0) {
			return "pc/employee/selectClient";
		}
		if (type == 2) {
			return "pc/employee/selectClient_xieyi";
		} else {
			return "pc/employee/selectClient_order";
		}
	}

	/**
	 * 跳转到员工为客户添加品种添加或者修改页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("add")
	public String add(HttpServletRequest request) {
		proPageList(productService, request);
		request.setAttribute("order", "add");
		Map<String,Object> map= systemParamsService.getSystemParamsByComId(getComId());
		request.setAttribute("moreMemo", map.get("moreMemo"));
		request.setAttribute("urlPrefix", map.get("urlPrefix"));
		request.setAttribute("com_id", getComId());
		return ConfigFile.PC_OR_PHONE + "employee/add";
	}

	/**
	 * 跳转到员工为客户添加品种添加或者修改页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("add_old")
	public String add_old(HttpServletRequest request) {
		proPageList(productService, request);
		request.setAttribute("order", "add");
		return ConfigFile.PC_OR_PHONE + "employee/add_old";
	}

	/**
	 * 代下订单页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("order")
	public String order(HttpServletRequest request) {
		// proPageList(productService, request);
		request.setAttribute("order", "order");
		Map<String,Object> map= systemParamsService.getSystemParamsByComId(getComId());
		request.setAttribute("beginTime", DateTimeUtils.dateToStr(DateUtils
				.addDays(new Date(), -MapUtils.getIntValue(map, "dayTime_Of_SdPlan"))));
		request.setAttribute("begin", map.get("dayN1_SdOutStore_Of_SdPlan"));
		request.setAttribute("endTime",map.get("dayN2_SdOutStore_Of_SdPlan"));
		request.setAttribute("time", map.get("dayTime_Of_SdPlan"));
		request.setAttribute("orderplan", map.get("orderplan"));
		request.setAttribute("accnIvt", map.get("accnIvt"));
		request.setAttribute("moreMemo", map.get("moreMemo"));
		return ConfigFile.PC_OR_PHONE + "employee/order";
	}

	/**
	 * 订单跟踪页面
	 * @param request
	 * @return
	 */
	@RequestMapping("orderTracking")
	public String orderTracking(HttpServletRequest request ) {
		request.setAttribute("processName",getProcessNameNew(request));
		//获取收款单号对应的订单信息
		String recieved_id=request.getParameter("recieved_id");
		request.setAttribute("seeds", getOrderSeedsByRecieved(recieved_id));
		request.setAttribute("urlPrefix", ConfigFile.urlPrefix);
		request.setAttribute("com_id", getComId());
		String thead=getFileTextContent(getOrderTrackThead(request));
		if (StringUtils.isBlank(thead)) {
			StringBuilder builder=new StringBuilder("redirect:/weihu/");
			builder.append("otthead.html?com_id="+getComId()+"&ver="+getVer()); 
			return builder.toString();
		}
		request.setAttribute("thead",JSONArray.fromObject(thead));
		request.setAttribute("orderTrackConfig", orderTrackConfig(request));
		return "pc/employee/orderTrackingNew";
	}
	/**
	 * 获取订单流程跟踪中是否在下拉框中显示[备货中]和[生产中]状态
	 * @param request
	 * @return
	 */
	private JSONObject orderTrackConfig(HttpServletRequest request) {
		String msg=getFileTextContent(getComIdPath(request)+"orderProcessConfig.json");
		if(StringUtils.isNotBlank(msg)){
			return JSONObject.fromObject(msg);
		}
		return null;
	}

	/**
	 * 获取订单跟踪表头
	 * @param request
	 * @return
	 */
	private File getOrderTrackThead(HttpServletRequest request) {
		File file=new File(getComIdPath(request)+"orderTrackThead.json");
		mkdirsDirectory(file);
		return file;
	}

	@RequestMapping("orderTrackingNew")
	public String orderTrackingNew(HttpServletRequest request) {
		setProcessName(request);
		//获取收款单号对应的订单信息
		String recieved_id=request.getParameter("recieved_id");
		request.setAttribute("seeds", getOrderSeedsByRecieved(recieved_id));
		request.setAttribute("urlPrefix", ConfigFile.urlPrefix);
		request.setAttribute("com_id", getComId());
		return "pc/employee/orderTracking";
	}
	
	
	/**
	 * 订单跟踪记录
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("orderTrackingRecord")
	@ResponseBody
	public PageList<Map<String, Object>> orderTrackingRecord(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		request.setAttribute("type", "order");
		if (!isMapKeyNull(map, "seeds_id")) {
			String ids= map.get("seeds_id").toString().replace("[", "").replace("]", "");
			ids=ids.replaceAll("%20", "");
			map.put("seeds_id",ids);
		}
		if(!isMapKeyNull(map, "seeds")){
			String ids= map.get("seeds_id").toString().replace("[", "").replace("]", "");
			map.put("seeds_id",ids);
		}
		if(isMapKeyNull(map, "page")){
			map.put("page", 0);
		}
		getMySelf_Info(request, map);
		Object kuanOrHuo=systemParamsService.checkSystem("kuanOrHuo","0");
		map.put("kuanOrHuo",kuanOrHuo);
		String thead=getFileTextContent(getOrderTrackThead(request));
		if(StringUtils.isNotBlank(thead)){
			JSONArray jsons=JSONArray.fromObject(thead);
			StringBuffer buffer=new StringBuffer();
			for (int i = 0; i < jsons.size(); i++) {
				JSONObject json=jsons.getJSONObject(i);
				if(json.getBoolean("find")){
					if ("num".equals(json.get("type"))) {
						buffer.append("isnull(").append(json.get("findid")).append(",0) as ").append(json.get("id")).append(",");
					}else if("datetime".equals(json.get("type"))){
						buffer.append("convert(varchar(19),").append(json.get("findid")).append(",121) as ").append(json.get("id")).append(",");
					}else if("date".equals(json.get("type"))){
						buffer.append("convert(varchar(10),").append(json.get("findid")).append(",121) as ").append(json.get("id")).append(",");
					}else{
						buffer.append("ltrim(rtrim(isnull(").append(json.get("findid")).append(",''))) as ").append(json.get("id")).append(",");
					}
				}
			}
			map.put("filed", buffer.substring(0, buffer.length()-1));
		}
		return customerService.orderTrackingRecord(map);
	}

//	/**
//	 * 销售合同页面
//	 * 
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("contract")
//	public String contract(HttpServletRequest request) {
//		proPageList(productService, request);
//		return ConfigFile.PC_OR_PHONE + "employee/contract";
//	}
//
//	/**
//	 * 额度审批
//	 * 
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("guarantee")
//	public String guarantee(HttpServletRequest request) {
//
//		return ConfigFile.PC_OR_PHONE + "employee/guarantee";
//	}
//
//	/**
//	 * 代办事项
//	 * 
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("todo")
//	public String todo(HttpServletRequest request) {
//
//		return ConfigFile.PC_OR_PHONE + "todo";
//	}

	/**
	 * 计划添加或修改
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("plan")
	public String plan(HttpServletRequest request) {
		proPageList(productService, request);
		request.setAttribute("type", request.getParameter("type"));
		Map<String,Object> map=systemParamsService.getSystemParamsByComId(getComId());
		request.setAttribute("time", map.get("dayTime_Of_SdPlan"));
		request.setAttribute("moreMemo", map.get("moreMemo"));
		return "pc/employee/plan";
	}

	/**
	 * 计划列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("planlist")
	public String planlist(HttpServletRequest request) {
		CustomerQuery query = new CustomerQuery();
		query.setCom_id(getComId(request));
		request.setAttribute("customers", customerService.findQuery(query));
		request.setAttribute("type", request.getParameter("type"));
		request.setAttribute("order", "plan");
		// /计划页面默认显示的时间
		Map<String,Object> map= systemParamsService.getSystemParamsByComId(getComId());
		Date now = new Date();
		Date anotherDate = DateTimeUtils.strToDateTime(DateTimeUtils
				.dateToStr() +" "+ map.get("dayTime_Of_SdPlan"));
		String N1Time = null;
		if (now.compareTo(anotherDate) != 1) {// /anotherDate大于now为1开始日期减1
			N1Time = DateTimeUtils.dateToStr(DateUtils.addDays(new Date(),
					MapUtils.getIntValue(map,"dayN1_SdOutStore_Of_SdPlan")));
		} else {// 结束日期加1
			N1Time = DateTimeUtils.dateToStr(DateUtils.addDays(new Date(),
					MapUtils.getIntValue(map,"dayN1_SdOutStore_Of_SdPlan") + 1));
		}
		request.setAttribute("N1Time", N1Time);
		request.setAttribute("time", map.get("dayTime_Of_SdPlan"));
		String moreMemo=systemParamsService.checkSystem("moreMemo","false");
		request.setAttribute("moreMemo", moreMemo);
		return "pc/employee/planlist";
	}

	/**
	 * 销售计划准确率
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salePlanAccuracy")
	public String salePlanAccuracy(HttpServletRequest request) {
		return "pc/employee/salePlanAccuracy";
	}

	/**
	 * 我的客户
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("myClient")
	public String myClient(HttpServletRequest request) {
		return "pc/employee/myClient";
	}

	// ///////////////////////////////////////////////////
	/**
	 * 使用额度审批
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("quotaApproval")
	public String quotaApproval(HttpServletRequest request) {
		return "pc/employee/quotaApproval";
	}

	/**
	 * 我的协同
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("myOA")
	public String myOA(HttpServletRequest request) {
		return "pc/employee/myOA";
	}

	/**
	 * 我的协同
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("coordination")
	public String coordination(HttpServletRequest request) {
		return "pc/employee/coordination";
	}

	/**
	 * 保存审批记录
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOpinion")
	@ResponseBody
	public ResultInfo saveOpinion(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String employee = getEmployeeId(request);
			String spyij = request.getParameter("spyij");
			String spyijcontent = request.getParameter("spyijcontent");
			String ivt_oper_listing = request.getParameter("ivt_oper_listing");
			Map<String, String> map = getQueryKeyAndValue(request);
			map.put("employee", employee);
			map.put("spyij", spyij);
			map.put("spyijcontent", spyijcontent);
			map.put("ivt_oper_listing", ivt_oper_listing);
			map.put("processName", getProcessName(request, 0));
			employeeService.saveOpinion(map);
			// //
			StringBuffer pathname =getSpTemp(request);
			StringBuffer dest =getSpFilePath(request, ivt_oper_listing);
			
			File file = new File(pathname.toString());
			if (file.exists()) {
				File[] files = file.listFiles();
				if (files != null && files.length > 0) {
					for (File srcFile : files) {
						File destFile = new File(dest.append(srcFile.getName())
								.toString());
						if (srcFile.exists() && srcFile.isFile()) {
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
	 * 获取员工自己的待办事项列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getOAList")
	@ResponseBody
	public PageList<Map<String, Object>> getOAList(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		map.put("clerk_id", getEmployeeId(request));
		if (map.get("page") == null) {
			map.put("page", 1);
		}
		if (map.get("rows") == null) {
			map.put("rows", 50);
		}
		if (map.get("item_name") != null) {
			map.put("item_name", "%" + map.get("item_name") + "%");
		}
		if (map.get("OA_who") != null) {
			map.put("OA_who", "%" + map.get("OA_who") + "%");
		}
		if (map.get("store_date") != null) {
			map.put("store_date2", map.get("store_date") + " 23:59:59");
		}
		map.put("approval_YesOrNo", map.get("yesOrNo"));
		if (map.get("type_id") == "") {
			map.remove("type_id");
		}
		return employeeService.getOAList(map);
	}
 
	
	/**
	 * 获取审批详细记录
	 * 
	 * @param request
	 * @param seeds_id
	 * @return
	 */
	@RequestMapping("getOAInfo")
	@ResponseBody
	public Map<String, Object> getOAInfo(HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		Map<String, Object> mapinfo = employeeService.getOAInfo(map,getComIdPath(request));
		// 获取该审批的文件//文件存放规则 phone/img/审批编号/员工编号/文件列表
		if ("客户欠条审批".equals(mapinfo.get("item_name"))) {
			mapinfo.put("ioupath","../" + getComId(request) + "/"
							+ mapinfo.get("customer_id") + "/iou/"
							+ mapinfo.get("ivt_oper_listing") + ".html");
		}
		return mapinfo;
	}

	@RequestMapping("getFileList")
	@ResponseBody
	public List<String> getFileList(HttpServletRequest request) {
		List<String> list = new ArrayList<String>();
		// String type=request.getParameter("type");
		String approvaler = request.getParameter("OA_whom");
		if(StringUtils.isBlank(approvaler)){
			approvaler = request.getParameter("OA_who");
		}
		String ivt_oper_listing = request.getParameter("ivt_oper_listing");
		
		StringBuffer buffer = new StringBuffer().append("sp/");
		buffer.append(approvaler).append("/").append(ivt_oper_listing)
				.append("/");
		
		File file = new File(getComIdPath(request)+ buffer.toString());
		File[] files = file.listFiles();
		if (files != null && files.length > 0) {
			for (File file2 : files) {
				if (file2.exists() && file2.isFile()) {
					list.add("../"+getComId()+"/" + buffer.toString()+file2.getName());
				}
			}
		}
		return list;
	}

	// /**
	// * 获取订单页面查询数据
	// *
	// * @param map
	// * @return
	// */
	// private String getOrderParams(Map<String, Object> map) {
	// map.remove("page");
	// map.remove("rows");
	// Object[] keys = map.keySet().toArray();
	// Collection<Object> c = map.values();
	// Object[] vals = c.toArray();
	// StringBuffer wheresql = new StringBuffer();
	// for (int i = 0; i < vals.length; i++) {
	// if (vals[i] != null &&vals[i] !="" && keys[i] != null && keys[i] != ""
	// && keys[i].toString().length() > 2) {
	// if ("goods_origin".equals(keys[i])
	// || "item_style".equals(keys[i])
	// || "type_id".equals(keys[i])
	// || "com_id".equals(keys[i])) {
	// wheresql.append(" and t1.").append(keys[i]).append("=")
	// .append("'").append(vals[i]).append("'");
	// } else {
	// wheresql.append(" and t1.").append(keys[i])
	// .append(" like ").append("'%").append(vals[i])
	// .append("%'");
	// }
	// }
	// }
	// return wheresql.toString();
	// }

	/**
	 * 我的协同--协同流程
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("edspalready")
	public String edspalready(HttpServletRequest request) {
		return "pc/employee/edspalready";
	}

	/**
	 * 我的协同--协同流程信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("edspalreadyInfo")
	public String edspalreadyInfo(HttpServletRequest request) {
		return "pc/employee/edspalreadyInfo";
	}

	/**
	 * 保存申请审批
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveCoordination")
	@ResponseBody
	public ResultInfo saveCoordination(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValue(request);
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss",
					Locale.CHINA);
			Integer opidn = customerService.getApprovalNo(format
					.format(new Date()));
			String sd_order_id = "SPNR" + format.format(new Date())
					+ String.format("%03d", opidn);
			map.put("sd_order_id", sd_order_id);
			map.put("ivt_oper_listing", sd_order_id);
			map.put("mainten_clerk_id", getEmployeeId(request));
			map.put("maintenance_datetime", getNow());
			map.put("store_date", getNow());

			map.put("OA_who", getEmployeeId(request));
			employeeService.saveCoordination(map);
			// ///
			StringBuffer pathname = getSpTemp(request);
			
			StringBuffer dest =getSpFilePath(request, sd_order_id);
			
			File file = new File(pathname.toString());
			if (file.exists()) {
				File[] files = file.listFiles();
				if (files != null && files.length > 0) {
					for (File srcFile : files) {
						File destFile = new File(dest.append(srcFile.getName())
								.toString());
						if (srcFile.exists() && srcFile.isFile()) {
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
	 * 客户计划正确率
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("clientSalePlan")
	public String clientSalePlan(HttpServletRequest request) {
		return "pc/employee/clientSalePlan";
	}

	/**
	 * 销售计划
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salePlan")
	public String salePlan(HttpServletRequest request) {
		return "pc/employee/salePlan";
	}

	/**
	 * 销售计划--详细
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salePlanInfo")
	public String salePlanInfo(HttpServletRequest request) {
		return "pc/employee/salePlanInfo";
	}

	/**
	 * 销售计划--报表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salePlanReport")
	public String salePlanReport(HttpServletRequest request) {
		return "pc/employee/salePlanReport";
	}

	/**
	 * 工作交接
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("workHandover")
	public String workHandover(HttpServletRequest request) {
		return "pc/employee/leave/workHandover";
	}

	/**
	 * 员工离职
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("leaveOffice")
	public String leaveOffice(HttpServletRequest request) {
		return "pc/employee/leave/leaveOffice";
	}

	/**
	 * 员工离职交接
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("leaveTransfer")
	public String leaveTransfer(HttpServletRequest request) {
		return "pc/employee/leave/leaveTransfer";
	}

	/**
	 * 员工离职交接
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("shiftHandover")
	public String shiftHandover(HttpServletRequest request) {
		return "pc/employee/leave/shiftHandover";
	}

	/**
	 * 处理员工离职,离职交接,换岗交接
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveLeave")
	@ResponseBody
	public ResultInfo saveLeave(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String change_flag = request.getParameter("change_flag"); // 1、离职
																		// 2、离职交接
																		// 3、换岗交接
			String clerk_id_a = request.getParameter("clerk_id_a"); // 离职员工
			String clerk_id_b = request.getParameter("clerk_id_b"); // 待交接员工
			if (StringUtils.isNotBlank(change_flag)) {
				if (StringUtils.isNotBlank(clerk_id_a)) {
					if ("2".equals(change_flag) || "3".equals(change_flag)) {
						if (StringUtils.isNotBlank(clerk_id_b)) {
							Map<String, Object> map = new HashMap<String, Object>();
							map.put("com_id", getComId(request));
							map.put("change_flag", change_flag);
							map.put("clerk_id_a", clerk_id_a);
							map.put("clerk_id_b", clerk_id_b);
							employeeService.saveLeave(map);
							success = true;
						} else {
							msg = "请选择被交接人!";
						}
					} else if ("1".equals(change_flag)) {
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("com_id", getComId(request));
						map.put("change_flag", change_flag);
						map.put("clerk_id_a", clerk_id_a);
						map.put("clerk_id_b", "");
						employeeService.saveLeave(map);
						success = true;
					} else {
						msg = "执行操作类型错误!";
					}
				} else {
					msg = "请选择员工!";
				}
			} else {
				msg = "请选择执行操作类型!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	// ///////////////////////////////////////
	/**
	 * 采购管理
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("purchase")
	public String purchase(HttpServletRequest request) {
		return "pc/employee/purchase";
	}

	// /**
	// *
	// * @param request
	// * @return
	// */
	// @RequestMapping("")
	// public String (HttpServletRequest request) {
	// return "pc/employee/";
	// }
	//
	/**
	 * 获取客户列表根据员工id
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getCustomerByClerk_id")
	@ResponseBody
	public PageList<Map<String, Object>> getCustomerByClerk_id(
			HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upper", request.getParameter("upper"));
		map.put("com_id", getComId(request));
		map.put("clerk_id", getEmployeeId(request));
		String keyname = request.getParameter("keyname");
		String page = request.getParameter("page");
		String rows = request.getParameter("rows");
		if (StringUtils.isBlank(page)) {
			page = "0";
		}
		if (StringUtils.isBlank(rows)) {
			rows = "10";
		}
		map.put("page", page);
		map.put("rows", rows);
		if (StringUtils.isBlank(keyname)) {
			map.put("keyname", "");
		} else {
			keyname = "%" + keyname + "%";
			map.put("keyname", keyname);
		}
//		Map<String,Object> mapper =(Map<String, Object>) getEmployee(request).get("personnel");
//		Object mySelf_Info=mapper.get("mySelf_Info");
//		if(mySelf_Info!=null){
//			if("否".equals(mySelf_Info.toString().trim())){
//				map.put("mySelf_Info",false);//是否为客户带下订单,
//			}else{
//				map.put("mySelf_Info",true);//是否为客户带下订单,
//			}
//		}else{
//			map.put("mySelf_Info",false);//是否为客户带下订单,
//		}
		getMySelf_Info(request, map);
		return employeeService.getCustomerByClerk_id(map);
	}

	/**
	 * 销售计划报表详细,导出,打印
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("planReport")
	public String planReport(HttpServletRequest request) {
		int weeksnum = DateTimeUtils.getWeekNum(getNow());
		request.setAttribute("weeksnum", weeksnum);
		return "pc/employee/planReport";
	}

	@RequestMapping("updatePlanFlag")
	@ResponseBody
	public ResultInfo updatePlanFlag(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValueQuery(request);
			employeeService.updatePlanFlag(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 保存订单跟踪操作状态
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveHandle")
	@ResponseBody
	public ResultInfo saveHandle(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String[] seeds = request.getParameterValues("seeds_id[]");
			// String[]
			// customer_ids=request.getParameterValues("customer_ids[]");
//			String type = request.getParameter("type");
//			if (StringUtils.isNotBlank(type)) {
				Map<String, Object> map = getKeyAndValue(request);
				if (seeds != null && seeds.length > 0) {
					map.put("seeds", Arrays.toString(seeds).replaceAll("[", "").replaceAll("]", ""));
				}else if(map.get("seeds_id")!=null){
					map.put("seeds", map.get("seeds_id"));
				}else {
					msg = "请至少选择一项数据";
				}
//				if (isMapKeyNull(map, "new")) {
//					msg = employeeService.saveHandle(map);
//				}else{
					employeeService.saveOrderHandle(map);
//				}
				success = true;
//			} else {
//				msg = "请选择操作类型";
//			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	// ///////////////////////微信相关/////////////
	/**
	 * 导入部门数据到微信通讯录中
	 * 
	 * @param request
	 * @param dept_id
	 *            查询该部门下的所有 为空就查询整个表
	 * @return
	 */
	@RequestMapping("deptToWeixin")
	@ResponseBody
	public ResultInfo deptToWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValueQuery(request);
			List<Map<String, Object>> list = employeeService
					.getDeptToWeixin(map);
			WeixinUtil weixin = new WeixinUtil();
			StringBuffer buffer = new StringBuffer();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map2 = list.get(i);
				buffer.append(weixin.createDept(map2.get("dept_name"),
						map2.get("parentid"), i, map2.get("id"),getComId()));
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 员工数据导入到微信中
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("employeeToWeixin")
	@ResponseBody
	public ResultInfo employeeToWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValueQuery(request);
			List<Map<String, Object>> list = null;
			int deptId=1001;
			if ("employee".equals(map.get("type"))) {
				list = employeeService.getEmployeeToWeixin(map);
				deptId=1002;
			} else if ("vendor".equals(map.get("type"))) {
				deptId=1003;
				 list=employeeService.getVendorToWeixin(map);
			} else if ("driver".equals(map.get("type"))) {
				deptId=1004;
				 list=employeeService.getDriverToWeixin(map);
			} else if ("dian".equals(map.get("type"))) {
				deptId=1005;
				 list=employeeService.getDriverToWeixin(map);
			}
			else {
				list = customerService.getCustomerToWeixin(map);
			}
			// ///项微信通讯录中写入部门//// 
			// //////////
			StringBuffer buffer = new StringBuffer();
			WeixinUtil weixin = new WeixinUtil();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map2 = list.get(i);
				if (map2.get("userid") != null) {
					if (map2.get("weixinID") != null) {
						map2.put("weixinid", map2.get("userid"));
						map2.put("userid", map2.get("weixinID"));
					}
					int[] dept={deptId};
					map2.put("department",  dept);
					JSONObject json = JSONObject.fromObject(map2);
					buffer.append(weixin.saveEmployee(json, "create",getComId()));
				}
			}
			msg=buffer.toString();
//			writeLog(request, "同步数据到微信", msg);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 发送消息通过微信
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("sendMsgByWeixin")
	@ResponseBody
	public ResultInfo sendMsgByWeixin(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String content = request.getParameter("content");
			String clerk_id = request.getParameter("clerk_id");
			if (StringUtils.isNotBlank(clerk_id)) {
				if (StringUtils.isNotBlank(content)) {
					WeixinUtil wei = new WeixinUtil();
					msg = wei.sendMessage(content, clerk_id, null, null);
					if ("ok".equals(msg)) {
						success = true;
					}
				} else {
					msg = "请输入发送消息内容!";
				}
			} else {
				msg = "请选择发送人!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 邀请成员关注
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("invite_send")
	@ResponseBody
	public ResultInfo invite_send(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String weixinID = request.getParameter("weixinID");
			WeixinUtil wei = new WeixinUtil();
			msg = wei.invite_send(weixinID,getComId());
			
			JSONObject json =wei.getErrcodeToZh(msg);
			if ("60119".equals(json.getString("errcode"))) {
				msg = json.getString("errmsg");
				employeeService.updateWeixinInvite(weixinID);
			}else{
				msg=json.getString("errmsg");
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 客户收款确认
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("collectionConfirm")
	public String collectionConfirm(HttpServletRequest request) {

		return "pc/employee/collectionConfirm";
	}

	/**
	 * 收款确认列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("collectionConfirmList")
	@ResponseBody
	public PageList<Map<String, Object>> collectionConfirmList(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		if (!"001".equals(getEmployeeId(request))) {
			getDept_idInfoQuery(request, map, "customer_id", "customer_id.sql",
					"customer_id", "t1.", employeeService);
		}
		PageList<Map<String, Object>> pages = employeeService
				.collectionConfirmList(map);
		for (Iterator<Map<String, Object>> iterator = pages.getRows()
				.iterator(); iterator.hasNext();) {
			Map<String, Object> item = iterator.next();
			Object recieved = getRecievedMemo(request, item.get("recieved_id"),
					item.get("customer_id").toString());
			if (recieved != null) {
				item.put("recievedPath","../"+getComId()+"/"
								+ recieved.toString().split("\\\\"+getComId())[1]
										.replaceAll("\\\\", "/"));
			}
		}
		return pages;
	}

	/**
	 * 更新收款确认
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("collConfirm")
	@ResponseBody
	public ResultInfo collConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String, Object> map = getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("dept_id", getEmployee(request).get("dept_id"));
			map.put("clerk_name", getEmployee(getRequest()).get("clerk_name"));
			JSONArray jsons= getProcessNameNew(request);
			map.put("Status_OutStore",jsons.get(1));
			employeeService.collConfirm(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 跳转欠条列表页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("ioulist")
	public String ioulist(HttpServletRequest request) {
		return "pc/ioulist";
	}

	/**
	 * 获取欠条列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getIouList")
	@ResponseBody
	public List<String> getIouList(HttpServletRequest request) {
		String customer_id = request.getParameter("customer_id");
		if (StringUtils.isBlank(customer_id)) {
			return null;
		}
		return getIouList(request, customer_id);
	}

	// ////////////////////////////////////////////////////
//	@RequestMapping("weixinAccountSyn")
//	@ResponseBody
//	public ResultInfo weixinAccountSyn(HttpServletRequest request) {
//		boolean success = false;
//		String msg = null;
//		try {
//			Map<String, Object> map = getKeyAndValue(request);
//			WeixinUtil wei = new WeixinUtil();
//			String depts = wei.getDeptList(null);
//			String com_id = map.get("com_id").toString();
//			if (StringUtils.isNotBlank(depts)) {
//				LoggerUtils.info(depts);
//				if (!depts.startsWith("[")) {
//					depts = "[" + depts + "]";
//				}
//				boolean client = false;
//				boolean gys = false;
//				boolean employee = false;
//				Integer clientId = null;
//				Integer gysId = null;
//				Integer employeeId = null;
//				// String clientName=null;
//				JSONArray deptsJson = JSONArray.fromObject(depts);
//				List<Integer> deptId = new ArrayList<Integer>();
//				for (int i = 0; i < deptsJson.size(); i++) {
//					JSONObject json = deptsJson.getJSONObject(i);
//					Map<String, Object> dept = new HashMap<String, Object>();
//					dept.put("com_id", com_id);
//					Integer id = json.getInt("id");
//					String name = json.getString("name")+"";
//					if (name.contains("??")) {
//						throw new RuntimeException("中文乱码");
//					}
//					Integer parentid = json.getInt("parentid");
//					Integer order = json.getInt("order");
//					dept.put("id_weixin", id);
//					dept.put("name_weixin", name);
//					dept.put("parentid_weixin", parentid);
//					dept.put("order_weixin", order);
//					Map<String, Object> mapdept = employeeService
//							.getDeptByName(dept);
//					dept.put("name_weixin", name + "%");
//					if (name.contains("客户")) {// 查询是否有包含客户字样的客户
//						client = true;
//						clientId = id;
//					} else if (name.contains("供应商")) {
//						gys = true;
//						gysId = id;
//					} else {
//						deptId.add(id);
//					}
//					if (name.contains("员工")) {
//						employee = true;
//						employeeId = id;
//					}
//					if (mapdept != null) {
//						dept.put("sort_id", mapdept.get("sort_id"));
//						employeeService.updateDeptToWeixin(dept);
//					} else {
//						// if (StringUtils.isNotBlank(name)) {
//						// String upper_dept_id=null;
//						// if (parentid>0) {
//						// upper_dept_id=employeeService.getDeptUpperIdByid(dept);
//						// }
//						// String
//						// sort_id=getSortId("ctl00701","DE",managerService);
//						// dept.put("sort_id", sort_id);
//						// dept.put("dept_id", sort_id);
//						// dept.put("upper_dept_id", upper_dept_id);
//						// dept.put("dept_name", name+"_微信");
//						// dept.put("dept_sim_name", name);
//						// employeeService.saveDeptToWeixin(dept);
//						// }
//					}
//					LoggerUtils.msgToSession(request, "exceprogress",
//							"部门数据已处理:" + deptsJson.size() + "/" + i);
//				}
//				if (!employee) {
//					// /部门不存在就创建一个
//					LoggerUtils.msgToSession(request, "exceprogress",
//							"创建员工所在部门");
//					try {
//						employeeId = Integer.parseInt(wei.creatEmployeeDept());
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//				}
//				for (Integer dept_id : deptId) {
//					String employees = wei.getEmployeeList(dept_id, 1, 0);
//					if (!employees.startsWith("[")) {
//						employees = "[" + employees + "]";
//					}
//					JSONArray jsons = JSONArray.fromObject(employees);
//					for (int i = 0; i < jsons.size(); i++) {
//						JSONObject json = jsons.getJSONObject(i);
//						Map<String, Object> empl = new HashMap<String, Object>();
//						empl.put("com_id", com_id);
//						LoggerUtils.info(json);
//						String userid = json.getString("userid");// 微信账号
//						String name = json.getString("name");
//						// String department=json.getString("department");//部门id
//						// //
//						getJsonVal(empl, json, "movtel", "mobile"); // 手机号
//
//						String movtel = "";
//						if (empl.get("movtel") != null) {
//							movtel = empl.get("movtel").toString();
//						} else if (StringUtils.isNotBlank(userid)) {
//							movtel = userid;
//						} else if (empl.get("weixin") != null) {
//							movtel = empl.get("weixin").toString();
//						}
//						empl.put("movtel", movtel);
//						String clerk_id = employeeService
//								.getPersonnelByMobile(empl);
//						getJsonVal(empl, json, "movtel", "mobile"); // 手机号
//						empl.put("weixinID", userid);// 微信号
//						getJsonVal(empl, json, "weixin", "weixinid");
//						getJsonVal(empl, json, "headship", "position"); // 职务
//						getJsonVal(empl, json, "weixinStatus", "status"); // 状态
//						getJsonVal(empl, json, "e_mail", "email"); // 状态
//						if (StringUtils.isNotBlank(clerk_id)) {
//							empl.put("clerk_id", clerk_id);
//							employeeService.updateWeixinId(empl);
//						} else {
//							// Map<String,Object> dept=new HashMap<String,
//							// Object>();
//							// dept.put("com_id", com_id);
//							// if (department.startsWith("[")) {
//							// department=department.replaceAll("\\[", "");
//							// department=department.replaceAll("\\]", "");
//							// if (department.contains(",")) {
//							// department=department.split(",")[0];
//							// }
//							// }
//							// dept.put("id_weixin", department);
//							// //根据部门id查询部门内码
//							// Map<String,Object>
//							// mapdept=employeeService.getDeptByName(dept);
//							// if (mapdept!=null) {
//							// }
////							empl.put("dept_id", "DEWXQYH");
////							Integer seedsId = managerService.getMaxSeeds_id(
////									"ctl00801", "seed_id");
////							clerk_id = String.format("E%06d", seedsId + 1);
////							empl.put("clerk_id", clerk_id);
////							empl.put("self_id", clerk_id);
////							empl.put("clerk_name", name);
////							empl.put("user_password", "123qwe");
////							empl.put("working_status", "1");
////							employeeService.savePersonnelToWeixin(empl);
//						}
//						LoggerUtils.msgToSession(request, "exceprogress",
//								"员工数据已处理:" + jsons.size() + "/" + i);
//					}
//				}
//				// //////////////同步客户的数据/////
//				LoggerUtils.msgToSession(request, "exceprogress", "处理客户数据");
//				if (!client) {
//					// /部门不存在就创建一个
//					LoggerUtils.msgToSession(request, "exceprogress",
//							"创建客户所在部门");
//					try {
//						clientId = Integer.parseInt(wei.creatClientDept());
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//				}
//
//				// //同步客户信息到系统中////
//				String employees = wei.getEmployeeList(clientId, 1, 0);
//				if (!employees.startsWith("[")) {
//					employees = "[" + employees + "]";
//				}
//				JSONArray jsons = JSONArray.fromObject(employees);
//				LoggerUtils.info(jsons);
//				for (int j = 0; j < jsons.size(); j++) {
//					JSONObject json = jsons.getJSONObject(j);
//					Map<String, Object> customer = new HashMap<String, Object>();
//					customer.put("com_id", com_id);
//					LoggerUtils.info(json);
//					String userid = json.getString("userid");// 微信账号
//					String name = json.getString("name");//
//					// String department=json.getString("department");//部门id
//					// //
//					getJsonVal(customer, json, "movtel", "mobile"); // 手机号
//					getJsonVal(customer, json, "weixin", "weixinid"); // 微信号
//					String movtel = "";
//					if (customer.get("movtel") != null) {
//						movtel = customer.get("movtel").toString();
//					} else if (StringUtils.isNotBlank(userid)) {
//						movtel = userid;
//					} else if (customer.get("weixin") != null) {
//						movtel = customer.get("weixin").toString();
//					} else {
//						Map<String, Object> mapcus = customerService
//								.getCustomerByCustomer_id(movtel, getComId());
//						customer.put("weixinID", userid);// 微信账号
//						// getJsonVal(customer, json, "headship", "position");
//						// //职务
//						getJsonVal(customer, json, "weixinStatus", "status"); // 状态
//						getJsonVal(customer, json, "e_mail", "email"); // 状态
//						// /////////////////////////
//						if (mapcus != null && mapcus.get("customer_id") != null) {
//							managerService.insertSql(customer, 1, "sdf00504",
//									"customer_id", mapcus.get("customer_id")
//											.toString());
//						} else {
//							String customer_id = getSortId("sdf00504", "C",
//									managerService);
//							customer.put("user_id", customer.get("movtel"));
//							customer.put("tel_no", customer.get("movtel"));
//							customer.put("user_password", "888888");
//							customer.put("corp_name", name);
//							customer.put("corp_sim_name", name);
//							customer.put("clerk_name", name);
//							customer.put("license_type", "微信号");
//							customer.put("upper_customer_id", "CS1");
//							customer.put("customer_id", "CS1" + customer_id);
//							managerService.insertSql(customer, 0, "sdf00504",
//									null, null);
//						}
//					}
//					LoggerUtils.msgToSession(request, "exceprogress",
//							"客户数据已处理:" + jsons.size() + "/" + j);
//				}
//				// //////////////供应商/////
//				if (!gys) {
//					// /部门不存在就创建一个
//					LoggerUtils.msgToSession(request, "exceprogress",
//							"创建供应商所在部门");
//					try {
//						gysId = Integer.parseInt(wei.creatGysDept());
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//				}
//
//			}
//			success = true;
//		} catch (Exception e) {
//			msg = e.getMessage();
//			e.printStackTrace();
//		}
//		return new ResultInfo(success, msg);
//	}

	// //////////////////////////
	/**
	 * 备份数据库
	 * 
	 * @param request
	 * @return backup 备份文件路
	 */
	@RequestMapping("backup")
	@ResponseBody
	public ResultInfo backup(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			ClassLoader loader = InitConfig.class.getClassLoader();
			InputStream inStream = loader
					.getResourceAsStream("jdbc.properties");
			Map<String, Object> mapname = Kit.getTxtKeyVal(inStream);

			Map<String, Object> map = new HashMap<String, Object>();
			String path = getBackupFilePath(request);
			File file=new File(path);
			if(!file.getParentFile().exists()){
				file.getParentFile().mkdirs();
			}
			map.put("path", path);
			map.put("databaseName", mapname.get("databaseName"));
			employeeService.backup(map);
			msg = getComId()+"/backup/" + path.split("backup")[1];
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	@RequestMapping("rcovery")
	@ResponseBody
	public ResultInfo rcovery(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String path = request.getParameter("path");
			String sql = "use master　alter database commonwebsite set Offline with ROLLBACK IMMEDIATE;"
					+ "	restore database commonwebsite from disk='"
					+ path
					+ "' WITH RECOVERY;";
//			Map<String, Object> map = new HashMap<String, Object>();
//			map.put("path", path);
//			map.put("databaseName", mapname.get("databaseName"));
//			employeeService.rcovery(path);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 * 销售收款单
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salesReceipts")
	public String salesReceipts(HttpServletRequest request) {

		return "pc/employee/salesReceipts";
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salesReceiptsAdd")
	public String salesReceiptsAdd(HttpServletRequest request) {
		
		return "pc/employee/salesReceiptsAdd";
	}
	/**
	 * 员工收款
	 * @param request
	 * @return
	 */
	@RequestMapping("savePaymoney2")
	@ResponseBody
	public ResultInfo savePaymoney2(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Object orderNo=customerService.getOrderNo("销售收款", getComId(request));
			Calendar c = Calendar.getInstance();
			map.put("finacial_y", c.get(Calendar.YEAR));
			map.put("finacial_m", c.get(Calendar.MONTH));
			map.put("finacial_d", getNow());
			map.put("recieved_direct", "收款");
			map.put("recieved_auto_id",orderNo);
			if (map.get("recieved_id")==null||"".equals(map.get("recieved_id"))) {
				map.put("recieved_id", orderNo);
			}
			Map<String,Object> mapcus= customerService.getCustomerByCustomer_id(map.get("customer_id")+"", getComId());
			Object customerName=mapcus.get("corp_sim_name");
			map.put("customerName", customerName);
			map.put("sum_si_origin", "线下收款-员工");
			map.put("comfirm_flag", "N");
			map.put("recieve_type", "应收款");
			map.put("mainten_clerk_id", getComId(request));
			map.put("mainten_datetime", getNow());
			map.put("ivt_oper_cfm_time", getNow());
//			if (map.get("dept_id")==null) {
//				map.put("dept_id",getEmployee(request).get("dept_id"));
//			}
//			if (map.get("clerk_id")==null) {
//				map.put("clerk_id",getEmployeeId(request));
//			}
			customerService.savePaymoney(map, null);
			writeLog(request,getEmployeeId(request),"客户:"+customerName+"","收款单号:"+orderNo.toString());
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 销售收款单 分页查询
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("salesReceiptsList")
	@ResponseBody
	public PageList<Map<String, Object>> salesReceiptsList(
			HttpServletRequest request) {
		Map<String, Object> map = getKeyAndValueQuery(request);
		return employeeService.salesReceiptsList(map);
	}

	/**
	 * 库存调拨单
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("inventoryAllocation")
	public String inventoryAllocation(HttpServletRequest request) {
		return "pc/employee/inventoryAllocation";
	}

	/**
	 * 期初维护
	 * @param request
	 * @return
	 */
	@RequestMapping("initialMaintenance")
	public String inventoryInit(HttpServletRequest request) {
		return "pc/employee/initialMaintenance";
	}

	/**
	 * 期初库存分页查询
	 * @param request
	 * @return
	 */
	@RequestMapping("initialMaintenancePage")
	@ResponseBody
	public PageList<Map<String,Object>> initialMaintenancePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionManagementService.initialMaintenancePage(map);
	}
	/**
	 *  期初库存信息
	 * @param request
	 * @return
	 */
	@RequestMapping("initialMaintenanceInfo")
	@ResponseBody
	public Map<String,Object> initialMaintenanceInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productionManagementService.initialMaintenanceInfo(map);
	}
	
	/**
	 * 期初应收分页查询
	 * @param request
	 * @return
	 */
	@RequestMapping("initialReceivablePage")
	@ResponseBody
	public PageList<Map<String,Object>> initialReceivablePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionManagementService.initialReceivablePage(map);
	}
	
	/**
	 * 期初应收信息
	 * @param request
	 * @return
	 */
	@RequestMapping("initialReceivableInfo")
	@ResponseBody
	public Map<String,Object> initialReceivableInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return productionManagementService.initialReceivableInfo(map);
	}
	
	/**
	 * 期初应付分页查询
	 */
	@RequestMapping("initialPayablePage")
	@ResponseBody
	public PageList<Map<String,Object>> initialHandlePage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionManagementService.initialPayablePage(map);
	}
	
	/**
	 * 期初库存导出
	 * @param request
	 * @return
	 */
	@RequestMapping("initialMaintenanceExcel")
	@ResponseBody
	public ResultInfo initialMaintenanceExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =productionManagementService.initialMaintenancePage(map).getRows(); 
		    //生成导出excel
		    excelExport(request, list, "库存");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 期初应收导出
	 * @param request
	 * @return
	 */
	@RequestMapping("initialReceivableExcel")
	@ResponseBody
	public ResultInfo initialReceivableExcel(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			//获取要导出的数据
			List<Map<String,Object>> list =productionManagementService.initialReceivablePage(map).getRows(); 
		    //生成导出excel
		    msg=excelExport(request, list, "期初应收");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
 
	/**
	 * 库存调拨单查询
	 * @param request
	 * @return
	 */
	@RequestMapping("inventoryAllocationFind")
	@ResponseBody
	public PageList<Map<String, Object>> inventoryAllocationFind(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return productionManagementService.inventoryAllocationFind(map);
	}
	/**
	 * 每天0点生成签到表
	 */
	@Scheduled(cron = "0 0 1 * * ?" )
	public void GenerateSignBaseTable() {
		 employeeService.GenerateSignBaseTable();
	}
	/**
	 * 微信签到记录生成
	 * @param request
	 * @return
	 */
	@RequestMapping("weixinSign")
	@ResponseBody
	public ResultInfo weixinSign(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String serverId=request.getParameter("serverId");
			String imgUrl=request.getParameter("imgUrl");
			Date d=DateUtils.addSeconds(new Date(), -50);
			String signTime=DateTimeUtils.dateTimeToStr(d);
			SimpleDateFormat format=new SimpleDateFormat("yyyyMMddHHmmss", Locale.CHINA);
			String time=format.format(d);
			if (StringUtils.isNotBlank(serverId)) {
				WeixinUtil wei=new WeixinUtil();
				if(serverId.contains(",")){
					String[] imgs=serverId.split(",");
					for (int i = 0; i < imgs.length; i++) {
						String url="https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="+wei.getAccessToken(getComId())+"&media_id="+imgs[i];
						File destFile=new File(getSignPath(request,time+"_"+i));
						if (!destFile.getParentFile().exists()) {
							destFile.getParentFile().mkdirs();
						}
						wei.getDataImage(url,destFile);
					}
				}else{
					String url="https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="+wei.getAccessToken(getComId())+"&media_id="+serverId;
					File destFile=new File(getSignPath(request,time));
					if (!destFile.getParentFile().exists()) {
						destFile.getParentFile().mkdirs();
					}
					wei.getDataImage(url,destFile);
				}
				success = true;
			}else if(StringUtils.isNotBlank(imgUrl)){
				File srcFile=new File(getRealPath(request)+imgUrl);
				File destFile=new File(getSignPath(request,time));
				FileUtils.moveFile(srcFile, destFile);
				success = true;
			}
			if (success) {
				Map<String,Object> map=getKeyAndValue(request);
				map.put("signTime", signTime);
				map.put("clerk_id", getEmployeeId(request));
				map.remove("serverId");
				employeeService.saveSignInfo(map);
			}else{
				msg="请上传当前位置图";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  上班签到
	 * @param request
	 * @return
	 */
	@RequestMapping("sgin")
	public String sgin(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		//获取当前员工是否已经签到
		map.put("clerk_id", getEmployeeId(request));
		map.put("signDate", DateTimeUtils.dateToStr()); 
		return "pc/employee/sign";
	}
	/**
	 * 业务员签到
	 * @param request
	 * @return
	 */
	@RequestMapping("sellerSgin")
	public String sellerSgin(HttpServletRequest request) {
		return "pc/employee/sellerSgin";
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("sgin2")
	public String sgin2(HttpServletRequest request) {
		return "pc/employee/sign2";
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getImageInfo")
	@ResponseBody
	public Map<String,Object> getImageInfo(HttpServletRequest request) {
		String imgUrl=request.getParameter("imgUrl");
//		imgUrl=imgUrl.replaceFirst("..", "");
		File file=new File(getRealPath(request)+imgUrl);
		if (!file.exists()) {
			throw new RuntimeException("文件未找到!");
		}
		return WeixinUtil.getImageInfo(file);
	}
	
	/**
	 * 记录进入签到页面的时间
	 * @param request
	 * @return
	 */
	@RequestMapping("sign")
	@ResponseBody
	public ResultInfo sign(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			StringBuffer str=new StringBuffer("进入时间");
			str.append(getNow()).append("\n");
			saveFile(getSignLogPath(request), str.toString(),true);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 跳转到签到查看页面-上班签到
	 * @param request
	 * @return
	 */
	@RequestMapping("signinfo")
	public String signinfo(HttpServletRequest request) {
		Map<String, Object> map=getKeyAndValue(request);
		request.setAttribute("depts",managerService.getDeptByUpper_dept_id(map));
		map.put("signFindParam",  getSignFindParam(request));
		return "pc/employee/signinfo";
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("signinfoCount")
	public String signinfoCount(HttpServletRequest request) {
		Map<String, Object> map=getKeyAndValue(request);
		request.setAttribute("depts",managerService.getDeptByUpper_dept_id(map));
		map.put("signFindParam",  getSignFindParam(request));
		return "pc/employee/signinfoCount";
	}
	/**
	 *  跳转到签到查看页面-业务员签到
	 * @param request
	 * @return
	 */
	@RequestMapping("sellerSigninfo")
	public String sellerSigninfo(HttpServletRequest request) {
		Map<String, Object> map=getKeyAndValue(request);
		request.setAttribute("depts",managerService.getDeptByUpper_dept_id(map));
		return "pc/employee/sellerSigninfo";
	}
	/**
	 * 业务员列表更新业务员签到所属客户信息
	 * @param request
	 * @return
	 */
	@RequestMapping("updateSignInfo")
	@ResponseBody
	public ResultInfo saveSignInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.updateSignInfo(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取签到消息列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getSignInfoList")
	@ResponseBody
	public PageList<Map<String,Object>> getSignInfoList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		Date date=DateUtils.addDays(DateTimeUtils.strToDate(map.get("endDateS")+""), 1);
		map.put("endDateS",DateTimeUtils.dateToStr(date));
		Map<String, Object> mapval = getTxtKeyVal(request,
				getEmployeeId(request)); 
		if(!"001".equals(getEmployeeId(request))){
			if(isMapKeyNull(mapval, "signinfoAll")){
				map.put("clerk_id", getEmployeeId(request));
			}
			if(isMapKeyNull(mapval, "signinfoAllDept")){
				map.put("deptId", getEmployee(request).get("dept_id"));
			}
		}
		PageList<Map<String,Object>> pages=employeeService.getSignInfoList(map);
		if (isNotMapKeyNull(map, "yewuyuan")) {
			for (Iterator<Map<String,Object>> iterator = pages.getRows().iterator(); iterator
					.hasNext();) {
				Map<String,Object> item = iterator.next();
				File file=getSignRizhi(request, item);
				if (file.exists()) {
					item.put("rizhipath","/"+ getComId()+getSignRizhiPath(request, item));
				}else{
					item.put("rizhipath", "/"+ getComId()+"/xls/业务人员拜访日志.xlsx");
				}
//				imgPath="/"+event.data.com_id+"/rizhi/"+event.data.clerk_id+"/"+event.data.signDate+"_"+event.data.seeds_id+".xls";
//				rizhipath
				
			}
		}
		return pages;
	}
	
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getSignInfoCount")
	@ResponseBody
	public List<Map<String,Object>> getSignInfoCount(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		Date date=DateUtils.addDays(DateTimeUtils.strToDate(map.get("endDateS")+""), 1);
		map.put("endDateS",DateTimeUtils.dateToStr(date));
		Map<String, Object> mapval = getTxtKeyVal(request,
				getEmployeeId(request)); 
		if(!"001".equals(getEmployeeId(request))){
			if(isMapKeyNull(mapval, "signinfoAll")){
				map.put("clerk_id", getEmployeeId(request));
			}
			if(isMapKeyNull(mapval, "signinfoAllDept")){
				map.put("deptId", getEmployee(request).get("dept_id"));
			}
		}
		return employeeService.getSignInfoCount(map);
	}
	
	/**
	 * 获取签到日志
	 * @param request
	 * @param item
	 * @return
	 */
	private File getSignRizhi(HttpServletRequest request,Map<String,Object> item) {
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append(getSignRizhiPath(request, item));
		File file =new File(path.toString());
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 
	 * @param request
	 * @param item
	 * @return
	 */
	private StringBuffer getSignRizhiPath(HttpServletRequest request,Map<String,Object> item) {
		StringBuffer path=new StringBuffer();
		path.append("/rizhi/").append(item.get("clerk_id")).append("/").
		append(item.get("signDate")).append("_").append(item.get("seeds_id")).append("_业务人员拜访日志.xlsx");
		return path;
	}
	
	/**
	 *  获取当前员工是否已经签到
	 * @param request
	 * @return
	 */
	@RequestMapping("sginedList")
	@ResponseBody
	public List<Map<String,Object>> sginedList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		Date date=DateUtils.addDays(DateTimeUtils.strToDate(map.get("endDateS")+""), 1);
		map.put("endDateS",DateTimeUtils.dateToStr(date));
		return employeeService.sginedList(map);
	}
	/**
	 * 保存员工签到查询时间
	 * @param request
	 * @return
	 */
	@RequestMapping("saveSignFindParam")
	@ResponseBody
	public ResultInfo saveSignFindParam(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String param=request.getParameter("param");
			File file=new File(getComIdPath(request)+"sign/param.json");
			if(!file.getParentFile().exists()){
				file.getParentFile().mkdirs();
			}
			saveFile(file, param);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取签到查询时间参数
	 * @param request
	 * @return
	 */
	@RequestMapping("getSignFindParam")
	@ResponseBody
	public JSONObject getSignFindParam(HttpServletRequest request) {
		File file=new File(getComIdPath(request)+"sign/param.json");
		if(file.exists()){
			String str=getFileTextContent(file);
			if(StringUtils.isNotBlank(str)){
				return JSONObject.fromObject(str);
			}
		}
		return null;
	}
	
	/**
	 * 导出员工签到记录
	 * @param request
	 * @return
	 */
	@RequestMapping("employeeSignExport")
	@ResponseBody
	public ResultInfo employeeSignExport(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			Date date=DateUtils.addDays(DateTimeUtils.strToDate(map.get("endDateS")+""), 1);
			map.put("endDateS",DateTimeUtils.dateToStr(date));
			Map<String, Object> mapval = getTxtKeyVal(request,
					getEmployeeId(request)); 
			if(!"001".equals(getEmployeeId(request))){
				if(isMapKeyNull(mapval, "signinfoAll")){
					map.put("clerk_id", getEmployeeId(request));
				}
				if(isMapKeyNull(mapval, "signinfoAllDept")){
					map.put("deptId", getEmployee(request).get("dept_id"));
				}
			}
			List<Map<String,Object>> list=employeeService.employeeSignExport(map);
			msg=excelExport(request, list, "员工签到");
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 显示员工的签到信息log和图片
	 * @param request
	 * @return
	 */
	@RequestMapping("showSignInfo")
	@ResponseBody
	public Map<String,Object> showSignInfo(HttpServletRequest request) {
		String date=request.getParameter("date");
		if (StringUtils.isBlank(date)) {
			date=DateTimeUtils.dateToStr();
		}
		String clerk_id=request.getParameter("clerk_id");
		Map<String,Object> map=new HashMap<String, Object>();
		File file=new File(getSignPath(request, date, clerk_id));
		if (!file.exists()) {
			return map;
		}
		File[] files=file.listFiles();
		if (files!=null&&files.length>0) {
			List<String> imgs=new ArrayList<String>();
			for (int i = 0; i < files.length; i++) {
				File file2=files[i];
				LoggerUtils.info(file2.getPath());
				String path="../"+getComId()+file2.getPath().split("\\\\"+getComId())[1];
				path=path.replaceAll("\\\\", "/");
				if (path.contains("log")) {
//					log=path;
				}else{
					imgs.add(path);
				}
			}
//			map.put("log", log);
			map.put("imgs", imgs);
		}
		return map;
	}
	/**
	 * 签到页面使用的员工列表页面,已经主动添加去离职人员
	 * @param request
	 * @return
	 */
	@RequestMapping("getPersonnels")
	@ResponseBody
	public PageList<Map<String, Object>> getPersonnelsSignInfo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("working_status", 1);
		if (map.get("date")==null) {
			map.put("date", DateTimeUtils.dateToStr());
		}
		PageList<Map<String,Object>> pages=employeeService.getPersonnelsSignInfo(map);
		List<Map<String,Object>> list=pages.getRows();
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> map2 = iterator.next();
			File file=new File(getSignPath(request, map.get("date")+"", map2.get("clerk_id")+""));
			map2.put("sign", file.exists());
		} 
		return pages;
	}
 /**
 *  跳转库存报表页面
 * @param request
 * @return
 */
@RequestMapping("inventory")
public String inventory(HttpServletRequest request) {
	return "pc/employee/inventory";
}


// ///////////账户充值/////
@RequestMapping("paymoney")
public String paymoney(HttpServletRequest request) {
	 
	return "pc/employee/paymoney";
}
@RequestMapping("getPaymoneyNo")
@ResponseBody
public String getPaymoneyNo(HttpServletRequest request) {
	return customerService.getOrderNo("销售收款", getComId(request));
}
@RequestMapping("getSettlementList")
@ResponseBody
public List<Map<String,Object>> getSettlementList(HttpServletRequest request) {
	Map<String,Object> map=getKeyAndValueQuery(request);
	return customerService.getSettlementList(map);
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
		Calendar c = Calendar.getInstance();
		Map<String, Object> map =getKeyAndValue(request);
		Object orderNo=map.get("orderNo");
		map.put("finacial_y", c.get(Calendar.YEAR));
		map.put("finacial_m", c.get(Calendar.MONTH));
		map.put("finacial_d", getNow());
		map.put("recieved_direct", "收款");
		map.put("recieved_auto_id",orderNo);
		map.put("recieved_id", orderNo);
		
		Map<String,Object> mapcus= customerService.getCustomerByCustomer_id(map.get("customer_id")+"", getComId());
		Object customerName=mapcus.get("corp_sim_name");
		map.put("customerName", customerName);
		
		map.put("recieve_type", map.get("account"));
		map.put("rcv_hw_no", map.get("paystyle"));
		
		StringBuffer buffer=new StringBuffer(customerName+"");
		buffer.append(getNow().split(" ")[0]).append("收款单号");
		buffer.append("[").append(orderNo).append("]").append(map.get("paystyletxt"));
//		map.put("c_memo", buffer.toString());
		
		map.put("sum_si", map.get("amount"));
//		map.put("sum_si_origin",map.get("sum_si_origin"));
		map.put("comfirm_flag", "N");
		map.put("mainten_clerk_id", getComId(request));
		map.put("mainten_datetime", getNow());
		////////////////
		writeLog(request,map.get("customer_id")+"",customerName,"收款单号:"+orderNo);
		map.remove("orderNo");
		map.remove("account");
		map.remove("paystyle");
//		map.remove("paystyletxt");
		map.remove("amount");
		/////////////////
		customerService.savePaymoney(map,null);
		////////保存备注信息到文件中
		File file=getRecievedMemo(request, orderNo,getCustomerId(request));
		saveFile(file, buffer.toString());
		String clerk_id=getEmployeeId(request);
		if (clerk_id==null) {
			clerk_id=getCustomerId(request);
		}
		writeLog(request,clerk_id,"客户:"+customerName ,"收款单号:"+ orderNo);
		success = true;
		
	} catch (Exception e) {
		msg = e.getMessage();
		e.printStackTrace();
	}
	return new ResultInfo(success, msg);
}
/**
 * 付款单:用于供应商直接送货录入付款信息
 * @param request
 * @return
 */
@RequestMapping("savePayByItem")
@ResponseBody
public ResultInfo savePayByItem(HttpServletRequest request) {
	boolean success = false;
	String msg = null;
	try {
		Calendar c = Calendar.getInstance();
		Map<String, Object> map =getKeyAndValue(request);
		map.put("clerk_id",map.get("clerk_id"));
		map.put("dept_id", map.get("dept_id"));
		Object orderNo=map.get("orderNo");
		map.put("finacial_y", c.get(Calendar.YEAR));
		map.put("finacial_m", c.get(Calendar.MONTH));
		map.put("finacial_d", getNow());
		map.put("recieved_direct", "付款");
		map.put("recieved_auto_id",orderNo);
		map.put("recieved_id", orderNo);
		Object customerName=map.get("customerName");
		map.put("customerName", customerName);
		
		map.put("recieve_type", map.get("account"));
		map.put("rcv_hw_no", map.get("paystyle"));
		
		StringBuffer buffer=new StringBuffer(customerName+"");
		buffer.append(getNow().split(" ")[0]).append("付款单号");
		buffer.append("[").append(orderNo).append("]").append(map.get("paystyletxt"));
//		map.put("c_memo", buffer.toString());
		
		map.put("sum_si", map.get("amount"));
//		map.put("sum_si_origin",map.get("sum_si_origin"));
		map.put("comfirm_flag", "Y");
		map.put("mainten_clerk_id", getComId(request));
		map.put("mainten_datetime", getNow());
		////////////////
		writeLog(request,map.get("customer_id")+"","供应商:"+customerName,"付款单号:"+map.toString());
		map.remove("orderNo");
		map.remove("account");
		map.remove("paystyle");
//		map.remove("paystyletxt");
		map.remove("amount");
		/////////////////
		customerService.savePayProcurement(map,null);
		////////保存备注信息到文件中
		File file=getRecievedMemo(request, orderNo,getCustomerId(request));
		saveFile(file, buffer.toString());
		String clerk_id=getEmployeeId(request);
		if (clerk_id==null) {
			clerk_id=getCustomerId(request);
		}
		writeLog(request,clerk_id,"客户:"+customerName ,"收款单号:"+ orderNo);
		success = true;
		
	} catch (Exception e) {
		msg = "服务器异常,请稍后再试!";
		e.printStackTrace();
	}
	return new ResultInfo(success, msg);
}

	/**
	 *  供应商订单页面
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorOrder")
	public String vendorOrder(HttpServletRequest request) {
		return "pc/employee/vendorOrder";
	}

	/**
	 *  获取供应商订单页面
	 * @param request
	 * @return
	 */
	@RequestMapping("vendorOrderList")
	@ResponseBody
	public PageList<Map<String,Object>> vendorOrderList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.vendorOrderList(map);
	}

	/**
	 *  待采购页面
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingOrder")
	public String purchasingOrder(HttpServletRequest request) {
		return "pc/employee/purchasingOrder";
	}
	/**
	 * 保存采购下订单
	 * @param request
	 * @return
	 */
	@RequestMapping("savePurchasingOrder")
	@ResponseBody
	public ResultInfo savePurchasingOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("time", getNow());
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			employeeService.savePurchasingOrder(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 采购订单审核
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingOrderComfirm")
	@ResponseBody
	public ResultInfo purchasingOrderComfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_id", getEmployeeId(request));
			map.put("time", getNow());
			employeeService.purchasingOrderComfirm(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取待采购的数据
	 * @param request
	 * @return
	 */
	@RequestMapping("waitingPurchasingPage")
	@ResponseBody
	public PageList<Map<String,Object>> waitingPurchasingPage(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.waitingPurchasing(map);
	}
	/**
	 * 确认更改供应商
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmGys")
	@ResponseBody
	public ResultInfo confirmGys(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.confirmGys(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("cuidan")
	@ResponseBody
	public ResultInfo cuidan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.cuidan(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 作废采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("zuofeiPOrder")
	@ResponseBody
	public ResultInfo zuofeiPOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			if (isMapKeyNull(map, "item_id")) {
				msg="请输入产品id";
			}else if (isMapKeyNull(map, "st_auto_no")) {
				msg="请输入采购订单编号";
			}else{
				employeeService.zuofeiPOrder(map);
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	//////////////////////////////////////////
	/**
	 *  获取登录员工信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getEmployee")
	@ResponseBody
	public Map<String,Object> getEmployee(HttpServletRequest request) {
		return super.getEmployee(request);
	}
	@RequestMapping("generateRegisterQRCode")
	@ResponseBody
	public ResultInfo generateRegisterQRCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			if (getEmployee(request)==null) {
				msg="请先登录员工!";
			}else{
				Map<String,Object> map=getKeyAndValue(request);
				Integer width=MapUtils.getInteger(map, "width");
				Integer height=MapUtils.getInteger(map, "height");
				Integer image_width=MapUtils.getInteger(map, "image_width");
				Integer image_height=MapUtils.getInteger(map, "image_height");
				String type=MapUtils.getString(map, "type");
				if (type==null) {
					type="";
				} 
				String qrurl=systemParamsService.checkSystem("urlPrefix").toString();
				qrurl=qrurl+"/login/register.do?com_id="+getComId()+"&clerk_id="+getEmployeeId(request)+"&type="+type+"&ver="+Math.random();
				String logopath=getComIdPath(request)+"image/logo.png";
				File file=new File(logopath);
				if (!file.exists()) {
					String logo=request.getParameter("logo");
					if (StringUtils.isBlank(logo)) {
						logo="pc/image/logo.png";
					}
					logopath=getRealPath(request)+logo;
				}
				msg="/"+getComId()+"/register/"+getEmployeeId(request)+"/register"+type+".jpg";
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
	 *  生成二维码
	 * @param request
	 * @return
	 */
	@RequestMapping("generateQRCode")
	@ResponseBody
	public ResultInfo generateQRCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer width=Integer.parseInt(map.get("width").toString());
			Integer height=Integer.parseInt(map.get("height").toString());
			Integer image_width=Integer.parseInt(map.get("image_width").toString());
			Integer image_height=Integer.parseInt(map.get("image_height").toString());
			String logopath=null;
			if (isNotMapKeyNull(map, "logopath")) {
				logopath=getRealPath(getRequest())+map.get("logopath").toString();
			}else{
				logopath=getRealPath(getRequest())+"pc/image/logo.png";
			}
			if(isNotMapKeyNull(map, "qrUrls")){
				String[] qrUrls=map.get("qrUrls").toString().split(",");
				for (String qrurl : qrUrls) {
					String path="/temp/qrcode/"+new Date().getTime()+".jpg";
					if(msg==null){
						msg=path;
					}else{
						msg=msg+","+path;
					}
					path=getRealPath(request)+path;
					QRCodeUtil.generateQRCode(qrurl, width, height,logopath, image_width, image_height,path);
				}
			}else if(isNotMapKeyNull(map, "urlist")){
				String[] qrUrls=map.get("qrUrls").toString().split(",");
				for (String qrurl : qrUrls) {
					String path=getRealPath(request)+qrurl;
					QRCodeUtil.generateQRCode(qrurl, width, height,logopath, image_width, image_height,path);
				}
			}else{
				String path="/temp/qrcode/"+new Date().getTime()+".jpg";
				msg=path;
				path=getRealPath(request)+path;
				QRCodeUtil.generateQRCode(map.get("qrUrl").toString(), width, height,logopath, image_width, image_height,path);
			}
			
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	//////////每隔两小时获取采购订单并生成/////////////////////////
//	/**
//	* 五分钟执行一次
//	* 自动生成采购订单
//	*/
//	@Scheduled(cron="0 0 9-18/2 * * *")
//	public void autoGeneratePurchaseOrder() {
//		
//	}
	
	/**
	 *  库管验收页面
	 * @param request
	 * @return
	 */
	@RequestMapping("receiving")
	public String receiving(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("m_flag", 4);
		String[] sts=map.get("st_auto_no").toString().split("\\|");
		String type="";
		if(sts!=null&&sts.length>1){
			map.put("st_auto_no", sts[0]);
			type=sts[1];
			map.put("m_flag", 5);
		}
		
		if ("luru".equals(map.get("type"))) {
			map.put("m_flag", 5);
			type=map.get("type").toString();
		}
		
		List<Map<String,Object>> list=employeeService.getYanshouOrder(map);
		Map<String,Object> gys=employeeService.getYanshouGysInfo(map);
		request.setAttribute("gys", gys);
		request.setAttribute("list", list);
		if (StringUtils.isBlank(type)) {
			return "pc/supplier/receiving";
		}else{
			return "pc/supplier/entryNotice";
		}
	}
	/**
	 * 通知已收货
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeReceipt")
	@ResponseBody
	public ResultInfo noticeReceipt(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			String[] list=request.getParameterValues("list[]");
			if (list!=null&&list.length>0) {
				employeeService.noticeReceipt(map,list);
				success = true;
			}else{
				msg="没有选择产品!";
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 财务录入erp后通知采购和发货管理员
	 * @param request
	 * @return
	 */
	@RequestMapping("entryNotice")
	@ResponseBody
	public ResultInfo entryNotice(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.entryNotice(map);
			success = true;
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
		String path=com_id+"/certificate/"+orderNo+".jpg";
		File destFile=new File(getRealPath(request)+path);
		if(destFile.exists()){
			List<String> list=new ArrayList<String>();
			list.add("../"+path);
			return list;
		}
		return null;
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
		if (map.get(name)!=null) {
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
	/**
	 *  员工信息
	 * @param request
	 * @return
	 */
	@RequestMapping("userinfo")
	public String userinfo(HttpServletRequest request) {
		String clerk_id=getEmployeeId(request);
		if (StringUtils.isNotBlank(clerk_id)) {
			String com_id=getComId(request);
			Map<String,Object> map=employeeService.getPersonnel(clerk_id,com_id);
			if(map!=null){
				request.setAttribute("personnel",map);
			}
		}
		File file=new File(getEmployeeImgPath(request, clerk_id).toString());
		if (file.exists()&&file.listFiles()!=null&&file.listFiles().length>0) {
			for (File item : file.listFiles()) {
				if (item.isFile()) {
					String path="../"+getComId()+"/"+clerk_id+"/img/"+item.getName();
					request.setAttribute("sfzpath", path);
				}
			}
		}
		return "pc/employee/userinfo";
	}
	
	/**
	 *  获取提货地点文本
	 * @param request
	 * @return
	 */
	@RequestMapping("getThddTxt")
	@ResponseBody
	public List<String> getThddTxt(HttpServletRequest request) {
		String txt=getFileTextContent(getTHDDTxtPath(request));
		if(StringUtils.isNotBlank(txt)){
			return Arrays.asList(txt.split("\\|"));
		}else{
			return null;
		}
	}
	/**
	 * 保存提货地点
	 * @param request
	 * @return
	 */
	@RequestMapping("saveThddTxt")
	@ResponseBody
	public ResultInfo saveThddTxt(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			saveFile(getTHDDTxtPath(request), request.getParameter("thddval"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 获取签名信息
	 * @param request
	 * @return
	 */
	@RequestMapping("shouhuoed")
	public String shouhuoed(HttpServletRequest request) {
		String orderNo=request.getParameter("orderNo");
		String item_id=request.getParameter("item_id");
		String seeds_id=request.getParameter("seeds_id");
		String path=getQianmingImgPath(orderNo, item_id);
		File file=new File(path);
		String imgfile=getFileTextContent(file);
		request.setAttribute("img", imgfile);
		List<Map<String,Object>> listinfo= customerService.findOrderBySeeds_id(seeds_id);
		request.setAttribute("listinfo", listinfo);
		return "/pc/employee/shouhuo";
	}
	/**
	 *  客户评价
	 * @param request
	 * @return
	 */
	@RequestMapping("pingjia")
	public String pingjia(HttpServletRequest request) {
//		String orderNo=request.getParameter("orderNo");
//		String seeds_id=request.getParameter("seeds_id");
//		request.setAttribute("orderNo", seeds_id);
		
//		StringBuffer path=new StringBuffer(getRealPath(getRequest()));
//		path.append("001/eval/");
//		File file=new File(path.toString());
//		String imgpath=null;
//		File[] fs=file.listFiles();
//		seeds_id=seeds_id.replaceAll(",", "");
//		File imgfile=null;
//		for (File file2 : fs) {
//			if(file2.getPath().contains(seeds_id)){
//				if(!file2.isFile()){
//					for (File item : file2.listFiles()) {
//						if(item.getPath().contains(seeds_id)){
//							imgfile=item;
//							break;
//						}
//					}
//				}
//			}
//		}
//		if(imgfile!=null){
//			String type=request.getParameter("type");
//			if(StringUtils.isNotBlank(type)){
//				type=type+"/";
//			}else{
//				type="";
//			}
//			String map=getFileTextContent(imgfile.getParentFile().getPath()+".log");
//			if(StringUtils.isNotBlank(map)){
//				JSONObject json=JSONObject.fromObject(map);
//				request.setAttribute("map", json);
//			}
//			File dest=imgfile.getParentFile();//new File(imgfile);
////			File dest=new File(getComIdPath(request)+"eval/"+type+seeds_id+"/");
//			if(dest.exists()){
//				File[] files=dest.listFiles();
//				List<String> list=new ArrayList<String>();
//				for (File item : files) {
//					String[] paths=item.getPath().split("\\\\"+getComId());
//					String pathimg=getComId()+paths[1];
//					pathimg=pathimg.replaceAll("\\\\", "/");
//					list.add(pathimg);
//				}
//				request.setAttribute("list", list);
//			}
//		}
		return "pc/employee/pingjia";
	}
	/**
	 * 获取订单评价信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getOrderEvalInfo")
	@ResponseBody
	public JSONObject getOrderEvalInfo(HttpServletRequest request) {
		String seeds_id=request.getParameter("orderNo");
		String type=request.getParameter("type");
		///////////////////////////////////
		StringBuffer path=new StringBuffer(getRealPath(getRequest()));
		path.append("001/eval/");
		File file=new File(path.toString());
		File[] fs=file.listFiles();
		seeds_id=seeds_id.replaceAll(",", "");
		File imgfile=null;
		for (File file2 : fs) {
			if(file2.getPath().contains(seeds_id)){
				if(!file2.isFile()){
					for (File item : file2.listFiles()) {
						if(item.getPath().contains(seeds_id)){
							imgfile=item;
							break;
						}
					}
				}
			}
		}
		///////////////////////////////////////
		if(StringUtils.isNotBlank(type)){
			type=type+"/";
		}else{
			type="";
		}
		if(imgfile.getParentFile().exists()){
			String map=getFileTextContent(imgfile.getParentFile().getPath()+".log");
//		String map=getFileTextContent(getOrderEvalFilePath(request, seeds_id,type));
			if(StringUtils.isNotBlank(map)){
				JSONObject json=JSONObject.fromObject(map);
				return json;
			}
		}
		return null;
	}
	
	/**
	 * 门卫通知司机和库管
	 * @param request
	 * @return
	 */
	@RequestMapping("guardConfirmNotice")
	@ResponseBody
	public ResultInfo guardConfirmNotice(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			employeeService.guardConfirmNotice(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通知司机过磅,通知门卫关注过磅信息
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeDriveGuard")
	@ResponseBody
	public ResultInfo noticeDriveGuard(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
			employeeService.noticeDriveGuard(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 采购验收入库单
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingCheck")
	public String purchasingCheck(HttpServletRequest request) {
		return "pc/employee/purchasingCheck";
	}
	
	/**
	 * 向客户催款
	 * @param request
	 * @return
	 */
	@RequestMapping("cuikuan")
	@ResponseBody
	public ResultInfo cuikuan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("title", map.get("title").toString().replaceAll("平台", "["+getComName()+"]平台"));
			employeeService.cuikuan(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}

	/**
	 *  获取已增加入库单
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingCheckList")
	@ResponseBody
	public PageList<Map<String,Object>> purchasingCheckList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.purchasingCheckList(map);
	}
	/**
	 * 采购付款单(走采购流程)
	 */
	@RequestMapping("payProcurement")
	public String payProcurement(HttpServletRequest request) {
		return "pc/employee/payProcurement";
	}
	/**
	 * 付款单(用于供应商直接送货过来付款录入)
	 */
	@RequestMapping("payByItem")
	public String payByItem(HttpServletRequest request) {
		return "pc/employee/payByItem";
	}
	
	/**
	 * 获取采购付款单号
	 * @param request
	 * @return
	 */
	@RequestMapping("getPayorderNo")
	@ResponseBody
	public String getPayorderNo(HttpServletRequest request) {
		return customerService.getOrderNo("采购付款", getComId(request));
	}
	
	/**
	 * 保存采购付款单
	 * @param request
	 * @return
	 */
	@RequestMapping("savePayProcurement")
	@ResponseBody
	public ResultInfo savePayProcurement(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Calendar c = Calendar.getInstance();
			Map<String, Object> map =getKeyAndValue(request);
			map.put("clerk_id", map.get("clerk_id"));
			map.put("dept_id", map.get("dept_id"));
			Object orderNo=map.get("orderNo");
			map.put("finacial_y", c.get(Calendar.YEAR));
			map.put("finacial_m", c.get(Calendar.MONTH)+1);
			map.put("finacial_d", getNow());
			map.put("recieved_direct", "付款");
			map.put("recieved_auto_id",orderNo);
			map.put("recieved_id", orderNo); 
			Object customerName=map.get("customerName");
			map.put("recieve_type", map.get("account"));
			map.put("rcv_hw_no", map.get("paystyle"));
			
			StringBuffer buffer=new StringBuffer(customerName+"");
			buffer.append(getNow().split(" ")[0]).append("付款单号");
			buffer.append("[").append(orderNo).append("]").append(map.get("paystyletxt"));
			map.put("c_memo", buffer.toString());
			
			map.put("sum_si", map.get("amount"));
//			map.put("sum_si_origin",map.get("sum_si_origin"));
			map.put("comfirm_flag", "Y");
			map.put("mainten_clerk_id", getComId(request));
			map.put("mainten_datetime", getNow());
			////////////////
			writeLog(request,map.get("customer_id")+"","供应商:"+customerName,"付款单号:"+orderNo);
			map.remove("orderNo");
			map.remove("account");
			map.remove("paystyle");
//			map.remove("paystyletxt");
			map.remove("amount");
			/////////////////
			customerService.savePayProcurement(map,null);
			//////保存备注信息到文件中
			File file=getRecievedMemo(request, orderNo,getCustomerId(request));
			saveFile(file, buffer.toString());
			String clerk_id=getEmployeeId(request);
			if (clerk_id==null) {
				clerk_id=getCustomerId(request);
			}
			writeLog(request,clerk_id,"供应商:"+customerName,"付款单号:"+orderNo);
			success = true;
			
		} catch (Exception e) {
			msg = "服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取供应商信息
	 * 
	 */
	@RequestMapping("getSupplierByComId")
	@ResponseBody
	public PageList<Map<String, Object>> getSupplierByComId(
			HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upper", request.getParameter("upper"));//预留供应商上下级
		map.put("com_id", getComId(request));
		map.put("clerk_id", getEmployeeId(request));
		String keyname = request.getParameter("keyname");//搜索字段
		String page = request.getParameter("page");
		String rows = request.getParameter("rows");
		if (StringUtils.isBlank(page)) {
			page = "0";
		}
		if (StringUtils.isBlank(rows)) {
			rows = "10";
		}
		map.put("page", page);
		map.put("rows", rows);
		if (StringUtils.isBlank(keyname)) {
			map.put("keyname", "");
		} else {
			keyname = "%" + keyname + "%";
			map.put("keyname", keyname);
		}
		return employeeService.getSupplierByComId(map);
	}
	/**
	 * 给经办人经办部门设置默认值
	 */
	@RequestMapping("setDefaultByClerkId")
	@ResponseBody
	public List<Map<String, Object>> setDefaultByClerkId(HttpServletRequest request){
		Map<String,Object> map=getKeyAndValueQuery(request);
		map.put("clerk_id", getEmployeeId(request));
		return employeeService.setDefaultByClerkId(map);
	}
	/**
	 *  采购入库获取已发货采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("getProcurementList")
	@ResponseBody
	public PageList<Map<String,Object>> getProcurementList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getProcurementList(map);
	}
	/**
	 * 采购退货单
	 */
	@RequestMapping("purchaseReturn")
	public String purchaseReturn(HttpServletRequest request){
		return "pc/employee/purchaseReturn";
	}
	/**
	 *  获取已退货产品
	 * @param request
	 * @return
	 */
	@RequestMapping("purchasingReturnList")
	@ResponseBody
	public PageList<Map<String,Object>> purchasingReturnList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.purchasingReturnList(map);
	}
	/**
	 * 直接下采购订单,不走推消息流程
	 */
	@RequestMapping("directOrder")
	public String directOrder(HttpServletRequest request){
		return "pc/employee/directOrder";
	}
	/**
	 * 直接下采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("saveDirectOrder")
	@ResponseBody
	public ResultInfo saveDirectOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			Integer len=Integer.parseInt(map.get("len").toString());
			List<String[]> item_ids=new ArrayList<String[]>();
			for(int i=0;i<len;i++){
				item_ids.add(request.getParameterValues("item_ids["+i+"][]"));
			}
			map.put("item_ids",item_ids);
			employeeService.saveDirectOrder(map);
			success=true;
		} catch (Exception e) {
			msg = "服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取供应商信息
	 * 
	 */
	@RequestMapping("getNOByComId")
	@ResponseBody
	public PageList<Map<String, Object>> getNOByComId(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upper", request.getParameter("upper"));//预留供应商上下级
		map.put("com_id", getComId(request));
		map.put("clerk_id", getEmployeeId(request));
		String searchKey = request.getParameter("searchKey");//搜索字段
		String page = request.getParameter("page");
		String rows = request.getParameter("rows");
		if (StringUtils.isBlank(page)) {
			page = "0";
		}
		if (StringUtils.isBlank(rows)) {
			rows = "10";
		}
		map.put("page", page);
		map.put("rows", rows);
		if (StringUtils.isBlank(searchKey)) {
			map.put("searchKey",null);
		} else {
			searchKey = "%" + searchKey + "%";
			map.put("searchKey", searchKey);
		}
		return employeeService.getNOByComId(map);
	}
	/**
	 * 根据采购订单号计算订单金额,返回数据
	 * @param request
	 * @return
	 */
	@RequestMapping("getCgAmountByNo")
	@ResponseBody
	public String getCgAmountByNo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getCgAmountByNo(map);
	}
	/**
	 * 根据采购订单号查询已付金额,返回数据
	 * @param request
	 * @return
	 */
	@RequestMapping(value="getYfAmountByNo",method=RequestMethod.GET)
	@ResponseBody
	public String getYfAmountByNo(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getYfAmountByNo(map);
	}
	/**
	 * 采购订单跟踪表
	 */
	@RequestMapping("purchaseOrderTracking")
	public String purchaseOrderTracking(HttpServletRequest request){
		return "pc/employee/purchaseOrderTracking";
	}
	/**
	 * 库存查询
	 */
	@RequestMapping("queryInventory")
	public String queryInventory(HttpServletRequest request){
		return "pc/employee/queryInventory";
	}
	
	/**
	 * 生成计划采购订单
	 * @param request
	 * @return
	 */
	@RequestMapping("generatePurchaseOrderByPlan")
	@ResponseBody
	public ResultInfo generatePurchaseOrderByPlan(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValueQuery(request);
			map.put("clerk_id", getEmployeeId(request));
			if(isMapKeyNull(map, "vendor_id")){
				map.put("vendor_id", "");
			}
			msg=employeeService.generatePurchaseOrderByPlan(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  上报产品信息
	 * @param request
	 * @return
	 */
	@RequestMapping("upItemInfo")
	public String upItemInfo(HttpServletRequest request) {
		
		return "pc/qingyuan/upItemInfo";
	}
	/**
	 *  上报产品信息
	 * @param request
	 * @return
	 */
	@RequestMapping("upItemInfoList")
	public String upItemInfoList(HttpServletRequest request) {
		
		return "pc/qingyuan/upItemInfoList";
	}
	
	/**
	 *  获取供应商上报产品信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getGysUpItemInfoList")
	@ResponseBody
	public List<Map<String,Object>> getGysUpItemInfoList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		Object date=map.get("beginDate");
		if (date=="") {
			return null;
		}
		List<Map<String,Object>> list= employeeService.getGysUpItemInfoList(map);
		for (Iterator<Map<String, Object>> iterator = list.iterator(); iterator.hasNext();) {
			Map<String, Object> item =  iterator.next();
			File file=new File(getUpitemItemImgPath(request, date, item.get("vendor_id"), item.get("item_id")));
			if (file.exists()&&file.isDirectory()) {
				File[] fs=file.listFiles();
				List<String> imgs=new ArrayList<String>();
				for (File file2 : fs) {
					String path="../"+getComId()+"/"+file2.getPath().split("\\\\"+getComId())[1];
					path=path.replaceAll("\\\\", "/");
					imgs.add(path);
				}
				item.put("imgs", imgs);
			}
		}
		return list;
	}
	/**
	 * 更新供应商上报产品信息标识
	 * @param request
	 * @return
	 */
	@RequestMapping("updateGysProFlag")
	@ResponseBody
	public ResultInfo updateGysProFlag(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=employeeService.updateGysProFlag(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 修改报价单单价
	 * @param request
	 * @return
	 */
	@RequestMapping("editAddedInfo")
	@ResponseBody
	public ResultInfo editAddedInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.editAddedInfo(map);
			writeLog(request,getEmployeeId(request),getEmployee(request).get("clerk_name"), "修改报价信息报价单号:"+map.get("orderNo")+"_"+map.get("item_name"));
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 修改订单数量
	 * @param request
	 * @return
	 */
	@RequestMapping("editOrderNum")
	@ResponseBody
	public ResultInfo editOrderNum(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if(!checkAuthority(request,"editOrderNum",null)){
				map.remove("zsnum");
			}
			if(!checkAuthority(request,"editOrderPrice",null)){
				map.remove("price");
			}
			map.put("clerk_name", getEmployee(request).get("clerk_name"));
//			map.put("headship", getEmployee(request).get("headship"));
			msg=employeeService.editOrderNum(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 录入销售订单数据
	 */
	@RequestMapping("salesOrder")
	public String salesOrder(HttpServletRequest request){
		return "pc/employee/salesOrder";
	}
	/**
	 * 获取已下销售开单信息
	 * @param request
	 * @return
	 */
	@RequestMapping("getSalesKdList")
	@ResponseBody
	public PageList<Map<String, Object>> getSalesKdList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getSalesKdList(map);
	}
	/**
	 * 录入销售开单数据
	 * @param request
	 * @return
	 */
	@RequestMapping("saveSalesOrder")
	@ResponseBody
	public ResultInfo saveSalesOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("mainten_clerk_id", getEmployeeId(request));
			employeeService.saveSalesOrder(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 审核销售开单数据
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmOrder")
	@ResponseBody
	public ResultInfo confirmOrder(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.confirmOrder(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 放弃审核销售开单数据
	 * @param request
	 * @return
	 */
	@RequestMapping("returnConfirm")
	@ResponseBody
	public ResultInfo returnConfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.returnConfirm(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 根据库存退货
	 * 
	 */
	@RequestMapping("itemReturn")
	public String itemReturn(HttpServletRequest request){
		return "pc/employee/itemReturn";
	}
	/**
	 * 销售退货
	 * 
	 */
	@RequestMapping("salesReturn")
	public String salesReturn(HttpServletRequest request){
		return "pc/employee/salesReturn";
	}
	/**
	 * 获取销售退货单
	 * @param request
	 * @return
	 */
	@RequestMapping("getSalesReturnList")
	@ResponseBody
	public PageList<Map<String, Object>> getSalesReturnList(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getSalesReturnList(map);
	}
	/**
	 * 保存销售退货单数据
	 * @param request
	 * @return
	 */
	@RequestMapping("saveSalesReturn")
	@ResponseBody
	public ResultInfo saveSalesReturn(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("mainten_clerk_id", getEmployeeId(request));
			employeeService.saveSalesReturn(map);
			success=true;
		} catch (Exception e) {
			msg ="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 进入库存调拨
	 */
	@RequestMapping("transfersInventory")
	public String transfersInventory(HttpServletRequest request) {
		return "pc/employee/transfersInventory";
	}
	/**
	 *生成库存调拨单 
	 */
	@RequestMapping("saveTransfersBills")
	@ResponseBody
	public ResultInfo saveTransfersBills(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.saveTransfersBills(map);
			success=true;
		} catch (Exception e) {
			msg ="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取库存调拨单
	 * @param request
	 * @return
	 */
	@RequestMapping("getTransfersBills")
	@ResponseBody
	public PageList<Map<String, Object>> getTransfersBills(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getTransfersBills(map);
	}
	/**
	 * 审核库存调拨单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmTransfers")
	@ResponseBody
	public ResultInfo confirmTransfers(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.confirmTransfers(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 审核库存调拨单
	 * @param request
	 * @return
	 */
	@RequestMapping("returnTransfers")
	@ResponseBody
	public ResultInfo returnTransfers(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.returnTransfers(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 进入库存报损
	 */
	@RequestMapping("breakageInventory")
	public String breakageInventory(HttpServletRequest request) {
		return "pc/employee/breakageInventory";
	}
	/**
	 *生成库存报损单
	 *@param request
	 */
	@RequestMapping("savebreInventory")
	@ResponseBody
	public ResultInfo savebreInventory(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.savebreInventory(map);
			success=true;
		} catch (Exception e) {
			msg ="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取库存报损单
	 * @param request
	 * @return
	 */
	@RequestMapping("getBreInventory")
	@ResponseBody
	public PageList<Map<String, Object>> getBreInventory(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getBreInventory(map);
	}
	/**
	 * 审核库存报损单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmBreInv")
	@ResponseBody
	public ResultInfo confirmBreInv(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.confirmBreInv(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 放弃审核库存报损单
	 * @param request
	 * @return
	 */
	@RequestMapping("returnBreInv")
	@ResponseBody
	public ResultInfo returnBreInv(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			employeeService.returnBreInv(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 进入库存盘点
	 */
	@RequestMapping("checkInventory")
	public String checkInventory(HttpServletRequest request) {
		return "pc/employee/checkInventory";
	}
	/**
	 *生成库存盘点单
	 *@param request
	 */
	@RequestMapping("saveCheckInv")
	@ResponseBody
	public ResultInfo saveCheckInv(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.saveCheckInv(map);
			success=true;
		} catch (Exception e) {
			msg ="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 获取库存盘点单
	 * @param request
	 * @return
	 */
	@RequestMapping("getCheckInv")
	@ResponseBody
	public PageList<Map<String, Object>> getCheckInv(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValueQuery(request);
		return employeeService.getCheckInv(map);
	}
	/**
	 * 审核库存盘点单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmCheckInv")
	@ResponseBody
	public ResultInfo confirmCheckInv(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.confirmCheckInv(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 放弃审核库存盘点单
	 * @param request
	 * @return
	 */
	@RequestMapping("returnCheckInv")
	@ResponseBody
	public ResultInfo returnCheckInv(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.returnCheckInv(map);
			success=true;
		} catch (Exception e) {
			msg = "系统异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 删除库存盘点,调拨,报损
	 * @param request
	 * @return
	 */
	@RequestMapping("delInventoryRel")
	@ResponseBody
	 public ResultInfo delInventoryRel(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.delInventoryRel(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	/**
	 * 删除销售开单,销售退货单
	 * @param request
	 * @return
	 */
	@RequestMapping("delSalesOrder")
	@ResponseBody
	 public ResultInfo delSalesOrder(HttpServletRequest request) {
		boolean success=false;
		String msg=null;
		try {
			Map<String,Object> map=getKeyAndValue(request); 
			employeeService.delSalesOrder(map);
			success=true;
		} catch (Exception e) {
			msg="服务器异常,请稍后再试!";
			e.printStackTrace();
		}
		return new ResultInfo(success,msg);
	}
	
	/**
	 * 客户订单附件列表
	 * @param request
	 * @return
	 */
	@RequestMapping("addFileList")
	public String addFileList(HttpServletRequest request) {
		return "pc/employee/addFileList";
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
		File file=new File(getComIdPath(request)+"addFile/"+map.get("customer_id"));
		if (file.exists()&&file.isDirectory()) {
			String[] files=file.list();
			List<String> fslist = Arrays.asList(files);
			Collections.reverse(fslist);
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
					Map<String,Object> info=new HashMap<>();
					Date date=null;
					if(path.startsWith("NO")){
						String time=path.split("\\.")[1].substring(0,8);
						SimpleDateFormat date_format = new SimpleDateFormat(
								"yyyyMMdd", Locale.CHINA);
						try {
							date=date_format.parse(time);
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}else{
						String time=path.split("\\.")[0];
						date=new Date(Long.parseLong(time));
					}
					if (date.getTime()>begin||date.getTime()<end) {
						info.put("time", DateTimeUtils.dateTimeToStr(date));
						info.put("url", "/"+map.get("com_id")+"/addFile/"+map.get("customer_id")+"/"+path);
						list.add(info);
					}
				}
				return list;
			}
		}
		return null;
	}
	/**
	 * 删除客户订单附件
	 * @param request
	 * @return
	 */
	@RequestMapping("delAddFile")
	@ResponseBody
	public ResultInfo delAddFile(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Object auth=request.getSession().getAttribute("auth");
			Map<String, Object> mapval =(Map<String, Object>) auth;
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "url")) {
				msg="没有附件路径!";
			}else if(isMapKeyNull(map, "customer_id")){
				msg="没有客户编码!";
			}else if(isMapKeyNull(mapval, "delAddFile")){
				msg="没有删除权限!";
			}else{
				File file=new File(getRealPath(request)+map.get("url"));
				if (file.exists()&&file.isFile()) {
					file.delete();
					writeLog(request,getEmployeeId(request), getEmployee(request).get("clerk_name")+"", "删除客户订单附件");
					success = true;
				}else{
					msg="文件不存在!";
				}
			}
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
				writeLog(request,getEmployeeId(request), getEmployee(request).get("clerk_name")+"", content);
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
	/**
	 *  设置当前运营商为默认演示运营商
	 * @param request
	 * @return
	 */
	@RequestMapping("setComDef")
	public String setComDef(HttpServletRequest request) {
		saveFile(getRealPath(request)+"comDef.txt",getComId());
		return "success";
	}
	/**
	 * 审核全部报价单
	 * @param request
	 * @return
	 */
	@RequestMapping("confirmAllAdded")
	@ResponseBody
	public ResultInfo confirmAllAdded(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=employeeService.confirmAllAdded(map);
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通知审核客户报价单
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeComfirm")
	@ResponseBody
	public ResultInfo noticeComfirm(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=employeeService.noticeComfirm(map);
			if (msg==null) {
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 * 通知业务员客户报价单已经审核
	 * @param request
	 * @return
	 */
	@RequestMapping("noticeAddedConfirmed")
	@ResponseBody
	public ResultInfo noticeAddedConfirmed(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			msg=employeeService.noticeAddedConfirmed(map);
			if (msg==null) {
				success = true;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}

