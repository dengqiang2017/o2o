var login=false;
customer.getCustomer(function(b){
	if(b!=false){
		login=true;
	}
	coupon.init();
});
var coupon={
		init:function(){
			var page=0;
			var count=0;
			var totalPage=0;
			if(document.referrer==""||document.referrer.indexOf("coupon.jsp")>=0){
				$(".header>a").attr("href","index.jsp?com_id="+com_id);
			}else{
				$(".header>a").attr("href",document.referrer);
			}
			 pop_up_box.loadScrollPage(function(){
					if (page==totalPage) {
					}else{
						page+=1;
						loadData(); 
					}
				});
				function loadData(){
					pop_up_box.loadWait();
					$.get("../client/getCouponPage.do",{
						"searchKey":$.trim($("#searchKey").val()),
						"beginDate":$.trim($("#d4311").val()),
						"endDate":$.trim($("#d4312").val()),
						"com_id":com_id,
						"page":page,
						"count":count,
					},function(data){
						pop_up_box.loadWaitClose();
						if (data&&data.rows.length>0) {
							$.each(data.rows,function(i,n){
								var item=$($("#item").html());
								$("#list").append(item);
								item.find("#f_amount").html(n.f_amount);
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
								if(n.customer_id){
									item.find(".getcoupon").html("去使用");
									item.click(function(){
										window.location.href="product_display.jsp?com_id="+com_id;
									});
								}else{
									item.click(function(){
										var item=$(this);
										if(login==false){
											pop_up_box.showMsg("您还没有登录,请登录后再领取吧!",function(){
												$.cookie("backurl",window.location.href,{ path: '/', expires: 1 });
												window.location.href="../pc/login.jsp?com_id="+com_id;
											});
										}else{
											var ivt_oper_listing=item.find("#ivt_oper_listing").html();
											pop_up_box.postWait();
											$.post("../client/receiveCoupon.do",{
												"ivt_oper_listing":ivt_oper_listing
											},function(data){
												pop_up_box.loadWaitClose();
												if (data.success) {
													pop_up_box.toast("领取成功!",1500);
													item.find(".getcoupon").html("去使用!");
													item.unbind("click");
													item.click(function(){
														window.location.href="product_display.jsp?com_id="+com_id;
													});
												} else {
													if (data.msg) {
														pop_up_box.showMsg("领取错误!"
																+ data.msg);
													} else {
														pop_up_box.showMsg("领取错误!");
													}
												}
											});
										}
									});
								}
							});
						}
					});
				}
				$("#list").html("");
				loadData();
		}
}