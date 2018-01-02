<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
	<div class="header-title">${requestScope.pageName}
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
<div class="container">
	 <div class="box-head">
	 <form style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">关键词</label> <input class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词" type="text">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">起始日期</label> <input id="d4311" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate" type="date">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">结束日期</label> <input id="d4312" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate" type="date">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">状态</label> 
			<select id="planResult" class="form-control"></select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" class="btn btn-primary btn-sm find" style="margin-top: 25px;">搜索</button>
<!-- 		<button type="button" class="btn btn-danger btn-sm print" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>打印</button> -->
		<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>导出</button>
	</div>
</form>
	 </div>
	 <div class="box-body">
	 <div>
		 <table class="table table-striped table-condensed table-bordered">
            <thead>
            <tr>
            <th data-name="xuhao">序号</th>
            <th data-name="clerkName">员工名称</th>
            <th data-name="planTime">计划时间</th>
            <th data-name="planContent">计划内容</th>
            <th data-name="planDescribe">结果备注</th>
            <th data-name="planResult">计划结果</th>
            </tr>
            </thead>
            <tbody></tbody>
            </table>
	 </div>
           <nav aria-label="分页">
			  <div style="float: left;margin-top: -6px;" id="page">
			  第1页/共1页
			  </div>
			  <ul class="pager" style="cursor: pointer;margin-top: -6px;">
			    <li><a><span class="glyphicon glyphicon-step-backward"></span>首页</a></li>
			    <li><a><span class="glyphicon glyphicon-backward"></span>上一页</a></li>
			    <li><a>下一页<span class="glyphicon glyphicon-forward"></span></a></li>
			    <li><a>末页<span class="glyphicon glyphicon-step-forward"></span></a></li>
			  </ul>
			</nav>
	 </div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/page.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/workPlanReport.js${requestScope.ver}"></script>
</body>
</html>