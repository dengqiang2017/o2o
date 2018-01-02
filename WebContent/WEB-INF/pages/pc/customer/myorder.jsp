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
	<c:if test="${sessionScope.customerInfo.com_id=='001Y10'}">
<script type="text/javascript">
window.location.href="ds/personal_center.html";
</script>
</c:if>
	<%@include file="../res.jsp"%>
  <link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<!--   <script src="../js/o2od.js"></script> -->
<!--   <script src="../js/o2otree.js"></script> -->
  <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
  <script type="text/javascript" src="../pc/js/customer/myorder.js${requestScope.ver}"></script>
</head>
    <style>
    @media(max-width:770px){
    .center_div{
          width:100%;
    padding-bottom: 25px;
    }
    }
    @media(min-width:770px){
    .center_div{
    width:70%;
    margin:auto;
    }
    }

    </style>
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

    <div class="center_div">
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
      客户: ${sessionScope.customerInfo.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
    </div>
    <%@include file="../chehuachu.jsp" %>
</body>
</html>