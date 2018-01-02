var math;
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
var clientEdit={
		init:function(){
			initNumInput();
			getHeadship();
			var customer_id=$("#editpage").find("#customerId");
			editUtils.editinit("getCustomerInfo", customer_id.val(),function(data){
				if(!data||!data.upper_customer_id){
					$("#editpage #upper_customer_id").val("CS1");
					$("#editpage #upper_corp_name").html("我公司虚拟");
				}
			});
		    var corp_sim_name=$("#editpage").find("input[name='corp_sim_name']");
		    var corp_name=$("#editpage").find("input[name='corp_name']");
		    corp_sim_name.change(function(){
		    	if (corp_name.val()=="") {
		    		corp_name.val($(this).val());
				}
		    	$("#editpage").find("input[name='easy_id']").val(makePy($(this).val()));
		    });
		    if($("#info").val()=="info"){
		    	$("input").attr("disabled","disabled");
		    	$("select").attr("disabled","disabled");
		    	$(".btn-success ").attr("disabled","disabled");
		    	$("#saveClient").hide();
		    }
		    $("#edit").click(function(){
		    	$("input").removeAttr("disabled");
		    	$("select").removeAttr("disabled");
		    	$(".btn-success ").removeAttr("disabled");
		    	$("#edit").hide();
		    	$("#saveClient").show();
		    });
			    
			   //////////////////
			    var user_id= $("input[name='user_id']");
				if (user_id.length > 0) {
					editUtils.checkPhone("");
				}
				$("#editpage").find("input[name='self_id']").change(function(){
			    	if ($.trim($(this).val())!="") {
			    		pop_up_box.loadWait();
			    		$.get("checkClientSelfId.do",{"self_id":$(this).val()},function(data){
			    			pop_up_box.loadWaitClose();
			    			if (data.success) {
			    				pop_up_box.showMsg("客户外码已经存在!",function(){
			    					$("#editpage").find("input[name='self_id']").val("");
			    				});
			    			}
			    		});
			    	}
			    });
			    
				$("#editpage").find(".btn-success").click(function(){
				   var n = $("#editpage").find(".btn-success").index(this);
				   var type=$(this).parents(".form-group").find("label").text();
				   if(type.indexOf("上级客户")>=0){
					   pop_up_box.loadWait(); 
					   $.get("../manager/getDeptTree.do",{"type":"client"},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   client.init();
					   });
				   }else if(type.indexOf("销售代表")>=0){
					   pop_up_box.loadWait(); 
					   $.get("../manager/getDeptTree.do",{"type":"employee"},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   employee.init(function(){
							   $("#clerk_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
							   $("#xsdb_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
						   });
					   });
				   }else if(type.indexOf("款项审批")>=0){
					   pop_up_box.loadWait(); 
					   $.get("../manager/getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   employee.init(function(){
							   $("#clerk_idAccountApprover").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
							   $("#clerk_nameAccountApprover").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
						   });
					   });
				   }else if(type.indexOf("部门")>=0){
					   pop_up_box.loadWait(); 
					   $.get("../manager/getDeptTree.do",{"ver":Math.random()},function(data){
						   pop_up_box.loadWaitClose();
						   $("body").append(data);
						   dept.init(function(id,name){
							   $("#dept_name").html(name);
							   $("#dept_id").html(id);
						   });
					   });
				   }
			   });
				
			   //////////
			   $("#saveClient").click(function(){
				   var easy_id=$("#editpage").find("input[name='easy_id']");
				   if(easy_id.val()==""){
					   $("#editpage").find("input[name='easy_id']").val(makePy(corp_sim_name.val()));
				   }
				   var movtel=$.trim($("#editpage input[name='movtel']").val());
				   var tel_no=$.trim($("#editpage input[name='tel_no']").val());
				   if(movtel!=""){
					   if($.trim(user_id.val())==""){
						   user_id.val(movtel);
					   }
					   if(tel_no==""){
						   $("#editpage input[name='tel_no']").val(movtel); 
					   }
				   }
				   if(tel_no!=""){
					   if($.trim(user_id.val())==""){
						   user_id.val(movtel);
					   }
					   if(movtel==""){
						   $("#editpage input[name='movtel']").val(tel_no);
					   }
				   }
				   if ($.trim(user_id.val())=="") {
					pop_up_box.showMsg("请输入客户登录账号!");
				   }else if($.trim($("input[name='user_password']").val())==""){
					   pop_up_box.showMsg("请输入客户登录密码!");
				   }else if($.trim(corp_name.val())==""){
					   pop_up_box.showMsg("请输入客户名称!");
				   }else if($.trim(corp_sim_name.val())==""){
					   pop_up_box.showMsg("请输入客户简称!");
				   }else if($.trim($("#editpage input[name='movtel']").val())==""){
					   pop_up_box.showMsg("请输入手机号!");
				   }else{
					   pop_up_box.postWait();  
					   $("input[name='salesOrder_Process_Name']").val($("input:radio:checked").next().html());
					   var upper_corp_id=$.trim($("#upper_customer_id").val());
					   if(upper_corp_id=="CS1C001"){
						   $("input[name='type']").val("养殖户");
					   }else if(upper_corp_id=="CS1C002"){
						   $("input[name='type']").val("贩卖方");
					   }
					   $.post("saveClient.do",$("#editForm").serialize(),function(data){
						   pop_up_box.loadWaitClose();
						   if (data.success) {
							   pop_up_box.toast("保存成功", 1000);
							   var type = 1;
								var cid = customer_id.val();
								var oldid=cid;
								if (cid == "") {
									cid = data.msg;
									type = 0;
								}
								customer_id.val(cid);
								var user_id=$("#editForm input[name='user_id']").val();
								var working_status=$("#editForm input[name='working_status']").val();
								var json={"user_id":user_id,"working_status":working_status};
								editUtils.tableShowSyn(type,getbtn(json),function(tr,j,name) {
									if (name == "regionalism_name_cn") {
										tr.find("td:eq("+ j+ ")").html($("#editForm #regionalism_name_cn").html());
									}else if(name=="corp_sim_name"){
										var val=$("#editForm *[name='"+name+"']").val();
										tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
										var li=$(".parent_li input[value='"+oldid+"']").parent().parent();
										li.find("i").html(val);
										li.find("input").val(cid);
									}
								});
						}else{
							pop_up_box.showMsg("保存失败,错误:"+data.msg);
						}
					   });
				   }
			   });
			   ///////////////回显图片////////////
			   var imgtype="userpic";
				  $.get("../saiyu/getevalimg.do",{
					  "customer_id":customer_id.val(),
					  "type":imgtype
				  },function(data){
					 if(data&&data.length>0){
						 $.each(data,function(i,n){
							 var customerId=$.trim($("#customerId").val());
							 if (customerId!="") {
								 var com_id=$.trim($("z").html());
									 $("#"+n.split(".")[0]).attr("src","../"+com_id+"/"+imgtype+"/"+customerId+"/"+n+"?"+Math.random());
				 			 }
						 });
						 }
				  	});
			   ///////////////////////////////////////////////
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
			   $("#qudao").change(function(){
				   if($(this).val()=="消费者"){
					   $("#zhiwu").hide();
					   $("#zhiwu input:eq(0)").val("");
				   }else{
					   $("#zhiwu").show();
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
				//////////////////////////////////////////
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