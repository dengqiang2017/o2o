$(function(){
//	alert("欢迎注册本平台");
	var regType=$("#regType").val();//注册类型<input type="hidden" value="customer" id="regType"> //value="employee"
	var phone=$("input[name='user_id']");//用户注册号
	var msgspan=$(".tips-red");//信息提示span
	var verificationCode=$("input[name='verificationCode']");//验证码输入框
	var get_code=$("#get_code");//获取验证码按钮id
	var pwd=$("input[name='user_password']");//密码输入框
	var confirmPwd=$("input[name='confirmPwd']");//重复密码输入框
	var phone_check=false;
	$.get("../login/getComs.do",function(data){
		if (data) {
			$("select").html("");
			for (var i = 0; i < data.length; i++) {
				var com=data[i];
				$("select").append("<option value='"+com.com_id+"'>"+com.com_sim_name+"</option>");
			}
			verificationCode.attr("disabled","disabled");
		}
	});	
	function tologin(){
		$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
		if(regType=="eval"){
			window.location.href="loginEval.html";
		}else if(regType=="drive"){
			window.location.href="loginDrive.html";
		}else if(regType=="supplier"){
			window.location.href="loginSupplier.html";
		}else if(regType=="employee"){
			window.location.href="login-yuangong.html";
		}else{
			window.location.href="login.html";
		}
	}
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
			var url="";
			if(regType=="eval"){
				url="../user/checkPhone.do";
			}else if(regType=="drive"){
				url="../user/checkPhone.do";
			}else{
				url="../"+regType+"/checkPhone.do";
			}
			$.get(url,{
				"com_id":$("select").val(),
				"reg":"reg",
				"type":regType,
				"mobileNum":phone.val(),
				"phone":phone.val()
				},function(data){
				pop_up_box.loadWaitClose();
				if(regType=="eval"||regType=="drive"){
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
	get_code.click(function(){
		pop_up_box.postWait();
		$.get("../customer/getVerificationCode.do",{"phone":phone.val()},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				get_code.attr("disabled","disabled");
				getCode(data.msg);///comm
				verificationCode.removeAttr("disabled");
			}else{
				msgspan.html(data.msg);
				pop_up_box.showMsg("验证码不正确->"+data.msg);
			}
		});
	});
var sort_id=$("#sort_id");
	
	$("#registerBtn").click(function(){
		var msghtml=msgspan.html();
		var sort_id_check=true;
		var pwd=$("input[name='user_password']");///兼容手机登录和注册页面出现的两个密码字段
		var confirmPwd=$("input[name='confirmPwd']");
		
		if (msghtml=="") {
			phone.change();
		}
		msghtml=msgspan.html();
		if (msghtml=="") {
			pwd.change();
		}
		msghtml=msgspan.html();
		if (msghtml=="") {
			confirmPwd.change();
		}
		if (sort_id.length>0) {
			if (sort_id.val()=="") {
				sort_id_check=false;
			}
		}
		var pwdtext=$.trim($("input[name='user_password']"));
		var confirmPwdtext=$.trim($("input[name='confirmPwd']"));
		if(!sort_id_check){
			pop_up_box.showMsg("请选择您所在的部门");
		}else  if (!phone_check) {
			pop_up_box.showMsg("手机号不正确->"+msghtml);
		}else if (!pwd_check) {
			pop_up_box.showMsg("密码不正确->"+msghtml);
		}else if (pwdtext!=confirmPwdtext) {
			pop_up_box.showMsg("二次密码不正确->"+msghtml);
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
			}
			pop_up_box.postWait();
			$.post(url,{
				"userId":phone.val(),
				"pwd":pwd.val(),
				"confirmPwd":confirmPwd.val(),
				"verificationCode":verificationCode.val(),
				"sort_id":sort_id.val(),
				"comId":$("select").val(),
				"licenseType":0
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					if (data.error_code==60118) {
						window.location.href="addWeixin.html?"+phone.val();
//						pop_up_box.showMsg("系统检测到您的手机号与微信号不匹配!请手动匹配微信号与手机号,以便正常使用系统消息功能!");
					}
					if ($("#erweima").length>0) {
						window.location.href="addUserWeixin.html?"+phone.val()+"|"+regType;
//						window.location.href="erweima.html";
					}else{
						pop_up_box.showMsg("注册成功去登录!",function(){
							if (regType=="employee") {
								$.cookie("employeeloginName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="login-yuangong.html";
							}else if(regType=="eval"){
								$.cookie("evalloginName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="loginEval.html";
							}else if(regType=="drive"){
								$.cookie("driveloginName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="loginDrive.html";
							}else if(regType=="supplier"){
								$.cookie("supplier",phone.val(),{ path: '/', expires: 7 });
								window.location.href="loginSupplier.html";
							}else{
								$.cookie("loginName",phone.val(),{ path: '/', expires: 7 });
								window.location.href="login.html";
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