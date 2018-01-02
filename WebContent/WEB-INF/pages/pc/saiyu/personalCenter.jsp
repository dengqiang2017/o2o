<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<!--[if lt IE 9]>
<script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>赛宇电器</title>
<%@include file="../res.jsp" %>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
<link rel="stylesheet" href="../pcxy/css/function.css">
<link rel="stylesheet" href="../pcxy/css/chat.css${requestScope.ver}">
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
</head>
    <style>
       @media(min-width:770px){
    .modal-size{
    width:720px
    }
    }
    </style>
<body>
<!------------------------header------------------------->
<div class="header">
    <ol class="breadcrumb" style="height: 100%;line-height: inherit;">
        <li style="height: 100%;float: left;margin-top: -10px;"><img  style="height: 70%;margin-bottom: 15px;margin-right: 10px" src="../pc/image/logo.png" ><span style="font-size: 36px;">成都赛宇电器</span></li>
        <li><a style="color: white;font-size: 24px;line-height:60px" data-title="title">照明体检</a></li>
    </ol>
    <div class="header-title">
        <a style="color: white;" data-title="title">照明体检</a>
        <a class="header-back" style="margin-top: 5px" href="../login/exitLogin.do?type=2">
        <span class="glyphicon glyphicon-menu-left" style="color: white;"></span>
        </a>
    </div>
    <div class="dht pull-right" style="margin-top: 2px">
        <img  src="../pc/repair-images/icon01.png"></div>
    <div class="zz">
        <ul>
            <li data-url="repair">照明体检</li>
            <li data-url="historicalPurchase">我的订单</li>
<!--             <li data-url="accountStatement">对账单</li> -->
            <li data-url="myOA">我的协同</li>
            <li data-url="paymentInfo">付款信息</li>
<!--             <li id="onlineZx">在线咨询</li> -->
<!--             <li data-index="1">基础资料维护</li> -->
        </ul>
    </div>
<!--     <div class="zz2"> -->
<!--         <ul> -->
<!--             <li data-url="repair">照明体检</li> -->
<!--             <li data-url="newRepair">新增照明体检信息</li> -->
<!--             <li data-url="repairHistory">体检历史</li> -->
<!--         </ul> -->
<!--     </div> -->
<!--     <div class="zz2"> -->
<!--         <ul> -->
<!--             <li data-url="personalData">基础资料维护</li> -->
<!--             <li data-url="clientDefineApproval">查看审批流程</li> -->
<!--             <li data-url="editPhone.jsp">修改绑定手机号</li> -->
<!--             <li data-url="editPass.jsp">修改密码</li> -->
<!--         </ul> -->
<!--     </div> -->
</div>
<!------------------------section------------------------->
<div class="con">
    <div class="con-shade"></div>
    <div class="med">
        <ul>
            <li data-url="repair">照明体检</li>
<!--             <li data-index="0">照明体检<div class="li-r"><span class="glyphicon glyphicon glyphicon-triangle-bottom"></span></div></li> -->
<!--             <div class="medli-tac"> -->
<!--                 <div class="medli-tac-div"  data-url="repair">照明体检</div> -->
<!--                 <div class="medli-tac-div"  data-url="newRepair">新增照明体检信息</div> -->
<!--                 <div class="medli-tac-div" data-url="repairHistory">体检历史</div> -->
<!--                 <div class="clear"></div> -->
<!--             </div> -->
            <li data-url="historicalPurchase">我的订单</li>
<!--             <li data-url="financialApproval">我的协同</li> -->
            <li data-url="myOA">我的协同</li>
            <li data-url="paymentInfo">付款信息</li>
<!--             <li data-url="accountStatement">对账单</li> -->
<!--              <li id="onlineZx1">在线咨询</li> -->
<!--             <li data-index="0">基础资料维护<div class="li-r"><span class="glyphicon glyphicon glyphicon-triangle-bottom"></span></div></li> -->
<!--             <div class="medli-tac"> -->
<!--                 <div class="medli-tac-div" data-url="personalData">基础资料维护</div> -->
<!--                 <div class="medli-tac-div" data-url="clientDefineApproval">查看审批流程</div> -->
<!--                 <div class="medli-tac-div" data-url="editPhone.jsp">修改绑定手机号</div> -->
<!--                 <div class="medli-tac-div" data-url="editPass.jsp">修改密码</div> -->
<!--                 <div class="clear"></div> -->
<!--             </div> -->
            <li onclick="window.location.href='../login/exitLogin.do?type=2'">回到首页</li>
        </ul>
        <input type="hidden" id="headshipG" value="${requestScope.headship}">
    </div>
    <div class="container tbd">
    <div id="containerhtml">
    
    </div>
    <div id="clientLiaotian"  style="display: none;">
	</div>
    </div>
    <div  id="cop"></div>
</div>

<div class="image-zhezhao" style="display:none">
   <div style="width: 5%;float: left">
        <div class="img-left"></div>
   </div>
    <div style="width: 90%;float: left;height: 100%;">
        <div class="img-ku" style="float:left;">
            <div id="imshow">
            </div>
        </div>
    </div>
    <div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div>
<div class="modal" id="mymodal" style="display: none;">
	<div class="modal-dialog modal-size">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">在线咨询</h4>
			</div>
			<div class="modal-body">
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
				<img style='width: 100px;height: 100px;display: none;'>
				<div style="width: 603px; height: 300px;color: black;display: none;" id="container"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js" charset="utf-8"></script>
<script type="text/javascript" src="http://map.qq.com/api/js?v=2.exp" charset="utf-8"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/customer/customerpay.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/personalCenter.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/sendChatMsg.js${requestScope.ver}"></script>

<script type="text/javascript" src="../pc/js/saiyu/evaluation.js${requestScope.ver}"></script>
</body>
</html>