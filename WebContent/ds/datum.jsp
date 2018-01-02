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
    <title>设计师资料</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/datum.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
   <div class="header-phone">
            <a onclick="javascript:history.back();" class="header_left">返回</a>
            设计师
        </div>
</nav>
<div class="container">
    <div class="clearfix" style="margin-top: 50px;">
            <div class="header_portrait col-xs-4">
                <img src="" id="tx" class="center-block">
            </div>
            <div class="col-xs-8">
               <ul>
                   <li>
                       <span style="color:#006667;font-size: 20px;font-weight: bold;" id="clerkName"></span><span style="color:#F42C2D;font-size: 13px;font-weight: bold;">知名设计师</span>
                   </li>
<!--                    <li style="color: #666666;font-size: 14px">8年工作经验</li> -->
                   <li style="color: #666666;font-size: 14px" id="describe">创意是设计的源泉，生活是设计的本质</li>
                   <li style="color: #666666;font-size: 14px">
                       <button type="button" class="btn btn-primary" id="chat" style="background-color: #FFFFFF;color: #076464">在线咨询</button>
                       <button type="button" class="btn btn-primary" id="tel" style="background-color: #076464;color: #FFFFFF">电话</button>
                   </li>
               </ul>
            </div>
        </div><div class="clearfix" id="jzlist">
        </div><div id="jzitem" style="display: none;">
        <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
            <div class="box">
                <div class="pic">
                    <img src="">
                </div>
                <div class="word">
                    <div class="word_top" id="proName">现代简约</div>
                    <div class="word_bottom" id="miaosu">简化整合，改变后的主卧空间</div>
                </div>
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
        </div><!-- --></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script> 
<script type="text/javascript" src="js/datum.js${requestScope.ver}"></script>
</body>
</html>