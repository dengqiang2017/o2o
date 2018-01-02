$(function(){
	$(".information_cover").hide();
	$(".information").hover(function(){
		var n = $(".information").index(this);
		$(".information_cover:eq("+n+")").stop().fadeIn(300);
	},function(){
		var n = $(".information").index(this);
		$(".information_cover:eq("+n+")").stop().fadeOut(300);
	});
	if($.trim($(".row").html())==""){
		$(".row").append($("#imgitem").html());
	}
	var videos=$(".row").find("video");
	for (var i = 0; i < videos.length; i++) {
		var item=$(videos[i]);
		var src=item.attr("src");
		if(src!=""){
		if (src.indexOf("mp4")>0||src.indexOf("MP4")>0) {
		}else{
			item.after('<embed src="'+src+'" allowfullscreen="true" quality="high" '+
	'allowscriptaccess="always" type="application/x-shockwave-flash" align="middle" height="81%" width="480">');
			item.remove();
		}
		}
	}
	var embeds=$("embed");
	for (var i = 0; i < embeds.length; i++) {
		var embed=$(embeds[i]);
		var embedp= embed.parent();
		var hei=embedp.outerHeight()-embedp.find(".articleedit_title").outerHeight();
		embed.css("height",hei);
	}
	var embeds=$("video");
	for (var i = 0; i < embeds.length; i++) {
		var embed=$(embeds[i]);
		var embedp= embed.parent();
		var hei=embedp.outerHeight()-embedp.find(".articleedit_title").outerHeight();
		embed.css("height",hei);
	}
	var embeds=$(".img>a");
	for (var i = 0; i < embeds.length; i++) {
		var embed=$(embeds[i]);
		var embedp= embed.parent();
		var hei=embedp.outerHeight()-embedp.find(".articleedit_title").outerHeight();
		embed.css("height",hei);
	}
});