package com.qianying.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Formatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Sign {
//    public static void main(String[] args) {
//        String jsapi_ticket = "jsapi_ticket";
//
//        // 注意 URL 一定要动态获取，不能 hardcode
//        String url = "http://dengqiang.nat123.com";
//        Map<String, String> ret = sign(jsapi_ticket,"dengqiang",new Date().getTime()+"", url);
//        for (Map.Entry entry : ret.entrySet()) {
//            System.out.println(entry.getKey() + ", " + entry.getValue());
//        }
//    };

    public static Map<String, String> sign(String jsapi_ticket,String nonce_str,String timestamp, String url) {
        Map<String, String> ret = new HashMap<String, String>();
        String string1;
        String signature = "";
        //注意这里参数名必须全部小写，且必须有序
        string1 = "jsapi_ticket=" + jsapi_ticket +
                  "&noncestr=" + nonce_str +
                  "&timestamp=" + timestamp +
                  "&url=" + url;
        LoggerUtils.info(string1);
        try
        {
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
            crypt.update(string1.getBytes("UTF-8"));
            signature = byteToHex(crypt.digest());
        }
        catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }
        catch (UnsupportedEncodingException e)
        {
            e.printStackTrace();
        }

        ret.put("url", url);
        ret.put("jsapi_ticket", jsapi_ticket);
        ret.put("nonceStr", nonce_str);
        ret.put("timestamp", timestamp);
        ret.put("signature", signature);
        return ret;
    }
    public static Map<String, String> signDa(String jsapi_ticket,String nonce_str,String timestamp, String url) {
        Map<String, String> ret = new HashMap<String, String>();
        String string1;
        String signature = "";
        //注意这里参数名必须全部小写，且必须有序
        string1 = "jsapi_ticket=" + jsapi_ticket +
                  "&nonceStr=" + nonce_str +
                  "&timeStamp=" + timestamp +
                  "&url=" + url;
        LoggerUtils.info(string1);
        try
        {
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
            crypt.update(string1.getBytes("UTF-8"));
            signature = byteToHex(crypt.digest());
        }
        catch (NoSuchAlgorithmException e)
        {
            e.printStackTrace();
        }
        catch (UnsupportedEncodingException e)
        {
            e.printStackTrace();
        }

        ret.put("url", url);
        ret.put("jsapi_ticket", jsapi_ticket);
        ret.put("nonceStr", nonce_str);
        ret.put("timestamp", timestamp);
        ret.put("signature", signature);
        return ret;
    }
    /**
     * 微信支付签名计算
     * @param map 
     * @param weixinType 
     * @param stringA 
     * @return 微信支付签名
     */
    public static String sign(Map<String, Object> map, String weixinType) {
    	String stringA=mapSort(map);
    	String weixinKey=null;//微信商户好找设置的密钥,用于计算签名的时候使用
    	if("0".equals(weixinType)){
    	   weixinKey="qianyinsortware20170302130000000";//微信商户好找设置的密钥,用于计算签名的时候使用
    	}else{
    	   weixinKey="yglGxlWqNj3s9i2nWXVvI4CLWiu1Iu55";//微信商户好找设置的密钥,用于计算签名的时候使用
    	}
    	String stringSignTemp=stringA+"&key="+weixinKey;
    	return MD5.MD5Encode(stringSignTemp).toUpperCase();
	}
//    public static void main(String[] args) throws UnsupportedEncodingException {
//    	String stringSignTemp="appId=wx582baadfc7c9859b&nonceStr=fa25ab6a&package=prepay_id=wx20151118154958f84fce63c30038953883&signType=MD5&timeStamp=1447832998&key=yglGxlWqNj3s9i2nWXVvI4CLWiu1Iu55";
//    	System.out.println( MD5.MD5Encode(stringSignTemp).toUpperCase());
//	}
    public static String mapSort(Map<String,Object> map) {
		List<Map.Entry<String,Object>> mappingList = null; 
		  //通过ArrayList构造函数把map.entrySet()转换成list 
		  mappingList = new ArrayList<Map.Entry<String,Object>>(map.entrySet()); 
		  //通过比较器实现比较排序 
		  Collections.sort(mappingList, new Comparator<Map.Entry<String,Object>>(){ 
		   public int compare(Map.Entry<String,Object> mapping1,Map.Entry<String,Object> mapping2){ 
		    return mapping1.getKey().compareTo(mapping2.getKey()); 
		   } 
		  }); 
		  StringBuffer buffer=new StringBuffer();
		  for(Map.Entry<String,Object> mapping:mappingList){
		   buffer.append(mapping.getKey()).append("=").append(mapping.getValue()).append("&");
		  } 
		  return buffer.toString().substring(0,buffer.length()-1);
	}
    
    private static String byteToHex(final byte[] hash) {
        Formatter formatter = new Formatter();
        for (byte b : hash)
        {
            formatter.format("%02x", b);
        }
        String result = formatter.toString();
        formatter.close();
        return result;
    }

//    private static String create_nonce_str() {
//        return UUID.randomUUID().toString();
//    }
//
//    private static String create_timestamp() {
//        return Long.toString(System.currentTimeMillis() / 1000);
//    }
}
