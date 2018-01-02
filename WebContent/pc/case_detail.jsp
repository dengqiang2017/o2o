<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.qianying.controller.BaseController" %>
<%
	JSONObject json=BaseController.getHtmlContentByUrl(request);
%>
<!Doctype html>
<html><head>
<meta charset="utf-8">
<title><%=json.getString("title")%></title>
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="">
<link rel="stylesheet" href="cms/css/global.css">
<link rel="stylesheet" href="cms/css/font-awesome.min.css">
<link rel="stylesheet" href="cms/css/case_detail.css">
<script src="cms/js/jquery.js"></script> <script src="../js_lib/jquery.cookie.js"></script> 
</head>
<body>
<div class="main_title_container">
	<div class="main_title_ctn">
    	<div class="main_title textonly">案例</div>
    	<input id="type" value="2" type="hidden">
    </div>
</div>    
<div class="divider"></div>
<div class="main_content_container">
	<div class="main_content_ctn articledetail">
    	<div class="case_detail_title articleedit_title"><%=json.getString("title")%></div>
    	<span class="case_detail_date articleedit_time">发布时间:<%=json.getString("releaseTime")%></span>
    	<span class="case_detail_date articleedit_author">发布人:<%=json.getString("publisher")%></span>
		<div id="fenxiang"> </div>
     	<div class="img"> 
    	<img id="imgvideo" src="<%=json.getString("img")%>" alt="" onerror="$(this).remove();">
             <video style="display: none;" src="<%=json.getString("img")%>" controls="controls" height="400" width="480" onerror="$(this).remove();"></video>  
    	</div> 
        <div class="case_detail_content articleedit_content">
        <%=json.getString("line")%>
        </div>
    </div>
</div>
 
<div id="back-to-top"></div>
<div class="side_tools logo_container"></div>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="cms/js/head.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js"></script>
<script type="text/javascript">
<!--
$(function(){
	var img=$(".img").find("img").attr("src");
if(img==""){
	$(".img").hide();
}
if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(img)){
// 	$(".img").find("img").show();
	$(".img").find("video").hide();
	$(".img").hide();
}else{
	$(".img").find("video").show();
}
	var imgsrc=$(".minute-container img")[0].src;
if(!imgsrc){
	imgsrc=$("img")[0].src;
}
	weixinShare.init("<%=json.getString("title")%>",$(".articleedit_content").text().substr(0,50)); 
	if($.trim($(".articleedit_content").text())==""){
	$("#imgvideo").show();
	}else{
		$("#imgvideo").hide();
	}
// 	var ims=$(".articleedit_content img");
// 	for (var i = 0; i < ims.length; i++) {
// 		var img=$(ims[i]);
// 		if(img.attr("src").indexOf(".mp4")>0){
// 			img.after('<video src="'+img.attr("src")+'" controls="controls" height="'+img.attr("height")+'" width="'+img.attr("width")+'"></video>');
// 			img.hide();
// 		}
// 	}
});
//-->
</script>
</body></html>