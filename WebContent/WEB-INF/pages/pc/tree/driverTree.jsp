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
									<th>司机名称</th>
									<th>联系电话</th>
<!-- 									<th>微信通讯录账号</th> -->
									<th>车牌号</th>
									<th>身份证</th>
									<th>车型</th>
								</tr>
							</thead>
							<tbody>
<%-- 								<c:forEach items="${requestScope.drivers}" var="driver"> --%>
<!-- 									<tr> -->
<%-- 										<td><input type="hidden" value="${driver.customer_id}">${driver.corp_sim_name}</td> --%>
<%-- 										<td>${driver.user_id}</td> --%>
<%-- 										<td>${driver.weixinID}</td> --%>
<!-- 									</tr> -->
<%-- 								</c:forEach> --%>
							</tbody>
						</table>
					</div>
				</div>
			</div> 
		</div>
	</div>
</div>
<script type="text/javascript">
var driver = {
	init : function(check,func) {
		function getTr(driver) {
			var chk="";
			if(check){
				chk='<input style="width: auto;height: auto;float:left;margin-top:8px;" type="checkbox">';
			}
			var tr = "<tr><td><input type='hidden' value='"
					+ ifnull(driver.customer_id)
					+ "'> "+chk+ifnull(driver.corp_sim_name)+"</td>"
			tr += "<td>" + ifnull(driver.user_id) + "</td>";
// 			tr += "<td>" + ifnull(driver.weixinID) + "</td>";
			tr += "<td>" + ifnull(driver.corp_working_lisence) + "</td>";
			tr += "<td>" + ifnull(driver.idcard) + "</td>";
			tr += "<td>" + ifnull(driver.memo) + "</td></tr>";
			return tr;
		}
		o2otree.init();
// 		o2otree.treeAll("driver", function(n) {
// 			return getTr(n);
// 		});
		o2otree.next_tree("driver", function(n) {
			return treeli(n.corp_sim_name, n.clerk_id);
		}, function(n) {
			return getTr(n);
		});
		$("#findtree").click();
		o2otree.treeSelectInit();
		o2otree.slectTreeVal("司机", function() {
			if (func) {
				func();
			}
		});
	}
}
	</script>
<!-- /.modal -->