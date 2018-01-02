package com.qianying.util;



import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.bcloud.msg.http.HttpSender;
import com.qianying.controller.BaseController;
import com.qianying.controller.FilePathController;

public class SendSmsUtil {
	private static int connectTimeOut = 5000;
	private static int readTimeOut = 10000;
	private static String requestEncoding = "UTF-8";
	public static int getConnectTimeOut() {
		return connectTimeOut;
	}
	public static void setConnectTimeOut(int connectTimeOut) {
		SendSmsUtil.connectTimeOut = connectTimeOut;
	}
	public static int getReadTimeOut() {
		return readTimeOut;
	}
	public static void setReadTimeOut(int readTimeOut) {
		SendSmsUtil.readTimeOut = readTimeOut;
	}
	public static String getRequestEncoding() {
		return requestEncoding;
	}
	public static void setRequestEncoding(String requestEncoding) {
		SendSmsUtil.requestEncoding = requestEncoding;
	}
	
	public static String doGet(String requrl,Map<?,?> parameters,String recvEndcoding){
		HttpURLConnection url_con=null;
		String responseContent = null;
		String vchartset=recvEndcoding==""?SendSmsUtil.requestEncoding:recvEndcoding;
		try {
				StringBuffer params=new StringBuffer();
				for (Iterator<?> iter=parameters.entrySet().iterator();iter.hasNext();) {
					Entry<?, ?> element=(Entry<?, ?>) iter.next();
					params.append(element.getKey().toString());
					params.append("=");
					params.append(URLEncoder.encode(element.getValue().toString(),vchartset));
					params.append("&");
				}
				if(params.length()>0){
					params=params.deleteCharAt(params.length()-1);
				}
				URL url=new URL(requrl);
				url_con=(HttpURLConnection) url.openConnection();
				url_con.setRequestMethod("GET");
				System.setProperty("连接超时：", String.valueOf(SendSmsUtil.connectTimeOut));
				System.setProperty("访问超时：", String.valueOf(SendSmsUtil.readTimeOut)); 
				url_con.setDoOutput(true);//
				byte[] b=params.toString().getBytes();
				url_con.getOutputStream().write(b, 0,b.length);
				url_con.getOutputStream().flush();
				url_con.getOutputStream().close();
				InputStream in=url_con.getInputStream();
				byte[] echo=new byte[10*1024];
				int len=in.read(echo);
				responseContent=(new String(echo,0,len).trim());
				int code = url_con.getResponseCode();
				if (code != 200) {
					responseContent = "ERROR" + code;
				}
				in.close();
		} catch (Exception e) {
			LoggerUtils.error("网络故障:"+ e.getMessage());
		}finally{
			if(url_con!=null){
				url_con.disconnect();
			}
		}
		return responseContent;
		
	}
	public static String doGet(String reqUrl, String recvEncoding) {
		HttpURLConnection url_con = null;
		String responseContent = null;
		String vchartset=recvEncoding==""?SendSmsUtil.requestEncoding:recvEncoding;
		try {
				StringBuffer params = new StringBuffer();
				String queryUrl = reqUrl;
				int paramIndex = reqUrl.indexOf("?");
				
				if (paramIndex > 0) {
					queryUrl = reqUrl.substring(0, paramIndex);
					String parameters = reqUrl.substring(paramIndex + 1, reqUrl.length());
					String[] paramArray = parameters.split("&");
					for (int i = 0; i < paramArray.length; i++) {
						String string = paramArray[i];
						int index = string.indexOf("=");
						if (index > 0) {
							String parameter = string.substring(0, index);
							String value = string.substring(index + 1, string.length());
							params.append(parameter);
							params.append("=");
							params.append(URLEncoder.encode(value, vchartset));
							params.append("&");
						}
					}

					params = params.deleteCharAt(params.length() - 1);
				}
				URL url = new URL(queryUrl);
				url_con = (HttpURLConnection) url.openConnection();
				url_con.setRequestMethod("GET");
				System.setProperty("sun.net.client.defaultConnectTimeout", String.valueOf(SendSmsUtil.connectTimeOut));
				System.setProperty("sun.net.client.defaultReadTimeout", String.valueOf(SendSmsUtil.readTimeOut));
				url_con.setDoOutput(true);
				byte[] b = params.toString().getBytes();
				url_con.getOutputStream().write(b, 0, b.length);
				url_con.getOutputStream().flush();
				url_con.getOutputStream().close();
				InputStream in = url_con.getInputStream();
				byte[] echo = new byte[10 * 1024];
				int len = in.read(echo);
				responseContent = (new String(echo, 0, len)).trim();
				int code = url_con.getResponseCode();
				if (code != 200) {
					responseContent = "ERROR" + code;
				}
				in.close();
		} catch (Exception e) {
			LoggerUtils.error("网络故障:"+ e.getMessage());
		}finally{
			if (url_con != null) {
				url_con.disconnect();
			}
		}
		return responseContent;
		
	}
	
	
	/**
	 * 调用post方法发送短信
	 * 传入参数示例
	 * 
	 * Map<String, String> map = new HashMap<String, String>();
	 *	map.put("username", "JSMB260263");//此处填写用户账号
	 *	map.put("scode", "800283");//此处填写用户密码
	 *	map.put("mobile","13708075380");//此处填写发送号码
	 *	map.put("tempid","MB-2013102300");//此处填写模板短信编号
	 *	//map.put("extcode","1234");
	 *	map.put("content","@1@=1234");//此处填写模板短信内容
	 *	String temp = SendSmsUtil.doPost("http://mssms.cn:8000/msm/sdk/http/sendsms.jsp",map, "GBK");
	 *
	 * @param reqUrl
	 * @param parameters
	 * @param recvEncoding
	 * @return
	 */
	public static String doPost(String reqUrl, Map<String, String> parameters, String recvEncoding) {
		HttpURLConnection url_con = null;
		String responseContent = null;
		String vchartset=recvEncoding==""?SendSmsUtil.requestEncoding:recvEncoding;
		try {
			StringBuffer params = new StringBuffer();
			for (Iterator<?> iter = parameters.entrySet().iterator(); iter.hasNext();) {
				Entry<?, ?> element = (Entry<?, ?>) iter.next();
				params.append(element.getKey().toString());
				params.append("=");
				params.append(element.getValue().toString());
//				params.append(URLEncoder.encode(element.getValue().toString(), vchartset));
				params.append("&");
			}

			if (params.length() > 0) {
				params = params.deleteCharAt(params.length() - 1);
			}

			URL url = new URL(reqUrl);
			url_con = (HttpURLConnection) url.openConnection();
			url_con.setRequestMethod("POST");
			url_con.setConnectTimeout(SendSmsUtil.connectTimeOut);
			url_con.setReadTimeout(SendSmsUtil.readTimeOut);
			url_con.setDoOutput(true);
			byte[] b = params.toString().getBytes();
			url_con.getOutputStream().write(b, 0, b.length);
			url_con.getOutputStream().flush();
			url_con.getOutputStream().close();

			InputStream in = url_con.getInputStream();
			byte[] echo = new byte[10 * 1024];
			int len = in.read(echo);
			responseContent = (new String(echo, 0, len)).trim();
			int code = url_con.getResponseCode();
			if (code != 200) {
				responseContent = "ERROR" + code;
			}
			in.close();
		}
		catch (IOException e) {
			LoggerUtils.error("网络故障:"+ e.getMessage());
		}
		finally {
			if (url_con != null) {
				url_con.disconnect();
			}
		}
		return responseContent;
	}
	/**
	 * 短信验证码发送
	 * 
	 * @param MobileNum
	 *            接收者手机号
	 * @param SendMsg
	 *            短信验证码
	 * @param pwdText
	 *            忘记密码短信内容发送
	 * @param object2 
	 * @param sendMsgBegin 
	 * @param SMSID 
	 * @param SmsUsername 
	 * @param SmsPassword 
	 * @return 返回值：>0代表您成功发送的短信数目，-1用户不存在，-2系统错误，-3余额不足，
	 *         -4无发送内容，-5无接收号码，-6网络通信错误，-7密码错误或IP非法 ，-8帐户未激活，-9网络异常
	 * @throws UnsupportedEncodingException 
	 */
	public synchronized static String sendSms2(String MobileNum, String SendMsg, String pwdText, Map<String,Object> map)  {
//		String sendMsgBegin, String sendMsgEnd, String SMSID, String SmsUsername, String SmsPassword;
		if(StringUtils.isBlank(MapUtils.getString(map, "smsid"))||MapUtils.getString(map, "smsid").equals("0")){
			String s=sendSmsLvDou(MobileNum, SendMsg, pwdText,map);
			if(s!=null){
				return s;
			}
		}
		String s0=null;
		String s1=null;
		String msg = null;
		try {
			if (StringUtils.isBlank(MobileNum)) {
				return "没有要发送的短信号码";
			}
			if (StringUtils.isBlank(SendMsg)) {
				pwdText=pwdText.replaceAll("【", "");
				pwdText=pwdText.replaceAll("】", "");
				int end=MapUtils.getString(map, "sendMsgBegin").indexOf("】");
				String qianm=MapUtils.getString(map, "sendMsgBegin").substring(0, end+1);
				msg = qianm+pwdText;
			} else {
				msg = MapUtils.getString(map, "sendMsgBegin") + SendMsg + MapUtils.getString(map, "sendMsgEnd");
			}
			msg = URLEncoder.encode(msg, "utf-8");
		} catch (Exception e0) {}
		try {
			s1 = "http://121.199.39.230:8888/sms.aspx?action=send&userid="+MapUtils.getString(map, "smsid")+"&account="
					.concat(URLEncoder.encode(MapUtils.getString(map, "SmsUsername"), "utf-8")).concat("&password=")
					.concat(MapUtils.getString(map, "SmsPassword")).concat("&mobile=")
					.concat(MobileNum).concat("&content=").concat(msg).concat("&sendTime=&taskName=&mobilenumber=")
					.concat("1&telephonenumber=0");
		} catch (Exception e) {}
		LoggerUtils.info(s1);
		s0 = SendGet(s1);
		LogUtil.saveFile(s1+"--->>>"+s0+"\r\n","sms");
		try {
			s0=new String(s0.getBytes(), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		LoggerUtils.info(s0);
		if(s0.contains("ok")){
			return "ok";
		}else{
			return s0;
		}
	}
	public synchronized static String sendSms3(String MobileNum, String verificationCode, String txtMsg,Map<String, Object> map)  {
		String msg = null;
		try {
			if (StringUtils.isBlank(MobileNum)) {
				return "没有要发送的短信号码";
			}
			if (StringUtils.isBlank(verificationCode)) {
				if(!txtMsg.contains("【")){
					int end=MapUtils.getString(map, "sendMsgBegin").indexOf("】");
					String qianm=MapUtils.getString(map, "sendMsgBegin").substring(0, end+1);
					msg = qianm + txtMsg;
				}else{
					txtMsg=txtMsg.replaceAll("【", "[");
					txtMsg=txtMsg.replaceAll("】", "]");
					int end=MapUtils.getString(map, "sendMsgBegin").indexOf("】");
					String qianm=MapUtils.getString(map, "sendMsgBegin").substring(0, end+1);
					msg = qianm + txtMsg;
				}
			} else {
				msg = MapUtils.getString(map, "sendMsgBegin") + verificationCode + MapUtils.getString(map, "sendMsgEnd");
			}
//			msg = URLEncoder.encode(msg, "utf-8");
		} catch (Exception e0) {}
			String uri = "http://114.55.141.65/msg/index.jsp";//应用地址
			String account =MapUtils.getString(map, "SmsUsername") ;//账号
			String pswd = MapUtils.getString(map, "SmsPassword") ;//密码
			boolean needstatus = true;//是否需要状态报告，需要true，不需要false
			String returnString="";
			try {
				returnString = HttpSender.send(uri, account, pswd, MobileNum, msg, needstatus, null, null);
			} catch (Exception e) {
				e.printStackTrace();
			}
			if(returnString.contains(",0")){
				LogUtil.saveFile(msg, "sms");
				return "ok";
			}else{
				return "error";
			}
	}
	/**
	 * 绿豆短信发送
	 * @param MobileNum
	 * @param verificationCode  验证码
	 * @param txtMsg 非验证码短信内容
	 * @param map 账号信息
	 * @return 发送状态
	 */
	public synchronized static String sendSmsLvDou(String MobileNum, String verificationCode, String txtMsg,Map<String, Object> map)  {
		String msg = null;
		String smsType="1";
		try {
			if (StringUtils.isBlank(MobileNum)) {
				return "没有要发送的短信号码";
			}
			if (StringUtils.isBlank(verificationCode)) {
				smsType="2";
				if(!txtMsg.contains("【")){
					int end=MapUtils.getString(map, "sendMsgBegin").indexOf("】");
					String qianm=MapUtils.getString(map, "sendMsgBegin").substring(0, end+1);
					msg = qianm + txtMsg;
				}else{
					int end=MapUtils.getString(map, "sendMsgBegin").indexOf("】");
					String qianm=MapUtils.getString(map, "sendMsgBegin").substring(0, end+1);
					if (!txtMsg.contains(qianm)) {
						txtMsg=txtMsg.replaceAll("【", "[");
						txtMsg=txtMsg.replaceAll("】", "]");
						msg = qianm + txtMsg;
					}else{
						msg = txtMsg;
					}
				}
			} else {
				msg = MapUtils.getString(map, "sendMsgBegin") + verificationCode + MapUtils.getString(map, "sendMsgEnd");
			}
		msg = URLEncoder.encode(msg, "utf-8");
		} catch (Exception e0) {}
//		String uri = "http://112.74.19.39:9999/sms/send";//应用地址
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
                .getRequestAttributes()).getRequest();
		String com_id=request.getSession().getAttribute(ConfigFile.OPERATORS_NAME).toString();
		if(StringUtils.isBlank(com_id)){
			com_id="001";
		}
		File file=new File(BaseController.getRealPath(request)+com_id+"/sms.json");
		String info=FilePathController.getFileTextContent(file);
		if (StringUtils.isBlank(info)) {
			msg="参数缺少,请联系管理员!";
		}
		JSONObject json=JSONObject.fromObject(info);
		String uri =json.getString("uri");// "http://119.23.45.121:9999/sms/send";//应用地址
		String accountKey =json.getString("accountKey");// "9028b83ac46a4b01a0ee755d684a0b12";
		String token =json.getString("token");//"af6ab1ca3d014c69a182fb5b64cdd46a";
		String appId =json.getString("appId");//"617892d13d6b41bfbaa76d756d0fa514";
		String returnString="";
		try {
			Long time=new Date().getTime();
			String sign=MD5Util.MD5(accountKey+token+time);
			String key=new String(Base64.encodeBase64((accountKey+":"+time).getBytes()));
			StringBuffer param=new StringBuffer("content=").append(msg).append("&sign=").append(sign).append("&key=").append(key);
			param.append("&smsType=").append(smsType).append("&to=").append(MobileNum)
			.append("&id=").append(accountKey).append("&appId=").append(appId);
			returnString =sendPost(uri, param.toString());
			LoggerUtils.info(returnString);
		} catch (Exception e) {
			e.printStackTrace();
		}
//			StringBuffer param=new StringBuffer("http://119.23.45.121:9999").append("?id=617892d13d6b41bfbaa76d756d0fa514 ").
//					append("&sign=").append(sign).append("&key=").append(key);
//			returnString=SendGet(param.toString());
		if(returnString.contains("200")){
			LogUtil.saveFile(msg, "sms");
			return "ok";
		}else{
			return "error";
		}
	}
	public synchronized static String sendSmsYx(String MobileNum, String txtMsg,Map<String, Object> map)  {
		String msg = null;
		if (StringUtils.isBlank(MobileNum)) {
			return "没有要发送的短信号码";
		}
		if (!txtMsg.endsWith("退订回T")) {
			txtMsg=txtMsg+".退订回T";
		}
    	String url="http://222.73.66.76:8000/sendsms.asp";
    	String account=MapUtils.getString(map, "YxSmsUsername") ;
    	String password=MapUtils.getString(map, "YxSmsPassword");
    	String content=txtMsg;
		try {
			txtMsg = URLEncoder.encode(txtMsg, "gb2312");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	String channel="1";
    	String request="account="+account+"&password="+password+"&phones="+MobileNum+"&content="+txtMsg+"&channel="+channel;
		String returnString="";
		msg=sendPost(url, request);
		LogUtil.saveFile(MobileNum+"|"+content+"|"+msg, "sms");
		if(returnString.contains(",0")){
			return "ok";
		}else{
			return "error";
		}
	}
	public static String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("user-agent",
                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }  
//	public static String sendPost(String url,String params) {
//		String result = "";
//		try {
//			URL httpurl = new URL(url);
//			HttpURLConnection httpConn = (HttpURLConnection) httpurl
//					.openConnection();
//			httpConn.setDoInput(true);
//			httpConn.setReadTimeout(5*1000);  
//			httpConn.setRequestMethod("post");
//			DataOutputStream out = new DataOutputStream(
//					httpConn.getOutputStream());
//			out.write(params.getBytes());
//			out.flush();
//			out.close();
//			BufferedReader readin = new BufferedReader(new InputStreamReader(
//					httpConn.getInputStream()));
//			String CurLine;
//			while ((CurLine = readin.readLine()) != null) {
//				result += CurLine;
//			}
//			readin.close();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return result;
//	}
	public static String SendGet(String url) {
		String result = "";
		try {
			URL httpurl = new URL(url);
			HttpURLConnection httpConn = (HttpURLConnection) httpurl
					.openConnection();
			httpConn.setDoInput(true);
			httpConn.setReadTimeout(5*1000);  
			httpConn.setRequestMethod("GET");
			BufferedReader readin = new BufferedReader(new InputStreamReader(
					httpConn.getInputStream()));
			String CurLine;
			while ((CurLine = readin.readLine()) != null) {
				result += CurLine;
			}
			readin.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
 
	// ////////////////短信发送结束/////////////////////////
	public static void main(String[] args) {
		/*达州电商部分页面：首页一个，产品列表，家装案例列表，设计师列表，产品详情，家装案例详情，设计师详情，购物车，订单确认，9个页面，再加个人中心，全部订单，资料维护，收货地址列表，增加，物流信息查看，
大小页面共计15个左右页面*/
	}
}
