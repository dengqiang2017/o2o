<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/choiceSupplier.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/procurementAccount.js${requestScope.ver}"></script>
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
	<%@include file="../employee/selSupplier.jsp"%>
	<div class="container">
		<div class="row">
			<div class="ctn">
				<div class="ctn-fff box-ctn" style="min-height: 750px;">
				 	<div class="box-head">
					<%@include file="../employee/showSelectSupplier.jsp" %>
       				</div>
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
									<h3>采购入库明细</h3>
								</div>
								<div class="table-responsive">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th>入库单号</th>
												<th>入库日期</th>
												<th>供应商</th>
												<th>采购单价</th>
												<th>入库数量</th>
												<th>金额</th>
												<th>入货仓库</th>
												<th>产品名称</th>
												<th>产品编码</th>
												<th>产品规格</th>
												<th>产品型号</th>
												<th>产品颜色</th>
												<th>产品单位</th>
												<th>产品折扣</th>
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

