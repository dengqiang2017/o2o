$(function(){
	 var yesOrNo="";
	$(".nav-tabs li").click(function(){
		$(".find").click();
	});
	$(".find").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var param;
		var tabsContent=$(".tabs-content:eq("+lia+")");//代办事项
		var badge=$(".badge");//代办事项
		var danger;
		if (lia==0) {//代办事项
			param={
				"item_name":$("#sd_order_id").val(),
				"OA_who":$("#OA_who").val(),
				"store_date":$("#store_date").val(),
				"type_id":$("#type_id").val(),
				"yesOrNo":"" 
			}
			danger=$(".alert-danger");//代办事项子项
		}else if(lia==1){//已办事项子项
			danger=$(".alert-info");//已办事项子项
			param={"item_name":$("#sd_order_id").val(),"yesOrNo":"已办"};
			yesOrNo="已办";
		}else{//自己申请
			danger=$(".alert-info");//已办事项子项
			param={"ziji":"ziji"};
		}
		tabsContent.html("");
		pop_up_box.loadWait();
		$.get("getOAList.do",param,function(data){
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				var item=$(danger.parent().html());
				tabsContent.append(item);
				item.find("#OA_what_item").html(n.OA_what);
				item.find("#store_date_item").html(new Date(n.store_date).Format("yyyy-MM-dd hh:mm:ss"));
				item.find("#OA_who_item").html("");
				if (n.upper_customer_id) {
					if (lia==0) {
//						var no=n.OA_what.split("单号:")[1];
						item.find(".btn-danger").attr("href","../manager/clientTijian.do?seeds_id="+n.seeds_id
								+"&spNo="+n.ivt_oper_listing+"&customer_id="+n.upper_customer_id+"&approval_step="+n.approval_step);
					}else{
						item.find(".btn-primary").attr("href","edspalready.do?seeds_id="+n.seeds_id);
					}
				}else{
					if (lia==0) {
						item.find(".btn-danger").attr("href","quotaApproval.do?seeds_id="+n.seeds_id);
					}else if(lia==1){
						item.find(".btn-primary").attr("href","edspalready.do?seeds_id="+n.seeds_id);
						var clerk_id=$("#clerk_id").val();
						if(n.OA_whom!=clerk_id){
							item.find("#OA_who_item").html("【抄送】");
						}
					}else{
						item.find(".btn-primary").attr("href","edspalready.do?ivt_oper_listing="+n.ivt_oper_listing);
					}
				}
				if (!n.OA_who) {
					item.find("#OA_who_item").append("申请人:"+n.OA_who2);
				}else{
					item.find("#OA_who_item").append("申请人:"+n.OA_who);
				}
			});
			if (lia==0) {
				badge.html(data.totalRecord);
			}
		});
	});
	$(".find:eq(0)").click();
});