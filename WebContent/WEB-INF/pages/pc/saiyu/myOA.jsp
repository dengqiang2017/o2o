<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript" src="../pc/js/saiyu/myOA.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<div id="listoa">
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a></div>
<div class="ctn-fff box-ctn">
			<div class="box-head">
				<ul class="nav nav-tabs">
					<li class="active" style="padding: 10px 15px"><a>待办 <span class="badge">0</span></a></li>
<li style="padding: 10px 0"><a>已办</a></li>
</ul>
<div class="ctn">
	<div class="col-sm-3 col-xs-6 m-t-b">
		<div class="form-group">
			<label for="">发起人</label> <input type="text" class="form-control input-sm" id="OA_who">
		</div>
	</div>
	<div class="col-sm-3 col-xs-6 m-t-b">
		<div class="form-group">
			<label for="">发起日期</label> <input type="date" class="form-control input-sm Wdate" name="store_date" id="store_date" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
	</div>
</div>
<div class="ctn">
	<button class="btn btn-primary find" type="button">查询</button>
<!-- 						<a class="btn btn-primary" href="coordination.do">协同申请</a> -->
		</div>
	</div>
</div>
<div class="box-body" style="line-height: 34px">
<div class="tabs-content" style="display: block;"></div>
<div style="display: none;">
	<div class="alert alert-danger">
		<div class="row">
		<div class="col-sm-2 m-t-b" id="OA_who_item"></div>
		<div class="col-sm-4 m-t-b" id="OA_what"></div>
		<div class="col-sm-2 m-t-b" id="store_date_item"></div>
		<div class="col-sm-2 m-t-b">
			<a class="btn btn-danger btn-sm">审批</a>
		</div>
		</div>
	</div>
</div>
<div class="tabs-content" style="display: none;"></div>
<div style="display: none;">
				<div class="alert alert-info">
			<div class="row">
					<div class="col-sm-2 m-t-b" id="OA_who_item"></div>
					<div class="col-sm-2 m-t-b" id="OA_what"></div>
					<div class="col-sm-2 m-t-b" id="store_date_item"></div>
					<div class="col-sm-2 m-t-b" id="approval_YesOrNo_item"></div>
					<div class="col-sm-2 m-t-b">
						<a class="btn btn-primary btn-sm">查看详细</a>
					</div>
				</div>
			</div>
			</div>
		</div>
	</div>
	</div>
<div id="itempage">

</div>