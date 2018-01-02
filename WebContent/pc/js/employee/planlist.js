var customer_id;
$(function() {
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
	});
	planlist.init();
});