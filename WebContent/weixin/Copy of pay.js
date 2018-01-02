var backurl=localStorage.getItem("backurl");
var timestamp = new Date().getTime()+"";
pop_up_box.dataHandling("初始化中...");
loadtime=window.setTimeout("pop_up_box.loadWaitClose()",10000);
var url=window.location.href;
if (url.split("?")[1].split("&").length<4) {
	alert("参数不正确,返回首页!");
	if(backurl){
		window.location.href=backurl;
	}else{
		window.location.href="../pc/index.html";
	}
}
var params=url.split("?")[1].split("&");
var param={};
for (var i = 0; i < params.length; i++) {
	var item=params[i].split("=");
	param[item[0]]=decodeURI(item[1]);
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
    			alert("签名错误!");
				return;
			}
    		pop_up_box.loadWaitClose();
        	if(data.return_msg!="OK"){
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
					pop_up_box.loadWaitClose();
					pop_up_box.dataHandlingWait();
	                $.get("../weixin/alipayOK.do",{
                    	"orderNo":param.orderNo
                    },function(data){
                    	if (data.success) {
                    		if(backurl){
                    			window.location.href=backurl;
                    		}else{
                    			window.location.href="../customer/paymoney.do";
                    		}
						}
                    });
                },
                cancel:function(res){
                    //支付取消
                	alert("支付取消!");
                    $.get("../weixin/alipayCancel.do",{
                    	"orderNo":param.orderNo
                    },function(data){
                    	if(backurl){
                    		window.location.href=backurl;
                    	}else{
                    		window.location.href="../customer/paymoney.do";
                    	}
                    });
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
	var pm="orderNo="+param.orderNo+
	"&total_fee="+param.total_fee+
	"&attach="+encodeURI(param.attach)+
	"&body="+encodeURI(param.body);
	var key=$.md5(pm);
	if (key!=param.key) {
		pop_up_box.loadWaitClose();
		alert("签名错误!");
		return;
	}
	$("#orderNo").html(param.orderNo);
	$("#attach").html(param.attach);
	$("#body").html(param.body);
	$("#total_fee").html(parseFloat(param.total_fee)/100);
	$("#shaoma").find("img").attr("src","/"+data.codeUrl);
	pop_up_box.loadWaitClose();
	setInterval(function(){
		$.get("../customer/getOrderPayState.do",{"orderNo":param.orderNo},function(data){
			if(data!="待支付"&&data!="支付中"){
				pop_up_box.showMsg("支付成功,返回首页", function(){
					window.location.href="../customer.do";
				});
			}
		});
	}, 5000);
});
}