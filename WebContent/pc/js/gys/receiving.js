var headship=$("#headship").val();
$(".btn-primary:eq(1)").click(function(){
	if(headship!="财务"){
		var items=$(".col-lg-4").find(".pro-checked");
		if((items&&items.length>0)){
			var st_auto_no;
			for (var i = 0; i < items.length; i++) {
				st_auto_no=$(items[i]).parent().find("ul").find("span").html();
			}
			pop_up_box.postWait();
			$.get("entryNotice.do",{
				"gysname":$("#gysname").html(),
				"st_auto_no":st_auto_no,
				"description":"您有一条来自【"+map.get("gysname")+"】的采购订单已收货入库,请进行订单核货处理",
				"title":"采购订单已收货入库,请进行订单核货处理",
				"headship":headship
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("提交成功!",function(){
						window.location.href="../pc/index.html";
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请选择已经录入的产品!");
		}
	}else{
		var items=$(".col-lg-4").find(".pro-checked");
		if((items&&items.length>0)){
			var list=[];
			var stAuto_no;
			for (var i = 0; i < items.length; i++) {
				var item=$(items[i]).parent();
				var item_id=item.find("input").val();
				var st_auto_no=item.find("ul").find(".orderNo").html();
				var sd_oq=item.find("ul").find(".num").html();
				var store_struct_id=item.find("ul").find(".store_struct_id").html();
				if(!store_struct_id){
					store_struct_id="";
				}
				stAuto_no=st_auto_no;
				var json={"item_id":item_id,"st_auto_no":st_auto_no,"sd_oq":sd_oq,"store_struct_id":store_struct_id};
				list.push(JSON.stringify(json));
			}
			pop_up_box.postWait();
			$.get("noticeReceipt.do",{
				"st_auto_no":stAuto_no,
				"gysname":$("#gysname").html(),
				"store_struct_id":$("#store_struct_id").html(),
				"phone":$("#phone").html(),
				"weixinID":$("#weixinID").html(),
				"m_flag":$("#m_flag").val(),
				"headship":headship,
				"list":list
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("提交成功!",function(){
						window.location.href="../pc/index.html";
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请选择已经收货的产品!");
		}
	}
	
});
$("#allcheck").bind("click",function(){
	var b=$(this).hasClass("pro-checked");
    if (b) {
    $(".pro-check").removeClass("pro-checked");
    }else{
    $(".pro-check").addClass("pro-checked");
    }
});
$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
	var b=$(this).hasClass("pro-checked");
	if (b) {
		$(this).removeClass("pro-checked");
	}else{
		$(this).addClass("pro-checked");
	}
});