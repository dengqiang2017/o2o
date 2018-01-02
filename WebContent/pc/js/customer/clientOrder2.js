function likai(){
//	alert("1223");
}
removeCookie();
$(function(){
	var FHDZ=$("input[name='FHDZ']");
	var orderlist=[];
	/////////////////////////////////////////
	pop_up_box.loadWait();
	$.get("getPayOderRecord.do",function(data){
		pop_up_box.loadWaitClose();
		var list=data.list;
		if (!list||data.list.length==0) {
		//	window.location.href="order.do";
			return;
		}
		$(".pro-list>ul").html("");
		for (var i = 0; i < data.list.length; i++) {
			//显示数据
			var liitem=$($("#liitem").html());
			$(".pro-list>ul").append(liitem);
			liitem.find(".msg").html(list[i].item_name);
			liitem.find("#sd_unit_price").html(list[i].sd_unit_price);
			liitem.find(".zsum").val(list[i].sd_oq);
			liitem.find("#ivt_oper_listing").val(list[i].ivt_oper_listing);
			liitem.find("#seeds_id").val(list[i].seeds_id);
			liitem.find("#com_id>span").html($.trim(list[i].com_id));
			liitem.find("#item_id").val(list[i].item_id);
			liitem.find("#pack_unit").html(list[i].pack_unit);
			liitem.find("#item_unit").html(list[i].item_unit);
			liitem.find("#casing_unit").html(list[i].casing_unit);
			liitem.find("img:eq(0)").attr("src","../"+$.trim(list[i].com_id)+"/img/"+$.trim(list[i].item_id)+"/sl.jpg");
 			liitem.find("img:eq(1)").click(function(){
				$(this).parents("li").remove();
				numPriceJe();
			});
// 			liitem.find(".num").bind("input propertychange blur",function(){
// 				var pack_unit=parseFloat($(this).parents("ul").find("#pack_unit").html());
// 				var val=parseFloat($.trim($(this).val()));
// 				if (val>0&&pack_unit!="0") {
// 					var num=parseFloat(val)*parseFloat(pack_unit);
// 					if(!num){
// 						num=0;
// 					}
// 					$(this).parents("ul").find(".zsum").val(numformat(num,0));
// 				}else{
// 					$(this).parents("ul").find(".zsum").val(0);
// 				}
// 				$(this).parents("ul").find(".zsum").attr("readonly","readonly");
// 			});
 			var pack_unit=parseFloat(list[i].pack_unit);
			var val=parseFloat(list[i].sd_oq);
 			var num=val/pack_unit;
 			var zsum=0;
 			if (num) {
 				zsum=num;
			}else{
				zsum=val;
			}
 			liitem.find(".num").val(numformat(zsum,0));
 			liitem.find("#spje").html(list[i].sd_unit_price*zsum);
 			liitem.find(".zsum").attr("readonly","readonly");
 			liitem.find(".num").attr("readonly","readonly");
//			orderlist.push(JSON.stringify({"ivt_oper_listing":list[i].ivt_oper_listing,
//				"seeds_id":list[i].seeds_id,
//				"com_id":$.trim(list[i].com_id),
//				"item_id":$.trim(list[i].item_id),
//				"sd_oq":numformat(val,0),
//				"sd_unit_price":$.trim(list[i].sd_unit_price),
//				"item_name":list[i].item_name}));
		}
		var now = new Date(); 
		  nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
		$("#nowdate").html(nowStr);
		try {
			if (data.customerinfo.FHDZ) {
				FHDZ.val(data.customerinfo.FHDZ);
			}else{
				FHDZ.val(data.customerinfo.addr1);
			}
		} catch (e) {
		}
		////////////////////////
		var acct_recieve_sum=0;
		if (data.accounts&&data.accounts.acct_recieve_sum) {
			acct_recieve_sum=data.accounts.acct_recieve_sum;
		}
		///////////////////////
		$("#ysk").html(numformat2(acct_recieve_sum));//应收款
		//账户总余额
		var zhye=numformat2((parseFloat(acct_recieve_sum)*-1)-parseFloat(data.noDeliveryje));
		$("#zhye").html(zhye);
		$("#orderzje").html(numformat2(data.ordercount.zje));
		/////////
		initNumInput();
		$(".add").click(function(){
			var num=parseFloat($(this).parent().find(".num").val());
			if (!num) {
				num=0;
			}
			$(this).parent().find(".num").val(num+1);
			$(this).parent().find(".num").blur();
			numPriceJe();
		});
		$(".sub").click(function(){
			var num=parseFloat($(this).parent().find(".num").val());
			if (!num) {
				$(this).parent().find(".num").val(1);
			}else{
				if ((num-1)==0) {
					$(this).parent().find(".num").val(1);
				}else{
					$(this).parent().find(".num").val(num-1);
				}
			}
			$(this).parent().find(".num").blur();
			numPriceJe();
		});
		numPriceJe();
	});
	function numPriceJe(){
		var lis=$(".pro-list>ul>li");
		var zje=0;
		for (var i = 0; i < lis.length; i++) {
			var li=$(lis[i]);
			var je=parseFloat(li.find(".zsum").val())*parseFloat(li.find("#sd_unit_price").html()); 
			li.find("#spje").html(numformat2(je));
			zje+=je;
		}
		$("#orderzje").html(numformat2(zje));
//		$(".proprice").find(".right:eq(0)").html(numformat2(zje));
//		$(".proprice").find(".right:eq(3)").html(numformat2(zje));
	}
	/////////////////////结算方式列表显示隐藏按钮//////////////////////// 
	$(".modal,.modal-cover").hide();
	$(".close").click(function(){
		$(".modal,.modal-cover").hide();
	}); 
	$(".btn-info,#saveOrder").click(function(){
		 if ($.trim($(".pro-list>ul").html())=="") {
			pop_up_box.showMsg("还没有要支付的产品,去选择产品吧!");
		}else if($.trim(FHDZ.val())==""){
			pop_up_box.showMsg("请输入发货地址 !");
		}else{
			////
			var zhye=parseFloat(numformat($.trim($("#zhye").html(),2)));//账户余额
			$("#mzhye").html(zhye);//充值打欠条对话框账户余额
			var ddzje=parseFloat($(".proprice").find(".right:eq(0)").html());
			if(!ddzje){
				ddzje=$.trim($("#orderzje").html());
			}
			var b=false;
//			var ifUseCredit=$("#ifUseCredit").val();
			////////////////////
			$.cookie("FHDZ",$.trim(FHDZ.val()));
			//充值打欠条对话框支付金额
			$("#mzje").html(ddzje);
			if (ddzje<=zhye) {
				b=true;
			}else if(zhye>0){
				ddzje=ddzje-zhye;
			}
			var lis=$(".pro-list>ul>li");
			for (var i = 0; i < lis.length; i++) {
				var li=$(lis[i]);
				orderlist.push(JSON.stringify({"ivt_oper_listing":$.trim(li.find("#ivt_oper_listing").val()),
					"seeds_id":$.trim(li.find("#seeds_id").val()),
					"com_id":$.trim(li.find("#com_id>span").html()),
					"item_id":$.trim(li.find("#item_id").val()),
					"sd_oq":numformat($.trim(li.find(".zsum").val()),0),
					"sd_unit_price":$.trim(li.find("#sd_unit_price").html()),
					"item_name":$.trim(li.find(".msg").html())}));
			}
			/////////////////////////
			if (b) {
				pop_up_box.postWait();
				$.post("orderPayment.do",{
					"orderlist":orderlist,
					"FHDZ":FHDZ.val()
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.success){
						pop_up_box.showMsg("提交成功",function(){
							removeOrder();
//							window.location.href="order.do";
						});
					}else{
						pop_up_box.showMsg("保存出错,错误:"+data.msg);
					}
				});
			}else{
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
				$.cookie("customerName",$.trim($("#customerName").val()));
				$.cookie("date",nowStr);
				$.cookie("ddje",numformat(ddzje,2));
				$.cookie("ddzje",numformat(ddzje,2));/////2015-10-24 21:23
				$.cookie("ljqk",numformat((zhye*-1)+ddzje,2));
				$.cookie("orderlist",orderlist);
					$(".modal,.modal-cover").show();
			}
			return;
		}
	});
});