<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">  
<meta http-equiv="expires" content="0">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
td span{
height: 30px;
width: 40%;
cursor: pointer;
text-align: center;
border: 1px solid #ddd;
padding-top: 10px;
}
.td1 span{
    float: left;
    width: 100%;
}
td img{width: 50px;height: 50px;}
.modal-body img{width: 100%;height: 300px;}
td .glyphicon{min-width: 50px;}
</style>
</head>
<body>
<div class="container">
<div class="page-header" style="text-align: center;">
<ol class="breadcrumb pull-left">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
<h3>${requestScope.pageName}</h3>
<h5>第一个轮播图作为微信分享小图</h5>
</div>
<button type="button" class="btn btn-info" id="add">增加图片</button>
<button type="button" class="btn btn-info" onclick="javaScript:bannerpush.saveBanner();">保存操作</button>
<button type="button" class="btn btn-info" onclick="javaScript:bannerpush.setDecGjc();">设置页面描述与关键词</button>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th width="50">顺序</th>
<th width="70">状态</th>
<th>图片</th>
<th>点击链接</th>
<th>操作</th>
</tr>
</thead>
<tbody>
<tr>
<td class="td1">
<span class="glyphicon glyphicon-arrow-up"></span>
<span class="glyphicon glyphicon-arrow-down"></span>
</td>
<td>
<img src="pc/images/logo.png" style="width: 50px;height: 50px; ">
</td>
<td><a href="/ds/commodity.html?com_id=001Y10&item_id=CP001216" target="_blank">/ds/commodity.html?com_id=001Y10&item_id=CP001216</a></td>
<td>
<span class="glyphicon glyphicon-pencil edit"></span>
<span class="glyphicon glyphicon-remove-circle del"></span>
<!-- <span class="glyphicon glyphicon-earphone" style="transform: rotateZ(270deg);"></span> -->
</td>
</tr>
<tr>
<td class="td1">
<span class="glyphicon glyphicon-arrow-up"></span>
<span class="glyphicon glyphicon-arrow-down"></span>
</td>
<td>
<img>
</td>
<td><a href="/ds/commodity.html?com_id=001Y10&item_id=CP001216" target="_blank">/ds/commodity.html?com_id=001Y10&item_id=CP001216</a></td>
<td>
<span class="glyphicon glyphicon-pencil edit"></span>
<span class="glyphicon glyphicon-remove-circle del"></span>
<!-- <span class="glyphicon glyphicon-earphone" style="transform: rotateZ(270deg);"></span> -->
</td>
</tr>
</tbody>
</table>
</div> 

<div class="modal-cover"></div>
<div class="modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">编辑图片</h4>
			</div>
			<div class="modal-body" style="line-height: 70px">
			<div class="input-group">
			<label class="input-group-addon">图片点击链接</label>
			<input type="url" maxlength="150" class="form-control" id="url">
			</div>
			<div class="input-group">
			<input type="file" id="imgfile" name="imgfile" style="display:none" accept="image/*" onchange="imgUpload(this);">  
			<div class="input-append">  
			    <input id="photoCover" class="input-large" type="url" style="height:30px;">  
			    <a class="btn btn-info">选择...</a>  
			</div>  
			<img src="" >
			</div> 
			</div>
			<div class="" style="text-align: center;padding: 10px;">
			<button type="button" class="btn btn-primary">确定</button>
			<button type="button" class="btn btn-default">取消</button>
			</div>
		</div>
	</div>
</div>
<div class="modal-first">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">页面描述与关键词设置</h4>
			</div>
			<div class="modal-body" style="line-height: 70px">
			 <div class="form-group">
			 <label>页面描述(微信分享显示内容)</label><textarea class="form-control" id="description" rows="3" cols="30"></textarea>
			 </div>
			 <div class="form-group">
			 <label>页面关键词</label><textarea class="form-control" rows="3" id="keywords" cols="30"></textarea>
			 </div>
			</div>
			<div class="" style="text-align: center;padding: 10px;">
			<button type="button" class="btn btn-primary">确定</button>
			<button type="button" class="btn btn-default">取消</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/bannerpush.js${requestScope.ver}"></script>
</body>
</html>