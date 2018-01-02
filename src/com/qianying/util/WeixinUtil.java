package com.qianying.util;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import com.drew.imaging.jpeg.JpegMetadataReader;
import com.drew.imaging.jpeg.JpegProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import com.qianying.controller.BaseController;
import com.qianying.controller.FilePathController;
import com.qq.weixin.mp.aes.AesException;
import com.qq.weixin.mp.aes.WXBizMsgCrypt;

public class WeixinUtil { 
	public static String notify_url =ConfigFile.urlPrefix+ "/weixin/notify_url.do";// 支付回调地址
	public static String sEncodingAESKey = "ZCXEBykpurC1V54VOmRnDvyJM1LUwEmIgwxhmQujG1r";// 密钥
	public static Integer agentid = 0;// 应用id
	public static String sToken = "dengqiang";//
	/**
	 * 应用所见部门id
	 */
//	private static Integer agentDeptId = 1;// 应用所见部门id 
	/**
	 * 获取指定com_id下微信参数存放路径
	 * @param com_id
	 * @param paramName 参数名称
	 * @return 指定com_id下微信参数存放路径
	 */
	public static synchronized File getWeixinParamFile(String com_id, String paramName) {
		String path =  ConfigFile.getProjectPath()+com_id+"/weixin/"+paramName+".txt";
		File file=new File(path);
		FilePathController.mkdirsDirectory(file);
		return file;
	}
	/**
	 * 获取指定com_id下微信参数值
	 * @param com_id
	 * @param paramName
	 * @return 指定com_id下微信参数值
	 */
	public static synchronized String getWeixinParam(String com_id,String paramName) {
		File path=getWeixinParamFile(com_id,paramName);
		if (path.exists()) {
			String ret=getFileTextContent(path);
			if(StringUtils.isNotBlank(ret)&&!ret.contains("invalid")){
				return ret;
			}else{
				path=getWeixinParamFile(com_id,paramName);
				if (path.exists()) {
					return BaseController.getFileTextContent(path);
				}else{
					return "";
				}
			}
		}else{//
			path=getWeixinParamFile(com_id,paramName);
			if (path.exists()) {
				return BaseController.getFileTextContent(path);
			}else{
				return "";
			}
		}
	}
	public static String getFileTextContent(File path) {
		try {
			InputStream inputStream=new FileInputStream(path);
			Scanner scanner=new Scanner(inputStream,"UTF-8");
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
			inputStream.close();
			return line.trim();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	public void delAccessFile(String com_id) {
		File file=getWeixinParamFile(com_id, "access_token");
		if (file.exists()&&file.isFile()) {
			file.delete();
		}
	  file=getWeixinParamFile(com_id, "access_token_chat");
	  if (file.exists()&&file.isFile()) {
		  file.delete();
	  }
	  file=getWeixinParamFile(com_id, "jsapi_ticket");
	  if (file.exists()&&file.isFile()) {
		  file.delete();
	  }
	  file=getWeixinParamFile(com_id, "access_token_service");
	  if (file.exists()&&file.isFile()) {
		  file.delete();
	  }
	  file=getWeixinParamFile(com_id, "access_token_service");
	  if (file.exists()&&file.isFile()) {
		  file.delete();
	  }
	}
	/**
	 * 获取微信调用接口凭证
	 * @param com_id 
	 * 
	 * @return 调用接口凭证
	 */
	public String getAccessToken(String com_id) {
		String access_token=getWeixinParam(com_id,"access_token");
		if (StringUtils.isNotBlank(access_token)) {
			return access_token;
		}
		String url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid="
				+ getWeixinParam(com_id,"corpid") + "&corpsecret=" +getWeixinParam(com_id,"corpsecret");
		String result = getData(url);
		LoggerUtils.info(result);
		if (StringUtils.isNotBlank(result)) {
			JSONObject json = JSONObject.fromObject(result);
			try {
				result = json.getString("access_token");
				BaseController.saveFile(getWeixinParamFile(com_id,"access_token"), result);
				access_token = result;
			} catch (Exception e) {
				if ("invalid corpid".equals(json.getString("errmsg"))) {
					result = "微信企业号->服务中心->消息发送接口->CorpID号错误!";
				} else {
					result = "微信企业号->服务中心->消息发送接口->Secret错误";
				}
			}
		} else {
			result = "连接微信访问出错!";
		}
		return result;
	}
	/**
	 * 获取微信调用接口凭证
	 * @param com_id 
	 * 
	 * @return 调用接口凭证
	 */
	public String getChatAccessToken(String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid="
				+getWeixinParam(com_id, "corpid") + "&corpsecret=" +getWeixinParam(com_id, "corpsecret_chat") ;
		String access_token_chat=getWeixinParam(com_id,"access_token_chat");
		if (StringUtils.isNotBlank(access_token_chat)) {
			return access_token_chat;
		}
		String result = getData(url);
		LoggerUtils.info("getChatAccessToken->"+result);
		if (StringUtils.isNotBlank(result)) {
			JSONObject json = JSONObject.fromObject(result);
			try {
				result = json.getString("access_token");
				BaseController.saveFile(getWeixinParamFile(com_id, "access_token_chat"), result);
//				access_token_chat = result;
			} catch (Exception e) {
				if ("invalid corpid".equals(json.getString("errmsg"))) {
					result = "微信企业号->服务中心->消息发送接口->CorpID号错误!";
				} else {
					result = "微信企业号->服务中心->消息发送接口->Secret错误";
				}
			}
		} else {
			result = "连接微信访问出错!";
		}
		return result;
	}
	public String jsapi_ticket(String com_id) {
		String jsapi_ticket=getWeixinParam(com_id, "jsapi_ticket");
		if (StringUtils.isNotBlank(jsapi_ticket)) {
			return jsapi_ticket;
		}
		String url = "https://qyapi.weixin.qq.com/cgi-bin/get_jsapi_ticket?access_token="
				+ getAccessToken(com_id);
		String result = getData(url);
		if (StringUtils.isNotBlank(result)) {
			JSONObject json = JSONObject.fromObject(result);
			try {
				result = json.getString("ticket");
				BaseController.saveFile(getWeixinParamFile(com_id, "jsapi_ticket"), result);
				jsapi_ticket=result;
			} catch (Exception e) {
				result = "微信企业号->服务中心->jsapi_ticket->CorpID号错误!";
			}
		}
		return result;
	}

	// //////////////////////
	private static class TrustAnyTrustManager implements X509TrustManager {

		public void checkClientTrusted(X509Certificate[] chain, String authType)
				throws CertificateException {
		}

		public void checkServerTrusted(X509Certificate[] chain, String authType)
				throws CertificateException {
		}

		public X509Certificate[] getAcceptedIssuers() {
			return new X509Certificate[] {};
		}
	}

	private static class TrustAnyHostnameVerifier implements HostnameVerifier {
		public boolean verify(String hostname, SSLSession session) {
			return true;
		}
	}

	// //////////////
	/**
	 * 以post方式提交数据
	 * 
	 * @param httpurl
	 *            提交路径
	 * @param json
	 *            json格式的数据
	 * @param type
	 *            数据提交类型
	 * @return 执行后的结果
	 * @throws Exception
	 */
	public String postData(String url, JSONObject json) {
		try {
			// 创建连接
			SSLContext sc = SSLContext.getInstance("TLSv1");
			sc.init(null, new TrustManager[] { new TrustAnyTrustManager() },
					new java.security.SecureRandom());
			URL httpurl = new URL(url);
			HttpsURLConnection connection = (HttpsURLConnection) httpurl
					.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			connection.setUseCaches(false);
			connection.setInstanceFollowRedirects(true);
			connection.setRequestProperty("Content-Type", "application/json");
			// connection.setRequestProperty("Accept-Charset", "UTF-8");
			connection.setRequestProperty("Content-Type", "UTF-8");
			connection.setSSLSocketFactory(sc.getSocketFactory());
			connection.setHostnameVerifier(new TrustAnyHostnameVerifier());
			connection.connect();
			// POST请求
			DataOutputStream out = new DataOutputStream(
					connection.getOutputStream());
			out.write(json.toString().getBytes("UTF-8"));
			out.flush();
			out.close();
			// 读取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream(), "UTF-8"));
			String lines;
			StringBuffer result = new StringBuffer();
			while ((lines = reader.readLine()) != null) {
				result.append(lines);
			}
			LoggerUtils.info(result);
			reader.close();
			// 断开连接
			connection.disconnect();
			return result.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}
	public String postxml(String url, String content) {
		try {
			// 创建连接
			SSLContext sc = SSLContext.getInstance("TLSv1");
			sc.init(null, new TrustManager[] { new TrustAnyTrustManager() },
					new java.security.SecureRandom());
			URL httpurl = new URL(url);
			HttpsURLConnection connection = (HttpsURLConnection) httpurl
					.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			connection.setUseCaches(false);
			connection.setInstanceFollowRedirects(true);
			connection.setRequestProperty("Content-Type", "text/xml; charset=UTF-8");  
			connection.setRequestProperty("Content-Length", String.valueOf(content.getBytes("UTF-8").length));
			connection.setSSLSocketFactory(sc.getSocketFactory());
			connection.setHostnameVerifier(new TrustAnyHostnameVerifier());
			connection.connect();
			// POST请求
			DataOutputStream out = new DataOutputStream(
					connection.getOutputStream());
			out.write(content.getBytes("UTF-8"));
			out.flush();
			out.close();
			// 读取响应
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream(), "UTF-8"));
			String lines;
			StringBuffer result = new StringBuffer();
			while ((lines = reader.readLine()) != null) {
				result.append(lines);
			}
			LoggerUtils.info(result);
			reader.close();
			// 断开连接
			connection.disconnect();
			return result.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}
//	public String postxml2(String url, String content) {
//		try {
//			// 创建连接
//	        KeyStore keyStore  = KeyStore.getInstance("PKCS12");
//	        FileInputStream instream = new FileInputStream(new File("E:/cert/apiclient_cert.p12"));
//	        try {
//	            keyStore.load(instream, "apiclient_cert".toCharArray());
//	        } finally {
//	            instream.close();
//	        }
//
//	        // Trust own CA and all self-signed certs
//	        SSLContext sslcontext = SSLContexts.custom()
//	                .loadKeyMaterial(keyStore, "apiclient_cert".toCharArray())
//	                .build();
//	        // Allow TLSv1 protocol only
//	        SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
//	                sslcontext,
//	                new String[] { "TLSv1" },
//	                null,
//	                SSLConnectionSocketFactory.BROWSER_COMPATIBLE_HOSTNAME_VERIFIER);
//	        CloseableHttpClient httpclient = HttpClients.custom()
//	                .setSSLSocketFactory(sslsf)
//	                .build();
////			SSLContext sc = SSLContext.getInstance("TLSv1");
//	        sslcontext.init(null, new TrustManager[] { new TrustAnyTrustManager() },
//					new java.security.SecureRandom());
//			URL httpurl = new URL(url);
//			HttpsURLConnection connection = (HttpsURLConnection) httpurl
//					.openConnection();
//			connection.setDoOutput(true);
//			connection.setDoInput(true);
//			connection.setRequestMethod("POST");
//			connection.setUseCaches(false);
//			connection.setInstanceFollowRedirects(true);
//			connection.setRequestProperty("Content-Type", "text/xml; charset=UTF-8");  
//			connection.setRequestProperty("Content-Length", String.valueOf(content.getBytes("UTF-8").length));//SSLSocketFactory
//			connection.setSSLSocketFactory(sslcontext.getSocketFactory());//SSLConnectionSocketFactory.getSocketFactory();//SSLConnectionSocketFactory
//			connection.setHostnameVerifier(new TrustAnyHostnameVerifier());
//			connection.connect();
//			// POST请求
//			DataOutputStream out = new DataOutputStream(
//					connection.getOutputStream());
//			out.write(content.getBytes("UTF-8"));
//			out.flush();
//			out.close();
//			// 读取响应
//			BufferedReader reader = new BufferedReader(new InputStreamReader(
//					connection.getInputStream(), "UTF-8"));
//			String lines;
//			StringBuffer result = new StringBuffer();
//			while ((lines = reader.readLine()) != null) {
//				result.append(lines);
//			}
//			LoggerUtils.info(result);
//			reader.close();
//			// 断开连接
//			connection.disconnect();
//			return result.toString();
//		} catch (Exception e) {
//			e.printStackTrace();
//			return e.getMessage();
//		}
//	}

	/**
	 * post方式请求服务器(https协议)
	 * 
	 * @param url
	 *            请求地址
	 * @param content
	 *            参数
	 * @param charset
	 *            编码
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws KeyManagementException
	 * @throws IOException
	 */
	public String post(String url, String content, String charset)
			throws NoSuchAlgorithmException, KeyManagementException,
			IOException {
		SSLContext sc = SSLContext.getInstance("TLSv1");
		sc.init(null, new TrustManager[] { new TrustAnyTrustManager() },
				new java.security.SecureRandom());

		URL console = new URL(url);
		HttpsURLConnection conn = (HttpsURLConnection) console.openConnection();
		conn.setSSLSocketFactory(sc.getSocketFactory());
		conn.setHostnameVerifier(new TrustAnyHostnameVerifier());
		conn.setDoOutput(true);
		// conn.setRequestMethod("post");
		conn.setRequestProperty("Accept-Charset", "utf-8");
//		conn.setRequestProperty("Content-Type", "text/xml; charset=UTF-8");  
		conn.setRequestProperty("contentType", "utf-8");
		conn.connect();
		DataOutputStream out = new DataOutputStream(conn.getOutputStream());
		out.write(content.getBytes(charset));
		// 刷新、关闭
		out.flush();
		out.close();

		BufferedReader reader = new BufferedReader(new InputStreamReader(
				conn.getInputStream(), "UTF-8"));
		String lines;
		StringBuffer result = new StringBuffer();
		while ((lines = reader.readLine()) != null) {
			lines = new String(lines.getBytes());
			result.append(lines);
		}
		LoggerUtils.info(result.toString());
		conn.disconnect();
		return result.toString();
	}
 
	/**
	 * 以get方式获取数据
	 * 
	 * @param url
	 * @return 获取的数据
	 */
	public String getData(String url) {
		String result = "";
		try {

			SSLContext sc = SSLContext.getInstance("TLSv1");
			sc.init(null, new TrustManager[] { new TrustAnyTrustManager() },
					new java.security.SecureRandom());
			URL console = new URL(url);
			HttpsURLConnection conn = (HttpsURLConnection) console
					.openConnection();
			conn.setSSLSocketFactory(sc.getSocketFactory());
			conn.setHostnameVerifier(new TrustAnyHostnameVerifier());
			conn.setDoOutput(true);
			conn.setRequestMethod("GET");
			// conn.setRequestProperty("Content-Type","application/json");
			conn.setRequestProperty("Accept-Charset", "UTF-8");
			// conn.setRequestProperty("Content-Type", "UTF-8");

			conn.setDoInput(true); // 设置输入流采用字节流
			conn.setUseCaches(false); // 设置缓存
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setRequestProperty("Charset", "utf-8");

			conn.connect();
			BufferedReader readin = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String CurLine;
			StringBuffer resultb = new StringBuffer();
			while ((CurLine = readin.readLine()) != null) {
				resultb.append(CurLine);
			}
			readin.close();
			conn.disconnect();
			LoggerUtils.info(resultb.toString());
			result = resultb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
		}
		return result;
	}
	/**
	 * 以get方式获取数据
	 * 
	 * @param url
	 * @return 获取的数据
	 */
	public String getDataImage(String url,File imgPath) {
		String result = "";
		try {
			
			SSLContext sc = SSLContext.getInstance("TLSv1");
			sc.init(null, new TrustManager[] { new TrustAnyTrustManager() },
					new java.security.SecureRandom());
			URL console = new URL(url);
			HttpsURLConnection conn = (HttpsURLConnection) console
					.openConnection();
			conn.setSSLSocketFactory(sc.getSocketFactory());
			conn.setHostnameVerifier(new TrustAnyHostnameVerifier());
			conn.setDoOutput(true);
			conn.setRequestMethod("GET");
			// conn.setRequestProperty("Content-Type","application/json");
			conn.setRequestProperty("Accept-Charset", "UTF-8");
			// conn.setRequestProperty("Content-Type", "UTF-8");
			
			conn.setDoInput(true); // 设置输入流采用字节流
			conn.setUseCaches(false); // 设置缓存
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setRequestProperty("Charset", "utf-8");
			conn.connect();
			//通过输入流获取图片数据
	        InputStream inStream = conn.getInputStream();  
	        //得到图片的二进制数据，以二进制封装得到数据，具有通用性  
	        byte[] data = readInputStream(inStream);  
	        //new一个文件对象用来保存图片，默认保存当前工程根目录  
	        //创建输出流  
	        FileOutputStream outStream = new FileOutputStream(imgPath);  
	        //写入数据  
	        outStream.write(data);  
	        //关闭输出流  
	        outStream.close(); 
	        conn.disconnect();
			result = "";
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
		}
		return result;
	}
	 public static byte[] readInputStream(InputStream inStream) throws Exception{  
	        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
	        //创建一个Buffer字符串  
	        byte[] buffer = new byte[1024];  
	        //每次读取的字符串长度，如果为-1，代表全部读取完毕  
	        int len = 0;  
	        //使用一个输入流从buffer里把数据读取出来  
	        while( (len=inStream.read(buffer)) != -1 ){  
	            //用输出流往buffer里写入数据，中间参数代表从哪个位置开始读，len代表读取的长度  
	            outStream.write(buffer, 0, len);  
	        }  
	        //关闭输入流  
	        inStream.close();  
	        //把outStream里的数据写入内存  
	        return outStream.toByteArray();  
	    }  
	public String getData2(String url) {
		String result = "";
		try {
			URL httpurl = new URL(url);
			HttpsURLConnection conn = (HttpsURLConnection) httpurl
					.openConnection();
			conn.setDoInput(true);
			conn.setReadTimeout(5 * 1000);
			conn.setRequestMethod("GET");

			BufferedReader readin = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String CurLine;
			StringBuffer resultb = new StringBuffer();
			while ((CurLine = readin.readLine()) != null) {
				resultb.append(CurLine);
			}
			readin.close();
			conn.disconnect();
			result = resultb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
		}
		return result;
	}

	public String getData3(String url) {
		String result = "";
		try {
			URL httpurl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) httpurl
					.openConnection();
			conn.setDoInput(true);
			conn.setReadTimeout(5 * 1000);
			conn.setRequestMethod("GET");

			BufferedReader readin = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "UTF-8"));
			String CurLine;
			StringBuffer resultb = new StringBuffer();
			while ((CurLine = readin.readLine()) != null) {
				resultb.append(CurLine);
			}
			readin.close();
			conn.disconnect();
			result = resultb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
		}
		return result;
	}

	/**
	 * 发送文本消息
	 * 
	 * @param msg
	 *            是 要发送的文本消息
	 * @param com_id 
	 * @param touser
	 *            否 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，
	 *            则向关注该企业应用的全部成员发送
	 * @param toparty
	 *            否 部门ID列表，多个接收者用‘|’分隔，最多支持100个。当touser为@all时忽略本参数
	 * @param totag
	 *            否 标签ID列表，多个接收者用‘|’分隔。当touser为@all时忽略本参数
	 * @return
	 */
	public String sendMessage(String msg, String com_id, String... params) {
		if (StringUtils.isBlank(msg)) {
			return "请输入要发送的消息内容!";
		}
		try {
			String url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="
					+ getAccessToken(com_id);
			JSONObject json = new JSONObject();
			if (params == null || params.length == 0) {
				msg = "没有微信账号!";
			} else {
				setSendMsgBasicInfo(json, params);
				json.put("msgtype", "text");// 是 消息类型，此时固定为：text
				json.put("safe", 0);// 否 表示是否是保密消息，0表示否，1表示是，默认0
				JSONObject content = new JSONObject();
				content.put("content", msg);
				json.put("text", content);
//				json.put("safe", safe);
				// 开始发送消息
				String resultmsg=post(url, json.toString(), "utf-8");
				if (StringUtils.isNotBlank(resultmsg)) {
					JSONObject result = JSONObject.fromObject(resultmsg);
					msg = result.getString("errmsg");
					if (!"ok".equals(msg)) {
						LoggerUtils.info(result);
					}
					result.put("time", DateTimeUtils.dateTimeToStr());
					json.put("result", result);
				}
				LogUtil.saveFile(json.toString()+",","txt");
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return msg;
	}

	/**
	 * 发送news消息
	 * 
	 * @param news
	 *            List<Map<String, Object>>
	 * @param touser
	 *            否 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，
	 *            则向关注该企业应用的全部成员发送
	 * @param toparty
	 *            否 部门ID列表，多个接收者用‘|’分隔，最多支持100个。当touser为@all时忽略本参数
	 * @param totag
	 *            否 标签ID列表，多个接收者用‘|’分隔。当touser为@all时忽略本参数
	 * 
	 * @param title
	 *            否 标题
	 * @param description
	 *            否 描述
	 * @param url
	 *            否 点击后跳转的链接。
	 * @param picurl
	 *            否 图文消息的图片链接，支持JPG、PNG格式，较好的效果为大图640*320，小图80*80。如不填，在客户端不显示图片
	 */
	public String sendMessagenews(List<Map<String, Object>> news,String com_id,
			String touser,String name) {
		return sendMessagenews2(listToJSONArray(news,com_id),com_id, touser, name);
	}
	/**
	 * 发送news消息
	 * @param articles JSONArray
	 * @param touser 否 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，
	 *            则向关注该企业应用的全部成员发送
	 * @param toparty 否 部门ID列表，多个接收者用‘|’分隔，最多支持100个。当touser为@all时忽略本参数
	 * @param totag 否 标签ID列表，多个接收者用‘|’分隔。当touser为@all时忽略本参数
	 * @return
	 */
	public String sendMessagenews2(JSONArray articles,String com_id, String... params) {
		String msg = null;
		if (articles == null || articles.size() <= 0) {
			return "请输入要发送的消息内容!";
		}
		try {
			String url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="
					+ getAccessToken(com_id);
			JSONObject json = new JSONObject();
			if (params == null || params.length == 0) {
				msg = "没有微信账号!";
			} else {
				if (params.length >= 1) {
					json.put("touser", params[0]);
				}
				json.put("agentid", agentid);
				json.put("msgtype", "news");// 是 消息类型，此时固定为：text
				if (params.length >= 2) {
					json.put("agentid",getRoleAgentId(params[1],com_id));// 是 企业应用的id，整型。可在应用的设置页面查看
				}
				JSONObject articles_json = new JSONObject();
				articles_json.put("articles", articles);
				json.put("news", articles_json);
//				json.put("safe", safe);
				// 开始发送消息
				String resultmsg = post(url, json.toString(), "utf-8");
				if (StringUtils.isNotBlank(resultmsg)) {
					JSONObject result = JSONObject.fromObject(resultmsg);
					msg = result.getString("errmsg");
					if (!"ok".equals(msg)) {
						LoggerUtils.info(result);
					}
					json.put("result", result);
				}
				json.put("time", DateTimeUtils.dateTimeToStr());
				LogUtil.saveFile(json.toString()+",","news");
			}
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return msg;
	}
	/**
	 * 发送news消息
	 * @param articles JSONArray
	 * @param touser 否 成员ID列表（消息接收者，多个接收者用‘|’分隔，最多支持1000个）。特殊情况：指定为@all，
	 *            则向关注该企业应用的全部成员发送
	 * @param toparty 否 部门ID列表，多个接收者用‘|’分隔，最多支持100个。当touser为@all时忽略本参数
	 * @param totag 否 标签ID列表，多个接收者用‘|’分隔。当touser为@all时忽略本参数
	 * @return
	 */
	public String sendMessagenewsAll(JSONArray articles,String com_id) {
		String msg = null;
		if (articles == null || articles.size() <= 0) {
			return "请输入要发送的消息内容!";
		}
		try {
			String url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="
					+ getAccessToken(com_id);
			JSONObject json = new JSONObject();
			json.put("touser","@all");
			json.put("agentid", 0);
			json.put("msgtype", "news");// 是 消息类型，此时固定为：text
			JSONObject articles_json = new JSONObject();
			articles_json.put("articles", articles);
			json.put("news", articles_json);
			// 开始发送消息
			String resultmsg = post(url, json.toString(), "utf-8");
			if (StringUtils.isNotBlank(resultmsg)) {
				JSONObject result = JSONObject.fromObject(resultmsg);
				msg = result.getString("errmsg");
				if (!"ok".equals(msg)) {
					LoggerUtils.info(result);
				}
				json.put("result", result);
			}
			json.put("time", DateTimeUtils.dateTimeToStr());
			LogUtil.saveFile(json.toString()+",","news");
		} catch (Exception e) {
			msg = e.getMessage();
			e.printStackTrace();
		}
		return msg;
	}

	/**
	 * 设置发消息基础信息
	 * 
	 * @param json
	 *            需要设置到的json对象
	 * @param params
	 *            员工,部门,标签
	 */
	private void setSendMsgBasicInfo(JSONObject json, String... params) {
		if (params.length >= 1) {
			json.put("touser", params[0]);
		}
		if (params.length >= 2) {
			json.put("toparty", params[1]);
		} else {
			json.put("toparty", "@all");
		}
		if (params.length >= 3) {
			json.put("totag", params[2]);
		} else {
			json.put("totag", "@all");
		}
		json.put("agentid", agentid);// 是 企业应用的id，整型。可在应用的设置页面查看
	}

	/**
	 * 将list集合转换为JSONArray
	 * 
	 * @param news
	 *            存放消息的map集合
	 * @param com_id 
	 * @param title
	 *            否 标题
	 * @param description
	 *            否 描述
	 * @param url
	 *            否 点击后跳转的链接。
	 * @param picurl
	 *            否 图文消息的图片链接，支持JPG、PNG格式，较好的效果为大图640*320，小图80*80。如不填，在客户端不显示图片
	 * @return
	 */
	public JSONArray listToJSONArray(List<Map<String, Object>> news, Object com_id) {
		JSONArray articles = new JSONArray();
		for (Map<String, Object> map : news) {
			JSONObject article = new JSONObject();
			if (map.get("title")==null) {
				articles=null;
				break;
			}
			if ("".equals(map.get("title").toString().trim())) {
				articles=null;
				break;
			}
			article.put("title", map.get("title"));
			article.put("description", map.get("description") +".消息通知时间:"+DateTimeUtils.dateTimeToStr());
			if(MapUtils.getString(map, "url").contains("?")){
				article.put("url", map.get("url")+"|com_id="+com_id);
			}else{
				article.put("url", map.get("url")+"?com_id="+com_id);
			}
			article.put("sendRen", map.get("sendRen"));
			LoggerUtils.info(map.get("url"));
			if (map.get("picurl") != null && !"".equals(map.get("picurl"))) {
				article.put("picurl", map.get("picurl"));
			}else{
				article.put("picurl", ConfigFile.urlPrefix+"/weixinimg/msg.png");
			}
			articles.add(article);
		}
		return articles;
	}

	/**
	 * 获取数组项根据索引值
	 * 
	 * @param totag
	 *            数组
	 * @param index
	 *            索引值
	 * @return 返回数据项,不存在返回空
	 */
	public String getArrayItem(String[] totag, int index) {
		if (totag != null && totag.length >= (index + 1)) {
			return totag[index];
		} else {
			return null;
		}
	}

	/**
	 * 获取数组项根据索引值
	 * 
	 * @param totag
	 *            数组
	 * @param index
	 *            索引值
	 * @return 返回数据项,不存在返回空
	 */
	public Integer getArrayItem(Integer[] totag, int index) {
		if (totag != null && totag.length >= (index + 1)) {
			return totag[index];
		} else {
			return null;
		}
	}

	// ///////////////////部门相关////////////////
	/**
	 * 创建部门
	 * 
	 * @param name
	 *            部门名称 长度限制为1~64个字节，字符不能包括\:*?"<>｜
	 * @param parentid
	 *            是 父亲部门id。根部门id为1 及seeds_id值
	 * @param order
	 *            否 在父部门中的次序值。order值小的排序靠前。
	 * @param id
	 *            生成的部门id 整型。指定时必须大于1，不指定时则自动生成 及seeds_id值
	 * @return 成功返回部门id值,失败返回null
	 */
	public String createDept(Object name, Object parentid, Object order,
			Object id,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/department/create?access_token="
				+ getAccessToken(com_id);
		JSONObject json = new JSONObject();
		json.put("name", name);
		json.put("parentid", parentid);
		if (order != null) {
			json.put("order", order);
		}
		json.put("id", id);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			try {
				return result.getString("id");
			} catch (Exception e) {
				LoggerUtils.info(resultmsg);
			}
		}
		return null;
	}

	/**
	 * 创建客户所在部门
	 * 
	 * @return
	 */
//	public String creatClientDept() {
//		return createDept(clientDeptName, 1, 200, clientDeptId);
//	}
	/**
	 * 创建员工所在部门
	 * 
	 * @return
	 */
//	public String creatEmployeeDept() {
//		return createDept(employeeDeptName, 1, 200, employeeDeptId);
//	}
	/**
	 * 创建运营商部门
	 * @return
	 */
//	public String creatOperateDept() {
//		return createDept(operateDeptName, 1, 200, operateDeptId);
//	}

	/**
	 * 创建供应商所在部门
	 * 
	 * @return
	 */
//	public String creatGysDept() {
//		return createDept(gysDeptName, 1, 200, gysDeptId);
//	}
//	public String creatSaiyuDept() {
//		try {
//			createDept(driverDeptName,1,200,driverDeptId);
//			createDept(dianDeptName,1,200,dianDeptId);
//		} catch (Exception e) {
//			return e.getMessage();
//		}
//		return null;
//	}
	/**
	 * 更新部门
	 * 
	 * @param id
	 *            是 部门id 及seeds_id值
	 * @param name
	 *            否 更新的 部门名称 长度限制为1~64个字节，字符不能包括\:*?"<>｜
	 * @param parentid
	 *            否 父亲部门id。根部门id为1
	 * @param order
	 *            否 在父部门中的次序值。order值小的排序靠前。
	 * @return 成功返回updated,失败返回null
	 */
	public String updateDept(Object id, String name, Object parentid,
			Object order,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/department/udpate?access_token="
				+ getAccessToken(com_id);
		JSONObject json = new JSONObject();
		if (StringUtils.isNotBlank(name)) {
			json.put("name", name);
		}
		if (parentid != null) {
			json.put("parentid", parentid);
		}
		if (order != null) {
			json.put("order", order);
		}
		json.put("id", id);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}

	/**
	 * 删除部门
	 * 
	 * @param id
	 *            部门id及seeds_id值
	 * @return
	 */
	public String deleteDept(Object id,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/department/delete?access_token="
				+ getAccessToken(com_id) + "&id=" + id;
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}

	/**
	 * 获取部门列表
	 * 
	 * @param id
	 *            否 部门id。获取指定部门及其下的子部门及seeds_id值
	 * @return 部门json格式列表
	 */
	public String getDeptList(Object id,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/department/list?access_token="
				+ getAccessToken(com_id);
		if (id != null) {
			url += "&id=" + id;
		}
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			if ("ok".equals(result.getString("errmsg"))) {
				return result.getString("department");
			}
		}
		return resultmsg;
	}
	/**
	 * 获取应用所在部门
	 * @return
	 */
	public void saveDeptList(String com_id,Object agentDeptId) {
		String str=getDeptList(agentDeptId,com_id);
		if(StringUtils.isNotBlank(str)){
//			JSONArray deptJsons= JSONArray.fromObject(str);
			BaseController.saveFile(getWeixinParamFile(com_id, "deptJsons"), str);
		}
	}
	/**
	 * 根据部门名称模糊搜索部门id
	 * @param key
	 * @param com_id 
	 * @param agentDeptId 
	 * @return
	 */
	public Integer getDeptByName(String key, String com_id, Object agentDeptId) {
		Integer id=Integer.parseInt(agentDeptId.toString());
		String str=getWeixinParam(com_id, "deptJsons");
		if(StringUtils.isBlank(str)){
			saveDeptList(com_id,agentDeptId);
		}
		str=str.trim();
		if(str.startsWith("[")&&str.endsWith("]")){
			JSONArray deptJsons=JSONArray.fromObject(str);
			for (int i = 0; i < deptJsons.size(); i++) {
				JSONObject json=deptJsons.getJSONObject(i);
				if (json.getString("name").contains(key)) {
					id= json.getInt("id");
					break;
				}
			}
		}else{
			id=0;
		}
		return id;
	}
	/**
	 * 获取消息发送应用id根据角色名称
	 * @param key
	 * @param com_id 
	 * @return 发送消息应用名称
	 */
	public Integer getRoleAgentId(String key, String com_id) {
		Integer id=agentid;
		String str=getWeixinParam(com_id, "agentJsons");
		if(StringUtils.isNotBlank(str)){
			if(str.startsWith("[")){///{"name":"员工","agentid":12}
				JSONArray agentJsons=JSONArray.fromObject(str);
				for (int i = 0; i < agentJsons.size(); i++) {
					JSONObject json=agentJsons.getJSONObject(i);
					if (json.has("name")&&json.getString("name").contains(key)) {
						id= json.getInt("agentid");
						break;
					}
				}
			}else{
//				if(!str.equals(id)){
//					BaseController.saveFile(getWeixinParamFile(com_id, "agentJsons"), id+"");
//				}
			}
		}else{
//			BaseController.saveFile(getWeixinParamFile(com_id, "agentJsons"), id+"");
		}
		return id;
	}
	// /////////////////////员工相关//////////
	/**
	 * 创建或者更新员工信息,
	 * 
	 * @param type
	 *            create,update
	 * @param json
	 * @param userid
	 *            是 成员UserID。对应管理端的帐号，企业内必须唯一。长度为1~64个字节
	 * @param name
	 *            是 成员名称。长度为1~64个字节
	 * @param department
	 *            否 成员所属部门id列表。注意，每个部门的直属成员上限为1000个
	 * @param position
	 *            否 职位信息。长度为0~64个字节
	 * @param mobile
	 *            否 手机号码。企业内必须唯一，mobile/weixinid/email三者不能同时为空
	 * @param gender
	 *            否 性别。1表示男性，2表示女性
	 * @param email
	 *            否 邮箱。长度为0~64个字节。企业内必须唯一
	 * @param weixinid
	 *            否 微信号。企业内必须唯一。（注意：是微信号，不是微信的名字）
	 * @param avatar_mediaid
	 *            否 成员头像的mediaid，通过多媒体接口上传图片获得的mediaid
	 * @param "avatar_mediaid": "2-G6nrLmr5EC3MNb_-zL1dDdzkd0p7cNliYu9V5w7o8K0",
	 * @return
	 */
	public String saveEmployee(JSONObject json, String type,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/" + type
				+ "?access_token=" + getAccessToken(com_id);
		String resultmsg = postData(url, json);
		LoggerUtils.info(resultmsg);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			if (result.getString("errmsg").contains("existed")) {
				//获取原来部门编号
//				if(ConfigFile.weixinMoreDept){
//					String infostr=getEmployeeInfo(json.getString("userid"),com_id);
//					if(StringUtils.isNotBlank(infostr)){
//						JSONObject info=JSONObject.fromObject(infostr);
//						JSONArray is= json.getJSONArray("department");
//						JSONArray infos= info.getJSONArray("department");
//						is.addAll(infos);
//						json.put("department", is);
//					}
//				}
				url = "https://qyapi.weixin.qq.com/cgi-bin/user/update?access_token=" + getAccessToken(com_id);
				resultmsg = postData(url, json);
				if (StringUtils.isNotBlank(resultmsg)) {
					result = getErrcodeToZh(resultmsg);
					LoggerUtils.info(result);
					if ("0".equals(result.getString("errcode"))) {
						return "";
					}
					return result.getString("errmsg");
				}
			}else{
				if ("0".equals(result.getString("errcode"))) {
					return "";
				}
				return result.getString("errmsg");
			}
		}
		return null;
	}

	/**
	 * 删除成员
	 * 
	 * @param clerk_id
	 * @return 删除执行结果
	 */
	public String deleteEmployee(Object clerk_id,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/delete?access_token="
				+ getAccessToken(com_id) + "&&userid=" + clerk_id;
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}

	/**
	 * 获取成员信息
	 * 
	 * @param userid
	 * @return 成员列表
	 */
	public String getEmployeeInfo(String userid,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/get?access_token="
				+ getAccessToken(com_id);
		if (StringUtils.isNotBlank(userid)) {
			url += "&userid=" + userid;
		}
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			try {
				JSONObject result = JSONObject.fromObject(resultmsg);
				if ("ok".equals(result.getString("errmsg"))) {
					return resultmsg;
				}
			} catch (Exception e) {
				LoggerUtils.error(e.getMessage());
			}
		}
		return null;
	}

	/**
	 * 获取成员列表根据部门id
	 * 
	 * @param id
	 *            部门id及seeds_id值
	 * @param fetch_child
	 *            否 1/0：是否递归获取子部门下面的成员
	 * @param status
	 *            否 0获取全部成员，1获取已关注成员列表，2获取禁用成员列表，4获取未关注成员列表。status可叠加,未填写则默认为4
	 * @return 成员列表
	 */
	public String getEmployeeList(Object id, int fetch_child, int status,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/list?access_token="
				+ getAccessToken(com_id);
		if (id != null) {
			url += "&department_id=" + id;
			url += "&fetch_child=" + fetch_child;
			url += "&status=" + status;
		}
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			if ("ok".equals(result.getString("errmsg"))) {
				return result.getString("userlist");
			}
		}
		return null;
	}
	public String getEmployeeSimplelist(Object id, int fetch_child, int status,String com_id, String agentDeptId) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/simplelist?access_token="
				+ getAccessToken(com_id);
		if (id != null) {
			url += "&department_id=" + agentDeptId;
			url += "&fetch_child=" + fetch_child;
			url += "&status=" + status;
		}
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			if ("ok".equals(result.getString("errmsg"))) {
				return result.getString("userlist");
			}
		}
		return null;
	}

	/**
	 * 邀请成员关注
	 * 
	 * @param clerk_id
	 * @returnerrmsg 对返回码的文本描述内容 type 1:微信邀请 2.邮件邀请
	 */
	public String invite_send(String clerk_id,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/invite/send?access_token="
				+ getAccessToken(com_id);
		JSONObject json = new JSONObject();
		json.put("userid", clerk_id);
		LoggerUtils.info(json);
		return postData(url, json);
	}

	public String getOatuh(String code,String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token="
				+ getAccessToken(com_id) + "&code=" + code;
		return getData(url);
	} 
	
	public String applient() {
//		String stringA = "appid=wxd930ea5d5a258f4f&body=test&device_info=1000&mch_id=10000100&nonce_str=ibuaiVcKdpRxkhJA";

		return "";
	}

	public String alipay() throws Exception {
		KeyStore keyStore = KeyStore.getInstance("PKCS12");
		FileInputStream instream = new FileInputStream(new File(
				"D:/1228337002.p12"));
		try {
			keyStore.load(instream, "1228337002".toCharArray());
		} finally {
			instream.close();
		}
		// Trust own CA and all self-signed certs
		SSLContext sslcontext = SSLContexts.custom()
				.loadKeyMaterial(keyStore, "1228337002".toCharArray()).build();
		// Allow TLSv1 protocol only
		SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
				sslcontext, new String[] { "TLSv1" }, null,
				SSLConnectionSocketFactory.BROWSER_COMPATIBLE_HOSTNAME_VERIFIER);
		CloseableHttpClient httpclient = HttpClients.custom()
				.setSSLSocketFactory(sslsf).build();
		try {
			HttpPost httpget = new HttpPost(
					"https://api.mch.weixin.qq.com/secapi/pay/refund");
			// ////////////////////
			// POST请求
			// ///////////////////////////
			LoggerUtils.info("executing request" + httpget.getRequestLine());

			CloseableHttpResponse response = httpclient.execute(httpget);
			try {
				HttpEntity entity = response.getEntity();

				LoggerUtils.info("----------------------------------------");
				LoggerUtils.info(response.getStatusLine());
				if (entity != null) {
					LoggerUtils.info("Response content length: "
							+ entity.getContentLength());
					BufferedReader bufferedReader = new BufferedReader(
							new InputStreamReader(entity.getContent()));
					String text;
					while ((text = bufferedReader.readLine()) != null) {
						LoggerUtils.info(text);
					}
				}
				EntityUtils.consume(entity);
			} finally {
				response.close();
			}
		} finally {
			httpclient.close();
		}
		return null;
	}

	// ///////////////////////////////////////////////////////////////////////
	/**
	 * 根据文件id下载文件
	 * 
	 * @param mediaId
	 *            媒体id
	 * @throws Exception
	 */
	public InputStream getInputStream(String mediaId,String com_id) {
		InputStream is = null;
		String url = "https://qyapi.weixin.qq.com/cgi-bin/media/get?access_token="
				+ getAccessToken(com_id) + "&media_id=" + mediaId;
		try {
			URL urlGet = new URL(url);
			HttpsURLConnection http = (HttpsURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // 必须是get方式请求
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");// 连接超时30秒
			System.setProperty("sun.net.client.defaultReadTimeout", "30000"); // 读取超时30秒
			http.connect();
			// 获取文件转化为byte流
			is = http.getInputStream();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return is;
	}

	/**
	 * 获取下载图片信息（jpg）
	 * 
	 * @param mediaId
	 *            文件的id
	 * @param com_id 
	 * @throws Exception
	 */
	public void saveImageToDisk(String mediaId, String path, String com_id) throws Exception {
		if (StringUtils.isBlank(mediaId)) {
			return;
		}
		InputStream inputStream = getInputStream(mediaId,com_id);
		byte[] data = new byte[1024];
		int len = 0;
		FileOutputStream fileOutputStream = null;
		try {
			fileOutputStream = new FileOutputStream(path);
			while ((len = inputStream.read(data)) != -1) {
				fileOutputStream.write(data, 0, len);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (fileOutputStream != null) {
				try {
					fileOutputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
	}

	/**
	 * userid转换成openid接口
	 * @param weixinID
	 *            微信账号
	 * @param com_id 
	 * @return openid
	 */
	public String useridToOpenid(String weixinID, String com_id) {
		String url = "https://qyapi.weixin.qq.com/cgi-bin/user/convert_to_openid?access_token="
				+ getAccessToken(com_id);
		JSONObject json = new JSONObject();
		json.put("userid", weixinID);
		String result = postData(url, json);
		if (StringUtils.isNotBlank(result) && result.contains("ok")) {
			LoggerUtils.info(result);
			JSONObject json_result = JSONObject.fromObject(result);
			return json_result.getString("openid");
		}
		return null;
	}
	
	/**
	 * 获取相机拍摄照片的信息
	 * @param path 照片路径
	 * @return 拍摄照片的Make-品牌,Model-机型,Original-拍摄时间,
	 */
	public static Map<String,Object> getImageInfo(File path) {
		Map<String,Object> map=new HashMap<String, Object>();
		try {
            Metadata metadata = JpegMetadataReader.readMetadata(path);
            for (Directory directory : metadata.getDirectories()) {
                for (Tag tag : directory.getTags()) {
                	//Make 手机品牌
                	//Model 手机型号
                	//Date/Time Original 原始时间
                	//Date/Time Digitized 数字化时间
                    switch (tag.getTagName()) {
					case "Make":
						map.put("Make", tag.getDescription());
						break;
					case "Model":
						map.put("Model", tag.getDescription());
						break;
					case "Date/Time Original":
						map.put("Original", tag.getDescription());
						break;
					case "Date/Time Digitized":
						map.put("Digitized", tag.getDescription());
						break; 
					}
                }
                if (directory.hasErrors()) {
                    for (String info : directory.getErrors()) {
                        System.err.println("ERROR: " + info);
                    }
                }
            }
        } catch (JpegProcessingException e) {
        	
        } catch (IOException e) {
        	
        } 
		return map;
	}
	////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 创建企业群聊回话
	 * @param chatid  是	 会话id。字符串类型，最长32个字符。只允许字符0-9及字母a-zA-Z, 
	 * @param name 是	 会话标题
	 * @param owner 是	 管理员userid，必须是该会话userlist的成员之一
	 * @param userlist 成员列表
	 * @param com_id 
	 * @return
	 */
	public String chatCreate(String chatid,String name, String owner, String[] userlist, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/create?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("chatid", chatid);
		json.put("name", name);
		json.put("owner", owner);
		json.put("userlist", userlist);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}
	public String chatCreate(String chatid,String name, String owner, List<String> userlist, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/create?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("chatid", chatid);
		json.put("name", name);
		json.put("owner", owner);
		json.put("userlist", userlist);
		String resultmsg = postData(url, json);
		LoggerUtils.info("chatCreate-->>>"+resultmsg);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result =getErrcodeToZh(resultmsg);// JSONObject.fromObject(resultmsg);
			if (result.has("invaliduser")) {
				return result.getString("errmsg")+result.getString("invaliduser");
			}else{
				return result.getString("errmsg");
			}
		}
		return null;
	}
	/**
	 * 获取企业号会话
	 * @param chatid 会话id
	 * @param com_id 
	 * @return 会话信息
	 */
	 public String chatGet(String chatid, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/get?access_token="+getChatAccessToken(com_id)+"&chatid="+chatid;
		String resultmsg = getData(url);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			if (result.has("chat_info")) {
				return result.getString("chat_info");
			}else{
				return resultmsg;
			}
		}
		return null;
	}
	 
	 /**
	  * 修改企业会话
	 * @param chatid  是	 会话id。字符串类型，最长32个字符。只允许字符0-9及字母a-zA-Z, 
	 * @param name 是	 会话标题
	 * @param owner 是	 管理员userid，必须是该会话userlist的成员之一
	  * @param add_user_list 会话新增成员列表，成员用userid来标识
	  * @param del_user_list 会话退出成员列表，成员用userid来标识
	 * @param com_id 
	  * @return
	  */
	 public String chatUpdate(String chatid,String name, String owner, String[] add_user_list,String[] del_user_list, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/update?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("chatid", chatid);
		json.put("name", name);
		json.put("op_user", owner);
		json.put("owner", owner);
		if (add_user_list!=null) {
			json.put("add_user_list", add_user_list);
		}
		if (del_user_list!=null) {
			json.put("del_user_list", del_user_list);
		}
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}
	 /**
	  * 
	  * @param chatid 会话id
	  * @param op_user 操作人userid
	 * @param com_id 
	  * @return 
	  */
	 public String chatQuit(String chatid, String op_user, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/quit?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("chatid", chatid);
		json.put("op_user", op_user);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}
	 /**
	  * 清楚未读会话
	  * @param op_user 是	 会话所有者的userid
	  * @param type 会话类型：single|group，分别表示：群聊|单聊
	  * @param lisi 会话值，为userid|chatid，分别表示：成员id|会话id
	 * @param com_id 
	  * @return
	  */
	 public String chatClearnotify(String op_user, String type, String lisi, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/chat/clearnotify?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("op_user", op_user);
		JSONObject chat=new JSONObject();
		chat.put("type", type);
		chat.put("id", lisi);
		json.put("chat", chat);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}
	 /**
	  * 发送消息
	  * @param id 接收人的值，为userid|chatid，分别表示：成员id|会话id
	  * @param msgtype 消息类型
	  * @param sender 发送人
	  * @param content 消息内容,媒体文件id
	 * @param com_id 
	  * @return
	  */
	 public String chatSend(String id,String msgtype,String sender, String content, String com_id) {
		String  url="https://qyapi.weixin.qq.com/cgi-bin/chat/send?access_token="+getChatAccessToken(com_id);
		JSONObject json=new JSONObject();
		JSONObject receiver=new JSONObject();
		receiver.put("type", "group");
		receiver.put("id", id);
		json.put("msgtype", msgtype);
		json.put("sender", sender);
		if ("image".equals(msgtype)) {
			JSONObject image=new JSONObject();
			image.put("media_id", content);
			json.put("image", image);
		}else if ("file".equals(msgtype)) {
			JSONObject file=new JSONObject();
			file.put("media_id", content);
			json.put("file", file);
		}else if ("voice".equals(msgtype)) {
			JSONObject file=new JSONObject();
			file.put("media_id", content);
			json.put("voice", file);
		}else{
			JSONObject text=new JSONObject();
			text.put("content", content);
			json.put("text", text);
		}
		json.put("receiver", receiver);
		LoggerUtils.info(json);
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
			JSONObject result = JSONObject.fromObject(resultmsg);
			return result.getString("errmsg");
		}
		return null;
	}
    public String decryptMsg(String msgSignature,String timeStamp,String nonce,String encrypt_msg, String com_id) {
        WXBizMsgCrypt pc;  
        String result ="";  
        try {  
            pc = new WXBizMsgCrypt(getAccessToken(com_id), sEncodingAESKey, getWeixinParam(com_id, "corpid"));  
            result = pc.DecryptMsg(msgSignature, timeStamp, nonce, encrypt_msg);  
        } catch (AesException e) {
            e.printStackTrace(); 
        }  
        return result;  
    }
    /**
     * 向客服发送信息
     * @param sender
     * @param receiver
     * @param content
     * @param type
     * @return
     */
	public String kfsend(JSONObject sender, JSONObject receiver, String content,
			String type, String com_id) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/kf/send?access_token="+getAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("sender", sender);
		json.put("receiver", receiver);
		json.put("msgtype", type);
		JSONObject contenttype=new JSONObject();
		if ("text".equals(type)) {
			contenttype.put("content", content);
			json.put("text", contenttype);
		}else{
			contenttype.put("media_id", content);
			json.put("image", contenttype);
		}
		String resultmsg = postData(url, json);
		if (StringUtils.isNotBlank(resultmsg)) {
//			JSONObject result = JSONObject.fromObject(resultmsg);
			return  getErrcodeToZh(resultmsg).getString("errmsg");
		}
		return null;
	}
	/**
	 * 以http post方式进行提交数据
	 * @param requestUrl  请求url
	 * @param requestParamsMap 请求参数map
	 * @return json对象
	 */
	public JSONObject httppost( String requestUrl,Map<String, Object> requestParamsMap) {
		PrintWriter printWriter = null;  
        BufferedReader bufferedReader = null;
        // BufferedReader bufferedReader = null;  
        StringBuffer responseResult = new StringBuffer();  
        StringBuffer params = new StringBuffer();  
        HttpURLConnection httpURLConnection = null;  
        // 组织请求参数  
        Iterator<Entry<String, Object>> it = requestParamsMap.entrySet().iterator();  
        while (it.hasNext()) {
            Entry<String, Object> element =  it.next();  
            params.append(element.getKey());  
            params.append("=");
            params.append(element.getValue());  
            params.append("&");  
        }  
        if (params.length() > 0) {  
            params.deleteCharAt(params.length() - 1);  
        }  
        try {  
            URL realUrl = new URL(requestUrl);  
            // 打开和URL之间的连接  
            httpURLConnection = (HttpURLConnection) realUrl.openConnection();  
            // 设置通用的请求属性  
            httpURLConnection.setRequestProperty("accept", "*/*");  
            httpURLConnection.setRequestProperty("connection", "Keep-Alive");  
            httpURLConnection.setRequestProperty("Content-Length", String  
                    .valueOf(params.length()));  
            // 发送POST请求必须设置如下两行  
            httpURLConnection.setDoOutput(true);  
            httpURLConnection.setDoInput(true);  
            // 获取URLConnection对象对应的输出流  
            printWriter = new PrintWriter(httpURLConnection.getOutputStream());  
            // 发送请求参数  
            printWriter.write(params.toString());  
            // flush输出流的缓冲  
            printWriter.flush();  
            // 根据ResponseCode判断连接是否成功  
            int responseCode = httpURLConnection.getResponseCode();  
            if (responseCode != 200) {  
            	LoggerUtils.error(" Error===" + responseCode);  
            }
            // 定义BufferedReader输入流来读取URL的ResponseData  
            bufferedReader = new BufferedReader(new InputStreamReader(  
                    httpURLConnection.getInputStream()));  
            String line;  
            while ((line = bufferedReader.readLine()) != null) {  
                responseResult.append(line);  
            }  
        } catch (Exception e) {  
        	LoggerUtils.error("send post request error!" + e);  
        } finally {  
            httpURLConnection.disconnect();  
            try {  
                if (printWriter != null) {  
                    printWriter.close();  
                }  
                if (bufferedReader != null) {  
                    bufferedReader.close();  
                }  
            } catch (IOException ex) {  
                ex.printStackTrace();  
            }  
        }  
        return JSONObject.fromObject(responseResult.toString());
	}
	/**
	 * 使用百度翻译进行英文翻译为中文
	 * @param query 需要翻译的英文内容
	 * @return 翻译后的中文
	 */
//	public String fanyi(String query) {
//		if (StringUtils.isBlank(query)) {
//			return query;
//		}
//		String requestUrl = "http://fanyi.baidu.com/v2transapi";  
//        Map<String, Object> requestParamsMap = new HashMap<String, Object>();
//        requestParamsMap.put("from", "en");
//        requestParamsMap.put("to", "zh");
//        requestParamsMap.put("transtype", "trans");  
//        requestParamsMap.put("query", query);
//        requestParamsMap.put("simple_means_flag", "3");
//        JSONObject json=httppost(requestUrl, requestParamsMap);
//        try {
//        	return json.getJSONObject("dict_result").getJSONArray("net_means").getJSONObject(0).getString("means");
//		} catch (Exception e) {
//			try {
//				return json.getJSONObject("trans_result").getJSONArray("data").getJSONObject(0).getString("dst");
//			} catch (Exception e2) {
//				return query;
//			}
//		}
//	}
//	public static Map<String,String> weixinErrorMsgMap;
	/**
	 * 加载微信返回码对应中文信息
	 * @return
	 */
	public static Map<String, String> getErrorMsg() {
		ClassLoader loader = WeixinUtil.class.getClassLoader();
		InputStream inStream = loader.getResourceAsStream("weixinerrorinfo.txt");
		if (inStream==null) {
			return null;
		}
		Scanner scanner=new Scanner(inStream,"UTF-8");
		Map<String,String> weixinErrorMsgMap=new HashMap<String, String>();
		while (scanner.hasNext()) {
			String li=scanner.nextLine();
			 if (StringUtils.isNotBlank(li)) {
				 String[] kvs=li.split("=");
				 if (StringUtils.isNotBlank(kvs[0])&&StringUtils.isNotBlank(kvs[1])) {
					 weixinErrorMsgMap.put(kvs[0].trim(), kvs[1].trim());
				}
			}
		}
		scanner.close();
		return weixinErrorMsgMap;
	}
	/**
	 * 根据返回编码获取相应的中文说明
	 * @param resultmsg  请求返回结果信息
	 * @return 根据返回码转换后的中文对应说明信息 返回JSONObject
	 */
	public JSONObject getErrcodeToZh(String resultmsg) {
		JSONObject result = JSONObject.fromObject(resultmsg);
		if (result.has("errcode")) {
			String msg=getErrorMsg().get(result.getString("errcode"));
			if (StringUtils.isNotBlank(msg)) {
				result.put("errmsg", msg);
			}
		}
		return result;
	}
	
	public static void main(String[] args) {
		WeixinUtil wx=new WeixinUtil();
//		System.out.println(w.getIPAddressInfo("119.29.37.68")); 
//		System.out.println(w.getIPAddressInfo("222.209.184.182")); 
//		String url="https://m.v.qq.com/play.html?&vid=g0396t1rhun&ptag=v.qq.com%23v.play.adaptor%232";
		String url="https://m.v.qq.com/play.html?vid=l0396nxia4w&ptag=v.qq.com%23v.play.adaptor%232";
		String msg=wx.getData(url);
		int b= msg.indexOf("<video");
		int e=msg.indexOf("</video>");
		msg=msg.substring(b, e);
		b=msg.indexOf("src")+5;
		e=msg.indexOf(">");
		System.out.println(msg.substring(b, e));
	}
	public synchronized String getIPAddressInfo(String ip) {
		if (ip.startsWith("0:0:0")) {
			return "本地地址";
		}
		String str=getData3("http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip="+ip);
		str=str.split("=")[1];
		if (StringUtils.isNotBlank(str)&&!"Read timed out".equals(str)) {
			JSONObject json=JSONObject.fromObject(str);
			if(json.getInt("ret")==1){
				StringBuffer address=new StringBuffer();//国家decode1(json.getString("country"))
//				address.append(decode1(json.getString("area")));//片区
				if (!json.getString("province").equals(json.getString("city"))) {
					address.append(decode1(json.getString("province")));//省份
				}
				address.append(decode1(json.getString("city"))).append(decode1(json.getString("isp")));// 网络类型
				return address.toString();
			}
		}
		return "无效";
	}
	public static String decode1(String s) {
		Pattern reUnicode = Pattern.compile("\\\\u([0-9a-zA-Z]{4})");
	    Matcher m = reUnicode.matcher(s);
	    StringBuffer sb = new StringBuffer(s.length());
	    while (m.find()) {
	        m.appendReplacement(sb,
	                Character.toString((char) Integer.parseInt(m.group(1), 16)));
	    }
	    m.appendTail(sb);
	    return sb.toString();
	}
	///////////////////////////
	/**
	 * 获取IP地址地理位置
	 * @param ip
	 * @param datatype jsonp,txt,xml
	 * @return 
	 */
	public synchronized String doInBackground(String ip) {
		if (ip.startsWith("0:0:0")) {
			return "本地地址";
		}
        String strUrl = "http://api.ip138.com/query/" ;
        Map<String,String> params = new HashMap<String,String>();
        params.put("ip",ip); //可为空
        params.put("datatype","jsonp");
//        params.put("callback",strings[2]); //可为空
        String result = null;
        try {
            URL url = new URL(strUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            //头信息
            HashMap<String, String> header = new HashMap<String,String>();
            header.put("token","dae14be065c23959e2e29693eb1f7a61");
            for (String headerName : header.keySet()) {
                connection.addRequestProperty(headerName, header.get(headerName));
            }
            //设置超时时间
            connection.setConnectTimeout(5*1000);
            //设置允许输入
            connection.setDoInput(true);
            //设置读取超时：
            connection.setReadTimeout(5*1000);
            connection.setRequestMethod("GET");
            //参数
            byte[] body = encodeParameters(params,"UTF-8");
            if (body != null)
            {
                connection.setDoOutput(true);
                connection.addRequestProperty("Content-Type","application/x-www-form-urlencoded; charset=" + "UTF-8");
                DataOutputStream out = new DataOutputStream(connection.getOutputStream());
                out.write(body);
                out.close();
            }
            int responseCode = connection.getResponseCode();
            if (responseCode == -1) {
                throw new IOException("Could not retrieve response code from HttpUrlConnection.");
            }
            if (responseCode != 200)
            {
                return responseCode + "";
            }
            InputStream inputStream = null;
            try {
                inputStream = connection.getInputStream();
            } catch (IOException ioe) {
                inputStream = connection.getErrorStream();
            }
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            byte[] data = new byte[1024];
            int len = 0;
            if (inputStream != null) {
                try {
                    while ((len = inputStream.read(data)) != -1) {
                        outputStream.write(data, 0, len);
                    }
                    result = new String(outputStream.toByteArray(), "UTF-8");
                }
                catch (IOException e) {
                    e.printStackTrace();
                }
            }
            JSONObject json=JSONObject.fromObject(result);
            if ("ok".equals(json.getString("ret"))) {
            	JSONArray js=json.getJSONArray("data");
            	StringBuffer b=new StringBuffer();
            	for (int i = 1; i < js.size(); i++) {
					b.append(js.getString(i));
				}
            	return b.toString();
			}else{
				LoggerUtils.error(json);
			}
            return "无效";
        } catch (IOException e) {

        }
        return null;
    }
	byte[] encodeParameters(Map<String, String> params, String paramsEncoding) {
        if (params == null || params.size() == 0) return null;

        StringBuilder encodedParams = new StringBuilder();
        try {
            for (Map.Entry<String, String> entry : params.entrySet()) {
                encodedParams.append(URLEncoder.encode(entry.getKey(), paramsEncoding));
                encodedParams.append('=');
                encodedParams.append(URLEncoder.encode(entry.getValue(), paramsEncoding));
                encodedParams.append('&');
            }
            return encodedParams.toString().getBytes(paramsEncoding);
        } catch (UnsupportedEncodingException uee) {
            throw new RuntimeException("Encoding not supported: " + paramsEncoding, uee);
        }
    }
	////////////////////////////
	public String getCodeUrl(String com_id, String redirect_uri , String state) throws UnsupportedEncodingException {
		StringBuffer url=new StringBuffer("https://open.weixin.qq.com/connect/oauth2/authorize?appid=");
		url.append(getWeixinParam(com_id, "corpid")).append("&redirect_uri=").append(URLEncoder.encode(redirect_uri,"utf-8"));
		url.append("&response_type=code&scope=snsapi_base");
		url.append("&state=").append(state).append("#wechat_redirect");
		return url.toString();
	}
	/**
	 * 获取
	 * @param com_id
	 * @param code
	 * @return
	 * { "UserId":"USERID", "DeviceId":"DEVICEID"}
	 * { "OpenId":"OpenId", "DeviceId":"DEVICEID"}
	 */
	public JSONObject getuserinfo(String com_id, String code) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/user/getuserinfo?access_token="+getAccessToken(com_id)+"&code="+code;
		String ret=getData(url);
		if (StringUtils.isNotBlank(ret)) {
			JSONObject json=JSONObject.fromObject(ret);
			if (json.has("UserId")) {
				json.put("userid", json.get("UserId"));
			}
			return json;
		}
		return null;
	}
	/**
	 * 获取登录用户账户信息
	 * @param com_id
	 * @param auth_code 授权码
	 * @return
	 */
	public String getUseridBylogin(String com_id, String auth_code) {
		String url="https://qyapi.weixin.qq.com/cgi-bin/service/get_login_info?access_token="+getAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("auth_code", auth_code);
		String ret=postData(url, json);
		JSONObject retjson=JSONObject.fromObject(ret);
		if(retjson.has("user_info")){
			retjson=retjson.getJSONObject("user_info");
			if (retjson.has("userid")) {
				return retjson.getString("userid");
			}else{
				return retjson.getString("email");
			}
		}
		return null;
	}
}
