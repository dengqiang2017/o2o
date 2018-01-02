<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="modal_worker">
	<div class="modal-cover"></div>
	<div class="modal" style="display:block;">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">工人选择</h4>
				</div>
				
				<div class="modal-body">
					<form class="form-inline m-t-b">
			        	<div class="form-group">
			            	<label for="recipient-name" class="control-label">关键词</label>
			            	<input type="text" class="form-control" id="modal_searchKey">
			          	</div>
			          	<button type="button" class="btn btn-primary" id="modal_find">搜索</button>
					  	<button type="button" class="btn btn-primary" id="modal_ok">确定</button>
			          	<button type="button" class="btn btn-default" id="modal_close">取消</button>
			        </form>
					<div class="tabs-content" style="height:400px;">
						<div class="table" style="height:360px; overflow-y:scroll;">
							<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>员工名称</th>  
									       <th>员工编号</th>
									       <th>手机号</th>  
									    </tr>
									</thead>
									<tbody>
									<c:forEach items="${requestScope.worker}" var="prop">
										<tr>
											<td>${prop.clerk_name}</td>
											<td>${prop.clerk_id}</td>
											<td>${prop.movtel}</td>
										</tr>
									</c:forEach>
									</tbody>
							</table>
							<div id="modal_value">
								<input type="text" class="form-control" id="modal_value1">
								<input type="text" class="form-control" id="modal_value2">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<script type="text/javascript">
		//模态框最终值隐藏
		$("#modal_value").hide();
		
		//模态框表格每一行增加点击事件
		$("#modal_worker").find("tr").each(function(){
			$(this).attr("onclick","chooseIt(this)");
		});
		
		//模态框选择值
		var chooseIt = function(data){
			$("#modal_worker").find("tr").each(function(){
				$(this).css('background-color','#FFFFFF');
			});
			$(data).css('background-color','#337AB7');
			var clerk_name = $(data).find("td:eq(0)")[0].innerText;
			var clerk_id = $(data).find("td:eq(1)")[0].innerText;
			$("#modal_value1").val(clerk_name);
			$("#modal_value2").val(clerk_id);
		};
		
		//模态框确认选择
		$("#modal_ok").click(function(){
			$("#clerk_name").html($("#modal_value1").val());
			$("#clerk_id").val($("#modal_value2").val());
			$("#modal_worker").remove();
		});
		
		//关闭模态框
		$("#modal_close, .close").click(function(){
			$("#modal_worker").remove();
		});
		
		//模态框搜索
		$("#modal_find").click(function(){
			pop_up_box.loadWait(); 
			$.get("../pm/getWorkerTree.do",{
				"modal_searchKey" : $.trim($("#modal_searchKey").val()),
				"work_id" : $("#work_id").val(),
				"ver":Math.random()
			},function(data){
				pop_up_box.loadWaitClose();
				$("#modal_worker").remove();
				$("body").append(data);
		   }); 
		});
	</script>
</div>