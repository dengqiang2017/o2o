<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate"> 
<meta http-equiv="expires" content="0">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="renderer" content="webkit">
<title>上班考勤签到-${sessionScope.systemName}</title>
<link href="../pcxy/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<c:if test="${requestScope.signed=='true'}">
<script type="text/javascript">
<!--
alert("今天已经签到成功一次,不能重复签到!");
window.location.href="../employee.do";
//-->
</script>
</c:if>
<style type="text/css">
	.container{
		padding: 0 10px;
	}
	
	body{
		padding-top: 5px;
		background:#f2f2f2;
	}
	
	.location-ctn{
		width: 100%;
		height: 40px;
		line-height: 40px;
		background:#fff;
		margin-top: 10px;
		border: 1px solid #e5e5e5;
		padding: 0 10px;
		overflow: hidden;
		font-size:16px;
	}
	
	.location-ctn>.glyphicon{
		color: #f40;
	}

	.location-ctn>.location{
		color: #555;
	}

	.picture-ctn{
		
	}

	.picture-ctn>.pic-icon{
		width: 100%;
		height: 100px;
		cursor: pointer;
		border: 1px solid #e5e5e5;
		background: #fff;
		border-top: none;
		position: relative;
	}

	.picture-ctn>.pic-icon>.glyphicon{
		display: block;
		float: left;
		font-size:40px;
		height: 80px;
		width: 80px;
		line-height:80px;
		text-align:center;
		background:#ddd;
		margin-top:10px;
		margin-left:10px;
		color:#999;
	}

	.picture-ctn>.pic-icon>.text{
		display: block;
		font-size: 18px;
		position: absolute;
		top: 0;
		bottom: 0;
		right: 0;
		left: 100px;
		padding-right:10px;
		padding-top:18px;
		color:#858585;
	}

	.picture-ctn>.pic{
		width: 120px;
		height: 120px;
		display: table-cell;
		margin: 10px 0 0;
		border-radius: 5px;
		text-align:center;
		vertical-align: middle;
	}

	.pic>img{
		max-width:120px;
		max-height:120px;
	}

	.sign-remark{
		width: 100%;
		height: 80px;
		background:#fff;
		border: 1px solid #e5e5e5;
		margin-top:10px;
	}

	.sign-remark>textarea{
		width: 100%;
		height: 100%;
		border: none;
		resize: none;
		padding: 5px;
	}

</style>
</head>
<body onload="init()">
	<div class="container">
		<div class="location-ctn">
			<span class="glyphicon glyphicon-map-marker"></span>
			<span class="location"  id="address"></span>
		</div>
		<div class="picture-ctn">
			<div class="pic-icon"><span class="glyphicon glyphicon-camera" id="weixinsign">
			</span>
			<span class="text">来张照片说明我在工作</span></div>
			<div class="pic"><img src="" alt=""></div>
		</div>
		<div class="sign-remark">
			<textarea cols="30" rows="3" placeholder="备注..."></textarea>
		</div>
		<button type="button" id="openLocation">上传位置</button>
		<div class="ctn text-center" style="padding-top:10px;">
			<button type="button" class="btn btn-primary" id="qiandao">提交</button>
			<button type="button" class="btn btn-primary" onclick="window.location.href='../employee.do';">返回</button>
		</div>
	</div>
	<div style="width: 603px; height: 300px;color: black;" id="container"></div>
<div class="footer">
	 ${sessionScope.userInfo.personnel.clerk_name}
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp&key=KDPBZ-MLJCV-A4TP2-UF7RY-NEU2E-MDF34"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/sign.js${requestScope.ver}"></script>
</body>
</html>