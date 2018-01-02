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
<title>领金币-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="css/index.css${requestScope.ver}">
<style type="text/css">
/* 小屏幕（平板，大于等于 768px） */
@media ( max-width : 768px) {
	.case_list_box img{
		width: 100%;
		height: 120px
	}
}
/* 小屏幕（平板，大于等于 768px） */
@media ( min-width : 768px) {
	.case_list_box img{
		width: 100%;
		height: 120px
	}
}
/* 中等屏幕（桌面显示器，大于等于 992px） */
@media ( min-width : 992px) {
	.case_list_box img{
		width: 100%;
		height: 200px
	}
}

/* 大屏幕（大桌面显示器，大于等于 1200px） */
@media ( min-width : 1200px) {
	.case_list_box img{
		width: 100%;
		height: 200px
	} 
}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
	<div class="header">
				<a href="index.jsp" class="header_left">返回</a>
				领金币
			</div>
</nav>
<div class="container">
		<div style="height:100px;background-color: rgb(255,201,14);margin-top: 50px;">
			<img src="images/jinbi.png" style="width: 60px; margin: 5px;">
			<span style="color: white;font-size: 18px;" id="totalJinbi">0</span><span  style="color: white;font-size: 14px;">金币</span>
			<button id="qiandao" type="button" class="btn btn-default btn-lg" style="float: right;margin-top: 25px;color: red;"></button>
	<!-- 					<span style="display:;">100金币=1元,满1000金币后可在下单时进行抵扣</span> -->
		</div>
		<div id="list" ></div>
		<div id="xptsitem" style="display: none;">
	       <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
	           <div class="case_list_box">
	               <a><img class="img-responsive"></a>
	               <div id="item_name" style="font-size: 14px;text-align: left;">地中海风</div>
	               <div style="text-align: left;"><span id="cost_name" style="color: #F00101;font-size: 14px;"></span>
	               <span class="wordT" id="price_display" style="text-decoration:line-through;font-size: 12px;">13999.00</span></div>
	           </div>
	       </div>
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/jinbi.js${requestScope.ver}"></script>
</body>
</html>