$(function(){
	//1.从cookie中获取数据,
	var orderInfo=$.cookie("productDetail");
	if(!orderInfo){
		orderInfo=$.cookie("productList");
	}
	if(!orderInfo){
		window.location.href="index.html";
	}
	//2.将参数传递到后台,获取订单相关数据与订单编号
	pop_up_box.loadWait();
	var list=$.parseJSON(orderInfo);
	var zje=0;
	for (var i = 0; i < list.length; i++) {
		var n=list[i];
		zje=zje+parseFloat(n.zsum)*parseFloat(n.sd_unit_price);
	}
	$(".amend").click(function(){
		$("textarea").removeAttr("readonly");
	});
	$("#amount").html(numformat2(zje));
	var orderlist=orderInfo;
	$.post("../product/getOrderInfo.do",{
		"orderInfo":orderInfo
	},function(data){
		pop_up_box.loadWaitClose();
		if(data){
			//3.将数据显示到页面上
//			var zje=0;
//			$.each(data.orderInfo,function(i,n){
//				zje=zje+parseFloat(n.je);
//			});
//			orderlist=JSON.stringify(data.orderInfo);
//			$("#amount").html(numformat2(zje));
			$("#orderNo").html(data.orderNo);
			$("textarea").val(data.FHDZ);
		}
	});
 $("#nowpay").click(function(){
	 pop_up_box.postWait();
	 $.post("../customer/savePaymoney.do",{
		 "orderNo":$("#orderNo").html(),
		 "amount":$("#amount").html(),
		 "FHDZ":$("textarea").val(),
		 "order":"neworder",
		 "orderlist":orderlist,
		 "account":"账上款",
		 "paystyletxt":$(".pos>span").html(),
		 "sum_si_origin":$(".pos>span").html(),
		 "paystyle":"JS000002"
	 },function(data){
		 pop_up_box.loadWaitClose();
		 if (data.success) {
			$.removeCookie("productDetail",{ path: '/'});
			$.removeCookie("productList",{ path: '/' });
			$.removeCookie("productDetail");
			$.removeCookie("productList");
			window.location.href="pay_success.html?"+data.msg;
		} else {
			if (data.msg) {
				pop_up_box.showMsg("保存错误!" + $("#orderNo").html());
			} else {
				pop_up_box.showMsg("保存错误!");
			}
		}
	 });
 });

});