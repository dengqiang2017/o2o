var browsingHistory={
		init:function(){
			var page=0;
			var count=0;
			var totalPage=0;
			function loadData(){
				pop_up_box.loadWait();
				$.get("../client/getProductViewPage.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"page":page,
					"isDate":false,
					"count":count
				},function(data){
					pop_up_box.loadWaitClose();
					if(data&&data.rows.length>0){
						$.each(data.rows,function(i,n){
							var item=$($("#xptsitem").html());
							$("#list").append(item);
							item.find("#item_name").html($.trim(n.item_name));
							item.find("#item_name").attr("title",$.trim(n.item_name));
							item.find("#cost_name").html("￥"+n.sd_unit_price);
							item.find("#view_time").html(n.view_time);
							item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
							item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
								window.location.href="commodity.jsp?com_id="+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
							});
						});
						count=data.totalRecord;
						totalPage=data.totalPage;
						if(data.rows.length<10){
							pop_up_box.toast("已全部加载");
						}
					}else{
						pop_up_box.toast("已全部加载");
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
	browsingHistory.init();
});