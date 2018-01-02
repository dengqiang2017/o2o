<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- <!DOCTYPE html> -->
<!-- <html> -->
<!-- <head lang="en"> -->
<!--     <meta charset="UTF-8"> -->
<!--     <meta http-equiv="U-XA-Compatible" content="IE-edge"> -->
<!--     <meta http-equiv="Pragma" content="no-cache"> -->
<!--     <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"> -->
<!--     <title></title> -->
<%--     <%@include file="../res.jsp" %> --%>

<!-- </head> -->
<!-- <body> -->
<style>
    @media(max-width: 770px){
        .margin{
            margin-top: 20px;
        }
    }
    @media(max-width: 770px){
        .margin{
            margin-top: 60px;
        }
    }
</style>
    <link rel="stylesheet" href="../pc/css/huashen-pingjia.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
<!-------------------导航条---------------------->
<nav class="nav navbar-default navbar-fixed-top nav-out" role="navigation">
    <div class="navbar-header">
        <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#collapse" style="float: left;margin-top: 15px;margin-left: 22px">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href=""><img src="../pc/image/logo.png"  style="width: 46px;height: 45px;position: absolute;right: 30px;top:10px"></a>
    </div>
    <input type="hidden" id="type" value="">
    <div class="collapse navbar-collapse" id="collapse">
        <ul class="nav navbar-nav navbar-left" style="margin-top: 15px;margin-bottom: 10px">
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="../employee.do" style="display: inline-block;padding: 10px 0">员工首页</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a id="ddlist" href="../employee/orderTracking.do" style="display: inline-block;padding: 10px 0">订单跟踪</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a style="display: inline-block;padding: 10px 0">评价订单</a>
            </li>
        </ul>
    </div>
</nav>
<!------------------------section-------------------->
<section class="section" style="margin-top:0">
    <div class="container">
        <div class="box-subject">
            <div class="box-subject-header">评价订单</div>
            <div class="box-subject-body">
                <form class="f1"><input type="hidden" id="orderNo" value="${requestScope.orderNo}">
                    <div class="form-group">
                        <textarea id="yijian" class="form-control" rows="9" placeholder="您的意见是我们前进的动力，请留下你的意见"></textarea>
                    </div>
    <div class="section-container-pingjia">
    <ul>
    <li id="spzl"><div style="margin-top:3px;float:left">商品质量</div><div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div></div><div style="clear:both"></div></li>
    <li id="fwtd"><div style="margin-top:3px;float:left">服务态度</div><div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div></div><div style="clear:both"></div></li>
    <li id="wlsd"><div style="margin-top:3px;float:left">物流速度</div><div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div></div><div style="clear:both"></div></li>
    <div style="clear:both;"></div>
    </ul>
    </div>
    <div id="showpingjia">
    <c:forEach items="${requestScope.list}" var="imgurl">
        <img src="../${imgurl}" onclick="evaluation.showImg(this);">
    </c:forEach>
    </div>
                </form>
            </div>
            </div>
        </div>
</section>
<div class="image-zhezhao" style="display:none">
   <div style="width: 5%;float: left">
        <div class="img-left"></div>
   </div>
    <div style="width: 90%;float: left;height: 100%;">
        <div class="img-ku" style="float:left;">
            <div id="imshow">
            </div>
        </div>
    </div>
    <div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div>
<!-- </body> -->
<!-- </html> -->