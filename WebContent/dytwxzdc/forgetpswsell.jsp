<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-养殖户修改密码</title>
    <link rel="stylesheet" href="../pc/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/changesell.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
</head>
<body>
<div style="width: 1px;height: 1px;">
    <img class="img-responsive center" src="../pc/images/logo.jpg">
</div>
<div class="header">
    <a onclick="javascript:history.back();">返回</a>修改密码
</div>
<div class="center">
    <div class="center01" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="../pc/images/phone.png"></label>
        <input type="text" class="form-control" placeholder="请输入手机号" name="user_id" maxlength="11" data-number="num" id="mobileNum">
        <div class="clearfix"></div>
    </div>
    <input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
    <div class="center02">
        <div class="pull-left">
            <input type="text" class="form-control" placeholder="输入验证码" maxlength="6" name="verificationCode" id="verifyCode">
        </div>
        <div class="pull-right">
            <button type="button" class="btn btn-success" id="get_code">获取验证码</button>
        </div>
        <div class="clearfix"></div>
    </div>
    <div class="center03" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="../pc/images/l.png"></label>
        <input type="password" class="form-control" placeholder="请输入密码" name="user_password" maxlength="20" id="new_pwd">
        <div class="clearfix"></div>
    </div>
    <div class="center04" style="background-color: #E8E8E8;">
        <label><img class="img-responsive center-block" src="../pc/images/l.png"></label>
        <input type="password" class="form-control" placeholder="确认密码" name="confirmPwd" maxlength="20" id="re_new_pwd">
        <div class="clearfix"></div>
    </div>
    <span class="tips" id="errorMsg"></span>
    <a id="submit" type="button" class="btn btn-block btn01">确认修改</a>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript" src="../pc/js/forgetpsw.js"></script>
</body>
</html>