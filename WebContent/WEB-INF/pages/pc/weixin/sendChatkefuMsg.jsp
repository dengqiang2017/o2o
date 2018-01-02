<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/function.css">
<link rel="stylesheet" href="../pcxy/css/chat.css${requestScope.ver}">
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script charset="utf-8" src="http://map.qq.com/api/js?v=1"></script>
<script type="text/javascript" src="../pc/js/weixin/sendChatMsg.js${requestScop.ver}"></script>
</head>
<body onload="init();">
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span><span class="info"></span></li>
      </ol>
      <div class="header-title"><span class="info"></span>
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
    </div>
	<div class="container"> 
			<input type="hidden" id="chatid">
			<input type="hidden" id="historyDate">
			<div class="message-box">
			<div>
			<div class="view-history">查看历史</div>
			</div>
			<div>
			</div>
			</div>
			
			<!-- 默认状态是输入框只有一行，当字数较多时，在.write-box上添加类名.write-box-lg -->
			<div class="write-box">
				<div class="write-tools">
					<!--键盘图标，默认隐藏，显示时，点击图标，图标隐藏，tools04显示，并且.input中，textarea显示，span隐藏-->
					<span class="tools tools01"></span>
					<!-- 加号图标，在输入框输入文字时，图标隐藏，点击后，.write-area显示，再次点击，.write-area隐藏 -->
					<span class="tools tools02"></span>
					<!-- 表情图标 -->
					<span class="tools tools03" style="display: none;"></span>
					<!-- 语音图标，默认显示，点击之后，图标隐藏，tools01显示，并且.input中，textarea隐藏，span显示 -->
					<span class="tools tools04"></span>
					<!-- 发送按钮，在输入框输入文字后，按钮显示 -->
					<div class="send">发送</div>
					<div class="input">
						<!-- 输入框，默认显示 -->
						<textarea></textarea>
						<!-- 按住说话按钮，默认隐藏 -->
						<span id="startRecord" style="display: none;">开始录音</span>
						<span id="stopRecord" style="display: none;">停止录音</span>
					</div>
				</div>
				<div class="write-area" style="display: none;">
					<!-- 照片图标 -->
					<div class="talk-icon-ctn">
						<div class="talk-icon talk-icon01"></div>
						<span>照片</span>
					</div>
					<!-- 拍摄图标 -->
					<div class="talk-icon-ctn">
						<div class="talk-icon talk-icon02"></div>
						<span>拍摄</span>
					</div>
					<!-- 小视频图标 -->
					<div class="talk-icon-ctn" style="display: none;">
						<div class="talk-icon talk-icon03"></div>
						<span>小视频</span>
					</div>
					<!-- 位置图标 -->
					<div class="talk-icon-ctn">
						<div class="talk-icon talk-icon04"></div>
						<span>位置</span>
					</div>
				</div>
			</div>
		</div>
<img style='width: 100px;height: 100px;display: none;'>
<div style="width: 603px; height: 300px;color: black;display: none;" id="container"></div>
</body>
</html>