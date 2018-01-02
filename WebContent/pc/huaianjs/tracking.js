$(function(){
	var params=window.location.href.split("?")[1];
	var orderitem=$("#orderitem");
	var historyitem=$("#historyitem");
	$.get("../orderTrack/getOrderInfo.do",{"params":params},function(data){
		if(data.orderInfo&&data.orderInfo.length>0){
			$("#orderlist").html("");
			$.each(data.orderInfo,function(i,n){
				var item=$(orderitem.html());
				$("#orderlist").append(item);
				item.find("#item_name").html(n.item_name);
				item.find("#sum_si").html(numformat2(n.sum_si));
				item.find("#sd_oq").html(n.sd_oq+"/"+n.item_unit);
				$("#orderNo").html(n.ivt_oper_listing);
				item.find("#sd_unit_price").html(n.sd_unit_price);
				item.find("img:eq(0)").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
				item.find("img:eq(0)").error(function(){
					$(this).remove();
				});
			});
		}
		if(data.historyInfo&&data.historyInfo.length>0){
			$("#historylist").html("");
			var hisitem;
			for (var i = 0; i < data.historyInfo.length; i++) {
				var n=data.historyInfo[i];
				var item=$(historyitem.html());
				if (i==0) {
					$("#historylist").append(item);
				}else{
					hisitem.before(item);
				}
				hisitem=item;
				item.find("#time").html(n.time);
				item.find("#content").html(n.content);
				if(i==(data.historyInfo.length-1)){
					item.find(".state_img02>img").attr("src","images/07_ring.png");
					item.find(".state_img02").addClass("state_img01");
					item.find(".li_margin02").addClass("li_margin");
				}
			}
		}
	});
});