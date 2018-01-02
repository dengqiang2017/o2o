<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.getVer(request);
	BaseController.setDescriptionAndKeywords(request);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>头条-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
#title{
margin: 2px;float: left;width: 68%;
}
#img{
width: 30%;float: left;
}
@media (min-width: 768px) {
#title{font-size: 16px;}
#img{height: 80px;}
}
@media (min-width: 992px) {
#title{font-size: 14px;}#img{height: 60px;}
}
@media (min-width: 1200px) {
#title{font-size: 14px;}#img{height: 60px;}
}
</style>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a onclick="javascript:history.back();" class="header_left">返回</a>
	头条
</div>
</nav>
<div class="container">
<div id=list style="margin-top: 50px;"></div>
</div>
<div id="imgitem" style="display: none;">
<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4" style="border:1px solid aqua;margin-top: 5px;padding-bottom: 5px;">
		<div id="title"></div>
		<img id="img">
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="../release/js/urlParam.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/headlineNews.js${requestScope.ver}"></script>
</body>
</html>