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
		"item_id":item_id,
		"customer_id":customerId,
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
var item_id="";
var customerId="";
$(function(){
	var params=window.location.href.split("?")[1];
	params=params.replace("#","");
	params=decodeURI(params).split("|");
	if(params[0]){
		customerId=params[0];
		$("#customerId").val(params[0]);
		$("#customerName").html(decodeURI(params[1]));
		$("#telNo").html(params[2]);
	}
	$(".btn-primary").click(function(){
		$.get("clientProcessModal.do",function(data){
			$("body").append(data);
			processAdd.init();
		});
	});
	function clickitem(){
		process.init();
	}
	/////////////////
	var itemhtml=$("#item");
	$.get("getProcessList.do",{
		"item_id":item_id,
		"customer_id":customerId,
		"item_name":$("#item_name").val()
	},function(data){
		$("#item01").html("");
		$.each(data,function(i,n){
			var item=$(itemhtml.html());
			$("#item01").append(item);
			item_id=n.item_id;
			item.find("#seeds_id").val(n.ID);
			item.find(".panel-heading").html("序号:"+(i+1));
			var n_headship="";
			if(n.zhiwu){
				n_headship=n.zhiwu;
			}
			if(n.clerk_name){
				item.find("#clerkName").html(n.clerk_name+"-"+n_headship+"(赛宇)");
			}else if(n.corp_sim_name){
				item.find("#clerkName").html(n.corp_sim_name+"-"+n_headship);
			}else{
				if(n.OA_whom&&n.OA_whom.indexOf("C")>=0){
					item.find("#clerkName").html(n.OA_whom+"(客户)");
				}else{
					item.find("#clerkName").html(n.OA_whom+"(员工)");
				}
			}
			item.find("#deptName").html(n.dept_name);
			item.find("#approvalStep").html(n.approval_step);
			item.find("#if_skip").html(n.if_skip);
			item.find("#noticeResult").html(n.noticeResult);
		});
		clickitem();
	});
});
var processAdd={
		init:function(id){
			if (!id) {
				$.get("getApproval_step.do",{
					"customer_id":customerId,
					"item_name":$("#item_name").val()
					},function(data){
					if($.trim($(".modal-first").find("#approval_step").html())!="2"){
						 $(".modal-first").find("#approval_step").html(data);
					 }
				});
			}
			
			$(".modal-first").find(".btn-success").unbind("click");
			$(".modal-first").find(".btn-success").click(function(){
				var n=$(".modal-first").find(".btn-success").index(this);
				pop_up_box.loadWait();
				if (n==0) {
					$(".modal-first").find("#clerk_id").val("");
					$(".modal-first").find("#clerk_name").html("");
					   $.get("getClientTree.do",{"customer_id":customerId,"next":"next","ver":Math.random()},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   client.init(function(){
							   $(".modal-first").find("#customer_id").val(treeSelectId);
							   $(".modal-first").find("#customer_name").html(treeSelectName);
						   });
					   });
				}else if(n==1){
					$(".modal-first").find("#customer_id").val("");
					$(".modal-first").find("#customer_name").html("");
					$.get("getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   employee.init(function(){
							   $(".modal-first").find("#clerk_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
							   $(".modal-first").find("#clerk_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
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
			$(".modal-first").find("input[name='inlineRadioOptions']").unbind("click");
			$(".modal-first").find("input[name='inlineRadioOptions']").click(function(){
				if($(this).val()=="0"){
					$(".modal-first").find("#clerk_nameSelect").show();
					$(".modal-first").find("#headshipselect").hide();
				}else{
					$(".modal-first").find("#clerk_nameSelect").hide();
					$(".modal-first").find("#headshipselect").show();
				}
			});
			$("#closeDiv,.close").click(function(){
				$(".modal-cover-first,.modal-first").remove();
			});
			$(".modal-first").find("#saveprocess").unbind("click");
			$(".modal-first").find("#saveprocess").click(function(){
				var clerk_id=$.trim($(".modal-first").find("#clerk_id").val());
				var headship =$.trim($(".modal-first").find("#headship").val());
				var customer_id =$.trim($(".modal-first").find("#customer_id").val());
				var dept_id=$.trim($(".modal-first").find("#deptId").val());
				var approval_step=$.trim($(".modal-first").find("#approval_step").html());
				var si=$(".modal-first").find("input[name='inlineRadioOptions']:checked").val();
				var ren;
				if(si=="0"){//选择协同人将角色清空
					headship="";
					if(customer_id==""){//第二步赛宇后台介入操作将客户清空
						ren=clerk_id;
					}else{
						ren=customer_id;
					}
				}else{
					customer_id="";
					clerk_id="";
				}
				if (ren=="") {
					alert("请选择审批人");
				}else if (approval_step=="") {
					alert("请选择审批步骤");
				}else{
					pop_up_box.postWait(); 
					$.post("saveProcessDetail.do",{
						"id":id,
						"clerk_id":clerk_id,
						"customer_id":customer_id,//选择客户编码
						"type":"client",
						"customerId":customerId,//上级客户编码
						"headship":headship,//角色
						"dept_id":dept_id,
						"approval_step":approval_step,
						"if_skip":$("#ifSkip").val(),
						"noticeResult":$(".modal-first").find("#noticeResult").val(),
						"item_id":item_id,
						"type_id":1,
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
			$(".btn-default").click(function(){
				$(this).parent().parent().find(".form-control").html("");
				$(this).parent().parent().find("input[type='hidden']").val("");
			});
		}
}

var process={
		init:function(){
			$(".col-lg-3").find("#upmove").unbind("click");
			$(".col-lg-3").find("#upmove").click(function(){
				moveprocess("up",this);
			});
			$(".col-lg-3").find("#downmove").unbind("click");
			$(".col-lg-3").find("#downmove").click(function(){
				moveprocess("down",this);
			});
			$(".col-lg-3").find("#editprocess").unbind("click");
			$(".col-lg-3").find("#editprocess").click(function(){
				var seeds_id=$.trim($(this).parents(".panel-info").find("#seeds_id").val());
				var t=this;
				$.get("clientProcessModal.do",function(data){
					$("body").append(data);
					processAdd.init(seeds_id);
					$(".modal-first").find("#approval_step").html($(t).parents(".col-lg-3").find("#approvalStep").html());
					if($.trim($(".modal-first").find("#approval_step").html())=="2"){
//						$("#employee").show();
//						$("#customer").hide();
					}
					if(seeds_id==""){
						return;
					}
					$.get("getProcess.do",{"seeds_id":seeds_id,"ver":Math.random()},function(data){
					 $(".modal-first").find("#clerk_name").html(data.clerk_name);
					 $(".modal-first").find("#customer_name").html(data.corp_sim_name);
					 $(".modal-first").find("#clerk_id").val(data.clerk_id);
					 $(".modal-first").find("#customer_id").val(data.customer_id);
					 $(".modal-first").find("#item_id").val(data.item_id);
					 $(".modal-first").find("#dept_name").html(data.dept_name);
					 $(".modal-first").find("#deptId").val(data.dept_id);
					 $(".modal-first").find("#approval_step").html(data.approval_step);
					 $(".modal-first").find("#if_skip").val(data.if_skip);
					 $(".modal-first").find("#noticeResult").val(data.noticeResult);
					 $(".modal-first").find("#headship").val(data.headship);
					 if(data.approval_step==2){
//						 $("#employee").show();
//						 $("#customer").hide();
					 }
					 if(data.headship&&data.headship!=""){
						 $("input[name='inlineRadioOptions']:eq(1)").click();
					 }
					})
				});
			});
			$(".col-lg-3").find("#delprocess").unbind("click");
			$(".col-lg-3").find("#delprocess").click(function(){
				if(confirm("是否要删除该审批流程!")){
					var seeds_id=$(this).parents(".panel-info").find("#seeds_id").val();
					var approvalStep=$(this).parents(".panel-info").find("#approvalStep").html();
					$.get("delProcess.do",{
						"id":seeds_id,
						"customer_id":customerId,
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
}