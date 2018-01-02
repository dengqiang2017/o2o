localStorage.removeItem("backurl");
$.removeCookie("backurl", { path: '/' });
$.removeCookie("backurl");
var index={
		i:0,
		data:"",
		init:function(){
			getBannerImg(com_id);
			////////获取头条////////
			if($("#rp1").length>0){
				$.get("/temp/getArticlePage.do",{
					"com_id":com_id,
					"projectName":"release",
					"type":"2",
					"rows":10
				},function(data){
					if (data&&data.rows.length>0) {
						$("#rp1 #rptitle").html(data.rows[index.i].title);
						$("#rp1 #htmlname").html(data.rows[index.i].htmlname);
						index.i++;
						$("#rp2 #rptitle").html(data.rows[index.i].title);
						$("#rp2 #htmlname").html(data.rows[index.i].htmlname);
						index.i++;
						index.data=data.rows;
						setInterval(function(){
							if(index.i==index.data.length){
								index.i=0;
							}
							$("#rptitle").html(index.data[index.i].title);
							$("#htmlname").html(index.data[index.i].htmlname);
							index.i++;
							$("#rp2 #rptitle").html(data.rows[index.i].title);
							$("#rp2 #htmlname").html(data.rows[index.i].htmlname);
							index.i++;
						}, 3000);
						$("#rp1 #rptitle").parent().click(function(){
							window.location.href="headlineNews.jsp?type=2";
						});
						$("#rp2 #rptitle").parent().click(function(){
							window.location.href="headlineNews.jsp?type=2";
						});
					}
				});
			}
//////////////
			 var fs=$(".footer a");
			 for (var i = 0; i < fs.length; i++) {
				var f=$(fs[i]);
				var url=f.attr("href");
				if(url&&url!=""&&url.indexOf("?")>0){
					f.attr("href",url+"&com_id="+com_id+"&ver="+Math.random());
				}else{
					f.attr("href",url+"?com_id="+com_id+"&ver="+Math.random());
				}
			 }
			 fs=$(".box-flex a");
			 for (var i = 0; i < fs.length; i++) {
				 var f=$(fs[i]);
				 var url=f.attr("href");
					if(url&&url!=""&&url.indexOf("?")>0){
						f.attr("href",url+"&com_id="+com_id+"&ver="+Math.random());
					}else{
						f.attr("href",url+"?com_id="+com_id+"&ver="+Math.random());
					}
			 }
			 fs=$(".xs a");
			 for (var i = 0; i < fs.length; i++) {
				 var f=$(fs[i]);
				 var url=f.attr("href");
				 if(url&&url!=""&&url.indexOf("?")>0){
					 f.attr("href",url+"&com_id="+com_id+"&ver="+Math.random());
				 }else{
					 f.attr("href",url+"?com_id="+com_id+"&ver="+Math.random());
				 }
			 }
		/////加载最新产品数据////
			 if($(".case_list").length>0){
				 $(".case_list").html("");
				 pop_up_box.loadWait();
				 $.get("../product/getZEROMOrderProduct.do",{
					 "com_id" :com_id,
					 "discount_ornot":"N",
					 "page":0,
					 "count":0,
					 "rows" :8
				 },function(data){
					 pop_up_box.loadWaitClose();
					 if(data&&data.rows.length>0){
						 $.each(data.rows,function(i,n){
							 var item=$($("#xptsitem").html());
							 $(".case_list").append(item);
							 item.find("#item_name").html($.trim(n.item_name));
							 item.find("#item_name").attr("title",$.trim(n.item_name));
							 item.find("#cost_name").html("￥"+n.sd_unit_price);
							 if(n.sd_unit_price!=n.price_display){
								 item.find("#price_display").html("￥"+n.price_display);
							 }
							 item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
							 item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
								 window.location.href="commodity.jsp?com_id="+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
							 });
						 });
					 }
				 });
			 }
			 if($("#saleslist").length>0){
				 $("#saleslist").html("");
				 $.get("../product/getZEROMOrderProduct.do",{
					 "com_id" :com_id,
					 "discount_ornot":"Y",
					 "page":0,
					 "count":0,
					 "rows" :8
				 },function(data){
					 if(data&&data.rows.length>0){
						 $.each(data.rows,function(i,n){
							 var item=$($("#xptsitem").html());
							 $("#saleslist").append(item);
							 item.find("#item_name").html($.trim(n.item_name));
							 item.find("#item_name").attr("title",$.trim(n.item_name));
							 item.find("#cost_name").html("￥"+n.sd_unit_price);
							 item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
							 item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
								 window.location.href="commodity.jsp?com_id="+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
							 });
						 });
					 }
				 });
			 }
		    if(!IsPC()){
		        $(".footer").addClass("navbar-fixed-bottom");
		        $(".contant").removeClass("contant");
		    }
		    ////获取家装案例
		    if($("#jzlist").length>0){
		    	$.get("../product/getProductByTypeName.do",{
		    		"com_id":com_id,
		    		"name":"%家装%"
		    	},function(data){
		    		if(data&&data.length>0){
		    			$.each(data,function(i,n){
		    				var item=$($("#jzitem").html());
		    				$("#jzlist").append(item);
		    				item.find("#typeName").html(n.typeName);
		    				item.find("#proName").html(n.proName);
		    				item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
		    				item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
		    					window.location.href="spruce_case.jsp?com_id="+event.data.com_id+"&item_id="+event.data.item_id;
		    				});
		    			});
		    		}
		    	});
		    }
		    //获取设计师列表
		    if($("#sjslist").length>0){
		    	$.get("../user/getDesigner.do",{
		    		"com_id":com_id,
		    		"name":"%设计师%"
		    	},function(data){
		    		if(data&&data.rows.length>0){
		    			$.each(data.rows,function(i,n){
		    				var item=$($("#sjsitem").html());
		    				$("#sjslist").append(item);
		    				item.find("#clerkName").html(n.clerkName);
		    				item.find("#describe").html(n.describe);
		    				item.find("img").attr("src","../"+$.trim(n.com_id)+"/"+$.trim(n.clerk_id)+"/img"+"/sfz.jpg");
		    				item.click({"com_id":$.trim(n.com_id),"clerk_id":$.trim(n.clerk_id)},function(event){
		    					window.location.href="datum.jsp?com_id="+event.data.com_id+"&clerk_id="+event.data.clerk_id;
		    				});
		    			});
		    		}
		    	});
		    }
		}
}
var code=common.getQueryString("code");
if(code){
	customer.getCustomer(function(){
		index.init();
	});
}else{
	index.init();
}



