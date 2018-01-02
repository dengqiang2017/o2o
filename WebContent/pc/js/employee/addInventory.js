//期初库存
$(function(){
	$.get("setDefaultByClerkId.do",function(data){
		$.each(data,function(i,n){
			$("#clerk_name,#clerkName,#clerkname").html(n.clerk_name);
			$("#clerkId,#clerkid,#clerk_id").val(n.clerk_id);
			$("#dept_name,#dept_sim_name,#dept").html(n.dept_name);
			$("#deptId,#deptsimId,#deptid").val(n.dept_id);
		})
	});
	//新增
	$("#selectClient").click(function(){
		var  store_struct_id=$.trim($("#storestructId").val());
		var  dept_id=$.trim($("#deptId").val());
		var  clerk_id=$.trim($("#clerkId").val());
		var  item_id=$.trim($("#itemId").val());
//		var  corp_id=$.trim($("#corp_id").val());
		var  oh=$.trim($("#oh").val());
		var  i_price=$.trim($("#i_price").val());
		if (store_struct_id==""){
			pop_up_box.showMsg("请选择仓库!");
			return;
		}else if(item_id==""){
			pop_up_box.showMsg("请选择产品!");
			return;
		}else if(oh==""){
			pop_up_box.showMsg("请输入期初数量!");
			return;
		}else if(dept_id==""){
			pop_up_box.showMsg("请选择经办部门!");
			return;
		}else if(clerk_id==""){
			pop_up_box.showMsg("请选择经办人!");
			return;
		}else if(i_price==""){
			pop_up_box.showMsg("请输入成本单价!");
			return;
		}else{
			$("#addWareInit").hide();
			pop_up_box.postWait(); 
			$.post("../manager/addInitialInventory.do",$("#setForm").serialize(),function(data){
				pop_up_box.loadWaitClose();
				if (data.success){
					pop_up_box.toast("数据保存成功!",2000);
					$(".find").click();
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
	});
	function initpageinp(){
		$("#oh").val("");
		$("#i_price").val("");
		$("#storestructId").val("");
		$("#store_struct_name").html("");
		$("#itemId").val("");
		$("#item_name").html("");
//		$("#corp_id").val("");
//		$("#corp_name").html("");
		$("#deptId").val("");
		$("#dept_name").html("");
		$("#clerkId").val("");
		$("#clerk_name").html("");
		$("#ivtnumdetail").val("");
		$("#item_zeroSell").val("");
	}
	//修改
	$("#editInitialInventory").click(function(){
		var ivt_num_detail=$.trim($(".tabs-content:eq(2)").find(".active_table #ivt_num_detail").val());
		if(ivt_num_detail==""){
			pop_up_box.showMsg("请选中一条需要修改的产品库存信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(2)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能修改,请弃审后再操作!");
			return;
		}
		initpageinp();
		pop_up_box.loadWait();
		$.get("initialMaintenanceInfo.do",{
			"ivt_num_detail":ivt_num_detail
		},function(data){
			pop_up_box.loadWaitClose();
				$("#oh").val(data.oh);
				$("#i_price").val(data.i_price);
				$("#storestructId").val(data.store_struct_id);
				$("#store_struct_name").html(data.store_struct_name);
				$("#itemId").val(data.item_id);
				$("#item_name").html(data.item_sim_name);
//				$("#corp_id").val(data.customer_id);
//				$("#corp_name").html(data.item_name);
				$("#deptId").val(data.dept_id);
				$("#dept_name").html(data.dept_name);
				$("#clerkId").val(data.clerk_id);
				$("#clerk_name").html(data.clerk_name);
				$("#ivtnumdetail").val(data.ivt_num_detail);
				$("#item_zeroSell").val(data.item_zeroSell);
			$("#addWareInit").show();
		});
	});
	//删除
	$("#delInitialInventory").click(function(){
		var ivt_num_detail=$.trim($(".tabs-content:eq(2)").find(".active_table #ivt_num_detail").val());
		if(ivt_num_detail==""){
			pop_up_box.showMsg("请选中一条需要删除的产品库存信息!");
			return;
		}
		var initial_flag=$.trim($(".tabs-content:eq(2)").find(".active_table #initial_flag").val());
		if(initial_flag=="Y"){
			pop_up_box.showMsg("该记录已经审核不能删除,请弃审后再操作!");
			return;
		}
		if (window.confirm("是否删除该条记录?")){
			pop_up_box.postWait();
			$.post("../manager/delClient.do",{"ivt_num_detail":ivt_num_detail,"type":"inventory"},
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
	//库存
	$("#initWareAdd").click(function(){
		$("#addWareInit").show();
		initpageinp();
	});
	$(".qx,.close").click(function(){
		$("#addWareInit").hide();
	});
	//负责部门
	$(".select").click(function(){
			pop_up_box.loadWait();
			$.get("../manager/getDeptTree.do", {
				"type" : "dept"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				dept.init(function(){
					$("#deptId").val($(".treeActive").find("input").val());
					$("#dept_name").html($(".treeActive").text());
				});
			});
	});
	//仓库名称
	$(".store").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "warehouse"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			warehouse.init(function(){
					$("#storestructId").val(treeSelectId);
					$("#store_struct_name").html(treeSelectName);
			});
		});
	});
	//产品名称
	$(".item").click(function(t){
		pop_up_box.loadWait();
		$.get("../tree/productSelect.do",
			function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			product.init(function(){
				var item_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
				var item_name=$(".modal").find("tr.activeTable").find("td:eq(1)").text();
				$("#itemId").val(item_id);
				$("#item_name").html(item_name);
			});
		});
	});	
	//负责人
	$(".clerk").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "employee"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			employee.init(function(){
					$("#clerkId").val(treeSelectId);
					$("#clerk_name").html(treeSelectName);
			});
		});
	});
	//供应商
	$(".gys").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "vendor"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			vendor.init(function(){
					$("#corp_id").val(treeSelectId);
					$("#corp_name").html(treeSelectName);
			});
		});
	});
})
