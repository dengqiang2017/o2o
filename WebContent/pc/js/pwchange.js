$(function(){
	var errorMsg = $("#errorMsg");
	var oldPwd = $("#old_pwd");
	var newPwd = $("#new_pwd");
	var reNewPwd = $("#re_new_pwd");
	var type=$("#type").val();
	if(!type||type==""){
		try {
			type = window.location.href.split("?")[1].split("=")[1];
		} catch (e) {}
	}
	
	//判断输入的旧密码和当前用户登录的密码是否一致
	oldPwd.change( function() {
		if(oldPwd.val() == ""){
			errorMsg.html("当前密码不能为空！");
			return false;
		}
		$.getJSON("../user/checkPwd.do",{"type":type,"value":$.md5(oldPwd.val())}, function(data){
			if(!data.success){
				errorMsg.html(data.msg);
				return false;
			}
		});
		errorMsg.html("");
	});
	//检测新密码是否合法
	newPwd.change(function(){
		if(newPwd.val() == ""){
			errorMsg.html("密码不能为空！")
			return false;
		}else if(newPwd.val().length < 6 || newPwd.val().length > 16){
			errorMsg.html("密码长度不能少于6位或超过16位！")
			return false;
		}else if(!/[a-zA-Z]+/.test(newPwd.val())){
			errorMsg.html("密码内容必须包含字母！")
			return false;
		}
		errorMsg.html("");
	});
	//检测确认新密码是否和新密码一致
	reNewPwd.change(function(){
		if(reNewPwd.val() == ""){
			errorMsg.html("确认密码不能为空！");
			return false;
		}else if(reNewPwd.val() != newPwd.val()){
			errorMsg.html("两次密码不一致。");
			return false;
		}
		errorMsg.html("");
	});
	//在提交前再次校验每条信息的合法性
	$("#submit").click(function(){
		//检测新密码是否合法
		if(newPwd.val() == ""){
			errorMsg.html("密码不能为空！");
			return false;
		}else if(newPwd.val().length < 6 || newPwd.val().length > 16){
			errorMsg.html("密码长度不能少于6位或超过16位！")
			return false;
		}else if(!/[a-zA-Z]+/.test(newPwd.val())){
			errorMsg.html("密码内容必须包含字母！")
			return false;
		}
		//检测确认新密码是否和新密码一致
		if(reNewPwd.val() == ""){
			errorMsg.html("确认密码不能为空！");
			return false;
		}else if(reNewPwd.val() != newPwd.val()){
			errorMsg.html("两次密码不一致。");
			return false;
		}
		//判断输入的旧密码和当前用户登录的密码是否一致
		if(oldPwd.val() == ""){
			
			errorMsg.html("当前密码不能为空！");
			return false;
		}
		
		$.getJSON("../user/checkPwd.do",{"type":type,"value":$.md5(oldPwd.val()), "date":new Date()}, function(data){
			if(!data.success){
				errorMsg.html(data.msg);
			}else{
				//提交数据到后台
				$.post("../user/pwdEdit.do", {"type":type,"value":$.md5(newPwd.val()), "date":new Date()}, function(data){
					if(data.success){
						alert("修改密码成功！");
						window.history.back(-1);
					}
				});
			}
		});
	});
	
	//点击取消，返回首页
	$("#cancel").click(function(){
		window.history.back(-1);
	});
	 
});