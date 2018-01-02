<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache" >
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
    <script src="../js/o2od.js?ver=001"></script>
    <script src="../js_lib/jquery-migrate-1.1.0.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/employee/planReport.js?ver=002"></script>
    
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售计划报表</li>
	</ol>
	<div class="header-title">销售计划报表
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-head">
					<ul class="nav nav-tabs" style="margin-top:10px;">
					    <li class="active"><a>日计划</a></li>
					    <li><a>周计划</a></li>
					    <li><a>月计划</a></li>
					</ul>
		  	</div>
		  	<input type="hidden" value="${sessionScope.userInfo.personnel.headship}" id="employeetype">
				<div class="box-body">
					<!-- 日计划 -->
					<div class="tabs-content">	
						<ul class="navsubtabs">
						  <li role="presentation" class="active"><a>分客户</a></li>
						  <li role="presentation"><a>不分客户</a></li>
						  <li role="presentation" style="display: none;"><a>录入Oracle</a></li>
						  <li role="presentation"><a>分产品</a></li>
						</ul>
<!-- 						01 -->
						<div class="subtabs-content">
							<%@include file="planReport/dayclient.jsp" %>							
						</div>
<!-- 						02 -->
						<div class="subtabs-content">
							<%@include file="planReport/dayNoClient.jsp" %>
						</div>

						<div class="subtabs-content">
							<%@include file="planReport/dayoracle.jsp" %>
						</div>
<!-- 						分产品统计 -->
						<div class="subtabs-content">
							<%@include file="planReport/dayproduct.jsp" %>
						</div>
					</div>

					<!-- 周计划 -->
					<div class="tabs-content">
						<ul class="navsubtabs">
						  <li role="presentation" class="active"><a>分客户</a></li>
						  <li role="presentation" style="display: none;"><a>需导入Oracle</a></li>
						  <li role="presentation"><a>分产品</a></li>
						</ul>
<!-- 						03 -->
						<div class="subtabs-content">
							<%@include file="planReport/weekclient.jsp" %>
						</div>
<!-- 						04 -->
					<div class="subtabs-content" style="display: block;">
						<%@include file="planReport/weekoracle.jsp" %>
						</div>
<!-- 					分产品 -->
					<div class="subtabs-content" style="display: block;">
						<%@include file="planReport/weekproduct.jsp" %>
						</div>
					</div>

					<!-- 月计划 -->
					<div class="tabs-content">
						<ul class="navsubtabs">
						  <li role="presentation" class="active"><a>分客户</a></li>
						  <li role="presentation" style="display: none;"><a>需导入Oracle</a></li>
						  <li role="presentation"><a>分品种</a></li>
						  <li role="presentation"><a>分客户品种</a></li>
						</ul>
						
						<div class="subtabs-content">
							<%@include file="planReport/mothclient.jsp" %>
						</div>
						<div class="subtabs-content">
							<%@include file="planReport/mothoracle.jsp" %>
						</div>
						<div class="subtabs-content">
							<%@include file="planReport/mothproduct.jsp" %>
						</div>
						<div class="subtabs-content">
							<%@include file="planReport/mothclientproduct.jsp" %>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	     员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
</div>
</body>
</html>

