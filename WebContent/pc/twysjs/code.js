$(function(){
	weixinShare.init('邀请注册','邀请客户注册');
	function getQueryString(key) {
	    var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) {
	    	return unescape(r[2]); 
	    }
	    return null;
	}
	var com_id=getQueryString("com_id");
	var clerk_id=getQueryString("clerk_id");
	var customer_id=getQueryString("customer_id");
	var lian="";
	if(window.location.href.indexOf("?")>0){
		lian="&";
	}else{
		lian="?";
	}
	if (window.location.href.split("&").length>3) {
		return;
	}
	if (com_id&&customer_id&&!clerk_id) {
		$("#qrcode").parent().show();
		$("#sellbuy").hide();
		$("#qrcode").attr("src","../"+com_id+"/register/"+customer_id+"/register.jpg?ver="+Math.random());
	}else{
		pop_up_box.loadWait();
		$.get("../customer/getCustomer.do",function(data){
			pop_up_box.loadWaitClose();
			if(data){
				pop_up_box.loadWait();
				$.get('../customer/generateRegisterQRCode.do',{
					"logo":"pc/image/logo100.png",
					"width":300,
					"height":300,
					"image_width":90,
					"image_height":90
				},function(dataimg){
					pop_up_box.loadWaitClose();
					if (dataimg.success) {
//						$("#qrcode").attr("src",".."+data.msg); 
						window.location.href=window.location.href+lian+"com_id="+data.com_id+"&customer_id="+data.customer_id;
					}
				});
			}
		});
	}

	if (com_id&&clerk_id&&!customer_id) {
		$("#qrcode").parent().hide();
		$("#sellbuy").show();
		 $("#qrcode_sell").attr("src","../"+com_id+"/register/"+clerk_id+"/registersell.jpg?ver="+Math.random());
		 $("#qrcode_buy").attr("src","../"+com_id+"/register/"+clerk_id+"/registerbuy.jpg?ver="+Math.random());
	}else{
		pop_up_box.loadWait();
		$.get("../employee/getEmployee.do",function(data){
			pop_up_box.loadWaitClose();
			if(data.clerk_id){
				pop_up_box.loadWait();
				$.get('../employee/generateRegisterQRCode.do',{
					"logo":"pc/image/logo100.png",
					"type":"sell",
					"width":300,
					"height":300,
					"image_width":90,
					"image_height":90
				},function(dataimg){
					pop_up_box.loadWaitClose();
					if (dataimg.success) {
//						$("#qrcode_sell").attr("src",".."+data.msg);
						$.get('../employee/generateRegisterQRCode.do',{
							"logo":"pc/image/logo100.png",
							"type":"buy",
							"width":300,
							"height":300,
							"image_width":90,
							"image_height":90
						},function(dataimg){
							if (dataimg.success) {
								window.location.href=window.location.href+lian+"com_id="+data.com_id+"&clerk_id="+data.clerk_id;
//							$("#qrcode_buy").attr("src",".."+data.msg);
							}
						});
					}
				});
			}
		});
	}
})