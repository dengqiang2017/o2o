<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-${requestScope.type}平台</title>
    <link rel="stylesheet" href="../pc/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/operatesell.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
    <div class="header" style="padding:10px;background-color: #6BD0B0;">
         <a href="../pc/login.html${requestScope.ver}" class="pull-left" style="color:#999;opacity:0">返回</a>
         <a class="pull-right">
       <img src="../pc/images/quit.png" style="width:20px">
    </a>
    <div class="clearfix"></div>
    </div>
    <div class="logo center-block">
        <img class="img-responsive center" src="../pc/images/3.png">
    </div>
    <div class="center">
        <div class="fg">
         <a href="preSale.do${requestScope.ver}">
            <div class="box">
    <img src="../pc/images/presell.png" class="center-block">
    我要${requestScope.type}
    </div>
    </a>
        </div>
        <div class="fg">
            <a href="../pc/dealbuy.html${requestScope.ver}">
    <div class="box">
    <img src="../pc/images/deal.png" class="center-block">
    我的交易
    </div>
    </a>
        </div>
        <c:if test="${requestScope.type=='预售'}">
        <div class="fg">

            <a href="../qidai.html">
            <div class="box">
            <img src="../pc/images/feed.png" class="center-block">
            我要进料
            </div>
            </a>
        </div>
        </c:if>
        <div class="fg">
            <a href="../pc/dataedition.html${requestScope.ver}">
    <div class="box">
    <img src="../pc/images/person.png" class="center-block">
    个人信息
    </div>
    </a>
        </div>
        <div class="col-xs-6"></div>
        <div class="clearfix"></div>
    </div>
    <a class="btn btn-danger center-block btn01" style="display:none">退出</a>
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript">
    <!--
	///../pc/huaian_index.html${requestScope.ver}
    $(".btn01").click(function(){
    $.get("../login/exitLogin.do",{"type":2});
    <c:if test="${requestScope.type=='预售'}">
    window.location.href="../pc/login.html";
    </c:if>
    <c:if test="${requestScope.type=='预购'}">
    window.location.href="../pc/loginbuy.html";
    </c:if>
    });
	$(".pull-right").click(function(){
		try {
		   WeixinJSBridge.call('closeWindow');
		} catch (e) {}
		window.location.href="../login/exitLogin.do";
	});
    //-->
    </script>
</body>
</html>