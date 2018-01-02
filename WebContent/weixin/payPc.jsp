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
    <title>订单跳转</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="contant.css">
    <link rel="stylesheet" href="pay_skipPC.css">
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
    if(is_weixin()){
    	window.location.href=window.location.href.replace("payPc", "pay");
    }
    //-->
    </script>
</head>
<body>
    <div class="container">
        <div class="a_box">
        <a onclick="javascript:history.back();">返回</a>
        </div>
        <div class="contant">
           <div class="contant_title">创新家居收银台</div>
            <div class="contant_word">
                <ul>
                    <li class="clearfix">
                        <div class="pull-left">订单编号 ：<span id="orderNo"></span></div>
                        <div class="pull-right">应付金额 ：￥<span id="total_fee"></span></div>
                    </li>
                    <li class="clearfix">
                        <div class="pull-left" >产品名称 ：<span id="body"></span></div>
                        <div class="pull-right" >收款方 ：<span id="attach"></span></div>
                    </li>
                </ul>
            </div>
            <div class="contant_pay">
                <div class="left">
                    <div class="pic">
                        <img src="weixin.png">
                    </div>
                    <div class="word">
                        微信支付
                    </div>
                </div>
                <div class="right">
                    支付<span id="totalFee">98.50元</span>
                </div>
            </div>
            <div class="code_box" id="shaoma">
                <div class="code center-block"><img style="width:100%"></div>
                <div class="code_bottom center-block">
                    <div class="code_bottom_pic">
                        <img src="scan.png">
                    </div>
                    <div class="code_bottom_word">
                        请使用微信扫一扫<br>扫描二维码完成订单
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
<!--
	document.write("<script src='pay.js?ver="+Math.random()+"'><\/script>");
//-->
</script>
</body>
</html>