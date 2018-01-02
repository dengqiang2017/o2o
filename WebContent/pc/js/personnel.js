personnel={
		init:function(clerk_id){
			if (!clerk_id) {
				clerk_id="";
				$("#qxcopy").remove();
			}
			getHeadship();
			/////将保存按钮放入到
			var r="<div class='btn-gp'><button class='btn btn-info saveinfo'>保存</button><a class='btn btn-primary closeinfo'>返回</a></div>";
			$(".footer>div:eq(0)").html(r);
			$(".footer>div:eq(0)").show();
			//////////////////
			var clerk_id=$("#editpage").find("input[name='clerk_id']");
			editUtils.editinit("getPersonnelInfo", clerk_id.val());
			var clerk_name =$("#editpage").find("input[name='clerk_name']"); 
			clerk_name.change(function() {
				$("#editpage").find("input[name='easy_id']").val(makePy($.trim(clerk_name.val())));
			});
			$(".btn-default").click(function(){
				$(this).parent().parent().find(".form-control").html("");
				$(this).parent().parent().find("input[type='hidden']").val("");
			});
			$(".btn-success").click(function() {
				 var type=$(this).parents(".form-group").find("label").text();
				 if(type.indexOf("所属部门")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
							"type" : "dept"
						}, function(data) {
							pop_up_box.loadWaitClose();
							$("body").append(data);
							o2otree.selectType=0;
							dept.init();
							treeSelectId="";
							treeSelectName="";
						});
				 }else if(type.indexOf("产品类别")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
							"type" : "cls"
						}, function(data) {
							pop_up_box.loadWaitClose();
							$("body").append(data);
							o2otree.selectType=1;
							procls.init(function(){
								multiselectInfo("type_id", "type_name", "类型");
								treeSelectId="";
								treeSelectName="";
							});
						});
				 }else if(type.indexOf("客户")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
							"type" : "client"
						}, function(data) {
							pop_up_box.loadWaitClose();
							$("body").append(data);
							o2otree.selectType=1;
							client.init(function(){
								 multiselectInfo("customer_id", "customer_name", "客户");
								 treeSelectId="";
								treeSelectName="";
								 
							});
							$(".tree").find("span:contains('我公司')").click();
						});
				 }else if(type.indexOf("部门来源")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
							"type" : "dept"
						}, function(data) {
							pop_up_box.loadWaitClose();
							$("body").append(data);
							o2otree.selectType=1;
							dept.init(function(){
								multiselectInfo("dept_idInfo", "dept_idInfoName", "部门");
								treeSelectId="";
								treeSelectName="";
							});
						});
				 }else if(type.indexOf("库房来源")>=0||type.indexOf("仓库")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
							"type" : "warehouse"
						}, function(data) {
							pop_up_box.loadWaitClose();
							$("body").append(data);
							o2otree.selectType=1;
							warehouse.init(function(){
								multiselectInfo("store_struct_id_Info", "store_struct_id_InfoName", "库房");
								treeSelectId="";
								treeSelectName="";
							});
						});
				 }else if(type.indexOf("所属工序")>=0){
					 if($("#modal_workProcess").length>0){
							$("#modal_workProcess").show();
							pop_up_box.loadWaitClose();
						}else{
							pop_up_box.loadWait();
							$.get("../pm/getWorkProcessTree.do",{
								"work_type":$.trim($("#work_type").html()),
								"ver":Math.random()
							},function(data){
								pop_up_box.loadWaitClose();
								$("body").append(data);
								o2otree.selectType=1;
								workProcessTree.init(function(work_id,work_name){
									$("#work_name").html(work_name);
									$("#work_id").val(work_id);
									treeSelectId="";
									treeSelectName="";
								});
							});
						}
				 }else if(type.indexOf("区划")>=0){
					 pop_up_box.loadWait();
					 $.get("../manager/getDeptTree.do", {
						 "type" : "regionalism"
					 }, function(data) {
						 pop_up_box.loadWaitClose();
						 $("body").append(data);
						 regionalism.init(function(treeId,treeName){
							 var treeId=$(".modal").find(".activeT").find("input").val();
							 var treeName=$(".modal").find(".activeT").text();
							 $("#regionalism_name_cn").html(treeName);
							 $("#regionalismId").val(treeId);
							 treeSelectId="";
								treeSelectName="";
						 });
					 });
				 }
			});
			//多选信息
			function multiselectInfo(id,name){
				var ids=$(".modal-body .treeActive");
				if(ids&&ids.length>0){
					for (var i = 0; i < ids.length; i++) {
						var idval=$(ids[i]).find("input").val();
						var nameval=$(ids[i]).text();
						if(idval!=""&&nameval!=""){
							if ($("#"+id).val().indexOf(idval)<0) {
								if ($("#"+id).val()=="") {
									$("#"+id).val(idval);
									$("#"+name).html(nameval);
								}else{
									$("#"+id).val($("#"+id).val()+","+idval);
									$("#"+name).html($("#"+name).html()+","+nameval);
								}
							}
						}
					}
				}else{
					ids=$(".modal-body .activeTable");
					if(ids&&ids.length>0){
						for (var i = 0; i < ids.length; i++) {
							var idval=$(ids[i]).find("input").val();
							var nameval=$(ids[i]).find("td:eq(0)").text();
							if(idval!=""&&nameval!=""){
								if ($("#"+id).val().indexOf(idval)<0) {
									if ($("#"+id).val()=="") {
										$("#"+id).val(idval);
										$("#"+name).html(nameval);
									}else{
										$("#"+id).val($("#"+id).val()+","+idval);
										$("#"+name).html($("#"+name).html()+","+nameval);
									}
								}
							}
						}
					}
				}
			}
			editUtils.checkPhone(1);
			$(".saveinfo:eq(0)").unbind("click");
			$(".saveinfo:eq(0)").click(function() {
						var run = true;
						var user_id= $("#editpage input[name='user_id']");
						if ($.trim(user_id.val())=="") {
							pop_up_box.showMsg("请输入登录账号!");
						}else if ($.trim(clerk_name.val()) == "") {
							pop_up_box.showMsg("请输入员工名称!");
						}else {
							pop_up_box.postWait();
							$.post("../manager/savePersonnel.do", $("#editForm")
									.serialize(), function(data) {
								pop_up_box.loadWaitClose();
								if (data.success) {
									pop_up_box.showMsg("保存成功!", function() {
										if(window.location.href.indexOf("userinfo")>0){
											window.location.href="../employee.do";
											return;
										}
										var type = 1;
										var cid = clerk_id.val();
										if (cid == "") {
											cid = data.msg;
											type = 0;
										}
										clerk_id.val(cid);
										editUtils.tableShowSyn(type,getbtn(cid),function(tr,j,name) {
											var val=$("#editForm *[name='"+name+"']").val(); 
										   if(name=="clerk_name"){
												tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
											}else if(name=="working_status"){
												var wst="离职";
												if (val==1||val=="Y") {
													wst="在职";
												}
												tr.find("td:eq("+j+")").html(wst);
											}else if(name=="mySelf_Info"){
												tr.find("td:eq("+j+")>a").html(val);
											}else if(name=="dept_name"){
												tr.find("td:eq("+j+")").html($("#editForm #dept_name").html());
											}else if(name=="regionalism_name_cn"){
//												tr.find("td:eq("+j+")>a").html($("#editForm #regionalism_name_cn").html());
												tr.find("td:eq("+j+")>a").html(val);
											}else if(name=="quanxian"){
												if(type==0){
													tr.find("td:eq("+j+")").html(getQuanxinBtn(0));
												}
											}else if(name=="clerk_id"){
												tr.find("td:eq("+j+")").html(cid);
											}else if(name=="self_id"){
												tr.find("td:eq("+j+")").html(cid);
											}else if(name=="class"){
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.showClass(this);'>查看</a>");
											}else if(name=="client"){
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.showClient(this);'>查看</a>");
											}else if(name=="dept"){
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.showDept(this);'>查看</a>");
											}else if(name=="warehouse"){
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.showWarehouse(this);'>查看</a>");
											}else if(name=="regionalism_name_cn"){
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.regionalism(this);'>"+ifnull(n[name])+"</a>");
											}else if(name=="mySelf_Info"){
												var info="否";
												if(n[name]&&ifnull(n[name])!="否"){
													info="是";
												}
												tr.find("td:eq("+j+")").html("<a onclick='employeelist.mySelf_Info(this);'>"+info+"</a>");
											}
										});
										
										$(".footer>div:eq(0)").html("");
									});
								} else {
									pop_up_box.showMsg("数据存储异常,错误代码:" + data.msg);
								}
							});
						}
					});
			$("#personnelEdit_a,.closeinfo").click(function(){
				editUtils.closePage();
				$(".footer>div:eq(0)").html("");
			});
			$("#qxfp").click(function(){///权限分配
				$.get("../manager/authority.do",{
					"clerk_id":clerk_id
				},function(data){
					$("#cop").before(data);
					$("#editpage").hide();
					authority.init();
				});
			});
 			/////////////////////
			$("#liuzhiwu").click(function(){
				$("#modal_smsSelect").show();
				var headship=$(this).parent().parent().find("#headship").val();
				for (var i = 0; i < $("#modal_smsSelect .modal_ul>li").length; i++) {
					var item=$($("#modal_smsSelect .modal_ul>li")[i]);
					if(headship.indexOf(item.find("span").html())>=0){
						item.find("div").addClass("pro-checked");
					}
				}
			});
			$("#zhiwuSelect").click(function(){
				var zhiwus=$("#modal_smsSelect").find("ul").find(".pro-checked");
				if(zhiwus&&zhiwus.length>0){
					var zhiwu="";
					for (var i = 0; i < zhiwus.length; i++) {
	  					var item=$(zhiwus[i]).parent();
						zhiwu=zhiwu+$.trim(item.find("span").text());
					}
					$("#headship").val(zhiwu);
					$("#modal_smsSelect").hide();
				}else {
					pop_up_box.showMsg("请至少选择一个职务!");
				}
			});
			$("#modal_smsSelect").find(".pro-check").unbind("click");
			$("#modal_smsSelect").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
			$("#modal_smsSelect").find("#allchecked").unbind("click");
			$("#modal_smsSelect").find("#allchecked").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$("#modal_smsSelect").find(".pro-check").removeClass("pro-checked");
				}else{
					$("#modal_smsSelect").find(".pro-check").addClass("pro-checked");
				}
			});
			$("#zhiwuClose,.close").click(function(){
				$("#modal_smsSelect").hide();
			});
			/////////////////////////////////////////
			$("#orderselect").click(function(){
				$("#modal_orderSelect").show();
			});
			$("#orderSelect").click(function(){
				var orders=$("#modal_orderSelect").find("ul").find(".pro-checked");
				if(orders&&orders.length>0){
					var order="";
					for (var i = 0; i < orders.length; i++) {
						var item=$(orders[i]).parent();
						order=order+$.trim(item.find("span").text());
						order=order+"-"+item.find("input[name='chuli']:checked").val()+",";
					}
					$("#orderStepRecipient").val(order);
					$("#modal_orderSelect").hide();
				}else {
					pop_up_box.showMsg("请至少选择一个职务!");
				}
			});
			$("#modal_orderSelect").find(".pro-check").unbind("click");
			$("#modal_orderSelect").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
			$("#modal_orderSelect").find("#allchecked").unbind("click");
			$("#modal_orderSelect").find("#allchecked").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$("#modal_orderSelect").find(".pro-check").removeClass("pro-checked");
				}else{
					$("#modal_orderSelect").find(".pro-check").addClass("pro-checked");
				}
			});
			$("#orderClose,.close").click(function(){
				$("#modal_orderSelect").hide();
			});
			////////////////////////////////////
		}
}

function imgUpload(t) {
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=imgFile&type=cp",
		"msgId" : "msg",
		"fileId" : "imgFile",
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 0.5
	}, t, function(imgurl) {
		$("#filePath").val(imgurl);
		$(".upload-img").find("img").attr("src",
				"../" + imgurl + "?ver=" + Math.random());
	});
}