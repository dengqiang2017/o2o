var weixinpay={
		init:function(){
			var timestamp = new Date().getTime()+"";
			pop_up_box.dataHandling("初始化中...");
			loadtime=window.setTimeout("pop_up_box.loadWaitClose()",10000);
			var url=window.location.href;
			var param={
					"orderNo":$("#orderNo").html(),
					"attach":$("input[name='attach']").val(),
					"body":$("input[name='body']").val(),
					"total_fee":parseFloat($("#sum_si").html())*100,
					"totalFee":parseFloat($("#sum_si").html())*100
			};
			if (!is_weixin()) {
				if(IsPC()){
					geterweima();
				}else{
					pop_up_box.showMsg("请使用手机微信或者电脑进行支付!");
				}
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
			    		"total_fee":param.total_fee,
			    		"attach":param.attach,
			    		"body":param.body
			    	},function(data){
			    		///计算签名
			    		var pm="orderNo="+param.orderNo+
			    		"&total_fee="+param.total_fee+
			    		"&attach="+encodeURI(param.attach)+
			    		"&body="+encodeURI(param.body);
			    		var key=$.md5(pm);
			    		if (key!=param.key) {
			    			pop_up_box.loadWaitClose();
			    			alert("页面签名错误!");
							return;
						}
			    		pop_up_box.loadWaitClose();
			        	if(data.return_msg!="OK"){
			    		    pop_up_box.showMsg(data.return_msg);
			        	}else{
			            try{
			            	function onBridgeReady(){
			            	    WeixinJSBridge.invoke(
			            	        'getBrandWCPayRequest', {
			            	            "appId":data.appId+"", //公众号名称，由商户传入     
			            	            "timeStamp":data.timeStamp+"",         //时间戳，自1970年以来的秒数     
			            	            "nonceStr":data.nonce_str, //随机串     
			            	            "package": "prepay_id="+data.prepay_id,     
			            	            "signType": "MD5",        //微信签名方式：     
			            	            "paySign": data.paySign //微信签名 
			            	        },
			            	        function(res){
			            	        // 使用以上方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。 
			            	            if(res.err_msg == "get_brand_wcpay_request:ok" ) {
			            	            	pop_up_box.loadWaitClose();
			            					pop_up_box.dataHandlingWait();
			            	                $.get("../weixin/getOrderPayState.do",{
			            	                	"weixinType":data.weixinType,
			                                	"orderNo":param.orderNo,"total_fee":param.total_fee
			                                },function(data){
			                                	pop_up_box.loadWaitClose(); 
			                                	if (data.success) {
			                                		window.location.href="pay_success.html";
			            						}
			                                });
			            	            }else{
			            	            	pop_up_box.loadWaitClose();
			                            	pop_up_box.showMsg("支付取消!",function(){
			                            		$.get("../weixin/alipayCancel.do",{
			                            			"orderNo":param.orderNo
			                            		},function(data){
			                            			
			                            		});
			                            	});
			            	            }
			            	        }
			            	    ); 
			            	 }
			            	if (typeof WeixinJSBridge == "undefined"){
			            	    if( document.addEventListener ){
			            	        document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
			            	    }else if (document.attachEvent){
			            	        document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
			            	        document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
			            	    }
			            	 }else{
			            	    onBridgeReady();
			            	 }
			            	setInterval(function(){
			            		$.get("../weixin/getOrderPayState.do",{"orderNo":param.orderNo,"total_fee":param.total_fee},function(data){
			            			if (data.success) {
			                    		window.location.href="pay_success.html";
									}
			            		});
			            	}, 3000);
			        	} catch (e) {
							 alert("失败"+e);
						}
			        	}
			    	});
				});
				wx.error(function(res) {
					alert("错误:"+res);
					// config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
					});
				});  
					
				}
			function geterweima(){
			$("#shaoma img").show();
			pop_up_box.dataHandlingWait();
			$.post("../weixin.do",{
				"trade_type":"NATIVE",
				"orderNo":param.orderNo,
				"total_fee":param.total_fee,
				"attach":param.attach,
				"body":param.body
			},function(data){
				///计算签名
				var pm="orderNo="+param.orderNo+
				"&total_fee="+param.total_fee+
				"&attach="+encodeURI(param.attach)+
				"&body="+encodeURI(param.body);
				var key=$.md5(pm);
				if (key!=param.key) {
					pop_up_box.loadWaitClose();
					alert("扫码签名错误!");
					return;
				}
				$("#shaoma").find("img:eq(0)").attr("src","/"+data.codeUrl);
				pop_up_box.loadWaitClose();
				setInterval(function(){
					$.get("../weixin/getOrderPayState.do",{
						"orderNo":param.orderNo,
						"weixinType":data.weixinType,
						"total_fee":param.total_fee
						},function(data){
						if (data.success) {
			        		window.location.href="pay_success.html";
						}else{
							if(data.msg){
								var json=$.parseJSON(data.msg);
								if(json.result_code=="FAIL"){
									pop_up_box.showMsg("出错了,请选择其它支付方式!",function(){
										history.go(-1);
									});
								}
							}
						}
					});
				}, 3000);
			});
			}
			
			
			
		}
}