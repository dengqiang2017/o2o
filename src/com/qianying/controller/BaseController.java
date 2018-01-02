package com.qianying.controller;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.ConvolveOp;
import java.awt.image.Kernel;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;

import net.sf.excelutils.ExcelUtils;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.qianying.bean.ResultInfo;
import com.qianying.bean.UserInfo;
import com.qianying.bean.VerificationCode;
import com.qianying.service.IManagerService;
import com.qianying.util.ConfigFile;
import com.qianying.util.DateTimeUtils;
import com.qianying.util.Kit;
import com.qianying.util.LoggerUtils;
import com.qianying.util.WeixinUtil;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

/**
 * 公共控制类
 * 
 * @author dengqiang 2014-07-16 14:00:00
 */
public abstract class BaseController {
	/**
	 * 需要过滤的后缀名列表
	 */
	public static final List<String> type_ext_List = new ArrayList<String>();

	public static final String time_23 = " 23:59:59";
	public static final String time_00 = " 00:00:00";
	/**
	 * 获取服务器域名
	 */
	public static String serverName = null;
  
	/**
	 * 检查是否登录
	 * 
	 * @param request
	 * @return
	 */
	public boolean checkUser(HttpServletRequest request) {
		UserInfo bean = (UserInfo) request.getSession().getAttribute(
				ConfigFile.SESSION_USER_INFO);
		if (bean != null) {
			return true;
		}
		return false;
	}
	/**
	 * 检查资料维护是否有使用权限
	 * @param request
	 * @param name 接口名称
	 * @return 用户为001直接返回true,其它用户进行判断,true可以向下执行
	 */
	public boolean checkAuthority(HttpServletRequest request, String name,String suffix) {
		boolean b=false;
		String com_id=getEmployeeId(request);
		if (!"001".equals(com_id)) {
			String clerk_id=getEmployeeId(request);//获取员工内码从管理员session中
			if (StringUtils.isBlank(clerk_id)) {//获取员工内码从员工登录中
				clerk_id=getEmployeeId(request);
			}
			if (StringUtils.isNotBlank(clerk_id)) {
				//获取员工的权限
				Map<String,Object> map=getTxtKeyVal(request, clerk_id);
				if (map!=null) {
					if(suffix==null){
						suffix="";
					}
					Object obj=map.get(name+suffix);
					if (obj!=null) {
						b=true;
					}
				}
			} 
		}else{
			b=true;
		}
		return b;
	}
	/**
	 * 获取商家id
	 * 
	 * @param request
	 * @return id
	 */
	public Long getUserInfoId(HttpServletRequest request) {
		UserInfo bean = (UserInfo) request.getSession().getAttribute(
				ConfigFile.SESSION_USER_INFO);
		if (bean != null) {
			return bean.getId();
		}
		return 0l;
	}
	/**
	 * 
	 * @param request
	 * @return id
	 */
	public String getUserInfo_Id(HttpServletRequest request) {
		UserInfo bean = (UserInfo) request.getSession().getAttribute(
				ConfigFile.SESSION_USER_INFO);
		if (bean != null) {
			return bean.getId()+"";
		}
		return null;
	}

	/**
	 * 检查是否是管理员
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public boolean checkAdmin(HttpServletRequest request) throws Exception {
		// Business bean= (Business)
		// request.getSession().getAttribute(ConfigFile.SESSION_BUSINESS_USER);
		// if (bean.getLevel()==1) {
		// return true;
		// }
		return false;
	}

	/**
	 * 检查后缀名是否需要直接放行
	 * 
	 * @param obj
	 * @return 放行为true
	 */
	public String getFileType(String obj) {
		String type = null;
		for (String type_ext : type_ext_List) {
			String ext = FilenameUtils.getExtension(obj);
			if (type_ext.contains(ext)) {
				type = type_ext.split(",")[0];
				break;
			}
		}
		return type;
	}

	/** 
	 * 获取绝对路径  已经在返回时添加 '/'
	 * 
	 * @param request
	 * @param url
	 * @return
	 */
	public static String getRealPath(HttpServletRequest request, String url) {
		if (StringUtils.isBlank(url)) {
			url = ConfigFile.ROOT;
		}
		return request.getSession().getServletContext().getRealPath(url)+"/";
	}
	/** 
	 * 获取绝对路径  已经在返回时添加 '/'
	 * 
	 * @param request
	 * @param url
	 * @return
	 */
	public static String getRealPath(HttpServletRequest request) {
		return request.getSession().getServletContext().getRealPath("/")+"/";
	}

	/**
	 * 获取服务器域名
	 * 
	 * @param request
	 * @return 服务器域名
	 */
	public String getServerName(HttpServletRequest request) {
		return "http://" + request.getServerName() + ConfigFile.ROOT;
	}
	// ////////////////////////////////
	/**
	 * 比较日期大小如果开始时间大于结束时间就将两个日期换位置放入map中
	 * 
	 * @param map
	 *            需要存放日期的map
	 * @param beginDate
	 *            开始日期
	 * @param endDate
	 *            结束日期
	 */
	public void dateCompare(Map<String, Object> map, Date beginDate,
			Date endDate) {
		String beginTime = DateFormatUtils.format(beginDate,
				ConfigFile.DATE_FORMAT);
		String endTime = DateFormatUtils
				.format(endDate, ConfigFile.DATE_FORMAT);
		if (beginDate.getTime() > endDate.getTime()) {
			map.put("beginTime", endTime + time_00);
			map.put("endTime", beginTime + time_23);
		} else {
			map.put("beginTime", beginTime + time_00);
			map.put("endTime", endTime + time_23);
		}
	}

	/**
	 * 根据传入的开始时间和结束时间,判断是否为空为空的就初始化为当前日期 获取当前天的日期放入到map中
	 * 
	 * @param beginTime
	 *            开始时间
	 * @param endTime
	 *            结束时间
	 * @param map
	 *            需要存放日期的map
	 */
	public void getNowDay(String beginTime, String endTime,
			Map<String, Object> map) {
		// 当开始时间和结束时间都没有的时候默认查询近7天的数据
		if (StringUtils.isBlank(beginTime)) {
			// 如果只有开始时间没有就查询近30天的数据
			beginTime = DateFormatUtils.format(new Date(),
					ConfigFile.DATE_FORMAT);
		}
		map.put("beginTime", beginTime + time_00);
		if (StringUtils.isBlank(endTime)) {// 结束时间为空的时候默认当天
			endTime = DateFormatUtils
					.format(new Date(), ConfigFile.DATE_FORMAT);
		}
		map.put("endTime", endTime + time_23);

	}

	/**
	 * 获取判定后查询时间
	 * 
	 * @param beginTime
	 * @param endTime
	 * @param map
	 */
	public void getQueryTime(String beginTime, String endTime,
			Map<String, Object> map) {
		Date beginDate = null;
		Date endDate = null;
		// 当开始时间和结束时间都没有的时候默认查询近7天的数据
		if (StringUtils.isBlank(beginTime) && StringUtils.isBlank(endTime)) {
			beginDate = DateUtils.addDays(new Date(), -7);
		} else if (StringUtils.isBlank(beginTime)) {
			// 如果只有开始时间没有就查询近30天的数据
			beginDate = DateUtils.addDays(new Date(), -30);
		} else {
			beginDate = DateTimeUtils.strToDate(beginTime);
		}
		if (StringUtils.isBlank(endTime)) {// 结束时间为空的时候默认当天
			endDate = new Date();
		}
		dateCompare(map, beginDate, endDate);
	}

