<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<link rel="stylesheet" href="../pcxy/css/function.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/write-table.css${requestScope.ver}">
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/finance_employee.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/initialMaintenance.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/addInventory.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/addReceivable.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/addHandle.js${requestScope.ver}"></script>
<style type="text/css">
	.active_table li{
		background-color: #add;
	}
	.table-body li{
	cursor: pointer;
	}
	@media ( max-width : 770px) {
	.center{
	width:95%;
	margin:auto;
	margin-top:60px;
	}
	.box-ctn{
	height: auto;
	padding-bottom: 50px;
	}
	}
	@media ( min-width : 770px) {
	.center{
	width:65%;
	margin:auto;
	margin-top:60px;
	}
	.box-ctn{
	min-height: 750px;
	}
	}
</style>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span> <a
				href="../employee.do">员工首页</a></li>
			<li><span class="glyphicon glyphicon-triangle-right"></span>期初维护</li>
		</ol>
		<div class="header-title">
			员工-期初维护 <a href="../employee.do" class="header-back"> <span class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
	</div>
	<div class="center">
		<div class="ctn-fff box-ctn" style="top:0">
	<div style="padding:10px 0">
	<div class="col-sm-4 col-lg-3 m-t-b" style="padding-left:0">
	<div class="form-group">
	<div class="input-group">
	<input type="text" class="form-control input-sm" maxlength="20"
	placeholder="请输入搜索关键词" id="searchKey"> <span
	class="input-group-btn">
	<button class="btn btn-success btn-sm find" type="button">搜索</button>
	</span>
	</div>
	</div>
	</div>
	<div style="clear:both"></div>
	</div>
			<ul class="nav nav-tabs">
				<li class="active"><a>期初应收</a></li>
				<li><a>期初应付</a></li>
				<li><a>期初库存</a></li>
			</ul>
			<div class="box-body">
				<!-- 应收账款初始化 -->
				<div class="tabs-content">
					<div class="ctn">
						<c:if test="${sessionScope.auth.excelImp!=null}">
							<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入 
							<input type="file" name="xlsarf" id="xlsarf" onchange="excelimport(this,'arf');"
							 accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"></a>
						</c:if>
						<c:if test="${sessionScope.auth.excel!=null}">
							<button type="button" class="btn btn-danger btn-sm m-t-b excel">导出</button>
						</c:if>
						<c:if test="${sessionScope.auth.add_maintenance!=null}">
						<button type="button" class="btn btn-primary m-t-b" id="initReceivable">新增</button>
						</c:if>
						<c:if test="${sessionScope.auth.edit_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b modify" id="editReceivable">修改</button>
						</c:if>
						<c:if test="${sessionScope.auth.del_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b delete" id="delReceivable">删除</button>
						</c:if>
						<c:if test="${sessionScope.auth.initysk_shenhe!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="initysk_shenhe">审核</button>
						</c:if>
						<c:if test="${sessionScope.auth.initysk_qishen!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="initysk_qishen">弃审</button>
						</c:if>
						<button type="button" class="btn btn-primary m-t-b" style="display: none;">保存</button>
					</div>
					<div class="write-table">
						<ul class="table-head">
							<li style="width: 20%;">客户名称</li>
							<li style="width: 10%;">期初金额</li>
							<li style="width: 20%;">结算方式</li>
							<li style="width: 20%;">备注</li>
							<li style="width: 20%;">经办部门</li>
							<li class="last" style="width: 10%;">经办人</li>
						</ul>
