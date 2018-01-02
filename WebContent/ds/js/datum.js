$(function(){
	datum.init();
});
var datum={
		init:function(){
			var clerk_id=getQueryString("clerk_id");
			var page=0;
			var count=0;
			var totalPage=0;
			var load=true;
			$("#jzlist").html("");
			loadData();
			function loadData(){
			    pop_up_box.loadWait();
			    $.get("../product/getProductPageByTypeName.do",{
			    	"com_id":com_id,
			    	"page":page,
			    	"searchKey":$.trim($("#searchKey").val()),
			    	"count":count,
			    	"clerk_id":clerk_id,
			    	"name":"%家装%"
			    },function(data){
			    	pop_up_box.loadWaitClose();
			    	if(data&&data.rows.length>0){
			    		if(data.rows.length>1){
			    			for (var i = 1; i < data.rows.length; i++) {
			    				var n=data.rows[i];
			    				var item=$($("#jzitem").html());
				    			$("#jzlist").append(item);
				    			if(n.proName){
					    			item.find("#proName").html(n.proName);
				    			}
				    			if (n.miaosu) {
					    			item.find("#miaosu").html(n.miaosu);
								}
				    			if(n.price>0){
					    			item.find("#price").html((n.price/10000)+"万元");
				    			}else{
					    			item.find("#price").html(n.price);
				    			}
				    			item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
				    			item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
				    				window.location.href="spruce_case.jsp?com_id="+event.data.com_id+"&item_id="+event.data.item_id;
				    			});
			    			}
			    		}
			    		//取第一条数据中的员工信息加载
			    		$("#clerkName").html(data.rows[0].clerk_name);
			    		$("#describe").html(data.rows[0].describe);
			    		$("#tx").attr("src","../"+$.trim(com_id)+"/"+$.trim(clerk_id)+"/img"+"/sfz.jpg");
			    		$("#tel").click({"tel":data.rows[0].movtel},function(event){
				    		if(IsPC()){
				    			pop_up_box.showMsg("电话号码:"+event.data.tel);
				    		}else{
				    			window.location.href="tel:"+event.data.tel;
				    		}
			    		});
			    		$("#chat").click({"id":$.trim(data.rows[0].clerk_id)},function(event){
			    			window.open("chat.jsp?clerk_id="+event.data.id+"&com_id="+com_id,"_blank");
			    		});
			    		///
			    		count=data.totalRecord;
						totalPage=data.totalPage;
						weixinShare.init($("#clerkName").html(),$("#describe").html(),$("#tx").attr("src"));
			    	}
			    });
			}
		    pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadData(); 
				}
			});
		}
}