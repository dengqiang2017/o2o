<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../res.jsp" %>
	<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/report/orderReportDeptCount.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				
				<div class="box-body">
					<div class="ctn">
						<div class="ctn">
							 <%@include file="find.jsp" %>
							<div class="text-center">
								<h3>销量汇总统计报表</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>分部</th>
									       <th>本期销量</th>
									       <th>同期销量</th>
									       <th>本期同比</th>
									       <th>上期销量</th> 
									       <th>本期环比</th> 
									       <th>本年累计销量</th> 
									       <th>上年同期累计销量</th> 
									       <th>本年累计同比</th> 
									    </tr>
									</thead>
									<tbody>
									</tbody>
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
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div> 
</body>
</html>

    