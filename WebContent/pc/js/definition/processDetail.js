$(function(){
	var params=window.location.href.split("?")[1];
	params=params.split("&");
	var type=params[0].split("=")[1];
	var type_id=params[1].split("=")[1];
	type=decodeURI(type);
	$(".box-head").append("-"+type);
	$("#item_name").val(type);
	$("#type_id").val(type_id);
	$(".btn-primary:eq(0)").click(function(){
		$.get("processModal.do",function(data){
			$("body").append(data);
			processAdd.init();
		});
	});
	$(".btn-primary:eq(1)").click(function(){
		$.get("processModal.do",{
			"type":"cc"
		},function(data){
			$("body").append(data);
			chaosong.init();
		});
	});
	function clickitem(){
		function moveprocess(type,t){
			var item_name=$("#item_name").val();
			var approvalStep=$(t).parents(".panel-info").find("#approvalStep").html();
			var id=$(t).parents(".panel-info").find("#seeds_id").val();
			if (approvalStep==1) {
				pop_up_box.showMsg("已经是第一个,不能在向上移!");
				return;
			}
			$.get("moveProcess.do",{
				"approval_step":approvalStep,
				"item_name":item_name,
				"item_id":$("#item_id").val(),
				"type":type,
				"id":id
			},function(data){
				if (data.success) {
					window.location.reload();
				}else{
					pop_up_box.showMsg("移动失败,错误:"+data.msg);
				}
			});
		}
		$(".col-lg-3").find("#upmove").click(function(){
			moveprocess("up",this);
		});
		$(".col-lg-3").find("#downmove").click(function(){
			moveprocess("down",this);
		});
		$(".col-lg-3").find("#editprocess").click(function(){
			var item=$(this).parents(".panel-info");
			var seeds_id=$(this).parents(".panel-info").find("#seeds_id").val();
			var approvalStep=$(this).parents(".panel-info").find("#approvalStep");
			if(approvalStep.length>0){
				$.get("processModal.do",function(data){
					$("body").append(data);
					processAdd.init(seeds_id);
					$("#clerk_name").html(item.find("#clerkName").html());
					$(".modal-body #clerk_id").val(item.find("#clerk_id").html());
					$("#dept_name").html(item.find("#deptName").html());
					$(".modal-body #deptId").val(item.find("#dept_id").html());
					$("#approval_step").html(item.find("#approvalStep").html());
					$("#if_skip").val(item.find("#if_skip").html());
				});
			}else{//抄送
				$.get("processModal.do",{
					"type":"cc"
				},function(data){
					$("body").append(data);
					chaosong.init();
					var clerkName=item.find("#clerkName").html();
					var clerk_id=item.find("#clerk_id").html();
					$(".modal-body #clerk_name").html(clerkName);
					$(".modal-body #clerk_id").html(clerk_id);
				});
			}
		});
		$(".col-lg-3").find("#delprocess").click(function(){
			if(confirm("是否要删除该审批流程!")){
				var seeds_id=$(this).parents(".panel-info").find("#seeds_id").val();
				var approvalStep=$(this).parents(".panel-info").find("#approvalStep").html();
				$.get("delProcess.do",{
					"id":seeds_id,
					"approval_step":approvalStep,
					"item_name":$("#item_name").val()
				},function(data){
					if (data.success) {
						$(this).parents(".panel-info").remove();
						window.location.reload();
					}else{
						pop_up_box.showMsg("删除失败,错误:"+data.msg);
					}
				});
			}
		});
	}
	/////////////////
	var itemhtml=$(".col-lg-3");
	$.get("getProcessList.do",{
		"item_id":$("#item_id").val(),
		"item_name":$("#item_name").val()
	},function(data){
		$("#item01").html("");
		$.each(data,function(i,n){
			var item=$("<div class='col-lg-3 col-sm-4'>"+itemhtml.html()+"</div>");
			$("#item01").append(item);
			$("#item_id").val(n.item_id);
			item.find("#seeds_id").val(n.ID);
			item.find(".panel-heading").html("序号:"+(i+1));
			item.find("#clerkName").html(n.clerk_name);
			item.find("#clerk_id").html(n.clerk_id);
			item.find("#dept_id").html(n.dept_id);
			if(!n.approval_step){
				item.find("#clerkName").prev().html("抄送人:");
				item.find("#deptName").parent().remove();
				item.find("#approvalStep").parent().remove();
				item.find("#if_skip").parent().remove();
				item.find("#upmove").remove();
				item.find("#downmove").remove();
			}else{
				item.find("#deptName").html(n.dept_name);
				item.find("#approvalStep").html(n.approval_step);
				item.find("#if_skip").html(n.if_skip);
			}
		});
		clickitem();
	});
});
var chaosong={
		init:function(){
			$(".btn-success").unbind("click");
			$(".btn-success").click(function(){
				var n=$(".btn-success").index(this);
				pop_up_box.loadWait(); 
			    $.get("getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
			 	   pop_up_box.loadWaitClose();
			 	   $("body").append(data);
			 	   employee.init(function(){
			 		   var clerk_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
			 		   console.debug($("#clerk_id").text());
			 		   console.debug($("#clerk_id").text().indexOf(clerk_id));
			 		   if ($(".modal-body #clerk_id").text().indexOf(clerk_id)<0) {
			 			   $(".modal-body #clerk_id").append(clerk_id+",");
			 			   $(".modal-body #clerk_name").append($(".modal").find("tr.activeTable").find("td:eq(0)").text()+",");
			 		   }
			 	   });
			    });
			});
			$("#saveprocess").unbind("click");
			$("#saveprocess").click(function(){
				var clerk_id=$.trim($(".modal-body #clerk_id").html());
				if (!clerk_id) {
					pop_up_box.showMsg("请选择抄送人员!");
				}else{
					pop_up_box.postWait(); 
					$.post("saveProcessDetail.do",{
						"clerk_id":clerk_id,
						"approval_step":20,
						"item_id":$("#item_id").val(),
						"type_id":$("#type_id").val(),
						"item_name":$("#item_name").val()
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							$(".modal-cover-first,.modal-first").remove();
							window.location.reload(true);
						}else{
							alert("保存失败!错误"+data.msg);
						}
					});
				}
			});
			$("#closeDiv,.close").click(function(){
				$(".modal-cover-first,.modal-first").remove();
			});
			$(".btn-default").click(function(){
				$(this).parent().parent().find(".form-control").html("");
				$(this).parent().parent().find("#clerk_id").html("");
				$(this).parent().parent().find("#clerk_id").val("");
			});
		}
};
var processAdd={
		init:function(id){
			if (!id) {
				$.get("getApproval_step.do",{"item_name":$("#item_name").val()},function(data){
					$("#approval_step").html(data);
				});
			}
			$(".btn-success").unbind("click");
			$(".btn-success").click(function(){
				var n=$(".btn-success").index(this);
				pop_up_box.loadWait(); 
				if (n==0) {
					   $.get("getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   employee.init(function(){
							   $("#clerk_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
							   $("#clerk_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
						   });
					   });
				}else{
			  		   $.get("getDeptTree.do",{"type":"dept","ver":Math.random()},function(data){
			  			   pop_up_box.loadWaitClose(); 
			  			   $("body").append(data);
			  			   dept.init();
			  		   });
				}
			});
			$("#saveprocess").unbind("click");
			$("#saveprocess").click(function(){
				var clerk_id=$.trim($("#clerk_id").val());
				var dept_id=$.trim($("#deptId").val());
				var approval_step=$.trim($("#approval_step").html());
				if (clerk_id=="") {
					alert("请选择审批人");
				}else if (dept_id=="") {
					alert("请选择所属部门");
				}else if (approval_step=="") {
					alert("请选择审批步骤");
				}else{
					pop_up_box.postWait(); 
					$.post("saveProcessDetail.do",{
						"id":id,
						"clerk_id":clerk_id,
						"dept_id":dept_id,
						"approval_step":approval_step,
						"if_skip":$("#ifSkip").val(),
						"item_id":$("#item_id").val(),
						"type_id":$("#type_id").val(),
						"item_name":$("#item_name").val()
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							$(".modal-cover-first,.modal-first").remove();
							window.location.reload(true);
						}else{
							alert("保存失败!错误"+data.msg);
						}
					});
				}
			}); 
			$("#closeDiv,.close").click(function(){
				$(".modal-cover-first,.modal-first").remove();
			});
			$(".btn-default").click(function(){
				$(this).parent().parent().find(".form-control").html("");
				$(this).parent().parent().find("input[type='hidden']").val("");
			});
		}
}