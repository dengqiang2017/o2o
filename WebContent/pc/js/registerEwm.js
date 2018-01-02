var upper_customer_id="";
var type="";
$(function(){
//	alert("欢迎注册本平台");
	var regType=$("#regType").val();//注册用户类型<input type="hidden" value="customer" id="regType"> //value="employee"
	var phone=$("input[name='user_id']");//用户注册手机号
	var msgspan=$(".tips-red");//信息提示span
	var verificationCode=$("input[name='verificationCode']");//验证码输入框
	var get_code=$("#get_code");//获取验证码按钮id
	var phone_check=false;
	var com_id=$.cookie("com_id",{path:"/"});
	$.get("../login/getComs.do",function(data){
		if (data) {
			$("select").html("");
			var k=0;
			for (var i = 0; i < data.length; i++) {
				var com=data[i];
				if($.trim(com.com_id)==com_id){
					k=i;
				}
				$("select").append("<option value='"+$.trim(com.com_id)+"'>"+com.com_sim_name+"</option>");
			}
			$("select").val(data[k].com_id);
			$(".yysname").html(data[k].com_sim_name);
		}
	});	
//	$("#verifycodeimg,#verifycodea").click(function(){
//		$.get("../login/getImgVerifyCode.do",function(data){
//			if(data.success){
//				$("#verifycodeimg").attr("src","../temp/verifies/"+data.msg);
//			}
//		});
//	});
	//根据注册用户类型,跳转到相应的登录页面
	function tologin(){
		$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
		if(regType=="eval"){
			window.location.href="../pc/loginEval.html";
		}else if(regType=="drive"){
			window.location.href="../pc/loginDrive.html";
		}else if(regType=="supplier"){
			window.location.href="../pc/loginSupplier.html";
		}else if(regType=="employee"){
			window.location.href="../pc/login-yuangong.html";
		}else{
			window.location.href="../pc/login.html";
		}
	}
	//给手机号输入框绑定change事件
	phone.change(function(){
		get_code.attr("disabled","disabled");
		if (phone.val()=="") {
			phone_check=false;
			msgspan.html("手机号不能为空!");
		}else if (phone.val().length!=11) {
			phone_check=false;
			msgspan.html("手机号长度不正确!");
		}else if(/^[0-9]\d{4,10}$/.test(phone.val())){
			phone_check=true;//1[3|4|5|8]
			msgspan.html("");
			pop_up_box.dataHandling("检测手机号中...");
			var url="../user/checkPhone.do";
			if(regType=="supplier"){
				url="../supplier/checkPhone.do";
			}
			$.get(url,{
				"com_id":$("select").val(),
				"reg":"reg",
				"type":regType,
				"mobileNum":phone.val(),
				"phone":phone.val()
				},function(data){
				pop_up_box.loadWaitClose();
				if(regType!="supplier"){
					if (data.success) {
						msgspan.html("手机号已经存在!");
						pop_up_box.showMsg("手机号已经存在,请直接登录吧!",function(){
							tologin();
						});
						phone_check=false;
					}else{
						phone_check=true;
						msgspan.html("");
						get_code.removeAttr("disabled");
					}
				}else {
					if (data.success) {
						phone_check=true;
						msgspan.html("");
						get_code.removeAttr("disabled");
					}else{
						msgspan.html("手机号已经存在!");
						pop_up_box.showMsg("手机号已经存在,请直接登录吧!",function(){
							tologin();
						});
						phone_check=false;
					}
				}
			});
		}else{
			phone_check=false;
			msgspan.html("手机号码格式不正确!");
		}
	});
	var getcodeimg=get_code.parent().find("img");
	if(getcodeimg&&getcodeimg.length>0){
		getcodeimg.click(function(){
			get_code.click();
		});
	}
	get_code.click(function(){
		if ($(this).html().indexOf("秒")>0) {
			
		}else{
			var verifycode=$.trim($("#verifycode").val());
			if(!verifycode){
				pop_up_box.showMsg("请输入图形验证码");
				return;
			}
			pop_up_box.postWait();
			$.get("../customer/getVerification_code.do",{
				"phone":phone.val(),
				"verifycode":verifycode
				},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					get_code.attr("disabled","disabled");
					getCode(data.msg);///comm
					verificationCode.removeAttr("disabled");
				}else{
					msgspan.html(data.msg);
					if(data.msg.indexOf("图形")>=0){
						pop_up_box.showMsg("页面过期",function(){
							window.location.reload();
						});
					}else{
						pop_up_box.showMsg("验证码不正确->"+data.msg,function(){
							window.reload();
						});
					}
				}
			});
		}
	});
