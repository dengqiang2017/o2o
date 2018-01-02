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
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="达州创新家居电商平台主要经营家具,家居,沙发,茶几,桌子,装修">
    <meta name="keywords" content="家具,家居,沙发,茶几,桌子,装修">
    <title>全部订单</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/orderList.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a href="personal_center.jsp" class="header_left">返回</a>
    全部订单
</div>
<div class="search">
    <div class="input-group center-block">
        <label><span class="fa fa-search find" aria-hidden="true"></span></label>
        <input type="text" placeholder="请输入关键词" id="searchKey" maxlength="20">
        <div class="clearfix"></div>
    </div>
</div>
<div class="header" style="display: none;">
<a onclick="$('#wuliupage,.header:eq(1),.search').hide();$('#infopage,.header:eq(0)').show();" class="header_left">返回</a> 订单跟踪
</div>
</nav>
    <div class="container">
        <div id="infopage">
				<div class="" id="list" style="margin-top: 86px;">
                <div id="orderitem" style="display: none;">
<!--                         <div class="word_title"> -->
<!--                             <div class="pull-left"></div> -->
<!--                             <div class="pull-right" id="Status_OutStore"></div> -->
<!--                             <div class="clearfix"></div> -->
<!--                         </div> -->
                        <div class="word_product col-xs-12 col-sm-6 col-md-4 col-lg-4">
                            <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 pic"><a id="zcgm"><img class="img-responsive"></a></div>
                            <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                                <div class="product">
                                    <div id="item_name" style="font-size: 14px;"></div>
                                    <div class="product_color text-overflow" id="item_color"></div>
                                    <div class="product_bottom">
                                        <div class="cost pull-left" id="price">￥</div>
                                        <div class="number pull-right" id="sd_oq">x1</div>
                                        <div class="clearfix"></div>
                                        <div class="product_title"><span class="product_title">特殊工艺:</span><span class="product_title text-overflow" style="text-decoration: underline;" id='memo_color'></span></div>
                                       <div class="product_title">订单状态:<span class="product_title" id="Status_OutStore"></span></div>
                                       <span style="font-size: 12px;display: none;" id="evaluatemmsg">评价+晒单可得30金币</span>
                                        <div class="clearfix"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-12">
                                <div class="btn-center">
<!--                                     <a class="check" id="tuijian">推荐</a> -->
<!--                                     <button type="button" class="check" id="delorder">删除订单</button> -->
                                    <button class="check" type="button" id="viewLogistics">查看订单详情</button>
                                    <button type="button" id="qrsh" class="check">确认收货</button>
                                    <button type="button" id="pjdd" class="check">评价</button>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                </div>
            </div></div><div id="wuliupage" style="display: none;">
				
				<div class="word_product" style="margin-top: 50px;">
					<div class="col-xs-4 pic">
						<img class="img-responsive" src="">
					</div>
					<div class="col-xs-8">
						<div class="product">
							<div class="product_title" id="item_name"></div>
							<div class="product_color">颜色规格：<span id="item_color"></span></div>
							<div class="product_bottom">
								<div class="cost pull-left">￥<span id="price"></span></div>
								<div class="number pull-right">x<span id="sd_oq"></span></div>
								<div class="clearfix"></div>
							</div>
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
								<div class="state_img"></div>
							</div>
							<div class="col-xs-10 li_margin">
								<ul>
									<li style="margin-top: 0;" id="content"></li>
									<!-- <li style="white-space:nowrap">【货运司机:梁二(14780007226)】</li> -->
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
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/orderList.js${requestScope.ver}"></script>
</body>
</html>