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
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="达州创新家居电商平台主要经营家具,家居,沙发,茶几,桌子,装修">
    <meta name="keywords" content="家具,家居,沙发,茶几,桌子,装修">
    <title>个人中心</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/animate.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/modified_data.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
    <a href="personal_center.jsp" class="header_left">返回</a>
    编辑资料
</div>
    <div class="header" style="display: none;">
    <a onclick="$('#editName,.header:eq(1)').hide();$('#infopage,.header:eq(0)').show();" class="header_left">返回</a>
 <span id="modal_title" style="color: white;"></span>
</div>
</nav>
<div class="container">
    <div id="infopage" style="margin-top: 50px;">
		<div class="modified">
		    <ul>
		        <li>
		            <div class="modified-left">姓名</div>
		            <div class="modified-right">
		                <div class="left" id="customerName"></div>
		                <div class="right">
		                    <img src="images/backRight.png">
		                </div>
		            </div>
		        </li>
		        <li class="change_sex">
		            <div class="modified-left">性别</div>
		            <div class="modified-right">
		                <div class="left" id="sex"></div>
		                <div class="right">
		                    <img src="images/backRight.png">
		                </div>
		            </div>
		        </li>
		        <li>
		            <div class="modified-left">联系方式</div>
		            <div class="modified-right">
		                <div class="left" id="movtel"></div>
		                <div class="right">
		                    <img src="images/backRight.png">
		                </div>
		            </div>
		        </li>
		        <li onclick="window.location.href='addressManage.jsp'">
		            <div class="modified-left">收货地址</div>
		            <div class="modified-right">
		                <div class="left"></div>
		                <div class="right">
		                    <img src="images/backRight.png">
		                </div>
		            </div>
		        </li>
		    </ul>
		</div>
		<div class="side-cover">
		    <div class="amend_sex" onclick="event.cancelBubble = true">
		        <ul>
		            <li>修改性别</li>
		            <li style="border-top: 1px solid #dddddd">男</li>
		            <li>女</li>
		        </ul>
		    </div>
		</div>
		<div class="eidt" style="cursor: pointer;">退出当前账户</div>
    </div><div id="editName" style="display: none;margin-top: 50px;">
<div class="secition">
    <div class="name_input">
        <input type="text" placeholder="输入个人姓名">
        <span style="display: none;"></span>
    </div>
    <div class="name_input" style="display: none;">
        <input type="text" style="width: 100px;" id="codeinput" maxlength="4" disabled="disabled"><button type="button" class="btn btn-info" id="codebtn" disabled="disabled">获取验证码</button>
    </div>
    <div class="name_button">
        <button type="button" class="btn" id="saveName" disabled="disabled">保存</button> 
    </div>
</div>
</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="platformjs/swiper-3.3.1.jquery.min.js"></script>
<script type="text/javascript" src="platformjs/jquery.nicescroll.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/modified_data.js${requestScope.ver}"></script>
</body>
</html>