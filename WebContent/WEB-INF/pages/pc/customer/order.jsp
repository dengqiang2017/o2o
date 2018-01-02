<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>O2O营销服务平台</title>
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<%@include file="../res.jsp"%>
<script src="../js/o2od.js"></script>
<script src="../pc/js/employee/findparms.js"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/ordercom.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/customer/order.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../customer.do">客户首页</a></li>
			<li class="active"><span
				class="glyphicon glyphicon-triangle-right"></span>下订单</li>
		</ol>
		<div class="header-title">
			 下订单 <a href="../customer.do" class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
		<input type="hidden" id='accnIvt' value="${requestScope.accnIvt}">
	</div>

	<div class="container">
		<div class="ctn-fff box-ctn" style="min-height: 500px;">
			<div class="box-head">
				<%@include file="../find.jsp"%>
			</div>
			<!-- 列表区域 -->
			<div class="box-body">
				<div class="tabs-content" style="display: block;">
				<input type="checkbox" class="check" style="display: none;">
					<div class="ctn">
						<%@include file="../list/employee/order.jsp"%>
					</div>
					<div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				<div class="tabs-content" style="display: block;">
					<div class="ctn">
						<%@include file="../list/employee/order.jsp"%>
					</div>
				<div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				 <div class="tabs-content" style="display: block;">
              		<div class="ctn">
              		  <button type="button" class="btn btn-danger" id="orderdel">删除</button>
              		  <button class="btn btn-success btn-sm" id="zhifu" type="button">支付</button>
					  <button class="btn btn-success btn-sm" id="all1" type="button">全选</button>
              		</div>
               <div id="item01"></div>
				<div id="item02"></div>
          <div class="ctn" style="display: none;">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
              </div>
			</div>
		</div>
	</div>

	<div class="back-top" id="scroll"></div>

	<div class="footer">
		客户:${sessionScope.customerInfo.clerk_name} 
		<input type="hidden" id="customer_id" value="${sessionScope.customerInfo.upper_customer_id}">
		<div class="btn-gp">
		<div id="xiaorder">
			<button class="btn btn-info allcheck">全选</button>
			<button class="btn btn-info allcheck" style="display: none;">全选</button>
			<button class="btn btn-info" id="saveShopping">加入购物车</button>
			<button class="btn btn-info" id="saveOrder">提交</button>
		</div>
			<a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
		</div>
	</div>
</body>
</html>