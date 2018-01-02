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
				<h4 class="modal-title">电工选择</h4>
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
				</form>
				<div class="tabs-content" style="height: 400px;">
					<div class="table" style="height: 360px; overflow-y: scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>电工名称</th>
									<th>联系电话</th>
									<th>微信通讯录账号</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${requestScope.electricans}" var="electrican">
									<tr>
										<td><input type="hidden" value="${electrican.customer_id}">${electrican.corp_sim_name}</td>
										<td>${electrican.user_id}</td>
										<td>${electrican.weixinID}</td>
									</tr>
								</c:forEach>
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
var electrican = {
	init : function(func) {
		function getTr(electrican) {
			var tr = "<tr><td><input type='hidden' value='"
					+ ifnull(electrican.customer_id)
					+ "'> "+ ifnull(electrican.corp_sim_name) + "</td>"
			tr += "<td>" + ifnull(electrican.user_id) + "</td>";
			tr += "<td>" + ifnull(electrican.weixinID) + "</td>";
			return tr;
		}
		var setto2o = o2otree;
		setto2o.init();
		setto2o.treeAll("electrican", function(n) {
			return getTr(n);
		});
		setto2o.next_tree("electrican", function(n) {
			return treeli(n.clerk_name, n.clerk_id);
		}, function(n) {
			return getTr(n);
		});
		setto2o.treeSelectInit();
		setto2o.slectTreeVal("电工", function() {
			if (func) {
				func();
			}
		});
	}
}
</script>
</div>
<!-- /.modal -->