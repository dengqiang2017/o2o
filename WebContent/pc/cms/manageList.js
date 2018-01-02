function getType(){
	return $(".x-active").find(".ui_type").html();
}
function getIndex(){
	var index=$('.secition_box_top>div').index($(".secition_box_top>div.x-active"));
	return index;
}
function getimgitem(){
	var imgitem=$("#imgitem");
	return imgitem;
}
function getlist(){
	var type=getType();
	var list;
	if(type==2){
		list=$("#caselist");
	}else if(type==3){
		list=$("#customerrap");
	}else{//怎么做？
		list=$("#information");
	}
	return list;
}
$(function(){
	var imgitem=$("#imgitem");
	$("#caselist").html("");
	$("#customerrap").html("");
	$("#information").html("");
	var projectName=$("#projectName").html();
	var pageList=[{"page":0},{"page":0},{"page":0}];
	var num=20;
	var over=true;
	function loadItem(){
		var type=getType();
		var list=getlist();
		var imgitem=$("#imgitem");
		$.get("../temp/getArticleList.do",{
			"filter":"json",
			"page":pageList[getIndex()].page,
			"num":num,
			"path":projectName+"/article/"+type
		},function(data){
			if (data&&data.length>0) {
				$.each(data,function(i,n){
					n=$.parseJSON(n);
					var item=$(imgitem.html());
					list.append(item);
					item.find(".articleedit_title").html(n.title);
					item.find(".articleedit_time").html(n.releaseTime);
					item.find(".articleedit_author").html(n.publisher);
					item.find(".articleedit_keywords").html(n.gjc);
					item.find("#htmlname").html(n.htmlname);
					if(n.zhiding){
						item.find(".articleedit_title").append("<span id='zhiding'>-置顶</span>");
					}
					if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
						item.find("img").attr("src",n.img);
						item.find("img").show();
					}else{
						if(n.img){
							item.find("video").attr("src",n.img);
							if(n.poster){
								item.find("video").attr("poster",n.poster);
							}else{
								item.find("video").attr("poster","../pc/images/poster.png");
							}
							item.find("video").show();
						}
					}
				});
				edithtml.init();
			}else{
				over=false;
				if(pageList[getIndex()].page==0){
					list.append(imgitem.html());
					edithtml.init();
				}
			}
		});
	}
	$('.secition_box_top>div').click(function() {
		$('.secition_box_top>div').removeClass('x-active');
		$(this).addClass('x-active');
		var type=getType();
		var list=getlist();
		$(".secition_box_bottom03").hide();
		$(".secition_box_bottom03").eq(getIndex()).show();
		var n=list.find(".right-main-item").length;
		if ($.trim(list.html())!=""&&n>1) {
			return;
		}
		list.html("");
		loadItem();
	});
	loadItem();
	$(window).scroll(function(){
        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
        	 if(over){
        		 pageList[getIndex()].page=pageList[getIndex()].page+1;
        		 loadItem(); 
        	 }
        }
     });  
});