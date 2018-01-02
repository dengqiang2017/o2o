URLFiltering();
if(!IsPC()){
	$(".footer").addClass("navbar-fixed-bottom");
}
$("#fanhui").attr("href","shopping_cart.jsp?ver="+Math.random());
var ivt_oper_listing="";
var totalJe=0;
pop_up_box.loadWait();
$.get("../customer/getSimpleOrderPayInfo.do",function(data){
	pop_up_box.loadWaitClose();
	if(data){
		$("#orderNo").html(data.orderNo);
		$("#lxr").html(data.lxr);
		$("#lxPhone").html(data.lxPhone);
		$("#fhdz").html(data.fhdz);
		$("#sum_si").html(data.sum_si);
		totalJe=data.sum_si;
		ivt_oper_listing=data.ivt_oper_listing;
		$(".orderNo").val(data.orderNo);
		$(".amount").val(data.sum_si);
		$("input[name='body']").val(data.item_name);
	}
});
//////显示加载的优惠券
$("#yhq").click(function(){
	$("#paypage").hide();
	$("#selectYhq").show();
	usecoupon.init();
});
$("#weixinpay").hide();
if(is_weixin()){
	$("#weixinpay").show();
}
if(IsPC()){
	$("#weixinpay").show();
}
$("input[name='attach']").val("达州创新家居");
$('.check span').click(function(){
$('.check span').removeClass('active');
	$(this).addClass('active');
});
$(".check").parents("li").click(function(){
	$('.check span').removeClass('active');
	$(this).find(".check span").addClass('active');
});
$("#usejinbi").prop("checked",false);
$.get("../client/getTotalJinbi.do",function(data){
	if(!data){
		$("#totalJinbi").parents("li").hide();
		$("#totalJinbi").html(0);
	}else{
		$("#totalJinbi").html(data);
	}
	if(data>1000){
		//向下拉框中加入值
		var jinbi=(data/1000)+"";
		var len=jinbi.split(".")[0];
		$("#shiyongjinbi").html("");
		for (var i = 0; i < len; i++) {
			$("#shiyongjinbi").append('<option value="'+((i+1)*1000)+'">'+((i+1)*1000)+'</option>');
		}
		$("#shiyongjinbi").change(function(){
			var val=parseInt($(this).val())/100;
			$("#dikou").html(val);
			getSumSi();
		});
		$("#keyong").html(len*1000);
		$("#usejinbi").click(function(){
			var b=$(this).prop("checked");
			if(b){
				$("#jinbidiv").show();
				var val=parseInt($("#shiyongjinbi").val())/100;
				$("#dikou").html(val);
			}else{
				$("#dikou").html("0");
				$("#jinbidiv").hide();
			}
			getSumSi();
		});
	}else{
		$("#usejinbi").hide();
		$("#usejinbi").attr("disabled","disabled");
	}
});
function getSumSi(){
	var sum_si=parseFloat(totalJe);
		var b=$("#usejinbi").prop("checked");
		var dikou=0;
		if(b){
			dikou=parseInt(common.isnull0($("#dikou").html()));
		}
	var yhqAmount=parseInt(common.isnull0($("#yhqAmount").html()));
	sum_si=sum_si-dikou-yhqAmount;
	if(sum_si<=0){
		sum_si=0;
		$("#weixinpay").hide();
	}else{
		if(is_weixin()){
			$("#weixinpay").show();
		}
		if(IsPC()){
			$("#weixinpay").show();
		}
	}
	$("#sum_si").html(sum_si);
	$(".amount").val(sum_si);
}
localStorage.backurl=window.location.href;
$(".btn-success").click(function(){
	var lxr=$.trim($("#lxr").html());
	var lxPhone=$.trim($("#lxPhone").html());
	var fhdz=$.trim($("#fhdz").html());
	if(lxr==""){
		pop_up_box.showMsg("请补全收货人!");
	}else if(lxPhone==""){
		pop_up_box.showMsg("请补全收货人联系电话!");
	}else if(fhdz==""){
		pop_up_box.showMsg("请补全收货地址!");
	}else{
		pop_up_box.postWait();
		var txt=$.trim($(".active").parents("li").find(".word_top").html());
		var fkfs="";
		if(txt=="货到付款"){
			fkfs=";货到付款";
		}
		var jinbi="";
		var jinbistr="";
		var usejinbi=$("#usejinbi").prop("checked");
		if(usejinbi){
			jinbi=$("#shiyongjinbi").val();
			if(jinbi!=""){
				jinbistr=",金币抵扣"+$("#dikou").html()+"元";
			}
		}
		var yhqAmount=parseInt($("#yhqAmount").html());
		var yhqNo=$("#yhqNo").html();
		var yhqId=$("#yhqId").html();
		if(yhqAmount&&yhqAmount>0){
			jinbistr=jinbistr+",优惠券抵扣"+yhqAmount+"元";
		}else{
			yhqAmount="";
			yhqNo="";
			yhqId="";
		}
		$.post("../customer/updateFHDZToOrder.do",{
			"fhdz":lxr+";"+lxPhone+";"+fhdz+fkfs,
			"fkfs":txt+jinbistr,
			"jinbi":jinbi,
//			"yhqAmount":yhqAmount,//优惠券金额
			"yhqId":yhqId,//优惠券编号
			"yhqNo":yhqNo,//优惠券编号
			"skdh":$("#orderNo").html(),//收款单号
			"orderNo":ivt_oper_listing
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				if(txt=="微信支付"){
					$("form").attr("action","../weixin/alipay.do");
					$("form").submit();
				}else if(txt=="银联支付"){
					pop_up_box.loadWaitClose();
					pop_up_box.showMsg("功能建设中,请选择其它支付方式!");
				}else if(txt=="支付宝"){
					$("form").submit();
				}else{
					pop_up_box.postWait();
					$.get("../customer/cashDelivery.do",{
						"title":"客户下订单审核通知",
						"fhdz":fhdz,
						"lxr":lxr+";"+lxPhone,
//						"yhqAmount":yhqAmount,//优惠券金额
						"yhqId":yhqId,//优惠券编号
						"yhqNo":yhqNo,//优惠券编号
						"orderNo":ivt_oper_listing,
						"skdh":$("#orderNo").html(),//收款单号
						"description":"@comName-@Eheadship-@clerkName：客户:@customerName,下订单,付款方式:货到付款"+jinbistr
						+",订单编号: "+ivt_oper_listing+",请尽快核实订单真实有效性并及时发货.",
						"headship":"内勤",
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("提交成功,请等待后台审核!", function(){
								window.location.href="personal_center.jsp";
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("保存错误!" + data.msg);
							} else {
								pop_up_box.showMsg("保存错误!");
							}
						}
					});
				}
			} else {
				pop_up_box.showMsg("提交错误!"+data.msg);
			}
		});
	}
});
/////////////////////
$("#addr").click(function(){
	$("#paypage").hide();$("#infopage").show();
	if($.trim($(".secition>ul").html())==""){
		addrSeelect.init();
	}
});
var addrSeelect={
		init:function(){
	    $(".secition>ul").html("");
	    pop_up_box.loadWait();
	    $.get("../customer/getFHDZList.do",function(data){
	    	pop_up_box.loadWaitClose();
	    	if(data&&data.length>0){
	    		$.each(data,function(i,n){
	    			var item=$($("#liitem").html());
	    			$(".secition>ul").append(item);
	    			item.find(".name").html(n.lxr);
	    			item.find(".cell").html(n.lxPhone);
	    			item.find(".site").html(n.fhdz);
	    			item.click(function(){
	    				//设置该地址为默认地址
	    				$(this).find("#mr").prop("checked",true);
	    				savefhdz($(this));
	    			});
	    		});
	    	}
	    });
	    
	    function savefhdz(t){
	    	var list=$("#infopage .secition>ul>li");
	    	if(list&&list.length>0){
	    		var fhdzlist=[];
	    		for (var i = 0; i < list.length; i++) {
					var item=$(list[i]);
					var json={};
					json.lxr=item.find(".name").html();
					json.lxPhone=item.find(".cell").html();
					json.fhdz=item.find(".site").html();
					json.mr=item.find("#mr").prop("checked");
					fhdzlist.push(JSON.stringify(json));
				}
	    		if(fhdzlist.length>0){
	    			pop_up_box.postWait();
	    			$.post("../customer/saveFHDZList.do",{
	    				"fhdzlist":"["+fhdzlist.join(",")+"]"
	    			},function(data){
	    				pop_up_box.loadWaitClose();
	    				if (data.success) {
//	    					pop_up_box.toast("保存成功",1000);
		    				$("#addr").find("#lxr").html(t.find(".name").html());
		    				$("#addr").find("#lxPhone").html(t.find(".cell").html());
		    				$("#addr").find("#fhdz").html(t.find(".site").html());
		    				$("#infopage").hide();$("#paypage").show();
						} else {
							pop_up_box.showMsg("保存错误!");
						}
	    			});
	    		}
	    	}
	    	
	    }
	    
		}
}