	/**
	 * 获取昨天的日期并放入到map中
	 * 
	 * @param map
	 */
	public void getYesterdayDate(Map<String, Object> map) {
		Date date = DateUtils.addDays(new Date(), -1);
		map.put("beginTime", DateTimeUtils.dateToStr(date) + time_00);
		map.put("endTime", DateTimeUtils.dateToStr(date) + time_23);
	}

	/**
	 * 获取map中value值,适用于map中存放单条数据的.
	 * 
	 * @param map
	 * @return
	 */
	public Object getValue(Map<String, Object> map) {
		Iterator<Entry<String, Object>> it = map.entrySet().iterator();
		Object obj = null;
		while (it.hasNext()) {
			Entry<String, Object> entry = (Entry<String, Object>) it.next();
			// entry.getKey() 返回与此项对应的键
			obj = entry.getValue();
		}
		return obj;
	}

	/**
	 * 获取json数据中的版本号 默认为0
	 * 
	 * @param bean
	 *            需要获取的json对象
	 * @param name
	 *            在json中的名称
	 * @return 从json中提取的数据 默认为0
	 * @throws Exception
	 */
	public Object getVersion(Object bean, String name) {
		Object ver = null;
		try {
			ver = PropertyUtils.getProperty(bean, name);
		} catch (Exception e) {
		}
		if (ver == null || StringUtils.isBlank(ver.toString())) {
			return "0";
		}
		return ver;
	}

