<%@page import="com.qianying.controller.BaseController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BaseController.getVer(request);
BaseController.setDescriptionAndKeywords(request);
%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="keywords" content="${requestScope.systemName},员工注册">
    <meta name="description" content="${requestScope.systemName}-员工注册">
    <title>员工注册-${requestScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
    <link rel="stylesheet" href="../pcxy/css/lr.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
  </head>
  <body>
    <div class="bg"></div>
    <div class="jumbotron myjumbotron">
      <div class="container">
        <div class="col-sm-4">
          <div class="login-img"><img src="../pc/image/logo.png${requestScope.ver}" alt="" id="shareLogo">
            <h3 >${requestScope.systemName}</h3>
          </div>
        </div>
        <input type="hidden" value="employee" id="regType">
        <input type="hidden" value="employee" id="erweima">
        <div class="col-sm-8">
          <h2 class="col-sm-offset-3">员工注册</h2>
          <form action='#' class='form-horizontal' role='form'>
            <div class="form-group">
              <label class="col-sm-3 control-label">运营商</label>
              <div class="col-sm-9">
                <select class="form-control"> 
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">姓名</label>
              <div class="col-sm-9">
                <input type="text" class="form-control" placeholder="请输入您的姓名" name="corp_name" maxlength="20">
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">账号</label>
              <div class="col-sm-9">
                <input type="tel" class="form-control" placeholder="请输入您的手机号" name="user_id" maxlength="11" data-number="num">
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">密码</label>
              <div class="col-sm-9">
                <input type="password" class="form-control" placeholder="6-16位，由数字、字母和标点符号组成" name="user_password" maxlength="20">
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">重复密码</label>
              <div class="col-sm-9">
                <input type="password" class="form-control" placeholder="请重复输入密码" name="confirmPwd" maxlength="20">
              </div>
            </div>
            <input type="hidden" id="verifycode" value="${requestScope.verifyCode}">
            <div class="form-group">
              <label class="col-sm-3 control-label">验证码</label>
              <div class="col-sm-9">
                <div class="input-group">
                  <input type="text" class="form-control" maxlength="6"  placeholder="输入验证码,有效期2分钟" name="verificationCode">
                  <span class="input-group-btn">
                        <button class="btn btn-success"  id="get_code" type="button">获取验证码</button>
                    </span>
                </div>
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
                <div class="pull-right"><a href="#"style="color:#fff;">忘记密码?</a></div>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-9 col-sm-offset-3 lr-tips">
                <span class="tips-red" id="msg"></span>
              </div>
            </div>
          </form>
          <p style="text-align:center;">
            <a class="btn btn-style1" id="registerBtn">注册</a>
            <a class="btn btn-style1" href="../pc/login-yuangong.jsp">已有账号，立即登录</a>
            <a class="btn btn-style1" href="../index.html" role="button">返回首页</a>
          </p>
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
weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-员工注册");
//-->
</script>
  </body>
</html>