//1.判断是否登录
 $.get("../customer/getCustomer.do",function(data){
 	 if(!data){
 		//没有登录就去登录
 		 $.cookie("backurl","shopping.html?com_id="+com_id,{ path: '/', expires: 1 });
 		 window.location.href="login.html?com_id="+com_id;
 	 }
 });
$(function(){
	//加载购物车订单
	var item=$("#item");
	$.get("../product/getShopping.do",{
		"com_id":com_id
	},function(data){
		if(data&&data.rows.length>0){
			$(".rowitem").html("");
			$.each(data.rows,function(i,n){
				var itemhtml=$(item.html());
				$(".rowitem").append(itemhtml);
				itemhtml.find("#sd_unit_price>strong").html(n.sd_unit_price);
				itemhtml.find("#orderNo").html(n.ivt_oper_listing);
				itemhtml.find("#seeds_id").html(n.seeds_id);
				itemhtml.find("#item_name").html(n.item_name);
				itemhtml.find("#casing_unit").html(n.casing_unit);
				itemhtml.find("#item_unit").html(n.item_unit);
				itemhtml.find("#item_spec").html(n.item_spec);
				itemhtml.find("#item_type").html(n.item_type);
				itemhtml.find("#pack_unit").html(n.pack_unit);
				itemhtml.find("#sd_oq").html(n.sd_oq);
				itemhtml.find("#pronum").val(n.sd_oq);
				itemhtml.find(".zsum").val(numformat(n.sd_oq/n.pack_unit,0));
//				itemhtml.find("#pronum,.zsum").attr("readonly","readonly");
				itemhtml.find("#item_id").val($.trim(n.item_id));
				itemhtml.find("#com_id").html("所属运营商:"+$.trim(n.com_id));
				itemhtml.find("a:eq(0)").attr("href","../product/productDetail.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id));
				if (itemhtml.find("img").length>0) {
					itemhtml.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
				}
				itemhtml.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
			itemhtml.find("#delshopping").click(function(){
				if(confirm("是否删除该产品!")){
					var t=$(this);
					var orderNo=$.trim(t.parents(".pro-msg").find("#orderNo").html());
					var seeds_id=$.trim(t.parents(".pro-msg").find("#seeds_id").html());
					$.post("../product/delShopping.do",{
						"orderNo":orderNo,
						"seeds_id":seeds_id
					},function(data){
						if (data.success) {
							t.parents(".product").remove();
						}else{
							pop_up_box.showMsg("删除失败:"+data.msg);
						}
					});
				}
			});
			jisuannum(itemhtml.find(".zsum"));
			function jisuannum(t){
				var num=parseFloat(t.parents(".product").find(".zsum").val());
				var pack_unit=parseFloat(t.parents(".product").find("#pack_unit").html());
				var sd_unit_price=parseFloat(t.parents(".product").find("#sd_unit_price>strong").html());
				if(!pack_unit){
					pack_unit=1;
				}
				t.parents(".product").find("#pronum").val(numformat(num*pack_unit,0));
				t.parents(".product").find("#sumsi").html("金额:￥"+numformat2(num*pack_unit*sd_unit_price));
			}
			
			itemhtml.find(".add").click(function(){
				var num=parseFloat($(this).parent().find(".zsum").val());
				if (!num) {
					num=0;
				}
				$(this).parent().find(".zsum").val(num+1);
				jisuannum($(this));
			});
			itemhtml.find(".sub").click(function(){
				var num=parseFloat($(this).parent().find(".zsum").val());
				if (!num) {
					$(this).parent().find(".zsum").val(0);
				}else{
					$(this).parent().find(".zsum").val(num-1);
				}
				jisuannum($(this));
			});
			
			});
		}else{
			$("#orderpay").hide();
			$(".rowitem").html("您的购物车空空如也,<a href='product.html?com_id="+com_id+"'>快去选择喜爱的产品吧</a>");
		}
	});
	///结算订单
	$("#orderpay").click(function(){
		var chks=$(".pro-checked");
		if (chks&&chks.length>0) {
				var seeds="";
				var list=[];
				for (var i = 0; i < chks.length; i++) {
					var item=$(chks[i]).parents(".product");
					var num=parseFloat(item.find("#pronum").html());
					if(num>=1){
						var seeds_id=$.trim(item.find("#seeds_id").html());
						list.push(JSON.stringify({"num":num,"seeds_id":seeds_id}));
					}
				}
				if(list.length>0){
					pop_up_box.postWait();
					$.post("../customer/orderpay.do",{
						"type":"shopping",
						"list":"["+list.join(",")+"]",
					},function(data){
						if (data.success) {
							window.location.href="../customer/orderConfirm.do";
						} else {
							if (data.msg) {
								pop_up_box.showMsg("保存错误!" + data.msg);
							} else {
								pop_up_box.showMsg("保存错误!");
							}
						}
					});
				}else{
					pop_up_box.showMsg("购买数量不能为0");
				}
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
});
String.prototype.replaceAll = function(s1,s2) {
    return this.replace(new RegExp(s1,"gm"),s2); 
}

