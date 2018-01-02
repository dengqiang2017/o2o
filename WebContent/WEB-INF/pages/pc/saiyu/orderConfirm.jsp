<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../pc/css/orderpay.css${requestScope.ver}">
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/customer/clientOrder2.js${requestScope.ver}"></script>
</head>
    <style>
        ul>li{
        list-style:none;
    }
    ul{
        padding-left:0;
    }
    .img{
    width:118px;
    height:118px;
    }
    .img>img{
    width:100%;
    height:100%;
    }
    .ul-one>li{
    padding:10px 0;
    }
    .leavemsg>textarea{
    width:100%;
    height:100px;
    }
    @media(max-width:770px){
    .img{
    width:300px;
    height:300px;
    }
    }
    </style>
<body>
<div class="bg"></div>
<div class="header">
  <ol class="breadcrumb">
    <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
    <li><span class="glyphicon glyphicon-triangle-right"></span>订单支付</li>
  </ol>
  <div class="header-title">客户-订单支付
    <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
  </div>
  <div class="header-logo"></div>  
</div>
	<input type="hidden" value="1" id="settlementModal">
<div class="container">
    <div class="ctn-fff" style="position: relative;">
        <div class="payorderctn" style="margin-top:30px">
            <div class="pro-list">
                <ul></ul>
                <div style="display: none;" id="liitem">
                    <li>
                    <div class="col-lg-2">
                        <div class="imgk">
                    <div class="img"><img src="image/function-01.png" alt=""></div>
                        </div>
    </div>
    <div class="col-lg-4">
                        <div class="wzk">
                            <ul class="ul-one">
                                <li><span style="margin-right: 10px">名称：</span><span class="msg"></span></li>
                                <li><span style="margin-right: 10px">单价:</span><span id="sd_unit_price"></span></li>
                                <li style="height:30px">
                                    <div class="p-form" style="">
                                        <label for="" style="float: left;margin-top: 6px;margin-right: 10px">数量</label>
                                        <div class="num-input-xs" style="height: 30px;float: left;border: 1px solid #ddd">
                                            <span class="sub" style="width: 25px;height: 30px;float: left;text-align: center;line-height: 30px;border-right:1px solid #ddd ">-</span>
                                            <span class="add" style="width: 25px;height: 30px;float: right;text-align: center;line-height: 30px;border-left:1px solid #ddd ">+</span>
                                            <input type="text" class="num" id="pronum" data-number="n" style="text-align:center;height:100%">
                                        </div>
                                        <span class="p-content-xs" id="casing_unit"></span>
                                    </div>
                                </li>
                                <li style="display:none"><span style="margin-right: 10px">规格：</span><span></span></li>
                                <li style="display:none"><span style="margin-right: 10px">型号：</span><span></span></li>
                            </ul>
                        </div>
    </div>
                    <input type="hidden" id="ivt_oper_listing">
                    <input type="hidden" id="seeds_id">
                    <input type="hidden" id="item_id">
                    <img src="../pc/images/add.png" alt="删除" style="position: absolute;right: 5px;top:5px;cursor: pointer;">
                </li>
                </div>
            </div>
            <div class="clear" style="clear:both"></div>
        </div>
        <div class="payorderctn" style="width: 93%;margin-top: 40px;margin-left:6px">
            <div class="title">发货地址</div>
            <div class="leavemsg">
                <textarea name="FHDZ">成都市创业路5号</textarea>
            </div>
        </div> 
        <div class="payorderctn" style="width: 93%;margin-top: 40px;margin-left:6px">
            <div class="proprice">
                <ul>
                    <li><span class="left">商品金额:&nbsp;&nbsp;</span><span class="right">14000.00</span></li>
                    <li><span class="left">优惠券:&nbsp;&nbsp;</span><span class="right">¥0.00</span></li>
                    <li><span class="left">运费:&nbsp;&nbsp;</span><span class="right">¥0.00</span></li>
                    <li><span class="left">实付款:&nbsp;&nbsp;</span><span class="right">14000.00</span></li>
                </ul>
            </div>
<h4 style="color:#4b77be;">截止<span id="nowdate"></span>，您累计的应收款为<span id="ysk">0.00</span>元，账户余额为<span id="zhye">0.00</span>元。 <a target="_blank" href="accountStatement.do" class="btn btn-danger">查看对账单</a></h4>
        </div>
    </div>
</div>
<!-- ///////////////////////////////////////////////////////////////////////////////////////////////// -->
<div class="modal-cover"></div>
<div class="modal" style="display:none; top: 10%;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">提示</h4>
			</div>
			<div class="modal-body" style="max-height:240px; overflow-y:scroll;">
				<p>您的账户余额为&yen;<span id="mzhye">0</span>
					<br>本次支付金额为&yen;<span id="mzje">0</span>
					<br>由于余额不足，不能继续支付！</p>
			</div>
			<div class="modal-footer"  style="text-align:center;">
			<c:if test="${sessionScope.customerInfo.ifUseCredit=='是'}">
				<a href="iou.do" class="btn btn-danger">打欠条</a>
			</c:if>
				<a href="paymoney.do?order" id="paymoney" class="btn btn-danger">去支付</a>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog  javascript:history.go(-1); -->
</div><!-- /.modal -->

<div class="footer">
    <div class="btn-gp">
      <a class="btn btn-info">提交</a>
      <a class="btn btn-primary" href="../pc/product.html">返回</a>
    </div>
客户:${sessionScope.customerInfo.clerk_name}
<input type="hidden" value="${sessionScope.customerInfo.clerk_name}" id="customerName">
<input type="hidden" value="${sessionScope.customerInfo.ifUseCredit}" id="ifUseCredit">
 </div>
</body>
</html>