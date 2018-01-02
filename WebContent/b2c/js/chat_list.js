var clerk_id=getQueryString("clerk_id");
    var type=getQueryString("type");
    if(!clerk_id){
    	clerk_id="";
    }
    if(!type){
    	type="kefu";
    }
    	$.get("../login/getChartList.do",{
    		"type":type
    	},function(data){
    		if(data){
    			$.each(data,function(i,n){
    				if(n.id=="img"){
    					return;
    				}
    				var item=$($("#item").html());
    				$("#list").append(item);
    				if (n.context) {
	    				var context=$.parseJSON(n.context);
	    				if(context.kehu){
		    				item.find("#context").html(context.kehu);
	    				}else{
	    					item.find("#context").html(context.kefu);
	    				}
	    				if(context.name){
		    				item.find("#name").html(context.name);
	    				}else{
		    				item.find("#name").html("陌生客户");
	    				}
					}
    				var time="";
    				for (var j = 0; j < 6; j++) {
    					var v=n.name.split(".")[0].split(" ")[1].split("")[j];
    					if(j!=0&&j%2==0){
    						time=time+":"+v;
    					}else{
    						time=time+v;
    					}
					}
    				item.find("#time").html(time);
    				item.click({"customer_id":n.id,"clerk_id":n.clerk_id,"com_id":n.com_id},function(event){
    					if(type=="kefu"){
    						window.location.href="chat.jsp?customer_id="+event.data.customer_id+"&com_id="+event.data.com_id;
    					}else{
    						window.location.href="chat.jsp?customer_id="+event.data.customer_id+"&clerk_id="+event.data.clerk_id+"&com_id="+event.data.com_id;
    					}
    				});
    			});
    			
    		}
    	});