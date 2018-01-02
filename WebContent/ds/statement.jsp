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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>对账单</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <style type="text/css">
    .navbar-fixed-bottom span{font-size: 14px;}
    .col-xs-12{border-bottom: 1px solid aqua;font-family: 'Microsoft YaHei',Arial,Helvetica,sans-serif;}
    @media (max-width: 758px) {
    .col-xs-12 .col-xs-1{margin-left: -8px;}
    .col-xs-12 .col-xs-9{padding-left: 10px;}
    .col-xs-12 div{font-size:16px;}
    .col-xs-12 img{width: 30px;height: 30px;margin-top: 5px;margin-right: 5px;}
    .Wdate,#if_check{width: 140px;display: inline-block !important;}
    .form-group{margin-bottom: 10px;}
     .find{margin-left: 30px;}
    }
    @media (min-width: 759px) {
     .find{margin-left: 10px;}
    .col-xs-12 img{width: 40px;height: 40px;}
    .col-xs-12{border-left: 1px solid aqua;}
    }
    </style>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header-phone">
			<a href="personal_center.jsp" class="header_left">返回</a>对账单
		</div>
	</nav>
	<div class="container" style="margin-top: 50px;">
	<span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
	<form class="form-inline">
  <div class="form-group">
    <label for="exampleInputName2">日期</label>
	<input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate">
	<input type="date" id="d4312" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
  </div>
    <div class="form-group">
  <label>状态</label>
  <select id="if_check" class="form-control input-sm">
  <option value="">全部</option>
  <option value="未对账">未对账</option>
  <option value="已对账">已对账</option>
  </select>
  <button type="button" class="btn btn-info find">搜索</button>
  </div>
</form>
		<div id="list">
		</div>
		<div id="item" style="display: none;">
			<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
			<span style="display: none;" id="seeds_id"></span>
			<span style="display: none;" id="no"></span>
			<div class="col-xs-2 col-sm-2 col-md-1">
			<div id="date">06-20</div>
			</div>
			<div class="col-xs-1 col-sm-2 col-md-1">
			<img src="images/money.png">
			</div>
			<div class="col-xs-9 col-sm-8 col-md-10">
			<div style="font-size: 16px;">￥<span id="ysje">0</span>&emsp;结余:￥<span id="jyje">0</span></div>
			<div><span id=type></span><input type="checkbox" style="float: right;"></div>
			</div>
			<div class="clearfix"></div>
			</div>
		</div>
	</div>
<nav class="navbar navbar-default navbar-fixed-bottom" style="padding-top: 10px;">
<div class="col-xs-4 col-sm-4 col-md-4">
<span>总金额:</span><span style="color: #E0342F;">¥<span id="zje">0</span></span>
</div>
<div class="col-xs-4 col-sm-4 col-md-4">
<span>实付款:</span><span style="color: #E0342F;">¥<span id="sfk">0</span></span>
</div>
<div class="col-xs-4 col-sm-4 col-md-4">
<span>应付款:</span><span style="color: #E0342F;">¥<span id="yfk">0</span></span>
</div>
<div class="clearfix"></div>
<div style="text-align: center;margin: 10px;">
<a class="btn btn-info" href="payList.jsp">付款</a>
<button type="button" class="btn btn-info" id='qianzi'>确认账单</button>
</div>
</nav>
	<div class="modal" id="mymodal2">
	<div class="modal-dialog" style="height:100%;margin:0;width:100%">
	<div class="modal-content" style="margin-top: 100px;">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	<h4 class="modal-title">确认无误在此签字确认</h4>
	</div>
	<div class="modal-body">
		<div id="qianzi">
		<img src="" style="width: 100%;height: 230px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px;display: none;">
		<div id="signature"  style="width: 100%;height: 300px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px"></div>
		<button class="btn btn-success pull-right btnsize" >提交</button>
		<button type="button" class="btn btn-success pull-right" onclick="$('#signature').jSignature('clear')" id="clear">清除</button>
		<a class="btn btn-default gbi" data-dismiss="modal">关闭</a>
		<div style="clear:both"></div>
		</div>
	</div>
	</div>
	</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../jSignature/jSignature.min.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/statement.js${requestScope.ver}"></script>
</body>
</html>