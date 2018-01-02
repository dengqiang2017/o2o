var xzdclogin={
		init:function(upper_customer_id,typeName){
			var code=getQueryString("code");
			function autologin(){
				var url=replaceAll(window.location.search,"\\|_", "&");
				var com_id=getQueryString("com_id",url);
				weixinAutoLogin.init("客户",com_id,function(id){
					if(id){
						var bu=$.cookie("backurl");
						if(!bu){
							bu=localStorage.getItem("backurl");
						}
						if(!bu){
							bu="../customer.do";
						}
						window.location.href=bu;
					}else{
						sdlogin();
					}
				},true,"CS1C002");
			}
			if(is_weixin()&&weixinAutoLogin){
				if(code==""){
					if(confirm("是否进行自动登录?")){
						autologin();
					}else{
						sdlogin();
					}
				}else{
					autologin();
				}
			}else{
				$(function(){
					var imgsrc=document.getElementsByTagName("img")[0].src;
					weixinShare.init(sharePrex+typeName,sharePrex+typeName,imgsrc);
					login.init("loginKefu","../customer/login.do","../pre/operate.do","customer");
				});
			}
		}
}