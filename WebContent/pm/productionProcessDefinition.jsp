<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
//  	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
// 	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">  
<meta http-equiv="expires" content="0">
<meta name="description" content="生产过程是时候该与互联网+进行结合了！生产工艺流程数据结构定义,可适用于流程型,离散型,混合型生产模式,可将产品成本,生产进度具体到每一个工序中,使生产内部管理更高效,进度实时掌握.">
<meta name="keywords" content="生产工艺,数据结构,流程型,离散型,混合型">
<title>生产工艺流程定义</title> 
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.list{margin-top: 5px;}
.item{margin-bottom: 5px;}
.gongduan{margin-bottom: 5px;margin-top: 5px;}
.gongxuList{margin-left: 10px;margin-bottom: 5px;margin-top: 5px;border: 1px solid #d6e9c6;}
.gongxu{margin-bottom: 5px;margin-top: 5px;}
.gongxuNextList{margin-left: 20px;margin-bottom: 5px;margin-top: 5px;}
.gongxu-next-item{border: 1px solid #d6e9c6;margin-bottom: 5px;}
label{margin: 5px;}
body{background-color: #f4faff}
.form-inline .form-group{margin: 5px;}
/* 小屏幕（平板，大于等于 768px） */
@media (max-width: 768px) {
.gongxu{border: 1px solid #d6e9c6;}
.form-control{width: auto;display: initial;}
.form-group label{width: auto;}
}
/* 大屏幕（大桌面显示器，大于等于 1200px） */
/* 中等屏幕（桌面显示器，大于等于 992px） */
@media (min-width: 992px) {}
.back-top{
  width: 50px;
  height: 50px;
  position: fixed;
  right: 10px;
  bottom: 110px;
  cursor: pointer;
  background-image: url(../pcxy/image/back-top.png);
}
</style>
</head>
<body>
<div style="width: 1px;height: 1px;"><img  style="width: 1px;height: 1px;" src="ppd.jpg"></div>
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container">
    <h2 style="text-align: center;">生产工艺流程定义<span style="color: red;font-size: 12px;">演示版</span></h2>
	<div style="margin: 5px;">
	<button type="button" class="btn btn-info" id="addGd">增加工段</button>
	<c:if test="${sessionScope.userInfo.clerk_id!=null}">
	<button type="button" class="btn btn-info" id="save">保存</button>
	<a class="btn btn-default" href="../employee.do">返回</a>
	</c:if>
	</div>
  </div>
</nav>
<div class="container" style="padding-top: 100px;">
<div id="gongduanItem" style="display: none;">
	<div class="gongduan panel-body">
	<div class="form-inline">
		<div class="form-group"><label><input type="checkbox" class="use"><span>使用</span></label>
		<button type="button" class="btn btn-info" onclick="ppd.open(this);">展开工序</button>
		<button type="button" class="btn btn-info addGx">增加工序</button>
		<button type="button" class="btn btn-info" onclick="$(this).parents('.gongduan').remove();">删除</button></div>
		<div class="form-group"><label>工段名称</label><input type="text" class="form-control gdName"></div>
		<div class="form-group"><label>工段编号</label><input type="text" class="form-control gdNo"></div>
		<div class="clearfix"></div>
	</div>
	<div class="gongxuList"></div>
	</div>
</div>
<div id="gongxuItem" style="display: none;">
	<div class="gongxu">
		<div class="form-inline">
			<div class="form-group"><label><input type="checkbox" class="use">使用</label>
			<button type="button" class="btn btn-info" onclick="ppd.open(this,'下级');">展开下级</button>
			<button type="button" class="btn btn-info addNextGx">增加下级</button>
			<button type="button" class="btn btn-info" onclick="$(this).parents('.gongxu').remove();">删除</button></div>
			<div class="form-group"><label>工序名称</label><input type="text" class="form-control gxName"></div>
			<div class="form-group"><label>工序编码</label><input type="text" class="form-control gxNo" data-num="zimu"></div>
			<div class="form-group"><label>工序价格</label><input type="text" class="form-control gxPrice" data-num="num2"></div>
			<div class="clearfix"></div>
		</div>
		<div class="gongxuNextList"></div>
	</div>
</div>
<div id="gongxuNextItem" style="display: none;">
	<div class="gongxu-next-item form-inline">
		<div class="form-group"><label><input type="checkbox" class="use">使用</label><button type="button" class="btn btn-info" onclick="$(this).parents('.gongxu-next-item').remove();">删除</button></div>
		<div class="form-group"><label>工序名称</label><input type="text" class="form-control gxName"></div>
		<div class="form-group"><label>工序编码</label><input type="text" class="form-control gxNo" data-num="zimu"></div>
		<div class="form-group"><label>工序价格</label><input type="text" class="form-control gxPrice" data-num="num2"></div>
		<div class="clearfix"></div>
	</div>
</div>
<div class="list panel panel-success">
</div>
</div>
<div id="cop" style="background-color: transparent; color: rgb(127, 127, 127); font-size: 14px;margin:0 auto;margin-top: 10px;text-align: center;width: 100%;" class="copyright textonly">
 蜀ICP备16002921号-1 
 <br>版权所有 <a href="http://www.pulledup.cn">牵引互联</a></div>
 <div class='back-top' id='scroll'></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="ppd.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
weixinShare.init($("title").html(),$("meta[name='description']").attr("content"),"http://www.pulledup.cn/pm/ppd.jpg");
//-->
</script>
</body>
</html>