<!-- 						<ul class="table-body" style="display: none;"> -->
<!-- 							<li style="width: 20%;"><button type="button">浏览</button></li> -->
<!-- 							<li style="width: 10%;"><input type="text"></li> -->
<!-- 							<li style="width: 20%;"><button type="button">浏览</button></li> -->
<!-- 							<li style="width: 20%;"><input type="text"></li> -->
<!-- 							<li style="width: 20%;"><button type="button">浏览</button></li> -->
<!-- 							<li class="last" style="width: 10%;"><button type="button">浏览</button></li> -->
<!-- 						</ul> -->
<!-- 						<div id="tableBody" style="display: none;"> -->
<!-- 						<ul class="table-body"> -->
<!-- 							<li style="width: 20%;">张三</li> -->
<!-- 							<li style="width: 10%;">1255000.00</li> -->
<!-- 							<li style="width: 20%;">结算方式2</li> -->
<!-- 							<li style="width: 20%;"></li> -->
<!-- 							<li style="width: 20%;">水产部</li> -->
<!-- 							<li class="last" style="width: 10%;">周五</li> -->
<!-- 						</ul> -->
						<div id="tableReceivable">
						
						</div>
						</div>
					</div>
				</div>

				<!-- 应付账款初始化 -->
				<div class="tabs-content">
					<div class="ctn">
						<c:if test="${sessionScope.auth.excelImp!=null}">
							<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
							 <input type="file" id="xlspayable" name="xlspayable" onchange="excelImport(this,'payable');" 
							 accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"></a>
						</c:if>
						<c:if test="${sessionScope.auth.excel!=null}">
							<button type="button" class="btn btn-danger btn-sm m-t-b excel">导出</button>
						</c:if>
						<c:if test="${sessionScope.auth.add_maintenance!=null}">
						<button type="button" class="btn btn-primary m-t-b" id="initHandle">新增</button>
						</c:if>
						<c:if test="${sessionScope.auth.edit_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b modify" id="editHandle">修改</button>
						</c:if>
						<c:if test="${sessionScope.auth.del_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b delete" id="delHandle">删除</button>
						</c:if>
						<c:if test="${sessionScope.auth.inityfk_shenhe!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="inityfk_shenhe">审核</button>
						</c:if>
						<c:if test="${sessionScope.auth.inityfk_qishen!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="inityfk_qishen">弃审</button>
						</c:if>
						<button type="button" class="btn btn-primary m-t-b" style="display: none;">保存</button>
					</div>
					<div class="write-table">
						<ul class="table-head">
							<li style="width: 25%;">供应商</li>
							<li style="width: 25%;">应付金额</li>
							<li style="width: 25%;">经办部门</li>
							<li class="last" style="width: 25%;">经办人</li>
						</ul>
<!-- 						<ul class="table-body" style="display: none;"> -->
<!-- 							<li style="width: 25%;"><button type="button">浏览</button></li> -->
<!-- 							<li style="width: 25%;"><input type="text"></li> -->
<!-- 							<li style="width: 25%;"><button type="button">浏览</button></li> -->
<!-- 							<li class="last" style="width: 25%;"><button type="button">浏览</button></li> -->
<!-- 						</ul> -->
<!-- 						<ul class="table-body" style="display: none;"> -->
<!-- 							<li style="width: 25%;"></li> -->
<!-- 							<li style="width: 25%;"></li> -->
<!-- 							<li style="width: 25%;"></li> -->
<!-- 							<li class="last" style="width: 25%;"></li> -->
<!-- 						</ul>  -->
						<div id="tableHandle">
						
						</div>
					</div>
				</div>

				<!-- 库存初始化-->
				<div class="tabs-content">
					<div class="ctn">
						<c:if test="${sessionScope.auth.excelImp!=null}">
							<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入 
							<input type="file" id="xlswareinit" name="xlswareinit" onchange="excelImport(this,'wareinit');" 
							accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"></a>
						</c:if>
						<c:if test="${sessionScope.auth.excel!=null}">
							<button type="button" class="btn btn-danger btn-sm m-t-b excel">导出</button>
						</c:if>
						<c:if test="${sessionScope.auth.add_maintenance!=null}">
						<button type="button" class="btn btn-primary m-t-b" id="initWareAdd">新增</button>
						</c:if>
						<c:if test="${sessionScope.auth.edit_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b modify" id="editInitialInventory">修改</button>
						</c:if>
						<c:if test="${sessionScope.auth.del_maintenance!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b delete" id="delInitialInventory">删除</button>
						</c:if>
						<c:if test="${sessionScope.auth.initkucun_shenhe!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="initkucun_shenhe">审核</button>
						</c:if>
						<c:if test="${sessionScope.auth.initkucun_qishen!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b" id="initkucun_qishen">弃审</button>
						</c:if>
