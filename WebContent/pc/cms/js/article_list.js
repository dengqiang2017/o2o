$(function(){
	$(".information_cover").hide();
	$(".information").hover(function(){
		var n = $(".information").index(this);
		$(".information_cover:eq("+n+")").stop().fadeIn(300);
	},function(){
		var n = $(".information").index(this);
		$(".information_cover:eq("+n+")").stop().fadeOut(300);
	});
//////////////////////////////////////////////////
	var urlname="article";
	var type=$("#type").val();
	if (type==1) {
		urlname="information_detail";
	}else if(type==3){
		urlname="customerrap_detail";
	}
	function additem(){
		$(".row").append($("#imgitem").html());
		try {
			edithtml.init();
		} catch (e) {
		}
	}
	$(".row").html("");
	additem();
	
});
var articleList={
		loadWrodList:function(data,i,text){
			var urlname="article";
			var type=$("#type").val();
			if (type==1) {
				urlname="information_detail";
			}else if(type==3){
				urlname="customerrap_detail";
			}
			var imgitem=$($("#imgitem").html());
	     	$(".row").append(imgitem);
			imgitem.find(".articleedit_time").html(data.releaseTime);
			imgitem.find(".articleedit_author").html(data.publisher);
			imgitem.find("img").attr("src",data.img);
			imgitem.find(".articleedit_content").html($(text).text().substr(0,100));
			imgitem.find(".articleedit_title").html(data.title);
			imgitem.find("a").attr("href",urlname+".html?url=article/"+i+"/"+data.htmlname);
			if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){
	     		imgitem.find("img").attr("src",data.img);
	     		imgitem.find("embed,video").attr("src","");
	     		imgitem.find("embed,video").hide();
	     		imgitem.find("img").show();
	     	}else if(data.img!=""){
	     		imgitem.find("embed,video").attr("src",data.img);
	     		imgitem.find("embed,video").attr("poster",data.poster);
	     		imgitem.find("img").attr("src","");
	     		imgitem.find("img").hide();
//	     		imgitem.find("embed,video").show();
	     		if (data.img.indexOf("mp4")>0||data.img.indexOf("MP4")>0) {
	     			imgitem.find("video").show();
	     			imgitem.find("embed").remove();
				}else{
//					imgitem.find("embed").show();
					imgitem.find("video").after('<embed src="'+data.img+'" allowfullscreen="true" quality="high" '+
							'allowscriptaccess="always" type="application/x-shockwave-flash" align="middle" height="400" width="480">');
					imgitem.find("video").remove();
				}
	     	}
			try {
				edithtml.init();
			} catch (e) {}
		}
}