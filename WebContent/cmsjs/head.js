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
		$(".qq-icon").show();
		$(".tools_icon").click(function(){//点击整块的时候也能跳转
			if ($(this).find("a").attr("href")) {
				var url=$(this).find("a").attr("href");
//				if($(this).find("a").html()=="总站"){
//					alert("即将返回首页:"+url);
//				}
				window.location.href=url;
			}
		});
		$(".tools_icon>.icon").click(function(){
			if ($(this).parent().find("a").attr("href")) {
				var url=$(this).parent().find("a").attr("href");
//				if($(this).parent().find("a").html()=="总站"){
//					alert("即将返回首页:"+url);
//				}
				window.location.href=url;
			}
		});
		var as=$(".logo_container a");
		for (var i = 0; i < as.length; i++) {
			var a=$(as[i]);
			var url=a.attr("href");
			if(url.indexOf("http")<0){
				a.attr("href",prex_url+a.attr("href"));
			}
		}
		var url=window.location.href.split("?")[0];
		$(".tools_icon").removeClass("active");
		for (var i = 0; i < $(".tools_icon>span>a").length; i++) {
			var a=$($(".tools_icon>span>a")[i]); 
			var ul=$(".tools_icon>span>a")[i].href.split("?")[0];
			if(url==ul){
				a.parents(".tools_icon").addClass("active");
				var txt=a.text();
				$(".main_title,title").html(txt);
				break;
			}
		}
	});
    $("#back-to-top").click(function(){
        $('body,html').animate({scrollTop:0},500);
        return false;
    }); 
});