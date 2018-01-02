var math;
var driver={
		init:function(){
			var customer_id=$("#editpage").find("#customerId");
			editUtils.editinit("getDriverInfo", customer_id.val());
			var clientdrive="";
			function clientDriveShow(){///参数类型 driveId|list(edit)&客户名称|电话
				var param=window.location.href.split("?")[1];
				if(param){
					var params=param.split("&");
					if(params.length>1){
						var clientInfos=params[1].split("_");
						var info=params[0];
						var infos=info.split("_");
						info=infos[1];//标识是从客户列表或者客户详细进入
						clientdrive=clientInfos[2];
						$(".header").hide();
						$(".header:eq(1)").show();
						$(".box-head").show();
						$(".box-head:eq(0)").find("h4:eq(0)").html("客户名称:"+decodeURI(clientInfos[0]));
						$(".box-head:eq(0)").find("h4:eq(1)>a").attr("href","tel:"+clientInfos[1]);
						$(".box-head:eq(0)").find("h4:eq(1)>a").html(clientInfos[1]);
						if(info!="edit"){
							$(".breadcrumb:eq(1)>li:eq(2)").hide();
						}else{
							$(".breadcrumb:eq(1)>li:eq(2)").show();
						}
					}
				}
			}
			clientDriveShow();
		var corp_sim_name=$("#editForm input[name='corp_sim_name']");
		var corp_name=$("#editForm input[name='corp_name']");
		corp_sim_name.change(function(){
			if (corp_name.val()=="") {
				corp_name.val($(this).val());
		}
			$("#editForm input[name='easy_id']").val(makePy($(this).val()));
		});
		  if($("#info").val()=="info"){
		  	$("input").attr("disabled","disabled");
		  	$("select").attr("disabled","disabled");
		  	$(".btn-success ").attr("disabled","disabled");
		  	$("#savedriver").hide();
		  }
		  //////////////////////////
		  var user_id= $("#editForm input[name='user_id']");
			if (user_id.length > 0) {
				editUtils.checkPhone("driver");
			}
			$("#editForm input[name='self_id']").change(function(){
		  	if ($.trim($(this).val())=="") {
		  		return;
		  	}
		  	pop_up_box.loadWait();
		  	$.get("checkSelfId.do",{"self_id":$(this).val(),"type":"driver"},function(data){
		  		pop_up_box.loadWaitClose();
		  		if (data.success) {
		  			pop_up_box.showMsg("司机外码已经存在!",function(){
		  				$("input[name='self_id']").val("");
		  			});
		  		}
		  	});
		  });
		  
		  $(".btn-success").click(function(){
			  var n = $(".btn-success").index(this);
			  var type=$(this).parents(".form-group").find("label").text();
			  if(type.indexOf("区划")>=0){
				  pop_up_box.loadWait(); 
				  $.get("getDeptTree.do",{"type":"regionalism","ver":Math.random()},function(data){
					  pop_up_box.loadWaitClose();
					  $("body").append(data);
					  regionalism.init(function(treeId,treeName){
						  var treeId=$(".modal").find(".activeT").find("input").val();
						  var treeName=$(".modal").find(".activeT").text();
						  $("#regionalism_name_cn").html(treeName);
						  $("#regionalismId").val(treeId);
					  });
				  });
			  }
		  });
		  $("#savedriver").click(function(){
			   if ($.trim(user_id.val())=="") {
				pop_up_box.showMsg("请输入司机登录账号!");
			   }else if($.trim($("#editForm input[name='user_password']").val())==""){
				   pop_up_box.showMsg("请输入司机登录密码!");
			   }else if($.trim(corp_name.val())==""){
				   pop_up_box.showMsg("请输入司机名称!");
			   }else if($.trim(corp_sim_name.val())==""){
				   pop_up_box.showMsg("请输入司机简称!");
			   }else{
				   pop_up_box.postWait();  
				   $("#editForm").append("<input name='clientdrive' value='"+clientdrive+"' >");
				   $.post("../saiyu/saveDriver.do",$("#editForm").serialize(),function(data){
					   pop_up_box.loadWaitClose();
					   if (data.success) {
						   pop_up_box.toast("保存成功", 1000);
						   var type = 1;
							var cid = customer_id.val();
							if (cid == "") {
								cid = data.msg;
								type = 0;
							}
							customer_id.val(cid);
							editUtils.tableShowSyn(type,getbtn(),function(tr,j,name) {
								if(name=="corp_sim_name"){
									var val=$("#editForm *[name='"+name+"']").val(); 
									tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
								}
							});
					}else{
						pop_up_box.showMsg("保存失败,错误:"+data.msg);
					}
				   });
			   }
		  });
		///////////////回显图片////////////
		  $.get("../saiyu/getevalimg.do",{
			  "customer_id":customer_id.val()
		  },function(data){
			 if(data&&data.length>0){
				 var com_id=$.trim($("#editForm #com_id").val());
				 var customerId=$.trim($("#editForm #customerId").val());
				 $.each(data,function(i,n){
					 if (customerId!="") {
							 $("#"+n.split(".")[0]).attr("src","../"+com_id+"/evalimg/"+customerId+"/"+n+"?"+Math.random());
		 			 }
				 });
				 }
		  	});
		}
}
function imgCLientUpload(t,key,img){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key+"&type=userpic"+math+"&imgName="+img,
		"msgId":"msg",
		"fileId":key,
		"msg":"图片",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$("#"+img).attr("src","../"+imgurl+"?ver="+Math.random());
	});
}