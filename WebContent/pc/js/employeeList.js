$.ajaxSetup({  
	async : false  
});
employeelist={
		authority:function(t){
			var clerk_id=$(t).parents("tr").find("input").val();
			var clerkName=$(t).parents("tr").find("td:eq(0)").text();
			$.get("authority.do",{
				"clerk_id":clerk_id,
				"type":"list"
			},function(data){
				$("#cop").before(data);
				$("#listpage").hide();
				authority.init(clerk_id,clerkName);
			});
		},
		authorityCopy:function(t){
			var clerk_id=$(t).parents("tr").find("input").val();
			var clerkName=$(t).parents("tr").find("td:eq(0)").html();
			$.get("getDeptTree.do",{
				"type":"personnel"
			},function(data){
				$("body").append(data);
				$(".modal-title").html("您复制了【"+clerkName+"】的权限，复制给谁，请选择：");
				employee.init(function(){
					var auths=$(".modal").find("tbody").find(".checkedbox");
					
					if (auths&&auths.length>0) {
						for (var i = 0; i < auths.length; i++) {
							var auth=auths[i];
							var selectId=$(auth).parents("tr").find("input").val();
							$.get("authorityCopy.do",{
								"treeSelectId":selectId,
								"clerk_id":clerk_id
								},function(data){
								if (data.success) {
									//pop_up_box.showMsg("复制成功!");
								}else{
									if (data.msg) {
										pop_up_box.showMsg("复制失败,"+data.msg);
									}else{
										pop_up_box.showMsg("复制失败,请联系管理员!");
									}
								}
							});
						}
						pop_up_box.showMsg("复制成功!");
					}else{
						pop_up_box.showMsg("请至少选择一个目标员工!");
					}
				});
			});
		},
		editload:function(t){
			var clerk_id=$(t).parents("tr").find("input").val();
			pop_up_box.loadWait();
			$.get("personnelEdit.do?clerk_id="+clerk_id,function(data){
				$("#listpage").hide();
				$("#editpage").append(data);
				personnel.init(clerk_id);
				pop_up_box.loadWaitClose();
			});
		},
		delClerk:function(t){
			if (window.confirm("是否要删除该记录?")) {
				var clerk_id=$(t).parents("tr").find("input").val();
				pop_up_box.postWait();
				$.post("delClient.do",{"treeId":clerk_id,"type":"employee"},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						$(t).parents("tr").remove(); 
					}else{
						pop_up_box.showMsg(data.msg);
					}
				});
			}
		},
		showInfo:function(type,typename,t){
			pop_up_box.loadWait(); 
			var clerk_id=$(t).parents("tr").find("input").val();
			$.get("getEmployeeInfo.do",{
				"clerk_id":clerk_id,
				"type":type
			},function(data){
				pop_up_box.loadWaitClose(); 
				if (data) {
					$("body").append(data);
					$(".modal-title").html(typename);
				}
			});
		},
		showClass:function(t){
			employeelist.showInfo("cls","可使用的产品类别",t);
		},
		showClient:function(t){
			employeelist.showInfo("client","可做的客户",t);
		},
		showDept:function(t){
			employeelist.showInfo("dept","可查看的部门",t);
		},
		showWarehouse:function(t){
			employeelist.showInfo("warehouse","可查看的库房",t);
		},
		mySelf_Info:function(t){
			pop_up_box.loadWait(); 
			var clerk_id=$(t).parents("tr").find("input").val();
			$.get("getEmployeeInfo.do",{
				"clerk_id":clerk_id,
				"type":"mySelf_Info"
			},function(data){
				pop_up_box.loadWaitClose(); 
				if (data) {
					$("body").append(data);
//					$(".modal-title").html("是否只看自己?");
					modal_first.mySelf_Info(clerk_id,$(t).html());
				}
			});
		},
		regionalism:function(t){
			pop_up_box.loadWait();
			var clerk_id=$(t).parents("tr").find("input").val();
			$.get("getDeptTree.do", {
				"type" : "regionalism"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				regionalism.init(function(treeId,treeName){
					$.get("updateInfo.do",{
						"regionalism_id":treeId,
						"clerk_id":clerk_id
					},function(data){
						if(data.success){
						$("#listpage tbody").find("td:contains('"+clerk_id+"')").parents("tr").find("td:eq(9)>a").html(treeName);
						$(".modal-cover,.modal").remove();
						pop_up_box.showMsg("提交成功!");
						}else{
						pop_up_box.showMsg("提交失败!");
						}
					})
				});
			});
		}
}
 
