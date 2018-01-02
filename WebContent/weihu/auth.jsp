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
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>应用功能模块显示控制-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="../pc/css/chehuachu.css${requestScope.ver}">
<style type="text/css">
	*{
		font-family: Microsoft YaHei;
	}
	input{
		font-family: Microsoft YaHei;
	}
.nextItem{
    margin-bottom: 14px;
	border-bottom: 1px solid #999;
	padding-bottom: 24px;
}
	.box{
		border: 1px solid #dddddd;
	}
	.box-header{
		border-bottom:1px solid #dddddd ;
		margin-bottom: 5px;
		padding: 20px 0;
		background-color: #dddddd;
	}
	.next{
		display: none;
	}
	.btn-box{
		padding: 10px;
		width: 290px;
	}
	.next{
		width: 90%;
		margin: auto;
	}
	.tc img{
	width: 70px;
	height: 100x;
	margin: 1px;
	padding: 1px;
	border: 2px solid #ccc;
	}
</style>
</head>
<body>
<div class="page-header">
<ol class="breadcrumb navbar navbar-default navbar-fixed-top">
  <li><a href="../employee.do">${sessionScope.indexName}&gt;</a></li>
  <li class="active">应用功能模块显示控制</li>
  <li>
  &emsp;&emsp;&emsp;&emsp;
<button type="button" class="btn btn-danger add" style="margin-right: 30px;padding: 7px;font-size: 16px;">增加大模块</button>
<button type="button" class="btn btn-danger save" style="padding: 7px;font-size: 16px;">保存数据</button>
  </li>
</ol>
</div>
<div id="list" class="container"></div>
<div id="item" style="display: none;">
<div class="item box">
	<div class="box-header">
<div class="col-sm-1" style="margin-top: 25px">
	<label>
	<input type="checkbox" name="checked" checked="checked" onclick="headerCheckbox(this);">使用
	</label>
</div>
<div class="col-sm-1" style="margin-top: 25px">
			<button type="button" class="btn btn-danger btn-sm zk" style="margin-right: 0" onclick="$(this).parents('.item').find('.next').slideToggle();">展开</button>
<!-- 			<button type="button" class="btn btn-danger btn-sm up" style="margin-right: 0" onclick="upmove(this);">上移</button> -->
<!-- 			<button type="button" class="btn btn-danger btn-sm down" style="margin-right: 0" onclick="nextmove(this);">下移</button> -->
		</div>
<div class="col-sm-4">
<label>权限英文名称</label>
<input type="text" placeholder="权限英文名称" data-num="zimu" name="name" maxlength="30" class="form-control">
</div>
<div class="col-sm-3">
<label>权限中文名称</label>
<input type="text" placeholder="权限中文名称" name="name_ch" maxlength="30" class="form-control">
</div>
<div class="col-sm-2" style="margin-top: 25px">
<button type="button" class="btn btn-danger btn-sm addNext" style="margin-right: 0" onclick="addNext(this)">增加下级</button>
			</div>
		<div class="clearfix"></div>
	</div>
<div class="next">
</div>
</div>
</div>
<div id="nextItem" style="display: none;">
<div class="nextItem">
<div class="col-sm-1" style="margin-top: 25px">
	<label>
<input type="checkbox" name="checked" checked="checked" onclick="nextCheckbox(this)">使用
		</label>
</div>
<div class="col-sm-2">
<label>权限英文名称</label>
<input type="text" placeholder="权限英文名称" data-num="zimu" name="name" maxlength="30" class="form-control">
</div>
<div class="col-sm-3">
<label>权限中文名称</label>
<input type="text" placeholder="权限中文名称" name="name_ch" maxlength="30" class="form-control">
</div>
<div class="col-sm-3">
<label>对应链接(功能性请保持为空)</label>
<input type="text" placeholder="进入网址,功能性请保持为空" name="url"  data-num="zimu" maxlength="40" class="form-control">
</div>
<div class="col-sm-2" style="margin-top: 25px">
<button type="button" class="btn btn-danger btn-sm" onclick="$(this).parents('.nextItem').remove();">删除</button>
<button type="button" class="btn btn-danger btn-sm logo" style="margin-right: 0" onclick="logobtnselect(this);">图标</button>
<img src="" style="width: 50px;height: 50px;">
		</div>
	<div class="clearfix"></div>
</div>
</div>
<a href="#cop" class="back-bottom"></a>
<div class='back-top' id='scroll'></div>
    <div class="tc" style="height: 100%;top: 0;">
        <div class="tc_top">员工首页logo列表(点击选择)
        <button type="button" class="btn btn-default">关闭</button>
        </div>
        <div class="panel-body">
        <label>logo图片服务器地址</label>
        <input type="text" value="/pcxy/logo_images/" id="imgpath">
        <button type="button" class="btn btn-info" id="reloadimg">重新获取</button>
        </div>
        <div class="panel-body" style="overflow-y: scroll; height: 80%">
        </div>
    </div>
    <div class="zhezhao" style="position: fixed;left: 0;right: 0;top: 0;bottom: 0;background-color: #000;opacity: 0.6;z-index: 990;display: none;"></div>
<!--------------------------->
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="auth.js${requestScope.ver}"></script>
</body>
</html>