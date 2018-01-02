function share(index){
	if(index==undefined||index<0){
		index=0;
	}
	var imgsrc;
	if ($("img").length > 0) {
		imgsrc = $("img")[index].src;
	} else {
		imgsrc = "http://www.pulledup.cn/img/qrcode_www.pulledup.cn.png";
	}
//alert($("img")[7].src);  //弹窗测试img的取值
//var imgsrc=$("img")[6].src;  //2017-02-19:图片必须要给id和src，才能生效生效！    
	weixinShare.init("傻瓜变强悍 复杂变简单", "好想随心所欲的生成我想要的二维码，分享给别人扫码、长按、点击,让他们看我想让他们看的东东",imgsrc);
}
var loadData={
		/**
		 * 获取数据
		 * @param id 所在父级元素=projectName
		 * @param page 加载页数
		 * @param type 加载数据类型
		 * @param rows 加载条数
		 */
		getData:function(id,page,type,rows,itemid){
			if(!rows||rows<1){
				rows=4;
			}
			if(!itemid||itemid==""){
				itemid="item";
			}
			$.get("/temp/getArticlePage.do",{
				"page":page,
				"count":$("div[data-id='"+id+"']").find("#count").html(),
				"type":type,
				"projectName":id,
				"rows":rows,
				"path":id+"/article/"+type
			},function(data){
				if(data&&data.rows.length>0){
					$("div[data-id='"+id+"']").find("#list").html("");
					$.each(data.rows,function(i,n){
						$("div[data-id='"+id+"']").find("#page").html(page);
						$("div[data-id='"+id+"']").find("#count").html(n.count);
						var item=$($("#"+itemid).html());
						$("div[data-id='"+id+"']").find("#list").append(item);
						item.find("#title").html(n.title);
						item.find("#desc").html(n.gjc);
						if(n.img){
							if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
								item.find("#slimg").attr("src","/"+id+"/"+n.img+"?ver="+Math.random());
//	 							item.find("#slimg").show();
//	 							item.find("video").hide();
							}else{
//	 							var video=$('<video  controls="controls" src="" style="height:150px;width: 300px;" preload="none" poster=""></video>');
//	 							item.find("#slimg").parent().html(video);
//	 							item.find("video").attr("src",n.img);
								if(n.poster){
									item.find("#slimg").attr("src","/"+id+"/"+n.poster+"?ver="+Math.random());
								}else{
									item.find("#slimg").attr("src","/"+id+"/images/poster.png");
								}
//	 							item.find("video").show();
//	 							item.find("#slimg").hide();
							}
						}
						if(n.htmlname){
							item.click({"htmlname":n.htmlname},function(event){
								window.location.href="/"+id+"/"+name+"case_detail.jsp?url="+id+"/article/"+type+"/"+event.data.htmlname;
							});
						}
					});
				}
				$("div[data-id='"+id+"']").find("#totalPage").html(data.totalPage);
				$("div[data-id='"+id+"']").find("#showpage").html((page+1)+"/"+(data.totalPage+1));
			});
		},
		/**
		 * 分页
		 * @param id 所在父级元素=projectName
		 * @param type 加载数据类型
		 * @param rows 加载条数
		 */
		pageinit:function(id,type,rows,item){
			$("div[data-id='"+id+"']").find("#img-Previous").click(function(){
				var page=$("div[data-id='"+id+"']").find("#page").html();
				if(page==""){
					page=0;
				}else{
					page=parseInt(page);
				}
				if(page>0){
					page=page-1;
					$("div[data-id='"+id+"']").find("#page").html(page);
					loadData.getData(id, page,type,rows,item);
				}
			});
			$("div[data-id='"+id+"']").find("#img-Next").click(function(){
				var page=$("div[data-id='"+id+"']").find("#page").html();
				if(page==""){
					page=0;
				}else{
					page=parseInt(page);
				}
				var totalPage=$("div[data-id='"+id+"']").find("#totalPage").html();
				if(totalPage==""){
					totalPage=0;
				}else{
					totalPage=parseInt(totalPage);
				}
				if(page<totalPage){
					page=page+1;
					$("div[data-id='"+id+"']").find("#page").html(page);
					loadData.getData(id, page,type,rows,item);
				}
			});
		
		}
}
$(function(){
	$('#qqgroup').text(qqgroup);
//	loadData.getData("p2", 0,2,4,"item");
//	loadData.pageinit("p2",2,4,"item");
//	loadData.getData("p1", 0,2,4,"item");
//	loadData.pageinit("p1",2,4,"item");
//	loadData.getData("p9", 0,1,4,"item");
//	loadData.pageinit("p9",1,4,"item");
});