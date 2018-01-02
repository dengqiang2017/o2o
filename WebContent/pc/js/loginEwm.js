var login={
		init:function(btnId,url,backurl,cookiename,func){
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
				$.get("loginSelect.jsp",function(data){
					$("body").append(data)
				});
				var bu=$.cookie("backurl");
				if(bu){
					$.removeCookie("backurl", { path: '/' });
					$.removeCookie("backurl");
				}
				var com_id=$.cookie("com_id",{path:"/"});
				if(!com_id||com_id.indexOf("com")>=0){
					com_id="";
				}
				var comid=getQueryString("com_id");
				if(comid){
					com_id=comid;
				}
				 $(".btn-default,.close").click(function(){
					 $("#modal_smsSelect").hide();
				 });
			    $("#"+btnId).click(function(){
			    	var name=$.trim($("#username").val());
			    	var pwd=$.trim($("#pwd").val());
			    	if(name==""){
			    		$(".tips-red").html("请输入用户名!");
			    		$("#username").focus();
			    	}else{
			    		if(pwd&&pwd!=""){
			    			pwd=$.md5(pwd);
			    		}else{
			    			pwd="";
			    		}
			    		if(!com_id){
				    		com_id="";
				    	}else if(com_id.indexOf("=")>=0){
				    		com_id="";
				    	}
				    	if(com_id&&com_id!=""){
				    		checkedLogin({"com_id":com_id,"name":name,"pwd":pwd});
				    	}else{
				    		pop_up_box.postWait();
				    		$(".modal-body").html("");
				    		$.post("../"+cookiename+"/loginEwmList.do",{
				    			"com_id":com_id,
				    			"name":name,
				    			"pwd":pwd
				    		},function(data){
				    			pop_up_box.loadWaitClose();
				    			if(!data){
				    				pop_up_box.showMsg("用户名不存在!");
				    			}else if(data.length==0){
				    				pop_up_box.showMsg("用户名或密码错误");
				    			}else{
				    				//将运营商放入弹出框进行选择
				    				//只有一条记录时不弹出
				    				if(data.length==1){
				    					checkedLogin(data[0]);
				    				}else{
				    					//放入弹出框
				    					$.each(data,function(i,n){
				    						var item=$($("#item").html());
				    						$(".modal-body").append(item);
				    						item.find(".radio-inline").html(n.com_sim_name);
				    						item.find("#comid").html(n.com_id);
				    						item.click({"com_name":n.com_sim_name,"com_id":n.com_id,"name":n.name,"pwd":n.pwd},function(event){
				    							checkedLogin(event.data);
				    						});
				    					});
				    					$("#modal_smsSelect").show();
				    				}
				    			}
				    		});
				    	}
			    	}
			    });
			    function checkedLogin(params){
			    	pop_up_box.postWait();
			    	$.post("../"+cookiename+"/checkedLogin.do",params,function(data){
			    		pop_up_box.loadWaitClose();
						if (data.success) {
							///是否保存用户名和密码
							var pwd=$.trim($("#pwd").val());
							var name=$("#username").val();
							
						    $.removeCookie(cookiename);
						    $.removeCookie(cookiename,{path:"/"});
						    $.removeCookie(cookiename+"com_id");
						    $.removeCookie(cookiename+"com_id",{path:"/"});
						    $.removeCookie(cookiename+"pwd");
						    $.removeCookie(cookiename+"pwd",{path:"/"});
						    
		    				$.cookie(cookiename,name ,{ path: '/', expires: 7 });
		    				$.cookie(cookiename+"com_id",com_id,{ path: '/', expires: 7 });
		    				$.cookie("com_id",com_id,{ path: '/', expires: 7 });
		    				if(pwd!=""){
		    					if($(".coded_checked").length>0){
		    						if($(".pro-check").length>0){
		    						}else{
		    							$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
		    						}
		    					}else{
		    						$.cookie(cookiename+"pwd",$("#pwd").val(),{ path: '/', expires: 7 });
		    					}
		    				}
		    				if(bu){
		    					window.location.href=bu;
		    				}else{
		    					window.location.href=backurl;
		    				}
						}else{
							pop_up_box.showMsg("参数错误");
						}
					});
			    }
		}
}