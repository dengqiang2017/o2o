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
	var pageList=[{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0}];
	var num=20;
	$("#zhid,#show").change(function(){
		getlist().html("");
		pageList[getIndex()].page=0;
		pageList[getIndex()].count=0;
		loadItem();
	});
	$(".find").click(function(){
		getlist().html("");
		pageList[getIndex()].page=0;
		pageList[getIndex()].count=0;
		loadItem();
	});
	var over=true;
	function loadItem(){
		var type=getType();
		var list=getlist();
		var imgitem=$("#imgitem");
//			$.get("../temp/getArticleList.do",{
//			"filter":"json",
		pop_up_box.loadWait();
		$.get("../temp/getArticlePage.do",{
			"page":pageList[getIndex()].page,
			"count":pageList[getIndex()].count,
			"rows":num,
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$("#d4311").val(),
			"endDate":$("#d4312").val(),
			"zhiding":$("#zhid").val(),
			"show":$("#show").val(),
			"type":type,
			"projectName":projectName,
			"path":projectName+"/article/"+type
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows.length>0) {
				var ver="001";
				$.each(data.rows,function(i,n){ 
					var item=$(imgitem.html());
					list.append(item);
					if(n.zhiding=="1"||n.zhiding=="true"){
						item.find("#zhiding").html("置顶");
					}else{
						item.find("#zhiding").html("");
					}
					if(n.show=="0"||n.show=="false"){
						item.find("#zhiding").append("&emsp;不显示");
					}
					item.find(".articleedit_title").html(n.title);
					item.find(".articleedit_time").html(n.releaseTime);
					item.find(".articleedit_author").html(n.publisher);
					item.find(".articleedit_keywords").html(n.gjc);
					item.find("#htmlname").html(n.htmlname);
					if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
						item.find("img").show();
						item.find("video").remove();
						item.find("img").attr("src",n.img+"?ver="+ver);
					}else{
						if(n.img){
							item.find("video").show();
							item.find("img").remove();
							item.find("video").attr("src",n.img+"?ver="+ver);
							if(n.poster){
								item.find("video").attr("poster",n.poster+"?ver="+ver);
							}else{
								item.find("video").attr("poster","../"+projectName+"/images/poster.png");
							}
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
			pageList[getIndex()].count=data.totalRecord;
			pageList[getIndex()].totalPage=data.totalPage;
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
	var projectType=getQueryString("projectType");
	var cmslen=window.location.href.indexOf("_cms");
	if(projectType&&cmslen<0){
		var n=$(".ui_type:contains('"+projectType+"')");
		if(projectType=="1"){
			$('.secition_box_top>div').eq(2).click();
		}else if(projectType=="3"){
			$('.secition_box_top>div').eq(1).click();
		}else if(projectType=="2"){
			loadItem();
		}
	}else{
		loadItem();
	}
	$(window).scroll(function(){
        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
        	 if(over){
        		 if(pageList[getIndex()].page<pageList[getIndex()].totalPage){
        			 pageList[getIndex()].page=pageList[getIndex()].page+1;
        			 loadItem(); 
        		 }
        	 }
        }
     });  
});