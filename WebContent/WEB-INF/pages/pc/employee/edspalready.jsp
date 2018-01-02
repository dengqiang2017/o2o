<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
 <%@include file="../res.jsp" %>
	<link rel="stylesheet" href="../pcxy/css/product.css">
   <script src="../js/o2od.js"></script>
   <script type="text/javascript" src="../pc/js/employee/OAFile.js${requestScope.ver}"></script>
   <script type="text/javascript" src="../pc/js/employee/spalread.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="myOA.do">我的协同</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>协同流程详细</li>
		</ol>
		<div class="header-title">协同流程详细
			<a href="myOA.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div> 
	</div>
<input type="hidden" id="clerk_id" value="${sessionScope.userInfo.personnel.clerk_id}">
<input type="hidden" id="com_id" value="${sessionScope.userInfo.com_id}">
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<div class="panel panel-danger">
					<div class="panel-heading">
						<span id="OA_what">标题:</span>
					</div>
					<div class="panel-body">
						<p id="OA_who">发起人:</p>
						<p id="store_date">发起时间:</p>
						<p id="content">内容:</p>
						<input type="hidden" id="ivt_oper_listing">
						<p id="sqfujian">附件:
							<span class="glyphicon glyphicon-save table-dld"></span>
			            	<span class="glyphicon glyphicon-search table-dld"></span>
			            </p>
			            <p id="iou">
							<a id="ioupath" target="_blank">查看欠条</a>
							<a href=""  id="accountStatement" target="_blank">查看对账单</a>
						</p>
					</div>
				</div>
			</div>
			<div class="box-body">
				<h5>审批记录</h5>
				<div class="alert alert-success">
					<div class="ctn">
						<div class="col-sm-2 m-t-b" style="font-weight:700;"></div>
						<div class="col-sm-1 m-t-b" style="font-weight:700;"></div>
						<div class="col-sm-5 m-t-b"></div>
						<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;"></div>
						<div class="col-sm-2 m-t-b">
							<button type="button" class="btn btn-primary">附件</button>
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