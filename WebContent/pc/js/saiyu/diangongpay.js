$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	try {
		if(backelec){
			backelec();
		}else{
			backlist();
		}
	} catch (e) {
		backlist();
	}
});
function showelec(){
	$("#itempage").show();
	$("#backelec").html("");
}
var diangongpay={
		init:function(){
			$('a[data-title="title"]').html("电工安装费支付");
			pop_up_box.loadWait();
			var orderlist=[];
			var xsskNo;
			var orderNo; 
			$.get("../customer/getPaymoneyNo.do",function(data){
				xsskNo=data;
			});
			var anzfy=0;
			$.get("../saiyu/getOrderDetails.do",{"ivt_oper_listing":$("#orderNo").val()},function(data){
				pop_up_box.loadWaitClose();
//				$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
				$.each(data,function(i,n){
					var item=$($("#an_item").html());
					$("#anz_orderlist").append(item);
					item.find("ul>li:eq(0)").find("span").html(n.ivt_oper_listing);
					item.find("ul>li:eq(1)").find("span").html(n.item_name);
					item.find("ul>li:eq(2)").find("span").html(numformat2(n.sd_oq));
					item.find("ul>li:eq(3)").find("span").html(numformat2(n.AZTS_free));
					if(n.casing_unit){
						item.find("ul>li:eq(3)").append("/"+n.casing_unit);
					}
					anzfy=anzfy+(n.sd_oq*n.AZTS_free);
				});
				$("#azfy").html(numformat2(anzfy));
			});
			$('.footer2').click(function(){
		        $('.process-zz').toggle('slow');
		    });
			var itempage=$("#itempage");
			$(".process-zz").find("li").click(function(){
				var paystyle=$.trim($(this).find("span").text());
					pop_up_box.postWait();
					$.post("saveEvalOrderPay.do",{
						"xsskNo":xsskNo,
						"orderNo":$("#orderNo").val(),
						"dian_customer_id":$("#dian_customer_id").val(),
						"amount":$.trim($("#azfy").html()),
						"anz_datetime":$.trim($("#anz_datetime").html()),
						"paystyle":paystyle 
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							var zftl=$(".zftl")
							if ($.trim(zftl.text())=="支付宝") {
								$("form").submit();
								pop_up_box.showMsg("支付完成!",function(){
									backlist();
								});
							}else if ($.trim(zftl.text())=="微信支付") {
								$("form").attr("action","../weixin/alipay.do");
								$("form").submit();
								pop_up_box.showMsg("支付完成!",function(){
									backlist();
								});
							}else{
								pop_up_box.showMsg("数据提交成功!",function(){
									backlist();
								});
							}
						}else{
							pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
						}
						$("#saveOrder").removeAttr("disabled");
					});
			});
		}
}
