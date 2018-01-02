package com.qianying.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class AuthenticationUtil {
	/**
	 * hash算法
	 * @param encryptText
	 * @param encryptKey
	 * @return
	 * @throws Exception
	 */
	public static String getHash(String encryptText, String encryptKey) throws Exception { 
		byte[] data=encryptKey.getBytes(); 
		SecretKey secretKey = new SecretKeySpec(data, "HmacSHA1"); 
		Mac mac = Mac.getInstance("HmacSHA1"); 
		mac.init(secretKey); 
		byte[] text = encryptText.getBytes(); 
		return bytesToHexString(mac.doFinal(text)); 
		} 
		public static String bytesToHexString(byte[] src){ 
		StringBuilder stringBuilder = new StringBuilder(""); 
		if (src == null || src.length <= 0) { 
		return null; 
		} 
		for (int i = 0; i < src.length; i++) { 
		int v = src[i] & 0xFF; 
		String hv = Integer.toHexString(v); 
		if (hv.length() < 2) { 
		stringBuilder.append(0); 
		} 
		stringBuilder.append(hv); 
		} 
		return stringBuilder.toString(); 
		} 
		//发送
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
	            in.close();
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
		
//		public static void main(String[] args) throws Exception {
//			long time = System.currentTimeMillis();
//			//应用app json数组
//			String app ="{\"appid\":\"1004\" , \"channel\":\"1004\" , \"timestamp\":\""+time+"\"}" ;
//			System.out.println(app);
//			System.out.println(getHash("appid=1004&timestamp="+ System.currentTimeMillis()+"&channel=1004", "DSphYnoKGK1sGfKpu90TD6p6+V2tctAhpdjpew7C7Pk="));;
//		}
}
