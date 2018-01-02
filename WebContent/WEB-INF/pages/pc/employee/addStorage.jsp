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
<%@include file="../pcxy_res.jsp" %>
<script src="../js/o2otree.js?ver=001"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
<script type="text/javascript" src="../pc/js/addStorage.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="purchasingCheck.do">采购入库</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>新增验收入库</li>
		</ol>
		<div class="header-title">员工-新增验收入库
			<a href="productlist.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container" style="margin-top:10px;">
	<form id="storageForm">
		<div class="ctn-fff box-ctn">
			<div class="box-body">
				<div class="form">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>采购单号</label>
					    	<input type="text" class="form-control input-sm" data-number="n" name="st_auto_no" maxlength="40">
					  	</div>
					</div>
				</div>
				 <div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>供应商</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2"  id="vendor_name" ></span>
							<span class="input-group-btn">
								<input id="vendorId" type="hidden" name="vendor_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm corp" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>联系电话</label>
				    	<input type="tel" class="form-control input-sm" data-number="n"  name="tel_no"  maxlength="50">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>总搬运费</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="convey_charge"  maxlength="20">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>结算方式</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2"  id="settlement_name" ></span>
							<span class="input-group-btn">
								<input id="settlementId" type="hidden" name="settlement_type_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm settlement" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>经办人</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2"  id="clerk_name" ></span>
							<span class="input-group-btn">
								<input id="clerkId" type="hidden" name="clerk_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>经办部门</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2"  id="dept_name"></span>
							<span class="input-group-btn">
								<input id="deptId" type="hidden" name="dept_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm dept" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>库存类型</label>
				    	<input type="text" class="form-control input-sm" name="stock_type" maxlength="15">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>付款日期</label>
				    	<input type="text" class="form-control input-sm" data-number="n"  name="cgt_day"  maxlength="15">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>付款金额</label>
				    	<input type="text" class="form-control input-sm" data-number="n"  name="pay_sum"  maxlength="15"> 	
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>未付余额</label>
				    	<input type="text" class="form-control input-sm" data-number="n"  name="arrearage" maxlength="15">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>总金额</label>
				    	<input type="text" class="form-control input-sm" data-number="n"  name="st_sum" maxlength="40">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>备注</label>
				    	<input type="text" class="form-control input-sm" name="c_memo"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>产品名称</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2" id="item_name"></span>
							<span class="input-group-btn">
								<input id="itemId" type="hidden" name="item_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm item" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>税率</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="tax_rate"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>税额</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="tax_sum"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>价税合计</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="allSum"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>入货仓库</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2" id="store_struct_name"></span>
							<span class="input-group-btn">
								<input id="storestructId" type="hidden" name="store_struct_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm store" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>入库数量</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="rep_qty"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>入库金额</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="st_sum"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>入库日期</label>
				    	<input type="text" class="form-control input-sm" data-number="n" name="store_date"  maxlength="24">
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>入库单号</label>
				    	<input id="rcv_auto_no" type="hidden" name="rcv_auto_no">
				    	<input type="text" class="form-control input-sm" data-number="n" name="rcv_hw_no"  maxlength="24">
				  	</div>
				</div>
			</div>
		</div>
	</form>
	</div>
	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info" id="selectClient">保存</button>
			<a href="purchasingCheck.do" class="btn btn-primary">返回</a>
		</div>
	</div> 
</body>
</html>