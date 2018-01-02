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
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/customer/salePlanReport.js"></script>
    
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售计划报表</li>
	</ol>
	<div class="header-title">销售计划报表
		<a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-body">
					<div class="tabs-content">	
						<div class="subtabs-content">
						<input type="hidden" id="customer_id" value="${sessionScope.customerInfo.customer_id}">
							<%@include file="../employee/planReport/dayproduct.jsp" %>
						</div>
					</div>
 
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	    客户:${sessionScope.customerInfo.clerk_name} 
</div>
</body>
</html>

    