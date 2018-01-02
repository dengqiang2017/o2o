var zixun={
		init:function(projectName){
			var page=0;
			var count=0;
			var totalPage=0;
			var type=1;
			var rows=10;
//			var projectName="jiaju";
			$("html,body").animate({scrollTop:0},200);
			$("#list").html("");
			function loadItem(){
			$.get("/temp/getArticleList.do",{
				"com_id":header.getComId(),
				"page":page,
				"count":count,
				"projectName":projectName,
				"type":type,
				"rows":rows,
				"path":projectName+"/article/"+type
			},function(data){
				pop_up_box.loadWaitClose();
				if (data&&data.length>0) {
					$.each(data,function(i,n){
						n=$.parseJSON(n);
						if(n.count!=undefined){
							return;
						}
						var item=$($("#item").html());
						$("#list").append(item);
						item.find("#title").html(n.title);
						item.find("#desc").html(n.gjc);
						if(n.releaseTime&&$.trim(n.releaseTime)!=""){
							var dates=n.releaseTime.split("-");
							item.find("#nian").html(dates[0]+"/"+dates[1]);
							item.find("#ri").html(dates[2]);
						}
						if(n.htmlname){
							item.find("#title").attr("href","zixun_detail.jsp?url="+projectName+"/article/"+type+"/"+n.htmlname);
						}
					});
				}
				totalPage=data.totalPage;
				count=data.totalRecord;
				});
			}
			loadItem(); 
			$(window).scroll(function(){
			    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
			    	if(page<totalPage){
			    		page=page+1;
			    		loadItem(); 
			    	}
			    }
			 });

		}
}
header.init(function(){
	$.get("filename.txt",function(data){
		zixun.init(data);
	});
})
