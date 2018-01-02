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
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
</head>
<body onload="init()">
<div id="do_loginDiv">
<div class="login-mainly">
<div class="form-group">
  <label class="col-sm-3 control-label">运营商</label>
  <div class="col-sm-9">
    <select class="form-control">
    </select>
  </div>
</div>
    <div class="login-account"><label class="ico-account" for="">登录帐号</label><input type="text" placeholder="登录帐号" id="username"></div>
    <div class="login-password"><label class="ico-password " for="">登录密码</label><input type="password" placeholder="登录密码" id="pwd"></div>
</div>
<a class="btn-login" href="javascript:void(0);" id="do_login">登录</a>
</div>
<p>本签到页面为全自动签到页面</p>
<p><a href="../pc/iphoneLocation.html">苹果版微信开启定位的方法</a></p>
<p>提示:如果您的手机无法在该页面中完成签到,请选择【员工签到(选图)】进行签到，并提前使用手机照相机拍摄当前所在位置的原始图片</p>
<div id="address"></div><button class="btn btn_primary" id="openLocation"  style="display:none;">查看地图</button>
	<br>
	<button class="btn btn_primary" id="weixinsign" style="display: none;">拍照</button>
	<button class="btn btn_primary" id="uploadimg" style="display: none;">上传图片并签到</button>
	<button class="btn btn_primary" id="qiandao" style="display: none;">直接签到</button>
	<br>
	<a id="sxin">刷新页面</a>&emsp;&emsp;<a href="../employee.do">返回首页</a>
	<br>
	<div style="width: 603px; height: 300px;color: black;display: none;" id="container"></div>
	<img alt="" src="">
<div class="footer">
	 ${sessionScope.userInfo.personnel.clerk_name} 
</div>	
<script type="text/javascript" src="../pc/js/weixin/sign.js${requestScope.ver}"></script>


</body>
</html>