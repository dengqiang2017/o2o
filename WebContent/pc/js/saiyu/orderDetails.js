var orderDetails={
		init:function(){
			$("#itempage").find("#orderpay").click(function(){
				var orderNo=event.data.orderNo;
				pop_up_box.loadWait();
				$.get("cashierPayment.do",{
					"orderNo":"${requestScope.orderNo}"
				},function(data){
					pop_up_box.loadWaitClose();
					$('a[data-title="title"]').html("我的订单-订单支付");
					$("#orderlist").hide();
					$("#itempage").html(data);
					$("a[data-head]").unbind("click");
					$("a[data-head]").click(backlist);
				});
			});
			$("#itempage").find("#allcheck").click(function(){
				var b=$(this).hasClass("pro-checked");
			    if (b) {
			    $("#itempage").find(".pro-check").removeClass("pro-checked");
			    }else{
			    $("#itempage").find(".pro-check").addClass("pro-checked");
			    }
			});
			$("#itempage").find(".section-one-container").find(".pro-check").click(function(){
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
			$("#itempage").find("#qrsh").click(function(){
				var t=$(this);
				var items=$("#itempage").find(".pro-checked");
				if(items&&items.length>0){
					var itemids=[];
					for (var i = 0; i < items.length; i++) {
						itemids.push($(items[i]).parents("li").find("input").val());
					}
					if(confirm("是否对勾选的商品进行收货操作!")){
					$.post("confimShouhuo.do",{
						"orderNo":"${requestScope.orderNo}",
						"itemids":"["+itemids.join(",")+"",
						},function(data){
						if (data.success) {
							pop_up_box.showMsg("提交成功!",function(){
								backlist();
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("提交错误!" + data.msg);
							} else {
								pop_up_box.showMsg("提交错误!");
							}
						}
					});
				}
				}else{
					pop_up_box.showMsg("请至少选择一个产品进行收货!");
				}
			});
		}
}