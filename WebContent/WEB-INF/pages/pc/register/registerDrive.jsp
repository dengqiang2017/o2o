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
<meta name="keywords" content="${requestScope.systemName},司机注册">
<meta name="description" content="${requestScope.systemName}-司机注册">
<title>司机注册-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/signup.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="../pc/image/logo.png${requestScope.ver}" alt="" id="shareLogo">
			</div>
			<div style="text-align: center;">司机注册</div>
		</div>
		<div class="main"> 
			<div class="input-group">
				<input type="hidden" value="drive" id="regType">
				<input type="hidden" value="drive" id="erweima">
				<select class="form-control" style="display: none;"></select>
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<input type="text" placeholder="请输入您的手机号" name="user_id" maxlength="11" data-number="num">
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input type="password" placeholder="6-16位，由数字、字母和标点符号组成" name="user_password" maxlength="20">
				</div>
			</div> 
			<input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp03.png" alt=""></div>
				<div class="input">
					<input type="text"  placeholder="输入验证码,有效期2分钟" maxlength="6" name="verificationCode">
					<button type="button" class="btn" id="get_code" style="cursor: pointer;">获取验证码</button>
				</div>
			</div>
			<div class="row" style="display: none;">
				<div class="col-sm-9 col-sm-offset-3">
					<div class="pull-left form-group">
						<div class="from-group">
							<input type="checkbox" id="check" checked="checked">
							<label for="check">我已阅读并同意<a href="#" style="color:#fff; text-decoration:underline;">《<span class="yysname"></span>用户协议》</a></label>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-9 col-sm-offset-3 lr-tips">
					<span class="tips-red" id="msg"></span>
				</div>
				<span class="tips" id="msg"></span>
				<div class="signup-btn" id="registerBtn">注册</div>
				<div class="signup-btn" onclick="window.location.href='../index.html';">返回首页</div>
			</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/password.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/register.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-司机注册");
//-->
</script>
</body>
</html>