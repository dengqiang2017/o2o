<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/suggest.css">
<script src="../js/o2od.js"></script>
<script src="../js/o2otree.js"></script>
<script src="../pc/../pc/js/saiyu/suggest.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
		<li><span class="glyphicon glyphicon-triangle-right"></span><a
			href="../employee.do">员工首页</a></li>
		<li><span class="glyphicon glyphicon-triangle-right"></span><a
			href="../employee/myOA.do">我的协同</a></li>
		<li class="active"><span
			class="glyphicon glyphicon-triangle-right"></span>协同-为客户推荐产品</li>
	</ol>
	<div class="header-title">
		员工-为客户推荐产品 <a href="myOA.do" class="header-back"><span
			class="glyphicon glyphicon-menu-left"></span></a>
	</div>
	<div class="header-logo"></div>
	<input type="hidden" id="upper_customer_id">
	<input type="hidden" id="ivt_oper_listing">
</div>
<div class="container">
	<div class="box-head panel panel-danger">
		<div class="panel-body">
			<ul>
				<li><span class="fll">报修客户:</span><span id="OA_who"></span></li>
				<li><span class="fll">报修信息:</span><span id="num"></span></li>
				<li><span class="fll">报修单号:</span><span id="no"></span></li>
				<li><span class="fll">报修时间:</span><span id="store_date"></span></li>

				<li><span class="fll">产品列表:</span> <button type="button" class="btn btn-sm btn-primary" id="tuiPro">推荐产品</button></li>
			</ul>
			<div class="row">
			</div>
			<div id="item" style="display: none;">
			<div class="col-lg-4 col-sm-4 m-t-b">
					<div class="form-group fl">
						<ul>
							<li><span class="fll">类型:</span><span id="sort_name"></span><input type="hidden"
								id="item_id"></li>
							<li><span class="fll">品牌:</span><span id="class_card"></span></li>
							<li><span class="fll">名称:</span><span id="item_sim_name"></span></li>
							<li><span class="fll">规格:</span><span id="item_spec"></span></li>
							<li><span class="fll">型号:</span><span id="item_type"></span></li>
							<li><span class="fll">颜色:</span><span id="item_color"></span></li>
							<li><span class="fll">产品单价:</span><input type="text" id="sd_unit_price" data-num="n"></li>
							<li style="height: 30px;"><span class="spanleft fll">数量:</span><div class="secition-three-3"><span class="sub bt3">-</span> <input type="text"
								class="num" id="pronum" value="1" data-num="n"> <span
								class="add bt2">+</span></div></li>
						</ul>
						<div class="gb"><span class="glyphicon glyphicon-remove"></span></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
	<div class="btn-gp">
		<button class="btn btn-info" id="save">保存</button>
		<a href="myOA.do" class="btn btn-primary">返回</a>
	</div>
	<span class="glyphicon glyphicon-earphone"></span>
</div>
<div id="modalProd">
</div>
	
</body>
</html> 