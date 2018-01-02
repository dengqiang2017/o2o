<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	String send=BaseController.getPageNameByUrl(request,"productViewOrderChart.jsp");
	request.setAttribute("sendName", send);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">  
<meta http-equiv="expires" content="0">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css"><link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="../jqChart/css/jquery.jqChart.css">
<link rel="stylesheet" href="../jqChart/css/jquery.jqRangeSlider.css">
<style type="text/css">
.dropdown-menu{
cursor: pointer;
}
.liactive{
background-color: #FCB441;
color: white;
}
</style>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
<ol class="breadcrumb">
		<li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
		<li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
</nav>
<div class="container">
<div class="form-inline" style="margin-top: 70px;">
<div class="form-group"">
        <label>产品名称关键词</label>
    <input maxlength="30" id="searchKey" placeholder="请输入产品名称关键词" class="form-control input-sm" type="text" style="min-width: 200px;">
</div>
<div class="form-group" style="margin-top: 5px;">
        <label class="pull-left" style="margin-top: 5px;">产品类别</label>
        <div class="pull-left" style="width: 300px;">
    <span class="form-control input-sm" id="clsName"  style="width: 200px;float: left;"></span>
    <span class="form-control input-sm" id="clsId"  style="display: none;"></span>
    <button type="button" class="btn btn-default" id="clearClass" style="margin-left: 0px;float: left;">X</button>
    <button type="button" class="btn btn-info" id="selectClass" style="margin-left: -10px;float: left;">选择</button>
        </div>
        <div class="clearfix"></div>
</div>
<div class="form-group">
			<label for="">起始日期</label> <input id="d4311" class="form-control input-sm Wdate" 
			onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:true})" name="beginDate" type="text">
		</div>
<div class="form-group">
			<label for="">结束日期</label> <input id="d4312" class="form-control input-sm Wdate"
			 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:true})" name="endDate" type="text">
		</div>
		<button type="button" class="btn btn-primary find"><span class='glyphicon glyphicon-search'></span>&ensp;搜索</button>
</div>
<div class="col-md-6">
<div id="jqChart_zhu" style="width: 100%; height: 500px;margin: auto;margin-top: 30px">
</div>
</div>
<div class="col-md-6">
<div class="dropdown">
  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    统计方式
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
    <li><a data-type="10">天</a></li>
    <li><a data-type="7" class='liactive'>月</a></li>
    <li><a data-type="4">年</a></li>
  </ul>
</div>
<div id="salesCount" style="width: 100%; height: 500px;margin: auto;margin-top: 30px">
</div>
</div>
<div class="col-md-6">
<div id="salesCountLine" style="width: 100%; height: 500px;margin: auto;margin-top: 30px">
</div>
</div>
<div class="col-md-6">
<div id="salesCountPie" style="width: 100%; height: 500px;margin: auto;margin-top: 30px">
</div>
</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../jqChart/js/jquery.jqChart.min.js"></script>
<script type="text/javascript" src="../jqChart/js/jquery.jqRangeSlider.min.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js_chart/commReport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/provieworder.js${requestScope.ver}"></script>
</body>
</html>