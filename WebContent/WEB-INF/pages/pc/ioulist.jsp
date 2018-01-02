<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>牵引O2O营销服务平台</title>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<%@include file="res.jsp"%>
<link rel="stylesheet" href="../pcxy/css/word.css">
<script src="../js_lib/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
</head>
<body>
	<div id="item" style="display: none;">
	<div class="container" style="padding: 20px;">
		<button type="button" class="btn-default" id="print">打印</button>
		<div id="printdiv">
		
		</div>
	</div>
	</div>
	
	<script type="text/javascript">
	//1.从服务器获取桥列表
	$.get("getIouList.do",{
		
	},function(data){
		$.each(data,function(i,n){
			//2.获取存放欠条的模板div对象
			var item =$($("#item").html());
			//3.将欠条文件放入到指定的div中
			item.find("#printdiv").load(n);
		});
	});
	
	</script>
</body>
</html>