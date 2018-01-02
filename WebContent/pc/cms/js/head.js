function isPC() {
			var winWidth=0;
		if (window.innerWidth)
	winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
	winWidth = document.body.clientWidth;
	if(winWidth>=700){
		return true;
	}else{
		return false;
	}
  /*  var userAgentInfo = navigator.userAgent;
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
return flag;*/
}
setInterval(function(){
	if(!isPC()){
		var fonts=$("div[data-phone-font]");
		if(fonts){
			for (var i = 0; i < fonts.length; i++) {
				var ft=$(fonts[i]);
				ft.css("font-size",ft.attr("data-phone-font"));
			}
		}
	}else{
		var fonts=$("div[data-pc-font]");
		if(fonts){
			for (var i = 0; i < fonts.length; i++) {
				var ft=$(fonts[i]);
				ft.css("font-size",ft.attr("data-pc-font"));
			}
		}
	}
}, 50);
$(function(){
	var url01=window.location.href.split("?")[0];
	var url02=url01.split("/");
	url01=url02[url02.length-1];
	parent.edit_url=url01;
	$.get("../pc/head.html?ver="+Math.random(),function(data){
		$(".logo_container").html(data);
		var ahtmls=$(".header > ul >li>a");
		ahtmls.parent().removeClass("active");
		for (var i = 0; i < ahtmls.length; i++) {
			var ah=$(ahtmls[i]);
			 if(ah.attr("href")==url01){
				 ah.parent().addClass("active");
			 }
		} 
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
					var txt=$(this).parent().find("a").text();
					$(".main_title,title").html(txt); 
				}
			});
		} 
		var url=window.location.href;
		$(".tools_icon").removeClass("active");
		for (var i = 0; i < $(".tools_icon>span>a").length; i++) {
			var a=$($(".tools_icon>span>a")[i]);
			var href=a.attr("href").split(".html")[0];
			if(url.indexOf(href)>=0&&href!=""){
				a.parents(".tools_icon").addClass("active");
				var txt=a.text();
				$(".main_title,title").html(txt);
			} 
		} 
		if (isPC()) {
			setTimeout(function(){
	    	   $.get("../pc/fenxiang.html?ver="+Math.random(),function(data){
				$("body").append(data);
	    	   });
	    	}, 3000);
		}
	});
		if (!isPC()) {
		if(window.location.href.indexOf("index")>=0){
			var imgs=$("img");
			for (var i = 0; i < imgs.length; i++) {
				var src=$(imgs[i]).attr("src");
				var srcphone=src.replace(".", "-phone.");
				$(imgs[i]).attr("src",srcphone);
			}
			$("img").error(function(){
				var imgsrc=$(this).attr("src");
				if (imgsrc.indexOf("phone")>0) {
					$(this).attr("src",imgsrc.replace("-phone", ""));
				}
			});
		}
	}
	$.get("../pc/footer.html?ver="+Math.random(),function(data){
		$(".footer").html(data);
		try {
			edithtml.init();
		} catch (e) {
		}
	});
	$(".login,.login-fix").remove();
	$(".btn_01").hide();
	$(".btn_02").hide();
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
	$.removeCookie("ordershopping");
	$.removeCookie("zhixun");
	localStorage.removeItem("orderpay");
	localStorage.removeItem("ordershopping");
	localStorage.removeItem("zhixun");
}
function hoverFenxiang(div,display){
	div.nextElementSibling.nextElementSibling.style.display=display;
}
function hoverFenxiangMe(div,display){
	var fenxiang=div.style.display=display;
}
function clickFenxiangMe(div){
	if($("#fenxiang").css("display")=='none'){
		$("#fenxiang").show();
	}else{
		$("#fenxiang").hide();
	}
}