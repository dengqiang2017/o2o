package com.qianying.controller;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qianying.bean.ResultInfo;
import com.qianying.service.IClientService;
import com.qianying.service.ICustomerService;
import com.qianying.service.IEmployeeService;
import com.qianying.service.IManagerService;
import com.qianying.service.IOperatorsService;
import com.qianying.service.ISupplierService;
import com.qianying.service.ISystemParamsService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.LogUtil;
import com.qianying.util.LoggerUtils;
import com.qianying.util.MD5Util;
import com.qianying.util.SendMail;
import com.qianying.util.VerifyCodeUtils;
import com.qianying.util.WeiXinServiceUtil;
import com.qianying.util.WeixinUtil;

@Controller
@RequestMapping("/login")
public class LoginController extends FilePathController {

	@Autowired
	private IOperatorsService operatorsService;
	@Autowired
	private IManagerService managerService;
	@Autowired
	private IEmployeeService employeeService;
	@Autowired
	private ICustomerService customerService;
	@Autowired
	private ISupplierService supplierService;
	@Autowired
	private ISystemParamsService systemParams;
	@Autowired
	private IClientService clientService;
	
	@RequestMapping("index")
	public String index(HttpServletRequest request,HttpServletResponse response) throws IOException {
		StringBuilder builder=new StringBuilder("/");
//		builder.append("phone/index.html"); "redirect:/"
		builder.append("index.html?ver="+Math.random()); 
		response.sendRedirect(builder.toString());
		return null;//builder.toString();
	}
	/**
	 * 跳转到注册页面
	 * @param request
	 * @return
	 */
	@RequestMapping("register")
	public String register(HttpServletRequest request) {
		String type=request.getParameter("type");
		if (type==null) {
			type="";
		}
		//1.获取图形验证码
		String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
		request.getSession().setAttribute(VerifyCodeUtils.imgverifyCode, verifyCode);
		request.setAttribute("verifyCode", verifyCode);
		return "pc/register/register"+type;
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("forgetpsw")
	public String forgetpsw(HttpServletRequest request) {
		String type=request.getParameter("type");
		if (type==null) {
			type="";
		}
		//1.获取图形验证码
		String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
		request.getSession().setAttribute(VerifyCodeUtils.imgverifyCode, verifyCode);
		request.setAttribute("verifyCode", verifyCode);
		return "pc/forgetpsw/forgetpsw";
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("getComs")
	@ResponseBody
	public List<Map<String,Object>> getComs(HttpServletRequest request) {
		 
		return operatorsService.getAll();
	}
	/**
	 * 获取启用的颜色运营商列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getNextComs")
	@ResponseBody
	public List<Map<String,Object>> getNextComs(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		return operatorsService.getNextComs(map);
	}
	
	/**
	 * 获取图形验证码
	 * @param request
	 * @return
	 */
	@RequestMapping("getImgVerifyCode")
	@ResponseBody
	public ResultInfo getImgVerifyCode(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			try {
				msg=new Date().getTime() + ".jpg";
				File dir = new File(getRealPath(request)+"/temp/verifies");
				int w = 200, h = 80;
				String verifyCode = VerifyCodeUtils.generateVerifyCode(4);
				request.getSession().setAttribute(VerifyCodeUtils.imgverifyCode, verifyCode);
				File file = new File(dir, msg);
				VerifyCodeUtils.outputImage(w, h, file, verifyCode);
			} catch (IOException e) {
				e.printStackTrace();
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	@RequestMapping("/exitLogin")
	public String exitLogin(HttpServletRequest request) throws Exception {
		String type=request.getParameter("type");
		if ("2".equals(type)) {
			request.getSession().setAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN, null);
		}else if ("3".equals(type)) {
			request.getSession().setAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN, null);
		}else{
			request.getSession().setAttribute(ConfigFile.SESSION_USER_INFO, null);
		}
		String com_id=getComId(request);
		request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, null);
		if("001Y10".equals(com_id)){
			return "redirect:../ds/?com_id="+com_id;
		}
		return "redirect:../index.html?com_id="+com_id;
	}
	/**
	 * 获取上下文路径path值
	 * @param request
	 * @return
	 */
	@RequestMapping("getContextPath")
	@ResponseBody
	public String getContextPath(HttpServletRequest request) {
		return  request.getContextPath();
	}
	
	@RequestMapping("getSystemName")
	@ResponseBody
	public ResultInfo getSystemName(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			File systemName=new File(BaseController.getRealPath(request)+map.get("com_id")+"/systemName.txt");
			msg=getFileTextContent(systemName);
			if (StringUtils.isBlank(msg)) {
				msg="O2O运营及服务平台";
			}
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 同步项目文件
	 * @param request
	 * @throws IOException
	 */ 
	@RequestMapping("fileSync")
	@ResponseBody
	public ResultInfo fileSync(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String info=request.getParameter("list");
			if (StringUtils.isNotBlank(info)) {
				JSONArray jsons=JSONArray.fromObject(info);
				for (int i = 0; i < jsons.size(); i++) {
					JSONObject json=jsons.getJSONObject(i);
					String src=json.getString("src");
					String dest=json.getString("dest");
					String basestr=json.getString("base");
					if(StringUtils.isNotBlank(basestr)){
						basestr=ConfigFile.TOMCAT_DIR+"/";
					}else{
						basestr=getRealPath(request);
					}
					StringBuffer base=new StringBuffer(basestr);
					File srcFile=new File(getRealPath(request)+src);
					if (srcFile.exists()) {
						File destFile=new File(base.toString()+dest);
						if (destFile.isDirectory()) {
							LoggerUtils.info("文件夹->"+destFile.getPath());
							try {
								FileUtils.copyDirectory(srcFile, destFile);
							} catch (Exception e) {
								FileUtils.copyFile(srcFile, destFile,true);
							}
						}else {
							try {
								FileUtils.copyFile(srcFile, destFile,true);
							} catch (Exception e) {
								FileUtils.copyDirectory(srcFile, destFile);
							}
						}
					}
				}
				success = true;
			}else{
				msg="无数据";
			} 
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	@RequestMapping("getFileList")
	@ResponseBody
	public List<String> getFileList(HttpServletRequest request) {
		List<String> list=new ArrayList<String>();
		String path=request.getParameter("path");//目标文件夹
		final String filter=request.getParameter("filter");//过滤
		String numstr=request.getParameter("num");//每次加载数
		String pagestr=request.getParameter("page");//开始记录数
		File file=new File(getRealPath(request)+path+"/");
		if(file.exists()){ 
			File[] fs=file.listFiles(new FileFilter() {
				@Override
				public boolean accept(File pathname) {
					if (StringUtils.isNotBlank(filter)) {
						String s = pathname.getName().toLowerCase();
	                	if(s.endsWith(filter)){
	                		return true;
	                	}else{
	                		return false;
	                	}
					}
					return true;
				}
			});
			List<File> fslist=Arrays.asList(fs);
			if(fslist!=null&&fslist.size()>0){
				Integer num=0;
				if (StringUtils.isNotBlank(numstr)) {
					num=Integer.parseInt(numstr);
				}
				Collections.reverse(fslist);
				Integer page=0;
				if (StringUtils.isNotBlank(pagestr)) {
					page=Integer.parseInt(pagestr);
				}
				if (page<fslist.size()) {
					for (int i = page; i < fslist.size(); i++) {
						list.add(fslist.get(i).getName()); 
						if (num>0) {
							if (i>=num) {
								break;
							}
						}
					}
				}
			}
		}
		return list;
	}
	public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }
	/**
	 * 	从toUrl中跳转时候先登录的页面url
	 */
	public static final JSONArray toUrlList=new JSONArray();
	@RequestMapping("toUrl")
	public String toUrl(HttpServletRequest request) {
		String url=request.getParameter("url");
		String jumpPage="redirect:/index.html?ver="+Math.random();
		if(StringUtils.isBlank(url)){
			if(request.getQueryString().split("=").length>1){
				url=request.getQueryString().split("=")[1];
			}
		}
		if(StringUtils.isBlank(url)){
			return jumpPage;
		}
		url=url.replaceAll("\\|_", "&");
		url=url.replaceAll("\\|", "&");
		if (!url.contains("?")) {
			if (url.contains("&")) {
				url=url.replace("&", "?");
			}
		}
		if(url.split("\\?").length==2){
			String[] params=url.split("\\?")[1].split("&");
			Map<String,String> map=new HashMap<>();
			String paramstr="";
			for (String str : params) {
				String[] pas=str.split("=");
				if(pas.length==2){
					if("processName".equals(pas[0])){
						boolean b=isContainChinese(pas[1]);
						if(b){
							pas[1]=utf8to16(pas[1]);
						}
					}
					map.put(pas[0],pas[1]);
					paramstr=paramstr+"&"+pas[0]+"="+pas[1];
				}else{
					map.put(pas[0],pas[0]);
					paramstr=paramstr+"&"+pas[0]+"="+pas[0];
				}
			}
			if(paramstr.length()>2){
				paramstr=paramstr.substring(1, paramstr.length());
				url=url.split("\\?")[0];
				url=url+"?"+paramstr;
			}
		}
		if(getCustomer(request)!=null||getEmployee(request)!=null){
			return "redirect:"+url;
		}else if(url.contains("html")){
			LoggerUtils.error("-->"+url);
			return "redirect:"+url;
		}else{
			request.getSession().setAttribute("sessionUrl", url);
			////////////////////////
			String com_id="";
			if (url.contains("com_id")) {
				String[] pas=url.split("\\?")[1].split("&");
				for (String ps : pas) {
					String[] pams=ps.split("=");
					if("com_id".equals(pams[0])){
						com_id="&com_id="+pams[1];
						break;
					}
				}
			}
			if (StringUtils.isBlank(com_id)&&StringUtils.isNotBlank(getComId())) {
				com_id="&com_id="+getComId();
			}
			for (int i = 0; i < toUrlList.size(); i++) {
				JSONObject json=toUrlList.getJSONObject(i);
				boolean b=url.contains(json.getString("containsUrl"));
				if(b){
					if (json.has("jumpPage")) {//有跳转路径时进行跳转
						jumpPage=json.getString("jumpPage")+"?ver="+Math.random()+com_id;
					} else {//没有的时候就直接跳转到url对应的页面
						jumpPage="redirect:"+url;
					}
					break;
				}
			}
			return jumpPage;
		}
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("sqlExec")
	@ResponseBody
	public List<Map<String,Object>> sqlExec(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		String pwd="qianying"+DateTimeUtils.getNowDate();
		pwd=MD5Util.MD5(pwd);
		if(pwd.equalsIgnoreCase(map.get("adminPsd").toString())){
			try {
				return operatorsService.sqlExec(map);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		throw new RuntimeException("口令错误");
	}
	
	/**
	 *  获取帮助文件列表
	 * @param request
	 * @return 帮助文件夹下面的文件名
	 */
	@RequestMapping("getHelpFileList")
	@ResponseBody
	public List<String> getHelpFileList(HttpServletRequest request) {
		List<String> list=new ArrayList<String>();
		File file=new File(getRealPath(request)+"help/");
		if(file.exists()){
			File[] fs=file.listFiles();
			Arrays.sort(fs);
			if(fs!=null&&fs.length>0){
				for (File file2 : fs) {
					list.add(file2.getName());
				}
			}
		}
		if(getEmployee(request)!=null){
			Map<String,Object> map=(Map<String, Object>) request.getSession().getAttribute("auth");
			if(isNotMapKeyNull(map, "uploadHelpFile")){
				list.add("上传文件");
			}
			if(isNotMapKeyNull(map, "delHelpFile")){
				list.add("删除文件");
			}
		}
		return list;
	}
	
	@RequestMapping("sendmail")
	@ResponseBody
	public ResultInfo sendmail(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			map.put("tomail", systemParams.checkSystem("tomail"));
			if (isMapKeyNull(map, "tomail")) {
				msg="没有收件人";
			}else if(isMapKeyNull(map, "subject")){
				msg="没有邮件标题";
			}else if(isMapKeyNull(map, "text")){
				msg="没有邮件正文内容";
			}else{
				success=SendMail.sendSinaMail(map.get("subject")+"", map.get("text")+"",
						map.get("imgUrl")+"",MapUtils.getString(map, "tomail","").split(","));
				JSONObject json=new JSONObject();
				json.put("success",success);
				json.put("time", getNow());
				json.put("content", map.get("subject")+","+map.get("text")+","+MapUtils.getString(map, "tomail",""));
				saveFile(getRealPath(request)+map.get("com_id")+"/email.log",json.toString(),true);
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
//	/**
//	 * Word转html
//	 * @param request
//	 * @return
//	 */
//	@RequestMapping("convert2Html")
//	@ResponseBody
//	public ResultInfo convert2Html(HttpServletRequest request) {
//		boolean success = false;
//		String msg = null;
//		try {
//			File fileName=new File(getRealPath(request)+request.getParameter("fileName"));//"temp/word/案例.doc";
//			File outPutFile=new File(getRealPath(request)+request.getParameter("outPutFile"));//"pc/word/anli.html";
//			File imgPath=new File(getRealPath(request)+request.getParameter("imgPath"));//"pc/word/img/";
//			String imgprex=request.getParameter("imgprex");
//			String utf=request.getParameter("utf");
//			if (StringUtils.isBlank(utf)) {
//				utf="UTF-8";
//			}
//			if (!fileName.getParentFile().exists()) {
//				fileName.getParentFile().mkdirs();
//			}
//			if (!outPutFile.getParentFile().exists()) {
//				outPutFile.getParentFile().mkdirs();
//			}
//			if (!imgPath.exists()) {
//				imgPath.mkdirs();
//			}
//			docTest.convert2Html(fileName.getPath(), outPutFile.getPath(), imgPath.getPath()+"/",utf,imgprex);
//			success = true;
//		} catch (Exception e) {
//			msg = e.getMessage();
//			e.printStackTrace();
//		}
//		return new ResultInfo(success, msg);
//	}
	
	/**
	 *  
	 * @param request
	 * @param aut 成员编码
	 * @param date 日期
	 * @return
	 */
	@RequestMapping("getLogList")
	@ResponseBody
	public String getLogList(HttpServletRequest request) {
		String aut=request.getParameter("aut");
		if(StringUtils.isBlank(aut)){
			aut=getEmployeeId(request);
		}
		if (StringUtils.isBlank(aut)) {
			aut=getCustomerId(request);
		}
		String date=request.getParameter("date");
		if (StringUtils.isBlank(date)) {
			date=DateTimeUtils.dateToStr();
		}
		StringBuffer path=new StringBuffer(getComIdPath(request));
		path.append("/planquery/").append(aut).append("/log/");
		path.append(date).append(".log");
		File file=new File(path.toString());
		if (file.exists()) {
			return getFileTextContent(file);
		}else{
			return "";
		}
	}
	
	/**
	 *  根据openid获取userid
	 * @param request
	 * @return
	 */
	@RequestMapping("getUseridByOpenid")
	@ResponseBody
	public String getUseridByOpenid(HttpServletRequest request) {
		Map<String,Object> map=getKeyAndValue(request);
		WeixinUtil wei=new WeixinUtil();
		String url="https://qyapi.weixin.qq.com/cgi-bin/user/convert_to_userid?access_token="+wei.getAccessToken(map.get("com_id")+"");
		JSONObject json=new JSONObject();
		json.put("openid", map.get("openid"));
		String msg=wei.postData(url, json);
		if (msg!=null) {
			json=JSONObject.fromObject(msg); 
			if (json.has("userid")) {
				return json.getString("userid");
			}
		}
		return null;
	}
	
	//TODO 微信服务号网页版操作----开始----
	/**
	 * 跳转微信服务号用户授权页面
	 * @param request
	 * @return
	 */
	@RequestMapping("getWeixinCode")
	public String getWeixinCode(HttpServletRequest request) {
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		String com_id=request.getParameter("com_id");
		String redirect_uri=request.getParameter("url");//redirect_uri
		String state=request.getParameter("state");
		if (StringUtils.isBlank(com_id)) {
			com_id="001";
		}
		if (StringUtils.isBlank(state)) {
			state="001";
		}
		String msg=null;
		try {
			msg = ws.getCodeUrl(com_id, redirect_uri, state);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return "redirect:"+msg;
	}
	/**
	 *  从网页中获取openid和access_token 如果是客户就自动登录
	 * @param com_id 
	 * @param code 第一步用户授权后回调地址中获取
	 * @return {"access_token":"","expires_in":7200,"refresh_token":"","openid":"","scope":""}
	 */
	@RequestMapping("getOpenIdAndAccess_token")
	@ResponseBody
	public JSONObject getOpenIdAndAccess_token(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		String code=request.getParameter("code");
		String autologin=request.getParameter("login");//默认自动登录
		if (StringUtils.isBlank(autologin)) {
			autologin="true";
		}
		if (StringUtils.isBlank(com_id)) {
			com_id="001";
		}
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		JSONObject json= ws.getOpenIdAndAccess_token(com_id, code);
		//自动登录客户
		json.put("login", false);
		if(json.has("openid")&&"true".equals(autologin)){
			String type=request.getParameter("type");
			Map<String,Object> login=null;
			if("员工".equals(type)){
				login=employeeAutoLogin(request, com_id, json.getString("openid"),"服务号");
			}else if("供应商".equals(type)){
				login=gysAutoLogin(request, com_id, json.getString("openid"),"服务号");
			}else{//客户
				login=customerAutoLogin(request, com_id, json,"服务号");
			}
			if(login!=null){
				json.put("login", true);
				json.put("info",login);
			}
		}
		return json;
	}
	/**
	 * 根据微信通讯录账号微信id
	 * @param type
	 * @param com_id
	 * @param json
	 * @param map
	 * @return openid
	 */
	private Map<String, Object> getOpenidByUserId(Object type, String com_id, String userid, Map<String,Object> map) {
		if("企业号".equals(type)){
			WeixinUtil ws=new WeixinUtil();
			String openid=ws.useridToOpenid(userid, com_id);
			map.put("openid", openid);
		}
		return map;
	}
	
	/**
	 * 客户自动登录根据openid 
	 * @param request
	 * @param com_id
	 * @param openid
	 * @return 
	 */
	private Map<String, Object> customerAutoLogin(HttpServletRequest request,String com_id,JSONObject json,String type) {
		if(getCustomer(request)==null){
			String id="";
			if("企业号".equals(type)){
				id= json.getString("userid");
			}else{
				id= json.getString("openid");
			}
			Map<String,Object> map= customerService.getCustomerInfoByOpenid(com_id,id,type);
			setComId(request, com_id);
			if(map!=null){
				map=getOpenidByUserId(type, com_id, id, map);
				request.getSession().setAttribute(
						ConfigFile.CUSTOMER_SESSION_LOGIN, map);
				if("企业号".equals(type)){
					map.remove("openid");
				}
				customerService.updateLoginTime(map);
				customerService.noticeEmployee(map);
			}else{
				String autoRegister=systemParams.checkSystem("autoRegister", "true");
				if(!"true".equals(autoRegister)){
					return null;
				}
				//注册
				map=new HashMap<>();
				map.put("com_id", com_id);
				String upper_customer_id=request.getParameter("upper_customer_id");
				if (StringUtils.isNotBlank(upper_customer_id)) {
					map.put("upper_customer_id", upper_customer_id);
				}else{
					map.put("upper_customer_id", "CS1");
				}
				map.put("type_id", "1");
				map.put("working_status", "是");
				map.put("user_password", "123456");
				if("企业号".equals(type)){
					WeixinUtil wx=new WeixinUtil();
					String ret=wx.getEmployeeInfo(id, com_id);
					if(StringUtils.isNotBlank(ret)){
						JSONObject info=JSONObject.fromObject(ret);
						map.put("corp_name", info.get("name"));
						map.put("corp_sim_name", info.get("name"));
						if (info.has("mobile")) {
							map.put("user_id", info.get("mobile"));
							map.put("movtel", info.get("mobile"));
						}
						if(info.has("gender")){
							if ("1".equals(info.get("gender"))) {
								map.put("sex", "男");
							}else if("2".equals(info.get("gender"))){
								map.put("sex", "女");
							}
						}
					}
					map.put("weixinID",id);
				}else{
					WeiXinServiceUtil ws=new WeiXinServiceUtil();
					JSONObject info= ws.getUserInfoByOpenid(id, com_id);
					if(info!=null){
						map.put("corp_name", getJsonVal(info, "nickname"));
						map.put("corp_sim_name", getJsonVal(info, "nickname"));
						if(info.has("sex")){
							if ("1".equals(info.get("sex"))) {
								map.put("sex", "男");
							}else if("2".equals(info.get("sex"))){
								map.put("sex", "女");
							}
						}
						if(info.has("city")){
							map.put("regionalism_id", getJsonVal(info, "city"));
						}
						map.put("openid",  getJsonVal(info, "openid"));
					}
				}
				map.put("ditch_type", "消费者");
				map.put("customer_type", "终端客户");
				map.put("market_type", "终端客户");
				String clerk_idAccountApprover=customerService.getClerk_idAccountApprover(getComId());
				map.put("clerk_idAccountApprover", clerk_idAccountApprover);
				if(!map.containsKey("openid")||MapUtils.getString(map, "openid").length()<20){
					LoggerUtils.error("openid异常:"+map.get("openid"));
					return null;
				}else{
					if (isNotMapKeyNull(map, "corp_name")) {
						customerService.save(map);
						map = customerService.getCustomerInfoByOpenid(com_id,id,type);
						request.getSession().setAttribute(
								ConfigFile.CUSTOMER_SESSION_LOGIN, map);
					}
				}
			}
			return map;
		}else{
			return getCustomer(request);
		}
	}
	/**
	 * 供应商自动登录根据openid
	 * @param request
	 * @param com_id
	 * @param openid
	 * @return
	 */
	private Map<String, Object> gysAutoLogin(HttpServletRequest request,String com_id,String openid,String type) {
		if(getCustomer(request)==null){
			Map<String,Object> map= supplierService.getGysInfoByOpenid(com_id,openid,type);
			if(map!=null){
				map=getOpenidByUserId(type, com_id, openid, map);
				if (isNotMapKeyNull(map, "openid")&&MapUtils.getString(map, "openid").length()>=20) {
					managerService.updateOpenid(map);
				}
				setComId(request, com_id);
				request.getSession().setAttribute(
						ConfigFile.CUSTOMER_SESSION_LOGIN, map);
			}
			return map;
		}else{
			return getCustomer(request);
		}
	}
	private void setComId(HttpServletRequest request,String com_id) {
		request.getSession().setAttribute(ConfigFile.OPERATORS_NAME,com_id);
		Object com_name=managerService.getOneFiledNameByID("ctl00501", "com_name", "1=1",com_id);
		request.getSession().setAttribute(ConfigFile.SYSTEM_NAME, com_name);
	}
	/**
	 * 员工自动登录根据openid
	 * @param request
	 * @param com_id
	 * @param openid
	 * @return
	 */
	private Map<String,Object> employeeAutoLogin(HttpServletRequest request,String com_id,String openid,String type) {
		if (getEmployee(request)==null) {
			Map<String,Object> mapPersonnel= employeeService.getEmployeeInfoByOpenid(com_id,openid,type);
			if(mapPersonnel!=null){
				Map<String,Object> map=new HashMap<>();
				if (mapPersonnel.get("dept_id") != null) {
					String dept_id = mapPersonnel.get("dept_id")
							.toString();
					map.put("dept_id", dept_id);
				}
				if(isNotMapKeyNull(mapPersonnel, "headship")){
					map.put("headship", mapPersonnel.get("headship"));
				}
				map.put("clerk_name", mapPersonnel.get("clerk_name"));
				map.put("weixinID", mapPersonnel.get("weixinID"));
				map.put("type_id", mapPersonnel.get("type_id"));
				map.put("com_id", mapPersonnel.get("com_id"));
				map.put("clerk_id", mapPersonnel.get("clerk_id"));
				map.put("user_id", mapPersonnel.get("user_id"));
				mapPersonnel.remove("weixinID");
				mapPersonnel.remove("type_id");
				mapPersonnel.remove("headship");
				mapPersonnel.remove("dept_id");
				mapPersonnel.remove("com_id");
				mapPersonnel.remove("clerk_id");
				mapPersonnel.remove("user_id");
				map.put("personnel", mapPersonnel);
				map=getOpenidByUserId(type, com_id, openid, map);
				if (isNotMapKeyNull(map, "openid")&&MapUtils.getString(map, "openid").length()>=20) {
					if(!"企业号".equals(type)){
						managerService.updateOpenid(map);
					}
				}
				setComId(request, com_id);
				request.getSession().setAttribute(
						ConfigFile.SESSION_USER_INFO, map);
			}
			return mapPersonnel;
		}else{
			return getEmployee(request);
		}
	}
	/**
	 * 检查access_token 能否使用
	 * @param request
	 * @param access_token
	 * @param openid
	 * @return 可以返回true,不可以返回false,
	 */
	@RequestMapping("checkAccess_token")
	@ResponseBody
	public ResultInfo checkAccess_token(HttpServletRequest request, String access_token, String openid) {
		boolean success = false;
		String msg = null;
		try {
			WeiXinServiceUtil ws=new WeiXinServiceUtil();
			Boolean b=ws.checkAccess_token(access_token, openid);
			if (b==null) {
				msg="接口访问错误!";
			}else{
				success = b;
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 * 刷新refresh_token
	 * @param request
	 * @param com_id 
	 * @param refresh_token 
	 * @return
	 */
	@RequestMapping("refresh_token")
	@ResponseBody
	public JSONObject refresh_token(HttpServletRequest request, String com_id, String refresh_token) {
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		return ws.refresh_token(com_id, refresh_token);
	}
	
	/**
	 *  获取用户信息
	 * @param request
	 * @param access_token 
	 * @param openid 
	 * @return
	 */
	@RequestMapping("getUserInfo")
	@ResponseBody
	public JSONObject getUserInfo(HttpServletRequest request, String access_token, String openid) {
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		return ws.getUserInfo(access_token, openid);
	}
	/**
	 * 保存openid到客户信息中
	 * @param request
	 * @return
	 */
	@RequestMapping("saveOpenid")
	@ResponseBody
	public ResultInfo saveOpenid(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
//			weixinService.saveOpenid(map);
			WeiXinServiceUtil ws=new WeiXinServiceUtil();
			msg=ws.getUserInfo(MapUtils.getString(map, "access_token"), MapUtils.getString(map, "openid")).toString();
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/**
	 *  获取微信服务号中的用户列表
	 * @param request
	 * @return
	 */
	@RequestMapping("getUserInfoList")
	@ResponseBody
	public JSONObject getUserInfoList(HttpServletRequest request) {
		return new WeiXinServiceUtil().getUserInfoList("001");
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("saveTemplate")
	@ResponseBody
	public JSONArray saveTemplate(HttpServletRequest request) {
		WeiXinServiceUtil service=new WeiXinServiceUtil();
		Map<String,Object> map=getKeyAndValue(request);
		JSONArray jsons= service.get_all_private_template(MapUtils.getString(map, "com_id"));
//		File file=new File(getComIdPath(request)+"weixin/template.log");
//		saveFile(file, jsons.toString());
		for (int i = 0; i < jsons.size(); i++) {
			String msg=jsons.getJSONObject(i).toString();
			msg=msg.split("example")[0];
			JSONObject js=JSONObject.fromObject(msg.substring(0, msg.length()-2)+"}");
			System.out.println(js);
		}
		return jsons;
	}
	
	@RequestMapping("sendMessage")
	@ResponseBody
	public ResultInfo sendMessage(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	//TODO 微信服务号网页版操作----结束----
	/**
	 *  获取微信授权地址
	 * @param request
	 * @param com_id
	 * @param url 授权后跳转地址
	 * @param state 跳转参数
	 * 域名/login/getCodeUrl.do?url=域名&state=/employee/orderTrackRecord.do?orderNo=123123213_|customer_id=serwer|_weixinType=qiye
	 * @return
	 */
	@RequestMapping("getWeixinCodeUrl")
	public String getWeixinCodeUrl(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		setComId(request, com_id);
		String weixinType=request.getParameter("weixinType");
		if(StringUtils.isBlank(weixinType)){
			weixinType=systemParams.checkSystem("weixinType", "0");
		}
		if("0".equals(weixinType)){
			return getWeixinCode(request);
		}else{
			return getCodeUrl(request);
		}
	}
	/**
	 *  获取微信企业号授权地址
	 * @param request
	 * @param com_id
	 * @param url 授权后跳转地址
	 * @param state 跳转参数
	 * @return 授权后跳转地址+code+state
	 * 域名/login/getCodeUrl.do?url=域名&state=/employee/orderTrackRecord.do?orderNo=123123213_|customer_id=serwer|_weixinType=qiye
	 * 域名/?code=6a7c2fb60f7f8849f0797619a3a38ca7&state=/employee/orderTrackRecord.do?orderNo=123123213_|customer_id=serwer|_weixinType=qiye
	 * 域名/?code=6a7c2fb60f7f8849f0797619a3a38ca7&state=/employee/orderTrackRecord.do?orderNo=123123213_|customer_id=serwer&weixinType=qiye
	 */
	@RequestMapping("getCodeUrl")
	public String getCodeUrl(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		String redirect_uri=request.getParameter("url");//redirect_uri
		String state=request.getParameter("state");
		if (StringUtils.isBlank(com_id)) {
			com_id="001";
		}
		if (StringUtils.isBlank(state)) {
			state="qiye";
		}
		String msg=redirect_uri;
		try {
			WeixinUtil ws=new WeixinUtil();
			msg = ws.getCodeUrl(com_id, redirect_uri, state);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return "redirect:"+msg;
	}
	/**
	 *  获取微信企业号
	 * @param request
	 * @param com_id
	 * @param code
	 * @return  http://www.pulledup.cn/login/getuserinfo.do?com_id=001&code=e5c854352120699446a3619e65a851d8
	 */
	@RequestMapping("getuserinfo")
	@ResponseBody
	public JSONObject getuserinfo(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		String code=request.getParameter("code");
		String autologin=request.getParameter("login");//默认自动登录
		if (StringUtils.isBlank(autologin)) {
			autologin="true";
		}
		if (StringUtils.isBlank(com_id)) {
			com_id="001";
		}
		WeixinUtil ws=new WeixinUtil();
		JSONObject json= ws.getuserinfo(com_id, code);
		//自动登录
		json.put("login", false);
		if(json.has("userid")&&"true".equals(autologin)){
			String type=request.getParameter("type");
			Map<String,Object> login=null;
			if("员工".equals(type)){
				login=employeeAutoLogin(request, com_id, json.getString("userid"),"企业号");
			}else if("供应商".equals(type)){
				login=gysAutoLogin(request, com_id, json.getString("userid"),"企业号");
			}else{//客户
				login=customerAutoLogin(request, com_id, json,"企业号");
			}
			if(login!=null){
				json.put("login", true);
				json.put("info", login);
			}
		}
		return json;
	}
	/**
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("ganzhi")
	@ResponseBody
	public ResultInfo ganzhi(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			///////////////////////
			Object corp_name=null;
			if(isNotMapKeyNull(map, "userid")){
				if(MapUtils.getString(map, "userid").length()>20){
					corp_name=managerService.getOneFiledNameByID("sdf00504", "corp_name", "openid='"+map.get("userid")+"'", map.get("com_id").toString());
				}else{
					corp_name=managerService.getOneFiledNameByID("sdf00504", "corp_name", "weixinID='"+map.get("userid")+"'", map.get("com_id").toString());
					if(corp_name==null){
						WeixinUtil wei=new WeixinUtil();
						String info=wei.getEmployeeInfo(map.get("userid")+"", map.get("com_id")+"");
						if (StringUtils.isNotBlank(info)) {
							JSONObject json=JSONObject.fromObject(info);
							if(json.has("name")){
								corp_name=json.get("name");
							}
						}
					}
				}
			}
			if(corp_name==null){
				corp_name="陌生客户";
				map.put("corp_name", null);
			}else{
				map.put("corp_name", corp_name);	
			}
			/////////////
			String ip= LogUtil.getIpAddr(request);
			String id=DateTimeUtils.getNowDateTimeS();
			map.put("ip", ip);
			map.put("article_id", map.get("id"));
			map.put("id", id);
			map.put("read_time", getNow());
			msg=clientService.saveGanzhiInfo(map);
			////////////////////
			///向客服发送消息
			List<Map<String, Object>> news=new ArrayList<Map<String,Object>>();
			Map<String,Object> mapMsg=new HashMap<String, Object>();
			mapMsg.put("title",map.get("title"));
			String description="";
			if (isNotMapKeyNull(map, "desc")) {
				description=map.get("desc").toString().replaceAll("@customerName", corp_name+"");
				mapMsg.put("description",description);
			} 
			mapMsg.put("url",  ConfigFile.urlPrefix+"/login/toUrl.do?url="+map.get("url")+id);
			mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			news.add(mapMsg);
			if (isNotMapKeyNull(map, "clerk_id")) {
				if("001".equals(map.get("clerk_id"))){
					Map<String,Object> mapinfo= employeeService.getPersonnel(map.get("clerk_id")+"",map.get("com_id")+"");
					if(mapinfo!=null){
						WeixinUtil wei=new WeixinUtil();
						description=description.replaceAll("@clerkName", mapinfo.get("clerk_name")+"");
						news.get(0).put("description", description);
						wei.sendMessagenews(news, map.get("com_id")+"", mapinfo.get("weixinID")+"", "员工");
					}
				}
			}else{
				Map<String,Object> mapparams=new HashMap<String, Object>();
				mapparams.put("com_id", map.get("com_id"));
				mapparams.put("headship", "%客服%");
				List<Map<String, String>> touserList=employeeService.getPersonnelNeiQing(mapparams);
				if (touserList!=null&&touserList.size()>0) {
					WeixinUtil wei=new WeixinUtil();
					for (Map<String, String> map2 : touserList) {
						wei.sendMessagenews(news, map.get("com_id")+"", map2.get("weixinID")+"", "员工");
					}
				}
			}
			msg=id;
			success = true;
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	/**
	 *  文章阅读时间
	 * @param request
	 * @return
	 */
	@RequestMapping("stopTime")
	@ResponseBody
	public void stopTime(HttpServletRequest request) throws Exception {
		Map<String,Object> map=getKeyAndValue(request);
		map.put("endTime", getNow());
		clientService.updateGanzhiEndTime(map);
	}
	///////////聊天///////
	/**
	 * 消息列表
	 * @param request
	 * @return 返回[{"id":"CS1C00002","name":"张三","len":2}]
	 */
	@RequestMapping("getChartList")
	@ResponseBody
	public List<Map<String,Object>> getChartList(HttpServletRequest request) {
		String clerk_id="";
		String type=request.getParameter("type");
		if (!"kefu".equals(type)) {
			clerk_id=getEmployeeId(request);
		}
		File file=new File(getComIdPath(request)+"chart/"+clerk_id);
		if (file.exists()) {
			File[] fs=file.listFiles();
			List<File> fslist =Arrays.asList(fs);
			Collections.reverse(fslist);
			List<Map<String,Object>> list=new ArrayList<>();
			for (File file2 : fslist) {
				if (file2.exists()&&file2.isDirectory()) {
					Integer len=file2.list().length;
					if (len>0) {
						if (file2.listFiles()[len-1].isFile()) {
							String id=file2.getName();
							if("img".equals(id)){
								continue;
							}
							Map<String,Object> map=new HashMap<>();
							map.put("id", id);
							map.put("clerk_id", clerk_id);
							map.put("com_id", getComId());
							map.put("len", len);
							map.put("name", file2.listFiles()[len-1].getName());
							map.put("context", getFileTextContent(file2.listFiles()[len-1]));
							list.add(map);
						}
					}
				}
			}
			return  list;
		}
		return null;
	}
	/**
	 * 保存聊天消息
	 * @param chat 消息内容
	 * @param customer_id 所属客户
	 * @param clerk_id 指定成员
	 * @return 
	 */
	@RequestMapping("saveChartInfo")
	@ResponseBody
	public ResultInfo saveChartInfo(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			String chat=request.getParameter("chat");
			String com_id=request.getParameter("com_id");
			if(StringUtils.isNotBlank(chat)){
				File file=new File(getRealPath(request)+com_id+"/chart/"+getChatId(request)+"/"+getNow().replaceAll(":", "")+".json");
				JSONObject json=new JSONObject();
				if (getEmployee(request)!=null) {
					json.put("kefu", chat);
					json.put("name", getEmployee(request).get("clerk_name"));
				}else{
					json.put("kehu", chat);
					if (getCustomer(request)!=null) {
						json.put("name", getCustomer(request).get("clerk_name"));
					}
				}
				if (!json.has("name")) {
					json.put("name", "陌生客户");
				}
				mkdirsDirectory(file);
				saveFile(file, json.toString());
				String jinru=request.getParameter("jinru");
				if (getEmployee(request)==null&&(StringUtils.isBlank(jinru)||"0".equals(jinru))) {//只在客户进入时发送一次消息
					//使用微信进行通知
					Map<String,Object> map=new HashMap<>();
					map.put("com_id", com_id);
					map.put("headship", "%客服%");
					List<Map<String, Object>> news=new ArrayList<>();
					Map<String,Object> param=new HashMap<>();
					param.put("title", "客户咨询消息提醒");
					param.put("description", "你好，你有一条用户咨询待解决");
//					param.put("description", json.get("name")+chat);
					String customer_id=request.getParameter("customer_id");
					if (StringUtils.isBlank(customer_id)) {
						if(StringUtils.isNotBlank(getCustomerId(request))){
							customer_id=getCustomerId(request);
						}else{
							customer_id=LogUtil.getIpAddr(request);
						}
					}
					String url= ConfigFile.urlPrefix+"/ds/chat.jsp?customer_id="+customer_id;
					param.put("url",url);
					news.add(param);
					List<Map<String, String>> list= employeeService.getPersonnelNeiQing(map);
					WeixinUtil wx=new WeixinUtil();
					WeiXinServiceUtil ws=new WeiXinServiceUtil();
					String template_id="CadaNgUupXd_jT26XiKYt__rH1MFiTItjra4PCKP5k8";
					JSONObject data=new JSONObject();
					JSONObject first=new JSONObject();
					first.put("value", "你好，你有一条用户咨询待解决");
					first.put("color","#173177");
					data.put("first",first);
					JSONObject keynote1=new JSONObject();
					keynote1.put("value",json.get("name"));
					keynote1.put("color","#173177");
					data.put("keyword1",keynote1);
					JSONObject keynote2=new JSONObject();
					keynote2.put("value", chat);
					keynote2.put("color","#173177");
					JSONObject remark=new JSONObject();
					remark.put("value", "点击处理咨询");
					remark.put("color","#173177");
					data.put("keyword2",keynote2);
					data.put("remark",remark);
					for (Map<String, String> map2 : list) {
						if(StringUtils.isNotBlank(map2.get("weixinID"))){
							wx.sendMessagenews(news, com_id, map2.get("weixinID"), "员工");
						}
						if(StringUtils.isNotBlank(map2.get("openid"))){
							msg=ws.sendMessage(map2.get("openid"), template_id, com_id, url, data);
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
	 * 获取客户咨询路径编码
	 * @param request
	 * @return customer_id
	 */
	private String getChatId(HttpServletRequest request) {
		String customer_id=request.getParameter("customer_id");
		String clerk_id=request.getParameter("clerk_id");
		if (StringUtils.isBlank(clerk_id)) {
			clerk_id="";
		}else{
			clerk_id=clerk_id+"/";
		}
		if (getEmployee(request)==null) {
			String ip=LogUtil.getIpAddr(request).replaceAll(":", "");
			if(getCustomer(request)!=null){
				customer_id=getCustomerId(request);
				String com_id=request.getParameter("com_id");
				File file=new File(getRealPath(request)+com_id+"/chart/"+clerk_id+ip);
				if (file.exists()) {
					customer_id=ip;
				}
			}else{
				if (StringUtils.isBlank(customer_id)) {
					customer_id=ip;
				}
			}
		}
		return clerk_id+customer_id;
	}
	
	/**
	 * 获取新消息
	 * @param len
	 * @param customer_id
	 * @return
	 */
	@RequestMapping("getNewMsg")
	@ResponseBody
	public JSONArray getNewMsg(HttpServletRequest request) {
		String len=request.getParameter("len");
		if (StringUtils.isBlank(len)) {
			len="0";
		}
		return getChartMsg(request, getChatId(request), Integer.parseInt(len));
	}
	/**
	 *  
	 * @param request
	 * @return
	 */
	@RequestMapping("getMsgCount")
	@ResponseBody
	public Integer getMsgCount(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		File file=new File(getRealPath(request)+com_id+"/chart/"+getChatId(request));
		if(file.exists()&&file.isDirectory()){
			return file.list().length;
		}else{
			return 0;
		}
	}
	/**
	 * 获取消息内容
	 * @param request
	 * @param customer_id
	 * @param len 现在页面消息长度
	 * @return 
	 */
	private JSONArray getChartMsg(HttpServletRequest request, String customer_id, Integer len) {
		String com_id=request.getParameter("com_id");
		File file=new File(getRealPath(request)+com_id+"/chart/"+customer_id);
		if (file.exists()) {
			if (len<file.list().length) {
				List<String> list=Arrays.asList(file.list());
				Collections.reverse(list);
				Integer l= file.list().length-len;
				if(l>10){
					l=10;
				}
				JSONArray jsons=new JSONArray();
				for (int i = 0; i < l; i++) {
					String path=file.getPath()+"/"+list.get(i);
					String jsonstr=getFileTextContent(path);
					if (StringUtils.isNotBlank(jsonstr)) {
						JSONObject json=JSONObject.fromObject(jsonstr);
						jsons.add(json);
					}
				}
				Collections.sort(jsons);
				return jsons;
			}
		}
		return null;
	}
	/**
	 * 保存留言
	 * @param request
	 * @return
	 */
	@RequestMapping("saveLeavingMsg")
	@ResponseBody
	public ResultInfo saveLeavingMsg(HttpServletRequest request) {
		boolean success = false;
		String msg = null;
		try {
			Map<String,Object> map=getKeyAndValue(request);
			if (isMapKeyNull(map, "name")) {
				msg="请输入您的名称或公司名称!";
			}else if(isMapKeyNull(map, "tel")){
				msg="请输入您的联系电话!";
			}else{
				JSONObject json=new JSONObject();
				json.put("name",map.get("name"));
				json.put("tel",map.get("tel"));
				json.put("memo",map.get("memo"));
				String file=getRealPath(request)+map.get("com_id")+"/leavingmsg.json";
				saveFile(file, json.toString()+",",true);
				success = true;
				Map<String,Object> mapparams=new HashMap<String, Object>();
				mapparams.put("com_id", map.get("com_id"));
				mapparams.put("headship", "%客服%");
				List<Map<String, String>> list= employeeService.getPersonnelNeiQing(mapparams);
				if (list!=null&&list.size()>0) {
					List<Map<String,Object>> news=new ArrayList<Map<String,Object>>();
					Map<String,Object> mapMsg=new HashMap<String, Object>();
					mapMsg.put("title","客户留言通知");
					String description=json.getString("name")+","+json.getString("tel")+","+json.getString("memo");
					mapMsg.put("description",description);
//					mapMsg.put("url", "");
					mapMsg.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
					news.add(mapMsg);
					for (Map<String, String> map2 : list) {
						sendMessageNews(news, map2.get("weixinID"));
					}
				}
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
}
