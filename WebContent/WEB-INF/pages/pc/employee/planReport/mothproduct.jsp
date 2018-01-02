<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<form style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">品名</label> <input type="text"
				class="form-control input-sm" name="item_name" maxlength="20">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">日期<span style="font-weight: normal;">(月份中任意一天)</span></label>
			<input type="date" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',onpicked:yuefen})"
				maxlength="20">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" class="btn btn-sm btn-primary find"
			style="margin-top: 25px;">搜索</button>
		<button type="button" class="btn btn-sm btn-danger excel"
			style="margin-top: 25px;">导出</button>
	</div>
</form>
<div class="text-center">
	<h3>销售计划报表</h3>
</div>
<p>计划月份为:</p>
<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>产品类别</th>
				<th>产品名称</th>
				<th>计划数量</th>
				<th>订单数量</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>