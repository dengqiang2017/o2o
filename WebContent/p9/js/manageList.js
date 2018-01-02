function getType(){
	return $(".x-active").find(".ui_type").html();
}
function getIndex(){
	var index=$('.secition_box_top>div').index($(".secition_box_top>div.x-active"));
	return index;
}
function getimgitem(){
	var imgitem;
	var type=getType();
	if(type==1){
		imgitem=$("#imgitem");
	}else if(type==2){
		imgitem=$("#imgitem");
	}else if(type==20){//互联网+思维？
		imgitem=$("#item");
	}else if(type==21){//为什么？
		imgitem=$("#item");
	}else{//怎么做？
		imgitem=$("#item");
	}
	return imgitem;
}
function getlist(){
	var type=getType();
	var list;
	if(type==1){
		list=$("#caselist");
	}else if(type==2){
		list=$("#newslist");
	}else if(type==20){//互联网+思维？
		list=$(".secition_box_bottomtop_y:eq(0)>.y-box>ul");
	}else if(type==21){//为什么？
		list=$(".secition_box_bottomtop_y:eq(1)>.y-box>ul");
	}else{//怎么做？
		list=$(".secition_box_bottomtop_y:eq(2)>.y-box>ul");
	}
	return list;
}
$(function(){
	var imgitem=$("#imgitem");
	$("#caselist,#newslist").html("");
	$(".secition_box_bottomtop_y:eq(0)>.y-box>ul").html("");
	$(".secition_box_bottomtop_y:eq(1)>.y-box>ul").html("");
	$(".secition_box_bottomtop_y:eq(2)>.y-box>ul").html("");
//	var page=0;
	var pageList=[{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0},{"page":0,"count":0,"totalPage":0}];
	var num=20;
	var over=true;
	getlist().html("");
	$("#caselist").html("");
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
	function loadItem(parentHtml){
		var type=getType();
		var list=getlist();
		var imgitem=getimgitem();
		pop_up_box.loadWait();
		$.get("../temp/getArticlePage.do",{
			"page":pageList[getIndex()].page,
			"count":pageList[getIndex()].count,
			"rows":num,
			"type":type,
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$("#d4311").val(),
			"endDate":$("#d4312").val(),
			"zhiding":$("#zhid").val(),
			"show":$("#show").val(),
			"projectName":projectName,
			"path":projectName+"/article/"+type,"ver":Math.random()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows.length>0) {
				var ver="001";
				for (var i = 0; i < data.rows.length; i++) {
					var n=data.rows[i];
					var item=$(imgitem.html());
					list.append(item);
					if(n.zhiding=="1"){
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
//						item.find("video").hide();
						item.find("video").remove();
						item.find("img").attr("src",n.img+"?ver="+ver);
					}else{
						if(n.img){
							item.find("video").show();
//							item.find("img").hide();
							item.find("img").remove();
							item.find("video").attr("src",n.img+"?ver="+ver);
							if(n.poster){
								item.find("video").attr("poster",n.poster+"?ver="+ver);
							}else{
								item.find("video").attr("poster","../"+projectName+"/images/poster.png");
							}
						}
					}
				}
				edithtml.init(parentHtml);
			}else{
				over=false;
				if(pageList[getIndex()].page==0){
					list.append(imgitem.html());
					edithtml.init(parentHtml);
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
		var parentHtml=".col-lg-3";
		var n;
		if(type==1){
			n=list.find(".right-main-item").length;
		}else if(type==2){
			n=list.find(".right-main-item").length;
		}else if(type==20){//互联网+思维？
			n=$(".secition_box_bottomtop_y:eq(0)>.secition_box_bottom_x>div").length;
			parentHtml="li";
		}else if(type==21){//为什么？
			n=$(".secition_box_bottomtop_y:eq(1)>.secition_box_bottom_x>div").length;
			parentHtml="li";
		}else{//怎么做？
			n=$(".secition_box_bottomtop_y:eq(2)>.secition_box_bottom_x>div").length;
			parentHtml="li";
		}
		$(".secition_box_bottom").hide();
		$(".secition_box_bottom05").hide();
		var nn=$('.secition_box_top>div').index(this);
		if(nn==4){
			$(".secition_box_bottom05").show();
		}else{
			$(".secition_box_bottom").eq(nn).show();
			if(nn!=3){
				if ($.trim(list.html())!=""&&n>1) {
					return;
				}
				list.html("");
				loadItem(parentHtml);
			}else{
				window.location.href="../pc/zhaopinRelease.html?projectName=p9";
			}
		}
	});
	$(".secition_box_bottom").eq(0).show();
	$(".secition_box_bottomtop_y").eq(0).show();
	$(".secition_box_bottomtop_y4").eq(0).show();
	$('.secition_box_bottom_x>div').click(function() {
		$('.secition_box_bottom_x>div').removeClass('x-active');
		$(this).addClass('x-active');
		var type=getType();
//		var type=getTwoType();
		var list=getlist();
		var n;
		if(type==20){//互联网+思维？
			n=$(".secition_box_bottomtop_y01>.secition_box_bottom_x>div").length;
		}else if(type==21){//为什么？
			n=$(".secition_box_bottomtop_y02>.secition_box_bottom_x>div").length;
		}else{//怎么做？
			n=$(".secition_box_bottomtop_y03>.secition_box_bottom_x>div").length;
		}
		$(".secition_box_bottomtop_y").hide();
		$(".secition_box_bottomtop_y").eq($('.secition_box_bottom_x>div').index(this)).show();
		if ($.trim(list.html())!=""&&n>1) {
			return;
		}
	//	list.html("");
	//	loadItem("li");
	});

	var projectType=getQueryString("projectType");
	if(projectType){
		var ui_types=$(".ui_type:contains('"+projectType+"')");
		if(ui_types){
			if(projectType=="20"||projectType=="21"||projectType=="22"){
				$('.secition_box_top>div').eq(1).click();
				if(projectType=="21"){
					$('.secition_box_bottom_x>div').eq(1).click();
				}else if(projectType=="22"){
					$('.secition_box_bottom_x>div').eq(2).click();
				}
			}else {
				var ui_type;
				for (var i = 0; i < ui_types.length; i++) {
					var n=$(ui_types[i]).html();
					if(projectType==n){
						ui_type=$(ui_types[i]).parent();
						break;
					}
				}
				ui_type.click();
			}
		}
	}else{
		getlist().html("");
		loadItem(".col-lg-3");
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