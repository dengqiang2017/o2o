<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
    <%@include file="../res.jsp"%>
    <link rel="stylesheet" href="../pcxy/css/function.css"> 
	<script src="../js/o2od.js"></script>
	<script type="text/javascript" src="../pc/js/customer/quotaApplication.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li>我的位置</li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>款项申请</li>
      </ol>
      <div class="header-title">款项申请
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
		
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
			额度申请
		</div>
		<div class="box-body">
			<form action="">
				<div class="pay-form">
					<span class="pay-label">申请金额</span>
					<input type="text" class="payinput" data-number="num">
				</div>
				<div class="pay-form">
					<span class="pay-label">充值日期</span>
					<input type="text" class="payinput Wdate">
				</div>
			</form>
			<a href="iou.do" target="_blank">查看欠条</a>
			<div class="ctn m-t-b">
				<button type="button" class="btn btn-primary">提交</button>
				<a href="../customer.do" class="btn btn-primary">返回</a>
			</div>
		</div>
      </div>
    </div>

    <div class="footer">
客户:${sessionScope.customerInfo.clerk_name} 
    </div>
</body>
</html>