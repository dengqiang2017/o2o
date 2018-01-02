<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="contant.css${requestScope.ver}">
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header">
			<a class="header_left">返回</a> 产品详情图文编辑<div class="pull-right"><button type="button" class="btn btn-info" id="save">保存编辑</button></div>
		</div>
	</nav>
<div style="margin-top: 60px;">
<h3>产品名称:<span id="item_name"></span></h3>
<script id="editor" type="text/plain" style="width:100%;"></script>
</div>
<script type="text/javascript">
<!--
$("#editor").css("height",window.screen.height-200);
//-->
</script>
<script type="text/javascript" src="/baidu/baiduedit.js${requestScope.ver}"></script>
<script type="text/javascript" src='/product/articleDialog.js${requestScope.ver}'></script>