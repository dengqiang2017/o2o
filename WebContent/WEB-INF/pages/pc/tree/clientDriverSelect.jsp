<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display: block;">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title">司机选择</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline m-t-b">
					<div class="form-group">
						<label for="recipient-name" class="control-label">关键词</label> <input
							type="text" class="form-control" id="searchKey" placeholder="请输入关键词">
					</div>
					<button type="button" class="btn btn-primary" id="findtree">搜索</button>
					<button type="button" class="btn btn-primary" id="selectClient">确定</button>
					<button type="button" id="closeTree" class="btn btn-default">取消</button>
				</form>
				<div class="tabs-content" style="height: 400px;">
					<div class="table" style="height: 360px; overflow-y: scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>司机名称</th>
									<th>联系电话</th>
									<th>车牌号</th>
									<th>车型</th>
								</tr>
							</thead>
							<tbody> 
							</tbody>
						</table>
					</div> 
				</div>
			</div> 
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
	<script type="text/javascript">
var driver = {
	init : function(driveId,func) {
		function getTr(driver) {
			var tr = "<tr><td><input type='hidden' value='"
					+ ifnull(driver.customer_id)
					+ "'> "+ ifnull(driver.corp_sim_name) + "</td>"
			tr += "<td>" + ifnull(driver.user_id) + "</td>";
			tr += "<td>" + ifnull(driver.corp_working_lisence) + "</td>";
			tr += "<td>" + ifnull(driver.memo) + "</td></tr>";
			return tr;
		}
		$("#findtree").click(function(){
			pop_up_box.loadWait();
			$.get("../manager/getClientDriver.do",{
				"searchKey":$(".modal").find("#searchKey").val(),
				"driveId":driveId
			},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			if(data&&data.legth>0){
				for (var i = 0; i < data.length; i++) {
					$("tbody").append(getTr(data[i]));
				}
				select_Tree();
			}
			});
		});
		$(".modal").find("#closeTree,.close").click(function(){
			$(".modal,.modal-cover").remove();
		});
		o2otree.slectTreeVal("司机", function() {
// 			$("modal").find(".activeTable").val();
			if (func) {
				func();
			}
		});
	}
}
	</script>
</div>
<!-- /.modal -->