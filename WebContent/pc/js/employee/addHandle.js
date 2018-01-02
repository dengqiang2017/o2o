//期初应付
$(function(){
	$("#saveHandle").click(function(){
		var  vendor_id=$.trim($("#vendorId").val());
		var  dept_id=$.trim($("#deptid").val());
		var  clerk_id=$.trim($("#clerk_id").val());
		var  beg_sum=$.trim($("#beg_sum").val());
		if (vendor_id==""||dept_id==""||beg_sum==""||clerk_id==""){
			pop_up_box.showMsg("请选择经办人!");
			return;
		}else if(dept_id==""){
			pop_up_box.showMsg("请选择经办部门!");
			return;
		}else if(vendor_id==""){
			pop_up_box.showMsg("请选择供应商!");
			return;
		}else if(beg_sum==""){
			pop_up_box.showMsg("请输入应付金额!");
			return;
		}else{
			$("#addHandleInit").hide();
			pop_up_box.postWait(); 
			$.post("../manager/addInitialHandle.do",$("#setHandle").serialize(),function(data){
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
	//删除
	$("#delHandle").click(function(){
		var seeds_id=$.trim($(".active_table #seeds_id").val());
		if(seeds_id==""){
			pop_up_box.showMsg("请选中一条需要修改删除的期初应付信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(1)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能删除,请弃审后再操作!");
			return;
		}
		if (window.confirm("是否删除该条记录?")){
			var ivt_num_detail=$.trim($(".active_table #seeds_id").val());
			pop_up_box.postWait();
			$.post("../manager/delClient.do",{"seeds_id":seeds_id,"type":"handle"},
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
	function initpageinp(){
		$("#vendorId").val("");
		$("#vendor_name").html("");
		$("#deptid").val("");
		$("#dept").html("");
		$("#clerk_id").val("");
		$("#clerkname").html("");
		$("#beg_sum").val("");
		$("#seedsid").val("");
	}
	//修改
	$("#editHandle").click(function(){
		var seeds_id=$.trim($(".tabs-content:eq(1)").find(".active_table #seeds_id").val());
		if(seeds_id==""){
			pop_up_box.showMsg("请选中一条需要修改的期初应付信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(1)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能修改,请弃审后再操作!");
			return;
		}
		initpageinp();
		pop_up_box.loadWait();
		$.get("initialPayablePage.do",{
			"seeds_id":seeds_id
		},function(data){
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				$("#vendorId").val(n.vendor_id);
				$("#vendor_name").html(n.corp_name);
				$("#deptid").val(n.dept_id);
				$("#dept").html(n.dept_name);
				$("#clerk_id").val(n.clerk_id);
				$("#clerkname").html(n.clerk_name);
				$("#beg_sum").val(n.beg_sum);
				$("#seedsid").val(n.seeds_id);
			});
			$("#addHandleInit").show();
		});
	});
	//应付
	$("#initHandle").click(function(){
		$("#addHandleInit").show();
		initpageinp();
	});
	$(".qx,.close").click(function(){
		$("#addHandleInit").hide();
	});
	$(".corp").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "vendor"
		}, function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			vendor.init(function(){
					$("#vendorId").val(treeSelectId);
					$("#vendor_name").html(treeSelectName);
			});
		});
	});
	$(".procurementDept").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do",{
			"type" : "dept"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			dept.init(function(){
					$("#deptid").val(treeSelectId);
					$("#dept").html(treeSelectName);
					
			});
		});
	});
	$(".procurementClerk").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "employee"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			employee.init(function(){
					$("#clerk_id").val(treeSelectId);
					$("#clerkname").html(treeSelectName);
			});
		});
	});
})