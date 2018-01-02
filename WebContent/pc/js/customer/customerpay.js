$(function(){
//	pop_up_box.loadWait();
	removeCookie();
	return;
	var orderpay=getCookieval("orderpay");
	var s_n=getCookieval("s_n");
	var order_b=(ifnull(orderpay)!="");
	var b=window.location.href.indexOf("saiyu")>0;
	var perx="";
	if(b){
		perx="../";
	}
	if(order_b){
		pop_up_box.postWait();
		$.post(perx+"customer/orderpay.do",{
			"orderpay":orderpay,
			"s_n":s_n
		},function(data){
			pop_up_box.loadWaitClose();
			if(data.success){
				removeCookie();
				window.location.href=perx+"customer/orderConfirm.do";
			}
		});
	}else{
		var ordershopping=getCookieval("ordershopping");
		if (ordershopping) {
			pop_up_box.postWait();
			$.post("product/postShopping.do",{
				"shopping":ordershopping.substring(0,ordershopping.length-1),
				"s_n":s_n
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					removeCookie();
					window.location.href=perx+"customer/orderConfirm.do";
				}
			});
		}
//		else{
//			var shopping=getCookieval("shopping");
//			if(shopping){
//				pop_up_box.postWait();
//				$.post(perx+"customer/shopping.do",{
//					"shopping":shopping
//				},function(data){
//					pop_up_box.loadWaitClose();
//					if(data.success){
//						removeCookie();
//						if(!order_b){
//							window.location.href=perx+"customer/orderConfirm.do";
////							window.location.href=perx+"customer/myorder.do";
//						}
//					}
//				});
//			}
//		}
	}
	

//	function getCookieval(key){
//		var shopping=$.cookie(key);
//		if(!shopping){
//			shopping=localStorage.getItem(key);
//		}
//		return shopping;
//	}
//	function removeCookie(){
//		$.removeCookie("orderpay");
//		localStorage.removeItem("orderpay");
//		
//		$.removeCookie("ordershopping");
//		localStorage.removeItem("ordershopping");
//		var shopping=getCookieval("shopping");
//		if(shopping){
//			var shoppings=shopping.split(",");
//			for (var i = 0; i < shoppings.length; i++) {
//				$.removeCookie(shoppings[i].split("_")[0]);
//				localStorage.removeItem(shoppings[i].split("_")[0]);
//			}
//		}
//		$.removeCookie("shopping");
//		localStorage.removeItem("shopping");
//		
//		$.removeCookie("zhixun");
//		localStorage.removeItem("zhixun");
//	}
	pop_up_box.loadWaitClose();
});