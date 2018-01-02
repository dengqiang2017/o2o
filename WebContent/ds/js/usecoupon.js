var usecoupon={
		init:function(){
			var page=0;
			var count=0;
			var totalPage=0;
			var sum_si=$("#sum_si").html();
			loadData();
			function loadData(){
				pop_up_box.loadWait();$(".contant").html("");
				$.get("../client/getCanUseCoupon.do",{
					"sum_si":sum_si,
					"com_id":com_id
				},function(data){
					pop_up_box.loadWaitClose();
					if (data&&data.length>0) {
						$.each(data,function(i,n){
							var item=$($("#item").html());
							$(".contant").append(item);
							item.find("#f_amount").html(n.f_amount);
							item.find("#seeds_id").html(n.seeds_id);
							item.find("#up_amount").html(n.up_amount);
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							item.find("#type_id").html(n.type_id);
							if(n.type_name){
								item.find("#type_name").html("仅可购买【"+n.type_name+"】商品");
							}else{
								item.find("#type_name").html("全品类");
							}
							item.find("#begin_use_date").html(n.begin_use_date);
							item.find("#end_use_date").html(n.end_use_date);
							item.find("#use").click(function(){
								var yhqNo=$(this).parents(".yhq").find("#ivt_oper_listing").html();
								var yhqAmount=$(this).parents(".yhq").find("#f_amount").html();
								var seeds_id=$(this).parents(".yhq").find("#seeds_id").html();
								$("#yhqNo").html(yhqNo);
								$("#yhqAmount").html(yhqAmount);
								$("#yhqId").html(seeds_id);
								getSumSi();
								$('#selectYhq').hide();$('#paypage').show();
							});
					});
					}else{
						if($(".contant").length<=1){
							$(".contant").html("很遗憾<br>您暂无可以使用的优惠券");
						}
					}
					$("#count").html(data.length);
				});
			}
		}
}