<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>O2O营销服务平台</title> 
	<link rel="stylesheet" href="../pcxy/css/bootstrap.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="../pcxy/css/function.css"> 
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<link rel="stylesheet" href="../css/popUpBox.css">
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>运营商充值</li>
      </ol>
      <div class="header-title">运营商充值
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
		
	<div class="container" style="margin-bottom: 25px;">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
			运营商充值
		</div>
		<div class="box-body">
			<form action="alipay.do" method="post">
			<div class="pay-form">
				<span class="pay-label">充值单号</span>
				<input type="text" readonly="readonly" class="payinput" name="orderNo">
			</div>
			<div class="pay-form">
				<span class="pay-label">充值金额</span>
				<span style="font-size: 14px;color: red;">￥500.00/年</span>
				<input class="payinput" name="amount" value="500" readonly="readonly" type="hidden">
			</div>
			<input type="hidden" name="attach">
			<input type="hidden" name="body">
			</form>
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
			<div class="pay-form" id="zftl" style="display: none;">
				<span class="pay-label">支付通路</span>
				<div class="paycheck-ctn">
<!-- 					<div class="paycheck-box">第三方网银在线支付 -->
<!-- 						<span class="glyphicon glyphicon-ok"></span> -->
<!-- 					</div> -->
<!-- 					<div class="paycheck-box active">线下转账 -->
<!-- 						<span class="glyphicon glyphicon-ok"></span> -->
<!-- 					</div> -->
<!-- 					<div class="paycheck-box">银联线下代扣 -->
<!-- 						<span class="glyphicon glyphicon-ok"></span> -->
<!-- 					</div> -->
<!-- 					<div class="paycheck-box">银联在线支付 -->
<!-- 						<span class="glyphicon glyphicon-ok"></span> -->
<!-- 					</div> -->
					<div class="paycheck-box">微信支付
						<span class="glyphicon glyphicon-ok"></span>
					</div>
<!-- 					<div class="paycheck-box">支付宝 -->
<!-- 						<span class="glyphicon glyphicon-ok"></span> -->
<!-- 					</div>  -->
				</div>
			</div>
		</div>
      </div>
    </div>

    <div class="footer">
<%--       员工:${sessionScope.customerInfo.clerk_name}<span class="glyphicon glyphicon-earphone"></span> --%>
      <div class="btn-gp">
        <a href="../employee.do" class="btn btn-primary">返回首页</a>
      </div>
    </div>
    <script type="text/javascript" src="paymoney.js"></script>
</body>
</html>