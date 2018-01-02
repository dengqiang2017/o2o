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
	$("title").html(data.title+"-"+$("title").html());
	$(".articleedit_time").html("发布时间:"+data.releaseTime);//发布时间
	$(".articleedit_author").html("发布人:"+data.publisher);//发布人
	$("#articalUrl").val(url);
	$.get(url+"?math="+Math.random(),function(data){
		$(".articleedit_content").html(data);
	});
	(function(){
		var p = {
		url:window.location.href,
		showcount:'1',/*是否显示分享总数,显示：'1'，不显示：'0' */
		desc:$(".articleedit_title").html(),/*默认分享理由(可选)*/
		summary:$(".articleedit_author").html(),/*分享摘要(可选)*/
		title:$(".articleedit_title").html(),/*分享标题(可选)*/
		site:'牵引互联',/*分享来源 如：腾讯网(可选)*/
		pics:'', /*分享图片的路径(可选)*/
		style:'201',
		width:39,
		height:39
		};
		var s = [];
		for(var i in p){
		s.push(i + '=' + encodeURIComponent(p[i]||''));
		}
		document.getElementById("fenxiang").innerHTML=(['<a version="1.0" class="qzOpenerDiv" href="http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?',s.join('&'),'" target="_blank">分享</a>'].join(''));
	    $("body").append('<script src="http://qzonestyle.gtimg.cn/qzone/app/qzlike/qzopensl.js#jsdate=20111201" charset="utf-8"><//script>');
		})(); 
//	(function(){
//		var p = {
//		url:location.href, /*获取URL，可加上来自分享到QQ标识，方便统计*/
//		desc:'', /*分享理由(风格应模拟用户对话),支持多分享语随机展现（使用|分隔）*/
//		title:$(".articleedit_title").html(), /*分享标题(可选)*/
//		summary:$(".articleedit_author").html(), /*分享摘要(可选)*/
//		pics:'http://www.my-tw.com/o2o/logo.png', /*分享图片(可选)*/
//		flash: $("video").attr("src"), /*视频地址(可选)*/
//		site:'牵引互联', /*分享来源(可选) 如：QQ分享*/
//		style:'201',
//		width:32,
//		height:32
//		};
//		var s = [];
//		for(var i in p){
//		s.push(i + '=' + encodeURIComponent(p[i]||''));
//		}
//		document.getElementById("fenxiang").innerHTML=document.getElementById("fenxiang").innerHTML+['<a class="qcShareQQDiv" href="http://connect.qq.com/widget/shareqq/index.html?',s.join('&'),'" target="_blank">分享到QQ</a>'].join('');
//		$("body").append('<script src="http://connect.qq.com/widget/loader/loader.js" widget="shareqq" charset="utf-8"><//script>');
//		})();
	
//	if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){
// 		$("img").attr("src",data.img);
// 		$("embed,video").attr("src","");
// 		$("embed,video").hide();
// 		$("img").show();
// 	}else 
	if(data.img!=""&&!/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){ 
 		$("embed,video").attr("src",data.img);
 		$("img").attr("src","");
 		$("img").hide();
 		$("embed,video").show();
 	}else{
        $("embed,video").remove();
	}
	try {
		edithtml.init();
	} catch (e) {
	}
});
}
});