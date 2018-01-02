<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>牵引O2O营销服务平台</title>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<%@include file="../res.jsp"%>
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/settlementEdit.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="settlement.do">结算方式</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>结算方式详细</li>
		</ol>
		<div class="header-title">员工-结算方式详细
			<a href="settlement.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn">
		<form id="editForm">		
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body" style="min-height:500px;">
				<div class="form">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>结算方式编码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" 
					    	name="settlement_type_id" maxlength="30" data-num="num" >
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>结算方式</label>
					    	<input type="text" class="form-control input-sm" title="输入结算方式" id="fs"
					    	name="settlement_sim_name" maxlength="15"  >
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>记忆码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" id="jym"
					    	name="easy_id" maxlength="30" >
					  	</div>
					</div> 
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>上级结算方式</label>
					    	<div class="input-group">
					    	<span class="form-control input-sm" title="点击浏览选择结算方式" 
								 id="upper_settlement_name"></span>
								<span class="input-group-btn">
								<input type="hidden" name="upper_settlement_id" id="upper_settlement_id">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>账户性质</label>
					    	<select name="cheque_flag" class="form-control input-sm">
					    	<option value="账上款">账上款</option>
					    	<option value="预存款">预存款</option>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>期初金额</label>
					    	<input type="text" class="form-control input-sm" title="输入期初金额" name="i_Amount" maxlength="17" data-number="num">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>户头全称</label>
					    	<input type="text" class="form-control input-sm" title="输入户头全称" name="c_fullname" maxlength="10">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>账号</label>
					    	<input type="text" class="form-control input-sm" title="输入账号" name="c_accounts" maxlength="60">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>省份</label>
					    	<input type="text" class="form-control input-sm" title="输入户省份名称" name="c_province" maxlength="10">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>城市</label>
					    	<input type="text" class="form-control input-sm" title="输入城市名称" name="c_city" maxlength="10">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>银行名称</label>
					    	<input type="text" class="form-control input-sm" title="输入银行名称" name="c_backname" maxlength="30" >
					  	</div>
					</div>

					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>所属部门</label>
					    	<div class="input-group">
								<span class="form-control input-sm" placeholder="点击浏览选择部门" 
								id="dept_name"></span>
								<span class="input-group-btn">
								<input type="hidden" name="dept_id" id="deptId">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
				</div>
			</div>
			<input type="hidden" name="sort_id">
			</form>
		</div>

	</div>

	<div class="footer">
	 员工:${sessionScope.userInfo.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a href="settlement.do" class="btn btn-primary">返回</a>
		</div>	
	</div> 
</body>
</html>