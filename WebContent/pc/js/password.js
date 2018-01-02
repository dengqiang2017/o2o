var pwd_check=false;
var confirmPwd_check=false;
$(function(){
	var pwd=$("input[name='user_password']");///兼容手机登录和注册页面出现的两个密码字段
	var confirmPwd=$("input[name='confirmPwd']");
	var msgspan=$("#msg");
	/**
	 * 检查确认密码
	 */
	function checkConfirmPwd(){
//		removePwdCss(confirmPwdMsg);
		if (confirmPwd.val()=="") {
			confirmPwd_check=false;
			msgspan.html("请输入确认密码!");
		}else if (pwd.val()==confirmPwd.val()) {
			confirmPwd_check=true;
			msgspan.html("");
		}else{
			confirmPwd_check=false;
			msgspan.html("两次输入密码不一致!");
		}
	}
	/**
	 * 检查密码等级
	 */
	function passwordLevel(password) {
		var Modes = 0;  
		for (i = 0; i < password.length; i++) {
			Modes |= CharMode(password.charCodeAt(i));  
			}   return bitTotal(Modes);  
			// CharMode函数
	function CharMode(iN) { 
		if (iN >= 48 && iN <= 57)// 数字
		return 1;    
	if (iN >= 65 && iN <= 90) // 大写字母
		return 2;    
	if ((iN >= 97 && iN <= 122) || (iN >= 65 && iN <= 90))  // 大小写
		return 4;    
	else     
		return 8;
	// 特殊字符
	}   // bitTotal函数
	function bitTotal(num) {
		modes = 0;    
		for (i = 0; i < 4; i++) {   
			if (num & 1) modes++;   
			num >>>= 1;    
			}  
		return modes; 
		} 
	}
	pwd.change(function(){
		var pwdlevel=$("#pwdlevel");
//		removePwdCss(pwdMsg);
		if (pwd.val()=="") {
			pwd_check=false;
			msgspan.html("密码不能为空!");
		}else if (pwd.val().length<6) {
			pwd_check=false;
			msgspan.html("密码不能少于6位!");
		}else{
			pwd_check=true; 
			msgspan.html("");
		}
//		var level=passwordLevel(pwd.val());
//		 ////密码强度判断
//		switch (level) {
//		case 2:
//			pwdlevel.html("中等");
//			break;
//		case 3:
//			pwdlevel.html("较强");
//			break;
//		default:
//			pwdlevel.html("弱");
//			break;
//		}
	});
	confirmPwd.change(function(){
		checkConfirmPwd();
	});

});