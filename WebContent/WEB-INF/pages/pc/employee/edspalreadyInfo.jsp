<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title> 
	<%@include file="../res.jsp" %>
	<link rel="stylesheet" href="css/product.css">
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="myOA.do">我的协同</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>协同流程详细</li>
		</ol>
		<div class="header-title">员工协同流程详细
			<a href="myOA.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div> 
	</div>

	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<ul class="sim-title">
		            <li class="col-xs-3">发起人</li>
		            <li class="col-xs-3">发起时间</li>
		            <li class="col-xs-3">发起事项</li>
		            <li class="last col-xs-3">金额</li>
		        </ul>
				<ul class="sim-msg">
		            <li class="col-xs-3">林氏木业家具有限公司</li>
		            <li class="col-xs-3">2015-08-05</li>
		            <li class="col-xs-3">使用额度</li>
		            <li class="last col-xs-3">&yen;150000.00元</li>
		        </ul>
			</div>
			<div class="box-body">
				<h5>审批记录</h5>
				<div class="alert alert-success">
					<div class="panel-body" style="overflow:hidden;">
						<div class="col-sm-2 m-t-b" style="font-weight:700;">市场经理李四</div>
						<div class="col-sm-2 m-t-b" style="font-weight:700;">同意</div>
						<div class="col-sm-6 m-t-b"></div>
						<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;">2015-08-03</div>
					</div>
				</div>
				<div class="alert alert-success">
					<div class="panel-body" style="overflow:hidden;">
						<div class="col-sm-2 m-t-b" style="font-weight:700;">市场经理李四</div>
						<div class="col-sm-2 m-t-b" style="font-weight:700;">同意</div>
						<div class="col-sm-6 m-t-b">经审核，该客户符合申请&yen;150000.00元额度款的条件，本人同意该客户的申请！</div>
						<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;">2015-08-03</div>
					</div>
				</div>
				<div class="alert alert-success">
					<div class="panel-body" style="overflow:hidden;">
						<div class="col-sm-2 m-t-b" style="font-weight:700;">市场经理李四</div>
						<div class="col-sm-2 m-t-b" style="font-weight:700;">同意</div>
						<div class="col-sm-6 m-t-b">经审核，该客户符合申请&yen;150000.00元额度款的条件，本人同意该客户的申请！</div>
						<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;">2015-08-03</div>
					</div>
				</div>
				<div class="alert alert-success">
					<div class="panel-body" style="overflow:hidden;">
						<div class="col-sm-2 m-t-b" style="font-weight:700;">市场经理李四</div>
						<div class="col-sm-2 m-t-b" style="font-weight:700;">同意</div>
						<div class="col-sm-6 m-t-b">经审核，该客户符合申请&yen;150000.00元额度款的条件，本人同意该客户的申请！</div>
						<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;">2015-08-03</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
	</div>
</body>
</html>