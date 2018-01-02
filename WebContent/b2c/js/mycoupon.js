customer.getCustomerInfo(function(b){
	mycoupon.init();
});
var mycoupon={
		init:function(){
			var page=0;
			var count=0;
			var totalPage=0;
			$(".nav li").click(function(){
				var flag=$(".nav li").index(this);
				if($(".tab-pane").eq(flag).length<=1){
					$(".tab-pane").eq(flag).html("");
					 page=0;
					 count=0;
					loadData(flag);
				}
			});
			loadData('0');
			function loadData(flag){
//				var flag=($(".nav .active"));
				var date="";
				if(flag!=1){
					date=new Date().Format("yyyy-MM-dd");
				}
				pop_up_box.loadWait();
				$.get("../client/getClientCoupon.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"beginDate":$.trim($("#d4311").val()),
					"endDate":$.trim($("#d4312").val()),
					"date":date,
					"flag":flag,
					"com_id":com_id,
					"page":page,
					"count":count,
				},function(data){
					pop_up_box.loadWaitClose();
					if (data&&data.rows.length>0) {
						$.each(data.rows,function(i,n){
							var item=$($("#item").html());
							$(".tab-pane").eq(flag).append(item);
							item.find("#f_amount").html(n.f_amount);
							item.find("#up_amount").html(n.up_amount);
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							item.find("#type_id").html(n.type_id);
							if(n.type_name){
								item.find("#type_name").html("仅可购买【"+n.type_name+"】");
							}else{
								item.find("#type_name").html("全品类");
							}
							item.find("#begin_use_date").html(n.begin_use_date);
							item.find("#end_use_date").html(n.end_use_date);
							if(flag!=0){
								item.find("#use").hide();
							}
					});
					}else{
						if($(".tab-pane").eq(flag).length<=1){
							$(".tab-pane").eq(flag).html("无优惠券");
						}
					}
//					$(".nav .active").find("span").html(data.totalRecord);
				});
			}
		}
}