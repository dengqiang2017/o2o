<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<title>O2O营销服务平台</title>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<link rel="stylesheet" href="/pcxy/css/bootstrap.css?ver=001">
<link rel="stylesheet" href="/pcxy/css/global.css?ver=007">
<link rel="stylesheet" href="/css/popUpBox.css?ver=001">
<link rel="stylesheet" href="/pcxy/css/word.css">
<script type="text/javascript" src="/js_lib/jquery.11.js"></script>
<script type="text/javascript" src="/js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="/js_lib/jquery.jqprint.js"></script>
<script type="text/javascript" src="/js_lib/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="/pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/js/common.js?ver=002"></script>
<script type="text/javascript" src="/js/popUpBox.js?ver=002"></script>
<script type="text/javascript" src="/pc/js/customer/iou.js"></script>
<script type="text/javascript" src="/jSignature/jSignature.min.js"></script>
</head>
<body>
<div class="container" style="padding:20px;" >
		<button type="button" class="btn-default" id="print">打印</button>
		<button type="button" class="btn-default" id="confirmIou">确认欠条</button>
		<button type="button" class="btn-default" onclick="javascript:history.go(-1);">放弃欠条</button>
		<div id="printdiv">
		<h2>${sessionScope.systemName}公司客户赊欠条（代客户欠条）</h2>
		<div class="letter-head"><span class="space-lg">${sessionScope.systemName}</span>有限公司：</div>
		<p class="content">客户<span class="space-lg customerName"></span>于<span class="space-sm date"></span>
		向贵公司购买板材，因资金周转等原因，特向贵公司申请赊欠。本次欠款计&yen;
		<span id="ddje" class="space-lg"></span>元，
		人民币大写：<span id="ddje_dx" class="space-sm"></span>。
<!-- 		您的累计欠款为&yen;<span id="ljqk" class="space-lg">0</span>元。 -->
		</p>
		<ul class="msg-sm">
			<!-- <li>订单号:<span id=""></span></li> -->
<!-- 			<li>承运人:<span id="Kar_Driver"></span></li> -->
<!-- 			<li>车牌号:<span id="Kar_paizhao"></span></li> -->
			<li>立据人:<span class="customerName"></span></li>
			<li class="last">日期:<span class="date"></span></li>
		</ul>
		<div class="write-box">
			<p>客户在线签字</p>
			<img src="">
			<div id="signature" style="height: 300px;"></div>
		</div>
		<button type="button" onclick="$('#signature').jSignature('clear')" id="clear">清除</button>
		<div id="orderlist" style="display: none;" title="订单号"></div>
		</div>
</div>
</body>
</html>