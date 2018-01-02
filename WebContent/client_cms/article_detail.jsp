<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.qianying.controller.BaseController" %>
<%
BaseController.getVer(request);
	JSONObject json=BaseController.getHtmlContentByUrl(request);
	if(json==null){
		json=new JSONObject();
		json.put("title","");
		json.put("gjc","");
		json.put("releaseTime","");
		json.put("publisher","");
		json.put("img","");
		json.put("poster","");
		json.put("line","参数错误,获取数据失败");
	}else{
// 		if(json.has("")){
			
// 		}
	}
%>
<!Doctype html>
<html><head>
<meta charset="utf-8">
<title><%=json.getString("title")%></title>
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="<%=json.getString("gjc")%>">
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../ds/css/contant.css">
<link rel="stylesheet" href="cms/css/global.css">
<link rel="stylesheet" href="../css/popUpBox.css">
<link rel="stylesheet" href="cms/css/font-awesome.min.css">
<link rel="stylesheet" href="cms/css/case_detail.css">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script> 
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<style type="text/css">
.articledetail img{ display: inline-block;}
</style>
<script type="text/javascript">
<!--
if(window.location.href.indexOf("|_from")>0){
	var url=replaceAll(window.location.href,"\\|_", "&");
	window.location.href=replaceAll(url,"\\|", "&");
}
var url=window.location.href;
if(url.indexOf("|_")>0){
	url=replaceAll(url,"\\|_", "&");
	url=replaceAll(url,"\\|", "&");
	window.location.href=url;
}
//-->
</script>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header" style="width: auto;">
<a href="#" onclick="history.go(-1);" class="header_left">返回</a><span style="margin-left: 39px;"><%=json.getString("title")%></span></div>
</nav>
<!-- <div class="divider"></div> -->
<div class="main_content_container" style="margin-top: 30px;">
	<div class="main_content_ctn articledetail">
<%--     	<div class="case_detail_title articleedit_title" style="display: none;"><%=json.getString("title")%></div> --%>
<%--     	<span class="case_detail_date articleedit_time">发布时间:<%=json.getString("releaseTime")%></span> --%>
<%--     	<span class="case_detail_date articleedit_author">发布人:<%=json.getString("publisher")%></span> --%>
<!--      	<div class="img"> -->
<%--     	<img id="imgvideo" style="display: none;" src="<%=json.getString("img")%>" alt="" onerror="$(this).remove();"> --%>
<%--              <video style="display: none;" src="<%=json.getString("img")%>" controls="controls" height="400" width="480" onerror="$(this).remove();"></video>   --%>
<!--     	</div>  -->
        <div class="case_detail_content articleedit_content">
        <%=json.getString("line")%>
        </div>
    </div>
</div>
 
<div id="back-to-top"></div>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<%-- <script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script> --%>
<script type="text/javascript">
<!--
var imgsrc;
if($(".articleedit_content img").length>0){
	imgsrc=$(".articleedit_content img")[0].src;
}
if(!imgsrc&&$("img").length>0){
	imgsrc=$("img")[0].src;
}else{
	imgsrc="http://www.pulledup.cn/img/indexCarouseBottom0120170204.jpg";
}
weixinShare.init("<%=json.getString("title")%>","<%=json.getString("gjc")%>",imgsrc);
//-->
</script>
</body></html>