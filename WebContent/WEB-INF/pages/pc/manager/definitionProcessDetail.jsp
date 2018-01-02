<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate"> 
<meta http-equiv="expires" content="0">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="renderer" content="webkit">
<title>流程定义-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/definition/processDetail.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
		<li><span class="glyphicon glyphicon-triangle-right"></span><a
			href="../employee.do">${sessionScope.indexName}</a></li>
		<li><span class="glyphicon glyphicon-triangle-right"></span><a
			href="definitionProcess.do">定义协同流程</a></li>
		<li class="active"><span
			class="glyphicon glyphicon-triangle-right"></span>流程定义</li>
	</ol>
	<div class="header-title">
		流程定义<a href="../employee.do" class="header-back"><span
			class="glyphicon glyphicon-menu-left"></span></a>
	</div>
	<div class="header-logo"></div>
	<input type="hidden" id='accnIvt' value="${requestScope.accnIvt}">
	<span style="display: none;" id="com_id">${sessionScope.userInfo.com_id}</span>
</div>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="min-height:600px;">
    		<div class="box-head">
    			流程定义
    		</div>
    		<div class="box-body">
    			<div class="ctn">
					<button type="button" class="btn btn-primary" >新增审批步骤</button>
					<button type="button" class="btn btn-primary" >抄送</button>
					<input type="hidden" id="item_name">
					<input type="hidden" id="item_id">
					<input type="hidden" id="type_id">
				</div>
				<div class="ctn" style="margin-top:10px;" id="item01">
					<div class="col-lg-3 col-sm-4">
						<div class="panel panel-info sp-ctn">
						<input type="hidden" id="seeds_id">
							<div class="panel-heading sp-head">序号:1</div>
							<div class="panel-body sp-body">
								<div class="ctn">
									<div class="col-xs-4 sp-label">审批人</div>
									<div class="col-xs-8 sp-content" id="clerkName"></div>
									<div id="clerk_id" style="display: none;"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">审批部门</div>
									<div class="col-xs-8 sp-content" id="deptName"></div>
									<div id="dept_id" style="display: none;"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">审批步骤</div>
									<div class="col-xs-8 sp-content" id="approvalStep"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">是否可跳过</div>
									<div class="col-xs-8 sp-content" id="if_skip">否</div>
								</div>
							</div>
							<div class="panel-footer">
								<button type="button" class="btn btn-xs btn-info" id="upmove">上移</button>
								<button type="button" class="btn btn-xs btn-info" id="downmove">下移</button>
								<button type="button" class="btn btn-xs btn-primary" id="editprocess">编辑</button>
								<button type="button" class="btn btn-xs btn-danger" id="delprocess">删除</button>
							</div>
						</div>
					</div>
 
				</div>	
    		</div>
    	</div>
    </div>
    <div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
        <div class="btn-gp">
<!-- 			<button class="btn btn-info">保存</button> -->
			<a href="definitionProcess.do" class="btn btn-primary">返回</a>
		</div>	
    </div>
</body>
</html>