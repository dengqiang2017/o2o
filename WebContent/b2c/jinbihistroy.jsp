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
<title>我的金币-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.jinbidiv{
background-color: rgb(237,83,83);width: 100%;height: 80px;
}
.jinbidiv span,.jinbidiv p{
color: white;
}
ul li{margin-left: 5px;border-bottom: 1px solid aqua;height: 65px;}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a onclick="javascript:history.back();" class="header_left">返回</a>
	我的金币
</div>
</nav>
	<div class="container">
	<div class="" style="margin-top: 50px;">
				<div class="jinbidiv">
				<p style="padding-top: 10px;">
				<span style="font-size: 24px;margin-left: 20px;" id="totalJinbi"></span><span style="font-size: 12px;">个</span>
				</p>
				<p style="margin-left: 20px;font-size: 12px;">1000金币=10元,可在购物时直接抵用!</p>
				</div>
				<div>
				<div style="background-color: rgb(212,66,66);width: 100%;height: 40px;">
				<div style="width: 50%;float: left;text-align: center;height: 100%;"><img id="zhuan" style="height: 30px;margin-top: 5px;cursor: pointer;" alt="" src="images/zhuan.jpg"></div>
				<div style="width: 50%;float: left;text-align: center;height: 100%;"><img id="hua" style="height: 30px;margin-top: 5px;cursor: pointer;" alt="" src="images/hua.jpg"></div>
				</div>
				</div>
				<div>
				<div style="border-bottom: 1px solid aqua;padding-left: 5px;">收支明细</div>
				   <div style="overflow: auto;" id="list">
				   
				   </div>
				<div id="item" style="display: none;">
				   <div style="border-bottom: 1px solid aqua;">
				   <div class="pull-left">
				   <p id="source" style="margin-top: 5px;margin-left: 5px;font-size: 14px;">领金币</p>
				   <p id="time" style="font-size: 12px;margin-left: 5px;">2017-04-04 12:22:21</p>
				   </div>
				   <div id="num" class="pull-right" style="color: rgb(212,66,66);margin-right: 10px;">+9</div>
				   <div class="clearfix"></div>
				   </div>
				</div>
				</div>
			</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/jinbihistroy.js${requestScope.ver}"></script>
</body>
</html>