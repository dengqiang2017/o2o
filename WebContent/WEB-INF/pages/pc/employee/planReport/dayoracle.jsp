<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<form action="" style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">品名</label> <input type="text"
				class="form-control input-sm" id="item_name" maxlength="50">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">状态</label> <select id="type"
				class="form-control input-sm">
				<option value="日计划">日计划</option>
				<option value="周计划">周计划</option>
				<option value="月计划">月计划</option>
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">计划日期</label> <input type="date"
				class="form-control input-sm Wdate"
				onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-{%d+1}',isShowClear:false,onpicked:zhuciday})">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" class="btn btn-sm btn-primary find">搜索</button>
		<button type="button" class="btn btn-sm btn-danger excel">导出</button>
	</div>
</form>
<div class="text-center">
	<span id="zhuci" style="float: left; display: none;">计划周次为:${requestScope.weeksnum}周</span>
	<h3>销售计划报表</h3>
</div>
<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>录入标识</th>
				<th>部门名称</th>
				<th style="display: none;">部门编码</th>
				<th>员工名称</th>
				<th style="display: none;">员工编码</th>
				<th>客户名称</th>
				<th style="display: none;">客户编码</th>
				<th>产品名称</th>
				<th style="display: none;">产品编码</th>
				<th>计划数量</th>
				<th>计划日期</th>
				<th>计划提货日期</th>
			</tr>
		</thead>
		<tbody>

		</tbody>
	</table>
</div>
<div class="pull-right" style="display: none;"> 
	<button type="button" class="btn btn-info btn-sm">首页</button>
	<button type="button" class="btn btn-info btn-sm">上一页</button>
	<button type="button" class="btn btn-info btn-sm">下一页</button>
	<button type="button" class="btn btn-info btn-sm">末页</button>
</div>