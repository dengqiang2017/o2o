$(function(){
	//供应商
	$(".corp").click(function(){
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
	//结算方式
	$(".settlement").click(function(){
		$.get("../manager/getDeptTree.do", {
			"type" : "settlement"
		}, function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			settlement.init(function(){
					$("#settlementId").val(treeSelectId);
					$("#settlement_name").html(treeSelectName);
			});
		});
	});
	//经办人
	$(".clerk").click(function(){
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
	//经办部门
	$(".dept").click(function(){
			$.get("../manager/getDeptTree.do", {
				"type" : "dept"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				dept.init(function(){
						$("#deptId").val(treeSelectId);
						$("#dept_name").html(treeSelectName);
						
				});
			});
	});
	//产品名称
	$(".item").click(function(t){
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
	//入货仓库
	$(".store").click(function(){
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
	//保存
	$("#selectClient").click(function(){
		if ($("#storageForm").find("input").val()==""){
			pop_up_box.showMsg("请将相应信息填完完善!");
		}else{
			$("#storageForm").hide();
			pop_up_box.postWait(); 
			$.post("../manager/addPurchasingCheck.do",$("#storageForm").serialize(),function(data){
				pop_up_box.loadWaitClose();
				if (data.success){
					pop_up_box.showMsg("数据保存成功返回列表页面",function(){
						$("form>input").val("");
						window.location.href="purchasingCheck.do"
					});
				}else{
					pop_up_box.showMsg("数据保存失败,错误:"+data.msg);
				}
			});
		}
	});
})