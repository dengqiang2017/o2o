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
    <title>装修案例</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/animate.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/spruce.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
   <div class="header-phone">
            <a href="index.jsp" class="header_left">返回</a>
            装修案例
        </div><div class="search">
                <div class="input-group center-block" style="">
                    <label><span class="fa fa-search" aria-hidden="true"></span></label>
                    <input type="text" placeholder="请输入关键词" id="searchKey" maxlength="20">
                    <div class="clearfix"></div>
                </div>
                <div class="screen"><span style="color: burlywood;font-size: 28px;" class="glyphicon glyphicon-th-list"></span></div>
            </div>
</nav>
<div class="container">
<div id="jzlist" class="spruce_box clearfix" style="height: 100%;overflow: auto;">
        </div><div id="jzitem" style="display: none">
        	<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
                <div class="box">
                 <div class="pic">
                     <img src="">
                 </div>
                <div class="word">
                    <div class="word_top clearfix">
                        <div class="pull-left" id="proName"></div>
                        <div class="pull-right"><span style="color: #FE4645" id="price"></span></div>
                    </div>
                    <div class="word_bottom" id="miaosu"></div>
                </div>
                </div>
            </div>
        </div><!-------------商品筛选-------------><div class="side-cover-phone">
            <div class="product-check-phone" onclick="event.cancelBubble = true">
                <div class="p-c-header">
                    <span class="title">筛选</span>
                    <span class="left-btn">取消</span>
                    <span class="right-btn">确定</span>
                </div>

                <div class="p-c-body">
                    <div class="p-c-group p-c-content ui_shaixuan">
                        <div class="p-c-title active">
                            <span class="title">风格</span>
                            <span class="filedId" style="display: none;"></span>
                            <i class="fa fa-angle-right fa-fw"></i>
                            <span class="checked"></span>
                        </div>
                        <ul style="display: block;"></ul>
                    </div>
                    <div class="p-c-group p-c-content ui_shaixuan">
                        <div class="p-c-title">
                            <span class="title">用途</span>
                            <span class="filedId" style="display: none;"></span>
                            <i class="fa fa-angle-right fa-fw"></i>
                            <span class="checked"></span>
                        </div>

                        <ul style="display: none;"></ul>
                    </div>

                    <div class="p-c-group p-c-content ui_shaixuan">
                        <div class="p-c-title">
                            <span class="title">类别</span>
                            <span class="filedId" style="display: none;"></span>
                            <i class="fa fa-angle-right fa-fw"></i>
                            <span class="checked"></span>
                        </div>
                        <ul style="display: none;"></ul>
                    </div>

                    <div class="p-c-group p-c-content ui_shaixuan">
                        <div class="p-c-title">
                            <span class="title">店铺</span>
                            <span class="filedId" style="display: none;"></span>
                            <i class="fa fa-angle-right fa-fw"></i>
                            <span class="checked"></span>
                        </div>
                        <ul style="display: none;"></ul>
                    </div>

                    <div class="p-c-group p-c-content ui_shaixuan">
                        <div class="p-c-title">
                            <span class="title">价格区间</span>
                            <span class="filedId" style="display: none;">price_display</span>
                            <i class="fa fa-angle-right fa-fw"></i>
                            <span class="checked"></span>
                        </div>
                        <ul style="display: none;">
                            <li>
                                <span>全部价格</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>20000-40000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>40000-60000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>60000-80000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>80000-100000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>100000-150000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>150000-200000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>200000-250000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>250000-300000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>300000-350000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>350000-400000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>400000-450000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>450000-500000</span>
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                            <li>
                                <span>500000</span>以上
                                <i class="glyphicon glyphicon-ok"></i>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="clear-ctn">
                    <div class="clear-btn">清除选项</div>
                </div>
            </div>
        </div><!-------------固定尾部------------><div class="footer navbar navbar-default navbar-fixed-bottom">
            <div class="col-xs-4">
                <a href="index.jsp">
                    <span class="fa fa-home fa-fw active" aria-hidden="true"></span>
                    <span class="active">首页</span>
                </a>
            </div>
            <div class="col-xs-4">
                <a href="shopping_cart.jsp">
                    <span class="fa fa-shopping-cart" aria-hidden="true"></span>
                    <span>购物车</span>
                </a>
            </div>
            <div class="col-xs-4">
                <a href="personal_center.jsp">
                    <span class="fa fa-user fa-fw" aria-hidden="true"></span>
                    <span>我</span>
                </a>
            </div>
            <div class="clearfix"></div>
        </div>
        </div>

<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/spruce.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
weixinShare.init($("title").html(),"${requestScope.description}","http://www.pulledup.cn/ds/images/banner2.jpg");
//-->
</script>
        </body>
</html>