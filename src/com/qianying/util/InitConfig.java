package com.qianying.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;

import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import com.alipay.config.AlipayConfig;
import com.qianying.controller.BaseController;
import com.qianying.controller.LoginController;
import com.qianying.integerceptor.Integerceptor;

/**
 * 加载"initConfig.txt配置文件内容
 * 
 * @author dengqiang
 * 
 */
public abstract class InitConfig {
	/**
	 * 获取boolean值
	 * 
	 * @param properties
	 * @param key
	 *            配置项的key值
	 * @param def
	 *            默认值
	 * @return
	 */
	public static Boolean getBoolean(Properties properties, String key,
			boolean def) {
		String log_str = properties.getProperty(key);
		if (StringUtils.isBlank(log_str)) {
			return def;
		}
		Boolean log = Boolean.parseBoolean(log_str.trim());
		return log;
	}
	/**
	 * 获取boolean值
	 * 
	 * @param properties
	 * @param key
	 *            配置项的key值
	 * @param def
	 *            默认值
	 * @return
	 */
	public static Boolean getBoolean(Map<String,Object> map, String key,
			boolean def) {
		Object log_str = map.get(key);
		if (log_str==null) {
			return def;
		}
		Boolean log = Boolean.parseBoolean(log_str.toString().trim());
		return log;
	}

//	/**
//	 * 获取字符串值
//	 * 
//	 * @param properties
//	 * @param key
//	 *            配置项的key值
//	 * @param def
//	 *            默认值
//	 * @return
//	 */
//	private static String getString(Properties properties, String key,
//			String def) {
//		String log_str=null;
//		try {
//			if (properties.getProperty(key)!=null) {
//				log_str = new String(properties.getProperty(key).getBytes(), "utf-8");
//			}
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
//		if (StringUtils.isBlank(log_str)) {
//			return def;
//		}
//		return log_str.trim();
//	}
	/**
	 * 获取字符串值
	 * 
	 * @param map
	 * @param key
	 *            配置项的key值
	 * @param def
	 *            默认值
	 * @return
	 */
	private static String getString(Map<String,Object> map, String key,
			String def) {
		String log_str=null;
//		try {
			if (map.get(key)!=null) {
				log_str=map.get(key).toString();
//				log_str = new String(map.get(key).toString().getBytes(), "utf-8");
			}
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
		if (StringUtils.isBlank(log_str)) {
			return def;
		}
		return log_str.trim();
	}

	/**
	 * 获取Integer整数值
	 * 
	 * @param properties
	 * @param key
	 *            配置项的key值
	 * @param def
	 *            默认值
	 * @return
	 */
	private static Integer getIneger(Properties properties, String key, int def) {
		String log_str = properties.getProperty(key);
		if (StringUtils.isBlank(log_str)) {
			return def;
		}
		Integer log = Integer.parseInt(log_str.trim());
		return log;
	}
	/**
	 * 获取Integer整数值
	 * 
	 * @param map
	 * @param key
	 *            配置项的key值
	 * @param def
	 *            默认值
	 * @return
	 */
	private static Integer getInteger(Map<String,Object> map, String key, int def) {
		Object log_str = map.get(key);
		if (log_str==null) {
			return def;
		}
		Integer log = Integer.parseInt(log_str.toString().trim());
		return log;
	}

