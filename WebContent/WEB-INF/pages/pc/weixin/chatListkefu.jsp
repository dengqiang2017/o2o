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
<link rel="stylesheet" href="../pcxy/css/chat.css">
<script src="../js/o2od.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>我的聊天</li>
      </ol>
      <div class="header-title">我的聊天
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
		
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
<!--       	<div class="box-head"> -->
<!--       		<a href="chat.do" type="button" class="btn btn-sm btn-primary m-t-b">发起聊天</a> -->
<!--       	</div> -->
      	<div id="item" style="display: none;">
	      	<div class="col-sm-6">
				<div class="chat-group">
					<div class="chat-msg">
						<span class="chat-member"></span>
						<input type="hidden">
					</div>
					<span class="new-chat" style="display: none;">0</span>
				</div>
			</div>
      	</div>
		<div class="box-body">
		</div>
      </div>
    </div>
    <script >
var item0=$("#item");
$.get("../user/getCharids.do",function(data){
	$(".box-body").html("");
	 if (data.length>0) {
		 pop_up_box.loadWait();
		 var item=$(item0.html());
		 $(".box-body").append(item);
		 item.find(".chat-member").html(data[0].name);
		 item.find("input").val(data[0].chatid);
		 item.find(".chat-group").click(function(){
			 var val=$(this).find("input").val();
			 window.location.href="sendChatMsg.do?"+val;
		 });
		 window.location.href="sendChatMsg.do?"+data[0].chatid;
		 pop_up_box.loadWaitClose();
	}else{
		pop_up_box.loadWait();
		$.get("kefuchatcreat.do",function(data){
			 window.location.href="sendChatMsg.do?"+data.msg;
		});
	}
});
</script>
</body>
</html>