<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="index01_top navbar-fixed-top">
<!-- 		<div class="pull-left"> -->
<!-- 			<a><img -->
<!-- 				class="img-responsive" src="../pc/images/logo.png" style="height: 95px;"></a> -->
<!-- 		</div> -->
	<div>
		<ol class="breadcrumb pull-left" style="width: 270px;">
		  <li><a href="/employee.do">${sessionScope.indexName}</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span></li>
		  <li class="active">${requestScope.pageName}</li>
		</ol>
	</div>
		<form style="border-bottom: 1px solid aqua;">
		<div class="col-xs-12 col-sm-6 col-md-3">
		<div class="col-xs-6 col-sm-6 col-md-6">
			<input type="date" id="d4311" class="form-control Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})"
				name="beginDate">
		</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
					<input type="date" id="d4312"
					class="form-control Wdate"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})"
					name="endDate">
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-1">
			<div class="form-group">
				<select id="zhid" class="form-control">
					<option value="">全部</option>
					<option value="1">置顶</option>
					<option value="0">不置顶</option>
				</select>
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-1">
		<div class="form-group">
				<select id="show" class="form-control">
					<option value="">全部</option>
					<option value="1">对外显示</option>
					<option value="0">不对外显示</option>
				</select>
			</div>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-3">
			<input type="text" class="form-control" id="searchKey" style="width:200px;display: inline-block;"
				maxlength="20" placeholder="请输入标题或关键词部分内容">
			<button type="button" class="btn btn-info find">搜索</button>
		</div>
		<div class="clearfix"></div>
		</form>
</div>

