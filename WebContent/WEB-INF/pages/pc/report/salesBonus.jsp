<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>客户维护</title> 
<%@include file="../pcxy_res.jsp" %>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/report/salesBonus.js${requestScope.ver}"></script>
</head>
<body>
<div id="list">
<div class="header">
	<ol class="breadcrumb">
	  <li><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>直销奖金报表</li>
	</ol>
	<div class="header-title">
	直销奖金报表<a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
	</div>
</div>
<div class="left-hide-ctn" style="display: none;">
	<form class="form-inline" style="overflow:hidden;">
	<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
					<div class="form-group" style="margin-bottom: 15px; width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">开始日期</label>
						</div>
						<div class="col-lg-9">
							<input type="date" class="form-control input-sm Wdate"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
								style="float: left;">
							<div style="clear: both"></div>
						</div>
					</div>
					<div class="form-group" style="width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">结束日期</label>
						</div>
						<div class="col-lg-9">
							<input type="date" class="form-control input-sm Wdate"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
								style="float: left;">
							<div style="clear: both"></div>
						</div>
					</div>
				</div>
		<div class="col-sm-6 col-xs-6 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
	  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  		</div>
		</div> 
	  	<div class="col-sm-6 col-xs-6 m-t-b">
	  	</div>
	</form>
	<div class="tree">
		<ul>
		<li><span id="treeAll" style="display: none;"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
		</li>
		</ul>
		<ul>
		<c:forEach items="${requestScope.clients}" var="client">
		<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${client.corp_name}
		<input type="hidden" value="${client.customer_id}"></span></li>
		</c:forEach>
		</ul>
	</div>
</div>
<div class="cover" style="display: none;"></div>
<div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head">
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
			<c:if test="${requestScope.auth.excel!=null}">
<!-- 		    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('salesCommission');">导出</button> -->
		    </c:if>
  		</div>
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">客户名称</th>
					       <th width="200">所有下级客户销售数量</th>
					       <th width="200">所有下级客户销售金额</th>
					       <th width="200">奖金比例(%)</th> 
					       <th width="200">奖金金额</th>
<!-- 					       <th width="200">是否已付款</th>   -->
<!-- 					       <th width="200">操作</th>  -->
					    </tr>
					</thead>
					<tbody>
					<tr>
					<td>客户02</td>
					<td>20</td>
					<td>2000.00</td>
					<td>1</td>
					<td>20</td>
<!-- 					<td>否</td> -->
<!-- 					<td><button type="button" class="btn btn-primary">付款</button></td> -->
					</tr>
					<tr>
					<td>客户03</td>
					<td>20</td>
					<td>2000.00</td>
					<td>1</td>
					<td>20</td>
<!-- 					<td>是</td> -->
<!-- 					<td></td> -->
					</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div class="box-footer">
			<div class="form-inline" style="display: none;">
				<div class="form-group pull-left">
				    <label>合计</label>
				    <span class="form-control" >${requestScope.pages.totalRecord}</span>
				</div>
			</div>
		</div>
	</div>
</div>
<%@include file="../footer.jsp" %>
</div>
<div id="editpage"></div>
</body>

</html>