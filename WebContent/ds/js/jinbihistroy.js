var jinbihistroy={
		init:function(){
			//获取总数
			$.get("../client/getQiandaoInfo.do",function(data){
				$("#totalJinbi").html(data.totalJinbi);
			});
			var page=0;
			var count=0;
			var totalPage=0;
			var flag="";
			$("#zhuan").click(function(){
				 page=0;
				 count=0;
				flag=0;$("#list").html("");
				loadData();
			});
			$("#hua").click(function(){
				 page=0;
				 count=0;
				flag=1;$("#list").html("");
				loadData();
			});
			//获取列表
			function loadData(){
				pop_up_box.loadWait();
				$.get("../client/getJinbiPage.do",{
					"flag":flag,
					"page":page,
					"count":count
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.rows&&data.rows.length>0){
						$.each(data.rows,function(i,n){
							var item=$($("#item").html());
							$("#list").append(item);
							item.find("#time").html(n.time);
							item.find("#source").html(n.source);
							if(n.num>0){
								item.find("#num").html("+"+n.num);
							}else{
								item.find("#num").html(n.num);
							}
						});
					}
					count=data.totalRecord;
					page=data.totalPage;
				});
			}
			loadData();
			pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadData(); 
				}
			});
		}
}
$(function(){
	jinbihistroy.init();
});