<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="css/query.css">
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<div id=findlistpage style="display: none;">
	<div class="header2">
		查询 <a class="pull-left closed"
			style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer"
			>取消</a> <a class="pull-right find"
			style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer">确认</a>
	</div>
	<div class="body">
		<ul>
			<li>
				<div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">关键词</div>
				<div class="col-xs-8">
					<input type="text" id="searchKey" maxlength="20" class="form-control" placeholder="输入查询关键词">
				</div>
				<div class="clearfix"></div>
			</li>
			<li>
				<div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">起始日期</div>
				<div class="col-xs-8">
						<input type="date" id="d4311"
    class="form-control Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}'})" name="beginDate">
				</div>
				<div class="clearfix"></div>
			</li>
			<li>
				<div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">结束日期</div>
				<div class="col-xs-8">						
						<input type="date" id="d4312" class="form-control Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01'})" name="endDate">
				</div>
				<div class="clearfix"></div>
			</li>
		</ul>
	</div>
</div>