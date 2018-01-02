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
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>浏览记录-${requestScope.systemName}</title>
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="css/index.css${requestScope.ver}">
<style type="text/css">
@media (min-width: 992px) {
	#list{height: 407px;}
}
@media (min-width: 768px) {
#list{height: 100%;}
}
@media (min-width: 992px) {
#list{height: 91%;}
}
@media (min-width: 1200px) {
#list{height: 91%;}
}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a onclick="javascript:history.back();" class="header_left">返回</a>
	浏览记录
</div>
</nav>
<div class="container">
<div id="list" style="overflow: auto;margin-top: 50px;"></div>
<div id="xptsitem" style="display: none;">
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
          <div class="case_list_box">
              <a>
                  <img class="img-responsive">
              </a>
              <div id="item_name" style="font-size: 14px;text-align: left;">地中海风</div>
              <div style="text-align: left;">
              <span id="cost_name" style="color: #F00101;font-size: 14px;"></span>
              <p id="view_time" style="font-size: 12px;"></p>
               </div>
           </div>
     </div>
</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/browsingHistory.js${requestScope.ver}"></script>
</body>
</html>