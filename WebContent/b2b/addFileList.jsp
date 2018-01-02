<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.getVer(request); 
%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>我的订单附件</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.col-xs-12{border: 1px solid aqua;font-size: 18px;padding: 5px;background-color: white;}
@media (max-width: 759px) {
.form-inline input{width:135px;display: inline-block;}
}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<span id="customer_id" style="display:none;">${sessionScope.customerInfo.upper_customer_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header-phone">
	<a href="personal_center.jsp" class="header_left">返回</a>我的订单附件
	<div class="pull-right">
		<a id="upload-btn" class="btn btn-success">增加订单附件
		<input type="file" name="imgFile" id="imgFile" onchange="fileLoad(this);">
		<input type="hidden" id="filepath">
		</a>
	</div>
</div>
</nav>
<div class="container" style="margin-top: 50px;">
<p id=iphone style="display: none;color: red;">提示:苹果系统原因只能上传图片</p>
	<div class="form-inline">
	<input type="date" id="d4311"
    class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" name="beginDate">
    <input type="date" id="d4312" class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" name="endDate">
    <button type="button" class="btn btn-success find">查询</button>
	</div>
		<div id="list"></div>
		<div id="item" style="display: none;">
		  <div class="col-xs-12 col-sm-6 col-md-4">
			<div class="pull-left">
			<p>上传时间:<span id="time"></span></p>
			</div>
			<div class="pull-right">
			<a target="_blank" class="btn btn-info">查看附件</a>
			</div>
			</div>
		</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/customer.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/addFileList.js${requestScope.ver}"></script>
</body>
</html>