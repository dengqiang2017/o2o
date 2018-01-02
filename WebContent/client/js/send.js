$('.word-list-box').hover(function(){
        $('.word-list-box .box-title').css({backgroundColor: '#ffffff',color: '#000000'});
        $(this).find('.box-title').css({backgroundColor: '#707070',color: '#ffffff'});
        $('.box-title img').hide();
        $(this).find('.box-title').find('img').show();
    });
    $('.contant').hover(function(){
        $('.contant .box-title').css({backgroundColor: '#ffffff',color: '#000000'});
        $(this).find('.box-title').css({backgroundColor: '#707070',color: '#ffffff'});
        $('.box-title img').hide();
        $(this).find('.box-title').find('img').show();
    });
    setInterval(function(){
        //监测每个高度,
        var lis=$(".li-center");
        //循环获取每一个
        for (var i = 0; i < lis.length; i++) {
            var li=$(lis[i]);
            li.next().css("height",li.css("height"));
        }
    }, 100);
    $(".word-list").sortable({axis:"X"});
    ///////////
    var weixinID=getQueryString("weixinID");
    var selectClient=localStorage.getItem("selectClient");
    var selectEmployee=localStorage.getItem("selectEmployee");
    var selectGys=localStorage.getItem("selectGys");
    var receiverInfo={};
    if(weixinID){
    	receiverInfo.clientid=weixinID;
    	var name=decodeURI(window.location.href.split("?")[1].split("&")[1].split("=")[1])
    	receiverInfo.clientName=name;
    	$("#khbf,#khlb").show();
    	$("#khbf").attr("href","relationship.html?customer_id="+getQueryString("customer_id"));
    }else if(selectClient&&selectClient!="undefined"){
    	$.get("../client/getClientInfoById.do",{
    		"selectClient":selectClient,
    		"selectGys":selectGys,
    		"selectEmployee":selectEmployee
    	},function(data){
    		if(data){
    			$.each(data,function(i,n){
    				if($("#clientSelect").prev().html().indexOf(n.name)<0){
    					   var item=$($("#item").html());
    					   $("#clientSelect").prev().append(item);
    					   item.find("#name").html(n.name);
    					   item.find("#weixinID").html(n.weixinID);
    					   item.find("#customerId").html(n.customer_id);
    					   item.click(function(){
    						   delclient(this);
    					   });
    				   }
    			});
    		}
    	});
    }else{
    	selectClient="";
    }
    function delclient(t){
		 $(t).remove();
		 saveId("clientSelect", "selectClient");
    }
    //选择员工
    o2otree.selectType=1;
    $("#employeeSelect").click(function(){
    	pop_up_box.loadWait(); 
 	   $.get("../manager/getDeptTree.do",{"type":"employee"},function(data){
 		   pop_up_box.loadWaitClose();
 		   $("body").append(data);
 		   employee.init(function(){
 			   for (var i = 0; i < $(".modal-body .activeTable").length; i++) {
 				  var customerId=$.trim($($(".modal-body .activeTable")[i]).find("input").val());
 				   if($("#employeeSelect").prev().html().indexOf(customerId)<0){
 					   var item=$($("#item").html());
 					   $("#employeeSelect").prev().append(item);
 					   item.find("#name").html($($(".modal-body .activeTable")[i]).find("td:eq(0)").text());
 					   var weixinID=$($(".modal-body .activeTable")[i]).find("td:eq(3)").text();
 					   item.find("#weixinID").html(weixinID);
  					   item.find("#customerId").html(customerId);
 					   item.click(function(){
 						   $(this).remove();
 					   });
 				   }
			}
 			  saveId("employeeSelect", "selectEmployee");
 		   });
 		  employee.backshow(function(){
   			 var trs=$(".modal-body tbody tr");
   			 for (var i = 0; i < trs.length; i++) {
   				 var tr=$(trs[i]);
   				 if($("#employeeSelect").prev().html().indexOf(tr.find("td:eq(3)").text())>0){
   					 tr.addClass("activeTable");
   				 }
   			 }
   		 });
 	   });
    });
    //选择客户
    $("#clientSelect").unbind("click");
    $("#clientSelect").click(function(){
    	pop_up_box.loadWait(); 
  	   $.get("../manager/getClientTree.do",function(data){
  		   pop_up_box.loadWaitClose();
  		   $("body").append(data);
  		   client.init(function(){
  			   for (var i = 0; i < $(".modal-body .activeTable").length; i++) {
  				   var name=$($(".modal-body .activeTable")[i]).find("td:eq(0)").text();
  				   var b=$("#clientSelect").prev().html().indexOf(name)<0;
  				   if(b){
  					   var item=$($("#item").html());
  					   $("#clientSelect").prev().append(item);
  					   var weixinID=$.trim($($(".modal-body .activeTable")[i]).find("td:eq(2)").text());
  					   item.find("#name").html(name);
  					   item.find("#weixinID").html(weixinID);
  					   var customerId=$.trim($($(".modal-body .activeTable")[i]).find("input").val());
  					   item.find("#customerId").html(customerId);
  					   item.click(function(){
  						   delclient(this);
  					   });
  				   }
 			}
  			 saveId("clientSelect", "selectClient");
  		   });
  		 client.backshow(function(){
  			 var trs=$(".modal-body tbody tr");
  			 for (var i = 0; i < trs.length; i++) {
  				 var tr=$(trs[i]);
  				 if($("#clientSelect").prev().html().indexOf(tr.find("td:eq(2)").text())>0){
  					 tr.addClass("activeTable");
  				 }
  			 }
  		 });
  		   $(".modal-body .nav-tabs>li:eq(1)").click();
  	   });
    });
    //TODO 保存选择的客户ID
    function saveId(clientSelect,selectClientKey){
    	var cus=$("#"+clientSelect).prev().find(".member");
    	if(cus&&cus.length>0){
    		var selectClient="";
    		for (var i = 0; i < cus.length; i++) {
				var item=$(cus[i]);
				var customerId=$.trim(item.find("#customerId").html());
				if(selectClient==""){
					selectClient=customerId;
				}else{
					selectClient=selectClient+","+customerId;
				}
			}
    		localStorage.setItem(selectClientKey,selectClient);
    	}
    }
    //选择供应商
    $("#gysSelect").click(function(){
    	pop_up_box.loadWait(); 
    	$.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
    		pop_up_box.loadWaitClose();
    		$("body").append(data);
    		vendor.init(function(){
    			for (var i = 0; i < $(".modal-body .activeTable").length; i++) {
    				var weixinID=$($(".modal-body .activeTable")[i]).find("td:eq(2)").text();
   				   if($("#gysSelect").prev().html().indexOf(weixinID)<0){
   					   var item=$($("#item").html());
   					   $("#gysSelect").prev().append(item);
   					   item.find("#name").html($($(".modal-body .activeTable")[i]).find("td:eq(0)").text());
   					   item.find("#weixinID").html(weixinID);
  					   var customerId=$.trim($($(".modal-body .activeTable")[i]).find("input").val());
  					   item.find("#customerId").html(customerId);
   					   item.click(function(){
   						   $(this).remove();
   					   });
   				   }
    			}
    			saveId("gysSelect", "selectGys");
    		});
    		vendor.backshow(function(){
      			 var trs=$(".modal-body tbody tr");
      			 for (var i = 0; i < trs.length; i++) {
      				 var tr=$(trs[i]);
      				 if($("#gysSelect").prev().html().indexOf(tr.find("td:eq(2)").text())>0){
      					 tr.addClass("activeTable");
      				 }
      			 }
      		 });
    	});
    });
    //////////
    $(".word-list").html(""); 
    ///显示选择的图文消息从本地存储
    var list=localStorage.getItem("jsonList");
    var index=0;
    if(list){
	    list=list.split(",");
    	if(list.length>0){
    		var len=list.length;
			getSendItem(list[index]);
    	}
    }
    var projectName="";
    function getSendItem(url){
    	if(url.indexOf("json")<0){
    		url=url+".json";
    	}
    	$.get(url,function(data){
    		var item=$($("#imgItem").html());
    		$(".word-list").append(item);
    		item.find("#title").html(data.title);
    		item.find("#title").attr("title",data.title);
    		var url=data.htmlname;
    		if(data.projectName){
    			projectName=data.projectName;
    		}
            if(projectName.indexOf("p")==0){
            	if(data.type){
          	  url="/"+projectName+"/article/"+data.type+"/"+url;
            	}else{
            		url="/"+projectName+"/article/"+data.projectType+"/"+url;
            	}
            }
    		item.find("#htmlname").html(url);
    		item.find("#projectName").html(projectName);
    		if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){
    			if(data.img!=""){
    				if(projectName.indexOf("p")==0){
    					item.find("img:eq(1)").attr("src","/"+projectName+"/"+data.img);
    				}else{
    					item.find("img:eq(1)").attr("src",data.img);
    				}
    			}
    		}else{
    			if(data.poster!=""){
    				if(projectName.indexOf("p")==0){
    					item.find("img:eq(1)").attr("src","/"+projectName+"/"+data.poster);
    				}else{
    					item.find("img:eq(1)").attr("src",data.poster);
    				}
    			}
    		}
    		item.find(".box-title>img").click(function(){
    			$(this).parents('.word-list-box').remove();
    		});
    		index+=1;
    		if(index<list.length){
    			getSendItem(list[index]);
    		}
    	});
    }
    $("#send").click(function(){
    	var sendList=$(".word-list .word-list-box");
    	var receiverInfo={};
    	var sendName="";
    	var all=$("#all").prop("checked");
    	for (var i = 0; i < $(".li-center:eq(0) .member").length; i++) {
			var item=$($(".li-center:eq(0) .member")[i]);
			var name=item.find("#name").html();
			var ui_weixinid=item.find("#weixinID").html();
			var clerkId="'"+item.find("#customerId").html()+"'";
			if(!receiverInfo.employeeName||receiverInfo.employeeName==""){
    			receiverInfo.employeeName=name;
    		}else{
    			receiverInfo.employeeName=receiverInfo.employeeName+"|"+name;
    		}
    		if(ui_weixinid!=""){
    			if(!receiverInfo.employeeid||receiverInfo.employeeid==""){
    				receiverInfo.employeeid=ui_weixinid;
    			}else{
    				receiverInfo.employeeid=receiverInfo.employeeid+"|"+ui_weixinid;
    			}
    		}
    		if(clerkId!=""){
    			if(!receiverInfo.clerkId||receiverInfo.clerkId==""){
    				receiverInfo.clerkId=clerkId;
    			}else{
    				receiverInfo.clerkId=receiverInfo.clerkId+","+clerkId;
    			}
    		}
			receiverInfo.employeeType="员工";
		}
    	////////客户/////
    	for (var i = 0; i < $(".li-center:eq(1) .member").length; i++) {
    		var item=$($(".li-center:eq(1) .member")[i]);
    		var name=item.find("#name").html();
    		var ui_weixinid=item.find("#weixinID").html();
    		var customerId="'"+item.find("#customerId").html()+"'";
    		if(!receiverInfo.clientName||receiverInfo.clientName==""){
    			receiverInfo.clientName=name;
    		}else{
    			receiverInfo.clientName=receiverInfo.clientName+"|"+name;
    		}
    		if(ui_weixinid!=""){
    			if(!receiverInfo.clientid||receiverInfo.clientid==""){
    				receiverInfo.clientid=ui_weixinid;
    			}else{
    				receiverInfo.clientid=receiverInfo.clientid+"|"+ui_weixinid;
    			}
    		}
    		if(customerId!=""){
    			if(!receiverInfo.customerId||receiverInfo.customerId==""){
    				receiverInfo.customerId=customerId;
    			}else{
    				receiverInfo.customerId=receiverInfo.customerId+","+customerId;
    			}
    		}
    		receiverInfo.clientType="客户";
    	}
    	for (var i = 0; i < $(".li-center:eq(2) .member").length; i++) {
    		var item=$($(".li-center:eq(1) .member")[i]);
    		var name=item.find("#name").html();
    		var ui_weixinid=item.find("#weixinID").html();
    		var corpId="'"+item.find("#customerId").html()+"'";
    		if(!receiverInfo.gysName||receiverInfo.gysName==""){
    			receiverInfo.gysName=name;
    		}else{
    			receiverInfo.gysName=receiverInfo.gysName+"|"+name;
    		}
    		if(ui_weixinid!=""){
    			if(!receiverInfo.gysid||receiverInfo.gysid==""){
    				receiverInfo.gysid=ui_weixinid;
    			}else{
    				receiverInfo.gysid=receiverInfo.gysid+"|"+ui_weixinid;
    			}
    		}
    		if(corpId!=""){
    			if(!receiverInfo.corpId||receiverInfo.corpId==""){
    				receiverInfo.corpId=corpId;
    			}else{
    				receiverInfo.corpId=receiverInfo.corpId+","+corpId;
    			}
    		}
    		receiverInfo.gysType="供应商";
    	}
    	if(!receiverInfo&&!all){
    		pop_up_box.showMsg("请选择接收人!");
    	}else if(!sendList.length||sendList.length<0){
    		pop_up_box.showMsg("请选择发送内容!");
    	}else{
    		var jsonList=[];
    		var len=8;
    		if(sendList.length<8){
    			len=sendList.length;
    		}
    		var weixinType=$("input[name='weixintype']:checked").val();
    		if (weixinType=="") {
				pop_up_box.showMsg("请选择消息发送方式!");
    			return;
			}
    		var urlprex="";
    		if(weixinType=="service"){
    			weixinType="0";
    			urlprex="/login/getWeixinCode.do?com_id=@com_id&url=";
    		}else if(weixinType=="qiyehao"){
    			weixinType="1";
    			urlprex="/login/getCodeUrl.do?com_id=@com_id&url=";
    		}else{
    			weixinType="2";
    			urlprex="";
    		}
    		for (var i = 0; i < len; i++) {
				var json={};
				var item=$(sendList[i]);
				json.title=item.find("#title").html();//标题
				json.htmlname=item.find("#htmlname").html();
				projectName=item.find("#projectName").html();
				var url="@urlPrefix/client/article_detail.jsp?url=";
				if(projectName.indexOf("p")==0){
					url="@urlPrefix/"+projectName+"/case_detail.jsp?url=";
				}
				json.url=urlprex+url+json.htmlname+"|_com_id=@com_id|_clerk_id=@clerk_id";//消息进入路径
				json.imgName=item.find(".box-img>img").attr("src").replace("..", "");//封面图片路径
				jsonList.push(JSON.stringify(json));
			}
    		pop_up_box.postWait();
    		$.post("../weixin/sendArticles.do",{
    			"all":all,
    			"weixinType":weixinType,
				"articleList":"["+jsonList.join(",")+"]",
				"receiverInfo":JSON.stringify(receiverInfo)
    		},function(data){
    			pop_up_box.loadWaitClose();
    			if (data.success) {
    				if(data.msg){
    					pop_up_box.showMsg("发送成功!"+data.msg);
    				}else{
    					pop_up_box.showMsg("发送成功!");
    				}
				} else {
					if (data.msg) {
						pop_up_box.showMsg("发送错误!" + data.msg);
					} else {
						pop_up_box.showMsg("发送错误!");
					}
				}
    		});
    	}
    });