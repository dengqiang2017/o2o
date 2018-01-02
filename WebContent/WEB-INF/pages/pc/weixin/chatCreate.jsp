<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>创建会话</title>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/function.css">
<link rel="stylesheet" href="../pcxy/css/chat.css">
<script src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/selectPerson.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/chatCreate.js${requestScope.ver}"></script>
</head>
<body>
<div class="header">
  <ol class="breadcrumb">
    <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">首页</a></li>
    <li><span class="glyphicon glyphicon-triangle-right"></span><a href="chatList.do">我的聊天</a></li>
    <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>创建会话</li>
  </ol>
  <div class="header-title">创建会话
    <a href="chatList.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
  </div>
  <div class="header-logo"></div>  
</div>
<div class="container" style="padding-top:10px;">
	
	<form id="chat">
		<div class="form-gp">
			<span>会话标题</span> 
			<div class="input"><input type="text" name="chatTitle" maxlength="20"></div>
		</div>
		<div>
			<div class="chat-mem-title">会话成员</div>
			<div id="item" style="display: none;">
				<div class="chat-mem">
					<div class="header-img">
						<img>
					</div>
					<span class="chat-mem-name"></span>
					<span class="del"></span>
					<input type="hidden" name="userlist">
				</div>
			</div>
			<div class="chat-mem-ctn">
				<div>
				
				</div>
				<div class="add-mem"></div>
			</div>
		</div>
	</form>
	<div class="text-center" style="margin-top:10px;">
		<button type="button" class="btn btn-sm btn-primary">创建</button>
	</div>
</div> 
</body>
</html>