$(function(){
	//1.获取url
	var url= window.location.href;
	url=url.split("url")[1].split("=")[1];
	$.get("article/4/"+url,function(data){
		try {
			data=eval("("+data+")");
			} catch (e) {try {
			data=eval(data);
			} catch (e) {}}
		$(".productname").html(data.proName);
		$(".producttips").html(data.proTips);
		$(".productprice>span").html(data.proJe);
		$(".productimg > img").attr("src",data.imgurl);
		$("#jsonname").val(url.split("\.")[0]);
		$(".tabs_content").html("");
		$.get("article/4/"+$("#jsonname").val()+"-0.html",function(data){
			$($(".tabs_content")[0]).html(data);
		});
	});
	$(".tabstitle").removeClass("activeTabs");
	$(".tabstitle:eq(0)").addClass("activeTabs");
	$(".tabs_content").hide();
	$(".tabs_content:eq(0)").show();
	$(".tabstitle").click(function(){
		var n = $(".tabstitle").index(this);
		$(".tabstitle").removeClass("activeTabs");
		$(".tabstitle:eq("+n+")").addClass("activeTabs");
		$(".tabs_content").hide();
		$(".tabs_content:eq("+n+")").show();
		$.get("article/4/"+$("#jsonname").val()+"-"+n+".html?ver="+Math.random(),function(data){
			$($(".tabs_content")[n]).html(data);
		});
	});
});