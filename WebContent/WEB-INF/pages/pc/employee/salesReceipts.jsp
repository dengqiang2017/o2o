<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script src="../js/o2od.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/employee/salesReceipts.js${requestScope.ver}"></script>
	
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售收款单</li>
	</ol>
	<div class="header-title">员工- 销售收款单
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
<%@include file="../employee/selClient.jsp" %>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;"> 
			<div class="box-head">
				<%@include file="../employee/showSelectClient.jsp" %>
       		</div>
				<div class="box-body">
					<div class="tabs-content">
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
				        </div>
						<form style="clear:both;overflow:hidden;">
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
				                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入搜索关键词">
				              </div>
				            </div>
				            <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结算方式</label>
				                <div class="input-group">
									<span class="form-control input-sm" id="settlement_name"></span>
									<span class="input-group-btn">
									<input type="hidden" class="form-control input-sm"  id="settlement_id" name="rcv_hw_no">
										<button type="button" class="btn btn-default btn-sm">X</button>	
								        <button class="btn btn-success btn-sm" type="button">浏览</button>
								    </span>
								</div>
				              </div>
				            </div> 
				            <div class="col-sm-6 col-lg-4 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
				            </div>
						</form>
			            	<a id="addSales" class="btn btn-primary btn-sm" style="margin-top:25px;">新增</a>
<!-- 			            	<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;">导出</button> -->
						<div class="text-center">
							<h3>销售收款单</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>收款日期</th>   
								       <th>客户名称</th>  
 								       <th>实收金额</th>   
								       <th>结算方式</th>   
								       <th>收款单号</th>  
								       <th>收款部门</th> 
								       <th>收款人</th> 
								       <th>销售单号</th> 
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

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

 