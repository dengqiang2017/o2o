<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>O2O营销服务平台</title>
	<script type="text/javascript" >
	<!--
	var type=1;	
	var url=window.location.href.split("?");
	 var params=url[1].split("|");
	 var pa=decode(params[1]);
	 if(pa.indexOf("发货")>=0){
		 type=2;
	 }else if(pa.indexOf("收货")>=0){
		 type=2;
	 }
	window.location.href='../pc/order_center.html?type='+type;
	//-->
	</script> 
	<%@include file="../res.jsp"%>
  <link rel="stylesheet" href="../pcxy/css/product.css">
  <script src="../js/o2od.js"></script>
  <script src="../js/o2otree.js"></script>
  <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
  <script type="text/javascript" src="../pc/js/employee/productpage.js"></script>
  <script type="text/javascript" src="../pc/js/customer/myorder.js?ver=002"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>我的订单</li>
      </ol>
      <div class="header-title">客户 -我的订单
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-body">
          <div class="ctn tabs-content">
          <%@include file="../list/customer/myorder3.jsp" %>
          </div>
        </div>
      </div>
    </div>

    <div class="back-top" id="scroll"></div>

    <div class="footer">
      客户: ${sessionScope.customerInfo.user_id}<span class="glyphicon glyphicon-earphone"></span>
    </div>
    
</body>
</html>