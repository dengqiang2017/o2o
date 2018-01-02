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
		         <button type="button" id="backshow" class="btn btn-default" style="display: none;">显示已选择</button>
		        </form>
		        <ul class="nav nav-tabs" style="margin-top:10px;">
				    <li class="active"><a href="#">树形展示</a></li>
				    <li ><a href="#">列表展示</a></li>
				</ul>
				<input type="hidden" id="select_customer_id">
				<div class="tabs-content" style="height:400px;">
					<div class="tree" style="height:360px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.clients}" var="client">
					<li class="parent_li"><span  class="client_tree">
					<i class="glyphicon glyphicon-leaf"></i>${client.corp_name}
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
							       <th data-name="corp_name">客户名称</th>  
							       <th data-name="tel_no">手机号</th> 
							       <th data-name="weixinID">微信账号</th>
							    </tr>
							</thead>
							<tbody>
							<c:forEach items="${requestScope.clients}" var="client">
								<tr>
									<td><input type="hidden" value="${client.customer_id}">${client.corp_name} </td>
									<td>${client.tel_no}</td> 
									<td>${client.weixinID}</td>
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
function getClentTr(client){
	var tr="<tr><td><input type='hidden' value='"+ifnull(client.customer_id)+"'>"+ifnull(client.corp_name)+"</td>"
	tr+="<td>"+ifnull(client.tel_no)+"</td>";
	tr+="<td>"+ifnull(client.weixinID)+"</td>";
	return tr;
}
client={
		init:function(func){
			o2otree.treeAll("client",function(n){
			return getClentTr(n);
		});
			o2otree.next_tree("client",function(n){
			if(treeSelectId==n.customer_id){
				return "";
			}
			return treeli(n.corp_name,n.customer_id);
		},function(n){
			return getClentTr(n);
		});
			o2otree.treeSelectInit();
			o2otree.slectTreeVal("上级客户",function(){
			if(func){
				func(treeSelectId,treeSelectName);
			}else{
			if($("input[name='upper_customer_id']").length>0){
				$("input[name='upper_customer_id']").val(treeSelectId);
			}else{
				$("#clientId").val(treeSelectId);
			}
			$("#upper_corp_name").html(treeSelectName);
			$("#upper_customer_name").html(treeSelectName);
			$("#upper_corpName").html(treeSelectName);
			}
		});
// 			$("#findtree:eq(0)").click();
			$(".tree").find("span:contains('我公司')").click();
		},backshow:function(backshow){
			$(".modal-body #backshow").unbind("click");
			$(".modal-body #backshow").click(function(){
				backshow();
			});
			$(".modal-body #backshow").show();
		}
}
// client.init();
</script>
</div> 