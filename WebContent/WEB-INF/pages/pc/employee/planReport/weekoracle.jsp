<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<form action="" style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">品名</label> <input type="text"
				class="form-control input-sm" id="item_name" maxlength="20">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">计划周次日期</label> <input type="date"
				class="form-control input-sm Wdate"
				title="选择一个日期,将自动计算所在周一和周日的日期时间,默认为当前周"
				onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-{%d},isShowWeek:true',isShowClear:false,onpicked:zhuci})">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" style="" class="btn btn-sm btn-primary find">搜索</button>
		<button type="button" style="" class="btn btn-sm btn-danger excel"
			id="hide">导出</button>
	</div>
</form>
<div class="text-center">
	<span id="zhuci" style="float: left;">计划周次为:${requestScope.weeksnum}周</span>
	<h3>销售计划报表</h3>
</div>
<div class="table-responsive" id="print04">
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>发生部门</th>
				<th>产品名称</th>
				<th>计划数量</th>
				<th>订单数量</th>
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