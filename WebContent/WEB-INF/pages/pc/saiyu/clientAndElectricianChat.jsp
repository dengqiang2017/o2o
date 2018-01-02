<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<link rel="stylesheet" href="../pcxy/css/chat.css${requestScope.ver}">
<script type="text/javascript" src="../pc/js/saiyu/clientAndElectricianChat.js${requestScop.ver}"></script>
<div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;
用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span>
<span><a href="javaScript:showele();">实时预约电工-></a></span><span>${requestScope.chatname}</span></div>
<input type="hidden" id="dian_customer_id" value="${requestScope.dian_customer_id}">
<input type="hidden" id="chatname" value="${requestScope.chatname}">
	<div class="container"> 
			<input type="hidden" id="chatid" value="${requestScope.chatid}">
			<input type="hidden" id="historyDate">
			<div class="message-box">
<span><a href="javaScript:showele();">返回选择电工-></a></span>
			<div>
			<div class="view-history">查看历史</div>
			</div>
			<div>
			
			</div>
<!-- 	<div class="div-group" style="position: absolute;right: 0;bottom: 10px;"> -->
<!-- 	<button type="button" class="btn btn-primary btn-dw">确认预约电工</button> -->
<!-- 	</div> -->
			</div>

<!-- 默认状态是输入框只有一行，当字数较多时，在.write-box上添加类名.write-box-lg -->
<div class="write-box">
	<div class="write-tools">
		<!--键盘图标，默认隐藏，显示时，点击图标，图标隐藏，tools04显示，并且.input中，textarea显示，span隐藏-->
<!-- 		<span class="tools tools01"></span> -->
		<!-- 加号图标，在输入框输入文字时，图标隐藏，点击后，.write-area显示，再次点击，.write-area隐藏 -->
<!-- 		<span class="tools tools02"></span> -->
		<!-- 表情图标 -->
<!-- 		<span class="tools tools03" style="display: none;"></span> -->
		<!-- 语音图标，默认显示，点击之后，图标隐藏，tools01显示，并且.input中，textarea隐藏，span显示 -->
<!-- 		<span class="tools tools04"></span> -->
		<!-- 发送按钮，在输入框输入文字后，按钮显示 -->
		<button class="btn btn-sm tools send">发送</button>
		<div class="input">
			<!-- 输入框，默认显示 -->
			<textarea style="line-height:35px"></textarea>
			<!-- 按住说话按钮，默认隐藏 -->
<!-- 			<span id="startRecord" style="display: none;">开始录音</span> -->
<!-- 			<span id="stopRecord" style="display: none;">停止录音</span> -->
		</div>
	</div>
<!-- 	<div class="write-area" style="display: none;"> -->
		<!-- 照片图标 -->
<!-- 		<div class="talk-icon-ctn"> -->
<!-- 			<div class="talk-icon talk-icon01"></div> -->
<!-- 			<span>照片</span> -->
<!-- 		</div> -->
		<!-- 拍摄图标 -->
<!-- 		<div class="talk-icon-ctn"> -->
<!-- 			<div class="talk-icon talk-icon02"></div> -->
<!-- 			<span>拍摄</span> -->
<!-- 		</div> -->
		<!-- 小视频图标 -->
<!-- 		<div class="talk-icon-ctn" style="display: none;"> -->
<!-- 			<div class="talk-icon talk-icon03"></div> -->
<!-- 			<span>小视频</span> -->
<!-- 		</div> -->
		<!-- 位置图标 -->
<!-- 			<div class="talk-icon-ctn"> -->
<!-- 				<div class="talk-icon talk-icon04"></div> -->
<!-- 				<span>位置</span> -->
<!-- 			</div> -->
<!-- 		</div> -->
	</div>
</div>
<img style='width: 100px;height: 100px;display: none;'>
