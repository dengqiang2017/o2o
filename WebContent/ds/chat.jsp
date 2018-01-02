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
    <title>与客服交谈中</title>
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/chat.css${requestScope.ver}">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="css/lightbox.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
<a onclick="javascript:history.back();" class="header_left">返回</a>
	与客服交谈中
</div>
</nav>
<div class="container">
    <div class="chat_box clearfix">
        <ul id="list" class="clearfix"></ul><span id="msg_end" style="overflow:hidden"></span>
    </div>
    <div id="chat_right" style="display: none;">
      <li class="clearfix">
          <div class="chat_right">
          <div class="word" style="display:  ;"></div>
          <div class="tp_left" style="display: none;"></div>
          <div class="pic">
               <img src="images/portrait.png">
          </div>
          </div>
      </li>
    </div>
    <div id="chat_left" style="display: none;">
      <li class="clearfix">
          <div class="chat_left">
          <div class="pic">
              <img src="images/service.png">
          </div>
          <div class="word word_left">你好</div>
          <div class="tp_left" style="display: none;"></div>
          </div>
      </li>
    </div>
<!--     <div class="footer clearfix"> -->
<!--     </div> -->
    
<nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="col-xs-10 col-md-9">
            <div class="chat" contenteditable="true"></div>
        </div>
        <div class="col-xs-2 col-md-3">
            <div class="footer_pic clearfix">
                <img src="images/addpl.png" style="width: 35px;">
                <a class="head_portrait_amend" style="display: none;" id="scxq"></a>
                <a class="head_portrait_amend" id="upload-btn">
                    <input type="hidden" name="typeImg" id="filePath">
                    <input type="file" class="ct input-upload" name="imgFile" id="imgFile" onchange="imgUpload(this);">
                </a>
                <button type="button" class="btn btn-success" id="send" style="display: none;">发送</button>
            </div>
        </div>
</nav>
    </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/lightbox.js"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/chat.js${requestScope.ver}"></script>
</body>
</html>