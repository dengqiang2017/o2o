<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/planReport.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>计划统计报表</li>
	</ol>
	<div class="header-title">员工-计划统计报表
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-head">
			 <%@include file="find.jsp" %>
					<ul class="nav nav-tabs" style="margin-top:10px;">
					    <li class="active"><a>按产品汇总统计</a></li>
					    <li><a>明细统计</a></li>
					    <li><a>明细记录</a></li>
					    <li><a>店面金额统计</a></li>
						 <li><a>供应商金额统计</a></li>
					</ul>
		 	 	</div>
		 	 	<span style="display: none;" id="purchase_price">${sessionScope.auth.purchase_price}</span>
		 	 	<span style="display: none;" id="purchase_num">${sessionScope.auth.purchase_num}</span>
		 	 	<span style="display: none;" id="purchase_gen">${sessionScope.auth.purchase_gen}</span>
				<div class="box-body">
					<!-- 按产品汇总统计 -->
					<div class="tabs-content">
						<div class="ctn">
<!-- 						<button type="button" class="btn btn-danger btn-sm">通知供应商</button> -->
							<div class="text-center">
								<h3>按产品汇总统计</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th data-name="item_name">产品名称</th>
									       <th data-name="planNum">计划数量</th>
									       <th data-name="kucun">库存</th>
									       <th data-name="item_unit">基本单位</th>
									       <th data-name="item_cost">采购价(元)</th>
									       <th data-name="item_zeroSell">零售价(元)</th>
									       <th data-name="je">金额(元)</th>
									       <th data-name="planTime">计划日期</th>
									       <th data-name="corp_name">供应商</th>
									       <th>查看</th>
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>

					<!-- 客户统计 -->
					<div class="tabs-content">
						<div class="ctn">
							<div class="text-center">
								<h3>明细统计</h3>
							</div>
								<div>
									<label><input type="radio" name="type" value="0">全部记录</label>
									<label><input type="radio" name="type" value="1" checked="checked">正常记录</label>
									<label><input type="radio" name="type" value="2">追加记录</label>
									<label><input type="radio" name="desc" value="0" checked="checked">按店面排序</label>
									<label><input type="radio" name="desc" value="1">按产品排序</label>
								</div>
								<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th data-name="c_corp_sim_name">门店简称</th>  
									       <th data-name="item_name">产品名称</th>
									       <th data-name="planNum">计划数量</th>
									       <th data-name="kucun">库存</th>
									       <th data-name="item_unit">单位</th>
									       <th data-name="item_cost">采购价(元)</th>
									       <th data-name="je">金额(元)</th>
									       <th data-name="at_term_datetime">计划日期</th>
									       <th data-name="corp_name">供应商</th>
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
<!-- 					////////////////// -->
					<div class="tabs-content">
						<div class="ctn"> 
							<div class="text-center">
								<h3>明细记录</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th data-name="c_corp_sim_name">门店简称</th>  
									       <th data-name="item_name">产品名称</th>
									       <th data-name="planNum">计划数量</th>
									       <th data-name="kucun">库存</th>
									       <th data-name="item_unit">单位</th>
									       <th data-name="item_cost">采购价(元)</th>
									       <th data-name="je">金额(元)</th>
									       <th data-name="at_term_datetime">计划日期</th>
									       <th data-name="corp_name">供应商</th>
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
<!-- 					//////////////////////////////// -->
					<div class="tabs-content">
						<div class="ctn"> 
							<div class="text-center">
								<h3>店面金额统计</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th data-name="corp_sim_name">门店简称</th>  
									       <th data-name="zje">金额(元)</th>
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>

<div class="tabs-content">
						<div class="ctn"> 
							<div class="text-center">
								<h3>供应商金额统计</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th width="100px" data-name="corp_sim_name">供应商简称</th>  
									       <th width="100px" data-name="zje">金额(元)</th>
									       <th width="50px">查看</th>
									       <th width="50px">操作</th>
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
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
<div id="modal_smsSelect" style="display: none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">更改</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label>采购价</label>
					<label class="radio-inline">
					  <input type="number" data-num="num2" maxlength="7">
					</label>
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;display: none;">
					<label>零售价</label>
					<label class="radio-inline">
					  <input type="number" data-num="num2" maxlength="7">
					</label>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div>
	</div>
</div>
</div>


</body>
</html>

 