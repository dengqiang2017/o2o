<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getVer(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="达州创新家居电商平台主要经营家具,家居,沙发,茶几,桌子,装修">
    <meta name="keywords" content="家具,家居,沙发,茶几,桌子,装修">
    <title>订单确认</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/pay.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
	<style type="text/css">
	#yhq{
	color: red;
	}
	#yhq span{
	color: red;
	}
	</style>
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
    <div class="container">
        <div id="paypage" style="margin-top: 50px;">
<nav class="navbar navbar-default navbar-fixed-top">
 <div class="header">
                <a id="fanhui" class="header_left">返回</a>
                订单确认
            </div>
</nav>
            <div class="pay_list">
                <ul>
                    <li>
                        <div class="pay_list_left">订单编号 ：</div>
                        <div class="pay_list_right" id="orderNo"></div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position: relative;cursor: pointer" id="addr">
                        <div class="pay_list_top">
                             <div class="left">收货人 ：<span id="lxr"></span></div>
                             <div class="right"><span id="lxPhone"></span></div>
                        </div>
                        <div class="pay_list_bottom">
                           	 收货地址 ：<span id="fhdz"></span>
                        </div>
                        <i class="fa fa-angle-right" aria-hidden="true"></i>
                    </li>
                    <li>
                    <div style="font-size: 14px;">金币&ensp;共<span id="totalJinbi">0</span>金币,可用
                    <span id="keyong">0</span>金币<input type="checkbox" id="usejinbi" style="width: 20px;height: 20px;margin-left: 20px;"></div>
                    <div id="jinbidiv" style="font-size: 14px;display: none;">使用<select id="shiyongjinbi">
                    </select>金币,抵扣 ￥<span id="dikou">10.00</span></div>
                    </li>
                    <li style="height: 40px;cursor: pointer;" id="yhq">
                    <span class="pull-left" style="font-size: 16px;">优惠券</span>
                    &emsp;&emsp;-<span id="yhqAmount">0</span>
                    <span class="glyphicon glyphicon-chevron-right pull-right" style="color: aqua;font-size: 14px;"></span>
                    <span id="yhqNo" style="display: none;"></span>
                    <span id="yhqId" style="display: none;"></span>
                    </li>
                    <li>
                        <div class="pay_list_left" style="margin-top: 2px">总金额 ：</div>
                        <div class="pay_list_right">￥<span id="sum_si"></span></div> 
                        <div class="clearfix"></div>
                    </li>
                    <li style="padding: 15px 10px" id="weixinpay">
                        <div class="pull-left">
                            <div class="pic">
                                <img src="images/weixin.png">
                            </div>
                            <div class="word">
                                <div class="word_top">微信支付</div>
                                <div class="word_bottom">使用微信支付，安全便捷</div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="pull-right">
                        	<div class="check">
                           		<span class="fa fa-check-circle active" aria-hidden="true"></span>
                        	</div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="padding: 15px 10px;display: none;">
                        <div class="pull-left">
                            <div class="pic">
                                <img src="images/yinlian.png">
                            </div>
                            <div class="word">
                                <div class="word_top" style="margin-top: 12px">银联支付</div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="pull-right"><div class="check">
                            <span class="fa fa-check-circle" aria-hidden="true"></span>
                        </div></div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="padding: 15px 10px">
                        <div class="pull-left">
                            <div class="pic">
                                <img src="images/hdfk.png">
                            </div>
                            <div class="word">
                                <div class="word_top" style="margin-top: 12px">货到付款</div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="pull-right"><div class="check">
                            <span class="fa fa-check-circle" aria-hidden="true"></span>
                        </div></div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="border-bottom: none">
                        <button type="button" class="btn btn-success btn-style center-block">确认支付</button>
                    </li>
                </ul>
                <form action="../customer/alipay.do" style="display: none;">
                    <div class="pay-form">
                        <span class="pay-label">付款单号</span>
                        <input type="text" readonly="readonly" class="orderNo" name="orderNo">
                    </div>
                    <div class="pay-form">
                        <span class="pay-label">付款金额</span>
                        <input class="payinput amount" name="amount" data-number="n" maxlength="15" type="tel">
                    </div>
                    <input type="hidden" name="attach">
                    <input type="hidden" name="body">
                </form>
            </div>
        </div>
        <div id="infopage" style="display: none;">
        <nav class="navbar navbar-default navbar-fixed-top">
        <div class="header">
            <a onclick='$("#infopage").hide();$("#paypage").show();' class="header_left">返回</a>
            选择收货地址
            <a href="addressManage.jsp" class="header_right">管理</a>
        </div>
        </nav>
        <div class="secition" style="margin-top: 50px;">
            <ul>
                
            </ul>
        </div>
        <div id="liitem" style="display: none;">
        <li>
                    <div class="manage_top">
                        <div class="name"></div>
                        <div class="cell"></div>
                    </div>
                    <div class="manage_center">
                        <div class="site"></div>
                    </div>
                    <div style="display: none"><input type="checkbox" id="mr"></div>
                </li>
        </div>
    </div><div id="selectYhq" style="display: none;">
    <nav class="navbar navbar-default navbar-fixed-top">
    	<div class="header">
				<a onclick="javascript:$('#selectYhq').hide();$('#paypage').show();" class="header_left">返回</a>
				使用优惠券(<span id="count" style="color: white;">0</span>)
			</div>
    </nav>
			<div class="contant" style="margin-top: 50px;">
			
			</div>
			<div id="item" style="display: none;">
				<div class="col-xs-12 col-md-12 col-lg-12 yhq" style="height: 80px; border: 1px solid #F00;">
					<div class="col-xs-3 col-md-3 col-lg-3" style="height: 100%; background-color: #337ab7; color: white; padding: 5px;">
						<div style="text-align: center;color: white; ">
							￥<span style="font-size: 20px;color: white; " id="f_amount">5</span>
						</div>
						<div style="font-size: 10px; padding-top: 5px;color: white; ">
							满<span id="up_amount" style="font-size: 10px;color: white; ">100</span>元可用
						</div>
					</div>
					<div class="col-xs-9 col-md-9 col-lg-9">
						<div style="padding-top: 10px;font-size: 14px;">
							仅可购买<span id="type_name" style="font-size: 14px;">芝华士</span>商品
						</div>
						<div id="type_id" style="display: none;"></div>
						<div style="padding-top: 5px">
							<span style="font-size: 10px;"> <span id="f_begin_date" style="font-size: 10px;">2017.04.05</span>~<span id="f_end_date" style="font-size: 10px;">2017.05.05</span>
							</span> <span></span>
							<a class="btn btn-info btn-xs pull-right" id="use">立即使用</a>
						</div>
					</div>
					<div style="display: none;" id="ivt_oper_listing"></div>
					<div style="display: none;" id="seeds_id"></div>
				</div>
			</div>
    </div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/pay.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/usecoupon.js${requestScope.ver}"></script>
</body>
</html>