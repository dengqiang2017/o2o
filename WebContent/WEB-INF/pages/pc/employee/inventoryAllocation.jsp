<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp"%>
	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
	<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
	<script type="text/javascript" src="../pc/js/employee/inventoryAllocation.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>库存调拨单</li>
	</ol>
	<div class="header-title">员工-库存调拨单
		<a href="function-gly.html" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;"> 
				<div class="box-body">
					<div class="tabs-content">
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding">展开</button>
				        </div>
						<form action="" style="clear:both;overflow:hidden;">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">起始日期</label>
				                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="beginDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结束日期</label>
				                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="endDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">关键词</label>
				                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20">
				              </div>
				            </div>
				            <div class="col-sm-6 col-lg-4 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
				            </div>
						</form>
<!-- 			            	<a href="" target="_blank" class="btn btn-primary btn-sm" id="hide" style="margin-top:25px;">新增</a> -->
<!-- 			            	<span  id="upload-btn" class="btn btn-sm btn-danger" style="margin-top:25px;">导入 -->
<!-- 								<input type="file" id="xlsinventoryAllocation" name="xlsinventoryAllocation" onchange="excelImport(this,'inventoryAllocation');"> -->
<!-- 							</span> -->
<!-- 			            	<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;">导出</button> -->
						<div class="text-center">
							<h3>库存调拨单</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>调拨日期</th> 
								       <th>产品名称</th> 
								       <th>规格</th> 
								       <th>型号</th>
								       <th>总金额</th>
								       <th>调入仓库</th>   
								       <th>调出仓库</th>
								       <th>责任人</th> 
 								       <th>责任部门</th>
								       <th>调拨单号</th>   
								    </tr>
								</thead>
								<tbody></tbody>
							</table>
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

