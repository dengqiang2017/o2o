var customer_id;
$(function(){
	selectClient.init(function(customerId){
		tabsIndex=0;
		customer_id=customerId;
		$(".find:eq(0)").click();
	});
	order.init();
	////////////////
	$(".nav li:eq(2)>a").html("已下订单");
});  
