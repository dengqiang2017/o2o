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
		<%@include file="../res.jsp" %>
		<link rel="stylesheet" href="../pcxy/css/product.css?ver=002">
	<script type="text/javascript" src="../js/o2od.js"></script>
	<script type="text/javascript" src="../js/o2otree.js"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../pc/js/employee/productpage.js?ver=006"></script>
	<script type="text/javascript" src="../pc/js/employee/planlistcom.js?ver=001"></script>
	<script type="text/javascript" src="../pc/js/customer/planlist.js?ver=003"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户计划</li>
      </ol>
      <div class="header-title">客户-客户计划
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b" id="ti">
              <div class="form-group">
                <label for="">预计提货日期</label>
                <input type="date" class="form-control input-sm Wdate" value="${requestScope.N1Time}" id="at" 
                onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'%y-%M-{%d+1}',onpicked:pickedFunc})">
                <span id="n1time" style="display: none;">${requestScope.N1Time}</span>
              </div> 
              <p style="color:#af3444; font-size:18px;display: none;" id="chadan">您正在紧急插单！</p>
           <div class="form-group"  id="chadantext">
            <label for="">备注</label>
            <textarea class="form-control input-sm"></textarea>
          </div> 
         </div>
        </div>
        <div class="box-head">
        <%@include file="../find.jsp"%>
        <input type="hidden" id="customer_id" value="${sessionScope.customerInfo.customer_id}">
        <input type="hidden" id="sd_order_direct" value="日计划">
        </div>

        <div class="box-body">

          <div class="tabs-content">
            <div class="ctn">
            <%@include file="../list/employee/planlist.jsp"%>
            </div>
          </div>
          <div class="tabs-content">
            <div class="ctn">
              <button type="button" class="btn btn-danger" id="plandel">删除</button>
              <span>以${requestScope.time},之前的为今天的计划,之后的明天的计划</span>
            </div>
            <div class="ctn">
               <div class="col-sm-6" id="item01"></div>
				<div class="col-sm-6" id="item02"></div>           
            </div>
          </div>

          <div class="ctn">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
        </div>
      </div>
    </div>

    <div class="back-top" id="scroll"></div>

    <div class="footer">
      客户:${sessionScope.customerInfo.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button class="btn btn-info" id="allcheck" disabled="disabled">全选</button>
        <button class="btn btn-info" id="save" disabled="disabled">提交</button>
        <a href="../customer.do" class="btn btn-primary">返回</a>
      </div>
    </div>
    
</body>
</html>