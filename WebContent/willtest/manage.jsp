<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.getVer(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>威尔检测文章发布</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/manage.css${requestScope.ver}">
<link rel="stylesheet" href="bianji/css/edit_modal.css${requestScope.ver}">
<link rel="stylesheet" href="bianji/css/font-awesome.min.css">
<link rel="stylesheet" href="css/flattingshow.css">
<link rel="stylesheet" href="css/edit.css${requestScope.ver}" >
<link href="images/logo.ico" type="image/x-icon" rel="shortcut icon" />
<script type="text/javascript" src="js/jquery-1.11.3.js"></script>
<link href="/css/popUpBox.css${requestScope.ver}" rel="stylesheet">
<script type="text/javascript" src="/js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/edithtml.js${requestScope.ver}"></script>
<script type="text/javascript" src="cms/manageList.js${requestScope.ver}"></script>
<style type="text/css">
.serve05 {
	text-align: center;
	margin-top: 50px;
	/*background-color: #FFFFFF;*/
	padding: 20px;
}
.serve05>.col-lg-4>img {
	width: 159px;
	margin-bottom: 15px;
}
.secition_box_bottom05{
	display: none;
	margin: auto;
	margin-top: 20px;
	width: 85%;
	background-color: #ffffff;
}
.serve05>.col-lg-4{
	color: #FFFFFF;
}
.boxed{
	width: 200px;
	margin: auto;
	padding: 10px;
	color: #FFFFFF;
	font-size: 18px;
}
.boxed img{
	margin-bottom: 10px;
}
</style>
</head>
<body>
<span style="display: none;" id="projectName"></span>
	<!--公用头部-->
	<div class="index01_top navbar-fixed-top">
		<div class="center">
			<div class="pull-left">
				<a href="index.html"><img class="img-responsive"
					src="images/123(1).png"></a>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="secition">
		<div class="secition_box">
			<div class="secition_box_top clearfix">
					<div class="fl x-active">行业咨询<span class="ui_type" style="display: none;">1</span></div>
			</div>
			<!-- 案例--> 
			<div class="secition_box_bottom03 clearfix" id="information">
			</div>
				<div id="imgitem" style="display: none;">
					<div class="col-lg-3">
					<div class="right-main-item">
						<div  class="img imgvideo" data-title="推荐尺寸318*230px">
							<div class="imgk02">
								<a> <img data-bd-imgshare-binded="1"
									src="" alt=""> <video
										style="display: none;" src="" controls="controls" preload="none" height="400"
										width="480"></video> <!--               <embed style="display: none;" src="" allowfullscreen="true" quality="high" allowscriptaccess="always" type="application/x-shockwave-flash" align="middle" height="400" width="480"> -->
								</a>
							</div>
						</div>
						<div class="msg articleedit">
						<div style="display: none;" id="htmlname"></div>
								<div class="msg-data-title articleedit_title"
									style="font-size: 18px;"></div>
								<div class="msg-subtitle articleedit_keywords"></div>
								<div class="other">
									<span class="author articleedit_time"></span> <span
										class="date articleedit_author"></span>
								</div>
						</div>
					</div>
					</div>
				</div>

			<!-- -->
			</div>
		</div>
</body>
</html>