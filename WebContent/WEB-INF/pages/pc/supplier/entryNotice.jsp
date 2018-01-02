<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <%@include file="../res.jsp"%>
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
</head>
<body>
<!----------------header----------------->
<div class="header">
    <div class="header-title">
        <a style="color: white;" data-title="title">采购订单已收货通知单</a>
        <a class="header-back" style="margin-top: 5px" href="../employee.do">
            <span class="glyphicon glyphicon-menu-left" style="color: white;"></span>
        </a>
    </div>
</div>
<!----------------secition----------------->
<div class="section">
	<div class="col-lg-4 col-sm-6" style="background-color: #FFFFFF;margin: auto;margin-top: 10px;width: 95%;margin-bottom: 20px">
	<div>
	<input type="hidden" value="${requestScope.gys.corp_id}"> 
	<ul style="padding-left: 35px;margin-bottom: 0">
	<li>供应商名称:<span id="gysname">${requestScope.gys.corp_name}</span></li>
	<li>手机号:<span id="phone">${requestScope.gys.user_id}</span></li>
	</ul>
	<div style="display: none;" id="weixinID">${requestScope.gys.weixinID}</div>
	</div>
	</div>
    <div class="col-lg-4 col-sm-6" style="margin: auto;margin-top: 10px;width: 95%;">
    <c:forEach items="${requestScope.list}" var="item">
        <div class="div-bg" style="background-color: #FFFFFF;">
            <div class="pro-check" style="margin-top:5px">
            <input type="hidden" value="${item.item_id}">
            </div>
            <ul style="padding-left:40px">
                <li>采购编号:<span class="orderNo">${item.st_auto_no}</span></li>
                <li>产品名称:${item.item_name}</li>
                <li>产品类型:${item.item_type}</li>
                <li>单价:<span class="price">${item.price}</span></li>
                <li>数量:<span class="num">${item.rep_qty}</span></li>
                <li>订单日期:${item.at_term_datetime}</li>
            </ul>
        </div>
    </c:forEach>
    </div>
	</div>
	<input type="hidden" id="m_flag" value="5">
	<input type="hidden" value="采购,内勤" id="headship">
	<div style="height: 46px;">

	<button class="btn btn-primary btn-lg" id="allcheck" style="float: left;">全选</button>
	<button class="btn btn-primary btn-lg"  style="float: left;">确认通知采购和内勤</button>
	</div>
	<script type="text/javascript" src="../pc/js/gys/receiving.js${requestScope.ver}"></script>
</body>
</html>