<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-管理方注册</title>
    <link rel="stylesheet" href="../pc/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/registermanage.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
</head>
<body>
<div style="width: 1px;height: 1px;">
    <img class="img-responsive center" src="../pc/images/logo.jpg" id="shareLogo">
</div>
<div class="header">
    <a href="../pc/login-yuangong.html${requestScope.ver}" >返回</a>注册
</div>
        <input type="hidden" value="employee" id="regType">
        <input type="hidden" value="employee" id="erweima">
<div class="center">
        <div class="center01" style="background-color: #E8E8E8;">
            <label><img class="img-responsive center-block" src="../pc/images/phone.png"></label>
            <input type="tel" class="form-control" placeholder="请输入手机号" name="user_id" maxlength="11" data-number="num">
            <div class="clearfix"></div>
        </div>
        <input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
    <div class="center02">
        <div class="pull-left">
            <input type="tel" class="form-control" placeholder="输入验证码" maxlength="6" name="verificationCode" data-number="zimu">
        </div>
        <div class="pull-right">
            <button type="button" class="btn btn-success" id="get_code">获取验证码</button>
        </div>
        <div class="clearfix"></div>
    </div>
    <div class="center03" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="../pc/images/l.png"></label>
        <input type="password" class="form-control" placeholder="请输入密码" name="user_password" maxlength="20">
        <div class="clearfix"></div>
    </div>
    <div class="center04" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="../pc/images/l.png"></label>
        <input type="password" class="form-control" placeholder="确认密码" name="confirmPwd" maxlength="20">
        <div class="clearfix"></div>
    </div>
    <div class="from-group" style="display: none;">
		<input type="checkbox" id="check" checked="checked">
		<label for="check">我已阅读并同意<a href="#" style="color:#fff; text-decoration:underline;">《<span class="yysname"></span>用户协议》</a></label>
	</div>
    <span class="tips-red" id="msg"></span>
    <a id="registerBtn" type="button" class="btn btn-block btn01">确认注册</a>
</div>

<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript" src="../pc/js/password.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/register.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js"></script>
<script type="text/javascript">
<!--
weixinShare.init(sharePrex+'员工注册',sharePrex+'员工注册');
//-->
</script>
</body>
</html>