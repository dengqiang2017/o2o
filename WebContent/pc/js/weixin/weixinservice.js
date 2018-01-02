/**
 * 微信服务号工具类
 */
var weixinservice={
		code:"",
		com_id:"001",
		init:function(func){
			//1.从cookie在获取openid
			weixinservice.code=getQueryString("code");
			var com_id=getQueryString("com_id");
			if(com_id){
				weixinservice.com_id=com_id;
			}
			if(weixinservice.code){
				weixinservice.getOpenIdAndAccess_token();
				return true;
			}
			var openid=$.cookie("openid");//从cookie中获取openid
			var access_token=$.cookie("access_token");//从cookie中获取openid
			if (openid&&access_token) {
				weixinservice.getUserInfo(openid,access_token);
				return openid;
			}else{
				var refresh_token=$.cookie("refresh_token");
				if(refresh_token){//成功从服务器获取
					weixinservice.refreshToken(refresh_token);
				}else{
					weixinservice.getCodeUrl();
				}
			}
		},getCodeUrl:function(){
			window.location.href="../login/getWeixinCode.do?com_id="+
			weixinservice.com_id+"&state="+weixinservice.com_id
			+"&url="+window.location.href;
		},getOpenIdAndAccess_token:function(){
			$.get("../login/getOpenIdAndAccess_token.do",{
				"com_id":weixinservice.com_id,
				"code":weixinservice.code
			},function(data){
				if (data.access_token) {
					$.cookie("openid",data.openid,{"path":"/"});
					$.cookie("access_token",data.access_token,{"path":"/"});
					$.cookie("refresh_token",data.refresh_token,{"path":"/"});
					weixinservice.getUserInfo(data.openid,data.access_token);
				}
			});
			
		},getUserInfo:function(openid,access_token){
			$.get("../login/getUserInfo.do",{
				"openid":openid,
				"access_token":access_token
			},function(datao){
				//返回客户微信信息在界面上显示
				$(".headimg").attr("src",datao.headimgurl);
				$(".headname").html("您好:"+datao.nickname);
			});
		},refreshToken:function(refresh_token){
			$.get("../login/refresh_token.do",{
				 "com_id":weixinservice.com_id,
				 "refresh_token":refresh_token
			 },function(data){
				 if (data.access_token) {
					$.cookie("openid",data.openid,{"path":"/"});
					$.cookie("access_token",data.access_token,{"path":"/"});
					weixinservice.getUserInfo(data.openid,data.access_token);
				}else{
					weixinservice.getCodeUrl();
				}
			 });
		}
		
}
$(function(){
	if(is_weixin()){
		weixinservice.init();
	}
});