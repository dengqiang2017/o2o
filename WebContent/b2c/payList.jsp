<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getVer(request);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>我的付款</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css">
<link rel="stylesheet" href="../pc/css/uploadPingz.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<style type="text/css">
.dataitem{border: 1px solid aqua;font-size: 18px;}
.dataitem div{margin: 5px;}
.dataitem span{margin: 5px;}
.dataitem button{margin-bottom: 5px;}
.dataitem #no{font-size: 16px;}
.dataitem #flag{margin: 0;}
.navbar-fixed-bottom span{font-size: 14px;}
.col-xs-12{border-bottom: 1px solid aqua;font-family: 'Microsoft YaHei',Arial,Helvetica,sans-serif;}
@media (max-width: 758px) {
.col-xs-12 .col-xs-1{margin-left: -8px;}
.col-xs-12 .col-xs-9{padding-left: 10px;}
.col-xs-12 div{font-size:16px;}
.col-xs-12 img{width: 30px;height: 30px;margin-top: 5px;margin-right: 5px;}
.Wdate,#comfirm_flag{width: 140px;display: inline-block !important;}
.form-group{margin-bottom: 10px;}
.find{margin-left: 30px;}
}
@media (min-width: 759px) {
.find{margin-left: 10px;}
.col-xs-12 img{width: 40px;height: 40px;}
.col-xs-12{border-left: 1px solid aqua;}
.form-group{margin-bottom: 20px;}
}
.btn-group li{cursor: pointer;}
#row span{margin: 0!important;}
.btn-group{margin: 0 !important;margin-right: -10px !important;}
.modal-dialog{margin-top: 50px;}
</style>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header-phone">
			<a href="personal_center.jsp" class="header_left">返回</a>我的付款
			<a class="pull-right btn btn-info" id="addPay" style="margin-top: -3px;">新增付款</a>
		</div>
	</nav>
	<div class="container" style="margin-top: 50px;">
	<span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
		<form class="form-inline">
  <div class="form-group">
    <label for="exampleInputName2">日期</label>
	<input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate">
	<input type="date" id="d4312" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
  </div>
  <div class="form-group">
  <label>状态</label>
  <select id="comfirm_flag" class="form-control">
  <option value="">全部</option>
  <option value="N">未确认</option>
  <option value="Y">已确认</option>
  </select>
  <button type="button" class="btn btn-info find">搜索</button>
  </div>
</form>
	<div id="list"></div>
	<div style="display: none;" id="item">
	    <div class="col-xs-12 col-sm-12 col-md-6 dataitem">
	    <div><span id="date"></span><span id="rcv_hw_no"></span><span class="pull-right" id="flag"></span>
	    <div class="clearfix"></div></div>
	    <div>
	    <div id="row" class=" pull-left"><span>￥</span><span id="je"></span>,<span id="no"></span>
	    <span id="sort_id" style="display: none;"></span>
	    <span id="imgsrc" style="display: none;"></span>
	    </div>
	    <div class="btn-group pull-right">
  <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
   	操作 <span class="caret"></span>
  </button>
  <ul class="dropdown-menu">
    <li><a class="edit"><span class="glyphicon glyphicon-edit"></span>修改</a></li>
    <li role="separator" class="divider"></li>
    <li><a id="del"><span class="glyphicon glyphicon-remove"></span>删除</a></li>
    <li role="separator" class="divider"></li>
    <li><a id="showimg"><span class="glyphicon glyphicon-cloud-download"></span>查看凭证</a></li>
    <li role="separator" class="divider"></li>
    <li><a class="upload"><span class="glyphicon glyphicon-cloud-upload"></span>上传凭证</a></li>
    <li role="separator" class="divider"></li>
    <li><a id="bullhorn"><span class="glyphicon glyphicon-bullhorn"></span>申请确认</a></li>
  </ul>
</div><div class="clearfix"></div>
	    </div>
	    </div>
	</div>
	</div>

	<div class="modal-first" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">新增付款</h4>
			</div>
			<div class="modal-body" style="overflow:hidden ; padding: 20px;">
  <form class="form-horizontal">
  <div class="form-group">
    <label for="settlement" class="col-sm-2 control-label">支付方式</label>
    <div class="col-sm-10">
      <select class="form-control" id="settlement"></select>
    </div>
  </div>
  <div class="form-group">
    <label for="jeipt" class="col-sm-2 control-label">支付金额</label>
    <div class="col-sm-10">
      <input type="number" class="form-control" id="jeipt" data-num="num2" maxlength="10">
    </div>
  </div>
  <div class="form-group" style="text-align: center;">
  	 <a id="upload-btn" class="btn btn-primary m-t-b">上传凭证
	<input name="imgFile" id="imgFile" onchange="imgUpload(this);" type="file">
	<input id="filepath" type="hidden">
	</a>
	<button type="button" id="scpz" class="btn btn-primary m-t-b" style="display: none;">上传凭证</button>
	<div class="showimg">
	<img src="images/paydef.jpg">
	</div>
  </div>
</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="save">提交</button>
			</div>
		</div>
	</div>
</div>

<div class="modal" style="display: none;">
   <div class="modal-dialog">
	 <div class="modal-content">
	    <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
		<span class="sr-only">Close</span></button>
		<h4 class="modal-title">查看凭证图片</h4>
		</div>
		<div class="modal-body" style="overflow:hidden ; padding: 10px;">
		<img src="" style="max-width: 100%;max-height: 400px;">
		</div>
		<div class="modal-footer">
				<button type="button" class="btn btn-default">关闭</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/bootstrap.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/payList.js${requestScope.ver}"></script>
</body>
</html>