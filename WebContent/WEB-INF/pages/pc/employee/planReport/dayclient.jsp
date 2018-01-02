<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<form action="" style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">客户名称</label> <input type="text"
				class="form-control input-sm" id="customer_name" maxlength="50">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">状态</label> <select id="type"
				class="form-control input-sm">
				<option value="">全部</option>
				<option value="1">下计划并下订单</option>
				<option value="2">下计划未下订单</option>
				<option value="3">下订单未下计划</option>
				<option value="4">正常计划</option>
				<option value="5">插单计划</option>
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">品名</label> <input type="text"
				class="form-control input-sm" id="item_name" maxlength="50">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">计划日期</label> <input type="date"
				class="form-control input-sm Wdate"
				onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-{%d+1}',isShowClear:false,onpicked:clearDate})">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b" style="overflow: hidden">
		<label for="" style="width: 100px;">预计提货日期</label>
		<div>
			<input type="date" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,onpicked:clearDate})"
				style="float: left; margin-left: 2%; width: 40%;"> <span
				style="float: left; margin-left: 2%">~</span> <input type="date"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,onpicked:clearDate})"
				style="float: left; margin-left: 2%; width: 40%;">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" style="" class="btn btn-sm btn-primary find">搜索</button>
		<button type="button" style="" class="btn btn-sm btn-danger excel"
			id="hide">导出</button>
	</div>
</form> 
<div class="text-center">
	<h3>销售计划报表</h3>
</div>
<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>员工姓名</th>
				<th>部门</th>
				<th>客户名称</th>
				<th>产品名称</th>
				<th>计划数量</th>
				<th>计划日期</th>
				<th>计划提货日期</th>
				<th>实际提货日期</th>
				<th>订货数</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>

<div class="ctn" style="display: none;">
	<h5>该记录明细</h5>
	<div class="col-sm-6">
		<div class="tatable-responsive" style="margin-top: 10px;">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>客户</th>
						<th>产品品种</th>
						<th>提货数数</th>
						<th>日期</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
	<div class="col-sm-6">
		<div class="tatable-responsive" style="margin-top: 10px;">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>客户</th>
						<th>产品品种</th>
						<th>计划数</th>
						<th>日期</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="pull-right" style="display: none;">
	<button type="button" class="btn btn-info btn-sm">首页</button>
	<button type="button" class="btn btn-info btn-sm">上一页</button>
	<button type="button" class="btn btn-info btn-sm">下一页</button>
	<button type="button" class="btn btn-info btn-sm">末页</button>
</div>