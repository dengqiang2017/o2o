$(function(){
	 var nowPage=0;
	 var count=0;
	 var totalPage=0;
	 var itemhtml=$("#historyitem");
	$(".find").click(function(){
		nowPage=0;
		loadData();
	});
	loadData();
	function loadData(){
		$.get("getRepairHistory.do",{
			"searchKey":$("#searchKey").val(),
			"beginDate":$("#store_date").val(),
			"page":nowPage,
			"count":count
		},function(data){
			$.each(data.rows,function(i,n){
				var item=$(itemhtml.html());
				$(".row:eq(1)").append(item);
				item.find("li:eq(0)>span").html(new Date(n.repair_datetime).Format("yyyy-MM-dd hh:mm:ss"));
				item.find("li:eq(1)>span").html(n.position_big);
				item.find("li:eq(2)>span").html(n.position);
				item.find("li:eq(3)>span").html(n.item_name);
				item.find("li:eq(4)>span").html(n.sd_oq);
			});
			count=data.totalRecord;
			totalPage=data.totalPage;
		});
	}
	var addindex=0;
	$(window).scroll(function(){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (nowPage==totalPage) {
				}else{
					nowPage+=1;
					loadData();
				}
			}
		}
     });
});