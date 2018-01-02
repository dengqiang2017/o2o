<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="folding-btn m-t-b">
	<button type="button" class="btn btn-primary btn-folding btn-sm">展开搜索</button>
<!-- 	<button type="button" class="btn btn-danger btn-sm print"><span class="glyphicon glyphicon-share-alt"></span> 打印</button> -->
	<button type="button" class="btn btn-danger btn-sm excel"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
</div>
<form style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">关键词</label> <input type="text"
				class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">起始日期</label> <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">结束日期</label> <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<button type="button" class="btn btn-primary btn-sm find"
			style="margin-top: 25px;">搜索</button>
<!-- 			<button type="button" class="btn btn-danger btn-sm print" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>打印</button> -->
			<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>导出</button>
	</div>
	<script type="text/javascript">
	$(".btn-folding").click(function(){
		var form=$("form");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".btn-folding").is(":hidden")){
		$("form").show();
	}else{
		$("form").hide();
	}
	</script>
</form>
