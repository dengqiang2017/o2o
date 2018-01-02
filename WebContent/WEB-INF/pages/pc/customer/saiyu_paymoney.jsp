<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title> 
	<%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../pcxy/css/function.css"> 
    <script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/customer/paymoney.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>账户充值</li>
      </ol>
      <div class="header-title">客户-直接付款
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
		
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
			账户充值
		</div>
		<div class="box-body">
			<form action="alipay.do" method="post">
			<div class="pay-form">
				<span class="pay-label">充值单号</span>
				<input type="text" readonly="readonly" class="payinput" name="orderNo">
			</div>
			<div class="pay-form">
				<span class="pay-label">充值金额</span>
				<input class="payinput" name="amount" data-number="n" maxlength="15" type="tel">
			</div>
			<input type="hidden" name="attach">
			<input type="hidden" name="body">
			</form>
			<div class="pay-form">
				<span class="pay-label">充值日期</span>
				<input type="text" class="payinput" value="2015-10-13" readonly="readonly" id="time">
			</div>
			<div class="pay-form" id="account" style="display: none;">
				<span class="pay-label">账户类型</span>
				<div class="paycheck-ctn">
					<div class="paycheck-box">账上款
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box last">预存款
						<span class="glyphicon glyphicon-ok"></span>
					</div>
				</div>
			</div>
			<div class="pay-form" id="paystyle" style="display: none;">
				<span class="pay-label">结算方式</span>
				<div class="paycheck-ctn">
					<div class="paycheck-box">银联线下转账
						<span class="glyphicon glyphicon-ok"></span>
					</div> 
				</div>
			</div>
			<div class="pay-form" id="zftl">
				<span class="pay-label">支付通路</span>
				<div class="paycheck-ctn">
					<div class="paycheck-box">银联线下转账
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">银联线下代扣
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">银联在线支付
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">微信支付
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">QQ钱包
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">支付宝
						<span class="glyphicon glyphicon-ok"></span>
					</div>
					<div class="paycheck-box">其他
						<span class="glyphicon glyphicon-ok"></span>
					</div>
				</div>
			</div>
		</div>
      </div>
    </div>

    <div class="footer">
      客户:${sessionScope.customerInfo.user_id}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button type="button" class="btn btn-info">提交</button>
        <a href="../customer.do" class="btn btn-primary">返回</a>
      </div>
    </div>
</body>
</html>