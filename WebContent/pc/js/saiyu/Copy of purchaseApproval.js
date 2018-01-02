$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	backOa();
});
$(function(){
	$('a[data-title="phone"]').html("我的协同-采购审批");
	pop_up_box.loadWait();
	$.get("../saiyu/getSaiyuOAInfo.do",{"seeds_id":$("#seeds_id").val(),"type":"pur"},function(data){
		pop_up_box.loadWaitClose();
		var infos=data.info.OA_what.split("|");
		$("#info").html(infos[0].replace( /&/gm,"<br>"));
		$("#no").html(infos[1].split(":")[1]);
		$("#itempage").find("#spNo").val(data.info.ivt_oper_listing);
//		$("#itempage").find("#upper_customer_id").val(data.info.upper_customer_id);
		$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		$.each(data.list,function(i,n){
			var item=$($("#itempage").find("#puritem").html());
			$("#itempage").find(".row").append(item);
			item.find("input:eq(0)").val(n.item_id);
			item.find("li:eq(0)").html(n.item_name);
			item.find("#sd_unit_price").html(n.sd_unit_price);
			item.find("#casing_unit").html(n.casing_unit);
			item.find("#pronum").val(n.num);
			item.find("#item_unit").html(n.item_unit);
			if (n.pack_unit&&n.pack_unit>0) {
				item.find("#pack_unit").html(n.pack_unit);
			}else{
				item.find("#pack_unit").html("1");
			}
		});
		$(".glyphicon-remove").click(function(){
			$(this).parents(".col-lg-6").remove();
		});
		$("#itempage").find(".add").click(function(){
			var num=parseFloat($(this).parent().find(".num").val());
			if (!num) {
				num=0;
			}
			$(this).parent().find(".num").val(num+1);
			$(this).parent().find(".num").blur();
		});
//		$(".sub").unbind("click");
		$("#itempage").find(".sub").click(function(){
			var num=parseFloat($(this).parent().find(".num").val());
			if (!num) {
				$(this).parent().find(".num").val(0);
			}else{
				$(this).parent().find(".num").val(num-1);
			}
			$(this).parent().find(".num").blur();
		});
	});
	var itempage=$("#itempage");
	itempage.find("#saveOrder").click(function(){
		var item_ids=itempage.find(".row").find(".col-lg-6");
		if (item_ids&&item_ids.length>0) {
			var itemIds=[];
			for (var i = 0; i < item_ids.length; i++) {
				var item=$(item_ids[i]);
				var sd_unit_price=$.trim(item.find("#sd_unit_price").html());
				var pronum=parseFloat($.trim(item.find("#pronum").val()));
				var item_id=$.trim(item.find("#item_id").val());
				var casing_unit=$.trim(item.find("#casing_unit").html());//包装单位
				var item_unit=$.trim(item.find("#item_unit").html());//基本单位
				var pack_unit=$.trim(item.find("#pack_unit").html());//换算数量
				var c_memo=$.trim(item.find("#c_memo").html());
				if (pronum>0) {
					var itemdata={
							"item_id":item_id, 
							"num":pronum,
							"pack_unit":pack_unit,
							"casing_unit":casing_unit,
							"item_unit":item_unit,
							"c_memo":c_memo,
							"sd_unit_price":sd_unit_price
					}
					itemIds.push(JSON.stringify(itemdata));
				}
			}
			pop_up_box.postWait();
			$("#saveOrder").attr("disabled", "disabled");
			$.post("savePurchaseApproval.do",{
				"itemIds":itemIds,
				"upper_customer_id":$("#customer_id").val(),
				"spNo":$("#spNo").val(),
				"spyj":"同意",
				"ivt_oper_listing":$("#no").html(),
				"type":"client"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("数据提交成功!",function(){
						backOa();
					});
				}else{
					pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
				}
				$("#saveOrder").removeAttr("disabled");
			});
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
	
	
});
