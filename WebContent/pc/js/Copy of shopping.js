$(function(){ 
	var shopping=getCookieval("shopping");
	var item=$("#item");
	if (shopping) {
		var item_ids=shopping.split(",");
		if (item_ids&&item_ids.length>0) {
			$.get("../product/getProductList.do",{
				"item_ids":shopping
			},function(datas){
				for (var i = 0; i < item_ids.length; i++) {
					var item_id = item_ids[i].split("_")[0];
					var num =parseFloat(item_ids[i].split("_")[1]);
					var item_id_c=getCookieval(item_id);
					if (item_id!="") {
						if (item_id_c) {
							for (var j = 0; j < item_ids.length; j++) {
								if(item_ids[j].indexOf(data.item_id)>=0){
									num=parseFloat(item_ids[j].split("_")[1]);
									break;
								}
							}
							var hasitemid=$(".row").find("input[value='"+item_id+"']");
							if (hasitemid.length>0) {
								var pronum=parseFloat($(".row").find("#pronum").val());
								$(".row").find("#pronum").val(pronum+num);
							}else{
//								var data=$.parseJSON(item_id_c);
								var data=datas[i];
								var itemhtml=$(item.html());
								$(".row").append(itemhtml);
								itemhtml.find("#sd_unit_price").html(data.sd_unit_price);
								itemhtml.find("#item_name").html(data.item_name);
								itemhtml.find("#casing_unit").html(data.casing_unit);
								itemhtml.find("#pronum").val(num);
								itemhtml.find("#item_id").val(data.item_id);
								itemhtml.find("a:eq(0)").attr("href","../product/productDetail.do?item_id="+item_id);
								itemhtml.find("#delshopping").click(function(){
									var item_id_del=$(this).parent().find("#item_id").val();
									var num=$(this).parent().find("#pronum").val();
									$.removeCookie(item_id_del);
									shopping=shopping.replace(item_id_del,"");
									setCookieval("shopping",shopping);
									$(this).parents(".product").remove();
								});
							}
						}else{
							shopping=shopping.replace(item_id,"");
							setCookieval("shopping",shopping);
						}
					}else{
						if (num) {
							shopping=shopping.replace("_"+num,"");
						}else{
							shopping=shopping.replace(",","");
						}
						setCookieval("shopping",shopping);
						$.removeCookie("shopping");
						localStorage.removeItem("shopping");
					}
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
			$(".add").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num) {
					num=0;
				}
				$(this).parent().find(".num").val(num+1);
				$(this).parent().find(".num").blur();
			});
			$(".sub").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num) {
					$(this).parent().find(".num").val(0);
				}else{
					$(this).parent().find(".num").val(num-1);
				}
				$(this).parent().find(".num").blur();
			});
			$("#orderpay").click(function(){
				var chks=$(".pro-checked");
				if (chks&&chks.length>0) {
						var data="";
						for (var i = 0; i < chks.length; i++) {
							var item=$(chks[i]).parents(".product");
							var item_id=item.find("#item_id").val();
							var num=item.find("#pronum").val();
							var str=item_id+"_"+num;
							data=str+","+data;
						}
						if (data!="") {
							setCookieval("ordershopping",data);
						}
						setCookieval("backurl",window.location.href);
						window.location.href="../pc/login.html";
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
		}else{
			$("#orderpay").hide();
			$(".row").html("您的购物车空空如也,<a href='product.html'>快去选择喜爱的产品吧</a>");
		}
	}else{
		$("#orderpay").hide();
		$(".row").html("您的购物车空空如也,<a href='product.html'>快去选择喜爱的产品吧</a>");
	}
});


