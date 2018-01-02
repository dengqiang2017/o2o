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
				<h4 class="modal-title">员工选择</h4>
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
				<input type="hidden" id="select_customer_id">
				<div class="tabs-content" style="height: 400px;">
					<div class="table" style="height: 360px; overflow-y: scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>
								<th><div class="checkbox"></div></th> 
									<th>员工名称</th>
									<th>联系电话</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${requestScope.employees}" var="employee">
									<tr>
										<td><div class="checkbox"></div></td>
										<td><input type="hidden" value="${employee.clerk_id}">${employee.clerk_name}</td>
										<td>${employee.movtel}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div> 
				</div>

			</div> 
		</div> 
	</div>
	<!-- /.modal-dialog -->
	<script type="text/javascript">
		var employee = {
			init : function(func) {
				function getTr(employee) {
					var tr = "<tr><td><div class='checkbox'></div></td><td><input type='hidden' value='"
							+ ifnull(employee.clerk_id)+ "'>"
							+ ifnull(employee.clerk_name) + "</td>";
					tr += "<td>" + ifnull(employee.movtel) + "</td>";
					return tr;
				}
				$("thead").find(".checkbox:eq(0)").click(function(){
					var ch=$(this).hasClass("checkedbox");
					if(ch){
						$("thead").find(".checkbox:eq(0)").removeClass("checkedbox");
						$("tbody").find(".checkbox").removeClass("checkedbox");
					}else{
						$("thead").find(".checkbox:eq(0)").addClass("checkedbox");
						$("tbody").find(".checkbox").addClass("checkedbox");
					}
				});
				checkboxselect();
				function checkboxselect(){
				$("tbody").find(".checkbox").click(function(){
					var ch=$(this).hasClass("checkedbox");
					if(ch){
						$(this).removeClass("checkedbox");
					}else{
						$(this).addClass("checkedbox");
					}
				});
				}
				var setto2o;
				if (o2otree) {
					setto2o = o2otree;
					setto2o.init();
				} else {
					o2o.init();
					setto2o = o2o;
				}
				setto2o.init();
				setto2o.treeAll("employee", function(n) {
					return getTr(n);
				});
				setto2o.next_tree("employee", function(n) {
				//	return treeli(n.clerk_name, n.clerk_id);
				}, function(n) {
					return getTr(n);
				},null,function(){
					checkboxselect();
				});
				setto2o.treeSelectInit();
				setto2o.slectTreeVal("员工", function() {
					if (func) {
						func();
					}
				});
			}
		}
	</script>
</div>
<!-- /.modal -->