<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="vendorTreePage">
<div class="modal-cover"></div>
<div class="modal" style="display: block;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title">成员选择</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline m-t-b">
					<div class="form-group">
						<label for="recipient-name" class="control-label">名称</label> <input
							type="text" class="form-control" id="recipient-name">
					</div>
					<button type="button" class="btn btn-primary" id="findtree">搜索</button>
					<button type="button" class="btn btn-primary" id="selectClient">确定</button>
					<button type="button" id="closeTree" class="btn btn-default">取消</button>
					<button type="button" id="backshow" class="btn btn-default" style="display: none;">显示已选择</button>
				</form>
				<input type="hidden" id="select_customer_id">

				<div class="tabs-content" style="height: 400px;">
					<div class="table" style="height: 360px; overflow-y: scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>名称</th>
									<th>联系电话</th>
									<th>微信通讯录账号</th>
									<th>内码</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
<script type="text/javascript">
<!--
var chengyuan = {
	init : function(id,name,func) {
$("#findtree").unbind("click");
$("#findtree").click(function(){
	var div=$(".modal");
	var searchKey=$("#recipient-name").val();
	pop_up_box.loadWait(); 
	$.get("../manager/getGysPage.do",{
		"searchKey":searchKey
	},function(data){
		pop_up_box.loadWaitClose();
		$(".modal tbody").html("");
		$.each(data.rows,function(i,n){
			var tr=getTr(4);
			$(".modal tbody").find("tbody").append(tr);
			tr.find("td:eq(0)").html(n[name]);
			tr.find("td:eq(1)").html(n.movtel);
			tr.find("td:eq(2)").html(n.weixinID);
			tr.find("td:eq(2)").html(n[id]);
		});
	});
}); 
	o2otree.init(); 
	o2otree.treeSelectInit();
	o2otree.slectTreeVal("成员", function() {
		if (func) {
			func();
		}
	});
	},backshow:function(backshow){
		$(".modal-body #backshow").unbind("click");
		$(".modal-body #backshow").click(function(){
			backshow();
		});
		$(".modal-body #backshow").show();
	}
}
//-->
</script>
</div>
</div>
<!-- /.modal -->