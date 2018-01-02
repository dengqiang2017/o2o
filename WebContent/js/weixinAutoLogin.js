if($("html").html().indexOf("public.js")<0){
$("body").append("<script src='/js/public.js'><\/script>");
}
var weixinAutoLogin={
		/**
		 * 
		 * @param type 员工,客户,供应商
		 * @param com_id
		 * @param func
		 * @param login true-自动登录,false-只获取基本信息不自动登录
		 */
		init:function(type,com_id,func,login,upper_customer_id){
			if(is_weixin()&&weixinAutoLogin){
				if(!com_id){
					com_id="001";
				}
				if(!upper_customer_id){
					upper_customer_id="";
				}
				var code=common.getQueryString("code");
				if(code){
					var url=common.replaceAll(window.location.search,"\\|_", "&");
					var weixinType=common.getQueryString("weixinType",url);
					var state=common.getQueryString("state",url);
					if("qiye"==weixinType||state=="qiye"){
						weixinAutoLogin.weixinQiye(type,code,com_id,func,login,upper_customer_id);
					}else{
						weixinAutoLogin.weixinService(type,code,com_id,func,login,upper_customer_id);
					}
				}else{
					var state=common.getQueryString("state");
					if(state){
						state="&state="+state;
					}else{
						state="";
					}
					window.location.href="/login/getWeixinCodeUrl.do?url="+common.replaceAll(window.location.href,"&","|_")+state+"&com_id="+com_id;
				}
			}
		},getUserInfo:function(){
			var openid=localStorage.getItem("openid");
			var access_token=localStorage.getItem("access_token");
			$.get("../login/getUserInfo.do",{
			"openid":openid,
			"access_token":access_token
		},function(datao){
			//返回客户微信信息在界面上显示
			$(".headimg").attr("src",datao.headimgurl);
			$(".headname").html("您好:"+datao.nickname);
		});
		},weixinService:function(type,code,com_id,func,login,upper_customer_id){
			pop_up_box.dataHandling("自动登录中...");
			$.get("../login/getOpenIdAndAccess_token.do",{//获取用户的openid//并自动登录
				"com_id":com_id,
				"type":type,
				"login":login,
				"upper_customer_id":upper_customer_id,
				"code":code
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.openid) {
					localStorage.setItem("openid",data.openid);
				}else{
					pop_up_box.toast("自动登录失败!",2000);
				}
				if(func){
					func(data.login,data.openid);
				}
			});
		},weixinQiye:function(type,code,com_id,func,login,upper_customer_id){
			pop_up_box.dataHandling("自动登录中...");
			$.get("../login/getuserinfo.do",{//获取用户的UserId//并自动登录
				"com_id":com_id,
				"type":type,
				"login":login,
				"upper_customer_id":upper_customer_id,
				"code":code
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.UserId) {
					localStorage.setItem("UserId",data.UserId);
				}else{
					pop_up_box.toast("自动登录失败!",2000);
				}
				if(func){
					func(data.login,data.UserId);
				}
			});
		}
}