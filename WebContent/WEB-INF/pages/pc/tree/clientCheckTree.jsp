<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">客户选择</h4>
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
				<input type="hidden" id="select_customer_id">
				<div class="tabs-content" style="height:400px;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.clients}" var="client">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${client.corp_name}
					<input type="hidden" value="${client.customer_id}"></span></li>
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
							       <th>客户名称</th>  
							       <th>手机号</th> 
							       <th>渠道类型</th> 
							       <th>片区</th> 
							       <th>联系人</th>  
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.clients}" var="client">
								<tr>
									<td><a href="clientEdit.do?customer_id=${client.customer_id}&info=show" target="_blank" title="点击查看详细">${client.corp_name}</a></td>
									<td><input type="hidden" value="${client.customer_id}">${client.tel_no}</td>
									<td>${client.ditch_type}</td>
									<td>${client.regionalism_name_cn}</td>
									<td>${client.corp_reps}</td>
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
client={
		init:function(func){
		function getTr(client){
			var tr="<tr><td><input type='hidden' value='"+ifnull(client.customer_id)+"'>"+ifnull(client.corp_name)+"</td>"
			tr+="<td>"+ifnull(client.tel_no)+"</td>";
			tr+="<td>"+ifnull(client.ditch_type)+"</td>";
			tr+="<td>"+ifnull(client.regionalism_name_cn)+"</td>";
			tr+="<td>"+ifnull(client.corp_reps)+"</td>";
			return tr;
		}
		o2o.init();
		o2o.treeAll("cls",function(n){
			return getTr(n);
		});
		o2o.next_tree("client",function(n){
			if(treeSelectId==n.customer_id){
				return "";
			}
			return treeli(n.corp_name,n.customer_id);
		},function(n){
			return getTr(n);
		});
		o2o.treeSelectInit();
		o2o.slectTreeVal("上级客户",function(){
			if(func){
				func();
			}else{
			if($("input[name='upper_customer_id']").length>0){
				$("input[name='upper_customer_id']").val(treeSelectId);
			}else{
				$("#clientId").val(treeSelectId);
			}
			$("#upper_corp_name").html(treeSelectName);
			}
		});
		}
}
client.init();
$(".tree").find("span:contains('我公司')").click();
</script>
</div><!-- /.modal -->