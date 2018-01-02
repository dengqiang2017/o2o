	var timestamp = new Date().getTime()+"";
		pop_up_box.dataHandling("初始化中...");
		loadtime=window.setTimeout("pop_up_box.loadWaitClose()",10000);
		var now = new Date();
		var nowStr = now.Format("yyyyMMddhhmmss");
		$("input[name='orderNo']").val(nowStr);
		$("input[name='orderNo']").attr("readonly","readonly");
		var param={
				orderNo:nowStr,
				total_fee:50000,
				attach:"运营商充值",
				body:"运营商充值微信在线支付"
		};
		var url=window.location.href;
		var com_id=url.split("?")[1];
		if(!com_id){
			com_id=$.cookie("employeecom_id",{path:"/"});
		}
		if (!is_weixin()) {
			geterweima();
		}else{
		$.get("../employee/getSignature.do", {
			"timeStamp" : timestamp,
			"url" : url
		}, function(data) {
			try{
			wx.config({
				debug : false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				appId : data.split(",")[2], // 必填，企业号的唯一标识，此处填写企业号corpid
				timestamp : data.split(",")[1], // 必填，生成签名的时间戳
				nonceStr : data.split(",")[3], // 必填，生成签名的随机串
				signature : data.split(",")[0],// 必填，签名，见附录1
				jsApiList : ["chooseWXPay","hideOptionMenu"]
			// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
			});
			} catch (e) {
				pop_up_box.loadWaitClose();
			}
			wx.ready(function() {
				wx.hideOptionMenu();
				pop_up_box.loadWaitClose();
				pop_up_box.dataHandlingWait();
				$.post("../weixin.do",{
		    		"orderNo":param.orderNo,
		    		"com_id":com_id,
		    		"total_fee":param.total_fee,
		    		"attach":param.attach,
		    		"body":param.body
		    	},function(data){
		    		///计算签名
//		    		var pm="orderNo="+param.orderNo+
//		    		"&total_fee="+param.total_fee+
//		    		"&attach="+encodeURI(param.attach)+
//		    		"&body="+encodeURI(param.body);
//		    		var key=$.md5(pm);
//		    		if (key!=param.key) {
//		    			pop_up_box.loadWaitClose();
//		    			alert("签名错误!");
//						return;
//					}
		    		pop_up_box.loadWaitClose();
		    		if(data.error){
		    			pop_up_box.showMsg(data.error,function(){
		    				window.location.href="../employee.do";
		    			});
		    		}else if(data.return_msg!="OK"){
		    		    pop_up_box.showMsg(data.return_msg);
		        	}else{
		            try{
		            	wx.chooseWXPay({
		            	appId :data.appId+"",          //时间戳，自 1970 年以来的秒数
		            	timestamp:data.timeStamp+"",          //时间戳，自 1970 年以来的秒数
		                nonceStr : data.nonce_str, //随机串
		                "package" : "prepay_id="+data.prepay_id,
		                signType : "MD5",          //微信签名方式:
		                paySign : data.paySign //微信签名
		                ,success:function(res){
// 			                if(res.err_msg == "get_brand_wcpay_request:ok" ) {
// 			                	pop_up_box.showMsg("支付成功,返回充值页面",function(){
// 			                    window.location.href="../employee.do";
// 			                	});
// 			                }else{
// 			                    alert(res.err_msg);
// 								window.location.href="../employee.do";
// 			                }
							pop_up_box.loadWaitClose();
							pop_up_box.dataHandlingWait();
			                $.get("../weixin/alipayOK.do",{
		                    	"orderNo":param.orderNo,
		                    	"com_id":com_id,
		                    	"recharge_amount":param.total_fee
		                    },function(data){
		                    	if (data.success) {
		                    	window.location.href="../employee.do";
								}
		                    });
		                },
		                cancel:function(res){
		                    //支付取消
		                	alert("支付取消!");
//		                    $.get("../weixin/alipayCancel.do",{
//		                    	"orderNo":param.orderNo
//		                    },function(data){
		                    	window.location.href="../employee.do";
//		                    });
		                }
		            });
		        	} catch (e) {
						 alert("失败"+e);
					}
		        	}
		    	});
			});
			wx.error(function(res) {
				alert(res);
				// config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
			});
		});  
			
		}
    function geterweima(){
			$("#shaoma").show();
		pop_up_box.dataHandlingWait();
		$.post("../weixin.do",{
    		"trade_type":"NATIVE",
    		"orderNo":param.orderNo,
    		"total_fee":param.total_fee,
    		"attach":param.attach,
    		"body":param.body
    	},function(data){
    		///计算签名
//    		var pm="orderNo="+param.orderNo+
//    		"&total_fee="+param.total_fee+
//    		"&attach="+encodeURI(param.attach)+
//    		"&body="+encodeURI(param.body);
//    		var key=$.md5(pm);
//    		if (key!=param.key) {
//    			pop_up_box.loadWaitClose();
//    			alert("签名错误!");
//				return;
//			}
    		$("#orderNo").html(param.orderNo);
    		$("#attach").html(param.attach);
    		$("#body").html(param.body);
    		$("#total_fee").html(parseFloat(param.total_fee)/100);
    		$("#shaoma").find("img").attr("src","/"+data.codeUrl);
    		pop_up_box.loadWaitClose();
//    		setInterval(function(){
//    			window.location.href="../employee.do";
//    			$.get("../customer/getOrderPayState.do",{"orderNo":param.orderNo},function(data){
//    				if(data!="待支付"&&data!="支付中"){
//    					pop_up_box.showMsg("支付成功,返回首页", function(){
//    					});
//    				}
//    			});
//    		}, 5000);
    	});
		}