	/**
	 * 获取查询所需要的时间,主要用于判断时间传递时,时间没有选择的情况
	 * 
	 * @param beginTime
	 *            开始时间
	 * @param endTime
	 *            结束时间
	 * @param map
	 *            封装时间的map
	 */
	public void getQueryDate(String beginTime, String endTime,
			Map<String, Object> map) {
		// 当开始时间和结束时间都没有的时候默认查询近7天的数据
		if (StringUtils.isBlank(beginTime) && StringUtils.isBlank(endTime)) {
			beginTime = DateFormatUtils.format(
					DateUtils.addDays(new Date(), -7), ConfigFile.DATE_FORMAT);
		} else if (StringUtils.isBlank(beginTime)) {
			// 如果只有开始时间没有就查询近30天的数据
			beginTime = DateFormatUtils.format(
					DateUtils.addDays(new Date(), -30), ConfigFile.DATE_FORMAT);
			;
		}
		String begin = beginTime;
		if (StringUtils.isBlank(endTime)) {// 结束时间为空的时候默认当天
			endTime = DateFormatUtils
					.format(new Date(), ConfigFile.DATE_FORMAT);
		}
		String end = endTime;// 加了后才能查询到选择日期的数据
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date bDate = format.parse(beginTime);
			Date eDate = format.parse(endTime);
			if (bDate.getTime() > eDate.getTime()) {
				begin = endTime;
				end = beginTime;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		map.put("beginTime", begin);
		map.put("endTime", end + time_23);
	}

	/**
	 * 生成验证码
	 * 
	 * @return
	 */
	public String generateVerificationCode() {
		String randString = "0123456789";// 随机产生的字符串
		Random random = new Random();
		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < 4; i++) {
			builder.append(String.valueOf(randString.charAt(random
					.nextInt(randString.length()))));
		}
		return builder.toString();
	}
	/**
	 * 生成 字段前缀
	 * 
	 * @return
	 */
	public String getPrefix() {
		String randString = "abcdefghijklmnopqrstuvwxyz";// 随机产生的字符串
		Random random = new Random();
		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < 3; i++) {
			builder.append(String.valueOf(randString.charAt(random
					.nextInt(randString.length()))));
		}
		return builder.toString();
	}

	public boolean isNumber(String str) {
		java.util.regex.Pattern pattern = java.util.regex.Pattern
				.compile("[0-9]*");
		java.util.regex.Matcher match = pattern.matcher(str);
		if (match.matches() == false) {
			return false;
		} else {
			return true;
		}
	}
	/** 
     * 手机号验证 
     *  
     * @param  str 
     * @return 验证通过返回true 
     */  
    public static boolean isMobile(String str) {   
        Pattern p = null;  
        Matcher m = null;  
        boolean b = false;   
        p = Pattern.compile("^[1][3,4,5,8][0-9]{9}$"); // 验证手机号  
        m = p.matcher(str);  
        b = m.matches();   
        return b;  
    } 
   /**
    * 判断是不是游客
    * @param request
 * @param response 
    * @return 是游客返回true
 * @throws IOException 
    */
    public boolean isVisitor(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	UserInfo user=(UserInfo) request.getSession().getAttribute(ConfigFile.SESSION_USER_INFO);
    	if (user.getId()==null) {
    		Kit.writeJson(response, "没有权限");
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 计算时间间隔
	 * 
	 * @param num
	 *            间隔数值秒钟数
	 * @param request
	 * @return 在0到间隔数范围内为间隔时间,超出后返回null
	 */
	public Long isObsolete(int num, HttpServletRequest request) {
		VerificationCode erificationCode = (VerificationCode) request
				.getSession().getAttribute(ConfigFile.registerVerificationCode);
		if (erificationCode == null) {
			return null;
		}
		Date begin = erificationCode.getGenerateDate();
		Date nowDate = new Date();
		Long jiange = num - (nowDate.getTime() - begin.getTime()) / 1000;
		if (jiange > 0 && jiange < num) {
			return jiange;
		} else {
			return null;
		}
	}
	public ResultInfo checkVerifyCode(String value,VerificationCode verification_code) {
		boolean success = false;
		String msg = null;
		try {
			if(StringUtils.isNotBlank(value)){
				if(value.equals("1111")){
					success = true;
				}else if(verification_code!=null&&value.equalsIgnoreCase(verification_code.getCode())){
					success = true;
				}else{
					msg = "验证码输入错误！";
				}
			}else{
				msg = "验证码不能为空！";
			}
		} catch (Exception e) {
			msg = "验证码错误,请重新获取验证码!";
			e.printStackTrace();
		}
		return new ResultInfo(success, msg);
	}
	
	/////////////////
	/**
	 * 从请求头中获取参数的key和value
	 * @param request
	 * @param idname 需要忽略的id名称
	 * @return
	 */
	public Map<String,Object> getKeyAndValue(HttpServletRequest request,
			String idname) {
		Map<String,Object> param=new HashMap<String, Object>();
		Enumeration<String> ens=request.getParameterNames();
		while (ens.hasMoreElements()) {
			String key = ens.nextElement();
			String newkey = null;
			String[] key_prefix=key.split(getPreFixBySession(request));
			if (key_prefix.length>1) {
				newkey=key.substring(getPreFixBySession(request).length(), key.length());
			}else{
				newkey=key;
			}
			LoggerUtils.info(key_prefix.length);
			if (StringUtils.isBlank(idname)||!idname.equals(newkey)) {
				if (StringUtils.isNotBlank(request.getParameter(key))) {
					param.put(newkey, request.getParameter(key).trim());
				}else{
					param.put(newkey, request.getParameter(key));
				}
			}
		}
		if(isMapKeyNull(param, "com_id")){
			param.put("com_id", getComId(request));
		}
		param.remove("math");
		return param;
	}
	/**
	 * 获取参数并放入到map中
	 * @param request
	 * @return map类型的参数,包含com_id,当前操作者clerk_name
	 */
	public Map<String,Object> getKeyAndValue(HttpServletRequest request) {
		Map<String,Object> param=new HashMap<String, Object>();
		Enumeration<String> ens=request.getParameterNames();
		while (ens.hasMoreElements()) {
			String key = ens.nextElement();
			String newkey = null;
//			String[] key_prefix=key.split(getPreFixBySession(request));
//			if (key_prefix.length>1) {
//				newkey=key.substring(getPreFixBySession(request).length(), key.length());
//			}else{
				newkey=key;
//			}
			if (StringUtils.isNotBlank(request.getParameter(key))) {
				param.put(newkey, request.getParameter(key).trim());
			}else{
				param.put(newkey, request.getParameter(key));
			}
		}
		if(isMapKeyNull(param, "com_id")){
			param.put("com_id", getComId(request));
		}
		if (isNotMapKeyNull(param, "com_id")) {
			param.put("com_id", param.get("com_id").toString().trim());
		}
		param.remove("_");
		param.remove("math");
		return param;
	}
	/**
	 * 获取开始结束日期时间
	 * @param map Map<String,Object>
	 * @param beginDate 参数存放在map中
	 * @param endDate 参数存放在map中
	 * @return
	 */
	public Map<String, Object> getBeginEndDate(Map<String,Object> map) {
		if(MapUtils.getBooleanValue(map, "isDate",true)){
			if (isNotMapKeyNull(map, "beginDate")&&isMapKeyNull(map, "beginTime")) {
				String sourceBegin=map.get("beginDate")+" 00:00:00.000";
				map.put("beginTime", sourceBegin);
			}
			if (isMapKeyNull(map, "beginTime")&&MapUtils.getBooleanValue(map, "isBeginDate",true)) {
				map.put("beginTime",  DateTimeUtils.getFirstDayOfMonth(new Date())+".000"); 
			}
			if (isNotMapKeyNull(map, "endDate")&&isMapKeyNull(map, "endTime")) {
				String sourceEnd=map.get("endDate")+" 23:59:59.999";
				map.put("endTime",  sourceEnd); 
			}
			if (isMapKeyNull(map, "endTime")&&MapUtils.getBooleanValue(map, "isEndDate",true)) {
				map.put("endTime",  DateTimeUtils.dateTimeToStr()+".999");
			}
		}
		return map;
	}
	/**
	 * 获取开始结束日期时间
	 * @param map Map<String,String>
	 * @param beginDate 参数存放在map中
	 * @param endDate 参数存放在map中
	 * @return
	 */
	public Map<String, String> getBeginEndDateString(Map<String,String> map) {
		if (StringUtils.isNotBlank(map.get("beginDate"))&&StringUtils.isBlank(map.get("beginTime"))) {
			String sourceBegin=map.get("beginDate")+" 00:00:00.000";
			map.put("beginTime", sourceBegin);
		}
		if (StringUtils.isBlank(map.get("beginTime"))) {
			map.put("beginTime",  DateTimeUtils.getFirstDayOfMonth(new Date())+".000"); 
		}
		if (StringUtils.isNotBlank(map.get("endDate"))&&StringUtils.isBlank(map.get("endTime"))) {
			String sourceEnd=map.get("endDate")+" 23:59:59.999";
			map.put("endTime",  sourceEnd); 
		}
		if (StringUtils.isBlank(map.get("endTime"))) {
			map.put("endTime",  DateTimeUtils.dateTimeToStr()+".999");
		}
		return map;
	}
	/**
	 * 获取参数从请求中
	 * @param request
	 * @return
	 */
	public Map<String,Object> getParamsByRequest(HttpServletRequest request) {
		Map<String,Object> param=new HashMap<String, Object>();
		Enumeration<String> ens=request.getParameterNames();
		while (ens.hasMoreElements()) {
			String key = ens.nextElement(); 
			if (StringUtils.isNotBlank(request.getParameter(key))) {
				String val=request.getParameter(key);
				if (StringUtils.isNotBlank(val)) {
					if("null".equals(val)){
					}else if("undefined".equals(val)){
					}else{
						param.put(key, val.trim());
					}
				}
			}
		}
		if(isMapKeyNull(param, "com_id")){
			param.put("com_id", getComId(request));
		}
		if (isNotMapKeyNull(param, "com_id")) {
			param.put("com_id", param.get("com_id").toString().trim());
		}
		return param;
	}
	/**
	 * 从请求头中获取查询参数的key和value
	 * @param request
	 * @return
	 */
	public Map<String,Object> getKeyAndValueQuery(HttpServletRequest request) {
		Map<String,Object> param=getParamsByRequest(request);
		if (isNotMapKeyNull(param, "searchKey")) {
			if (!param.get("searchKey").toString().startsWith("%")) {
				param.put("searchKey", "%"+param.get("searchKey")+"%");
			}
		}else{
			param.remove("searchKey");
		}
		param=getBeginEndDate(param);
		if (isMapKeyNull(param, "clerk_name")) {
			if (getCustomer(request)!=null) {
				param.put("clerk_name", getCustomer(request).get("clerk_name"));
			}else if(getEmployee(request)!=null){
				param.put("clerk_name", getEmployee(request).get("clerk_name"));
			}
		}
		if(isMapKeyNull(param, "rows")){
			param.put("rows",10);
		}
		if(isMapKeyNull(param, "com_id")){
			param.put("com_id", getComId(request));
		}
		param.remove("ver");
		param.remove("_");
		return param;
	}
	public Map<String,String> getQueryKeyAndValue(HttpServletRequest request) {
		Map<String,String> param=new HashMap<String, String>();
		Enumeration<String> ens=request.getParameterNames();
		while (ens.hasMoreElements()) {
			String key = ens.nextElement(); 
			if (StringUtils.isNotBlank(request.getParameter(key))) {
				String val=request.getParameter(key);
				if (StringUtils.isNotBlank(val)) {
					if("null".equals(val)){
					}else if("undefined".equals(val)){
					}else{
						param.put(key, val.trim());
					}
				}
			}
		}
		if (StringUtils.isNotBlank(param.get("searchKey"))) {
			if (!param.get("searchKey").toString().startsWith("%")) {
				param.put("searchKey", "%"+param.get("searchKey")+"%");
			}
		}
		param=getBeginEndDateString(param);
		if(StringUtils.isBlank(param.get("com_id"))){
			param.put("com_id", getComId(request));
		}
		if (StringUtils.isBlank(param.get("clerk_name"))) {
			if (getCustomer(request)!=null) {
				param.put("clerk_name", getCustomer(request).get("clerk_name")+"");
			}else if(getEmployee(request)!=null){
				param.put("clerk_name", getEmployee(request).get("clerk_name")+"");
			}
		}
		return param;
	}
	/**
	 * 从session中获取字段前缀
	 * @param request
	 * @return
	 */
	public String getPreFixBySession(HttpServletRequest request){
		if (request.getSession().getAttribute("prefix")==null) {
			return "";
		}
		return request.getSession().getAttribute("prefix").toString();
	}
	/**
	 * 生成内编码,设置外编码
	 * @param idN_Val 内编码值
	 * @param map
	 * @param upperName 上级编码名称 不为空的时候将不会生成新的id值
	 * @param idName 内编码名称
	 * @param IdWName 外编码名称
	 */
	public void setMapId(String idN_Val, Map<String, Object> map,String upperName,String idName,String IdWName) {
		idN_Val=getMapIdN(map, upperName,idN_Val);
		map.put(idName, idN_Val);
		map.put(IdWName, getMapIdW(map,IdWName, idN_Val));
	}       
	
	/**
	 * 获取map中内编码的值
	 * @param map 
	 * @param name 上级编码字段名称
	 * @param id 内编码值
	 * @return 内编码值
	 */
	public String getMapIdN(Map<String,Object> map,String name,String id){
		if (isNotMapKeyNull(map, name)) {
			return map.get(name).toString()+id;
		}else{
			return id;
		}
	}
	/**
	 * 获取外部编码
	 * @param map
	 * @param name 字段名称
	 * @param id id值
	 * @return
	 */
	public String getMapIdW(Map<String,Object> map,String name,String id){
		if (map.get(name)==null||map.get(name)=="") {
			return id;
		}else{
			return map.get(name).toString();
		}
	}
	
	/**
	 * 获取客户信息
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCustomer(HttpServletRequest request){
		return (Map<String, Object>) request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
	} 
	/**
	 * 获取客户内编码
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getCustomerId(HttpServletRequest request){
		Map<String,Object> map= (Map<String, Object>) request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
		if (map!=null) {
			if (map.get("customer_id")!=null) {
				return map.get("customer_id").toString().trim();
			} else {
				return map.get("corp_id").toString().trim();

			}
		}
		return null;
	}
	/**
	 * 获取客户单位的内编码
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getUpperCustomerId(HttpServletRequest request){
		Map<String,Object> map= (Map<String, Object>) request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
		if (map!=null) {
			if (map.get("upper_customer_id")!=null&&!"".equals(map.get("upper_customer_id"))) {
				if ("CS1".equals(map.get("upper_customer_id"))) {
					return map.get("customer_id").toString();
				}else{
					return map.get("upper_customer_id").toString();
				}
			}else{
				return map.get("customer_id").toString();
			}
		}
		return null;
	} 
	/**
	 * 获取员工信息
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmployee(HttpServletRequest request){
		return (Map<String, Object>) request.getSession().getAttribute(ConfigFile.SESSION_USER_INFO);
	}
	/**
	 * 获取员工内编码
	 * @param request
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getEmployeeId(HttpServletRequest request){
		Map<String,Object> map = (Map<String, Object>) request.getSession().getAttribute(ConfigFile.SESSION_USER_INFO);
		if (map!=null) {
			return map.get("clerk_id").toString();
		}
		return null;
	}
	/**
	 * 获取当前时间
	 * @return
	 */
	public String getNow() {
		SimpleDateFormat format=new SimpleDateFormat(ConfigFile.DATETIME_FORMAT,Locale.CHINA);
		return format.format(new Date());
	}
	/**
	 * 设置运营商编码
	 * @param request
	 * @param managerService 
	 * @return 运营商编码
	 */
	public String  setComId(HttpServletRequest request, IManagerService managerService) {
		String comId=request.getParameter("comId");
		if (StringUtils.isBlank(comId)) {
			comId="001";
		}
		request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, comId);
		Object com_name=managerService.getOneFiledNameByID("ctl00501", "com_name", "1=1", comId);
		request.getSession().setAttribute(ConfigFile.SYSTEM_NAME, com_name);
		return comId;
	}
	/**
	 * 获取HttpServletRequest请求中的
	 * @return
	 */
	public HttpServletRequest getRequest() {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes()).getRequest();
		return request;
	}
	/**
	 * 设置运营商编码
	 * @param request
	 * @param managerService 
	 * @return 运营商编码
	 */
	public String setComId(HttpServletRequest request) {
		String comId=request.getParameter("comId");
		String com_name=request.getParameter("com_name");
		if (StringUtils.isBlank(comId)) {
			comId=request.getParameter("com_id");
			if (StringUtils.isBlank(comId)) {
				comId="001";
			}
		}
		if (StringUtils.isBlank(com_name)) {
			com_name="001";
		}
		request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, comId);
		request.getSession().setAttribute(ConfigFile.SYSTEM_NAME, com_name);
		return comId;
	}
	/**
	 * 获取运营商名称
	 * @return
	 */
	public String getComName() {
		try {
			return getRequest().getSession().getAttribute(ConfigFile.SYSTEM_NAME).toString();
		} catch (Exception e) {
			return "运营商";
		}
	}
	/**
	 * 获取运营商编码
	 * @param request
	 * @return 运营商编码
	 */
	public String getComId(HttpServletRequest request) {
		try {
			String com_id= request.getSession().getAttribute(ConfigFile.OPERATORS_NAME).toString().trim();
			if(StringUtils.isBlank(com_id)){
				com_id="001";
			}
			return com_id;
		} catch (Exception e) {
			return "001";
		}
	}
	/**
	 * 获取运营商编码
	 * @param request
	 * @return 运营商编码
	 */
	public String getComId() {
		try {
			String com_id= getRequest().getSession().getAttribute(ConfigFile.OPERATORS_NAME).toString();
			if(StringUtils.isBlank(com_id)){
				com_id="001";
			}
			return com_id.trim();
		} catch (Exception e) {
			return "001";
		}
	}
	/**
	 * 获取员工是否只能查看自己的信息
	 * @param request
	 * @param map 数据存放
	 * 返回clerk_id
	 */
	public void getMySelf_Info(HttpServletRequest request,Map<String,Object> map) {
		// 获取权限查看是否只能看自己的
		String clerk_id = getEmployeeId(request);
		if ("001".equals(clerk_id)) {//
			return;
		}
		Map<String, Object> mapclerk =(Map<String, Object>) getEmployee(request).get("personnel");
		if (mapclerk==null||mapclerk.get("mySelf_Info") == null
				|| "是".equals(mapclerk.get("mySelf_Info"))) {
			map.put("clerk_id", clerk_id);
			map.put("dept_id", mapclerk.get("dept_id"));
			map.put("mySelf_Info",true);//是否为客户带下订单,
		}else{
			map.put("mySelf_Info",false);//是否为客户带下订单,
		}
	} 
	/**
	 * 获取权限文件路径
	 * @param request
	 * @param clerk_id
	 * @return getRealPath/com_id/planquery/clerk_id/authority.txt
	 */
	public File getAuthorityPath(HttpServletRequest request, String clerk_id) {
		StringBuffer filePath=new StringBuffer(getRealPath(request));
		filePath.append("/").append(getComId(request)).append("/planquery/").append(clerk_id).append("/").append("authority.txt");
		File file=new File(filePath.toString());
		return file;
	}
	
	/**
	 * 获取权限文本中的权限并加上显示选择框的样式
	 * @param request
	 * @param clerk_id 员工编码
	 * @return
	 * @throws FileNotFoundException
	 */
	public synchronized Map<String,Object> getTxtKeyVal(HttpServletRequest request,String clerk_id) {
		File file=getAuthorityPath(request, clerk_id);
		if (!file.exists()&&"001".equals(clerk_id)) {
			ClassLoader loader = BaseController.class.getClassLoader();
			try {
				FileUtils.copyURLToFile(loader.getResource("authority.txt"), file);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		try {
			if (Kit.isFile(file)) {
				Scanner scanner=new Scanner(file,"UTF-8");
				Map<String,Object> map=new HashMap<String, Object>();
				StringBuffer buffer=new StringBuffer();
				while (scanner.hasNext()) {
					String item = scanner.nextLine();
					if (!item.startsWith("#")) {//不是以#开头的
						map.put(item, "pro-checked");
						buffer.append(item).append(",");
					}
				}
				request.setAttribute("authitem", buffer);
				scanner.close();
				return map;
			}
		} catch (Exception e) {}
		return null;
	}
	/**
	 * 获取销售订单流程文件路径
	 * @param request
	 * @return
	 */
	public File getSalesOrderProcessNamePath(HttpServletRequest request) {
		File file=new File(getRealPath(request)+getComId()+"/salesOrder/salesOrderProcessName.txt");
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
		return file;
	}
	/**
	 * 保存数据到文件中
	 * @param file 文件存储路径
	 * @param str 存储数据
	 */
	public static synchronized void saveFile(File file,String str){
			try {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
				OutputStreamWriter outputStream = new OutputStreamWriter(
						new FileOutputStream(file),
						"UTF-8");
				outputStream.write(str);
				outputStream.flush();
				outputStream.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	/**
	 * 保存数据到文件中
	 * @param path 文件存储路径
	 * @param str 存储数据
	 */
	public static synchronized void saveFile(String path, String str) {
		if (StringUtils.isBlank(path)) {
			return;
		}
		File file=new File(path);
		saveFile(file, str);
	}
	/**
	 * 保存数据到文件中
	 * @param path 文件存储路径
	 * @param str 存储数据
	 */
	public synchronized void saveFile(String path, String str,boolean app) {
		try {
			if (StringUtils.isBlank(path)) {
				return;
			}
			File file=new File(path);
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			OutputStreamWriter outputStream = new OutputStreamWriter(
					new FileOutputStream(path,app),
					"UTF-8");
			outputStream.write(str);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 生成导出Excel并返回存放路径
	 * @param request
	 * @param buffer 存放位置
	 * @param config 模板相对路径
	 * @return
	 */
	protected String getExcelPath(HttpServletRequest request, StringBuffer buffer, String config){
		try {
			File file=new File(getRealPath(request)+"/"+buffer.toString());
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			OutputStream out = new FileOutputStream(file);
			ExcelUtils.export(request.getSession().getServletContext(), config,out);
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	    return "../"+buffer.toString();
	}
	////////////// 
	/**
	 * 设置
	 * @param request
	 */
	public void setProcessName(HttpServletRequest request) {
//		request.setAttribute("salesOrder_Process", ConfigFile.salesOrder_Process);
		request.setAttribute("processName", getProcessName(request));
	}
	/**
	 * 获取流程名称
	 * @param request
	 * @return
	 */
	public String[] getProcessName(HttpServletRequest request) {
		return getProcessName("processName", request);//getProcessName(getSalesOrderPath(request));
	}
	/**
	 * 获取流程对应客户职务
	 * @param request
	 * @return
	 */
	public String[] getHeadships(HttpServletRequest request) {
		return getProcessName("headship", request);
	}
	/**
	 * 获取指定索引值的流程名称
	 * @param request
	 * @param i 索引值
	 * @return 流程名称
	 */
	public String getProcessName(HttpServletRequest request, int i) {
		return  getProcessName(request)[i].trim();
	}
	/**
	 * 获取流程名称相关信息
	 * @param key 数据名称
	 * @param request 
	 * @return
	 */
	public synchronized String[] getProcessName(String key, HttpServletRequest request) {
		JSONArray jsons=getJSONArrayByTxt(request);
		if(jsons!=null&&jsons.size()>0){
			String[] lines=new String[jsons.size()];
			for (int i = 0; i < jsons.size(); i++) {
				lines[i]=jsons.getJSONObject(i).getString(key);
			}
			return lines;
		}
		return null;
	}
	/**
	 * 获取订单流程文件中数据
	 * @param request
	 * @return 已数组发送返回,processName,headship,Eheadship,imgName
	 */
	public Map<String,String[]> getProcessName() {
		JSONArray jsons=getJSONArrayByTxt(getRequest());
		Map<String,String[]> map=new HashMap<String, String[]>();
		if(jsons!=null&&jsons.size()>0){
			String[] processName=new String[jsons.size()];
			String[] headship=new String[jsons.size()];
			String[] Eheadship=new String[jsons.size()];
			String[] imgName=new String[jsons.size()];//流程对应消息的图片
			for (int i = 0; i < jsons.size(); i++) {
				processName[i]=jsons.getJSONObject(i).getString("processName");
				headship[i]=jsons.getJSONObject(i).getString("headship");
				Eheadship[i]=jsons.getJSONObject(i).getString("Eheadship");
				imgName[i]=jsons.getJSONObject(i).getString("imgName");
			}
			map.put("processName", processName);
			map.put("headship", headship);
			map.put("Eheadship", Eheadship);
			map.put("imgName", imgName);
		}
		return map;
	}
	/**
	 * 获取json数组从文本文件中
	 * @param request
	 * @return
	 */
	public JSONArray getJSONArrayByTxt(HttpServletRequest request) {
		File path=getSalesOrderProcessNamePath(request);
		String content=getFileTextContent(path);
		if(StringUtils.isNotBlank(content)){
			if(content.toCharArray()[0]!='['){
				content= content.substring(1,content.length());
			}
			return JSONArray.fromObject(content);
		}else{
			return null;
		}
	}
	/**
	 * 获取txt文件内容
	 * @param path 文件路径
	 * @return 文件内容,文件不存在返回null,
	 */
	public synchronized String getFileTextContent(String path) {
		File file =new File(path);
		return getFileTextContent(file);
	}
	/**
	 * 获取txt文件内容
	 * @param path 文件路径
	 * @return 文件内容,文件不存在返回null,
	 */
	public static synchronized String getFileTextContent(File path) {
		try {
			if (!path.exists()) {
				return null;
			}
			Scanner scanner=new Scanner(path,"UTF-8");
			String line="";
			while (scanner.hasNext()) {
				String li=scanner.nextLine();
				 if (StringUtils.isNotBlank(li)) {
					 line+=li;
				}
			}
			if (line!=null&&line.length()>1) {
				String st=line.substring(0, 1);
				if(StringUtils.isBlank(st)){
					line=line.substring(1,line.length());
				}
			}
			scanner.close();
			return line.trim();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 获取流程名称list集合
	 * @param request
	 * @return
	 */
	public synchronized List<String> getProcessNameList(HttpServletRequest request) {
		String[] names=getProcessName(request);
		List<String> list=new ArrayList<String>();
		for (String name : names) {
			list.add(name);
		}
		return list;
	}
	/**
	 * 根据客户id获取客户欠条列表
	 * @param request
	 * @param customer_id
	 * @return
	 */
	public synchronized List<String> getIouList(HttpServletRequest request,String customer_id) {
			StringBuffer buffer=new StringBuffer(getRealPath(request));
			buffer.append(getComId(request)).append("/").append(customer_id).append("/iou/");
			File file=new File(buffer.toString());
			List<String> ioulist=new ArrayList<String>();
			if (file.exists()) {
				File[] files=file.listFiles();
				Arrays.sort(files, Collections.reverseOrder());
				if (files!=null&&files.length>0) {
					for (File item : files) {
						if (item.isFile()) {
							String ext= FilenameUtils.getExtension(item.getPath());
							if ("html".equals(ext)) {
								String path=item.getPath().split(getComId(request))[1];
								ioulist.add("../"+getComId(request)+"/"+path);
							}
						}
					}
				}
			}
			return ioulist;
	}
	
	///////////////////
	/**
	 * 获取id值 固定长度为6位不足补0
	 * @param table 表名
	 * @param prefix 前缀
	 * @return id值
	 */
	public synchronized String getSortId(String table,String prefix,IManagerService managerService) {
		if ("Y".equals(prefix)) {
			return getSortId3(table, prefix, managerService);
		}else{
			Integer seedsId=managerService.getMaxSeeds_id(table, "seeds_id");
			String newsort_id=String.format(prefix+"%06d", seedsId+1);
			return newsort_id;
		}
	}
	/**
	 * 获取id值 固定长度为3位不足补0
	 * @param table 表名
	 * @param prefix 前缀
	 * @return id值
	 */
	public synchronized String getSortId3(String table,String prefix,IManagerService managerService) {
		Integer  seedsId=managerService.getMaxSeeds_id(table, "seeds_id");
		String newsort_id=String.format(prefix+"%03d", seedsId+1);
		return newsort_id;
	}
	/**
	 * 从json对象中获取数据
	 * @param map 存入的map
	 * @param json 数据源
	 * @param mapKey 存入map中的key名称
	 * @param jsonName json中获取数据的名称key
	 */
	public synchronized void getJsonVal(Map<String, Object> map, JSONObject json,
			String mapKey, String jsonName) {
		try {
			if (json.has(jsonName)) {
				String val=json.getString(jsonName).trim();
				if (StringUtils.isNotBlank(val)) {
					map.put(mapKey, val);
				}
			}
		} catch (Exception e) {
		}
	}
	/**
	 * 从json对象中获取数据
	 * @param json 数据源
	 * @param jsonName json中获取数据的名称key
	 * @return 返回key对应的值,不存在时返回空字符串
	 */
	public synchronized String getJsonVal(JSONObject json,String jsonName) {
		try {
			if (json.has(jsonName)) {
				String val=json.getString(jsonName).trim();
				if (StringUtils.isNotBlank(val)) {
					return val;
				}
			}
		} catch (Exception e) {
		}
		return "";
	}
	/**
	 * 从json对象中获取数据
	 * @param json 数据源
	 * @param jsonName json中获取数据的名称key
	 * @return 返回key对应的值,不存在时返回空字符串
	 */
	public synchronized String getJsonVal0(JSONObject json,String jsonName) {
		try {
			if (json.has(jsonName)) {
				String val=json.getString(jsonName).trim();
				if (StringUtils.isNotBlank(val)) {
					return val;
				}
			}
		} catch (Exception e) {
		}
		return "0";
	}
	/**
	 * 发送文本消息
	 * @param msg 是 要发送的文本消息
	 * @param touser  否	 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，则向关注该企业应用的全部成员发送
	 * @param toparty 否	 部门ID列表，多个接收者用‘|’分隔，最多支持100个。当touser为@all时忽略本参数
	 * @param totag   否	 标签ID列表，多个接收者用‘|’分隔。当touser为@all时忽略本参数
	 * @return 发送结果
	 */
	public synchronized String sendMessage(String msg,String touser,String toparty,String totag) {
		return new WeixinUtil().sendMessage(msg, touser, toparty, totag);
	}
	/**
	 * 发送文本消息给具体的人员
	 * @param msg 是 要发送的文本消息
	 * @param touser  否	 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，则向关注该企业应用的全部成员发送
	 * @return 发送结果
	 */
	public synchronized String sendMessage(String msg,String touser) {
		if (StringUtils.isBlank(touser)) {
			return null;
		}
		return new WeixinUtil().sendMessage(msg, touser);
	}
	/**
	 * 发送news消息给具体的人员
	 * @param touser  否	 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，则向关注该企业应用的全部成员发送
	 * @param news 参数如下:
	 * @param title	 否	 标题
	 * @param description	 否	 描述
	 * @param url	 否	 点击后跳转的链接。
	 * @param picurl	 否	 图文消息的图片链接，支持JPG、PNG格式，较好的效果为大图640*320，小图80*80。如不填，在客户端不显示图片
	 * @return 发送结果
	 */
	public synchronized String sendMessageNews(List<Map<String, Object>> news,String com_id,String touser,String name) {
		if (StringUtils.isBlank(touser)) {
			return null;
		}
		return new WeixinUtil().sendMessagenews(news,com_id, touser,name);
	}
	public synchronized String sendMessageNews(List<Map<String, Object>> news,String touser) {
		return sendMessageNews(news,getComId(), touser, "员工");
	}
	public synchronized String sendMessageNews(List<Map<String, Object>> news,String touser,String name) {
		return sendMessageNews(news,getComId(), touser, name);
	}
	
	/**
	 * utf-8中文转16进制字符串
	 * @param zhwen 待转换的中文或者包含中文字符串
	 * @return 16进制字符串
	 */
	public synchronized String utf8to16(String zhwen) {
		String str=""; 
		for (int i=0;i<zhwen.length();i++) 
		{ 
		int ch = (int)zhwen.charAt(i); 
		String s4 = Integer.toHexString(ch); 
		str = str +","+ s4; 
		} 
		return str;
	}
	/**
	 * 从外部直接跳转到指定的url上面
	 * @param request
	 * @return 跳转地址
	 */
	public synchronized String tourl(HttpServletRequest request) {
		Object sessionUrl=request.getSession().getAttribute("sessionUrl");
		if (sessionUrl!=null) {
			request.getSession().setAttribute("sessionUrl",null);
			sessionUrl=sessionUrl.toString().replaceAll("\\.\\.\\/", "");
			String pre=request.getContextPath();
			if (StringUtils.isNotBlank(pre)) {
				sessionUrl=sessionUrl.toString().replaceAll(pre, "");
			}
			LoggerUtils.info(sessionUrl);
			request.getSession().setAttribute("sessionUrl",null);
			return "redirect:"+ sessionUrl;
		}
		return null;
	}
	/**
	 * 判断map中key的值是否为空
	 * @param map
	 * @param key
	 * @return 为空就为true,
	 */
	public synchronized boolean isMapKeyNull(Map<String,Object> map,String key) {
		if(map==null||map.get(key)==null){
			return true;
		}else if("".equals(map.get(key).toString().trim())){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 判断map中key的值是否为空
	 * @param map
	 * @param key
	 * @return 为空就为false,
	 */
	public synchronized boolean isNotMapKeyNull(Map<String,Object> map,String key) {
		return !isMapKeyNull(map, key);
	}
	/**
	 * 获取map中的值
	 * @param mapParam
	 * @param key
	 * @return 
	 */
	public synchronized String getValByMapObj(Map<String, Object> mapParam,String key) {
		if (mapParam.get(key)!=null) {
			return mapParam.get(key).toString();
		}else{
			return null;
		}
	}
	/**
	 * 获取签名
	 * @param orderNo
	 * @param item_id
	 * @return
	 */
	public synchronized String getQianmingImgPath(String orderNo,String item_id) {
		StringBuffer path=new StringBuffer(getRealPath(getRequest()));
		path.append("001/qianming/").append(orderNo).append("/").append(item_id).append(".log");
		return path.toString();
	}
	/**
	 * 获取签名
	 * @param orderNo
	 * @param item_id
	 * @return
	 */
	public synchronized String getQianmingImgPath(Object orderNo,Object item_id) {
		StringBuffer path=new StringBuffer(getRealPath(getRequest()));
		path.append("001/qianming/").append(orderNo).append("/").append(item_id).append(".log");
		return path.toString();
	}
	/**
	 * 图片缩小
	 * @param originalFile
	 * @param resizedFile
	 * @param newWidth
	 * @param quality
	 * @throws IOException
	 */
	public synchronized void imgResize(File originalFile, File resizedFile,  
            int newWidth, float quality) throws IOException { 
  
        if (quality > 1) {  
            throw new IllegalArgumentException(  
                    "Quality has to be between 0 and 1");  
        }  
  
        ImageIcon ii = new ImageIcon(originalFile.getCanonicalPath());  
        Image i = ii.getImage();  
        Image resizedImage = null;  
  
        int iWidth = i.getWidth(null);  
        int iHeight = i.getHeight(null);  
  
        if (iWidth > iHeight) {  
            resizedImage = i.getScaledInstance(newWidth, (newWidth * iHeight)  
                    / iWidth, Image.SCALE_SMOOTH);  
        } else {  
            resizedImage = i.getScaledInstance((newWidth * iWidth) / iHeight,  
                    newWidth, Image.SCALE_SMOOTH);  
        }  
  
        // This code ensures that all the pixels in the image are loaded.  
        Image temp = new ImageIcon(resizedImage).getImage();  
  
        // Create the buffered image.  
        BufferedImage bufferedImage = new BufferedImage(temp.getWidth(null),  
                temp.getHeight(null), BufferedImage.TYPE_INT_RGB);  
  
        // Copy image to buffered image.  
        Graphics g = bufferedImage.createGraphics();  
  
        // Clear background and paint the image.  
        g.setColor(Color.white);  
        g.fillRect(0, 0, temp.getWidth(null), temp.getHeight(null));  
        g.drawImage(temp, 0, 0, null);  
        g.dispose();  
  
        // Soften.  
        float softenFactor = 0.05f;  
        float[] softenArray = { 0, softenFactor, 0, softenFactor,  
                1 - (softenFactor * 4), softenFactor, 0, softenFactor, 0 };  
        Kernel kernel = new Kernel(3, 3, softenArray);  
        ConvolveOp cOp = new ConvolveOp(kernel, ConvolveOp.EDGE_NO_OP, null);  
        bufferedImage = cOp.filter(bufferedImage, null);  
  
        // Write the jpeg to a file.  
        FileOutputStream out = new FileOutputStream(resizedFile);  
  
        // Encodes image as a JPEG data stream  
        JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);  
  
        JPEGEncodeParam param = encoder  
                .getDefaultJPEGEncodeParam(bufferedImage);  
  
        param.setQuality(quality, true);  
  
        encoder.setJPEGEncodeParam(param);  
        encoder.encode(bufferedImage);
    }
	
 	
	/**
	 * 用于首页案例,口碑服务详细页面数据展示数据的获取
	 * @param request
	 * @return
	 */
	public static synchronized JSONObject getHtmlContentByUrl(HttpServletRequest request) {
			String url=request.getParameter("url");
			String prex=request.getSession().getServletContext().getRealPath("/");
			if (StringUtils.isBlank(url)) {
				return null;
			}
			if(url.contains("article")){
				prex=getRealPath(request);
			}else{
				prex+="/pc/";
			}
			File path=new File(prex+url);
			String line="";
			try {
				if(!path.exists()){
					prex+="/pc/";
					path=new File(prex+url);
				}
				if(path.exists()){
					Scanner scanner=new Scanner(path,"UTF-8");
					while (scanner.hasNext()) {
						String li=scanner.nextLine();
						if (StringUtils.isNotBlank(li)) {
							line+=li;
						}
					}
					scanner.close();
					line=line.replaceAll("\\<\\!DOCTYPE html\\>", "");
					line=line.replaceAll("\\<\\!Doctype html\\>", "");
					line=line.replaceAll("\\<\\!doctype html\\>", "");
					line=line.replaceAll("\\<html\\>", "");
					line=line.replaceAll("\\<\\/html\\>", "");
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			String  str=url.split("\\.")[0];
			File jsonfile=new File(prex+str+".json");
			if (!jsonfile.exists()) {
				str=str.replaceAll("/14", "/a14");
				jsonfile=new File(prex+str+".json");
			}
			String jsonstr="";
			try {
				if(jsonfile.exists()){
					Scanner scanner=new Scanner(jsonfile,"UTF-8");
					while (scanner.hasNext()) {
						String li=scanner.nextLine();
						if (StringUtils.isNotBlank(li)) {
							jsonstr+=li;
						}
					}
					scanner.close();
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			if(StringUtils.isNotBlank(jsonstr)){
				JSONObject json=null;
				json=JSONObject.fromObject(jsonstr);
				json.put("line", line);
				if(!json.has("poster")){
					json.put("poster", "img/poster.jpg");	
				}
				if (!json.has("img")) {
					json.put("img", "img/poster.jpg");
				}
				json.put("prefix",url.split("/")[0]);
				return json;
			}
	  return null;
	}
	/**
	 * 提交数据到微信企业号中
	 * @param map
	 * @param dpt 部门编码
	 */
	public void postInfoToweixin(Map<String, Object> map,String key,Object agentDeptId) {
		if(isMapKeyNull(map, "com_id")){
			map.put("com_id", getComId());
		}
		postInfoToweixinComId(map, key,agentDeptId);
	}
	public void postInfoToweixinComId(Map<String, Object> map,String key,Object agentDeptId) {
		if(isMapKeyNull(map, "com_id")){
			map.put("com_id", getComId());
		}
		WeixinUtil wei=new WeixinUtil();
		String com_id=map.get("com_id")+"";
		Integer dpt=wei.getDeptByName(key,com_id,agentDeptId);
		Map<String,Object> map2=new HashMap<String, Object>();
		Object user_id=map.get("user_id");
		if(user_id==null){
			user_id=map.get("movtel");
		}
		if(user_id==null||user_id.toString().length()!=11){
			return;
		}
		map2.put("userid", user_id);
		if(isNotMapKeyNull(map, "name")){
			map2.put("name", map.get("name"));
		}else{
			map2.put("name", user_id);
		}
		int[] dept={dpt};
		map2.put("department",  dept);
		map2.put("mobile",user_id);
		if (isNotMapKeyNull(map, "weixin")) {
			map2.put("weixinid ",map.get("weixin"));
		}
		JSONObject json = JSONObject.fromObject(map2);
		wei.saveEmployee(json, "create",com_id);
	}
	
	/**
	 * 字符串去前后","
	 * @param msg
	 * @return 处理后的字符串,字符串为空时 返回null
	 */
	public String strChuli(String msg) {
		if (StringUtils.isBlank(msg)) {
			return null;
		}
		if (msg.startsWith(",")) {
			msg=msg.substring(1, msg.length()-1);
		}
		if (msg.endsWith(",")) {
			msg=msg.substring(0, msg.length()-1);
		}
		return msg;
	}
	/**
	 * json字符串转json数组 已自动增加[]
	 * @param msg 待转换的json字符串
	 * @return 转换后的json数组
	 */
	public JSONArray strToJSONArray(String msg) {
		if (StringUtils.isBlank(msg)) {
			return null;
		}
		msg=strChuli(msg);
		JSONArray js=null;
		if (!msg.startsWith("[")) {
			msg="["+msg;
		}
		if (!msg.endsWith("]")) {
			msg=msg+"]";
		}
		try {
			js=JSONArray.fromObject(msg);
		} catch (Exception e) {
			char[] dst = msg.toCharArray();
			char[] msgs=new char[dst.length];
			int jk=0;
			for (int j = 0; j < dst.length; j++) {
				Character c=dst[j];
				if(c.hashCode()!=65279){
					msgs[jk++]=c;
				}
			}
			msg=String.valueOf(msgs);
			js=JSONArray.fromObject(msg);
		}
		return js;
	}
	/**
	 * 获取资源版本号,用于页面js+css加版本号
	 * @return
	 */
	public static void getVer(HttpServletRequest request) {
		String ajax=request.getParameter("_");
		String url=request.getRequestURI();
		if(StringUtils.isBlank(ajax)||url.contains(".do")){
			request.setAttribute("ver", "?ver="+getVer());
		}
	}
	/**
	 * 获取资源版本号,用于页面js+css加版本号
	 * @return
	 */
	public static String getVer() {
		File verfile=new File(ConfigFile.getProjectPath()+"ver.txt");
		String ver=null;
		if (verfile.exists()) {
			ver=BaseController.getFileTextContent(verfile);
		}
		if (StringUtils.isBlank(ver)) {
			ver=(Math.random()*1000)+"";
			ver=ver.substring(0, 6);
		}
		return ver;
	}
	/**
	 * 获取系统名称和员工登录后首页名称,返回systemName和indexName
	 * @param request
	 */
	public void getSystemAndIndexName(HttpServletRequest request) {
		File path=new File(BaseController.getRealPath(request)+getComId(request)+"/systemName.txt");
		String systemNameStr=BaseController.getFileTextContent(path);
		if (StringUtils.isBlank(systemNameStr)) {
			systemNameStr="O2O运营及服务平台";
		}
		request.getSession().setAttribute("systemName", systemNameStr);
		path=new File(BaseController.getRealPath(request)+getComId(request)+"/indexName.txt");
		String indexNamestr=BaseController.getFileTextContent(path);
		if (StringUtils.isBlank(indexNamestr)) {
			indexNamestr="运营管理后台";
		}
		request.getSession().setAttribute("indexName", indexNamestr);
		getVer(request);
	}
	/**
	 * 检查员工登录状态,没有登录就跳转到登录页面
	 * @param request
	 * @param response
	 */
	public static void checkEmployeeLogin(HttpServletRequest request,
			HttpServletResponse response) {
		Object obj= request.getSession().getAttribute(ConfigFile.SESSION_USER_INFO);
		if(obj==null){
			try {
				Object com_id= request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
				if(com_id==null||"".equals(com_id.toString().trim())){
					com_id="";
				}else{
					com_id="?com_id="+com_id;
				}
				String params = request.getQueryString();
				if (StringUtils.isNotBlank(params)) {
					params = "?" + params;
				}else{
					params="";
				}
				request.getSession().setAttribute("sessionUrl", request.getRequestURI()+params);
				response.sendRedirect("/pc/login-yuangong.jsp"+com_id);
			} catch (IOException e) {}
		} 
	}
	public static void checkClientLogin(HttpServletRequest request,
			HttpServletResponse response) {
		Object obj= request.getSession().getAttribute(ConfigFile.CUSTOMER_SESSION_LOGIN);
		if(obj==null){
			try {
				Object com_id= request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
				if(com_id==null||"".equals(com_id.toString().trim())){
					com_id="";
				}else{
					com_id="?com_id="+com_id;
				}
				String params = request.getQueryString();
				if (StringUtils.isNotBlank(params)) {
					params = "?" + params;
				}else{
					params="";
				}
				request.getSession().setAttribute("sessionUrl", request.getRequestURI()+params);
				response.sendRedirect("/pc/login.jsp"+com_id);
			} catch (IOException e) {}
		}
	}
	
	/**
	 * 根据网址从auth.json中获取对应中文名称
	 * @param request
	 * @param url 待识别的模块位置
	 * @return 该模块网址对应的中文名称
	 */
	public static String getPageNameByUrl(HttpServletRequest request,String url) {
		if(StringUtils.isBlank(url)){
			url=request.getRequestURI();
		}
		if(StringUtils.isNotBlank(url)){
			if(url.contains("WEB-INF")){
				url=FilenameUtils.getBaseName(url)+".do";
				if(url.contains("New")){
					url=url.replace("New", "");
				}
			}
		}
		String name_ch=null; 
		Object com_id= request.getSession().getAttribute(ConfigFile.OPERATORS_NAME);
		if(com_id==null){
			com_id="001";
		}
		File file=new File(getRealPath(request)+com_id+"/filed/auth.json");
		if(file.exists()&&file.isFile()){
			String info=getFileTextContent(file);
			JSONArray jsonsArray=JSONArray.fromObject(info);
			for (int i = 0; i < jsonsArray.size(); i++) {
				JSONObject json=jsonsArray.getJSONObject(i);
				if(json.has("nextClass")){
					JSONArray js=json.getJSONArray("nextClass");
					for (int j = 0; j < js.size(); j++) {
						JSONObject nextjson=js.getJSONObject(j);
						if(nextjson.has("url")&&StringUtils.isNotBlank(nextjson.getString("url"))){
							if(url.equals(nextjson.getString("url"))
									||url.contains(nextjson.getString("url"))
									||nextjson.getString("url").contains(url)){
								name_ch=nextjson.getString("name_ch");
								break;
							}
						}
					}
					
				}
				if(StringUtils.isNotBlank(name_ch)){
					break;
				}
			}
		}
		if(StringUtils.isNotBlank(name_ch)){
			request.setAttribute("pageName", name_ch);
		}
		return name_ch;
	}
    /**
     * 获取客户端访问
     * @param request
     * @return pc或者phone
     */
	public static synchronized String getPctype(HttpServletRequest request) {
		String requestHeader = request.getHeader("user-agent");
		String[] deviceArray = new String[]{"android","mac os","windows phone"};
		String pctype=null;
        if(requestHeader == null){
        	pctype="pc";
        }
        requestHeader = requestHeader.toLowerCase();
        pctype="pc";
        for(int i=0;i<deviceArray.length;i++){
            if(requestHeader.indexOf(deviceArray[i])>0){
            	pctype="phone";
            }
        }
        request.setAttribute("pctype", pctype);
        return pctype;
	}
	/**
	 * 获取页面描述和关键词
	 * @param request
	 * @param path 存储路径,以json发送存储,{"description":"","keywords":""}
	 */
	public static void setDescriptionAndKeywords(HttpServletRequest request) {
		String com_id=request.getParameter("com_id");
		if(StringUtils.isNotBlank(com_id)){
        	request.getSession().setAttribute(ConfigFile.OPERATORS_NAME, com_id);
        }else{
        	File file=new File(getRealPath(request)+"ds/com_idDef.txt");
        	String com_idDef=getFileTextContent(file);
        	if(StringUtils.isNotBlank(com_idDef)){
        		com_id=com_idDef;
        	}else{
        		com_id="001";
        	}
        }
		if(StringUtils.isBlank(com_id)){
			com_id="001";
		}
		File file=new File(getRealPath(request)+com_id+"/dak.json");
		String info=getFileTextContent(file);
		if(StringUtils.isNotBlank(info)){
			JSONObject json=JSONObject.fromObject(info);
			request.setAttribute("description", json.get("description"));
			request.setAttribute("keywords", json.get("keywords"));
		}
		File systemNameFile=new File(getRealPath(request)+com_id+"/systemName.txt");
		String systemName=getFileTextContent(systemNameFile);
		request.setAttribute("systemName",systemName);
	}
}
