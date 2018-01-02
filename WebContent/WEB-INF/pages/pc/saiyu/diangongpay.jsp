<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/repair-diangong.css${requestScope.ver}">
<script type="text/javascript" src="../pc/js/saiyu/diangongpay.js${requestScope.ver}"></script>
<div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;
用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span><span>电工安装费支付</span></div>
        <div class="container-one">
        <input type="hidden" id="orderNo" value="${requestScope.orderNo}">
        <input type="hidden" id="dian_customer_id" value="${requestScope.dian_customer_id}">
          <div>预计附近电工总服务费用：<span id="azfy"></span>元</div>
<%--             <div>安装时间:<span id="anz_datetime">${requestScope.anz_datetime}</span></div> --%>
        	<div id="anz_orderlist" class="row"> 
        	</div>
	            <div id="an_item" style="display:none">
	            <div class="col-lg-4 col-sm-6 fl">
        		<div class="div-bg">
	            <ul>
	                <li>订单号：<span></span></li>
	                <li>产品名称：<span></span></li>
	                <li>数量:<span></span></li>
	                <li>安装单价:<span></span></li>
	            </ul>
	            </div>
	            </div>
	            </div>
<!--             <button type="button" class="btn btn-sm btn-primary center-block container-btn">在线咨询</button> -->
<!--             <div class="text-center fl" style="margin-top: 20px">如有异议可以点击在线咨询了解详情</div> -->
            <div class="clear"></div>
        </div>
        <c:if test="${requestScope.type!='info'}">
        <button type="button" class=" btn btn-primary center-block footer2">立即支付安装费</button>
        </c:if>
        <c:if test="${requestScope.type=='info'}">
        <button type="button" class="btn btn-primary" onclick='javaScript:backlist();'>返回</button>
        </c:if>
<div class="process-zz">
    <ul>
        <li>
            <div class="zf center-block"><span>微信支付</span>
                <div class="dw">
                    <img class="img-responsive" src="../process-images/gou.png">
                </div>
             </div>
        </li>
        <li>
            <div class="zf center-block"><span>线下支付</span>
                <div class="dw">
                    <img class="img-responsive" src="../process-images/gou.png">
                </div></div>
        </li>
    </ul>
</div>