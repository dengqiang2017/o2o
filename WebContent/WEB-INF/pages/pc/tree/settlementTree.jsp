<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">结算方式选择</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline m-t-b">
		          <div class="form-group">
		            <label for="recipient-name" class="control-label">名称</label>
		            <input type="text" class="form-control" id="recipient-name">
		          </div>
		          <button type="button" class="btn btn-primary" id="findtree">搜索</button>
				  <button type="button" class="btn btn-primary" id="selectClient">确定</button>
		          <button type="button" id="closeTree" class="btn btn-default">取消</button>
		        </form>
		        <ul class="nav nav-tabs" style="margin-top:10px;">
				    <li class="active"><a href="#">树形展示</a></li>
				    <li><a href="#">列表展示</a></li>
				</ul>
				<input type="hidden" id="select_sort_id">
				<div class="tabs-content" style="height:400px;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.settlements}" var="settlement">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${settlement.settlement_sim_name}
					<input type="hidden" value="${settlement.sort_id}"></span></li>
					</c:forEach>
					</ul>
					</li>
					</ul>
					</div>
				</div>

				<div class="tabs-content" style="height:400px;">
					<div class="table" style="height:360px; overflow-y:scroll;">
					<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>结算方式名称</th> 
							       <th>结算方式编码</th>  
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.settlements}" var="settlement">
								<tr>
									<td><input type="hidden" value="${settlement.sort_id}">${settlement.settlement_sim_name}</td>
									<td><a>${settlement.sort_id}</a></td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
<!-- 					<div class="btn-group"> -->
<!-- 						<button type="button" class="btn btn-default btn-sm">首页</button> -->
<!-- 						<button type="button" class="btn btn-default btn-sm">上一页</button> -->
<!-- 						<button type="button" class="btn btn-default btn-sm">下一页</button> -->
<!-- 						<button type="button" class="btn btn-default btn-sm">末页</button> -->
<!-- 					</div> -->
				</div>
				
			</div>
<!-- 			<div class="modal-footer"> -->
<!-- 				<button type="button" id="closeTree" class="btn btn-default">取消</button> -->
<!-- 				<button type="button" class="btn btn-primary" id="selectClient">确定</button> -->
<!-- 			</div> -->
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
<script type="text/javascript">
function getSettlementTr(settlement){
	var tr="<tr><td><input type='hidden' value='"+ifnull(settlement.sort_id)+"'><a>"
	+ifnull(settlement.settlement_sim_name)+"</a></td>";
	tr+="<td>"+ifnull(settlement.sort_id)+"</td>";
	return tr;
}
settlement={
		init:function(func){
			var setto2o;
			try{
				o2o.init();
				setto2o=o2o;
			}catch(e){
				setto2o=o2otree;
				setto2o.init();
			}
			setto2o.treeAll("settlement",function(n){
				return getSettlementTr(n);
			});
			setto2o.next_tree("settlement",function(n){
				return treeli(n.settlement_sim_name,n.sort_id);
			},function(n){
				return getSettlementTr(n);
			}); 
			setto2o.treeSelectInit();
			setto2o.slectTreeVal("结算方式",function(){
				if(func){
					func();
				}else{
					$("#upper_settlement_id").val(treeSelectId);
					$("#upper_settlement_name").html(treeSelectName);
				}
			});
		}
}
// settlement.init();
// try {
// o2o.init();
// o2o.treeAll("settlement",function(n){
// 	return getTr(n);
// });
// o2o.next_tree("settlement",function(n){
// 	return treeli(n.settlement_sim_name,n.sort_id);
// },function(n){
// 	return getTr(n);
// }); 
// o2o.treeSelectInit();
// o2o.slectTreeVal("结算方式",function(){
// 	$("#upper_settlement_id").val(treeSelectId);
// 	$("#upper_settlement_name").html(treeSelectName);
// });
// } catch (e) {
// 	o2otree.init(); 
// 	o2otree.treeAll("settlement",function(n){
// 		return getTr(n);
// 	});
// 	o2otree.next_tree("settlement",function(n){
// 		return treeli(n.settlement_sim_name,n.sort_id);
// 	},function(n){
// 		return getTr(n);
// 	}); 
// 	o2otree.treeSelectInit();
// 	o2otree.slectTreeVal("结算方式",function(){
// 		$("#upper_settlement_id").val(treeSelectId);
// 		$("#upper_settlement_name").html(treeSelectName);
// 		$("#settlement_type_id").val(treeSelectId);
// 		$("#settlement_type_name").html(treeSelectName);
// 	});
// }
</script>
</div><!-- /.modal -->