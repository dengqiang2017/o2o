<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/myOA.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp"%>
<input type="hidden" id="isAutoFind" value="${sessionScope.isAutoFind}">
<input type="hidden" id="clerk_id" value="${sessionScope.userInfo.personnel.clerk_id}">
<input type="hidden" id="com_id" value="${sessionScope.userInfo.com_id}">
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<ul class="nav nav-tabs">
					<li class="active"><a>待办 <span class="badge">0</span></a></li>
					<li><a>已办</a></li>
					<li><a>已申请</a></li>
				</ul>
				<div class="ctn">
					<div class="col-sm-3 col-xs-6 m-t-b">
						<div class="form-group">
							<label for="">发起人</label> <input type="text"
								class="form-control input-sm"
								  id="OA_who">
						</div>
					</div>
					<div class="col-sm-3 col-xs-6 m-t-b">
						<div class="form-group">
							<label for="">发起日期</label> <input type="date"
								class="form-control input-sm Wdate"
								name="store_date" id="store_date"  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
						</div>
					</div>
					<div class="col-sm-3 col-xs-6 m-t-b">
						<div class="form-group">
							<label for="">类别</label> <select 
								class="form-control input-sm"
								name="type_id" id="type_id">
								<option></option>
								<option value="1">业务类</option>
								<option value="2">文牍类</option>
							</select>
						</div>
					</div>
					<div class="col-sm-3 col-xs-6 m-t-b" style="display: none;">
						<div class="form-group">
							<label for="">审批内容</label> <select 
								class="form-control input-sm"
								 id="sd_order_id">
								<option value=""></option>
								<option value="额度">信用额度</option>
								<option value="提前使用预存款">提前使用预存款</option>
								<option value="临时赊欠">临时赊欠</option>
								<option value="费用报销">费用报销</option>
							</select>
						</div>
					</div>
					<div class="ctn">
						<button class="btn btn-primary find" type="button">查询</button>
						<a class="btn btn-primary" href="coordination.do">协同申请</a>
					</div>
				</div>
			</div>
			<div class="box-body">
				<div class="tabs-content">
				</div>
				<div style="display: none;">
					<div class="alert alert-danger">
						<div class="col-sm-2 m-t-b" id="OA_who_item"></div>
						<div class="col-sm-4 m-t-b" id="OA_what_item"></div>
						<div class="col-sm-2 m-t-b" id="store_date_item"></div>
						<div class="col-sm-2 m-t-b">
							<a href="quotaApproval.do" class="btn btn-danger btn-sm">审批</a>
						</div>
					</div>
				</div>
				<div class="tabs-content">
				</div>
				<div class="tabs-content">
				</div>
				<div style="display: none;">
					<div class="alert alert-info">
						<div class="col-sm-2 m-t-b" id="OA_who_item"></div>
						<div class="col-sm-2 m-t-b" id="OA_what_item"></div>
						<div class="col-sm-2 m-t-b" id="store_date_item"></div>
						<div class="col-sm-2 m-t-b" id="approval_YesOrNo_item"></div>
						<div class="col-sm-2 m-t-b">
							<a class="btn btn-primary btn-sm">查看详细</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span>
	</div>
</body>
</html>