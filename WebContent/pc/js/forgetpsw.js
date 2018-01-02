$(function(){
	var mobile = $("#mobileNum");
	var newPwd = $("#new_pwd");
	var reNewPwd = $("#re_new_pwd");
	var errorMsg = $("#errorMsg");
	var submit = $("#submit");
	var verifyCode = $("#verifyCode");
	var type="cient";
	var param=window.location.href.split("?")[1];
	if(param){
		type = param.split("=")[1];
	}
	
	var verify_code = $("#get_code");
	type=$("#type").html();
	var com_id=getQueryString("com_id");// $.cookie("com_id",{path:"/"});
	//发送验证码
	verify_code.click(function(){
		var verifycode=$.trim($("#verifycode").val());
		if(!verifycode){
			pop_up_box.showMsg("请输入图形验证码");
			return;
		}
		$.get("../customer/getVerification_code.do",{
			"phone":mobile.val(),
			"verifycode":verifycode
			},function(data){
			if (data.success) {
				verify_code.attr("disabled","disabled");
				getCode(data.msg);
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	});
//	pop_up_box.loadWait();
//	$.get("../login/getComs.do",function(data){
//		if (data) {
//			$("select").html("");
//			for (var i = 0; i < data.length; i++) {
//				var com=data[i];
//				$("select").append("<option value='"+com.com_id+"'>"+com.com_sim_name+"</option>");
//			}
//		}
//		pop_up_box.loadWaitClose();
//	});
	//检测手机格式是否合法
	mobile.change(function(){
		if(mobile.val() == ""){
			errorMsg.html("手机号不能为空！");
			pop_up_box.showMsg("手机号不能为空！");
			return false;
		}
		if(mobile.val().length != 11){
			errorMsg.html("手机号格式不正确！");
			pop_up_box.showMsg("手机号格式不正确！");
			return false;
		}
		errorMsg.html("");
	});
	
	//检测新密码是否合法
	newPwd.change(function(){
		if(newPwd.val() == ""){
			errorMsg.html("密码不能为空！");
			pop_up_box.showMsg("密码不能为空！");
			return false;
		}else if(newPwd.val().length < 6 || newPwd.val().length > 16){
			errorMsg.html("密码长度不能少于6位或超过16位！");
			pop_up_box.showMsg("密码长度不能少于6位或超过16位！");
			return false;
		}else if(!/[a-zA-Z]+/.test(newPwd.val())){
			errorMsg.html("密码内容必须包含字母！");
			pop_up_box.showMsg("密码内容必须包含字母！");
			return false;
		}
		errorMsg.html("");
	});
	
	//检测确认新密码是否和新密码一致
	reNewPwd.change(function(){
		if(reNewPwd.val() == ""){
			errorMsg.html("确认密码不能为空！");
			pop_up_box.showMsg("确认密码不能为空！");
			return false;
		}else if(reNewPwd.val() != newPwd.val()){
			errorMsg.html("两次密码不一致。");
			pop_up_box.showMsg("两次密码不一致。");
			return false;
		}
		errorMsg.html("");
	});
	
	//校验验证码是否合法
	verifyCode.change(function(){
		if(verifyCode.val() == ""){
			errorMsg.html("验证码不能为空！");
			pop_up_box.showMsg("验证码不能为空！");
			return false;
		}
		if(verifyCode.val().length != 4){
			errorMsg.html("验证码错误！");
			pop_up_box.showMsg("验证码错误！");
			return false;
		}
	});
	
	//提交前再次校验每行信息是否合法
	submit.click(function(){
		if(mobile.val() == ""){
			errorMsg.html("手机号不能为空！");
			pop_up_box.showMsg("手机号不能为空！");
			return false;
		}
		if(mobile.val().length != 11){
			errorMsg.html("手机号格式不正确！");
			return false;
		}
		if(newPwd.val() == ""){
			errorMsg.html("密码不能为空！");
			return false;
		}else if(newPwd.val().length < 6 || newPwd.val().length > 16){
			errorMsg.html("密码长度不能少于6位或超过16位！")
			return false;
		}else if(reNewPwd.val() == ""){
			errorMsg.html("确认密码不能为空！");
			return false;
		}else if(reNewPwd.val() != newPwd.val()){
			errorMsg.html("两次密码不一致。");
			return false;
		}else if(verifyCode.val() == ""){
			errorMsg.html("验证码不能为空！");
			return false;
		}else if(verifyCode.val().length != 4){
			errorMsg.html("验证码错误！");
			return false;
		}
		pop_up_box.postWait();
		$.post("../user/forgetPwdEdit.do",{
			"type":type,
			"mobileNum":mobile.val(),
			"com_id":com_id, 
			"verifyCode":verifyCode.val(), 
			"value":$.md5(newPwd.val())
		},function(data){
			pop_up_box.loadWaitClose();
			if(data.success){
				pop_up_box.showMsg("修改密码成功！",function(){
					window.history.back(-1);
				});
			}else{
				pop_up_box.showMsg(data.msg);
			}
		}); 
	});
});