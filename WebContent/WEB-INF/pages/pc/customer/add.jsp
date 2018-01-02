<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>O2O营销服务平台</title> 
<link rel="stylesheet" href="../pcxy/css/product.css">
 <%@include file="../res.jsp" %>
     <script src="../js/o2od.js"></script>
      <script src="../js/o2otree.js"></script>
  <script type="text/javascript" src="../pc/js/employee/add.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户登录</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>自助增加品种</li>
      </ol>
      <div class="header-title">客户自助增加品种
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
      <input type="hidden" id="customer_id" value="${sessionScope.customerInfo.customer_id}">
    </div>

    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
        <%@include file="../orderfind.jsp" %>
        </div>
          <div class="box-body">
          <div class="ctn">
 			<%@include file="../list/customer/add.jsp" %>
          </div>
          <div class="ctn">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
        </div></div>
        </div>
    <div class="back-top" id="scroll"></div>
    <div class="footer">
      客户:${sessionScope.customerInfo.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button class="btn btn-info" id="allcheck">全选</button>
        <button class="btn btn-info" id="add">提交</button>
        <a href="../customer.do" class="btn btn-primary">返回</a>
      </div>
    </div>
    
</body>
</html>