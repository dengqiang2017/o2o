package com.qianying.util;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Iterator;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.qianying.controller.BaseController;

/**
 * 微信服务号工具类
 * @author dengqiang
 *
 */
public class WeiXinServiceUtil extends WeixinUtil {
	public String getAccessToken(String com_id) {
		String access_token=getWeixinParam(com_id,"access_token_service");
		if (StringUtils.isNotBlank(access_token)) {
			return access_token;
		}
		///wxd6d2b1e1898c3ef2////7480f2a2ac99a366e327a8b5be84ccaf
		String url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="
				+ getWeixinParam(com_id,"appid_service") + "&secret=" +getWeixinParam(com_id,"secret_service");
		String result = getData(url);
		LoggerUtils.info(result);
		if (StringUtils.isNotBlank(result)) {
			JSONObject json = JSONObject.fromObject(result);
				if (json.has("access_token")) {
					result = json.getString("access_token");
					BaseController.saveFile(getWeixinParamFile(com_id,"access_token_service"), result);
					access_token = result;
				}else{
					LoggerUtils.info(json);
				}
		} else {
			result = "连接微信访问出错!";
		}
		return result;
		
	}
	//TODO //////微信网页版操作开始///////
	/**
	 * 第一步 获取用户消息引导微信页面链接
	 * @param com_id
	 * @param redirect_uri 回调地址
	 * @param state 额外参数
	 * @return 微信登录界面
	 * @throws UnsupportedEncodingException 
	 */
	public String getCodeUrl(String com_id, String redirect_uri, String state) throws UnsupportedEncodingException {
//		String url="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+getWeixinParam(com_id,"appid_service");
//		url+="&redirect_uri="+URLEncoder.encode(redirect_uri,"utf-8")+"&response_type=code&scope=snsapi_userinfo&state="+state+"#wechat_redirect";
		StringBuffer urlb=new StringBuffer("https://open.weixin.qq.com/connect/oauth2/authorize?appid=");
		urlb.append(getWeixinParam(com_id,"appid_service")).append("&redirect_uri=").append(URLEncoder.encode(redirect_uri,"utf-8"));
		urlb.append("&response_type=code&scope=snsapi_base&state=").append(state).append("#wechat_redirect");
		return urlb.toString();
	}
	////////////////////////
	/**
	 * 第二步获取 OpenIdAndAccess_token
	 * @param com_id
	 * @param code 第一步页面调整后参数中的值
	 * @return {"access_token":"","expires_in":7200,"refresh_token":"","openid":"","scope":""}
	 * @Error 错误时返回 {"errcode":40029,"errmsg":"invalid code"}
	 * appID wx424277e9331956e8
appsecret 0c102005dc45eed4c3ec5e173a553e3d
	 */
	public JSONObject getOpenIdAndAccess_token(String com_id, String code) {//URLEncoder.encode(s)
		String url="https://api.weixin.qq.com/sns/oauth2/access_token?appid="+getWeixinParam(com_id,"appid_service")+
				"&secret="+getWeixinParam(com_id,"secret_service")+"&code="+code+"&grant_type=authorization_code";
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			return JSONObject.fromObject(msg);
		}
		return null;
	}
	/**
	 * 第三步 刷新网页版Access_token
	 * 由于access_token拥有较短的有效期，当access_token超时后，可以使用refresh_token进行刷新，
	 * refresh_token拥有较长的有效期（7天、30天、60天、90天），当refresh_token失效的后，需要用户重新授权。
	 * @param com_id
	 * @param refresh_token 第二步页面中获取到的refresh_token
	 * @return {"access_token":"","expires_in":7200,"refresh_token":"","openid":"","scope":""}
	 * @Error 错误时返回 {"errcode":40029,"errmsg":"invalid code"}
	 */
	public JSONObject refresh_token(String com_id, String refresh_token) {
		String url="https://api.weixin.qq.com/sns/oauth2/refresh_token?appid="+getWeixinParam(com_id,"appid_service")+
				"&grant_type=refresh_token&refresh_token="+refresh_token;
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			return JSONObject.fromObject(msg);
		}
		return null;
	}
	/**
	 * 第四部获取用户信息
	 * @param access_token 网页版access_token 第二步中获取
	 * @param openid 用户openid
	 * @return 用户信息json  
	 * @error {"errcode":40003,"errmsg":" invalid openid "}
	 */
	public JSONObject getUserInfo(String access_token, String openid) {
		String url="https://api.weixin.qq.com/sns/userinfo?access_token="+access_token+"&openid="+openid+"&lang=zh_CN";
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			return JSONObject.fromObject(msg);
		}
		return null;
	}
	
	public JSONObject getUserInfoByOpenid(String openid, String com_id) {
		String url="https://api.weixin.qq.com/cgi-bin/user/info?access_token="+getAccessToken(com_id)+"&openid="+openid+"&lang=zh_CN";
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			JSONObject json=JSONObject.fromObject(msg);
			if(json.has("errcode")){
				boolean b=delAccessTokenFile(json, com_id);
				if(b){
					msg=getData(url);
					json=JSONObject.fromObject(msg);
				}
				return json;
			}else{
				return json;
			}
		}  
		return null;
	}
	
	/**
	 * 验证网页获取的access_token是否可以使用
	 * @param access_token 第二步网页版access_token
	 * @param openid 用户openid
	 * @return 可以使用返回true, openid无效返回false,接口访问错误返回null
	 */
	public Boolean checkAccess_token(String access_token, String openid) {
		String url="https://api.weixin.qq.com/sns/auth?access_token="+access_token+"&openid="+openid;
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			JSONObject json= JSONObject.fromObject(msg);
			if ("ok".equals(json.getString("errmsg"))) {
				return true;
			}else{
				return false;
			}
		}
		return null;
	}
	//TODO //////微信网页版操作结束///////
	/**
	 * 设置post发送方式 设置行业类型
	 * @param com_id 
	 * @return
	 */
	public void api_set_industry(String com_id) {
		String url="https://api.weixin.qq.com/cgi-bin/template/api_set_industry?access_token="+getAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("industry_id1", "1");
		json.put("industry_id2", "15");
		String msg=postData(url, json);
		LoggerUtils.info(msg);
	}
	/**
	 * 获取服务号消息模板列表
	 * @param com_id
	 * @return
	 */
	public JSONArray get_all_private_template(String com_id) {
		String url="https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token="+getAccessToken(com_id);
		String msg=getData(url);
		if (StringUtils.isNotBlank(msg)) {
			JSONObject json=JSONObject.fromObject(msg);
			if (json.has("template_list")) {
				return json.getJSONArray("template_list");
			}
		}
		LoggerUtils.info(msg);
		return null;
//		{	
//			 "template_list": [{
//			      "template_id": "iPk5sOIt5X_flOVKn5GrTFpncEYTojx6ddbt8WYoV5s",
//			      "title": "领取奖金提醒",
//			      "primary_industry": "IT科技",
//			      "deputy_industry": "互联网|电子商务",
//			      "content": "{ {result.DATA} }\n\n领奖金额:{ {withdrawMoney.DATA} }\n领奖  时间:{ {withdrawTime.DATA} }\n银行信息:{ {cardInfo.DATA} }\n到账时间:  { {arrivedTime.DATA} }\n{ {remark.DATA} }",
//			      "example": "您已提交领奖申请\n\n领奖金额：xxxx元\n领奖时间：2013-10-10 12:22:22\n银行信息：xx银行(尾号xxxx)\n到账时间：预计xxxxxxx\n\n预计将于xxxx到达您的银行卡"
//			   }]
//			}
	}
	/**
	 * 发送服务号模板消息
	 * @param touser 接收人
	 * @param template_id 模板编号
	 * @param com_id
	 * @param url 跳转地址
	 * @return
	 */
	public String sendMessage(Object touser, Object template_id, String com_id, Object url,JSONObject data) {
		String posturl="https://api.weixin.qq.com/cgi-bin/message/template/send?access_token="+getAccessToken(com_id);
		JSONObject json=new JSONObject();
		json.put("touser", touser);
		json.put("template_id", template_id);
		if(url.toString().contains("?")){
			json.put("url", url+"|com_id="+com_id);
		}else{
			json.put("url", url+"?com_id="+com_id);
		}
		json.put("data", data);
		String msg=postData(posturl, json);
		if (StringUtils.isNotBlank(msg)&&msg.startsWith("{")) {
			JSONObject ret=JSONObject.fromObject(msg);
			if(delAccessTokenFile(ret, com_id)){
				msg=postData(posturl, json);
			}
			json.put("time", DateTimeUtils.dateTimeToStr());
			json.put("ret", msg);
			LogUtil.saveFile(json.toString()+",","news");
		}
		return msg;
	}
	/**
	 * 获取用户列表
	 * @param com_id
	 * @return
	 */
	public JSONObject getUserInfoList(String com_id) {
		String url="https://api.weixin.qq.com/cgi-bin/user/get?access_token="+getAccessToken(com_id);
		String info=getData(url);System.out.println(info);
		JSONObject json=JSONObject.fromObject(info);
		JSONArray jsons=json.getJSONObject("data").getJSONArray("openid");
		JSONArray ar=new JSONArray();
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject openid=new JSONObject();
			openid.put("openid", jsons.getString(i));
			openid.put("lang", "zh-CN");
			ar.add(openid);
		}
		JSONObject user_list=new JSONObject();
		user_list.put("user_list", ar);
		url="https://api.weixin.qq.com/cgi-bin/user/info/batchget?access_token="+getAccessToken(com_id);
		String msg=postData(url, user_list);
		JSONObject userinfo=JSONObject.fromObject(msg);
		return userinfo;
	}
	/**
	 * 通过客服接口向用户发送图文消息,客户通过公众号进入系统48小时之内才能发送成功
	 * @param com_id
	 * @param touser 消息接收者oliZuuMECVVG62gJYHyyyUhqrtjM
	 * @param articles 图文消息json数组
	 * articles.add(JSONObject);
	 * @param title 消息标题
	 * @param description 消息描述 
	 * @param url 消息跳转地址
	 * @param picurl 图片地址
	 * @return 发送结果状态json  45015-回复时间超过限制(客户进入系统间隔超过48小时)
	 */
	public JSONObject customSendNews(String com_id,String touser,JSONArray articles) {
		String url="https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="+getAccessToken(com_id);
		String weixinServiceUrlPrefix=ConfigFile.urlPrefix+"/login/getWeixinCode.do?url=";
		for (Iterator<JSONObject> iterator = articles.iterator(); iterator.hasNext();) {
			JSONObject ar = iterator.next();
			if(!ar.getString("url").contains("getWeixinCode")){
				ar.put("url", weixinServiceUrlPrefix+ar.getString("url")+"&weixinType=0");
			}
		}
		JSONObject json=new JSONObject();
		json.put("touser", touser);
		json.put("msgtype", "news");
		JSONObject news=new JSONObject();
		news.put("articles", articles);
		json.put("news", news);
		String msg=postData(url, json);
		if (StringUtils.isNotBlank(msg)) {
			JSONObject ret=JSONObject.fromObject(msg);
			if(ret.has("errcode")){
				boolean b=delAccessTokenFile(ret, com_id);
				if(b){
					msg=postData(url, json);
					ret=JSONObject.fromObject(msg);
				}
			}
			return ret;
		}
		return null;
	}
	private boolean delAccessTokenFile(JSONObject ret,String com_id) {
		if(ret.getString("errcode").equals("42001")||ret.getString("errcode").equals("40001")){
			File file=getWeixinParamFile(com_id, "access_token_service");
			if (file.exists()&&file.isFile()) {
				file.delete();
				return true;
			}
		}
		return false;
	}
	public static void main(String[] args) {
		WeiXinServiceUtil ws=new WeiXinServiceUtil();
		JSONArray jsons=ws.get_all_private_template("001Y10");
		for (int i = 0; i < jsons.size(); i++) {
			JSONObject json=jsons.getJSONObject(i);
			String[] ss=json.getString("content").split("\\\\n");
			for (String s : ss) {
				if (StringUtils.isNotBlank(s)) {
					System.out.println(s);
				}
			} 
		}
		
////		JSONObject msg=ws.getUserInfoList("001");
//		JSONArray articles=new JSONArray();
//		JSONObject jn=new JSONObject();
//		jn.put("title", "多图文客服消息发送测试001");
//		jn.put("description", "图文消息通过客户接口发送测试");
//		jn.put("url",  "http://www.pulledup.cn");
//		jn.put("picurl", "http://www.pulledup.cn/img/indexCarouseBottom0320170204.jpg");
//		articles.add(jn);
//		jn=new JSONObject();
//		jn.put("title", "多图文客服消息发送测试002");
//		jn.put("description", "图文消息通过客户接口发送测试002");
//		jn.put("url",  "http://www.pulledup.cn");
//		jn.put("picurl", "http://www.pulledup.cn/img/indexCarouseBottom0220170204.jpg");
//		articles.add(jn);
//		jn=new JSONObject();
//		jn.put("title", "多图文客服消息发送测试003");
//		jn.put("description", "图文消息通过客户接口发送测试003");
//		jn.put("url",  "http://www.pulledup.cn");
//		jn.put("picurl", "http://www.pulledup.cn/img/indexCarouseBottom0320170204.jpg");
//		articles.add(jn);
//		JSONObject msg=ws.customSendNews("001","oliZuuMECVVG62gJYHyyyUhqrtjM",articles);
//		System.out.println(msg);
//		JSONObject msg=ws.customSendNews("001","oliZuuCXUAQ_UXEfdVuX16eYlq2s",articles);
//		System.out.println(msg);
//		msg=ws.customSendNews("001","oliZuuGUrJ_yc7VwMeWNEAHX4Sgw",articles);
//		System.out.println(msg);
//		JSONObject msg=ws.customSendNews("001","oliZuuJXpWBAvpfzQjYPJqC0yKVE",articles);//
//		System.out.println(msg);
//		msg=ws.customSendNews("001","oliZuuCXUAQ_UXEfdVuX16eYlq2s",articles);
//		System.out.println(msg);http://www.pulledup.cn/login/getWeixinCode.do?url=http://www.pulledup.cn?weixinType=service
//		JSONObject msg=ws.customSendNews("001","oliZuuM6kOX7KXL32EMGOKr1--e4",articles);
//		System.out.println(msg);
		//{"errcode":40001,"errmsg":"invalid credential, access_token is invalid or not latest hint: [Ri7P_a0770rsz7!]"}
		//{"errcode":45015,"errmsg":"response out of time limit or subscription is canceled hint: [AsUsIA0800ge25]"}
		//{"errcode":0,"errmsg":"ok"}
	}
	
}