$(function(){
	///////////////////响应树形相关/////////////
	var clerk_id=getQueryString("clerk_id");
	if(clerk_id){
		pop_up_box.loadWait();
		$.get("personnelEdit.do?clerk_id="+clerk_id,function(data){
			$("#listpage").hide();
			$("#editpage").append(data);
			personnel.init(clerk_id);
			pop_up_box.loadWaitClose();
		});
		loadData("",clerk_id);
	}
	var count=0;
	$("#rows").change(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	function loadData(dept_id,clerk_id){
		$("#page").val(editUtils.page+1);
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();  
		$.get("getPersonnels.do",{
			"searchKey":searchKey,
			"page":editUtils.page,
			"count":count,
			"rows":$("#rows").val(),
			"clerk_id":clerk_id,
			"dept_id":dept_id
		},function(data){
			pop_up_box.loadWaitClose();
			$("#listpage tbody").html("");
			$.each(data.rows,function(i,n){
				var len=$("#listpage th").length;
				var tr=getTr(len);
				$("#listpage tbody").append(tr);
				for (var i = 0; i < len; i++) {
					var th=$($("#listpage th")[i]);
					var name=th.attr("data-name");
					var show=th.css("display");
					var j=$("#listpage th").index(th);
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
					}else{
						if(j>=0){
							if(name=="clerk_name"){
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.clerk_id)+"'>"+n[name]);
							}else if(name=="weixinStatus"){
								var o2o="";
								if(ifnull(n.weixinStatus)=="1"){
									o2o="已关注";
								}else if (ifnull(n.weixinStatus)=="2") {
									o2o="已冻结";
								}else if($.trim(n.weixinID)!=""){
									o2o="未关注";
								}else{
									o2o="无微信账号";
								}
								tr.find("td:eq("+j+")").html(o2o);
							}else if(name=="working_status"){
								var wst="离职";
								if (n.working_status==1||n.working_status=="Y") {
									wst="在职";
								}
								tr.find("td:eq("+j+")").html(wst);
							}else if(name=="mySelf_Info"){
								var info="否";
								if(n[name]&&ifnull(n[name])!="否"){
									info="是";
								}
								tr.find("td:eq("+j+")").html("<a onclick='employeelist.mySelf_Info(this);'>"+info+"</a>");
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
							}else if(name=="caozuo"){
								tr.find("td:eq("+j+")").html(getbtn(n.clerk_id,n.clerk_name));
							}else if(name=="quanxian"){
								tr.find("td:eq("+j+")").html(getQuanxinBtn(n.authority));
							}else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
					}
				}
			});
			$("#totalPage").html(data.totalPage+1);
			$("#totalRecord").html(data.totalRecord);
			editUtils.totalPage=data.totalPage;
			count=data.totalRecord;
			selectTr();
			$("#totalPage").html(data.totalPage+1);
			$(".pull-left .form-control").val(data.totalRecord);
		});
	}
	var leftcover=$(".left-hide-ctn,.cover");
	$("#treeAll").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	try {
		o2o.next_tree("dept",function(n){
			return treeli(n.dept_name,n.sort_id);
		},undefined,function(treeId){
			editUtils.page=0;
			count=0;
			loadData(treeId);
		});
		$("#treeAll").click();
	} catch (e) {}
////////////////////////////////
	$(".excel").click(function(){//导出Excel
		var searchKey=$("#searchKey").val(); 
		pop_up_box.loadWait();
		$.get("../maintenance/employeeExport.do",{
			"searchKey":searchKey, 
			"ver":Math.random() 
		},function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
	$("#find").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
//	$("#find").click();
////////////////////////////////
	editUtils.paging(function(){
		loadData();
	});
	//////////
	$("#addpersonnel").click(function(){///增加员工
		pop_up_box.loadWait();
		$.get("personnelEdit.do",function(data){
			$("#listpage").hide();
			$("#editpage").append(data);
			personnel.init();
			pop_up_box.loadWaitClose();
		});
	});
});

var excelemployee=0;
function excelimport(t,typeName) {
	if (!typeName) {
		typeName="";
	}
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=xls"+typeName,
		"msgId" : "msg",
		"fileId" : "xls"+typeName,
		"msg" : "",
		"fid" : "",
		"uploadFileSize" : 10000
	}, t, function(imgurl) {
		setTimeout(function() {
			pop_up_box.dataHandling("导入数据后台处理中.....");
			$.get("../maintenance/employeeImport.do", {
				url : imgurl,
				"typeName":typeName
			}, function(data) {
				pop_up_box.loadWaitClose();
				clearInterval(excelemployee);
				if (data.success) {
					var msg = data.msg;
					if (!msg) {
						msg = "";
					}
					pop_up_box.showMsg("数据导入成功!" + msg, function() {
						$.get("../product/excelOrderMsg.do", {
							"key" : "excelordermsg"
						}, function(data) {
							if (data.success && data.msg) {
								if (data.msg) {
									pop_up_box.showMsg("有导入数据不全信息!", function() {
										window.open(data.msg);
									});
								}
							}
						});
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("数据导入失败,错误:" + data.msg);
					} else {
						pop_up_box.showMsg("数据导入失败,请联系管理员!");
					}
					clearInterval(excelemployee);
				}
			});
			excelemployee = setInterval(function() {
				$.get("../product/excelOrderMsg.do", {
					"key" : "exceprogress"
				}, function(data) {
					if (data.success && data.msg) {
						pop_up_box.loadWaitClose();
						pop_up_box.dataHandling("导入数据后台处理中," + data.msg);
					}else{
						clearInterval(excelemployee);
					}
				});
			}, 500);
		}, 1000);

	});
}
function getbtn(clerk_id,clerk_name){
	var btn="";
	if($("#edit_hi").val()=="true"&&"客户审批员"!=ifnull(clerk_name)){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='employeelist.editload(this);'>修改</button>";
	}
	if($("#del_hi").val()=="true"&&"客户审批员"!=ifnull(clerk_name)){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='employeelist.delClerk(this);'>删除</button>";
	}
	return btn;
}
/**
 * 获取权限按钮
 * @param authority
 * @returns 权限按钮html
 */
function getQuanxinBtn(authority){
	if(!authority){
		authority=0;
	}
	var btn="";
	if ($("#qxfp_hi").val()=="true") {
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='employeelist.authority(this);'>分配("+authority+"项)</button>";
	}
	if ($("#qxcopy_hi").val()=="true") {
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='employeelist.authorityCopy(this);'>复制</button>";
	}
	return btn;
}