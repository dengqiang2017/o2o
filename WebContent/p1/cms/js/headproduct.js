$(function(){
	var url01=window.location.href.split("?")[0];
	var url02=url01.split("/");
	url01=url02[url02.length-1];
	parent.edit_url=url01;
	$.get("../pc/head.html?ver="+Math.random(),function(data){
		$(".logo_container").html(data);
		var ahtmls=$(".logo_container").find("a");
		ahtmls.parent().removeClass("active");
		for (var i = 0; i < ahtmls.length; i++) {
			var ah=$(ahtmls[i]);
			 if(ah.attr("href")==url01){
				 ah.parent().addClass("active");
			 }
			 ah.attr("href","../pc/"+ah.attr("href"));
		}
		var atxt=$(".logo_container").find("a");
		if ($("#type").val()=="1") {//服务
			$(".main_title,title").html($(atxt[3]).text());
		}else if ($("#type").val()=="2"){//案例
			$(".main_title,title").html($(atxt[2]).text());
		}else if ($("#type").val()=="3"){//口碑
			$(".main_title,title").html($(atxt[4]).text());
		}
		$(".tools_icon").click(function(){
			window.location.href=$(this).find("a").attr("href");
		});
		$(".tools_icon>.icon").click(function(){
			window.location.href=$(this).parent().find("a").attr("href");
		});
		try {
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
		$(".tools_icon").removeClass("active");
		$(".qq-icon").addClass("active");
	});
	$.get("../pc/head-login.html",function(data){
		$(".login").html(data);
		$.get("../pc/fenxiang.jsp",function(data){
			$("#fenxiang").html(data);
		});
		$(".close").click(function(){
			$(".login").hide();
		});
	});
	$.get("../pc/footer.html",function(data){
		$(".footer").html(data);
		try {
			edithtml.init();
		} catch (e) {
		}
	});
//	$(".login,.login-fix").remove();
	$(".btn_01").hide();
	$(".btn_02").click(function(){
		removeCookie();
		setCookieval("zhixun","zhixun");
		setCookieval("backurl",window.location.href);
		window.location.href="../login/toUrl.do?url=../user/sendChatMsg.do";
		return false;
	});
	$("title").html("牵引互联-"+$("title").html());
    $("#back-to-top").click(function(){
        $('body,html').animate({scrollTop:0},500);
        return false;
    }); 
});   
function setCookieval(key,val){
	try {
		localStorage.setItem(key,val);
	} catch (e) {
		$.cookie(key,val,{ path: '/', expires: 7 });
	}
}
//function getCookieval(key){
//	var shopping=$.cookie(key);
//	if(!shopping){
//		shopping=localStorage.getItem(key);alert(shopping);
//	}
//	return shopping;
//}
function removeCookie(){
	$.removeCookie("orderpay");
	$.removeCookie("ordershopping");
	$.removeCookie("zhixun");
	localStorage.removeItem("ordershopping");
	localStorage.removeItem("orderpay");
	localStorage.removeItem("zhixun");
}