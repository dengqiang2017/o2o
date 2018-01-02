var jinbi={
		init:function(){
			if(document.referrer.indexOf("login.jsp")>=0){
				$(".header_left").attr("href","index.jsp?com_id="+com_id);
			}else{
				$(".shopping_back>a").attr("href",document.referrer);
			}
			pop_up_box.loadWait();
			$.get("../client/getQiandaoInfo.do",function(data){
				pop_up_box.loadWaitClose();
				//1.获取当前客户的总金币
				$("#totalJinbi").html(data.totalJinbi);
				//2.今天是否已经签到
				if(data.success){
					$("#qiandao").attr("disabled","disabled");
					$("#qiandao").html("已签到");
				}else{
					$("#qiandao").html("签到领金币");
					$("#qiandao").click(function(){
						//生成签到数据
						pop_up_box.loadWait();
						$.get("../client/qiandao.do",function(data){
							pop_up_box.loadWaitClose();
							//本次签到金币数
							if(data.success){
								pop_up_box.showMsg("签到成功!本次获取金币数:"+data.jinbi);
								//总金币数
								$("#totalJinbi").html(data.totalJinbi);
							}else{
								pop_up_box.showMsg("已签到");
							}
							$("#qiandao").attr("disabled","disabled");
							$("#qiandao").html("已签到");
						});
						//增加总金额
					});
				}
			});
			//获取产品信息加载在下部,并滚动加载更多
			var page=0;
			var count=0;
			var totalPage=0;
			function loadData(){
				pop_up_box.loadWait();
				$.get("../product/getZEROMOrderProduct.do",{
					"com_id" :com_id,
					"page":page,
					"count":count,
					"rows" :10
				},function(data){
					pop_up_box.loadWaitClose();
					if(data&&data.rows.length>0){
						$.each(data.rows,function(i,n){
							var item=$($("#xptsitem").html());
							$("#list").append(item);
							item.find("#item_name").html($.trim(n.item_name));
							item.find("#item_name").attr("title",$.trim(n.item_name));
							item.find("#cost_name").html("￥"+n.sd_unit_price);
							if(n.sd_unit_price!=n.price_display){
								item.find("#price_display").html("￥"+n.price_display);
							}
							item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
							item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
								window.location.href="commodity.jsp?com_id="+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
							});
						});
					}
				});
			}
			loadData(); 
			 pop_up_box.loadScrollPage(function(){
					if (page==totalPage) {
					}else{
						page+=1;
						loadData(); 
					}
				});
		}
}
customer.getCustomerInfo(function(){
	jinbi.init();
});