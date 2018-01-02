$(function(){
	//1.获取客户支付中状态的订单数据
	$.get("../customer/getOrderStatusPaying.do",function(data){
		if(data&&data.length>0){
			var orderzje=0;
			//2.列表展示
			$.each(data,function(i,n){
				var item=$($("#item").html());
				$("#list").append(item);
				item.find("#item_name").html(n.item_name);
				item.find("#seeds_id").html(n.seeds_id);
				item.find("#sd_oq").html(numformat(n.sd_oq,0));
				item.find("#sd_unit_price").html(numformat2(n.sd_unit_price));
				item.find("#je").html(numformat2(n.je));
				item.find("#item_unit").html(n.item_unit);
				orderzje+=parseFloat(n.je);
			});
			//3.计算商品支付总金额
			$("#orderzje").html(orderzje);
		}else{
			pop_up_box.showMsg("没有获取到数据,请重新进行下单");
		}
	});
	//4.获取客户默认收货地址
	var fhdzList=[];
	$.get("../customer/getFHDZList.do",function(data){
		if(data&&data.length>0){
			fhdzList=data;
			for (var i = 0; i < data.length; i++) {
				var n=data[i];
				if(n.mr){
					var item=$($("#fhdzItem").html());
					$("#fhInfo").html(item);
					item.find("#lxr").html(n.lxr);
					item.find("#lxPhone").html(n.lxPhone);
					item.find("#fhdz").html(n.fhdz);
					break;
				}
			}
		}
	});
	//5.更换收货地址
	//6.选择支付方式
	//7.生成付款单数据
	//8.开始支付
	//9.更新付款单状态
	
	
	
	
	
});