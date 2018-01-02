var math;
var electrician={
		init:function(){
			var customer_id=$("#editpage").find("#customerId");
			editUtils.editinit("getElectricianInfo", customer_id.val());
			
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
		  	$("#savedian").hide();
		  }
		  //////////////////////////
		  var user_id= $("#editForm input[name='user_id']");
			if (user_id.length > 0) {
				editUtils.checkPhone("dian");
			} 
			$("#editForm input[name='self_id']").change(function(){
		  	if ($.trim($(this).val())=="") {
		  		return;
		  	}
		  	pop_up_box.loadWait();
		  	$.get("checkSelfId.do",{"self_id":this.val(),"type":"dian"},function(data){
		  		pop_up_box.loadWaitClose();
		  		if (data.success) {
		  			pop_up_box.showMsg("电工外码已经存在!",function(){
		  				$("#editForm input[name='self_id']").val("");
		  			});
		  		}
		  	});
		  });
		  
		  $(".btn-success").click(function(){
			  var n = $(".btn-success").index(this);
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
		  });
		  $("#savedian").click(function(){
			   if ($.trim(user_id.val())=="") {
				pop_up_box.showMsg("请输入电工登录账号!");
			   }else if($.trim($("#editForm input[name='user_password']").val())==""){
				   pop_up_box.showMsg("请输入电工登录密码!");
			   }else if($.trim($("#editForm input[name='corp_name']").val())==""){
				   pop_up_box.showMsg("请输入电工名称!");
			   }else if($.trim($("#editForm input[name='corp_sim_name']").val())==""){
				   pop_up_box.showMsg("请输入电工简称!");
			   }else if($.trim($("#editForm input[name='movtel']").val())==""){
				   pop_up_box.showMsg("请输入手机号!");
			   }else{
				   pop_up_box.postWait();  
				   $.post("../saiyu/saveElectrician.do",$("#editForm").serialize(),function(data){
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
			  "customer_id":$("#customerId").val()
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