var sort_id=$("#sort_id");
	$("#registerBtn").click(function(){
		var msghtml=msgspan.html();
		var phone=$("input[name='user_id']");//用户注册手机号
		if (msghtml=="") {
			phone.change();
		}
		var verifycode=$.trim($("#verifycode").val());
		if(!verifycode){
			pop_up_box.showMsg("请输入图形验证码");
			return;
		}
		var FHDZtext=$.trim($("textarea[name='FHDZ']").val());
		var corp_nametext=$.trim($("input[name='corp_name']").val());
		if (!phone_check) {
			pop_up_box.showMsg("手机号不正确->"+msghtml);
		}else if (verificationCode.val()=="") {
			pop_up_box.showMsg("请输入手机接收到的验证码!");
		}else if (!$("#check").attr("checked")) {
			pop_up_box.showMsg("请接受协议!");
		}else{
			pop_up_box.postWait();
			var url="../"+regType+"/saveUser.do";
			if(regType=="eval"){
				url="../saiyu/saveEval.do?";
			}else if(regType=="drive"){
				url="../saiyu/saveDrive.do";
			}else if(regType=="operate"){
				url="../manager/saveOperateR.do";
			}
			pop_up_box.postWait();
			var fenxiangid=$.cookie("fenxiangid");
			if(fenxiangid&&fenxiangid.indexOf("fenxiangid")>=0){
				fenxiangid=$.cookie("fenxiangid",{path:"/"});
			}else{
				fenxiangid="";
			}
//			var upper_customer_id=$.cookie("upper_customer_id");
//			if(upper_customer_id.indexOf("upper_customer_id")>=0){
//				upper_customer_id=$.cookie("upper_customer_id",{path:"/"});
//			}
//		   if(upper_customer_id=="CS1C001"){
//			   type="养殖户";
//		   }else if(upper_customer_id=="CS1C002"){
//			   type="贩卖方";
//		   }
			pop_up_box.postWait();
			$.post(url,{
				"userId":phone.val(),
				"verificationCode":verificationCode.val(),
				"comId":$("select").val(),
				"licenseType":0,
				"FHDZ":FHDZtext,
				"type":type,
				"upper_customer_id":upper_customer_id,
				"fenxiangid":fenxiangid,
				"corp_name":corp_nametext
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					if(data.msg){
						$.cookie(regType+"com_id",data.msg,{ path: '/', expires: 7 });
					}
					$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
					if (data.error_code==60118) {
						window.location.href="addWeixin.html?"+phone.val();
//						pop_up_box.showMsg("系统检测到您的手机号与微信号不匹配!请手动匹配微信号与手机号,以便正常使用系统消息功能!");
					}
					if ($("#erweima").length>0) {
						if($("#erweimadiv").length>0){
							$("#erweimadiv").show();
							$(".container").hide();
						}else{
							window.location.href="../pc/erweima.html";
						}
					}else{
						pop_up_box.showMsg("注册成功去登录!",function(){
							if (regType=="employee"||regType=="operate") {
//								$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
								window.location.href="../pc/login-yuangong.html";
							}else if(regType=="eval"){
//								$.cookie("evalName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="../pc/loginEval.html";
							}else if(regType=="drive"){
//								$.cookie("driveName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="../pc/loginDrive.html";
							}else if(regType=="supplier"){
//								$.cookie("supplierName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="../pc/loginSupplier.html";
							}else{
//								$.cookie("loginName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="../pc/login.html";
							}
						});
					}
				}else{
					if(data.msg){
						pop_up_box.showMsg("注册失败,错误代码:"+data.msg);
					}else{
						pop_up_box.showMsg("注册失败!");
					}
					msgspan.html(data.msg);
				}
			});
		}
	});
});