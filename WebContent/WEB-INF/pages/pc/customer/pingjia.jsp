<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../pc/css/huashen-pingjia.css">
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
        <script type="text/javascript"
	src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/customer/evaluation.js${requestScope.ver}"></script>
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
</head>
<body>
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
                <a href="../customer.do" style="display: inline-block;padding: 10px 0">客户首页</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="../customer/myorder.do" style="display: inline-block;padding: 10px 0">我的订单</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a style="display: inline-block;padding: 10px 0" id="pjtitle">评价订单</a>
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
                <form class="f1">
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
    <a id="upimg" class="btn btn-primary" style="position:relative;margin-top:20px;cursor: pointer;">上传照片
    <input type="hidden" name="typeImg" id="filePath">
    <input type="file" class="ct input-upload" name="pingjia" id="pingjia" onchange="imgUpload(this,'pingjia');" style="width:100%;height:100%">
    <input type="button" id="scpz"  class="ct input-upload" style="width:100%;height:100%">
    </a>
    <div id="showpingjia">
    <c:forEach items="${requestScope.list}" var="imgurl">
        <img src="../${imgurl}">
    </c:forEach>
    </div>
                </form>
                <button type="button" class="btn btn-success center-block btn-size2" style="background-color: #009805" id="postEval">提交评价</button>
            </div>
            </div>
        </div>
</section>
</body>
</html>