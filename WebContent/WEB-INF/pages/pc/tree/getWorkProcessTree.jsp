<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<div id="modal_workProcess">
	<div class="modal-cover"></div>
	<div class="modal" style="display:block;">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">工序选择</h4>
				</div>
				
				<div class="modal-body">
					<form class="form-inline m-t-b">
			        	<div class="form-group">
			            	<label for="recipient-name" class="control-label">工序类别</label>
			            	<select class="form-control" id="working_procedure_section">
			            	<c:forEach items="${requestScope.working_procedure_section}" var="prop">
								<option value="${prop}">${prop}</option>
							</c:forEach>
			            	</select>
			          	</div><br>
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
									       <th>工序名称</th>  
<!-- 									       <th>所属工段</th> -->
									       <th>工序编码</th>  
									       <th>序号</th>
									       <th>工序类别</th>
									    </tr>
									</thead>
									<tbody>
									<c:forEach items="${requestScope.workProcess}" var="prop">
										<tr>
											<td>${prop.work_name}</td>
<%-- 											<td>${prop.work_type}</td> --%>
											<td>${prop.work_id}</td>
											<td><fmt:formatNumber value="${prop.No_serial}" pattern="0"/></td>
											<td>${prop.working_procedure_section}</td>
										</tr>
									</c:forEach>
									</tbody>
							</table>
<!-- 							<div id="modal_value"> -->
<!-- 								<input type="text" class="form-control" id="modal_value1"> -->
<!-- 								<input type="text" class="form-control" id="modal_value2"> -->
<!-- 								<input type="text" class="form-control" id="modal_value3"> -->
<!-- 							</div> -->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<script type="text/javascript">
	
	var workProcessTree={
			init:function(func){
				$(".modal").find("tbody tr").removeClass('activeTable');
				$(".modal").find("tbody tr").click(function(){
					if($(this).hasClass("activeTable")){
						$(this).removeClass('activeTable');
					}else{
						$(this).addClass('activeTable');
					}
				});
		//隐藏域
		$(".hide").each(function(n){
			$(n).hide();
		});
		//模态框最终值隐藏
		$("#modal_value").hide();
		//模态框表格每一行增加点击事件
// 		$("#modal_workProcess").find("tr").each(function(){
// 			$(this).attr("onclick","chooseIt(this)");
// 		});
		//模态框选择值
// 		var chooseIt = function(data){
// 			$("#modal_workProcess").find("tr").each(function(){
// 				$(this).css('background-color','#FFFFFF');
// 			});
// 			$(data).css('background-color','#337AB7');
// 			var work_name = $(data).find("td:eq(0)")[0].innerText;
// 			var work_id = $(data).find("td:eq(2)")[0].innerText;
// 			var No_serial = $(data).find("td:eq(3)")[0].innerText;
// 			$("#modal_value1").val(work_name);
// 			$("#modal_value2").val(work_id);
// 			$("#modal_value3").val(No_serial);
// 		};
		//模态框确认选择
// 		$(".btn-primary").unbind("click");
		$("#modal_ok").click(function(){
// 			$("#work_name").html($("#modal_value1").val());
// 			$("#work_id").val($("#modal_value2").val());
// 			$("#No_serial").val($("#modal_value3").val());
// 			$("#modal_workProcess").remove();
			if(func){
				var trs=$(".modal").find(".activeTable");
				if(trs&&trs.length>0){
					var work_name="";
					var work_id="";
					for (var i = 0; i < trs.length; i++) {
						var tr=$(trs[i]);
						if(work_id!=""){
							work_name=work_name+","+tr.find("td:eq(0)").html();
							work_id=work_id+","+tr.find("td:eq(1)").html();
						}else{
							work_name=tr.find("td:eq(0)").html();
							work_id=tr.find("td:eq(1)").html();
						}
					}
					$("#modal_workProcess").hide();
					func(work_id,work_name);
				}
			}
		});
		
		//关闭模态框
		$("#modal_close, .close").click(function(){
			$("#modal_workProcess").remove();
		});
		
		//模态框搜索
		$("#modal_find").click(function(){
			pop_up_box.loadWait(); 
			$.get("../pm/getWorkProcessTreeList.do",{
				"searchKey" : $.trim($("#modal_searchKey").val()),
				"working_procedure_section":$("#working_procedure_section").val()
			},function(data){
				pop_up_box.loadWaitClose();
				$(".modal").find("tbody").html("");
				$.each(data,function(i,n){
					var tr=getTr(4);
					$(".modal").find("tbody").append(tr);
					tr.find("td:eq(0)").html(n.work_name);
					tr.find("td:eq(1)").html(n.work_id);
					tr.find("td:eq(2)").html(numformat(n.No_serial,0));
					tr.find("td:eq(3)").html(n.working_procedure_section);
				});
				$(".modal").find("tbody tr").removeClass('activeTable');
				$(".modal").find("tbody tr").click(function(){
					if($(this).hasClass("activeTable")){
						$(this).removeClass('activeTable');
					}else{
						$(this).addClass('activeTable');
					}
				});
		   });
		});
		}
	}
	</script>
</div>