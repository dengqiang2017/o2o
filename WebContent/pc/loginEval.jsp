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
<meta name="keywords" content="${requestScope.systemName},电工登录">
<meta name="description" content="${requestScope.systemName}-电工登录">
<title>电工登录-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/signup.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="image/logo.png${requestScope.ver}" alt="">
			</div>
			<div style="text-align: center;">电工登录</div>
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
			<a href="forgetpsw.html?type=2" style="display: none; font-size:14px; margin-left:10px; color:#646464;">忘记密码</a>
			<span class="tips"></span>
			<div class="signup-btn" id="logindaingong">登录</div>
			<div class="signup-btn-light" onclick="window.location.href='../login/register.do?type=Eval';">没有账号，立即注册</div>
			<div class="signup-btn-light" onclick="window.location.href='index.html';">返回首页</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/login.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
$(function(){
	weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-电工登录");
	login.init("logindaingong","../saiyu/login.do?type=0","../saiyu/eval.do","eval");
});
//-->
</script>
</body>
</html>