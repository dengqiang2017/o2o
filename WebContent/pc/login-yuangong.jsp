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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="keywords" content="${requestScope.systemName},员工登录">
    <meta name="description" content="${requestScope.systemName}-员工登录">
    <title>员工登录-${requestScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
    <link rel="stylesheet" href="../pcxy/css/lr.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
     <style type="text/css">
          .jumbotron{
            padding: 30px 0 !important;
          }
          .btn-style1 {
            padding: 8px 16px !important;
          }
          @media (max-width: 770px) {
            body{
              padding-top: 0;
            }
            .dl{
              width: 100%;
            }
          }
          @media (min-width: 770px) {
            body{
              padding-top: 55px;
            }
            .dl{
              width: 50%;
              float: right;
            }
          }
     </style>
  </head>
  <body>
    <div class="bg"></div>
    <div class="jumbotron myjumbotron">
      <div class="container">
        <div class="col-sm-4">
          <div class="login-img"><img src="image/logo.jpg${requestScope.ver}" alt="">
            <h3>${requestScope.systemName}</h3>
          </div>
        </div>
        
        <div class="col-sm-8">
          <h2 class="col-sm-offset-3">员工登录</h2>
          <form action='#' class='form-horizontal' role='form'>
            <div class="form-group">
              <label class="col-sm-3 control-label">运营商</label>
              <div class="col-sm-9">
                <select class="form-control"> 
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">日期</label>
              <div class="col-sm-9">
                <input type="text" class="form-control"  id="time" readonly="readonly">
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">用户名</label>
              <div class="col-sm-9">
                <input class="form-control" placeholder="请输入您的手机号" type="tel" id="username"  maxlength="11" data-number="num">
              </div>
            </div>
            <div class="form-group">
              <label class="col-sm-3 control-label">密码</label>
              <div class="col-sm-9">
                <input type="password" class="form-control" placeholder="请输入密码" id="pwd" placeholder="请输入密码"  maxlength="20">
              </div>
            </div>
            <div class="row">
              <div class="col-sm-9 col-sm-offset-3 lr-tips">
                <div class="pull-left"><span class="tips-red"></span></div>
                <div class="pull-right"><a href="../login/forgetpsw.do?type=1">忘记密码?</a></div>
              </div>
            </div>
          </form>
          <div class="dl" style="text-align:center;">
            <div class="col-xs-4">
            <a class="btn btn-style1 center-block" id="loginEmployee" role="button">登录</a>
            </div>
            <div class="col-xs-4">
            <a class="btn btn-style1 center-block" href="../login/register.do?type=Empl" role="button">注册</a>
              </div>
            <div class="col-xs-4">
            <a class="btn btn-style1 center-block" href="index.html" role="button">返回首页</a>
              </div>
          </div>
        </div>
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
$(function(){
	if(is_weixin()&&weixinAutoLogin){
		var url=common.replaceAll(window.location.search,"\\|_", "&");
		url=common.replaceAll(url,"\\|", "&");
		var com_id=common.getQueryString("com_id",url);
		if(com_id=="null"){
			logininit();
		}else{
			weixinAutoLogin.init("员工",com_id,function(id){
				if(id){
					window.location.href="../employee.do";
				}else{
					logininit();
				}
			});
		}
	}else{
		logininit();
	}
	function logininit(){
		login.init("loginEmployee","../employee/login.do","../employee.do","employee");
	}
		var imgsrc=document.getElementsByTagName("img")[0].src;
		weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-员工登录",imgsrc);
});
//-->
</script>
  </body>
</html>