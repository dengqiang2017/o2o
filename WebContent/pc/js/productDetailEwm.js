$(function(){
var item_id=$.trim($.cookie("item_id"));
var com_id=$.trim($("#com_id").val());
var customer_id="";
var orderNo="";
var s_n="";
if (!item_id) {
	item_id=window.location.href;
	item_id=item_id.split("?");
	var params=item_id[1].split("&");
	var json={};
	for (var i = 0; i < params.length; i++) {
		var pas=params[i].split("=");
		pas[0];
		json[pas[0]]=pas[1].replace("#","");
	}
	item_id=json.item_id;
	com_id=json.com_id;
	orderNo=json.orderNo;
	customer_id=json.customer_id;
	s_n=json.sn;
	$.cookie("com_id",com_id,{path:"/"});
	if(json.orderNo||json.jichu){
		$("#orderpay").parent().hide();
		$("#cpje").parent().hide();
		$("#back").parent().show();
		$(".pro-num").hide();
		if(json.jichu){
			$("#price_display").parent().show();
			$("#item_zeroSell").parent().hide();
		}
	}
	if(json.fenxiangid&&json.fenxiangid!=""){
		$.removeCookie("fenxiangid");
		$.removeCookie("fenxiangid",{path:"/"});
		$.cookie("fenxiangid",json.fenxiangid,{path:"/", expires: 7 });
	}
}
var imgpro=$(".pro-img");
imgpro.html(""); 
function IsPC() {
    var userAgentInfo = navigator.userAgent;
    var Agents = ["Android", "iPhone",
                "SymbianOS", "Windows Phone",
                "iPad", "iPod"];
    var flag = true;
    for (var v = 0; v < Agents.length; v++) {
        if (userAgentInfo.indexOf(Agents[v]) > 0) {
            flag = false;
            break;
        }
    }
    return flag;
}
	$.get("../product/getImgUrl.do",{"item_id":item_id,"com_id":com_id,"customer_id":customer_id},function(data){
		if (data.cps) {
			for (var i = 0; i < data.cps.length; i++) {
			var name=data.cps[i];
			var imgUrl="../"+com_id+"/img/"+item_id+"/cp/"+name;
			if (IsPC()) {
				$("#imageGallery").append("<li data-thumb='"+imgUrl+"'> <a href='../pc/image-view.html?type=product&url="+item_id+"&cp=cp' target='_blank'> <img src='"+imgUrl+"' /></a></li>");
			}else{
				$("#fade").append("<li> <a href='../pc/image-view.html?type=product&url="+item_id+"&cp=cp' target='_blank'> <img src='"+imgUrl+"' /></a></li>");
			}
			}
			$(".pro-img-lg").find("img:eq(0)").show();
			o2od.init();
		}
		if (data.xjs) {
			for (var i = 0; i < data.xjs.length; i++) {
				var name=data.xjs[i];
				if(name.indexOf("mp4")>=0){
					imgpro.append("<video controls='controls'  preload='none' height='400' width='480' src='../"+com_id+"/img/"+item_id+"/xj/"+name+"?ver="+Math.random()+"'></video>");
				}else{
					imgpro.append("<img src='../"+com_id+"/img/"+item_id+"/xj/"+name+"?ver="+Math.random()+"'>");
				}
			}
		}
		window.prettyPrint && prettyPrint();
		if (IsPC()) {
			$('#imageGallery').lightSlider({
				gallery:true,
				minSlide:1,
				maxSlide:1,
				currentPagerPosition:'left'  
			}); 
			$('#fade').parent().hide();
		}else{
			$('#imageGallery').parent().hide();
			$('#fade').lightSlider({
				minSlide:1,
				maxSlide:1,
				mode:'fade'
			});
		}
	});	

	try {
		o2od.init();
	} catch (e) {
	}
	$(".add").click(function(){
		var num=parseFloat($(this).parent().find(".num").val());
		if (!num) {
			num=1;
		}
		$(this).parent().find(".num").val(num+1);
		$(this).parent().find(".num").blur();
	});
	$(".sub").click(function(){
		var num=parseFloat($(this).parent().find(".num").val());
		if (!num||num=="0") {
			$(this).parent().find(".num").val(1);
		}else{
			if ((num-1)==0) {
				$(this).parent().find(".num").val(1);
			}else{
				$(this).parent().find(".num").val(num-1);
			}
		}
		$(this).parent().find(".num").blur();
	});
	$("#orderpay").click(function(){
		if(!orderpay){
			setCookieval("orderpay",com_id+"_"+item_id+"_"+$(".zsum").val());
			setCookieval("s_n",s_n);
		}
		///////////////////////////
		pop_up_box.postWait();
		$.post("../customer/orderpay.do",{
			"orderpay":com_id+"_"+item_id+"_"+$(".zsum").val(),
			"com_id":com_id,
			"item_id":item_id,
			"zsum":$(".zsum").val(),
			"s_n":s_n
		},function(data){
			pop_up_box.loadWaitClose();
			if(data.success){
				removeCookie();
				window.location.href="../customer/myOrder.do";
			}else{
				if(data.msg){
					pop_up_box.showMsg(data.msg);
				}
			}
		});
		///////////////////////
	});
	$("#addShopping").click(function(){
		//把购物车需要的数据序列化为json数据,然后在进行存储和获取 
		addshopping();
	});
	function addshopping(){
		if(!shopping){
			setCookieval("shopping",com_id+"_"+item_id+"_"+$(".zsum").val());
			setCookieval("s_n",s_n);
		}
		pop_up_box.postWait();
		$.post("../customer/shopping.do",{
			"shopping":com_id+"_"+item_id+"_"+$(".zsum").val(),
			"com_id":com_id,
			"item_id":item_id,
			"zsum":$(".zsum").val(),
			"s_n":s_n
		},function(data){
			if(data.success){
				pop_up_box.loadWaitClose();
				removeCookie();
				pop_up_box.toast("加入成功,去购物车查看!",1000);// showMsg("加入成功!");
			}else{
				if(data.msg){
					pop_up_box.showMsg(data.msg);
				}
			}
		});
	}
///////
	var orderpay=getCookieval("orderpay");
	var shopping=getCookieval("shopping");
	if(orderpay){
		var os=orderpay.split("_");
		com_id=os[0];
		item_id=os[1];
		$(".zsum").val(os[2]);
		removeCookie();
		$("#orderpay").click();
	}
	if(shopping){
		var os=shopping.split("_");
		com_id=os[0];
		item_id=os[1];
		$(".zsum").val(os[2]);
		removeCookie();
		addshopping();
	}
	$("#com_id").val(com_id);
	///////
});