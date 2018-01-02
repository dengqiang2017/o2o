<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="../pc/css/register.css?ver=001">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
    <script type="text/javascript" src="../js/common.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../pc/js/password.js?ver=004"></script>
    <script type="text/javascript" src="../pc/js/register.js?ver=004"></script>
    	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js"></script>
</head>
<body>
    <div class="container">
        <div class="header">
            巴中天仁钢化
        </div>
        <div class="main">
            <div class="input-group">
                <input type="hidden" value="customer" id="regType">
                <input type="hidden" value="customer" id="erweima">
                <div class="label"><img src="../pc/images/注册界面_03.jpg" alt=""></div>
                <div class="input">
                    <input type="text" placeholder="请输入手机号" name="user_id" maxlength="11" data-number="num">
                </div>
            </div>
            <input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
            <div class="input-group">
                <div class="label"><img src="../pc/images/注册界面_07.jpg" alt=""></div>
                <div class="input">
                    <input type="text" placeholder="输入验证码" maxlength="6" name="verificationCode" disabled="disabled">
                </div>
                <div id="get_code" class="get_carge">
                    获取验证码
                </div>
            </div>
            <div class="input-group">
                <div class="label"><img src="../pc/images/注册界面_11.jpg" alt=""></div>
                <div class="input">
                    <input type="password" placeholder="请输入6-12位字符密码" name="user_password" maxlength="20">
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
                    <div class="pull-right"><a href="#" style="color:#fff;">忘记密码?</a></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-9 col-sm-offset-3 lr-tips">
                    <span class="tips-red" id="msg"></span>
                </div>
                <span class="tips" id="msg"></span>
                <div class="signup-btn01" id="registerBtn">注册</div>
                <div class="signup-btn02" onclick="window.location.href='../pc/login.html';">返回</div>
            </div>
        </div>
        <div style="height: 70px"></div>
    </div>
<div class="logo_container"></div>
<script type="text/javascript">
<!--
weixinShare.init(sharePrex+'养殖户注册',sharePrex+'养殖户注册'); 
    $('input').bind('focus',function(){
        $('.logo_container').css('position','static');
    }).bind('blur',function(){
        $('.logo_container').css({'position':'fixed','bottom':'0'});
    });
//-->
</script>
</body>
</html>