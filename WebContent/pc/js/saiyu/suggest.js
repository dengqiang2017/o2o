$(function(){
	var name=window.location.href.split("?")[1].split("=")[0];
	var seeds_id=window.location.href.split("?")[1].split("=")[1];
	pop_up_box.loadWait();
	$.get("../saiyu/getSaiyuOAInfo.do",{name:seeds_id},function(data){
		pop_up_box.loadWaitClose();
		$("#OA_who").append(data.info.OA_who);
//		$("#accountStatement").attr("href","accountStatement.do?clientId="+data.customer_id+"&name="+data.info.OA_who);
//		$("#OA_what").append(data.info.OA_what);
		var infos=data.info.OA_what.split("|");
		$("#num").html(infos[0].replace( /&/gm,"<br>"));
		$("#no").html(infos[1].split(":")[1]);
//		$("#content").append(data.info.content);
//		$("#approvaler").val(data.info.approvaler);
		$("#ivt_oper_listing").val(data.info.ivt_oper_listing);
		$("#upper_customer_id").val(data.info.upper_customer_id);
		$("#store_date").append(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
	});
	/////////////选择推荐产品/////////
	function proinit(item){
		product.init(function(){
			$(".row").append(item);
			item.find("input:eq(0)").val($(".modal").find(".activeTable").find("input").val());
			item.find("#class_card").html($(".modal").find(".activeTable").find("td:eq(0)").html());
			item.find("#item_sim_name").html($(".modal").find(".activeTable").find("td:eq(1)").html());
			item.find("#item_spec").html($(".modal").find(".activeTable").find("td:eq(2)").html());
			item.find("#item_type").html($(".modal").find(".activeTable").find("td:eq(3)").html());
			item.find("#item_color").html($(".modal").find(".activeTable").find("td:eq(4)").html());
			item.find("#pronum").val($(".modal").find(".activeTable").find("td:eq(5)").html());
			item.find("#sd_unit_price").val($(".modal").find(".activeTable").find("td:eq(6)").html());
			item.find("#sort_name").html($(".modal").find(".activeTable").find("td:eq(8)").html());
//			$(".add").unbind("click");
			item.find(".add").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num) {
					num=0;
				}
				$(this).parent().find(".num").val(num+1);
				$(this).parent().find(".num").blur();
			});
//			$(".sub").unbind("click");
			item.find(".sub").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num) {
					$(this).parent().find(".num").val(0);
				}else{
					$(this).parent().find(".num").val(num-1);
				}
				$(this).parent().find(".num").blur();
			});
		});
//		$(".glyphicon-remove").unbind("click");
		item.find(".glyphicon-remove").click(function(){
			$(this).parents(".col-lg-4").remove();
		});
	}
	$("#tuiPro").click(function(){
		var item=$($("#item").html());
		var modalProd=$("#modalProd");
		if($.trim(modalProd.html())==""){
			$.get("../tree/productSelect.do",function(data){
				modalProd.html(data);
				proinit(item);
			});
		}else{
			$(".modal-cover,.modal").show();
			proinit(item);
		}
	});
	
	////////////////////////
	$("#save").click(function(){
		var  bxNo= $("#no").html();
		var itemids=$(".row").find(".form-group");
		if (itemids&&itemids.length>0) {
			var item_ids=[];
			for (var i = 0; i < itemids.length; i++) {
				var item=$(itemids[i]);
				var item_id=item.find("input:eq(0)").val();
				var num=item.find("#pronum").val();
				var sd_unit_price=item.find("#sd_unit_price").val();
				var itemdata={};
				itemdata.item_id=item_id;
				itemdata.num=num;
				itemdata.sd_unit_price=sd_unit_price;
				item_ids.push(JSON.stringify(itemdata));
			}
			pop_up_box.postWait();
			$.post("../saiyu/saveSuggest.do",{
				"item_ids":"["+item_ids.join(",")+"]",
//				"item_ids":item_ids,
				"bxNo":bxNo,//报修单号
				"spNo":$("#ivt_oper_listing").val(),  //审批单号
				"upper_customer_id":$("#upper_customer_id").val()
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						window.location.href="../employee/myOA.do";
					});
				} else {
					if(data.msg){
						pop_up_box.showMsg("保存错误!" + data.msg);
					}else{
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
			
			
		}else{
			pop_up_box.showMsg("请选择");
		}
	});
});