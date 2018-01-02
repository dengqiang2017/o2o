$(function(){
	register.init();
});
var register={
		upper_customer_id:"",
		type:"",
		quhua:"",
		backurl:"",
		init:function(){
			setComIdToA("body");
			var regType=$("#regType").val();//注册用户类型<input type="hidden" value="customer" id="regType"> //value="employee"
			var phone=$("input[name='user_id']");//用户注册手机号
			var msgspan=$(".tips-red");//信息提示span
			var verificationCode=$("input[name='verificationCode']");//验证码输入框
			var get_code=$("#get_code");//获取验证码按钮id
			var phone_check=false;
			var com_id=$.cookie("com_id",{path:"/"});
			if(com_id.indexOf("com")>=0){
				com_id="";
			}
			var comid=getQueryString("com_id");
			if(comid){
				com_id=comid;
			}
			$.get("../login/getNextComs.do",function(data){
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
//			$("#verifycodeimg,#verifycodea").click(function(){
//				$.get("../login/getImgVerifyCode.do",function(data){
//					if(data.success){
//						$("#verifycodeimg").attr("src","../temp/verifies/"+data.msg);
//					}
//				});
//			});
			//根据注册用户类型,跳转到相应的登录页面
			function tologin(){
				var com_id=$("select").val();
				$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
				if(regType=="eval"){
					window.location.href="../pc/loginEval.html?com_id="+com_id;
				}else if(regType=="drive"){
					window.location.href="../pc/loginDrive.html?com_id="+com_id;
				}else if(regType=="supplier"){
					window.location.href="../pc/loginSupplier.html?com_id="+com_id;
				}else if(regType=="employee"){
					window.location.href="../pc/login-yuangong.html?com_id="+com_id;
				}else{
					window.location.href="../pc/login.html?com_id="+com_id;
				}
			}
			phone.bind("input propertychange blur", function() {
				if(phone.val().length==11&&!phone_check){
					if(/^[0-9]\d{4,10}$/.test(phone.val())){
						phone_check=true;//1[3|4|5|8]
						msgspan.html("");
						var url="../user/checkPhone.do";
						if(regType=="supplier"){
							url="../supplier/checkPhone.do";
						}
						pop_up_box.dataHandling("检测手机号中...");
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
				}else{
					if(phone.val().length<11){
						phone_check=false;
					}
				}
			});
			//给手机号输入框绑定change事件
			phone.change(function(){
				if(phone.val().length!=11){
					get_code.attr("disabled","disabled");
					pop_up_box.dataHandling("检测手机号长度中...");
					if (phone.val()=="") {
						phone_check=false;
						msgspan.html("手机号不能为空!");
						pop_up_box.loadWaitClose();
					}else if (phone.val().length!=11) {
						phone_check=false;
						msgspan.html("手机号长度不正确!");
						pop_up_box.loadWaitClose();
					}else{
						pop_up_box.loadWaitClose();
					}
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
				var msghtml=$.trim(msgspan.html());
				var sort_id_check=true;
				var pwd=$("input[name='user_password']");///兼容手机登录和注册页面出现的两个密码字段
//				var confirmPwd=$("input[name='confirmPwd']");
				var phone=$("input[name='user_id']");//用户注册手机号
				var confirmPwd=pwd.val();
				if (msghtml=="") {
					phone.change();
				}
				msghtml=$.trim(msgspan.html());
				if (msghtml=="") {
					pwd.change();
				}
//				msghtml=msgspan.html();
//				if (msghtml=="") {
//					confirmPwd.change();
//				}
				var verifycode=$.trim($("#verifycode").val());
				if(!verifycode){
					pop_up_box.showMsg("请输入图形验证码");
					return;
				}
				var pwdtext=$.trim($("input[name='user_password']").val());
//				var confirmPwdtext=$.trim($("input[name='confirmPwd']").val());
				var FHDZtext=$.trim($("textarea[name='FHDZ']").val());
				var corp_nametext=$.trim($("input[name='corp_name']").val());
				
				if (!phone_check&&msghtml!="") {
					pop_up_box.showMsg("手机号不正确->"+msghtml);
				}else if (!pwd_check&&msghtml!="") {
					pop_up_box.showMsg("密码不正确->"+msghtml);
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
					var adr=$.trim($("#address").html());
					if(adr&&adr!=""){
						FHDZtext=adr;
					}
					var clerk_id=getQueryString("clerk_id");
					if(!clerk_id){
						clerk_id="";
					}
					var openid=localStorage.getItem("openid");
					pop_up_box.postWait();
					$.post(url,{
						"userId":phone.val(),
						"pwd":pwd.val(),
						"confirmPwd":confirmPwd,
						"verificationCode":verificationCode.val(),
						"sort_id":sort_id.val(),
						"comId":$("select").val(),
						"com_id":$("select").val(),
						"openid":openid,
						"clerk_id":clerk_id,
						"licenseType":0,
						"FHDZ":FHDZtext,
						"type":register.type,
						"quhua":register.quhua,
						"upper_customer_id":register.upper_customer_id,
						"fenxiangid":fenxiangid,
						"corp_name":corp_nametext
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							if(data.msg){
								$.cookie(regType+"com_id",data.msg,{ path: '/', expires: 7 });
							}
							$.cookie(regType+"pwd",pwd.val(),{ path: '/', expires: 7 });
							$.cookie(regType,phone.val(),{ path: '/', expires: 7 });
							pop_up_box.showMsg("注册成功!",function(){
								if(is_weixin()){
									window.location.href="../pc/erweima.html?com_id="+com_id;
								}else if(IsPC()){
									window.location.href="../pc/erweima.html?com_id="+com_id;
								}else{
									if(register.backurl!=""){
										window.location.href=register.backurl;
									}else{
										var com_id=$("select").val();
										if (regType=="employee"||regType=="operate") {
//									window.location.href="../pc/login-yuangong.html?com_id="+com_id;
											window.location.href="../employee.do?com_id="+com_id;
										}else if(regType=="eval"){
											window.location.href="../pc/loginEval.html?com_id="+com_id;
										}else if(regType=="drive"){
//									window.location.href="../pc/loginDrive.html?com_id="+com_id;
											window.location.href="../pc/index.html?com_id="+com_id;
										}else if(regType=="supplier"){
											window.location.href="../supplier/supplier.do?com_id="+com_id;
//									window.location.href="../pc/loginSupplier.html?com_id="+com_id;
										}else{
											window.location.href="../customer.do?com_id="+com_id;
//									window.location.href="../pre/operate.do?com_id="+com_id;
//									window.location.href="../pc/login.html?com_id="+com_id;
										}
									}
								}
							});
						}else{
							if(data.msg){
								pop_up_box.showMsg("注册失败:"+data.msg);
							}else{
								pop_up_box.showMsg("注册失败!");
							}
							msgspan.html(data.msg);
						}
					});
				}
			});

		}
}
