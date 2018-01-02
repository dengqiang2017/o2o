$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	backOa();
});
$(function(){
	$('a[data-title="phone"]').html("我的协同-协同审批");
	pop_up_box.loadWait();
	var approval_step=0;
	$.get("../saiyu/getSaiyuOAInfo.do",{"seeds_id":$("#seeds_id").val(),"type":"order"},function(data){
		pop_up_box.loadWaitClose();
		var infos=data.info.content.split("|");
		$("#info").html(infos[0].replace( /&/gm,"<br>"));
		$("#no").html(infos[1].split(":")[1]);
		$("#itempage").find("#spNo").val(data.info.ivt_oper_listing);
		$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		$("#itempage").find(".row").html("");
		var sumSi=0;
		approval_step=data.info.approval_step;
		$.each(data.list,function(i,n){
			var item=$($("#itempage").find("#puritem").html());
			$("#itempage").find(".row").append(item);
			item.find("li:eq(0)").html(n.item_name);
			item.find("#sd_unit_price").html(n.sd_unit_price);
			item.find("#casing_unit").html(n.casing_unit);
			item.find("#pronum").html(n.num);
			item.find("#item_unit").html(n.item_unit);
			sumSi=sumSi+parseFloat(n.sd_unit_price)*parseFloat(n.num);
			if (n.pack_unit&&n.pack_unit>0) {
				item.find("#pack_unit").html(n.pack_unit);
			}else{
				item.find("#pack_unit").html("1");
			}
		});
		$("#sunSi").html(numformat2(sumSi));
	});
	
	$("#save").click(function(){
		pop_up_box.postWait();
		$.post("saveApprovalInfo.do",{
			"spyj":$("#spyj").val(),
			"spNo":$("#spNo").val(),
			"approval_step":approval_step,
			"ivt_oper_listing":$("#no").html()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!",backOa);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	});
	$("#saveOrder").click(function(){
		
	});
});