$(function(){
	var phone=$("input[name='phone']");
	var verificationCode=$("input[name='code']");
	var get_code=$("#get_code");
	var msgspan=$("#msgspan");
	var type=$("#type").val();
	if(type==""){
		try {
			type = window.location.href.split("?")[1].split("=")[1];
		} catch (e) {}
	}
	phone.change(function(){
//		get_code.attr("disabled","disabled");
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
			$.get("../user/checkPhone.do",{"type":type,"phone":phone.val()},function(data){
				pop_up_box.loadWaitClose();
				if (!data.success) {
					phone_check=true;
					msgspan.html("");
					get_code.removeAttr("disabled");
				}else{
					msgspan.html("手机号已经存在!");
					pop_up_box.showMsg("手机号已经存在,请重新输入!",function(){
						phone.val("");
					});
					phone_check=false;
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
				pop_up_box.showMsg(data.msg);
			}
		});
	});
	$("#save").click(function(){
		if($.trim(phone.val())==""){
			pop_up_box.showMsg("请输入手机号!");
		}else if($.trim(verificationCode.val())==""){
			pop_up_box.showMsg("请输入验证码!");
		}else{
			$.post("../user/savePhone.do",{
				"type":type,
				"phone":phone.val(),
				"verifyCode":verificationCode.val()
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("保存成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}
	});
	initNumInput();
});