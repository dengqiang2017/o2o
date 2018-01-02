<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="U-XA-Compatible" content="IE-edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>忘记密码</title>
	<link rel="stylesheet" href="../pcxy/css/signup.css${requestScope.ver}">
	<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="../pc/image/logo.png" alt="">
			</div>
		</div>
		<div class="main">
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<input id="mobileNum" type="tel" placeholder="请输入您的手机号" name="user_id" maxlength="11" data-number="num">
					<div class="btn" style="background: none; color:#555;">手机号</div>
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input id="new_pwd" type="password" placeholder="6-16位，由数字、字母和标点符号组成" name="user_id" maxlength="16">
					<div class="btn" style="background: none; color:#555;">新密码</div>
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input id="re_new_pwd" type="password" placeholder="请重复输入密码" name="confirmPwd" maxlength="16">
					<div class="btn" style="background: none; color:#555;">重复密码</div>
				</div>
			</div>
			<input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp03.png" alt=""></div>
				<div class="input">
					<input id="verifyCode" maxlength="4" name="verificationCode" type="text" placeholder="输入验证码">
					<div id="get_code" class="btn">获取验证码</div>
				</div>
			</div>
			<span class="tips" id="errorMsg" style="display: block;"></span>
			<div class="signup-btn" id="submit">提交</div>
			<div class="signup-btn-light" onclick="history.go(-1);">返回</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/forgetpsw.js${requestScope.ver}"></script>
</body>
</html>