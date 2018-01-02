$(function(){
	$("#clerkBtn").click(function(){
		pop_up_box.loadWait(); 
		   $.get("../manager/getDeptTree.do",{"type":"employee"},function(data){
			   pop_up_box.loadWaitClose();
			   $("body").append(data);
			   employee.init(function(){
				   $("#clerk_id").html($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
				   $("#clerkName").val($(".modal").find("tr.activeTable").find("td:eq(0)").text());
			   });
		   });
	});
	$("#clerkName").change(function(){
		if($.trim($(this).val())==""){
			$("#clerk_id").html("");
		}
	});
	 var imgitem=$("#item");
	 var page=0;
	 var over=false;
	 var load=true;
	 $(".history-list").html("");
	 $(".find").click(function(){
		 $(".history-list").html("");
		 	page=0;
		 	load=true;
		 	jsonList=[];
		 	loadItem();
	 });
	 loadItem();
	 function loadItem(){
		 pop_up_box.loadWait();
		 over=false;
			$.get("../temp/getArticleListByEmployee.do",{
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"clerk_id":$("#clerk_id").html(),
			"searchKey":$.trim($("#searchKey").val()),
			"clerkName":$.trim($("#clerkName").val()),
			"filter":"json",
			"desc":"desc",
			"type":"history",
			"page":page,
			"num":6
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.length>0) {
				over=true;
				$.each(data,function(i,n){
					n=$.parseJSON(n);
					var infos=n.data;
					$.each(infos,function(j,k){
						var item=$(imgitem.html());
						$(".history-list").append(item);
						item.find("#sendTime").html(n.time);
						item.find("#recRen").html(n.clientName);
						item.find("#publisher").html(n.publisher);
						if(n.clientRet){
							item.find("#ret").html(n.clientRet);
						}
						if(n.clientServiceRet){
							item.find("#serviceRet").html(n.clientServiceRet);
						}
						item.find("#title").html(k.title.substr(0,7)+"...");
						item.find("#title").attr("title",k.title);
						item.find(".box-img>img").attr("src",k.imgName);
						item.find("#htmlname").html(k.url.replace("html","json"));
//						item.find("#gjc").html(n.gjc);
						item.find(".box-img").click({"htmlname":k.url},function(event){
							window.location.href= event.data.htmlname+"&type=liu";
						});
					});
				   });
			}else{
				load=false;
			}
		});
	}
	$(window).scroll(function(){
	    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
	    	 if(over&&load){
	    		 page=page+1;
	    		 loadItem(); 
	    	 }
	    }
	 }); 
});