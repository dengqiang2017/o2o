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
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta http-equiv="expires" content="0">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>领取优惠券-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.row>div {
	margin: 5px;
}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
	<div class="header">
	 <a onclick="javascript:history.back();" class="header_left">返回</a>
		领取优惠券
	</div>
</nav>
<div class="container">
        <div class="contant" style="margin-top: 50px;">
		<div id="list">
		</div>
		<div id="item" style="display: none;">
		<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 item" style="height: 80px; border: 1px solid #F00;">
				<div class="col-xs-3 col-md-3 col-lg-4" style="height: 100%; background-color: #337ab7; color: white; padding-top: 5px;margin-left: -5px;">
					<div style="text-align: center;color: white;">
						￥<span style="font-size: 20px;color: white;" id="f_amount">5</span>
					</div>
					<div style="font-size: 10px; padding-top: 5px;color: white;">
						满<span id="up_amount" style="color: white;">100</span>元可用
					</div>
				</div>
				<div class="col-xs-9 col-md-9 col-lg-8">
					<div style="padding-top: 10px;font-size: 12px;width: 109%;"id="type_name"></div>
					<div id="type_id" style="display: none;"></div>
					<div style="padding-top: 10px;width: 109%;">
						<span style="font-size: 10px;">
						<span id="begin_use_date" style="font-size: 10px;">2017.04.05</span>~
						<span id="end_use_date" style="font-size: 10px;">2017.05.05</span>
						</span>
						<button class="btn btn-info btn-xs pull-right getcoupon">领取</button>
					</div>
				</div>
				<div style="display: none;" id="ivt_oper_listing">优惠券编号</div>
			</div>
			</div>
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<!-- <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script> -->
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/coupon.js${requestScope.ver}"></script>
</body>
</html>