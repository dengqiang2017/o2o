<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.qianying.controller.BaseController" %>
<%
	JSONObject json=BaseController.getHtmlContentByUrl(request);
%>
<!Doctype html>
<html>
<head>
<meta charset="utf-8">
<title><%=json.getString("title")%></title>
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="<%=json.getString("gjc")%>">
<link rel="stylesheet" href="cms/css/global.css">
<link rel="stylesheet" href="cms/css/font-awesome.min.css">
<link rel="stylesheet" href="cms/css/information_detail.css">
<script src="cms/js/jquery.js"></script><script src="../js_lib/jquery.cookie.js"></script> 
</head>
<body>
<div style="display: none;">
<img  style="width: 500px;height: 500px;" alt="" width="700" src="<%=json.getString("poster")%>">
</div>
<div class="main_title_container">
	<div class="main_title_ctn">
    	<div class="main_title textonly">口碑</div>
    	<input id="type" value="3" type="hidden">
    </div>
</div>    
<div class="divider"></div>
<div class="main_content_container">
	<div class="main_content_ctn articledetail">
    	<div class="information_detail_title articleedit_title"><%=json.getString("title")%></div>
        <span class="information_detail_date articleedit_time">发布时间:<%=json.getString("releaseTime")%></span>
        <span class="information_detail_date articleedit_author">发布人:<%=json.getString("publisher")%></span>
         <div id="fenxiang"></div>
<!--           onerror="$(this).hide();" -->

        <div class="information_detail articleedit_content">
          <%=json.getString("line")%>
        </div>
        <br>
        <br>
          <video  controls="controls" src="<%=json.getString("img")%>"
          height="400" width="480" preload="none"
           poster="<%=json.getString("poster")%>"></video>
	</div>
</div> 
<div id="back-to-top"></div>
<div class="side_tools logo_container"></div>
<script type="text/javascript" src="cms/js/headn.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js"></script>
<script type="text/javascript">
<!--
$(function(){
	weixinShare.init("<%=json.getString("title")%>","<%=json.getString("title")%>");
});
//-->
</script>
</body>
</html>
