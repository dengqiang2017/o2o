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
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>个人中心-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/personal_center.css${requestScope.ver}">
<link rel="stylesheet" href="css/wuliuview.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.col-lg-4 div{
/* text-align: center; */
cursor: pointer;
}
.order_title{cursor: pointer;}
.order_title .col-xs-4{text-align: center;font-size: 18px;}
.borderright{border-right: 1px solid aqua;}
</style>
</head><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
	个人中心
</div>
<div class="header" style="display: none;">
<a onclick="$('#wuliupage,.header:eq(1)').hide();$('#infopage,.header:eq(0)').show();" class="header_left">返回</a> 订单跟踪
</div>
</nav>
	<div class="container">
	<div id="infopage">
				<div class="" style="margin-top: 50px;">
					<!------ banner-------->
					<div class="banner" style="height:150px;">
					<div class="col-xs-4 col-md-4">
						<img id="user_logo" onerror="$(this).hide();">
					</div>
					<div class="col-xs-8 col-md-8" style="text-align: left;">
						<div class="col-xs-12 col-md-12">
							<p id="clerk_name" style="color: white;"></p>
							<a href="/client_cms/index.html?com_id=${sessionScope.customerInfo.com_id}" class="btn btn-info btn-sm" style="color:yellow;font-weight: bold;">客户专栏</a>
						</div>
					</div>
						<a href="modified_data.jsp?com_id=${sessionScope.customerInfo.com_id}" class="edit">编辑资料</a>
					</div>
					<!------订单-- 非消费者,显示报价单---->
					<div class="order_title">
					<div class="col-xs-3 borderright" onclick="window.location.href='addFileList.jsp?com_id=${sessionScope.customerInfo.com_id}';">
					<div>订单附件</div>
					<div style="font-size: 12px;color: #999999;">上传订单附件,查看历史上传</div>
					</div>
					<div class="col-xs-3 borderright" onclick="window.location.href='addedList.jsp?com_id=${sessionScope.customerInfo.com_id}';">
					<div>我的报价单</div>
					<div style="font-size: 12px;color: #999999;">查看产品报价,下订单</div>
					</div>
					<div class="col-xs-3 borderright" onclick="window.location.href='payList.jsp?com_id=${sessionScope.customerInfo.com_id}';">
					<div>我要付款</div>
					<div style="font-size: 12px;color: #999999;">上传支付凭证</div>
					</div>
					<div class="col-xs-3" onclick="window.location.href='statement.jsp?com_id=${sessionScope.customerInfo.com_id}';">
					<div>我的账单</div>
					<div style="font-size: 12px;color: #999999;">交易明细,欠款,对账</div>
					</div>
					<div class="clearfix"></div>
					</div>
					<div class="order_title" onclick="window.location.href='orderList.jsp?com_id=${sessionScope.customerInfo.com_id}';">
						<div class="pull-left" style="margin-top: 2px">我的订单</div>
						<div class="pull-right">
							<div class="look_all_left">查看全部订单</div>
							<div class="look_all_right">
								<img src="images/backRight.png">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="clearfix"></div>
					</div>
					<div class="order_classify">
						<div class="col-xs-4 active">
							<span class="fa fa-dropbox" aria-hidden="true"></span> <span>待发货</span>
						</div>
						<div class="col-xs-4">
							<span class="fa fa-truck" aria-hidden="true"></span> <span>待收货</span>
						</div>
						<div class="col-xs-4">
							<span class="fa fa-trophy" aria-hidden="true"></span> <span>待评价</span>
						</div>
						<div class="clearfix"></div>
					</div>
					<div class="order_list">
					</div>
					<div id="item" style="display: none;">
					<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
							<div class="word_product clearfix">
									<div class="col-xs-4 pic">
										<img class="img-responsive">
									</div>
									<div class="col-xs-8">
										<span id="seeds_id" style="display: none;"></span> <span id="orderNo" style="display: none;"></span>
										<div class="product">
											<div class="text-overflow" id="item_name"></div>
											<div class="product_color">
												颜色规格：<span id="item_color"></span>
											</div>
											<div class="product_bottom">
												<div class="cost pull-left">
													￥<span id="price"></span>
												</div>
												<div class="number pull-right">
													x<span id="sd_oq"></span>
												</div>
												<div class="clearfix"></div>
											</div>
											<div class="product_title">特殊工艺:<span class="product_title text-overflow" style="text-decoration: underline;" id='memo_color'></span></div>
											<div class="product_title">
											<span style="font-size: 12px;">订单状态:</span>
											<span style="font-size: 12px;" id="Status_OutStore"></span></div>
										</div>
									</div>
									<div class="col-xs-12">
										<div class="btn-center">
											<button type="button" id="reminderDelivery">提醒发货</button>
											<button class="check" type="button" id="viewLogistics">查看物流</button>
											<button type="button" id="confirmReceipt">确认收货</button>
											<span style="font-size: 12px;display: none;" id="evaluatemmsg">评价+晒单可得30金币</span>
											<button type="button" style="width: 68px" id="evaluate">评价晒单</button>
										</div>
									</div>
								</div></div>
					</div>
				</div>
				<!-------------固定尾部------------>
			</div>
			<div id="wuliupage" style="display: none;">
				<div class="word_product">
					<div class="col-xs-4 pic">
						<img class="img-responsive" src="images/caseimg.jpg">
					</div>
					<div class="col-xs-8">
						<div class="product">
							<div id="item_name"></div>
							<div class="product_color">颜色规格：<span id="item_color"></span></div>
							<div class="product_bottom">
								<div class="cost pull-left">￥<span id="price"></span></div>
								<div class="number pull-right">x<span id="sd_oq"></span></div>
								<div class="clearfix"></div>
							</div>
							<div class="product_title">
											<span style="font-size: 14px;">订单状态:</span>
											<span style="font-size: 14px;" id="Status_OutStore"></span></div>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
				<div class="">
					<ul id="historylist">
					</ul>
					<div id="historyitem" style="display: none;">
						<li>
							<div class="col-xs-2">
								<div class="state_img">
									<img src="images/07_ring.png">
								</div>
							</div>
							<div class="col-xs-10 li_margin">
								<ul>
									<li style="margin-top: 0;" id="content"></li>
									<!--  <li style="white-space:nowrap">【货运司机:梁二(14780007226)】</li> -->
									<li id="time"></li>
								</ul>
							</div>
							<div class="clearfix"></div>
						</li>
					</div>
				</div>
			</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="platformjs/swiper-3.3.1.jquery.min.js"></script>
<script type="text/javascript" src="platformjs/jquery.nicescroll.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/customer.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/personal_center.js${requestScope.ver}"></script>
</body>
</html>