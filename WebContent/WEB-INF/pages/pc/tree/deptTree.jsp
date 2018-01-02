<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">部门选择</h4>
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
<!-- 				    <li><a href="#">列表展示</a></li> -->
				</ul>
				<input type="hidden" id="select_customer_id">
				<div class="tabs-content" style="height:400px;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.depts}" var="dept">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${dept.dept_name}
					<input type="hidden" value="${dept.sort_id}"></span></li>
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
							       <th>部门编码</th>  
							       <th>部门名称</th>  
<!-- 							       <th>部门类型</th>  -->
							       <th>负责人</th> 
<!-- 							       <th>联系电话</th>  -->
<!-- 							       <th>地址</th>   -->
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.depts}" var="dept">
								<tr>
								<td>${dept.sort_id}</td>
									<td><input type="hidden" value="${dept.sort_id}">
									<a href="deptEdit.do?sort_id=${dept.sort_id}&info=show" 
									target="_blank" title="点击查看详细">${dept.dept_name}</a></td>
<%-- 									<td>${dept.m_flag}</td> --%>
									<td>${dept.dept_manager}</td>
<%-- 									<td>${dept.tel_no}</td> --%>
<%-- 									<td>${dept.dept_addr}</td> --%>
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
<!-- 
dept={
		init:function(func){
function getTr(dept){
	var tr="<tr><td>"+ifnull(dept.sort_id)+"</td><td><input type='hidden' value='"+ifnull(dept.sort_id)+"'><a href='deptEdit.do?sort_id="+ifnull(dept.sort_id)
	+"&info=show' target='_blank' title='点击查看详细'>"+ifnull(dept.dept_name)+"</a></td>"
// 	tr+="<td>"+ifnull(dept.m_flag)+"</td>";
	tr+="<td>"+ifnull(dept.dept_manager)+"</td>";
// 	tr+="<td>"+ifnull(dept.tel_no)+"</td>";
// 	tr+="<td>"+ifnull(dept.dept_addr)+"</td>";
	return tr;
}
		o2otree.init();
		o2otree.treeAll("",function(n){
			return getTr(n);
		});
		o2otree.next_tree("dept",function(n){
			return treeli(n.dept_name,n.sort_id);
		},function(n){
			return getTr(n);
		}); 
		o2otree.treeSelectInit();
		o2otree.slectTreeVal("部门",function(){
			if(func){
				func(treeSelectId,treeSelectName);
			}else{
			if($("input[name='sort_id']").length>0){
				$("input[name='sort_id']").val(treeSelectId);
			}
				$("#deptId").val(treeSelectId);
			try{
				$("#upper_dept_id").val(treeSelectId);
				$("#upper_dept_name").html(treeSelectName);
			}catch(e){}
			$("#dept_name").html(treeSelectName);
			}
			});
		$(".modal").find(".tree").find("span:contains('武汉通威')").click();
		}
}
//-->
//dept.init();
</script>
</div><!-- /.modal -->