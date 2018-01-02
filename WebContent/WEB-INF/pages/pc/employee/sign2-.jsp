<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>业务员微信签到</title>
<link href="../pcxy/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="../pcxy/css/global.css">
 <link rel="stylesheet" href="../css/popUpBox.css">
<script type="text/javascript" src="../js_lib/jquery.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript"
	src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script charset="utf-8" src="http://map.qq.com/api/js?v=1"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
<style>
	.container{
		padding: 0 10px;
	}
	p{
	}
	img{
		max-width:100%;
	}

	.btn-upload{
		position: relative;
		overflow: hidden;
	}

	.btn-upload>input[type="file"]{
		position: absolute;
		left: 0;
		top: 0;
		right: 0;
		bottom: 0;
		display: block;
		width: 100%;
		height: 100%;
		opacity: 0;
		filter: alpha(opacity=0);
		cursor: pointer;
	}
	body{
		padding-top: 5px;
	}
</style>
</head>
<body onload="init()">
		<div class="container">
		<p>功能说明：本签到页面主要用于在自动签到页面部分手机的微信调用照相机接口不兼容,导致签到不能完成</p>
		<p>请先在使用本机照相机程序拍摄当前所在地照片,签到时间将以照片拍摄时间为准</p>
		<p><a href="../pc/iphoneLocation.html">苹果版微信开启定位的方法</a></p>
		<p>在本页面中签到流程:</p>
		<p>1.选择图片</p>
		<p>2.核对服务器返回的照片信息</p>
		<p>3.点击【签到】按钮完成签到</p>
		<p style="color: red;">注意事项:</p>
		<p style="color: red;">1.请一定选择手机照相机拍摄的原始照片</p>
		<p style="color: red;">2.非手机照相机原始图片将不能完成签到!</p>
		<div class="btn btn-sm btn-danger btn-upload">选择照片
			<input type="file" name="imgFile" id="imgFile"  accept="image/jpeg"  onchange="imgUpload(this);">
		</div>
		<div id="imginfo">
			<p>照片信息:</p>
		</div>
<!-- 		<button class="btn btn-sm btn-primary" onclick="imgUpload($('#imgFile'));">上传图片</button> -->
		<button class="btn btn-sm btn-primary" id="qiandao">签到</button>
		<br>
		<div id="address"></div>
		<button class="btn btn_primary" id="openLocation" style="display:none;">查看地图</button>
		<button class="btn btn_primary" id="txun" >查看地图</button>
		<br>
		<br>
		<a id="sxin">刷新页面</a>&emsp;&emsp;<a href="../employee.do">返回首页</a>
		<br>
			<div style="width: 603px; height: 300px;color: black;display: none;" id="container"></div>
			<img alt="" src="">
	</div>
<div class="footer">
	 ${sessionScope.userInfo.personnel.clerk_name} 
</div>	
<script type="text/javascript" src="../pc/js/weixin/sign2.js${requestScope.ver}"></script>

</body>
</html>