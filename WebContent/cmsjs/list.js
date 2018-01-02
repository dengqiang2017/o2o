var page=0;
var count=0;
var totalPage=0;
var imgitem=$("#imgitem");
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
var ver=getQueryString("ver");
if(!ver||ver==null){
	ver="001";
}
function loadItem(type,name){
	pop_up_box.loadWait();
	domainName="http://"+document.location.hostname;
	var com_id=getQueryString("com_id")
	if(!com_id){
		com_id="001";
	}
	var searchKey=$.trim($("#searchKey").val());
	if(!searchKey){
		searchKey="";
	}
	var zhid=$("#zhid").val();
	if(!zhid){
		zhid="";
	}
	var beginDate=$("#d4311").val();
	if(!beginDate){
		beginDate="";
	}
	var endDate=$("#d4312").val();
	if(!endDate){
		endDate="";
	}
	$.get(url+"/temp/getArticlePage.do",{
		"domainName":domainName,
		"page":page,
		"com_id":com_id,
		"count":count,
		"projectName":projectName,
		"type":type,
		"searchKey":searchKey,
		"zhid":zhid,
		"beginDate":beginDate,
		"endDate":endDate,
		"rows":6,
		"path":projectName+"/article/"+type
	},function(data){
		pop_up_box.loadWaitClose();
		if (data&&data.rows.length>0) {
			ver="001";
			$.each(data.rows,function(i,n){
				var item=$(imgitem.html());
				$(".row").append(item);
				item.find(".articleedit_title").html(n.title);
				item.find(".articleedit_time").html(ifnull(n.releaseTime));
				item.find(".articleedit_author").html(ifnull(n.publisher));
				item.find(".articleedit_keywords").html(ifnull(n.gjc));
				if(n.content){
					item.find(".articleedit_content").html(n.content.substr(0,100));
				}
//				item.find("#htmlname").html(ifnull(n.htmlname));
				if(n.img){
					if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
						item.find("img").attr("src",n.img+"?ver="+ver);
						item.find("img").show();
						item.find("video").hide();
					}else{
						item.find("video").attr("src",n.img+"?ver="+ver);
						if(n.poster){
							item.find("video").attr("poster",n.poster+"?ver="+ver);
						}else{
							item.find("video").attr("poster","../"+projectName+"/images/poster.png");
						}
						item.find("video").show();
						item.find("img").hide();
					}
				}
				if(n.htmlname){
					item.click({"htmlname":n.htmlname},function(event){
						window.location.href=url+"/"+projectName+"/"+name+".jsp?url="+projectName+"/article/"+type+"/"+event.data.htmlname;
					});
				}
			});
		}
		totalPage=data.totalPage;
		count=data.totalRecord;
	});
}
function scrollinit(type,name){
$(window).scroll(function(){
    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
    	if(page<totalPage){
    		page=page+1;
    		loadItem(type,name); 
    	}
    }
 });  
}
topback();