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
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta http-equiv="expires" content="0">
<meta name="description" content="${requestScope.description}">
<meta name="keywords" content="${requestScope.keywords}">
<title>我的优惠券-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<style type="text/css">
.row>div {
	margin: 5px;
}
#type_name{
display:block;/*内联对象需加*/
width:15em;
word-break:keep-all;/* 不换行 */
white-space:nowrap;/* 不换行 */
overflow:hidden;/* 内容超出宽度时隐藏超出部分的内容 */
text-overflow:ellipsis;/* 当对象内文本溢出时显示省略标记(...) ；需与overflow:hidden;一起使用。*/
}
</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a onclick="javascript:history.back();" class="header_left">返回</a>
	我的优惠券
</div>
</nav>
	<div class="container">
	<div style="margin-top: 50px;">
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab">未使用</a></li>
					<li role="presentation"><a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">已使用</a></li>
					<li role="presentation"><a href="#messages" aria-controls="messages" role="tab" data-toggle="tab">已过期</a></li>
				</ul>
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="home"></div>
					<div role="tabpanel" class="tab-pane" id="profile"></div>
					<div role="tabpanel" class="tab-pane" id="messages"></div>
					<div id="item" style="display: none;">
					<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3" style="height: 80px; margin-top: 5px;">
					<div style="border: 1px solid #F00;width: 100%;height: 100%;">
								<div class="col-xs-3 col-md-3 col-lg-3" style="height: 100%; background-color: #337ab7; color: white; padding: 5px;">
									<div style="text-align: center;color: white; ">
										￥<span style="font-size: 20px;color: white; " id="couponAmount">5</span>
									</div>
									<div style="font-size: 10px; padding-top: 5px;color: white; ">
										满<span id="couponUpAmount" style="font-size: 10px;color: white; ">100</span>元可用
									</div>
								</div>
								<div class="col-xs-9 col-md-9 col-lg-9">
									<div style="padding-top: 10px;font-size: 14px;">
										<span id="type_name" style="font-size: 14px;">芝华士</span>
									</div>
									<div id="type_id" style="display: none;"></div>
									<div style="padding-top: 5px">
										<span style="font-size: 10px;"> <span id="f_begin_date" style="font-size: 10px;">2017.04.05</span>~<span id="f_end_date" style="font-size: 10px;">2017.05.05</span>
										</span> <span></span>
										<a href="product_display.jsp" class="btn btn-info btn-xs pull-right" id="use">立即使用</a>
									</div>
								</div>
								<div style="display: none;" id="ivt_oper_listing">优惠券编号</div>
					</div>
							</div>
					</div>
				</div>
			</div></div>
	<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<!-- <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script> -->
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/mycoupon.js${requestScope.ver}"></script>
</body>
</html>