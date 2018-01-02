<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="warehouseTreePage">
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">库房选择</h4>
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
				<div class="tabs-content" style="height:400px;display:  ;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.wares}" var="ware">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf">${ware.store_struct_name}:${ware.addr}</i>
					<input type="hidden" value="${ware.sort_id}"></span></li>
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
							       <th>库房名称地址</th>
							       <th>库房编码</th>  
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.wares}" var="ware">
								<tr>
									<td><input type="hidden" value="${ware.sort_id}">${ware.store_struct_name}:${ware.addr}</td>
									<td>${ware.sort_id}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div> 
				</div>
			</div> 
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
<script type="text/javascript">
<!--
warehouse={
		init:function(func){
			function getWareTr(ware){
				var tr="<tr><td><input type='hidden' value='"+ifnull(ware.sort_id)+"'>"+ifnull(ware.store_struct_name)
				+":${ware.addr}</td>";
				tr+="<td>"+ifnull(ware.sort_id)+"</td>"
				return tr;
			}
			o2otree.init();
			o2otree.treeAll("warehouse",function(n){
			return getWareTr(n);
		});
			o2otree.next_tree("warehouse",function(n){
			return treeli(n.store_struct_name+":"+n.addr,n.sort_id);
		},function(n){
			return getWareTr(n);
		}); 
			o2otree.treeSelectInit();
			o2otree.slectTreeVal("库房",function(){
			if(func){
				func();
			}else{
			$("#upper_storestruct").val(treeSelectId);
			$("#store_struct_id").val(treeSelectId);
			$("#store_struct_name").html(treeSelectName);
			$("#upper_storestruct_name").html(treeSelectName);
			}
		});
// 		$(".modal .nav>li:eq(1)").click();
// 		$(".modal .nav>li:eq(0)").hide();
		}
}
//-->
</script>
</div><!-- /.modal -->
</div>