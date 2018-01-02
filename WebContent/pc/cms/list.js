var page=0;
var num=0;
var over=true;
var imgitem=$("#imgitem");
var projectName=$("#projectName").html();
function topback(){
	$("html,body").animate({scrollTop:0},200);
}
/**
 * 如果没有值就返回空字符串
 * @param val
 * @returns
 */
function ifnull(val) {
	if (val) {
		return val;
	} else {
		return "";
	}
}
$(".row").html("");
var load=true;
var url="http://www.pulledup.cn";
var domainName=window.location.href.split(".cn")[0]+".cn";
var projectName=$("#projectName").html();
function loadItem(type,name){
	pop_up_box.loadWait();
	load=false;
	$.get(url+"/temp/getArticleList.do",{
		"filter":"json",
		"page":page,
		"num":6,
		"domainName":domainName,
		"path":projectName+"/article/"+type
	},function(data){
		load=true;
		pop_up_box.loadWaitClose();
		if (data&&data.length>0) {
			$.each(data,function(i,n){
				n=$.parseJSON(n);
				var item=$(imgitem.html());
				$(".row").append(item);
				item.find(".articleedit_title").html(n.title);
				item.find(".articleedit_time").html(ifnull(n.releaseTime));
				item.find(".articleedit_author").html(ifnull(n.publisher));
				item.find(".articleedit_keywords").html(ifnull(n.gjc));
				if(n.content){
					item.find(".articleedit_content").html(n.content.substr(0,100));
				}
				item.find("#htmlname").html(ifnull(n.htmlname));
				if(n.img){
					if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
						item.find("img").attr("src",n.img);
						item.find("img").show();
						item.find("video").hide();
					}else{
						item.find("video").attr("src",n.img);
						if(n.poster){
							item.find("video").attr("poster",n.poster);
						}else{
							item.find("video").attr("poster","../pc/images/poster.png");
						}
						item.find("video").show();
						item.find("img").hide();
					}
				}
				if(n.htmlname){
					item.click({"htmlname":n.htmlname},function(event){
						window.location.href=name+".jsp?url=pc/article/"+type+"/"+event.data.htmlname;
					});
				}
			});
		}else{
			over=false;
		}
	});
}
function scrollinit(type,name){
$(window).scroll(function(){
    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
    	 if(over&&load){
    		 page=page+1;
    		 loadItem(type,name); 
    	 }
    }
 });  
}
topback();