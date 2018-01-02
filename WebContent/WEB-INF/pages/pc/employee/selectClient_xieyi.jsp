<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
	<script type="text/javascript" src="../js/o2otree.js"></script>
	<script type="text/javascript" src="../pc/js/employee/selectClient.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>选择客户</li>
	</ol>
	<div class="header-title">员工-选择客户
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container-fluid" style="margin-top:10px;">
	<div class="row">
		<div class="col-lg-4 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head">
					<form class="form-inline">
					<input type="hidden" id="employeeId" value="${sessionScope.userInfo.clerk_id}">
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>客户姓名</label>
					    		<input type="text" class="form-control input-sm" id="corp_name" maxlength="30">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>手机号</label>
					    		<input type="text" class="form-control input-sm" id="personnel.clerk_name" maxlength="11" data-number="num">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>渠道类型</label>
					    		<select class="form-control input-sm" id="ditch_type">
<!-- 					                  <option value="消费者" style="display: none;">消费者</option> -->
<!-- 					                  <option value="普通经销商" style="display: none;">普通经销商</option> -->
					                  <option value="合同经销商" selected="selected">合同经销商</option>
					                </select>
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>行政区划</label>
					    		<div class="input-group">
									<span type="text" class="form-control input-sm" aria-describedby="basic-addon2" id="regionalism_name_cn"></span>
									<span class="input-group-btn">
										<input type="hidden" id="regionalismId">
										<button class="btn btn-default btn-sm" type="button">X</button>
								        <button class="btn btn-success btn-sm" type="button">浏览</button>
								    </span>
								</div>
					  		</div>
						</div>
					  	<div class="col-sm-6 m-t-b">
					  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
					  	</div>
					</form>
				</div>
				<div class="box-body">
					<div class="tree lg-tree">
						<ul>
						<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
						</li>
						</ul>
					</div>
				</div>
            	
			</div>
		</div>
		<div class="col-lg-8 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">客户列表</h4>
					<div class="pull-right">
<!-- 						<a id="add" class="btn btn-success">增加品种</a> -->
						<a id="add" class="btn btn-success">销售合同</a>
					</div>
			  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<table class="table table-bordered" id="dibu">
							<thead>
								<tr>  
								   <th><div class="checkbox"><input type="checkbox" id="allcheck"></div>全选</th>
							       <th>客户姓名</th>  
							       <th>手机号</th> 
							       <th>渠道类型</th>  
							       <th>行政区划</th> 
							       <th>联系人</th>  
							       <th>发货地址</th>
							       <th>司机姓名</th>
							       <th>司机电话</th>
							       <th>货运商联系人</th>
							       <th>货运商电话</th>
							       <th>运货方式</th>  
							    </tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
	
				<div class="box-footer">
					<form class="form-inline">
						<div class="form-group pull-left">
						    <label>合计</label>
						    <input type="text" class="form-control">
						</div>
					</form>
					<div class="pull-right">
					 	<input type="hidden" id="page" value="0">
						<input type="hidden" id="totalPage" >
<!-- 						<input type="hidden" id="nowRecord" value="0"> -->
					    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
					    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
					    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
					    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
					</div>	
				</div>	
			</div>
		</div>
	</div>
</div>
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
</div>
</body>
</html>