<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.getVer(request); 
	BaseController.setDescriptionAndKeywords(request);
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
<title>产品列表</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/animate.min.css">
<link rel="stylesheet" href="css/swiper-3.3.1.min.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/product_display.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header">
			<a href="index.jsp" class="header_left">返回</a> 产品列表
			<button type="button" class="btn btn-success pull-right" id="saveOrder">提交</button>
		</div>
		<!------ 商品展示搜索--------->
		<div class="search">
			<div class="input-group center-block" style="">
				<label><span class="fa fa-search" aria-hidden="true"></span></label>
				<input type="text" placeholder="请输入关键词" id="searchKey"
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
			<div id="xptsitem" style="display: none;">
				<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 dataitem">
					<span style="display: none;" id="item_id"></span>
					<span style="display: none;" id="com_id"></span>
					<span style="display: none;" id="ivt_oper_listing"></span>
					<div class="case_list_box">
					<div class="img">
					<div class="hot">活动促销</div>
					<img class="img-responsive">
					</div>
						<div class="desc">
						<div id="item_name" style="font-size: 14px; text-align: left;"></div>
							<div style="text-align: left;margin-top: 3px;">
								￥<span id="price" style="color: #F00101; font-size: 14px;"></span>
	<!-- 							<span id="cost_name" style="color: #F00101; font-size: 14px;"></span> -->
								<span class="wordT" id="price_display"
									style="text-decoration: line-through; font-size: 12px;"></span>
							</div>
						<div>
						<input type="checkbox" class="check">
						<label>数量:</label><input type="tel" class="num" style="width: 70px;" data-num="num">
						<span id="item_unit"></span>
						<button type="button" class="btn btn-info btn-sm" id="memo">备注</button>
						<div id="memo_color"></div>
						</div>
						</div>
					</div>
					<div class="clearfix"></div>
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
		<!-------------固定尾部------------>
		<div class="footer navbar navbar-default navbar-fixed-bottom">
			<div class="col-xs-4">
				<a href="index.jsp"> <span class="fa fa-home fa-fw active"
					aria-hidden="true"></span> <span class="active">首页</span>
				</a>
			</div>
			<div class="col-xs-4">
				<a href="shopping_cart.jsp"> <span class="fa fa-shopping-cart"
					aria-hidden="true"></span> <span>购物车</span>
				</a>
			</div>
			<div class="col-xs-4">
				<a href="personal_center.jsp"> <span class="fa fa-user fa-fw"
					aria-hidden="true"></span> <span>我</span>
				</a>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript"
		src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
	<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
	<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
	<script type="text/javascript"
		src="../js/popUpBox.js${requestScope.ver}"></script>
	<script type="text/javascript"
		src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
	<script type="text/javascript"
		src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
	<script type="text/javascript"
		src="js/loaderweimaimg.js${requestScope.ver}"></script>
	<script type="text/javascript"
		src="js/productDisplay.js${requestScope.ver}"></script>
	<script type="text/javascript">
	<!--
		weixinShare.init($("title").html(), "${requestScope.description}",
				"http://www.pulledup.cn/ds/images/banner2.jpg");
	//-->
	</script>
</body>
</html>