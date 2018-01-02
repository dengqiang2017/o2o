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
    <title>购物车</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/shopping_cart.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">购物车</div>
</nav>
    <div class="container">
        <div class="shopping_cart_list" style="margin-top: 50px;">
                <ul>
                    
                </ul>
            </div>
            <div style="display: none;" id="item">
            <li>
                        <div class="list_box">
                            <div class="list_box_title">
                                <div class="title_pitch modal-word">
                                    <div class="word_pitch">
                                    <i class="fa fa-circle-thin" aria-hidden="true"></i>
                                	</div>
                                </div>
                                <div class="title_edit">
                                    <span class="editInfo" style="text-decoration: underline;"><span>编辑</span></span>
                                </div>
                            </div>
                            <div class="list_box_word">
                                
                                <span id="seeds_id" style="display: none;"></span>
                                <span id="orderNo" style="display: none;"></span>
                                <div class="word_product">
                                        <div class="col-xs-4 pic"><img class="img-responsive" src=""></div>
                                        <div class="col-xs-8">
                                            <div class="product">
                                                <div class="product_title" id="item_name"></div>
                                                <div class="product_color">颜色分类：<span id="item_color"></span></div>
                                                <div class="product_bottom">
                                                    <div class="cost pull-left">￥<span id="sd_unit_price"></span>元</div>
                                                    <div class="number pull-right">x<span id="sd_oq">1</span></div>
                                                    <div class="clearfix"></div>
                                                </div>
                                                <div class="product_title">特殊工艺:<span class="product_title text-overflow" style="text-decoration: underline;" id='memo_color'></span></div>
                                            </div>
                                            <div class="operation">
                                                <div class="pro-num-I">
                                                    <span class="add">+</span>
                                                    <span class="sub">-</span>
                                                    <input type="number" data-num="num2" value="1" class="num" id="pronum">
                                                </div>
                                                <button class="memocolor btn btn-info">特殊工艺备注</button>
                                                <div id="memo"></div>
                                            </div>
                                        </div>
                                </div>
                                <div class="del" style="display: none" id="delshopping">删除</div>
                            </div>
                        </div>
                    </li>
            </div>
            <!-------------结算---------------->
            <div class="close_accout navbar navbar-default navbar-fixed-bottom">
            <div class="container">
                <div class="close_accout_left">
                    <div class="accout_left_check" style="cursor: pointer;">
                        <i class="fa fa-circle-thin" aria-hidden="true"></i>全选
                    </div>
                    <div class="accout_left_cost">合计：￥<span class="zje">0</span></div>
                </div>
                <div class="close_accout_right" id="orderpay">
                	结算(<span class="zje"></span>)
                </div>
            </div>
                <div class="clearfix"></div>
            </div><!-------------固定尾部------------>
            <div class="footer navbar navbar-default navbar-fixed-bottom">
            <div class="container">
                <div class="col-xs-4">
                    <a href="index.jsp?com_id=${sessionScope.customerInfo.com_id}">
                        <span class="fa fa-home fa-fw" aria-hidden="true"></span>
                        <span>首页</span>
                    </a>
                </div>
                <div class="col-xs-4">
                    <a href="shopping_cart.jsp?com_id=${sessionScope.customerInfo.com_id}">
                        <span class="fa fa-shopping-cart active" aria-hidden="true"></span>
                        <span class="active">购物车</span>
                    </a>
                </div>
                <div class="col-xs-4">
                    <a href="personal_center.jsp?com_id=${sessionScope.customerInfo.com_id}">
                        <span class="fa fa-user fa-fw" aria-hidden="true"></span>
                        <span>我</span>
                    </a>
                </div>
            </div>
                <div class="clearfix"></div>
            </div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/customer.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/shopping_cart.js${requestScope.ver}"></script>
</body>
</html>