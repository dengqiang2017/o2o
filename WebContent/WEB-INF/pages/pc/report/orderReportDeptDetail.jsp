<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/orderReportDeptDetail.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-head">
				<%@include file="find.jsp" %>
					<ul class="nav nav-tabs" style="margin-top:10px;">
					    <li class="active"><a>明细统计</a></li>
					    <li><a>客户统计</a></li>
					    <li><a>业务员统计</a></li>
					    <li><a>销售记录</a></li>
					</ul>
		 	 	</div>
				<div class="box-body">
					<!-- 分客户 -->
					<div class="tabs-content">
						<div class="ctn">
							<div class="text-center">
								<h3>销售统计报表</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>部门</th>  
									       <th>业务员</th>   
									       <th>客户</th>  
									       <th>产品类别</th> 
									       <th>产品简称</th> 
									       <th>本期销量</th> 
									       <th>同期销量</th> 
									       <th>本年销量累计</th> 
									       <th>上年同期销量累计</th> 
									       <th>基本单位</th> 
									    </tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
 
							<div class="pull-right" style="display: none;">
							    <button type="button" class="btn btn-info btn-sm">首页</button>
							    <button type="button" class="btn btn-info btn-sm">上一页</button>
							    <button type="button" class="btn btn-info btn-sm">下一页</button>
							    <button type="button" class="btn btn-info btn-sm">末页</button>
							</div>
						</div>
					</div>

					<!-- 客户统计 -->
					<div class="tabs-content">
						<div class="ctn">
							<div class="text-center">
								<h3>销售统计报表</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>部门</th>  
									       <th>客户</th>  
									       <th>产品类别</th> 
									       <th>产品简称</th>  
									       <th>本期销量</th> 
									       <th>同期销量</th> 
									       <th>本年销量累计</th> 
									       <th>上年同期销量累计</th> 
									       <th>基本单位</th> 
									    </tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div class="pull-right" style="display: none;">
							    <button type="button" class="btn btn-info btn-sm">首页</button>
							    <button type="button" class="btn btn-info btn-sm">上一页</button>
							    <button type="button" class="btn btn-info btn-sm">下一页</button>
							    <button type="button" class="btn btn-info btn-sm">末页</button>
							</div>
						</div>
					</div>
<!-- 					业务员统计 -->
					<div class="tabs-content">
						<div class="ctn">
							<div class="text-center">
								<h3>销售统计报表</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>部门</th>
									       <th>业务员</th>
									       <th>产品类别</th>
									       <th>产品简称</th>
									       <th>本期销量</th>
									       <th>同期销量</th>
									       <th>本年销量累计</th>
									       <th>上年同期销量累计</th>
									       <th>计量单位</th>
									    </tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div class="pull-right" style="display: none;">
							    <button type="button" class="btn btn-info btn-sm">首页</button>
							    <button type="button" class="btn btn-info btn-sm">上一页</button>
							    <button type="button" class="btn btn-info btn-sm">下一页</button>
							    <button type="button" class="btn btn-info btn-sm">末页</button>
							</div>
						</div>
					</div>
<!-- 					销售记录 -->
					<div class="tabs-content">
						<div class="ctn">
							<div class="text-center">
								<h3>销售统计报表</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>部门</th>  
									       <th>业务员</th>  
									       <th>客户</th>  
									       <th>产品类别</th> 
									       <th>产品简称</th>  
									       <th>发货数量</th> 
									       <th>结算单价</th> 
									       <th>应收金额</th> 
									       <th>发货时间</th> 
									       <th>订单号</th> 
									    </tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<div class="pull-right" style="display: none;">
							    <button type="button" class="btn btn-info btn-sm">首页</button>
							    <button type="button" class="btn btn-info btn-sm">上一页</button>
							    <button type="button" class="btn btn-info btn-sm">下一页</button>
							    <button type="button" class="btn btn-info btn-sm">末页</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}<!-- <span class="glyphicon glyphicon-earphone"></span> -->
</div>
</body>
</html>

 