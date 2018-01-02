$(function(){
//1.获取文章列表
	//1.2 获取员工内编码
	var type=getQueryString("type");
	if(type!="select"){
		$("#confim").hide();
	}else{
		$("#send").show();
	}
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
	$("#confim").click(function(){
		if (jsonList.length>0) {
			localStorage.setItem("jsonList",jsonList);
			window.location.href="send.jsp";
		}else{
			pop_up_box.showMsg("请选择发送内容!");
		}
	});
	var page=0;
	var count=0;
	var totalPage=0;
	//1.3 获取当前员工是否可以查看所+有
	var jsonList=[];
	$(".find").click(function(){
		$(".history-list").html("");
		page=0;
		count=0;
		jsonList=[];
		loadItem();
	});
	$(".history-list").html("");
	$("#guanwan").change(function(){
		$(".history-list").html("");
		page=0;
		count=0;
		jsonList=[];
		loadItem();
	});
	 if(!IsPC()){
		 $("#addArticle").hide();
	 }
	loadItem();
	function loadItem(){
//		$.get("../temp/getArticleListByEmployee.do",{
		var clerk_id=$.trim($("#clerkId").html());
		var guanwan=$.trim($("#guanwan").val());
		var param={
				"beginDate":$(".Wdate:eq(0)").val(),
				"endDate":$(".Wdate:eq(1)").val(),
				"searchKey":$.trim($("#searchKey").val()),
				"guanwan":$.trim($("#guanwan").val()),
				"page":page,
				"count":count,
				"rows":10
		};
		if(guanwan==""){
			param.clerk="clerk";
			if($("#confim").css("display")=="none"){
				$("#clerk_id").html(clerk_id);
				$("#clerkName").val($("#clerk_name").html());
			}
			param.clerk_id=$.trim($("#clerk_id").html());
			param.clerkName=$.trim($("#clerkName").val());
		}else{
			param.projectName=guanwan.split("-")[0];
			param.type=guanwan.split("-")[1];
		}
		$.get("../temp/getArticlePage.do",param,function(data){
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
//				n=$.parseJSON(n);
				var item=$($("#item").html());
				$(".history-list").append(item);
				item.find("#title").attr("title",n.title);
				item.find("#releaseTime").html(n.releaseTime);
				item.find("#publisher").html(n.publisher);
				var url=n.htmlname.replace("html","json");
				var len=7;
	            if(n.projectName.indexOf("p")==0){
	          	  url="/"+n.projectName+"/article/"+n.type+"/"+url;
	          	  item.find(".edit").hide();
	          	  item.find(".del").hide();
	          	  len=10;
	            }
	            if(url.indexOf(clerk_id)<=0){
	            	item.find(".edit").hide();
	            	item.find(".del").hide();
	            	len=10;
	            }
	            if(!IsPC()){
	            	item.find(".edit").hide();
	            	item.find(".del").hide();
	            	len=20;
	            }
	            if($("#confim").css("display")=="none"){
	            	item.find('.check').hide();
	            	if(len==10){
	            		len=12;
	            	}else if(IsPC()){
	            		len=10;
	            	}
	            }else{
	            	len=10;
	            	item.find(".edit").hide();
	            	item.find(".del").hide();
	            }
	            item.find("#title").html(n.title.substr(0,len)+"...");
				item.find("#htmlname").html(url);
				item.find("#gjc").html(n.gjc);
				if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
					if(n.projectName.indexOf("p")==0){
						item.find(".box-img>img").attr("src","/"+n.projectName+"/"+n.img);
					}else{
						item.find(".box-img>img").attr("src",n.img);
					}
				}else{
					if(n.projectName.indexOf("p")==0){
						item.find(".box-img>img").attr("src","/"+n.projectName+"/"+n.poster);
					}else{
						item.find(".box-img>img").attr("src",n.poster);
					}
				}
				item.find(".box-img").click({"htmlname":url},function(event){
					window.location.href="case_detail.jsp?url="+event.data.htmlname;
				});
				item.find(".edit").click({"htmlname":n.htmlname},function(event){
					window.location.href="articleDialog.jsp?htmlname="+event.data.htmlname;
				});
				item.find(".del").click({"htmlname":n.htmlname},function(event){
					if (confirm("是否要删除该文档内容!")) {
						var par=$(this).parents(".contant");
						var htmlname=event.data.htmlname.replace("item.html", "");
//						$.get("../upload/removeTemp.do",{
						 $.get("../temp/delArticle.do",{
							 "htmlname":event.data.htmlname,
							 "clerk":"clerk",
							 "imgUrl":htmlname
						 },function(data){
							 if (data.success) {
								pop_up_box.toast("删除成功!",1500);
								par.remove();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("删除错误!" + data.msg);
								} else {
									pop_up_box.showMsg("删除错误!");
								}
							}
						 }); 
					}
				});
				item.find('.check').click({"projectName":n.projectName,"type":n.type,"htmlname":url},function(event){
		              var n = $(this).hasClass('fa-square');
		              var url=$(this).parents(".contant").find("#htmlname").html();
		              var projectName=event.data.projectName;
		              if(n){
		                  $(this).removeClass('fa-square').addClass('fa-check-square');
		                  if($.inArray(url,jsonList)<0){//判断元素在数组中是否存在
		                	  jsonList.push(url);
		                  }
		              }else{
		                  $(this).removeClass('fa-check-square').addClass('fa-square');
		                  	jsonList.removeByValue(url);
			          }
			      });
			   });
//			$(".history-list").append('<div class="clearfix"></div>');
			}
		totalPage=data.totalPage;
		count=data.totalRecord;
		});
	}
	$(window).scroll(function(){
	    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
	    	if(totalPage>page){
	    		page=page+1;
	    		loadItem(); 
	    	}
	    }
	 }); 
});
