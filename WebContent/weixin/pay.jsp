<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="达州创新家居电商平台主要经营家具,家居,沙发,茶几,桌子,装修">
    <meta name="keywords" content="家具,家居,沙发,茶几,桌子,装修">
	<title>订单支付</title>
	<link href="../pcxy/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="contant.css">
    <link rel="stylesheet" href="pay_skip.css?ver=001">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="font-awesome.min.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
	<script src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript">
    <!--
	    function IsPC(){
	        var userAgentInfo = navigator.userAgent;  
	        var Agents = new Array("Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod");    
	        var flag = true;    
	        for (var v = 0; v < Agents.length; v++) {    
	            if (userAgentInfo.indexOf(Agents[v]) > 0) { flag = false; break; }    
	        }    
	        return flag;
	     } 
	    if(!is_weixin()){
	    	window.location.href=window.location.href.replace("pay", "payPc");
	    }
    //-->
    </script>
</head>
<body>
<!------ 支付头部-------->
<div class="header">
    <a onclick="javascript:history.back();" class="header_left">返回</a>
</div>
<div class="contant">
    <div class="order">订单编号 <span id="orderNo"></span></div>
    <div class="money">￥<span id="total_fee"></span></div>
    <ul>
        <li class="clearfix">
            <div class="pull-left">收款方</div>
            <div class="pull-right" id="attach"></div>
        </li>
        <li class="clearfix">
            <div class="pull-left">产品名称</div>
            <div class="pull-right" id="body"></div>
        </li>
    </ul>
    <img style="display: none;">
</div>
<script type="text/javascript">
<!--
	document.write("<script src='pay.js?ver="+Math.random()+"'><\/script>");
//-->
</script>
</body>
</html>