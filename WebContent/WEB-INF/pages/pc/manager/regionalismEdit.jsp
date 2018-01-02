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
	<%@include file="../pcxy_res.jsp" %><script src="../js/o2otree.js?ver=001"></script>
	<script type="text/javascript" src="../pc/js/regionalismEdit.js"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="regionalism.do">行政区划</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>行政区划详细</li>
		</ol>
		<div class="header-title">行政区划详细
			<a href="regionalism.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body" style="min-height:500px;">
				<div class="form">
				<form id="setForm">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>行政区划编码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" 
					    	name="${sessionScope.prefix}regionalism_id" maxlength="30">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>行政区划</label>
					    	<input type="text" class="form-control input-sm" title="输入行政区划" id="fs"
					    	name="${sessionScope.prefix}regionalism_name_cn" maxlength="15">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>记忆码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" id="jym"
					    	name="${sessionScope.prefix}easy_id" maxlength="10">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>所属上级区划编码</label>
					    	<div class="input-group">
								<span type="text" class="form-control input-sm" disabled="disabled" title="点击浏览选择上级行业类型" 
								name="${sessionScope.prefix}upper_regionalism_name" id="regionalism_name_cn" maxlength="5"></span>
								<span class="input-group-btn">
									<input type="hidden" name="${sessionScope.prefix}upper_regionalism_id" id="regionalismId">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>所属销售部门编码</label>
					    	<div class="input-group">
								<span class="form-control input-sm" title="点击浏览选择销售部门" 
								 id="dept_name" ></span>
								<span class="input-group-btn">
									<input type="hidden" name="${sessionScope.prefix}dept_id" id="deptId">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>市场类型</label>
					    	<input type="text" class="form-control input-sm" title="输入市场类型" name="${sessionScope.prefix}market_type" maxlength="25">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>是否用于统计</label>
								<select name="${sessionScope.prefix}if_statistic"  class="form-control input-sm">
									<option value="0">否</option>
									<option value="1" selected="selected">是</option>
								</select>
					  	</div>
					</div>
					<input type="hidden" name="${sessionScope.prefix}sort_id">
					</form>
				</div>
			</div>
		</div>

	</div>

	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a href="regionalism.do" class="btn btn-primary">返回</a>
		</div>	
	</div>
</body>
</html>