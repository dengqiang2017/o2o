<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
  <link rel="stylesheet" href="../pcxy/css/product.css">
  <%@include file="../res.jsp" %>
    <script src="../js/o2od.js"></script>
      <script src="../pc/js/employee/findparms.js"></script>>
  <script type="text/javascript" src="../pc/js/employee/order.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="selectClient.do?type=1">选择客户</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>代下订单</li>
      </ol>
      <div class="header-title">员工-代下订单
        <a href="selectClient.do?type=1" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          客户信息
        </div>
        <div class="box-body">
          <ul class="sim-msg">
            <li></li>
          </ul>  
        </div>
      </div>
    </div>
    
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
        <%@include file="../orderfind.jsp" %>
        </div>
<!-- 列表区域 -->
        <div class="box-body">
          <div class="tabs-content" style="display: block;">
          <div class="ctn">
              <%@include file="../list/employee/order.jsp" %>
          </div>
          </div>
            <div class="tabs-content" style="display: block;">
              <div class="ctn">
                <button type="button" class="btn btn-danger">删除</button>
              </div>
<%--             <%@include file="../list/employee/order.jsp" %>--%>
              </div>
             
          <div class="ctn">
            <button class="btn btn-add" type="button" >点击加载更多</button>
          </div>
        </div>
      </div>
    </div>

    <div class="back-top" id="scroll"></div>

    <div class="footer">
      员工:${sessionScope.userInfo.user_id}<span class="glyphicon glyphicon-earphone"></span>
      
      <input type="hidden" id="customer_id">
      <div class="btn-gp">
        <button class="btn btn-info" id="allcheck">全选/取消</button>
        <button class="btn btn-info" id="saveOrder">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
    </div>
    
</body>
</html>