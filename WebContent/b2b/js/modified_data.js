URLFiltering();
$('.side-cover').hide();
    $('.modified li').eq(1).click(function(){//选择
         $('.side-cover').fadeIn('fast');
         $('.amend_sex').fadeIn('fast');
    });
    $('.side-cover').click(function(){
        $('.side-cover').fadeOut('fast');
        $('.amend_sex').fadeOut('fast');
    });
    $('.side-cover li:eq(1),.side-cover li:eq(2)').click(function(){
         $("#saveName").unbind("click");
         var sex=$(this).html();
 		pop_up_box.postWait();
 			$.post("../customer/saveUserInfo.do",{
 				"sex":sex
 			},function(data){
 				pop_up_box.loadWaitClose();
 				pop_up_box.toast("修改成功",1000);
		        $('.side-cover').fadeOut('fast');
		        $('.amend_sex').fadeOut('fast');
		        $("#sex").html(sex);
 			});
    });
    pop_up_box.loadWait();
    $.get("../customer/getCustomerInfo.do",function(data){
    	pop_up_box.loadWaitClose();
    	$("#customerName").html(data.corp_sim_name);
    	$("#sex").html(data.sex);
    	$("#movtel").html(data.movtel);
    	try {
    		if(!data.corp_sim_name||parseInt(data.corp_sim_name)>0){
    			$("#customerName").html(data.weixin_name);
    		}
    	} catch (e) {}
    	$(".modified li").eq(0).click(function(){
    		$("#editName,.header:eq(1)").show();
    		$("#infopage,.header:eq(0)").hide();
    		$("#modal_title").html("修改姓名");
    		$("#editName .name_input:eq(0)>input").attr("placeholder","输入个人姓名");
    		$("#editName .name_input:eq(0)>input").val($(this).find("#customerName").html());
    		$("#editName .name_input:eq(1)").hide();
    		$("#editName .name_input:eq(1)>input").val("");
    		$("#editName .name_input:eq(0)>input").bind("input propertychange blur",function(){
    			var v=$.trim($(this).val());
    			if(v!=""){
    				$("#saveName").removeAttr("disabled");
    			}else{
    				$("#saveName").attr("disabled","disabled");
    			}
    		});
    		$("#saveName").unbind("click");
    		$("#saveName").click(function(){
    			pop_up_box.postWait();
    			$.post("../customer/saveUserInfo.do",{
    				"corp_sim_name":$("#editName .name_input:eq(0)>input").val()
    			},function(data){
    				pop_up_box.loadWaitClose();
    				pop_up_box.toast("修改成功",1000);
		    		$("#editName,.header:eq(1)").hide();
		    		$("#infopage,.header:eq(0)").show();
		    		$("#customerName").html($("#editName .name_input:eq(0)>input").val());
    			});
    		});
    	});
    	$(".modified li").eq(2).click(function(){
    		$("#editName,.header:eq(1)").show();
    		$("#infopage,.header:eq(0)").hide();
    		$("#modal_title").html("修改联系方式");
    		$("#editName .name_input:eq(0)>input").attr("placeholder","输入电话号码");
    		$("#editName .name_input:eq(0)>input").val($(this).find("#movtel").html());
    		$("#editName .name_input:eq(0)>span").html($(this).find("#movtel").html());
    		$("#editName .name_input:eq(1)>input").val("");
    		$("#editName .name_input:eq(1)").show();
    		$("#codebtn,#codeinput,#saveName").attr("disabled","disabled");
    		$("#editName .name_input:eq(0)>input").bind("input propertychange blur",function(){
    			var val=$.trim($("#editName .name_input:eq(0)>span").html());
    			var v=$.trim($(this).val());
    			if(v.length==11&&val!=v){
    				$("#codebtn,#codeinput").removeAttr("disabled");
    			}else{
    				$("#codebtn,#codeinput").attr("disabled","disabled");
    			}
    		});
    		$("#editName .name_input:eq(1)>input").bind("input propertychange blur",function(){
    			var v=$.trim($(this).val());
    			if(v.length>=4){
    				$("#saveName").removeAttr("disabled");
    			}else{
    				$("#saveName").attr("disabled","disabled");
    			}
    		});
    		$("#codebtn").click(function(){
    			var val=$.trim($("#editName .name_input:eq(0)>input").val());
    			if(val!=""&&val.length==11){
    				$.get("../customer/getVerificationCode.do",{
    					"phone":val
    				},function(data){
    					if (data.success) {
    						pop_up_box.toast("验证码已发送!",2000);
    						$("#codebtn").attr("disabled","disabled");
						} else {
							if (data.msg) {
								pop_up_box.showMsg(data.msg);
							} else {
								pop_up_box.showMsg("发送失败!");
							}
						}
    				});
    			}else{
    				pop_up_box.showMsg("手机号格式不正确!");
    			}
    		});
    		$("#saveName").unbind("click");
    		$("#saveName").click(function(){
    			pop_up_box.postWait();
    			$.post("../customer/saveUserInfo.do",{
    				"movtel":$("#editName .name_input:eq(0)>input").val(),
    				"code":$("#editName .name_input:eq(1)>input").val()
    			},function(data){
    				pop_up_box.loadWaitClose();
    				if (data.success) {
						pop_up_box.toast("修改成功",1000);
						$("#editName,.header:eq(1)").hide();
						$("#infopage,.header:eq(0)").show();
						$("#movtel").html($("#editName .name_input:eq(0)>input").val());
					} else {
						if (data.msg) {
							pop_up_box.showMsg(data.msg);
						} else {
							pop_up_box.showMsg("修改失败!");
						}
					}
    			});
    		});
    	});
    });
    $(".eidt").click(function(){
    	login_url="personal_center.jsp?com_id="+com_id;
    	$.get("../login/exitLogin.do?type=2",function(){
    		window.location.href=login_url;
    	});
    });