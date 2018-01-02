<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1" />
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>${sessionScope.indexName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="pcxy/css/bootstrap.css">
<link rel="stylesheet" href="pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="pcxy/css/function.css${requestScope.ver}">
<link rel="stylesheet" href="css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="js_lib/jquery.11.js"></script>
<!-- <script type="text/javascript" src="js/bootstrap.min.js"></script> -->
<script type="text/javascript" src="js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/public.js${requestScope.ver}"></script>
<style type="text/css">
.panel-success {
	border-color: #ddd !important;
}
.panel-success > .panel-heading {
	color: #000;
	background-color: #fff !important;
	border-color: #ddd !important;
}
@media(max-width:770px){ 
	.footer a{
	 float: right;font-size: 20px;
	}
}
@media(min-width:770px){ 
}
/* 小屏幕（平板，大于等于 768px） */
@media (max-width: 768px) {
.list-group{
	padding-top: 113px;
    text-align: center;
}
#menuList{
right: 10px;
bottom: 50px;
position: fixed;
}
}

/* 中等屏幕（桌面显示器，大于等于 992px） */
@media (max-width:  1300px) {
.list-group{
	padding-top: 113px;
    text-align: center;
}
#menuList{
right: 10px;
bottom: 50px;
position: fixed;
}
.list-group-item{
width: 200px;
}
.glyphicon-th-list{ 
font-size:24px;
}
}
/* 大屏幕（大桌面显示器，大于等于 1200px） */
@media (min-width: 1300px) {
.list-group{
	padding-top: 10px;
    text-align: center;
}
}
</style>
</head>
<body> 
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a>${sessionScope.indexName}</a></li>
		</ol>
		<div class="header-title">
			${sessionScope.indexName}<a class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
	</div>
<div class="list-group bs-docs-sidebar hidden-print hidden-xs hidden-sm affix">
<div id=menuList>

</div>
</div>
	<div class="container">
		<div class="ctn-fff" style="min-height: 800px;margin-bottom:17px" id="list">
		</div>
		<div id="item" style="display: none;">
		<div class="col-sm-6 col-md-6 col-lg-6">
		<div class="panel panel-success">
			<div class="panel-heading"></div>
				<div class="panel-body next">
				</div> 
		</div>
		</div>
		</div> 
		<div id="nextItem" style="display: none;">
		<div class="col-sm-4 col-xs-4 function-ctn">
			<a href="" class="function-icon">
			<img src="">
			</a>
			<div class="function-name"></div>
		</div>
		</div>
		<div id="weixinclose" style="display: none;">
			<div class="col-sm-4 col-xs-4 function-ctn" id="weixinclose">
				<a class="function-icon" onclick="WeixinJSBridge.call('closeWindow');">
					<img src="pcxy/image/function-30.png" alt="">
				</a>
				<div class="function-name">关闭</div>
			</div> 
		</div>
	</div>
	<div class="footer">
	 员工:${sessionScope.userInfo.clerk_name} 
</div>
	<div id="auth" style="display: none;">${requestScope.auth}</div>
	<div id="clerk_id" style="display: none;">${sessionScope.userInfo.clerk_id}</div>
	<div id="address"></div>
<script type="text/javascript">
<!--
var auth=$("#auth").html();
var clerk_id=$.trim($("#clerk_id").html());
$.get("manager/getFiledList.do",{"type":"auth"},function(data){
	if(data&&data.length>0){
		 $.each(data,function(i,n){
			 if(n.checked&&n.nextClass&&n.nextClass.length>0){
				if(clerk_id=="001"||$.trim(n.name)==""||auth.indexOf(n.name)>=0){
				var item=$($("#item").html());
				$("#list").append(item);
				item.find(".panel-heading").html(n.name_ch);
					$.each(n.nextClass,function(j,m){
					   if(m.checked){
					   		if(clerk_id=="001"||$.trim(m.name)==""||auth.indexOf(m.name)>=0){
						 		if($.trim(m.url)!=""){
									var nextItem=$($("#nextItem").html());
									item.find(".next").append(nextItem);
									nextItem.find(".function-name").html(m.name_ch);
									if(m.url.indexOf("@")>=0){
										var url=m.url.replace("@com_id",$.trim('${sessionScope.userInfo.com_id}'));
										url=url.replace("@clerk_id",clerk_id);
										nextItem.find("a").attr("href",url+"&ver="+Math.random());
									}else{
										nextItem.find("a").attr("href",m.url+"${requestScope.ver}");
									}
									nextItem.find("img").attr("src",m.logo);
									if(m.url.indexOf("exitLogin")>=0){
										item.find(".next").append($("#weixinclose").html());
										if(!is_weixin()){
											$("#weixinclose").hide();
										}
									}
								 }
							 }
						 }
					 });
						var idname=$.trim(n.name);
						if(idname==""){
							idname="id"+i;
						}
						item.attr("id",idname);
						$("#menuList").append("<a href='#"+idname+"' class='list-group-item'>"+n.name_ch+"</a>");
					 if($.trim(item.find(".next").html())==""){
						 item.remove();
						 $("#menuList").find("a[href='#"+item.attr("id")+"']").remove();
					 }
				 }
			 }
		});
		 if(!common.isPC()||document.body.clientWidth<=1440){
			 $(".list-group").removeClass("bs-docs-sidebar");
			 $(".list-group").removeClass("hidden-print");
			 $(".list-group").removeClass("hidden-xs");
			 $(".list-group").removeClass("hidden-sm");
			 $(".list-group").removeClass("affix");
			 $(".list-group").addClass("cover");
			 $(".footer").append("<a href='#'><span class='glyphicon glyphicon-th-list'></span></a>");
			 $(".list-group").hide();
			 $(".glyphicon").click(function(){
				 $(".list-group").show();
			 });
			 $(".cover").click(function(){
				 $(".cover").hide();
			 });
		 $(".list-group").find("a").click(function(){
			 $(".list-group").find("a").removeClass("active");
			 $(this).addClass("active");
			 $(".list-group,.cover").hide();
		 });
		 }else{
		 $(".list-group").find("a").click(function(){
			 $(".list-group").find("a").removeClass("active");
			 $(this).addClass("active");
		 });
		 }
	}
});
//-->
</script>
</body>
</html>