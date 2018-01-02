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
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/signup.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
</head>
<body> 
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="image/logo.png" alt="">
			</div>
			<div style="text-align: center;">客户登录</div>
		</div>
		<div class="main">
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<input type="text" name="user_id" id="username" placeholder="请输入用户名"  maxlength="11" data-number="num">
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input type="password" placeholder="输入密码"  name="user_password" id="pwd" maxlength="20">
				</div>
			</div>
			<a href="forgetpsw.html?type=2" style="display: block; font-size:14px; margin-left:10px; color:#646464;">忘记密码</a>
			<span class="tips"></span>
			<div class="signup-btn" id="loginKefu">登录</div>
			<div class="signup-btn-light" onclick="window.location.href='../login/register.do';">没有账号，立即注册</div>
			<div class="signup-btn-light" onclick="window.location.href='index.html';">返回首页</div>
		</div>
	</div>
<div id="modal_smsSelect" style="display: none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<h4 class="modal-title">请点选登录运营商</h4>
			</div>
			<div id="item" style="display: none;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;border: 1px solid #01B;">
					<label class="radio-inline">
					</label>
					<span id=comid></span>
				</div>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				
			</div>
		</div>
	</div>
</div>
</div>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/loginEwm.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
$(function(){
	weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-客户登录");
	login.init("loginKefu","../customer/login.do","../customer.do","customer");
});
//-->
</script>
</body>
</html>