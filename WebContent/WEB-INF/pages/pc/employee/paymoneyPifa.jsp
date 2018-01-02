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
    <script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/employee/paymoney.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售收款单</li>
      </ol>
      <div class="header-title">员工-销售收款单
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
<%@include file="selClient.jsp" %>		
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
		<%@include file="showSelectClient.jsp" %>
		<input type="hidden" id="customer_id"> 
		</div>
		<div class="box-body">
			<form action="alipay.do" method="post">
					<div class="pay-form">
						<span class="pay-label">充值单号</span>
						<input type="text" readonly="readonly" class="payinput" name="orderNo">
					</div>
					<div class="pay-form">
						<span class="pay-label">充值金额</span>
						<input class="payinput" name="amount" data-number="n" maxlength="10" type="tel">
					</div>
					</form>
					<div class="pay-form">
						<span class="pay-label">充值日期</span>
						<input type="text" class="payinput" value="2015-10-13" readonly="readonly" id="time">
					</div>
					<div class="pay-form" id="account">
						<span class="pay-label">账户类型</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box active">账上款
								<span class="glyphicon glyphicon-ok"></span>
							</div>
						</div>
					</div>
					<div class="pay-form" id="paystyle">
						<span class="pay-label">结算方式</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box active">银联线下转账
								<span class="glyphicon glyphicon-ok"></span>
							</div> 
						</div>
					</div>
					<div class="pay-form" id="zftl">
						<span class="pay-label">支付通路</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box active">其他
								<span class="glyphicon glyphicon-ok"></span>
							</div>
						</div>
					</div>
					
				
			
			
		</div>
      </div>
    </div>

    <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button type="button" class="btn btn-info">提交</button>
        <a href="JavaScript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
    </div>
</body>
</html>