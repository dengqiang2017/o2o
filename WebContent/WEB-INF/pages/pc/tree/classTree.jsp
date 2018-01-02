<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">产品类别选择</h4>
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
					<c:forEach items="${requestScope.clss}" var="cls">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${cls.sort_name}
					<input type="hidden" value="${cls.sort_id}"></span></li>
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
							       <th>物品类别编码</th>  
							       <th>物品类别名称</th> 
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.clss}" var="cls">
								<tr>
									<td><a>${cls.sort_id}</a></td>
									<td><input type="hidden" value="${cls.sort_id}">${cls.sort_name}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
	procls={
		init:function(func){
		function getTr(cls){
			var tr="<tr><td><input type='hidden' value='"+cls.sort_id+"'><a>"+cls.sort_name+"</a></td>"
			tr+="<td>"+cls.sort_name+"</td>";
			return tr;
		}
				o2otree.treeAll("cls",function(n){
					return getTr(n);
				});
				o2otree.next_tree("productClass",function(n){
					return treeli(n.sort_name,n.sort_id);
				},function(n){
					return getTr(n);
				}); 
				o2otree.treeSelectInit();
				o2otree.slectTreeVal("产品类型",function(){
					if(func){
						func();
					}else{
					$("input[name='type_id']").val(treeSelectId);
					$("#type_id").val(treeSelectId);
					$("#sort_name").html(treeSelectName);
					$("#type_name").html(treeSelectName);
					$("#clsname").html(treeSelectName);
					}
				});
		}
	}
	
</script>
</div><!-- /.modal -->