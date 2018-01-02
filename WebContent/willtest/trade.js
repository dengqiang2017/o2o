$(function(){
	header.init();
	$(".style03").append('<span class="glyphicon glyphicon-remove" style="float: right;margin-right: 5px;"></span>');
	var classify=$("#list").html();
	var mobileli=$(".body02>ul").html();
	$("#list").html("");
	$(".body02>ul").html("");
var page=0;loadItem();
var load=false;
var over=true;
function loadItem(){
$.get("temp/getArticleList.do",{
		"filter":"json",
		"page":page,
		"num":10,
		"path":"article/1"
	},function(data){
		load=true;
		pop_up_box.loadWaitClose();
		if (data&&data.length>0) {
			$.each(data,function(i,n){
				n=$.parseJSON(n); 
				if(n.htmlname){
					var item=$(classify);
					$("#list").append(item);
					item.find(".title").html(n.title);
					if(n.releaseTime){
						var times=n.releaseTime.split("-");
						item.find("#yearmoth").html(times[0]+"-"+times[1]);
						item.find("#day").html(times[2]);					
					}
					item.click(n,function(event){
						$("#mymodal #releaseTime").html(event.data.releaseTime);
						$("#mymodal #title").html(event.data.title);
						$("#mymodal").modal("toggle");
						$("#mymodal #publisher").html(event.data.publisher);
						$.get("article/1/"+event.data.htmlname,function(htmldata){
							$("#mymodal #contentHtml").html(htmldata);
						});
					});
					$.get("article/1/"+n.htmlname,function(htmldata){
						item.find("#content").html($(htmldata).text().substring(0,95)+"...");
					}); 
				}
			});
		}else{
			over=false;
		} 
	});  
}
	$('.body button').click(function(){
		$("#mymodal").modal("toggle");
	});
	$('#mymodal .glyphicon-remove').click(function(){
		$("#mymodal").modal("hide");
	});
	$('.body>.col-lg-8>.classify').eq(0).css({'display':'block'});
	$('.cut_box>ul>li').click(function(){
		$('.body>.col-lg-8>.classify').hide();
		$('.cut_box>ul>li').removeClass('active2');
		$(this).addClass('active2');
		var i = $('.cut_box>ul>li').index(this);
		$('.body>.col-lg-8>.classify').eq(i).css({'display':'block'})
	});
	var index = 0;
	$('.down').click(function(){
		index++;
		if(index>5){
			index=0;
		}
		$('.cut_box>ul>li').removeClass('active2');
		$('.cut_box>ul>li').eq(index).addClass('active2');
		$('.body>.col-lg-8>.classify').hide();
		$('.body>.col-lg-8>.classify').eq(index).css({'display':'block'});
	});
	$('.up').click(function(){
		index--;
		if(index<0){
			index=5;
		}
		$('.cut_box>ul>li').removeClass('active2');
		$('.cut_box>ul>li').eq(index).addClass('active2');
		$('.body>.col-lg-8>.classify').hide();
		$('.body>.col-lg-8>.classify').eq(index).css({'display':'block'});
	});
	$('.pull-right').click(function(){
		$('.tc_box').toggle();
		$('.close').show();
	});
	$('.close').click(function(){
		$('.close').hide();
		$('.tc_box').hide();
	});
	$('.body02>ul>li').click(function(){
		$("#mymodal2").modal("toggle");
	});
	$('.closed').click(function(){
		$("#mymodal2").modal("hide");
	});
	weixinShare.init('威尔检测','威尔检测-行业资讯');

$(window).scroll(function(){
    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
    	 if(over&&load){
    		 page=page+1;
    		 loadItem(); 
    	 }
    }
 });   
	$("html,body").animate({scrollTop:0},200); 
});

    