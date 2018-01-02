<%@page import="com.qianying.controller.BaseController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BaseController.getVer(request);
BaseController.setDescriptionAndKeywords(request);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="${requestScope.systemName},客户登录">
<meta name="description" content="${requestScope.systemName}-客户登录">
<title>客户登录-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/signup.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="image/logo.png${requestScope.ver}" alt="">
			</div>
			<div style="text-align: center;">客户登录</div>
		</div>
		<div class="main">
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<input type="tel" name="user_id" id="username" placeholder="请输入用户名"  maxlength="11" data-number="num">
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input type="password" placeholder="输入密码"  name="user_password" id="pwd" maxlength="20">
				</div>
			</div>
			<a href="../login/forgetpsw.do?type=2" style="display: block; font-size:14px; margin-left:10px; color:#646464;">忘记密码</a>
			<span class="tips"></span>
			<div class="signup-btn" id="loginKefu">登录</div>
			<div class="signup-btn-light"><a href="../login/register.do" style="float: left;width: 100%;">没有账号，立即注册</a></div>
			<div class="signup-btn-light"><a href="index.html" id="index" style="float: left;width: 100%;">返回首页</a></div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/login.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
	var code=common.getQueryString("code");
	function autologin(){
		var url=common.replaceAll(window.location.search,"\\|_", "&");
		var com_id=common.getQueryString("com_id",url);
		weixinAutoLogin.init("客户",com_id,function(id){
			if(id){
				var bu=$.cookie("backurl");
				if(!bu){
					bu=localStorage.getItem("backurl");
				}
				if(!bu){
					if(com_id=="001Y10"){
						bu="/ds/personal_center.jsp";
					}else{
						bu="/b2c/personal_center.jsp";
					}
				}
				window.location.href=bu;
			}else{
				sdlogin();
			}
		});
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
		sdlogin();
	}
	function sdlogin(){
		var url=common.replaceAll(window.location.search,"\\|_", "&");
		var com_id=common.getQueryString("com_id",url);
			var imgsrc=document.getElementsByTagName("img")[0].src;
			weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-客户登录",imgsrc);
			if(window.location.href.indexOf("cdsydq")>0){
				login.init("loginKefu","../customer/login.do","../saiyu/personalCenter.do","customer");
			}else{
				var bu="";
				if(com_id=="001Y10"){
					bu="/ds/personal_center.jsp";
				}else{
					bu="/b2c/personal_center.jsp";
				}
				login.init("loginKefu","../customer/login.do",bu,"customer");
			} 
	}
//-->
</script>
</body>
</html>