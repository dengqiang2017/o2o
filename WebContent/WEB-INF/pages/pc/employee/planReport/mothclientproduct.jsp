<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<form style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">客户名称</label> <input type="text"
				class="form-control input-sm" name="customer_name" maxlength="20">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">日期<span style="font-weight: normal;">(月份中任意一天)</span></label>
			<input type="date" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:yuefen})">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" class="btn btn-sm btn-primary find"
			style="margin-top: 25px;">搜索</button>
		<!-- 									<button type="button" class="btn btn-sm btn-danger excel" style="margin-top:25px;">导出</button> -->
	</div>
</form>
<div class="text-center">
	<div class="ctn"></div>
	<h3>销售计划报表</h3>
</div>
<p>计划月份为:</p>
<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>客户名称</th>
				<th>产品简称</th>
				<th>计划月份</th>
				<th>本月累计计划</th>
				<th>本月累计拉货</th>
				<th>准时拉货率</th>
				<th>准时拉货率排名</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>