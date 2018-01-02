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
}); 
$.get("fenxiang.jsp",function(data){
	$("#fenxiang").html(data);
});
$.get("footer.html",function(data){
	$(".footer").html(data);
});