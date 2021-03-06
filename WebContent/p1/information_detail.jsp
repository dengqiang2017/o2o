<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.qianying.controller.BaseController" %>
<%
BaseController.getVer(request);
	JSONObject json=BaseController.getHtmlContentByUrl(request);
	if(json!=null){
		String re="pc";
		if(json.getString("line").contains("/"+re+"/")){
			json.put("line",json.getString("line").replaceAll("/"+re, "/"+json.get("prefix")));
		}else if(json.getString("line").contains(re+"/")){
			json.put("line",json.getString("line").replaceAll(re, "/"+json.get("prefix")));
		}
		if(json.getString("img").contains("mp4")){
			request.setAttribute("video", true);
		}else{
			request.setAttribute("video", false);
		}
	}else{
		json=new JSONObject();
		json.put("title","");
		json.put("gjc","");
		json.put("releaseTime","");
		json.put("publisher","");
		json.put("img","");
		json.put("poster","");
		json.put("line","");
	}
%>
<!Doctype html><html><head>
<meta charset="utf-8">
<title><%=json.getString("title")%></title>
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="<%=json.getString("gjc")%>">
<meta name="description" content="<%=json.getString("gjc")%>">
<link rel="stylesheet" href="cms/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="cms/css/font-awesome.min.css">
<link rel="stylesheet" href="cms/css/information_detail.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
if(window.location.href.indexOf("|_from")>0){
	var url=common.replaceAll(window.location.href,"\\|_", "&");
	window.location.href=common.replaceAll(url,"\\|", "&");
}
var url=window.location.href;
if(url.indexOf("|_")>0){
	url=common.replaceAll(url,"\\|_", "&");
	url=common.replaceAll(url,"\\|", "&");
	window.location.href=url;
}
//-->
</script>
</head>
<body marginwidth="0" marginheight="0">

<div class="main_title_container">
	<div class="main_title_ctn">
    	<div class="main_title textonly">服务</div>
    </div>
</div>    
<div class="divider"></div>

<div class="main_content_container">
	<div class="main_content_ctn articledetail">
    	<div class="information_detail_title articleedit_title"><%=json.getString("title")%></div>
        <span class="information_detail_date articleedit_time">发布时间:<%=json.getString("releaseTime")%></span>
        <span class="information_detail_date articleedit_author">发布人:<%=json.getString("publisher")%></span>
        <div id="fenxiang"></div>
        <c:if test="${requestScope.video==false}">
    	<img style="display: none;" src="<%=json.getString("img")%>" alt="">
		</c:if>
		<c:if test="${requestScope.video==true}">
        <video  controls="controls" src="<%=json.getString("img")%>"
          height="400" width="480" 
          preload="none"
           poster="<%=json.getString("poster")%>"></video>  
		</c:if>
        <div class="information_detail articleedit_content"><%=json.getString("line")%></div>
	</div>
</div>
<div class="side_tools logo_container"></div>
<footer class="footer"></footer>
<div id="back-to-top"></div>
<script type="text/javascript" src="../cmsjs/url.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/urlParam.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../cmsjs/head.js${requestScope.ver}"></script>
<script type="text/javascript" src="../cmsjs/ganzhi.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
var imgsrc=$(".articleedit_content img")[0].src;
if(!imgsrc){
    imgsrc=$(".main_content_container img")[0].src;
}
if(!imgsrc&&$("img").length>0){
   imgsrc=$("img")[0].src;
}
$(".articleedit_content").html(common.replaceAll($(".articleedit_content").html(),projectName+"/generateQRCode","pc/generateQRCode"));
weixinShare.init("<%=json.getString("title")%>",$(".articleedit_content").text().substr(0,50));
//-->
</script>
</body></html>