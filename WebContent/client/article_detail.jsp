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
<link rel="stylesheet" href="../p1/cms/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="../p1/cms/css/font-awesome.min.css">
<link rel="stylesheet" href="../p1/cms/css/case_detail.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script> 
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
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
<div class="divider"></div>
<div class="main_content_container">
	<div class="main_content_ctn articledetail">
    	<div class="case_detail_title articleedit_title" style="display: none;"><%=json.getString("title")%></div>
<%--     	<span class="case_detail_date articleedit_time">发布时间:<%=json.getString("releaseTime")%></span> --%>
<%--     	<span class="case_detail_date articleedit_author">发布人:<%=json.getString("publisher")%></span> --%>
		<div id="fenxiang"> </div>
     	<div class="img"> 
    	<img id="imgvideo" style="display: none;" src="<%=json.getString("img")%>" alt="" onerror="$(this).remove();">
             <video style="display: none;" src="<%=json.getString("img")%>" controls="controls" height="400" width="480" onerror="$(this).remove();"></video>  
    	</div> 
        <div class="case_detail_content articleedit_content">
        <%=json.getString("line")%>
        </div>
    </div>
</div>
<div id="back-to-top"></div>
<!-- <div class="side_tools logo_container"></div> -->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
$(function(){
	var type=common.getQueryString("type");
	if(type=="liu"){
		return;
	}
	var url=common.getQueryString("url");
	if(!url){
		return;
	}
	var id=common.getQueryString("id");
	var com_id=common.getQueryString("com_id");
	var clerk_id=common.getQueryString("clerk_id");
	if(!com_id){
		com_id=url.split("/")[1];
	}
	if(!clerk_id){
	    clerk_id=url.split("/")[3];
	}
	if(is_weixin()){
		weixinAutoLogin.init("客户", com_id, function(login,userid){//$("body").append(userid);
			$.post("../login/ganzhi.do",{
				 "id":url,
				 "name":$(".articleedit_title").html(),
				 "com_id":com_id,
				 "clerk_id":clerk_id,
				 "headship":"业务员",
				 "userid":userid,
				 "DeviceId":DeviceId,
				 "url":"/client/ganzhiRecord.jsp?id=",
				 "title":"客户浏览通知",
				 "desc":"@clerkName,客户【@customerName】浏览了【"+$(".articleedit_title").html()+"】,请注意后续跟进!"
			 },function(data){
				 stoptime(data);
			 });
		},false);
	}else{
		 $.post("../login/ganzhi.do",{
			 "id":url,
			 "name":$(".articleedit_title").html(),
			 "clerk_id":clerk_id,
			 "com_id":com_id,
			 "headship":"业务员",
			 "url":"/client/ganzhiRecord.jsp?id=",
			 "title":"客户浏览通知",
			 "desc":"有客户使用电脑浏览了【"+$(".articleedit_title").html()+"】,请注意后续跟进!"
		 },function(data){
			 stoptime(data);
		 });
	}	
// 	var code=getQueryString("code");
	var DeviceId="";
	var userid="";
	function stoptime(data){
		setInterval(function(){
			 ///提交停留时间
			 $.post("../login/stopTime.do",{//每3秒钟向服务器提交一次当前时间
				 "id":data.msg,
				 "com_id":com_id
			 });
		}, 3000);
	}
	///////////////////////////////
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
	
	$("#imgvideo").hide();
	if($.trim($(".articleedit_content").text())==""){
		$("#imgvideo").show();
	}else{
		$("#imgvideo").hide();
	}
	var ims=$(".articleedit_content img");
	for (var i = 0; i < ims.length; i++) {
		var img=$(ims[i]);
		if(img.attr("src").indexOf(".mp4")>0){
			img.after('<video src="'+img.attr("src")+'" controls="controls" height="'+img.attr("height")+'" width="'+img.attr("width")+'"></video>');
			img.hide();
		}
	}
});
//-->
</script>
</body></html>