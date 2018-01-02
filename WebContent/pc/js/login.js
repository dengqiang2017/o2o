var login={
		init:function(btnId,url,backurl,cookiename,func){
			common.setComIdToA("body");
			 var now = new Date();
			    var nowStr = now.Format("yyyy-MM-dd"); 
			    $("#time").val(nowStr);
			    $("#username").val($.cookie(cookiename));
			    if ($.trim($("#username").val())!="") {
			    	$("#pwd").val($.cookie(cookiename+"pwd"));
				}
				$(document).keydown(function(e) {
					if (e.keyCode == 13) {
						$("#"+btnId).click();
					}
				});
				var bu=$.cookie("backurl");
				if(!bu){
					bu=localStorage.getItem("backurl");
				}
				if(btnId=="loginEmployee"){
					bu="";
				}
				localStorage.removeItem("backurl");
				$.removeCookie("backurl", { path: '/' });
				$.removeCookie("backurl");
				
				var com_id=$.cookie(cookiename+"com_id");
				if(!com_id||com_id.indexOf("com")>=0){
					com_id="";
				}
				var comid=common.getQueryString("com_id");
				if(comid){
					com_id=comid;
				}
				$("#index").attr("href","/b2c/index.jsp?com_id="+com_id+"&ver="+Math.random());
				if($("select").length>0){
//					pop_up_box.loadWait();
					$.get("../login/getNextComs.do",function(data){
						if (data) {
							$("select").html("");
							for (var i = 0; i < data.length; i++) {
								var com=data[i];
								$("select").append("<option value='"+com.com_id+"'>"+com.com_sim_name+"</option>");
							}
							if(com_id){
								$("select").val(com_id);
							}
							if(func){
								func();
							}
						}
//						pop_up_box.loadWaitClose();
					});
				}
			    $("#"+btnId).click(function(){
			    	var name=$.trim($("#username").val());
			    	var pwd=$.trim($("#pwd").val());
			    	if(name==""){
			    		$(".tips-red").html("请输入用户名!");
			    		$("#username").focus();
			    	}else if(pwd==""){
			    		$(".tips-red").html("请输入密码!");
			    		$("#pwd").focus();
			    	}else{
			    		if(pwd&&pwd!=""){
			    			if(pwd.length<32){
			    				pwd=$.md5(pwd);
			    			}
			    		}else{
			    			pwd="";
			    		}
			    		pop_up_box.postWait(); 
			    		if($("select").length>0){
			    			com_id=$("select").val();
			    		}
			    		var openid=localStorage.getItem("openid");
			    		$.post(url,{
			    			"name":name,
			    			"comId":com_id,
			    			"openid":openid,
			    			"pwd":pwd
			    		},function(data){
			    			localStorage.removeItem("backurl");
							$.removeCookie("backurl", { path: '/' });
							$.removeCookie("backurl");
			    			if(data.success){
			    				///是否保存用户名和密码
			    				$.cookie(cookiename,name,{ path: '/', expires: 7 });
			    				$.cookie(cookiename+"com_id",com_id,{ path: '/', expires: 7 });
			    				$.cookie("com_id",com_id,{ path: '/', expires: 7 });
		    					if($(".coded_checked").length>0){
		    						if($(".pro-check").length>0){
		    						}else{
		    							$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
		    						}
		    					}else{
		    						$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
		    					}
			    				if(bu){
			    					window.location.href=bu;
			    				}else{
									window.location.href=backurl;
			    				}
			    			}else{
			    				pop_up_box.loadWaitClose();
			    				if (data.msg) {
			    					if (data.msg=="weixinid") {
			    						$.cookie(cookiename,name,{ path: '/', expires: 7 });
					    				$.cookie(cookiename+"com_id",com_id,{ path: '/', expires: 7 });
					    				$.cookie("com_id",com_id,{ path: '/', expires: 7 });
				    					if($(".coded_checked").length>0){
				    						if($(".pro-check").length>0){
				    						}else{
				    							$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
				    						}
				    					}else{
				    						$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
				    					}
					    				if(bu){
					    					window.location.href=bu;
					    				}else{
					    					window.location.href=backurl;
					    				}
									}else{
										pop_up_box.showMsg("登录失败,"+data.msg,function(){
											$("#pwd").focus();
										});
									}
								}else{
									pop_up_box.showMsg("登录失败请检查用户名和密码!",function(){
										$("#pwd").focus();
									});
								}
			    				$("#pwd").val("");
			    				$("#pwd").focus();
			    			}
			    		});
			    	}
			    });
		}
}