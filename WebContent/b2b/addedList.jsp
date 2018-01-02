<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.getVer(request); 
%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>我的报价单</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/product_display.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
.case_list_box label{font-weight: normal;font-size: 14px;}
.infodiv ul{margin-left: 0!important;}
.modal-dialog{margin-top: 50px;}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
	<div class="container">
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header-phone">
			<a href="personal_center.jsp" class="header_left">返回</a>我的报价单
			<a class="btn btn-primary" style="float: right;margin-top: -3px;" id=save>提交</a>
		</div>
		<!------ 商品展示搜索--------->
		<div class="search">
			<div class="input-group center-block">
				<label><span class="fa fa-search" aria-hidden="true"></span></label>
				<input type="text" placeholder="请输入关键词" id="searchKey" style="margin-left: 10px;"
					maxlength="20">
				<div class="clearfix"></div>
			</div>
			<div class="screen">
				<span style="color: burlywood; font-size: 28px;"
					class="glyphicon glyphicon-th-list"></span>
			</div>
		</div>
	</nav>
		<!------- 商品展示列表-------->
		<div class="product_display_list">
			<div id="productList"></div> 
			<div style="display: none;" id="xptsitem">
	<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
	<span id="item_id" style="display: none;"></span>
		<input type="hidden" id="seeds_id">
		<input type="hidden" id="price_display">
		<input type="hidden" id="price_prefer">
		<input type="hidden" id="price_otherDiscount">
		<%@include file="proinfo.jsp" %>
		<div style="border-bottom: 1px solid aqua;">
		<div class="col-xs-6 col-sm-6 col-md-6">
			<label for="">单价￥</label><span id="sd_unit_price"></span>元
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">下单数量</label> 
			<input type="number" id="num" data-num="num2" maxlength="10"> 
			<span id="item_unit"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">折算数量</label>
			<span id="pack_unit" style="display: none;"></span>
			<input type="number" id="zsum" data-num="num2" maxlength="10">
			<span id="casing_unit"></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6">
			<label for="sum_si">金额￥</label>
			<span id="sum_si"></span>元
		</div>
		<div class="col-xs-12 col-sm-12 col-md-12">
       		<button type="button" class="btn btn-success" id="moreMemo" style="float: right;">特殊工艺备注</button>
       		<span id="c_memo"></span>
       		<span id="memo_color"></span>
       		<span id="memo_other"></span>
         </div>
         <div class="clearfix"></div>
		</div>
	</div>
</div>
			
			
		</div>
		<!-------------商品筛选------------->
		<div class="side-cover-phone">
			<div class="product-check-phone" onclick="event.cancelBubble = true">
				<div class="p-c-header">
					<span class="title">筛选</span> <span class="left-btn">取消</span> <span
						class="right-btn">确定</span>
				</div>

				<div class="p-c-body">
					<div class="p-c-group p-c-content ui_shaixuan">
						<div class="p-c-title active">
							<input type="hidden" id="customer_id" value="CS1_ZEROM">
							<span class="title">品牌</span> <span class="filedId"
								style="display: none;"></span> <i
								class="fa fa-angle-right fa-fw"></i> <span class="checked"></span>
						</div>
						<ul style="display: block;"></ul>
					</div>
					<div class="p-c-group p-c-content ui_shaixuan">
						<div class="p-c-title">
							<span class="title">用途</span> <span class="filedId"
								style="display: none;"></span> <i
								class="fa fa-angle-right fa-fw"></i> <span class="checked"></span>
						</div>

						<ul style="display: none;"></ul>
					</div>

					<div class="p-c-group p-c-content ui_shaixuan">
						<div class="p-c-title">
							<span class="title">类别</span> <span class="filedId"
								style="display: none;"></span> <i
								class="fa fa-angle-right fa-fw"></i> <span class="checked"></span>
						</div>
						<ul style="display: none;"></ul>
					</div>

					<div class="p-c-group p-c-content ui_shaixuan"
						style="display: none;">
						<div class="p-c-title">
							<span class="title">店铺</span> <span class="filedId"
								style="display: none;"></span> <i
								class="fa fa-angle-right fa-fw"></i> <span class="checked"></span>
						</div>
						<ul style="display: none;"></ul>
					</div>

					<div class="p-c-group p-c-content ui_shaixuan">
						<div class="p-c-title">
							<span class="title">价格区间</span> <span class="filedId"
								style="display: none;">sd_unit_price</span> <i
								class="fa fa-angle-right fa-fw"></i> <span class="checked"></span>
						</div>
						<ul style="display: none;">
							<li><span>全部价格</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>2000-2500</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>2500-3000</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>3000-3500</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>4000-4500</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>5000-7000</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>7000-900</span> <i class="glyphicon glyphicon-ok"></i>
							</li>
							<li><span>9000-10000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>100000-15000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>150000-25000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>250000-45000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>450000-65000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>650000-95000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
							<li><span>950000-115000</span> <i
								class="glyphicon glyphicon-ok"></i></li>
						</ul>
					</div>
				</div>
				<div class="clear-ctn">
					<div class="clear-btn">清除选项</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/addedList.js${requestScope.ver}"></script>
</body>
</html>