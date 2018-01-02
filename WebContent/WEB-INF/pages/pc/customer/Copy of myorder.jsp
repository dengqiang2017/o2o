<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
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
      <div class="ctn-fff box-ctn" style="min-height:500px;"><div class="box-head">
          <ul class="nav nav-tabs" style="margin-top:10px;">
            <li class="active"><a>待支付订单</a></li>
            <li style="display: none;"><a>已支付订单</a></li>
            <li><a>订单跟踪</a></li>
          </ul>
          <%@include file="../find.jsp" %>
          <div></div>
        </div>
        <div class="box-body">
          <div class="ctn tabs-content">
            <div class="ctn">
              <button type="button" class="btn btn-danger" id="zhifu">支付</button>
              <button type="button" class="btn btn-primary" id="all1">全选</button>
              <button type="button" class="btn btn-primary" id="orderdel">删除</button>
            </div>
           <%@include file="../list/customer/myorder0.jsp" %>
          <div class="ctn" style="display: none;">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
          <div class="ctn tabs-content">
          <%@include file="../list/customer/myorder1.jsp" %>
          <div class="ctn" style="display: none;">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
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