$(function(){
	 var height01 =document.documentElement.clientHeight;
	    $('.body').height(height01);
	    maintenance.init();
});
var maintenance={
		init:function(){
			$("body").append('<a href="#cop" class="back-bottom"></a>');
			$("body").append("<div class='back-top' id='scroll'></div>");
			$('#scroll').click(function() {
				$("html,body").animate({
					scrollTop : 0
				}, 200);
			});
			//左侧加载数据
			 $('.subnav>ul>li').click(function(){
			        $('.subnav>ul>li').removeClass('active');
			        $(this).addClass('active');
			        $("#list").html("");
			        pop_up_box.loadWait();
			        $.get("../manager/getFiledList.do",{
			        	"table":$(this).find("span:eq(0)").html(),
			        	"type": $(this).find("span:eq(1)").html()
			        	},function(data){
			        		pop_up_box.loadWaitClose();
			        	 if(data&&data.length>0){
//			        		 data=JsonSort(data,"name");
			        		 if(data[0].info){
			        			 data=$.parseJSON(data[0].info);
			        		 }
			        		 $.each(data,function(i,n){
			        			 if(n.type){
			        				 var item=$($("#item").html());
			        				 $("#list").append(item);
			        				 //{"list":true,"edit":true,"name":"产品外码","filed":"peijian_id","type":"text","len":"30","dataNumber":"zimu"},
			        				 if(n.order>=0){
			        					 item.find(":eq(0) input:eq(0)").val(n.order);
			        				 }else{
			        					 item.find(":eq(0) input:eq(0)").val(99);
			        				 }
			        				 item.find(":eq(0) input:eq(0)").click(function(){
			        					 $(this).select();
			        				 });
			        				 if(n.list){
			        					 item.find("td:eq(1) input:eq(0)").prop("checked",true);
			        				 }else{               
			        					 item.find("td:eq(1) input:eq(0)").prop("checked",false);
			        				 }                  
			        				 if(n.edit){        
			        					 item.find("td:eq(1) input:eq(1)").prop("checked",true);
			        				 }else{               
			        					 item.find("td:eq(1) input:eq(1)").prop("checked",false);
			        				 }
			        				 if(n.required){        
			        					 item.find("td:eq(1) input:eq(2)").prop("checked",true);
			        				 }else{               
			        					 item.find("td:eq(1) input:eq(2)").prop("checked",false);
			        				 }
			        				 
			        				 item.find("td:eq(2) select").val(n.type);
			        				 item.find("td:eq(2) select").change(function(){
			        					 maintenance.selectChange($(this));
			        				 });
			        				 maintenance.selectChange(item.find("td:eq(2) select"));
			        				 item.find("#filed input").val(n.filed);
			        				 item.find("#filedtype").html(n.type);
			        				 item.find("td:eq(4) input").val(n.showName);//字段别称
			        				 item.find("td:eq(5) input").val(n.name);//中文名称
			        				 item.find("td:eq(6) select").val(n.dataNumber);// 文本模式->输入类型
			        				 item.find("td:eq(7) input").val(n.len);// 文本模式->输入长度
//			        			 {"list":true,"edit":true,"name":"物料状态","filed":"item_status","type":
//			        				 "select","option":[{"opName":"使用","opVal":"使用","selected":"selected"},{"opName":"停用","opVal":"停用"}]},
			        					 item.find("#selectList").html("");
			        					 if(n.option&&n.option.length>0){
			        						 for (var j = 0; j < n.option.length; j++) {
			        							 var op=n.option[j];
			        							 var selectItem=$($("#selectItem").html());
			        							 item.find("#selectList").append(selectItem);
			        							 selectItem.find(".box_center input:eq(0)").val(op.opVal);
			        							 selectItem.find(".box_center input:eq(1)").val(op.opName);
			        							 selectItem.find(".box_bottom button:eq(1)").click(function(){//增加
			        								 addselectItem(this);
			        							 });
			        							 selectbtn(selectItem);
			        						 }
			        					 }else{
			        						 var selectItem=$($("#selectItem").html());
		        							 item.find("#selectList").append(selectItem);
		        							 selectItem.find(".box_bottom button:eq(1)").click(function(){//增加
		        								 addselectItem(this);
		        							 });
		        							 selectbtn(selectItem);
			        					 }
			        					 function addselectItem(t){
			        						 var selectaddItem=$($("#selectItem").html());
			        						 $(t).parents(".select_item").after(selectaddItem);
			        						 selectaddItem.find(".box_bottom button:eq(1)").click(function(){
			        							 addselectItem(this);//递归方式注册增加事件
			        						 });
			        						 selectbtn(selectaddItem);//注册上移和删除事件
			        					 }
			        					 function selectbtn(selectItem){//注册上移和删除事件
			        						 selectItem.find(".box_bottom button:eq(0)").click(function(){
			        							 var divtop=$(this).parents(".select_item");
			        							 var index=$(this).parents(".box").find(".select_item").index(divtop);
			        							 if (index>0) {
			        								 $(this).parents(".select_item").insertBefore($(this).parents(".box").find(".select_item:eq("+(index-1)+")"));
			        							 }
			        						 });
			        						 selectItem.find(".box_bottom button:eq(2)").click(function(){
			        							 $(this).parents(".select_item").remove();
			        						 });
			        					 }
			        					 if(n.type&&n.type=="select"){
			        						 
			        					 }else if(n.type&&n.type=="liulan"){
			        				 }else if(n.type&&n.type=="fenge"){
			        				 }else{
			        				 }
			        				 item.find(".box_bottomL input[name='showNameId']").val(n.showNameId);
			        				 item.find(".box_bottomL input[name='filedId']").val(n.filedId);
			        				 item.find(".box_bottomL input[name='btnId']").val(n.btnId);
			        				 item.find(".up").click(function(){
			        					 var divtop=$(this).parents(".panel");
    									 var index=$(this).parents("#list").find(".panel").index(divtop);
    									 if (index>0) {
    										 $(this).parents(".panel").insertBefore($(this).parents("#list").find(".panel:eq("+(index-1)+")"));
    									 }
			        				 });
			        				 item.find(".down").click(function(){
			        					 var divtop=$(this).parents(".panel");
			        					 var index=$(this).parents("#list").find(".panel").index(divtop);
			        					 var len=divtop.find(".down").length-1;
			        					 if (index>0) {
			        						 $(this).parents(".panel").insertAfter($(this).parents("#list").find(".panel:eq("+(index+1)+")"));
			        					 }
			        				 });
			        				 item.find(".del").click(function(){
			        					 $(this).parents(".panel").remove();
			        				 });
			        				 item.find(".yinc").click(function(){
			        					 $(this).parents(".panel").hide();
			        				 });
			        				 item.find(".btn_styleK").click(function(){
			        					 var it=$($("#item").html());
			        					 $(this).parents(".panel").after(it);
			        					 it.find("td:eq(2) select").change(function(){
				        					 maintenance.selectChange($(this));
				        				 });
			        				 });
			        			 }
			        		 });
			        		 $("#list").sortable();
			        	 }
			        });
			    });$('.subnav>ul>li:eq(0)').click();
			    //保存数据
			    $(".btn_styleP").click(function(){
			    	var list=$("#list .panel");
			    	if(list&&list.length>0){
			    		var filedlist=[];
			    		for (var i = 0; i < list.length; i++) {
							var item=$(list[i]);
							var json={};
							json.name=item.find("input[name='nameCh']").val();
							json.type=item.find("select[name='type']").val();
							var txt=json.type;
							json.order=parseInt(item.find("input[name='order']").val());
							if(txt=="fenge"){
							}else{
								json.list=item.find("input:checkbox:eq(0)").prop("checked");
								json.edit=item.find("input:checkbox:eq(1)").prop("checked");
								json.required=item.find("input:checkbox:eq(2)").prop("checked");
								json.showName=$.trim(item.find("input[name='showName']").val());
								json.filed=$.trim(item.find("#filed input").val());
								 if(txt=="text"||txt=="textarea"||txt=="tel"||txt=="date"||txt=="datetime"){
									 json.len=$.trim(item.find("input[name='len']").val());
									 json.dataNumber=$.trim(item.find("select[name='dataNumber']").val());
								 }else if(txt=="select"){
									 json.option=[];
									 var sels=item.find("#selectList .select_item");
									 if(sels&&sels.length>0){
										 for (var j = 0; j < sels.length; j++) {
											var selItem=$(sels[j]);
											var seljson={};
											seljson.opName=$.trim(selItem.find("input[name='optionName']").val());
											seljson.opVal=$.trim(selItem.find("input[name='optionVal']").val());
											json.option.push(seljson);
										}
									 }
									 
								 }else if(txt=="liulan"){
									 json.showNameId=$.trim(item.find("input[name='showNameId']").val());
									 json.filedId=$.trim(item.find("input[name='filedId']").val());
									 json.btnId=$.trim(item.find("input[name='btnId']").val());
								 }
							}
							filedlist.push(JSON.stringify(json)+"\n");
						}
			    		///
			    		pop_up_box.postWait();
//			    		filedlist=JsonSort(filedlist,"order");
			    		$.post("../manager/saveFiled.do",{
			    			"type": $.trim($(".subnav .active span:eq(1)").html()),
			    			"filedlist":"["+filedlist.join(",")+"]"
			    		},function(data){
			    			pop_up_box.loadWaitClose();
			    			if (data.success) {
								pop_up_box.showMsg("成功!");
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
			    		});
			    	}
			    	
			    });
		},selectChange:function(t){
			var txt=t.val();
			var pt=t.parents(".panel");
			 t.parents("tr").find("td").hide();
			 pt.find("th").hide();
			 if(txt=="fenge"){
				 pt.find("th:eq(0)").show();
				 pt.find("th:eq(1)").show();
				 pt.find("th:eq(2)").show();
				 pt.find("th:eq(5)").show();
				 t.parents("tr").find("td:eq(0)").show();
				 t.parents("tr").find("td:eq(1)").show();
				 t.parents("tr").find("td:eq(2)").show();
				 t.parents("tr").find("td:eq(5)").show();
				 pt.find('.pattern').hide();
				 pt.find('.pattern_left').hide();
				 pt.find('.pattern_right').hide();
				 pt.find('.panel_table').show();
			 }else if(txt=="text"||txt=="textarea"||txt=="tel"||txt=="number"||txt=="date"||txt=="datetime"){
				 pt.find('.panel_table').show();
				 pt.find('.pattern').hide();
				 t.parents("tr").find("td").show();
				 pt.find("th").show();
			 }else if(txt=="select"){
				 pt.find("th:eq(0)").show();
				 pt.find("th:eq(1)").show();
				 pt.find("th:eq(2)").show();
				 pt.find("th:eq(3)").show();
				 pt.find("th:eq(4)").show();
				 pt.find("th:eq(5)").show();
				 t.parents("tr").find("td:eq(0)").show();
				 t.parents("tr").find("td:eq(1)").show();
				 t.parents("tr").find("td:eq(2)").show();
				 t.parents("tr").find("td:eq(3)").show();
				 t.parents("tr").find("td:eq(4)").show();
				 t.parents("tr").find("td:eq(5)").show();
				 pt.find('.pattern').show();
				 pt.find('.pattern_left').show();
				 pt.find('.pattern_right').hide();
				 pt.find('.panel_table').show();
			 }else if(txt=="liulan"){
				 pt.find("th:eq(0)").show();
				 pt.find("th:eq(1)").show();
				 pt.find("th:eq(2)").show();
				 pt.find("th:eq(3)").show();
				 pt.find("th:eq(4)").show();
				 pt.find("th:eq(5)").show();
				 t.parents("tr").find("td:eq(0)").show();
				 t.parents("tr").find("td:eq(1)").show();
				 t.parents("tr").find("td:eq(2)").show();
				 t.parents("tr").find("td:eq(3)").show();
				 t.parents("tr").find("td:eq(4)").show();
				 t.parents("tr").find("td:eq(5)").show();
				 pt.find('.pattern').show();
				 pt.find('.pattern_left').hide();
				 pt.find('.pattern_right').show();
				 pt.find('.panel_table').show();
			 }else{
				 pt.find("th").show();
				 t.parents("tr").find("td").show();
				 pt.find('.pattern').show();
				 pt.find('.pattern_left').show();
				 pt.find('.pattern_left').show();
				 pt.find('.panel_table').show();
			 }
		}
}