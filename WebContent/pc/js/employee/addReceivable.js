//期初应收
$(function(){
	$("#initReceivable").click(function(){
		$("#addReceivableInit").show();
		initpageinp();
	});
	$("#saveReceivable").click(function(){
		var  customerId=$.trim($("#customerId").val());
		var  oh_sum=$.trim($("#oh_sum").val());
		var  sdorderId=$.trim($("#sdorderId").val());
		var  deptsimId=$.trim($("#deptsimId").val());
		var  clerkid=$.trim($("#clerkid").val());
		var  c_memo=$.trim($("#c_memo").val());
		var  seeds_id=$.trim($("#seedsId").val());
		if (clerkid=="") {
			pop_up_box.showMsg("请选择经办人!");
			return;
		}else if(deptsimId==""){
			pop_up_box.showMsg("请选择经办部门!");
			return;
		}else if(customerId==""){
			pop_up_box.showMsg("请选择客户!");
			return;
		}else if(sdorderId==""){
			pop_up_box.showMsg("请选择结算方式!");
			return;
		}else if(oh_sum==""){
			pop_up_box.showMsg("请输入期初应收金额!");
			return;
		}else{
			$("#addReceivableInit").hide();
			pop_up_box.postWait(); 
			$.post("../manager/addInitialReceivable.do",
				{"customer_id":customerId,"rcv_hw_no":sdorderId,"dept_id":deptsimId
				,"clerk_id":clerkid,"c_memo":c_memo,"oh_sum":oh_sum,"seeds_id":seeds_id},
				function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.toast("数据保存成功!",2000);
					$(".find").click();
				}else{
					pop_up_box.showMsg("数据保存失败,错误:"+data.msg);
				}
			});
		}
	});
	function initpageinp(){
		$("#oh_sum").val("");
		$("#c_memo").val("");
		$("#sdorderId").val("");
		$("#customerId").val("");
		$("#customer_name").html("");
		$("#sd_order_name").html("");
		$("#deptsimId").val("");
		$("#dept_sim_name").html("");
		$("#clerkid").val("");
		$("#clerkName").html("");
		$("#seedsId").val("");
	}
	//修改
	$("#editReceivable").click(function(){
		var seeds_id=$.trim($(".tabs-content:eq(0)").find(".active_table #seeds_id").val());
		if(seeds_id==""){
			pop_up_box.showMsg("请选中一条需要修改的期初应收信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(0)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能修改,请弃审后再操作!");
			return;
		}
		initpageinp();
		pop_up_box.loadWait();
		$.get("initialReceivableInfo.do",{
			"seeds_id":seeds_id
		},function(data){
			pop_up_box.loadWaitClose();
			$("#oh_sum").val(data.oh_sum);
			$("#c_memo").val(data.c_memo);
			$("#sdorderId").val(data.rcv_hw_no);
			$("#customerId").val(data.customer_id);
			$("#customer_name").html(data.corp_sim_name);
			$("#sd_order_name").html(data.settlement_sim_name);
			$("#deptsimId").val(data.dept_id);
			$("#dept_sim_name").html(data.dept_name);
			$("#clerkid").val(data.clerk_id);
			$("#clerkName").html(data.clerk_name);
			$("#seedsId").val(data.seeds_id);
			$("#addReceivableInit").show();
		});
	});
	//删除
	$("#delReceivable").click(function(){
		var seeds_id=$.trim($(".tabs-content:eq(0)").find(".active_table #seeds_id").val());
		if(seeds_id==""){
			pop_up_box.showMsg("请选中一条需要删除的期初应收信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(0)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能删除,请弃审后再操作!");
			return;
		}
		if (window.confirm("是否删除该条记录?")){
			pop_up_box.postWait();
			$.post("../manager/delClient.do",{"seeds_id":seeds_id,"type":"receivable"},
					function(data){
				pop_up_box.loadWaitClose();
				if (data.success){
					pop_up_box.showmsg("删除成功!",function(){
						$(".find").click();
					});
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
	});
	$(".qx,.close").click(function(){
		$("#addReceivableInit").hide();
	});
	$(".belongDept").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do",{
			"type" : "dept"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			dept.init(function(){
					$("#deptsimId").val(treeSelectId);
					$("#dept_sim_name").html(treeSelectName);
					
			});
		});
	});
	$(".sd_order").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "settlement"
		}, function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			settlement.init(function(){
					$("#sdorderId").val(treeSelectId);
					$("#sd_order_name").html(treeSelectName);
			});
		});
	});
	$(".customer").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "client"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			client.init(function(){
					$("#customerId").val(treeSelectId);
					$("#customer_name").html(treeSelectName);
			});
		});
	});
	$(".belongClerk").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "employee"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			employee.init(function(){
					$("#clerkid").val(treeSelectId);
					$("#clerkName").html(treeSelectName);
			});
		});
	});
});
	
