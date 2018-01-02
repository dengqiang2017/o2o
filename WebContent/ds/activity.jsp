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
<title>近期活动-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
#title{
margin: 2px; 
}
/* 小屏幕（平板，大于等于 768px） */
@media ( max-width : 768px) {
	#hdimg{
		width: 100%;
		height: 120px
	}
}
/* 小屏幕（平板，大于等于 768px） */
@media ( min-width : 768px) {
	#hdimg{
		width: 100%;
		height: 120px
	}
}
/* 中等屏幕（桌面显示器，大于等于 992px） */
@media ( min-width : 992px) {
	#hdimg{
		width: 100%;
		height: 200px
	}
}

/* 大屏幕（大桌面显示器，大于等于 1200px） */
@media ( min-width : 1200px) {
	#hdimg{
		width: 100%;
		height: 200px
	} 
}
</style>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
				<a onclick="javascript:history.back();" class="header_left">返回</a>
				近期活动
			</div>
</nav>
	<div class="container">
			<div class="contant" style="margin-top: 50px;"></div>
			<div id="imgitem" style="display: none;">
				<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4" style="border-bottom:1px solid aqua;margin-top: 5px;padding-bottom: 5px;">
					<div id="time" style="color: red;font-size: 14px;font-weight: bold;margin-top: 5px;"></div>
					<div id="title"></div>
					<img id="hdimg">
				</div>
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
<script type="text/javascript" src="js/activity.js${requestScope.ver}"></script>
</body>
</html>