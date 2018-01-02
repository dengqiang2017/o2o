$(function() {
	var clerk_name = $("#clerk_name");
	clerk_name.change(function() {
		$("#easy_id").val(makePy(clerk_name.val()));
	});
	$(".btn-success").click(function() {
		var n = $(".btn-success").index(this);
		var type = "dept";
		if (n == 1) {
			type = "regionalism";
		}
		pop_up_box.loadWait();
		if (n==2) {
			$.get("getDeptTree.do", {
				"type" : "cls"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				procls.init(function(){
					multiselectInfo("type_id", "type_name", "类型");
//					var type_id=$("#type_id").val();
//					var type_name=$("#type_name").html();
//					var typeids=type_id.split(",");
//					var b=true;
//					for (var i = 0; i < typeids.length; i++) {
//						var typeid=typeids[i];
//						if (treeSelectId.indexOf(typeid)>0) {
//							b=false;
//							break;
//						}
//					}
//					if (type_id.indexOf(treeSelectId)<0) {
//						if (b) {
//							if (type_id=="") {
//								$("#type_id").val(treeSelectId);
//								$("#type_name").html(treeSelectName);
//							}else{
//								$("#type_id").val(type_id+","+treeSelectId);
//								$("#type_name").html(type_name+","+treeSelectName);
//							}
//						}else{
//							pop_up_box.showMsg("该类型已选择所属上级类型,不用再重复选择!");
//						}
//					}else{
//						pop_up_box.showMsg("该类型已选择!");
//					}
				});
			});
		}else if (n==3) {
			$.get("getDeptTree.do", {
				"type" : "client"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				client.init(function(){
					multiselectInfo("customer_id", "customer_name", "客户");
//					var customer_id=$("#customer_id").val();
//					var customer_name=$("#customer_name").html();
//					var typeids=customer_id.split(",");
//					var b=true;
//					for (var i = 0; i < typeids.length; i++) {
//						var typeid=typeids[i];
//						if (treeSelectId.indexOf(typeid)>0) {
//							b=false;
//							break;
//						}
//					}
//					if (customer_id.indexOf(treeSelectId)<0) {
//						if (b) {
//							if (customer_id=="") {
//								$("#customer_id").val(treeSelectId);
//								$("#customer_name").html(treeSelectName);
//							}else{
//								$("#customer_id").val(customer_id+","+treeSelectId);
//								$("#customer_name").html(customer_name+","+treeSelectName);
//							}
//						}else{
//							pop_up_box.showMsg("该客户已选择所属上级客户,不用再重复选择!");
//						}
//					}else{
//						pop_up_box.showMsg("该客户已选择!");
//					}
				});
			});
		}else if (n==4) {
			$.get("getDeptTree.do", {
				"type" : type
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				dept.init(function(){
					multiselectInfo("dept_idInfo", "dept_idInfoName", "部门");
//					var dept_idInfo=$("#dept_idInfo").val();
//					var dept_idInfoName=$("#dept_idInfoName").html();
//					var typeids=dept_idInfo.split(",");
//					var b=true;
//					for (var i = 0; i < typeids.length; i++) {
//						var typeid=typeids[i];
//						if (treeSelectId.indexOf(typeid)>0) {
//							b=false;
//							break;
//						}
//					}
//					if (dept_idInfo.indexOf(treeSelectId)<0) {
//						if (b) {
//							if (dept_idInfo=="") {
//								$("#dept_idInfo").val(treeSelectId);
//								$("#dept_idInfoName").html(treeSelectName);
//							}else{
//								$("#dept_idInfo").val(dept_idInfo+","+treeSelectId);
//								$("#dept_idInfoName").html(dept_idInfoName+","+treeSelectName);
//							}
//						}else{
//							pop_up_box.showMsg("该部门已选择所属上级部门,不用再重复选择!");
//						}
//					}else{
//						pop_up_box.showMsg("该部门已选择!");
//					}
				});
			});
		}else if (n==5) {//store_struct_id_Info查看库房信息来源
			$.get("getDeptTree.do", {
				"type" : "warehouse"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				warehouse.init(function(){
					multiselectInfo("store_struct_id_Info", "store_struct_id_InfoName", "库房");
//					var store_struct_id_Info=$("#store_struct_id_Info").val();
//					var store_struct_id_InfoName=$("#store_struct_id_InfoName").html();
//					var typeids=store_struct_id_Info.split(",");
//					var b=true;
//					for (var i = 0; i < typeids.length; i++) {
//						var typeid=typeids[i];
//						if (treeSelectId.indexOf(typeid)>0) {
//							b=false;
//							break;
//						}
//					}
//					if (store_struct_id_Info.indexOf(treeSelectId)<0) {
//						if (b) {
//							if (store_struct_id_Info=="") {
//								$("#store_struct_id_Info").val(treeSelectId);
//								$("#store_struct_id_InfoName").html(treeSelectName);
//							}else{
//								$("#store_struct_id_Info").val(store_struct_id_Info+","+treeSelectId);
//								$("#store_struct_id_InfoName").html(store_struct_id_InfoName+","+treeSelectName);
//							}
//						}else{
//							pop_up_box.showMsg("该库房已选择所属上级库房,不用再重复选择!");
//						}
//					}else{
//						pop_up_box.showMsg("该库房已选择!");
//					}
				});
			});
		}else{
			$.get("getDeptTree.do", {
				"type" : type
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				dept.init();
			});
		}
	});
	//多选信息
	function multiselectInfo(id,name,msg){
		var store_struct_id_Info=$("#"+id).val();
		var store_struct_id_InfoName=$("#"+name).html();
		var typeids=store_struct_id_Info.split(",");
		var b=true;
		for (var i = 0; i < typeids.length; i++) {
			var typeid=typeids[i];
			if (treeSelectId.indexOf(typeid)>0) {
				b=false;
				break;
			}
		}
		if (store_struct_id_Info.indexOf(treeSelectId)<0) {
			if (b) {
				if (store_struct_id_Info=="") {
					$("#"+id).val(treeSelectId);
					$("#"+name).html(treeSelectName);
				}else{
					$("#"+id).val(store_struct_id_Info+","+treeSelectId);
					$("#"+name).html(store_struct_id_InfoName+","+treeSelectName);
				}
			}else{
				pop_up_box.showMsg("该"+msg+"已选择所属上级"+msg+",不用再重复选择!");
			}
		}else{
			pop_up_box.showMsg("该"+msg+"已选择!");
		}
	}
	$("#userId").change(function() {
		if ($.trim($("#userId").val()) == "") {
			return;
		}
		pop_up_box.loadWait();
		$.get("checkPhone.do", {
			"phone" : $("#userId").val(),
			"type" : 1
		}, function(data) {
			pop_up_box.loadWaitClose();
			if (!data.success) {
				pop_up_box.showMsg("手机号已经存在!", function() {
					$("#userId").val("");
				});

			}
		});
	});
	$(".btn-info").click(
			function() {
				var inputs = $("input[type='text']");
				var msg = $("#msg");
				var run = true;
				if ($.trim($("#userId").val())=="") {
					pop_up_box.showMsg("请输入登录账号!");
				}else if ($.trim($("#clerk_name").val()) == "") {
					pop_up_box.showMsg("请输入员工名称!");
				}else if ($.trim($("#self_id").val()) == "") {
					pop_up_box.showMsg("请输入员工编码!");
				}else if ($.trim($("#user_id").val()) == "") {
					pop_up_box.showMsg("请输入员工登录密码!");
				}else if ($.trim($("#deptId").val()) == "") {
					pop_up_box.showMsg("请选择所属部门!");
				} else {
					pop_up_box.postWait();
					$.post("../manager/savePersonnel.do", $("#proForm")
							.serialize(), function(data) {
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("保存成功!", function() {
								$("#proForm>input").val("");
								window.location.href = "personnel.do";
							});
						} else {
							pop_up_box.showMsg("数据存储异常,错误代码:" + data.msg);
						}
					});
				}
			});
});

function imgUpload(t) {
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=imgFile&type=cp",
		"msgId" : "msg",
		"fileId" : "imgFile",
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 0.5
	}, t, function(imgurl) {
		$("#filePath").val(imgUrl);
		$(".upload-img").find("img").attr("src",
				"../" + imgurl + "?ver=" + Math.random());
	});
}