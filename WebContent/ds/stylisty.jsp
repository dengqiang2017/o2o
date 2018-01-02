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
    <title>设计师</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/stylisty.css${requestScope.ver}">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
   <div class="header-phone">
    <a onclick="javascript:history.back();" class="header_left">返回</a>
    设计师
</div>
        <div class="search">
            <div class="input-group center-block">
                <label><span class="fa fa-search" aria-hidden="true"></span></label>
                <input type="text" placeholder="请输入关键词" id="searchKey" maxlength="20">
                <div class="clearfix"></div>
            </div>
        </div>
</nav>
<div class="container">
    <div class="clearfix" id="sjslist" style="margin-top: 80px;">
        </div><div id="sjsitem" style="display: none;">
        <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
                <div class="stylist_box">
                    <img src="">
                    <span id="clerkName"></span>
                    <span id="describe"></span>
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
        </div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/stylisty.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
weixinShare.init($("title").html(),"${requestScope.description}","http://www.pulledup.cn/ds/images/banner2.jpg");
//-->
</script>
</body>
</html>