<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="../pc/saiyu/repair-lishi.css">
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/saiyu/repairHistory.js"></script>
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a></div>
<div class="row fl">
	<div class="col-lg-3 col-xs-6 m-t-b">
		<div class="form-group">
			<label for="">关键词</label> <input type="text"
				class="form-control input-sm" maxlength="20" placeholder="请输入搜索关键词"
				id="searchKey">
		</div>
	</div>
	<div class="col-lg-3 col-xs-6 m-t-b">
		<div class="form-group">
			<label>发起日期</label> <input type="date"
				class="form-control input-sm Wdate" name="store_date"
				id="store_date" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
		</div>
	</div>
	<div class="col-lg-3 col-xs-6 m-t-b">
		<div class="form-group">
			<button class="btn btn-primary find" type="button"
				style="margin-top: 20px">查询</button>
		</div>
	</div>
</div>
<div class="row"></div>
<div id="historyitem" style="display: none;">
	<div class="col-sm-6 col-lg-4">
		<div class="section-one">
			<ul>
				<li>报修时间：<span id=""></span></li>
				<li>损坏位置：<span id=""></span></li>
				<li>损坏楼层：<span id=""></span></li>
				<li>损坏类型：<span id=""></span></li>
				<li>损坏数量：<span id=""></span></li>
			</ul>
			<div class="dw" style="display: none;">
				<span class="glyphicon glyphicon-option-horizontal"
					style="font-size: 25px"></span>
			</div>
		</div>
	</div>
</div>