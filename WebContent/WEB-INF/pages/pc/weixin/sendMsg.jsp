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
    <script type="text/javascript" src="../pc/js/weixin/sendMsg.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>发送消息</li>
      </ol>
      <div class="header-title">发送消息
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
	<div class="container">
      <div class="ctn-fff box-ctn">
		<div class="box-body">
			<div class="contact-person">
				<span class="person"></span>
				<span id="person" style="display: none;"></span>
				<a id="clearPerson" >X</a>
				<a id="selectPerson" class="addcp-icon"></a>
			</div>
			<div class="message-box">
				 
			</div>
			<div class="write-box">
				<div class="write-tools">
					<span class="tools tools01"></span>
					<span class="tools tools02">
						<input type="file">
					</span>
					<span class="tools tools03">
						<input type="file">
					</span>
					<div class="send">发送</div>
				</div>
				<div class="write-area">
					<textarea rows="3"></textarea>
				</div>
			</div>
		</div>
      </div>
    </div>

    <div class="footer">
 ${sessionScope.userInfo.personnel.clerk_name}${sessionScope.customerInfo.clerk_name}
    </div>
</body>
</html>