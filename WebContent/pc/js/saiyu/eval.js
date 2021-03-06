$(function(){
	var page=0;
	var count=0;
	var evalitem=$("#evalitem").html();
	function loadData(pagec,countc){
		pop_up_box.loadWait();
		$.get("getEvalOrderInfo.do",{
			"page":pagec,
			"count":countc,
			"searchKey":$("#searchKey").val(),
			"elecState":$("#elecState").val(),
//			"endDate":$("input[name='endTime']").val(),
			"beginDate":$("input[name='beginTime']").val()
		},function(data){
			pop_up_box.loadWaitClose();
			$("#evallist").html("");
			if(data&&data.rows&&data.rows.length>0){
				$.each(data.rows,function(i,n){
					var item=$(evalitem);
					$("#evallist").append(item);
					item.find("li:eq(0)>span").html(n.ivt_oper_listing);
					item.find("li:eq(1)").append(n.confirm_je);
					if(n.dian_complete_confirm=="0"){
						item.find("li:eq(2)").append("未安装");
						item.find("#azwcbtn").show();
						item.find("#azwcbtn>button").click({"orderNo":n.ivt_oper_listing},function(event){
							if(confirm("是否确认安装完成!")){
								var t=$(this).parent();
								var orderNo=event.data.orderNo;
								$.get("anzconfirm.do",{
									"orderNo":orderNo
								},function(data){
									if (data.success) {
										pop_up_box.showMsg("提交成功!",function(){
											t.find("li:eq(2)").html("已安装!");
											t.hide();
										});
									} else {
										if (data.msg) {
											pop_up_box.showMsg("提交错误!" + data.msg);
										} else {
											pop_up_box.showMsg("提交错误!");
										}
									}
								});
							}
						});
					}else{
						item.find("li:eq(2)").append("已安装");
						item.find("#azwcbtn").hide();
					}
					if(n.dian_complete_datetime){
						item.find("li:eq(3)").append(new Date(n.dian_complete_datetime).Format("yyyy-MM-dd hh:mm:ss"));
					} 
					item.find("#ckxqbtn>button").click({"orderNo":n.ivt_oper_listing},function(event){
						var orderNo=event.data.orderNo;
						$(".container").hide();
						$(".container:eq(1)").show();
						var anzfy=0;
						$("#anz_orderlist").html("");
						$.get("../saiyu/getOrderDetails.do",{"ivt_oper_listing":orderNo},function(data){
							pop_up_box.loadWaitClose();
//							$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
							$.each(data,function(i,n){
								var item=$($("#an_item").html());
								$("#anz_orderlist").append(item);
								item.find("ul>li:eq(0)").find("span").html(n.ivt_oper_listing);
								item.find("ul>li:eq(1)").find("span").html(n.item_name);
								item.find("ul>li:eq(2)").find("span").html(numformat2(n.sd_oq));
								item.find("ul>li:eq(3)").find("span").html(numformat2(n.AZTS_free));
								if(n.casing_unit){
									item.find("ul>li:eq(3)").append("/"+n.casing_unit);
								}
								anzfy=anzfy+(n.sd_oq*n.AZTS_free);
							});
							$("#azfy").html(numformat2(anzfy));
						});
					});
//					item.find("li:eq(0)").append(n.item_name);
//					if(n.casing_unit){
//						item.find("li:eq(1)").append(n.sd_oq+"/"+n.casing_unit);
//					}else{
//						item.find("li:eq(1)").append(n.sd_oq);
//					}
//					item.find("#item_id").append(n.item_id);
//					item.find("li:eq(2)").append(n.AZTS_free);
//					item.find("li:eq(3)").append(numformat2(n.AZTS_free*n.sd_oq));
//					item.find("li:eq(4)>span").html(n.orderNo);
//					item.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
//						var b=$(this).hasClass("pro-checked");
//						if (b) {
//							$(this).removeClass("pro-checked");
//						}else{
//							$(this).addClass("pro-checked");
//						}
//					});
				});
			}
		});
	}
	$("#allcheck").bind("click",function(){
		var b=$(this).hasClass("pro-checked");
        if (b) {
        $(".pro-check").removeClass("pro-checked");
        }else{
        $(".pro-check").addClass("pro-checked");
        }
	});
	$(".find").click(function(){
		loadData(0,0);
	});
	$(".find:eq(0)").click();
	$("#diangongbtn").click(function(){
		var chks=$("#evallist").find(".pro-checked");
		if(chks&&chks.length>0){
			var list=[];
			for (var i = 0; i < chks.length; i++) {
				var item=$(chks[i]).parnet();
				var orderNo=item.find("li:eq(4)>span").html();
				var item_id=item.find("#item_id").val();
				list.push(JSON.stringify({"orderNo":orderNo,"item_id":item_id}));
			}
			pop_up_box.postWait();
			$.post("anzconfirm.do",{
				"list":list
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("提交成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请选择已安装的产品!");
		}
	});
});

function backlist(){
	$(".container").hide();
	$(".container:eq(0)").show();
}