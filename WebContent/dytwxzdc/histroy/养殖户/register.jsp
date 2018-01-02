<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-养殖户注册</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/register.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
	<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/password.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/register.js${requestScope.ver}"></script>
</head>
<body>
<div class="header">
    <a href="../pc/login.html">返回</a>注册
</div>
<div class="center">
		<input type="hidden" value="customer" id="regType">
		<input type="hidden" value="customer" id="erweima">
        <div class="center01" style="background-color: #E8E8E8;">
            <label><img class="img-responsive center-block" src="images/phone.png"></label>
            <input type="tel" class="form-control" placeholder="请输入手机号" name="user_id" maxlength="11" data-number="num">
            <div class="clearfix"></div>
        </div>
        <input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
    <div class="center02">
        <div class="pull-left">
            <input type="text" class="form-control" placeholder="输入验证码" maxlength="6" name="verificationCode" data-number="zimu">
        </div>
        <div class="pull-right">
            <button type="button" class="btn btn-success">获取验证码</button>
        </div>
        <div class="clearfix"></div>
    </div>
    <div class="center03" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="images/l.png"></label>
        <input type="password" class="form-control" placeholder="请输入密码" name="user_password" maxlength="20">
        <div class="clearfix"></div>
    </div>
    <div class="center04" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="images/l.png"></label>
        <input type="password" class="form-control" placeholder="确认密码" name="confirmPwd" maxlength="20">
        <div class="clearfix"></div>
    </div>
	<div class="from-group" style="display: none;">
		<input type="checkbox" id="check" checked="checked">
		<label for="check">我已阅读并同意<a href="#" style="color:#fff; text-decoration:underline;">《<span class="yysname"></span>用户协议》</a></label>
	</div>
	<span class="tips" id="msg"></span>
    <a id="registerBtn" class="btn btn-block btn01">确认注册</a>
</div>
<script type="text/javascript">
<!--
type="养殖户";
upper_customer_id="CS1C001";
//-->
</script>
</body>
</html>