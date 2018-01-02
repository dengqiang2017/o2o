<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<!-- <script type="text/javascript" -->
<%-- 	src="../pc/js/employee/selClient.js${requestScope.ver}"></script> --%>
<script type="text/javascript"
	src="../pc/js/employee/purchaseOrderTracking.js${requestScope.ver}"></script>
</head>
<style type="text/css">
@media ( max-width : 770px) {
	.xsmargin {
		margin-bottom: 40px;
	}
}

ul>li {
	list-style: none;
}

ul {
	padding-left: 0
}
</style>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../employee.do">员工首页</a></li>
			<li class="active"><span
				class="glyphicon glyphicon-triangle-right"></span>采购明细统计</li>
		</ol>
		<div class="header-title">
			员工-采购明细统计 <a href="../employee.do" class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
	</div>
	<div class="container">
		<div class="row">
			<div class="ctn">
				<div class="ctn-fff box-ctn" style="min-height: 750px;">
					<div class="box-body">
						<!-- 分客户 -->
						<div class="tabs-content">
							<input type="hidden" id="emplHeadship"
								value="${sessionScope.userInfo.personnel.headship}"> <input
								type="hidden" id="emplclerk_name"
								value="${sessionScope.userInfo.personnel.clerk_name}"> <input
								type="hidden" id="isAutoFind" value="${sessionScope.isAutoFind}">
							<div class="ctn">
								<div class="folding-btn m-t-b">
									<button type="button"
										class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button>
								</div>
								<%@include file="../procurementAccount.jsp"%>
								<div class="text-center">
									<h3>采购明细统计</h3>
								</div>
								<div class="table-responsive">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th><div class="checkbox"></div></th>
												<th>采购单号</th>
												<th>采购日期</th>
												<th>入货仓位</th>
												<th>产品编码</th>
												<th>产品名称</th>
												<th>规格</th>
												<th>型号</th>
												<th>颜色</th>
												<th>基本单位</th>
												<th>总数量</th>
												<th>单价</th>
												<th>金额</th>
												<th>折扣</th>
											</tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="pull-right">
									<button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
									<button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
									<button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
									<button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}
	</div>
</body>
</html>

