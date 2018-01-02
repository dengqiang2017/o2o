<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="electr">
<link rel="stylesheet" type="text/css" href="../pc/saiyu/repair-shishiyuyue.css${requestScope.ver}">
<div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;
用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span><span>预约电工</span></div>
<div  class="container-header" style="padding-bottom:10px">
<div class="container-header-center center-block" style="background-color:#FFFFFF">
    <input type="hidden" value="${requestScope.orderNo}" id="orderNo">
    <ul>
 	<li><label>安装费:</label><span id="confirm_je">${requestScope.confirm_je}</span><a class="btn btn-primary btn-sm" id="showMingxi" style="margin-left:10px">查看收费明细</a></li>
 	<li><label>联系人:</label><input type="text" value="${sessionScope.customerInfo.clerk_name}" id="lxr" style="width:177px"></li>
 	<li><label>联系人电话:</label><input type="tel" value="${sessionScope.customerInfo.user_id}" id="movtel" maxlength="11" data-num="num" style="width:177px"></li>
 	<li><label>安装地址:</label><input type="text" value="${requestScope.address}" id="address" style="width:177px"></li>
    <li><div class="pro-check" id="dgsfxz" style="float:left"></div><span style="line-height:30px;"><a>我已阅读附近电工收费标准</a></span><button type="button" class="btn btn-primary btn-sm" id="yqdg" style="margin-top:10px">邀请电工</button></li>
    <li><div id="yqdgxg" style="display: none;"><div class="pro-check" id="autoElec" style="float:left"></div><span>每5秒自动刷新</span>
    <button type="button" class="btn btn-primary btn-sm" id="refreshElec" style="margin-left:10px">刷新电工</button></div></li>
    </ul>
    </div>

<div class="center-dt" id="container"></div>
 <script charset="utf-8" src="../pc/js/saiyu/electricianNear.js${requestScope.ver}"></script>
</div>
    </div>