	/**
	 * 初始化
	 */
	public static void init() {
		try {
			ClassLoader loader = InitConfig.class.getClassLoader();
			InputStream inStream = loader.getResourceAsStream("initConfig.txt");
			initTxt(inStream);
			sax_url(loader.getResourceAsStream("passlist.xml"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 使用扫描方式读取txt文件中的信息
	 * @param in
	 * @throws IOException 
	 */
	public static void initTxt(InputStream in) throws IOException {
//		WeixinUtil.getErrorMsg();
		Map<String,Object> map= Kit.getTxtKeyVal(in);
		ConfigFile.LOG = getBoolean(map, "log", ConfigFile.LOG);
		// //
		ConfigFile.PRINT_ERROR = getBoolean(map, "print_error",
				ConfigFile.PRINT_ERROR);
		ConfigFile.DEBUG_PHONE = getBoolean(map, "debug_phone",
				ConfigFile.DEBUG_PHONE);
		ConfigFile.DEBUG = getBoolean(map, "debug",
				ConfigFile.DEBUG);
		ConfigFile.NoticeResultAll = getBoolean(map, "NoticeResultAll",
				ConfigFile.NoticeResultAll);
		ConfigFile.ORDER_SMS = getBoolean(map, "order_sms",
				ConfigFile.ORDER_SMS);
		ConfigFile.ORDER_SMS_DEBUG = getBoolean(map, "order_sms_debug",
				ConfigFile.ORDER_SMS_DEBUG);
		ConfigFile.isShowAllProduct = getBoolean(map, "isShowAllProduct",
				ConfigFile.isShowAllProduct);
		ConfigFile.NOSQL = getBoolean(map,"nosql",ConfigFile.NOSQL);
		ConfigFile.ORDER_SMS_NO = getString(map, "order_sms_no",
				"13086652206");
		ConfigFile.systemWeixin = getString(map, "systemWeixin",
				"13086652206");
		ConfigFile.ACAO = getString(map, "ACAO",
				ConfigFile.ACAO);
		ConfigFile.emplName = getString(map, "emplName","");
		ConfigFile.TEXT_WATERMARK = getString(map, "textWatermark",
				"");
		ConfigFile.NoticeStyle = getString(map, "NoticeStyle","2");
	    ConfigFile.urlPrefix = getString(map, "urlPrefix","");
		ConfigFile.Res_Ver = getString(map, "res_ver",getNewVer());//资源版本号,没有时自动随机生成
		ConfigFile.projectName = getString(map, "projectName",
				"o2o");
		ConfigFile.LOGO_URL = getString(map, "logoUrl",
				"/images/logo.png");
		
//		WeixinUtil.corpid = getString(map, "corpid","");
//		WeixinUtil.corpsecret = getString(map, "corpsecret","");
//		WeixinUtil.corpsecret_chat = getString(map, "corpsecret_chat","");
//		WeixinUtil.mch_id=getString(map, "mch_id","1267930701");
//		WeixinUtil.sEncodingAESKey=getString(map, "sEncodingAESKey","ZCXEBykpurC1V54VOmRnDvyJM1LUwEmIgwxhmQujG1r");
//		
//		WeixinUtil.agentid=getInteger(map, "agentid",0);
//		WeixinUtil.agentDeptId=getInteger(map, "agentDeptId",1);
//		WeixinUtil.safe=getInteger(map, "safe",0);
//		WeixinUtil.notify_url =ConfigFile.urlPrefix+ "/weixin/notify_url.do";// 支付回调地址
		//TODO  获取所有账套的
//		new WeixinUtil().getDeptList();
		////////////////////////////////////
		AlipayConfig.key=getString(map, "alipay_key", "");
		AlipayConfig.seller_email=getString(map, "alipay_seller_email", "");
		AlipayConfig.partner=getString(map, "alipay_partner", "");
		///////////////////////////////////
		ConfigFile.LOGDAY = 0 - getInteger(map, "logDay", 15);
		ConfigFile.PlanPush =getInteger(map, "PlanPush", 0);
		ConfigFile.PlanSource =getInteger(map, "PlanSource", 0);
		ConfigFile.QCWay =getInteger(map, "QCWay", 0);
		ConfigFile.POLLDATATIME = getInteger(map, "pollDataTime", 30) * 1000;
		ConfigFile.TOMCAT_DIR = System.getProperty("user.dir");
		if (ConfigFile.TOMCAT_DIR.contains("bin")) {
			File file = new File(ConfigFile.TOMCAT_DIR);
			ConfigFile.TOMCAT_DIR = file.getParent();
		}
		ConfigFile.TOMCAT_DIR = ConfigFile.TOMCAT_DIR + "/"
				+ getString(map, "appBase", "");
		 try {
			
//		String ipstr = getString(map, "ipstr",
//				"http://ip.chinaz.com/?jdfwkey=cpoxi2");
//		ConfigFile.exter_invoke_ip = getIP(ipstr);
		 } catch (Exception e) {}
		String initString = InitConfig.class.getClassLoader()
				.getResource("initConfig.txt").getPath();
		System.out.println("当前initConfig.txt所在路径:" + initString);
		ConfigFile.initModifiedTime = InitConfig
				.getModifiedTime("initConfig.txt");
		ConfigFile.passModifiedTime = InitConfig
				.getModifiedTime("passlist.xml");
	}
	
//	private static String msgEncode(String msg) {
//		try {
//			return new String(msg.getBytes("ISO-8859-1"), "utf-8");
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
//		return msg;
//	}

	/**
	 * 解析需要放行的请求xml
	 * 
	 * @param in
	 */
	@SuppressWarnings("unchecked")
	public static void sax_url(InputStream in) {
		if (in == null) {
			ClassLoader loader = InitConfig.class.getClassLoader();
			in = loader.getResourceAsStream("passlist.xml");
		}
		try {
			SAXReader reader = new SAXReader();
			Document document = reader.read(in);
			Element rootElm = document.getRootElement();
			List<Element> nodes = rootElm.elements("item");
			BaseController.type_ext_List.clear();
			for (Iterator<Element> it = nodes.iterator(); it.hasNext();) {
				Element elm = it.next();
				String url = elm.attributeValue("url");
				if (StringUtils.isNotBlank(url)) {
					Integerceptor.url_list.add(url); 
				}
				String type = elm.attributeValue("type");
				String ext = elm.attributeValue("ext");
				if (StringUtils.isNotBlank(ext) && StringUtils.isNotBlank(type)) {
					BaseController.type_ext_List.add(type + "," + ext);
				}
			}
			//从toUrl中跳转时候先登录的页面url
			List<Element> returnsms = rootElm.elements("toUrl");
			LoginController.toUrlList.clear();
			for (Iterator<Element> iterator = returnsms.iterator(); iterator.hasNext();) {
				Element elm = iterator.next();
				String containsUrl = elm.attributeValue("containsUrl");
				String jumpPage = elm.attributeValue("jumpPage");
				JSONObject json=new JSONObject();
				json.put("containsUrl", containsUrl);
				if (StringUtils.isNotBlank(jumpPage)) {///为空的时候表示直接放行不需要登录
					json.put("jumpPage", jumpPage);
				}
				LoginController.toUrlList.add(json);
			}
//			List<Element> roles = rootElm.elements("role");
//			WeixinUtil.agentJsons.clear();
//			WeixinUtil.agentJsons= new JSONArray();
//			for (Iterator<Element> iterator = roles.iterator(); iterator.hasNext();) {
//				Element element = iterator.next();
//				String name=element.attributeValue("name");
//				String agentid=element.attributeValue("agentid");
//				JSONObject json=new JSONObject();
//				json.put("name", name);
//				json.put("agentid", agentid);
//				WeixinUtil.agentJsons.add(json);
//			}
			in.close();
			LoggerUtils.error("加载xml完成!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取文件的修改时间 默认文件名initConfig.txt
	 * 
	 * @return 文件修改时间
	 */
	public static String getModifiedTime(String filename) {
		if (!StringUtils.isNotBlank(filename)) {
			filename = "initConfig.txt";
		}
		String filepath = InitConfig.class.getClassLoader()
				.getResource(filename).getPath();
		File initFile = new File(filepath);
		return FileOperate.getModifiedTime(initFile);
	}

	/**
	 * 动态加载initConfig文件
	 */
	public static void initLoad() {
		String initString = getModifiedTime(null);
		if (!initString.equals(ConfigFile.initModifiedTime)) {
			init();
			ConfigFile.initModifiedTime=initString;
		}
		String pass = getModifiedTime("passlist.xml");
		if (!pass.equals(ConfigFile.passModifiedTime)) {
			sax_url(null);
			ConfigFile.passModifiedTime=pass;
		}
	}
	
	public static String getIP(String ipstr) throws IOException {
		/**
		 * 首先要和URL下的URLConnection对话。 URLConnection可以很容易的从URL得到。比如： // Using
		 * java.net.URL and //java.net.URLConnection
		 */
		URL url = new URL(ipstr);
		// URL url = new URL("http://1111.ip138.com/ic.asp");
		URLConnection connection = url.openConnection();
		/**
		 * 然后把连接设为输出模式。URLConnection通常作为输入来使用，比如下载一个Web页。
		 * 通过把URLConnection设为输出，你可以把数据向你个Web页传送。下面是如何做：
		 */
		connection.setDoOutput(true);
		connection.setRequestProperty("contentType", "GBK");
		connection.setConnectTimeout(5 * 1000);
		/**
		 * 最后，为了得到OutputStream，简单起见，把它约束在Writer并且放入POST信息中，例如： ...
		 */
		OutputStreamWriter out = new OutputStreamWriter(
				connection.getOutputStream(), "8859_1");
		out.write("username=kevin&password=*********"); // post的关键所在！
		// remember to clean up
		out.flush();
		out.close();
		/**
		 * 这样就可以发送一个看起来象这样的POST： POST /jobsearch/jobsearch.cgi HTTP 1.0 ACCEPT:
		 * text/plain Content-type: application/x-www-form-urlencoded
		 * Content-length: 99 username=bob password=someword
		 */
		// 一旦发送成功，用以下方法就可以得到服务器的回应：
		String sCurrentLine;
		String sTotalString;
		sCurrentLine = "";
		sTotalString = "";
		InputStream l_urlStream;
		l_urlStream = connection.getInputStream();
		// 传说中的三层包装阿！
		BufferedReader l_reader = new BufferedReader(new InputStreamReader(
				l_urlStream, "gbk"));
		while ((sCurrentLine = l_reader.readLine()) != null) {
			sTotalString += sCurrentLine + "/r/n";
		}
		String urlhtml = null;
		try {
			urlhtml = sTotalString.substring(sTotalString.indexOf("["),
					sTotalString.indexOf("]"));
		} catch (Exception e) {
			LoggerUtils.error(e.getMessage());
			return getIP("http://ip.chinaz.com/?jdfwkey=zfcyd3");
		}
		return urlhtml.substring(urlhtml.indexOf(">") + 1,
				urlhtml.indexOf("</"));
	}
	/**
	 * 获取新的版本号
	 * @return
	 */
	public static String getNewVer() {
		String randString = "0123456789";// 随机产生的字符串
		Random random = new Random();
		StringBuilder builder = new StringBuilder();
		for (int j = 0; j < 6; j++) {
			builder.append(String.valueOf(randString.charAt(random
					.nextInt(randString.length()))));
		}
		ConfigFile.Res_Ver=builder.toString();
		return "?ver="+builder.toString();
	}
	/**
	 * 初始化账套必须文件
	 * @param com_id 
	 * @param key 文件夹名称或文件夹短路径
	 */
	public static void initFile(String com_id,String key) {
		//1.hqu
		if ("001".equals(com_id)) {
			return;
		}
		String path=ConfigFile.getProjectPath();
		File srcFile=new File(path+"001/"+key+"/");
		if(srcFile.exists()){
			File destFile=new File(path+com_id+"/"+key+"/");
			if(destFile.exists()){
				File[] fs=destFile.listFiles();
				if(fs!=null&&fs.length>0){
					return;
				}
			}
			destFile.mkdirs();
			try {
				FileUtils.copyDirectory(srcFile, destFile);
			} catch (IOException e) {
				LoggerUtils.error(e.getMessage());
			}
		}
	}
	/**
	 * 初始化账套必须文件
	 * @param com_id
	 */
	public static void initComIdFile(String com_id) {
		 initFile(com_id, "excel/xml");
		 initFile(com_id, "xls");
		 initFile(com_id, "filed");
	}
}
