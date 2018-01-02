<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>订单支付</title>
<link href="../pcxy/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="../pcxy/css/global.css">
<link rel="stylesheet" href="../pcxy/css/lr.css">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<link rel="stylesheet" href="../css/popUpBox.css">
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js"></script>
</head>
<body>
	<div id="shaoma">
	<ul>
	<li>订单编号:<span id="orderNo"></span></li>
	<li>订单金额:<span id="total_fee"></span></li>
	<li>支付类型:<span id="attach"></span></li>
	<li>支付信息:<span id="body"></span></li>
	</ul>
	<img style="display: none;">
	</div>
	<a onclick="javascript:history.back();">返回</a>
	<br> 
<script type="text/javascript">
<!--
	document.write("<script src='pay.js?ver="+Math.random()+"'><\/script>");
//-->
</script>
</body>
</html>
