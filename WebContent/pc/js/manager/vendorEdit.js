var math;
var vendorEdit = {
	init : function() {
		initNumInput();
		var corp_id = $("input[name='corp_id']");
		editUtils.editinit("getGysInfo",corp_id.val());
		var corp_sim_name = $("input[name='corp_sim_name']");
		var corp_name = $("input[name='corp_name']");
		corp_sim_name.change(function() {
			if (corp_name.val() == "") {
				corp_name.val(corp_sim_name.val());
			}
			$("input[name='easy_id']").val(makePy(corp_sim_name.val()));
		});
		if ($("#info").val() == "info") {
			$("input").attr("disabled", "disabled");
			$("select").attr("disabled", "disabled");
			$(".btn-success ").attr("disabled", "disabled");
			$("#savevendor").hide();
		}
		// ////////////////////////
		var user_id = $("input[name='user_id']");
		if (user_id.length > 0) {
			editUtils.checkPhone("vendor");
		}
		var self_id = $("input[name='self_id']");
		self_id.change(function() {
			if ($.trim(self_id.val()) != "") {
				pop_up_box.loadWait();
				$.get("../manager/checkSelfId.do", {
					"self_id" : self_id.val(),
					"type" : "vendor"
				}, function(data) {
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("供应商外码已经存在!", function() {
							self_id.val("");
						});

					}
				});
			}
		});
$(".btn-success").click(function() {
	var n = $(".btn-success").index(this);
	var type = $(this).parents(".form-group").find("label").text();
	if (type == "行政区划") {
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "regionalism"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			regionalism.init(function(treeId, treeName) {
				var treeId = $(".modal").find(".activeT").find(
						"input").val();
				var treeName = $(".modal").find(".activeT")
						.text();
				$("#regionalism_name_cn").html(treeName);
				$("#regionalism_id").val(treeId);
			});
		});
	}
});

$("#savevendor").click(function() {
	if ($.trim(user_id.val()) == "") {
		pop_up_box.showMsg("请输入供应商登录账号!");
	} else if ($.trim(corp_name.val()) == "") {
		pop_up_box.showMsg("请输入供应商名称!");
	} else if ($.trim(corp_sim_name.val()) == "") {
		pop_up_box.showMsg("请输入供应商简称!");
	} else {
		pop_up_box.postWait();
		$.post("../manager/saveGys.do",
		$("#editForm").serialize(),
		function(data) {
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.toast("保存成功", 1000);
				var type = 1;
				var cid = corp_id.val();
				if (cid == "") {
					cid = data.msg;
					type = 0;
				}
				corp_id.val(cid);
				editUtils.tableShowSyn(type,getbtn(),function(tr,j,name) {
					if (name == "regionalism_name_cn") {
						tr.find("td:eq("+ j+ ")").html($("#editForm #regionalism_name_cn").html());
					}else if(name=="corp_sim_name"){
						var val=$("#editForm *[name='"+name+"']").val(); 
						tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
					}
				});
			} else {
				pop_up_box.showMsg("保存失败,错误:"+ data.msg);
			}
		});
	}
});
		// /////////////回显图片////////////
		if ($.trim(corp_id.val()) != "") {
			$.get("../saiyu/getevalimg.do", {
				"customer_id" : corp_id.val()
			}, function(data) {
				if (data && data.length > 0) {
					$.each(data, function(i, n) {
						var customerId = $.trim(corp_id.val());
						if (customerId != "") {
							var com_id = $.trim($("#com_id").val());
							$("#"+n.split(".")[0]).attr("src","../" + com_id 
									+ "/evalimg/"+ customerId + "/" + n+ "?ver=" + Math.random());
						}
					});
				}
			});
		}
	}
}
function imgCLientUpload(t, key, img) {
	pop_up_box.postWait();
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=" + key
				+ "&type=userpic" + math + "&imgName=" + img,
		"msgId" : "msg",
		"fileId" : key,
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 50
	}, t, function(imgurl) {
		pop_up_box.loadWaitClose();
		$("#" + img).attr("src", "../" + imgurl + "?ver=" + Math.random());
	});
}