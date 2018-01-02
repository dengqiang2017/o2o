package com.qianying.integerceptor;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.qianying.controller.BaseController;
import com.qianying.controller.LoginController;
import com.qianying.util.ConfigFile;
/**
 * 请求拦截器
 * @author dengqiang
 *
 */
public class Integerceptor extends BaseController implements HandlerInterceptor {
	private Logger log = Logger.getLogger(Integerceptor.class);

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object obj, Exception exp)
			throws Exception {
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
	}

	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object obj, ModelAndView mav)
			throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
	}
	/**
	 * 需要过滤的url列表
	 */
	public static final List<String> url_list = new ArrayList<String>();
	/**
	 * 检查url是否需要直接放行
	 * @param obj
	 * @return 放行为true
	 */
	private boolean checkRequest(String obj) {
		boolean b=false;
		for (String url : url_list) {
			if(obj.contains(url)){
				b=true;
				break;
			}
		}
		return b;
	}
	private static String URL;
	@SuppressWarnings("unchecked")
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object obj) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String uri = request.getScheme() +"://" + request.getServerName();
//                + ":" +request.getServerPort() 
//                + request.getServletPath(); 
		String domainName=request.getParameter("domainName");
		if (StringUtils.isNotBlank(domainName)) {
			response.setHeader("Access-Control-Allow-Origin",domainName);
		}else{
			response.setHeader("Access-Control-Allow-Origin",uri);
		}
		response.setHeader("Access-Control-Allow-Methods", "GET,POST");
		ConfigFile.PC_OR_PHONE="pc/";//Kit.getPctype(request);
		log.info("preHandle===>>>" + request.getRequestURI());
		/////////
		log.info(request.getContentType());
//		request.getSession().setAttribute("projectName", ConfigFile.projectName);
		getVer(request);
		Object com_id=request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
		if(com_id==null){
			com_id="001";
		}
		// 访问的是放行列表里面的实例直接放行11
		Map<String, Object> userMap=null;
		Map<String, Object> customerMap=null;
//			Map<String, Object> managerMap=null;
		String url=request.getRequestURI();
		customerMap=(Map<String, Object>) request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
		userMap=(Map<String, Object>) request.getSession().getAttribute(ConfigFile.SESSION_USER_INFO);
//			managerMap=(Map<String, Object>) request.getSession().getAttribute(ConfigFile.MANAGER_SESSION_LOGIN);
                //不是ajax请求，则直接跳转页面
			boolean login=true;
        	if (url.contains("customer")||url.contains("supplier")) {//客户相关url请求
        		if (customerMap==null) {
        			login=checkUrl(request, response, url);
        		}else{
        			if(customerMap.get("corp_id")!=null){
        				if(url.contains("orderpay")){
//        					return false;
        					login=false;
        				}
        				if(url.contains("shopping")){
        					login=false;
        				}
        				if(url.contains("getCustomer.do")){
        					login=false;;
        				}
        			}else{
        				log.info("放行:" + request.getRequestURI());
        				login=true;
        			}
        		}
        	}else if(url.contains("employee")){//员工相关url请求||url.contains("manager")
        		if (userMap==null) {
        			login=checkUrl(request, response, url);
        		}else{
        			log.info("放行:" + request.getRequestURI());
        			login=true;
        		}
        	}else if(customerMap!=null||userMap!=null){//非这三种角色url但有一种已经登录的直接放行||managerMap!=null
        		log.info("放行:" + request.getRequestURI());
        		login=true;
        	}else{//没有登录的就转到检查url方法
        		login= checkUrl(request, response, url);
        	}
        	return login;
	}

	private boolean checkUrl(HttpServletRequest request, HttpServletResponse response, String url) throws IOException {
		String params = request.getQueryString();
		Object com_id=request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
		if(com_id==null||"null".equals(com_id)){
			com_id="001";
		}
		if (StringUtils.isNotBlank(params)) {
			params = "?" + params;
			if (!params.contains("com_id")) {
				if(com_id!=null){
					params+="&com_id="+com_id;
				}
			}
		} else {
			params = "?com_id="+com_id;
		}
		String path=request.getContextPath();
		if (StringUtils.isNotBlank(path)) {
			url=url.replaceAll(path, "");
		}
		String login ="/index.html"+params;
		if (url.contains("customer")) {
			 login ="../pc/login.jsp"+params;
		}else if (url.contains("employee")) {
			login ="../pc/login-yuangong.jsp"+params;
		}else if (params.contains("sendChatMsg")) {
			login ="../pc/login.jsp"+params;
			response.sendRedirect(login);
			return false;
		}
		if (url.contains("customer.do")) {
			login ="pc/login.jsp"+params;
		}else if (url.contains("employee.do")||url.contains("manager.do")) {
			login ="pc/login-yuangong.jsp"+params;
		}
		URL = url + params;
		if (login.equals(URL)) {
			URL = request.getHeader("Referer");
			return true;
		}
		if (StringUtils.isNotBlank(url) && !checkRequest(url)) {
			for (int i = 0; i < LoginController.toUrlList.size(); i++) {
				JSONObject json=LoginController.toUrlList.getJSONObject(i);
				boolean b=url.contains(json.getString("containsUrl"));
				if(b){
					if (json.has("jumpPage")) {//有跳转路径时进行跳转
						login=json.getString("jumpPage")+"?ver="+Math.random()+"&com_id="+com_id;
					} else {//没有的时候就直接跳转到url对应的页面
						login=url;
					}
					break;
				}
			}
			String ajax=request.getParameter("_");
			if(StringUtils.isNotBlank(ajax)){
				JSONObject  json=new JSONObject();
				json.put("msg", "请重新登录");
				json.put("url", login.replaceAll("redirect\\:", ""));
				response.setContentType("text/html;charset=utf-8");
				response.getOutputStream().write(json.toString().getBytes("utf-8"));
			}else{
				response.sendRedirect(login.replaceAll("redirect\\:", ""));
			}
			return false;
		} else {
			URL = null;
			return true;
		}
	}
}
