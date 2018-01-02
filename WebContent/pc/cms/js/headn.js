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
	var url=window.location.href;
	$(".tools_icon").removeClass("active");
	for (var i = 0; i < $(".tools_icon>span>a").length; i++) {
		var href=$($(".tools_icon>span>a")[i]).attr("href").split(".")[0];
		if(url.indexOf(href)>=0&&href!=""){
			$($(".tools_icon>span>a")[i]).parents(".tools_icon").addClass("active");
		}
	}
}); 
$.get("../pc/fenxiang.html?ver="+Math.random(),function(data){
	$("#fenxiang").html(data);
});
$.get("footer.html?ver="+Math.random(),function(data){
	$(".footer").html(data);
});