<!-- 						<button type="button" class="btn btn-primary m-t-b">保存</button> -->
					</div>
					<div class="write-table">
						<ul class="table-head">
							<li style="width: 7%;">仓位编码</li>
							<li style="width: 7%;">仓位名称</li>
							<li style="width: 7%;">产品编码</li>
							<li style="width: 7%;">产品名称</li>
							<li style="width: 8%;">规格</li>
							<li style="width: 8%;">型号</li>
							<li style="width: 8%;">包装单位</li>
							<li style="width: 8%;">基本单位</li>
							<li style="width: 8%;">成本单价</li>
							<li style="width: 8%;">期初库存</li>
							<li style="width: 8%;">金额</li>
							<li style="width: 8%;">经办部门</li>
							<li class='last' style="width: 8%;">经办人</li>
						</ul>
						<ul class="table-body" style="display: none;">
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 7%;"></li>
							<li style="width: 8%;"></li>
							<li class='last' style="width: 8%;"></li>
						</ul>
						<div id="tableBody">
						
						</div>
					</div>
				</div>
			</div>
		</div>
	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}</div>
<div id="addWareInit" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">期初库存</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setForm">
			<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerk_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerkId" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptId" type="hidden" name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm select" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>产品名称</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="item_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="itemId" type="hidden" name="item_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm item" type="button">浏览</button>
				    </span>
			</div>
			</div>
<!-- 			<div class="form-group" id="gys"> -->
<!-- 		    	<label>供应商</label> -->
<!-- 		    	<div class="input-group"> -->
<!-- 		    	<span class="form-control input-sm" id="corp_name" aria-describedby="basic-addon2"></span> -->
<!-- 					<span class="input-group-btn"> -->
<!-- 		    			<input id="corp_id" type="hidden" name="corp_id"> -->
<!-- 				        <button class="btn btn-default btn-sm" type="button">X</button> -->
<!-- 				        <button class="btn btn-success btn-sm gys" type="button">浏览</button> -->
<!-- 				    </span> -->
<!-- 				</div> -->
<!-- 			</div> -->
			<div class="form-group">
		    	<label>所在仓库</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="store_struct_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="storestructId" type="hidden" name="store_struct_id">
		    			<input id="ivtnumdetail" type="hidden" name="ivt_num_detail">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm store" type="button">浏览</button>
				    </span>
			</div>
			</div>
		  	<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>成本单价</label>
				<input id="i_price"  type="text" name="i_price" class="form-control input-sm">
			</div>
			</div>
			<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>期初库存</label>
				<input id="oh" type="text" name="oh" class="form-control input-sm">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="selectClient" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
<div id="addReceivableInit" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">期初应收</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setReceivable">
			<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerkName" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerkid" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm belongClerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept_sim_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptsimId" type="hidden"  name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm belongDept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>客户名称</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="customer_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="customerId" type="hidden"  name="customer_id">
		    			<input id="seedsId"    type="hidden"  name="seeds_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm customer" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="form-group">
		    	<label>结算方式</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="sd_order_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="sdorderId" type="hidden"  name="rcv_hw_no">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm sd_order" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>期初金额</label>
				<input id="oh_sum" type="text" name="oh_sum" class="form-control input-sm">
			</div>
			</div>
			<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>备注</label>
				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="saveReceivable" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
<div id="addHandleInit" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">期初应付</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setHandle">
			<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerkname" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerk_id" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm procurementClerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptid" type="hidden"  name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm procurementDept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>供应商</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="vendor_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="vendorId" type="hidden"  name="vendor_id">
		    			<input id="seedsid"    type="hidden"  name="seeds_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm corp" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>应付金额</label>
				<input id="beg_sum" type="text" name="beg_sum" class="form-control input-sm">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="saveHandle" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>

</body>
</html>