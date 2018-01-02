$(function(){
	var url01=window.location.href.split("?")[0];
	var url02=url01.split("/");
	url01=url02[url02.length-1];
	parent.edit_url=url01;
	function isPC() {
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
	$.get("head.html?ver="+Math.random(),function(data){
		$(".logo_container").html(data);
		var ahtmls=$(".header > ul >li>a");
		ahtmls.parent().removeClass("active");
		for (var i = 0; i < ahtmls.length; i++) {
			var ah=$(ahtmls[i]);
			 if(ah.attr("href")==url01){
				 ah.parent().addClass("active");
			 }
		}
		var atxt=$(".logo_container").find("a");
		try {
			$(".qq-icon").hide();
			edithtml.init();
		} catch (e) {
			$(".qq-icon").show();
			$(".tools_icon").click(function(){
				if ($(this).find("a").attr("href")) {
					window.location.href=$(this).find("a").attr("href");
				}
			});
			$(".tools_icon>.icon").click(function(){
				if ($(this).parent().find("a").attr("href")) {
					window.location.href=$(this).parent().find("a").attr("href");
				}
			});
		}
//		setTimeout(function(){
//			$.get("fenxiang.html",function(data){
//				if($("#fenxiang").length>0){
//					$("#fenxiang").html(data);
//				}else{
//					$("body").append(data);
//				}
//			});
//		}, 3000);
	});
	$.get("footer.html",function(data){
		$(".footer").html(data);
		try {
			edithtml.init();
		} catch (e) {
		}
	});
	$(".login,.login-fix").remove();
	$(".btn_01").hide();
	$(".btn_02").click(function(){
		removeCookie();
		setCookieval("zhixun","zhixun");
		setCookieval("backurl",window.location.href);
		window.location.href="../login/toUrl.do?url=../user/sendChatMsg.do";
		return false;
	});
    $("#back-to-top").click(function(){
        $('body,html').animate({scrollTop:0},500);
        return false;
    }); 
});   
function setCookieval(key,val){
	$.cookie(key,val);
	localStorage.setItem(key,val);
}
function getCookieval(key){
	var shopping=$.cookie(key);
	if(!shopping){
		shopping=localStorage.getItem(key);
	}
	return shopping;
}
function removeCookie(){
	$.removeCookie("orderpay");
	localStorage.removeItem("orderpay");
	
	$.removeCookie("ordershopping");
	localStorage.removeItem("ordershopping");
	
	$.removeCookie("zhixun");
	localStorage.removeItem("zhixun");
}
//function hoverFenxiang(div,display){
//	div.nextElementSibling.nextElementSibling.style.display=display;
//}
//function hoverFenxiangMe(div,display){
//	var fenxiang=div.style.display=display;
//}
//function clickFenxiangMe(div){
//	if($("#fenxiang").css("display")=='none'){
//		$("#fenxiang").show();
//	}else{
//		$("#fenxiang").hide();
//	}
//}