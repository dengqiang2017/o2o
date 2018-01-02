<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
		json.put("line",json.getString("line").replaceAll("p8/generateQRCode", "generateQRCode"));
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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">  
<meta http-equiv="expires" content="0">
<meta name="description" content="">
<meta name="keywords" content="<%=json.getString("gjc")%>">
<title><%=json.getString("title")%></title>
<link rel="stylesheet" href="/pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/header.css" />
<link rel="stylesheet" href="css/zixun_detail.css" />
</head>
<body>
  <div class="container">
  <div id="zixun">
<%--   <h3><%=json.getString("title")%></h3> --%>
  <div id="desc">
  <%=json.getString("line")%>
  </div>
  </div>
  </div>
<script type="text/javascript" src="/js_lib/jquery.11.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/public.js"></script>
<script type="text/javascript" src="/js/popUpBox.js"></script>
<script type="text/javascript" src="/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="/js/weixin/weixinShare.js"></script>
<script type="text/javascript" src="js/header.js"></script>
<script type="text/javascript">
<!--
header.init();
$("#desc span").css("background-color","");
var desc=$("#desc").text().substr(0,100);
$('meta name="description"').attr("content",desc);
weixinShare.init('<%=json.getString("title")%>',desc,$("img:eq(0)").attr("src"));
//-->
</script>
</body>
</html>