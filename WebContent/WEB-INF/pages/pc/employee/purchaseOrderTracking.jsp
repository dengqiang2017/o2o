<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 采购订单跟踪 -->
<%@include file="../res.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
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
<%@include file="../header.jsp" %>
	<div class="container">
		<div class="row">
			<div class="ctn">
				<div class="ctn-fff box-ctn" style="min-height: 750px;">
					<div class="box-body">
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
								<%@include file="../purchaseOrderTracking.jsp"%>
								<div class="text-center">
									<h3>采购订单跟踪</h3>
								</div>
								<div class="table-responsive">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th>订货单号</th>
												<th>订货日期</th>
												<th>订货数量</th>
												<th>收货数量</th>
												<th>未收货数量</th>
												<th>状态</th>
												<th>供应商</th>
												<th>联系电话</th>
												<th>产品编码</th>
												<th>产品名称</th>
												<th>单价</th>
												<th>规格</th>
												<th>型号</th>
												<th>颜色</th>
												<th>基本单位</th>
												<th>包装单位</th>
												<th>金额(元)</th>
												<th>折扣(%)</th>
											</tr>
										</thead>
										<tbody></tbody>
									</table>
								</div>
								<div class="pull-right">
									<span style="width: 50px;height: 20px;text-align: center;line-height: 20px" id="page">当前页:0</span>
					    			<input type="hidden" value="" id="totalPage">
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

