<%@page import="com.qianying.controller.BaseController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BaseController.getVer(request);
BaseController.setDescriptionAndKeywords(request);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="${requestScope.systemName},供应商登录">
<meta name="description" content="${requestScope.systemName}-供应商登录">
<title>供应商登录-${requestScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/signup.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="container">
		<div class="header">
			<div class="logo">
				<img src="image/logo.png${requestScope.ver}" alt="">
			</div>
			<div style="text-align: center;">供应商登录</div>
		</div>
		<div class="main">
		<div class="input-group" style="display: none;">
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<select style="display: none;"></select>
					<input type="tel" placeholder="请先输入您的运营商编码" name="com_id" maxlength="11">
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp01.png" alt=""></div>
				<div class="input">
					<input type="text" name="user_id" id="username" placeholder="请输入手机号"  maxlength="11" data-num="num">
				</div>
			</div>
			<div class="input-group">
				<div class="label"><img src="../pcxy/image/signp02.png" alt=""></div>
				<div class="input">
					<input type="password" placeholder="输入密码"  name="user_password" id="pwd" maxlength="20">
				</div>
			</div>
			<a href="forgetpsw.html?type=2" style="display: none; font-size:14px; margin-left:10px; color:#646464;">忘记密码</a>
			<span class="tips"></span>
			<div class="signup-btn" id="loginSupplier">登录</div>
			<div class="signup-btn-light"><a href="../login/register.do?type=Supplier" style="float: left;width: 100%;">没有账号，立即注册</a></div>
<!-- 			<div class="signup-btn-light"><a href="index.html" style="float: left;width: 100%;">返回首页</a></div> -->
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/login.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
$(function(){
	weixinShare.init("${requestScope.systemName}","${requestScope.systemName}-供应商登录");
	login.init("loginSupplier","../supplier/login.do","../supplier/supplier.do","supplier",function(){
		var com_id=$("input[name='com_id']");
		var comid=$.cookie("suppliercom_id");
		if(comid){
		com_id.val(comid);
		$("select").val(comid);
		}
		com_id.bind("change",function(){
			var comId=$("select option[value='"+$.trim($(this).val()) + "']").val();
			if($.trim($(this).val())==""||!comId){
				if(!comId){
					pop_up_box.showMsg("运营商不存在,请重新输入!", function(){
						$("input[name='com_id']").val("");
						$("input[name='com_id']").focus();
					});
				}
			}else{
				$("select").val($(this).val());
			}
		});
	});
});
//-->
</script>
</body>
</html>