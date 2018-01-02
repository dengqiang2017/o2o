var acticity={
		init:function(){
			var page=0;
			var count=0;
			var totalPage=0;
			var type=common.getQueryString("type");
			if(!type){
				type=1;
			}
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			function loadItem(){
				pop_up_box.loadWait();
				$.get("/temp/getArticlePage.do",{
					"com_id":com_id,
					"page":page,
					"count":count,
					"begin_date":nowStr,
					"desc":"desc",
					"projectName":projectName,
					"type":type,
					"rows":10
				},function(data){
					pop_up_box.loadWaitClose();
					if (data&&data.rows.length>0) {
						ver="001";
						$.each(data.rows,function(i,n){
							var item=$($("#imgitem").html());
							$("#list").append(item);
							if(n.title.length>30){
								item.find("#title").html(n.title.substr(0,30)+"...");
								item.find("#title").attr("title",n.title);
							}else{
								item.find("#title").html(n.title);
							}
							item.find("#time").html(ifnull(n.releaseTime));
							item.find("#htmlname").html(ifnull(n.htmlname));
							if(n.img){
								if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
									item.find("img").attr("src","/release/"+n.img+"?ver="+ver);
									item.find("img").show();
								}
							}
							if(n.htmlname){
								item.click({"htmlname":n.htmlname},function(event){
									window.location.href="/"+projectName+"/article_detail.jsp?url="+projectName+"/article/"+type+"/"+event.data.htmlname;
								});
							}
						});
					}
					totalPage=data.totalPage;
					count=data.totalRecord;
				});
			}
			loadItem();
			pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadItem(); 
				}
			});
		}
}
acticity.init();