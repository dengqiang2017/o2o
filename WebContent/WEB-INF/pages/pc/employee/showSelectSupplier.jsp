<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<button type="button" id="c-msg" class="btn btn-primary btn-sm m-t-b">供应商信息</button>
<button type="button" id="seekh" class="btn btn-primary btn-sm m-t-b">选择供应商</button>
<!-- <a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入 -->
<!-- <input type="file" id="xlsquotationSheet" name="xlsquotationSheet" onchange="excelImport(this,'quotationSheet');"></a> -->
<!-- <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('quotationSheet');">导出</button> -->
<div class="sim-table" style="display: none;">
	<ul class="sim-title">
		<li class="col-xs-6">供应商</li>
		<li class="last col-xs-6">手机号</li>
	</ul>
	<ul class="sim-msg">
		<li class="col-xs-6"></li>
		<li class="last col-xs-6"></li>
	</ul>
	<input type="hidden" id="corp_id">
</div>

<script type="text/javascript">
		var cMsg=$(".sim-table");
	$("#c-msg").click(function(){
		if(cMsg.is(":hidden")){
			cMsg.show();
		}else{
			cMsg.hide();
		}
	});
</script>
