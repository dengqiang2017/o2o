$(function(){
$("html,body",window.parent.document).animate({scrollTop:0},200);
var url=window.location.href;
url=url.split("?")[1];
url=url.split("&")[0];
if(url!=""){
url=url.split("=")[1];
var urls=url;
urls=url.split(".")[0];
$.get(urls+".json?math="+Math.random(),function(data){
	try {
		data=eval("("+data+")");
		} catch (e) {
		try {
		data=eval(data);
		} catch (e) {}
		}
	$(".artical_type").html(data.typeName);//类型名称
	$(".articleedit_title").html(data.title);//文章标题
	$(".articleedit_time").html("发布时间:"+data.releaseTime);//发布时间
	$(".articleedit_author").html("发布人:"+data.publisher);//发布人
	$("#articalUrl").val(url);
	$.get(url+"?math="+Math.random(),function(data){
		$(".articleedit_content").html(data);
	});
	if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){
 		$("img").attr("src",data.img);
 		$("embed,video").attr("src","");
 		$("embed,video").hide();
 		$("img").show();
 	}else if(data.img!=""){
 		$("embed,video").attr("src",data.img);
 		$("img").attr("src","");
 		$("img").hide();
 		$("embed,video").show();
 	}
	try {
		edithtml.init();
	} catch (e) {
	}
	$.get("fenxiang.jsp",function(data){
		$("#fenxiang").html(data);
	});
});
}
});