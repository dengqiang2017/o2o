weixinShare.init("牵引互联多图文消息发送(框架页面)","可用于业务员向客户发送营销类图文消息,也可用于企业内部员工部门或供应商之间图文消息的发布"); 
$(function() {
    $("#tabs").tabs();
    $("#tabs2").tabs();
    $(".ui_receiver").html("");
    $(".btn-success").click(function(){
    	var txt=$(this).text();
    	if (txt.indexOf("员工")>=0) {
    		pop_up_box.loadWait(); 
    		   $.get("../manager/getDeptTree.do",{"type":"employee"},function(data){
    			   pop_up_box.loadWaitClose();
    			   $("body").append(data);
    			   o2otree.selectType=1;
    			   employee.init(function(){
    				   if($(".modal").find("tr.activeTable").length>0){
    					   for (var i = 0; i < $(".modal").find("tr.activeTable").length; i++) {
    						var tr=$($(".modal").find("tr.activeTable")[i]);
    						var ui_weixinid=tr.find("td:eq(3)").text();
    						var name=tr.find("td:eq(0)").text();
    						var id=tr.find("td:eq(0)>input").val();
    					   var item=$($("#item").html());
    					   $("#tabs-1").find(".ui_receiver").append(item);
    					   item.find(".ui_ipt").append(name);
    					   item.find(".ui_id").append(id);
    					   item.find(".ui_weixinid").append(ui_weixinid);
    					}
    				   }
    			   });
    		   });
    	}else if(txt.indexOf("客户")>=0){
    		 pop_up_box.loadWait(); 
    		   $.get("../manager/getClientTree.do",function(data){
    			   pop_up_box.loadWaitClose();
    			   $("body").append(data);
    			   o2otree.selectType=1;
    			   $(".modal").find(".nav-tabs li:eq(1)").show();
    			   client.init(function(){
    				   if($(".modal").find("tr.activeTable").length>0){
    					   for (var i = 0; i < $(".modal").find("tr.activeTable").length; i++) {
    						var tr=$($(".modal").find("tr.activeTable")[i]);
    						var ui_weixinid=tr.find("td:eq(5)").text();
    						var name=tr.find("td:eq(0)").text();
    						var id=tr.find("td:eq(0)>input").val();
    					   var item=$($("#item").html());
    					   $("#tabs-2").find(".ui_receiver").append(item);
    					   item.find(".ui_ipt").append(name);
    					   item.find(".ui_id").append(id);
    					   item.find(".ui_weixinid").append(ui_weixinid);
    					}
    				   }
    			   });
    		   });
    	}else if(txt.indexOf("供应商")>=0){
    		 pop_up_box.loadWait();
     	   $.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
     		   pop_up_box.loadWaitClose();
     		   $("body").append(data);
     		  o2otree.selectType=1;
    			   vendor.init(function(){
    				   if($(".modal").find("tr.activeTable").length>0){
    					   for (var i = 0; i < $(".modal").find("tr.activeTable").length; i++) {
    						var tr=$($(".modal").find("tr.activeTable")[i]);
    						var ui_weixinid=tr.find("td:eq(2)").text();
    						var name=tr.find("td:eq(0)").text();
    						var id=tr.find("td:eq(0)>input").val();
    					   var item=$($("#item").html());
    					   $("#tabs-3").find(".ui_receiver").append(item);
    					   item.find(".ui_ipt").append(name);
    					   item.find(".ui_id").append(id);
    					   item.find(".ui_weixinid").append(ui_weixinid);
    					}
    				   }
    			  });
     	   });
    	}
    });
    $(".ui_list").sortable();
    $("#send").click(function(){
    	var receiverInfo={};
    	var ui_ipt_item=$(".ui_ipt_item");
    	if (ui_ipt_item&&ui_ipt_item.length>0) {
    		for (var i = 0; i < ui_ipt_item.length; i++) {
    			var item=$(ui_ipt_item[i]);
    			var id=$.trim(item.find(".ui_id").html());
    			var ui_weixinid=$.trim(item.find(".ui_weixinid").html());
    			var name=$.trim(item.find(".ui_ipt").html());
    			if(id.indexOf("C")==0&&ui_weixinid&&ui_weixinid!=""){
    				if(receiverInfo.clientName==""){
    					receiverInfo.clientName=name;
    					receiverInfo.clientid=ui_weixinid;
    				}else{
    					receiverInfo.clientid=receiverInfo.clientid+"|"+ui_weixinid;
    					receiverInfo.clientName=receiverInfo.clientName+"|"+name;
    				}
    				receiverInfo.clientType="客户";
    			}else if(id.indexOf("E")==0&&ui_weixinid&&ui_weixinid!=""){
    					if(!receiverInfo.employeeName||receiverInfo.employeeName==""){
    						receiverInfo.employeeid=ui_weixinid;
    						receiverInfo.employeeName=name;
    					}else{
    						receiverInfo.employeeid=receiverInfo.employeeid+"|"+ui_weixinid;
    						receiverInfo.employeeName=receiverInfo.employeeName+"|"+name;
    					}
    					receiverInfo.employeeType="员工";
    			}else if(id.indexOf("G")==0&&ui_weixinid&&ui_weixinid!=""){
    				if(receiverInfo.gysName==""){
    					receiverInfo.gysName=name;
    					receiverInfo.gysid=ui_weixinid;
    				}else{
    					receiverInfo.gysid=receiverInfo.gysid+"|"+ui_weixinid;
    					receiverInfo.gysName=receiverInfo.gysName+"|"+name;
    				}
    				receiverInfo.gysType="供应商";
    			}
    		}
    	var jsonList=[];
    	var uilist=$(".ui_list .ui_item");
    	if(uilist&&uilist.length>0){
    			for (var i = 0; i < uilist.length; i++) {
    				var json={};
    				var item=$(uilist[i]);
    				json.title=item.find(".ui_title").html();//标题
//    				json.description=item.find(".ui_desc").html();//描述
    				json.url=item.find(".ui_url").html();//消息进入路径
    				json.imgName=item.find("img").attr("src").replace("..", "");//封面图片路径
//     				json.time="";//发送时间
//     				json.ret="";//发送结果
    				jsonList.push(JSON.stringify(json));
    			}
    			pop_up_box.postWait();
    			$.post("../weixin/sendArticles.do",{
    				"articleList":"["+jsonList.join(",")+"]",
    				"receiverInfo":JSON.stringify(receiverInfo)
    			},function(data){
    				pop_up_box.loadWaitClose();
    				if (data.success) {
    					pop_up_box.showMsg("发送成功!");
    				} else {
    					if (data.msg) {
    						pop_up_box.showMsg("发送错误!" + data.msg);
    					} else {
    						pop_up_box.showMsg("发送错误!");
    					}
    				}
    			});
    		}else{
    			pop_up_box.showMsg("请选择消息发送内容!");
    		}
    	}else{
    		pop_up_box.showMsg("请选择消息接收人!");
    	}
    });
  });