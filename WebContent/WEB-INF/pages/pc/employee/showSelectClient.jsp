<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<button type="button" id="c-msg" class="btn btn-primary btn-sm m-t-b">客户信息</button>
<button type="button" id="seekh" class="btn btn-primary btn-sm m-t-b">选择客户</button>
<div class="sim-table" style="display: none;">
	<ul class="sim-title">
		<li class="col-xs-6">客户名称</li>
		<li class="last col-xs-6">手机号</li>
	</ul>
	<ul class="sim-msg">
		<li class="col-xs-6"></li>
		<li class="last col-xs-6"></li>
	</ul>
	<span id="ditch_type" style="display: none;"></span>
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
