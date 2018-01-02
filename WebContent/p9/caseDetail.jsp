<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.qianying.controller.BaseController" %>
<%
	JSONObject json=BaseController.getHtmlContentByUrl(request);
	if(json!=null){
		String re="pc";
		if(json.getString("line").contains("/"+re+"/")){
			json.put("line",json.getString("line").replaceAll("/"+re, "/"+json.get("prefix")));
		}else if(json.getString("line").contains(re+"/")){
			json.put("line",json.getString("line").replaceAll(re, "/"+json.get("prefix")));
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
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title> 牵引互联-<%=json.getString("title")%></title>
    <meta name="keywords" content="<%=json.getString("gjc")%>">
    <link rel="stylesheet" href="http://www.pulledup.cn/pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/minute.css">
</head>
<body>
<!--公用头部-->
<div class="index01_top navbar-fixed-top">
    <div class="center">
        <div class="pull-left">
            <a href="index.html"><img class="img-responsive" src="images/LOGO.png"></a>
        </div>
        <div class="pull-right">
            <ul>
                <li><a href="index.html">首页</a></li>
                <li><a href="serve.html">服务</a></li>
                <li><a class="active" href="case.html">案例</a></li>
                <li><a href="about.html">关于我们</a></li>
                <li style="margin-right: 0"><a href="relation.html">联系我们</a></li>
                <div class="clearfix"></div>
            </ul>
            <img src="images/tc.png" style="width: 24px;margin-top: 12px;">
        </div>
        <div class="clearfix"></div>
    </div>
</div>
<!---->
<div class="zz_box"></div>
<div class="zz">
    <ul style="margin-bottom: 0;">
        <a href="index.html"><li>首页</li></a>
        <a  href="serve.html"><li>服务</li></a>
        <a href="case.html"><li class="active">案例</li></a>
        <a href="about.html"><li>关于我们</li></a>
        <a href="relation.html"><li style="margin-right: 0">联系我们</li></a>
        <div class="clearfix"></div>
    </ul>
</div>

    <div class="minute-container">
        <a class="btn btn-default" href="javascript:history.back();">返回</a>
        <h1><%=json.getString("title")%></h1>
        <div class="time"><span><%=json.getString("releaseTime")%></span></div>
<!--         <div class="img"> -->
<!--             <img src="" style="display: none"> -->
<!--         </div> -->
        <div class="word">
         <%=json.getString("line")%>
        </div>
    </div>
<script src="cj-js/jquery-1.8.3.min.js"></script>
<script type="text/javascript">
<!--
    $('.center>.pull-right img').click(function(){
          $('.zz_box').toggle();
          $('.zz').slideToggle();
    });
    $('.zz_box').click(function(){
        $('.zz_box').hide();
        $('.zz').slideUp();
    });
//-->
</script>
</body>
</html>