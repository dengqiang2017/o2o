$(function(){
	/////////////
	$('.secition-right').click(function() {
		$('.secition-body').slideToggle();
		$('.bg2').toggle();
	});
	$('.bg2').click(function() {
		$('.bg2').hide();
		$('.secition-body').hide('1s');
	});
	$('.modal-body>ul>li').click(function() {
		var n = $(this).find('.pro-check').hasClass('pro-checked');
		if (n) {
			$(this).find('.pro-check').removeClass('pro-checked')
		} else {
			$(this).find('.pro-check').addClass('pro-checked')
		}
	});
	$("#usePurchase").click(function(){
		var b=$(this).prop("checked");
		if(b){
			$("input[name='purchase_btn_show']").parent().show();
		}else{
			$("input[name='purchase_btn_show']").prop("checked",false);
			$("input[name='purchase_btn_show']").parent().hide();
		}
	});
	$("#usePPlan").click(function(){
		var b=$(this).prop("checked");
		if(b){
			$("input[name='pPlan_btn_show']").parent().show();
		}else{
			$("input[name='pPlan_btn_show']").prop("checked",false);
			$("input[name='pPlan_btn_show']").parent().hide();
		}
	});
	//////////
	var itemhtml=$(".ui_list").html();
	$(".ui_list").html("");
	///获取系统预设职务
	var headshipItem=$('#modal_headship .modal_ul').html();
	 $('#modal_headship .modal_ul').html("");
	$.get('../manager/getJSONArrayByFile.do',{
 	   "path":"headship.json"
    },function(data){
 	   if(data&&data.length>0){
	           $.each(data,function(i,n){
	               var item = $(headshipItem);
	               $('#modal_headship .modal_ul').append(item);
	               item.find(".ui_modal_headship").html(n.name);
	           });
 	   }else{
 		  $('#modal_headship .modal_ul').html("还没有设置职务!");
 	   }
    });
	//获取系统预设微信消息图片
	var imgItem=$("#modal_imgSelect .modal_ul").html();
	$('#modal_imgSelect .modal_ul').html("");
	 $.get('../manager/getJSONArrayByFile.do',{
		 "path":"weixinImg.json"
	 },function(data){
		 if(data&&data.length>0){
			 $.each(data,function(i,n){
				 var item = $(imgItem);
				 $('#modal_imgSelect .modal_ul').append(item);
				 item.find(".ui_modal_img_title").html(n.title);
				 item.find("img").attr("src",".."+ n.imgName);
			 });
		 }else{
			 $('#modal_imgSelect .modal_ul').html("还没有设置消息图片!");
		 }
	 });
	///获取系统预设消息模板
	 var tempItem=$("#modal_tempSelect .list-group").html();
	 $('#modal_tempSelect .list-group').html("");
	 $.get('../manager/getJSONArrayByFile.do',{
		 "path":"news.json"
	 },function(data){
		 if(data&&data.length>0){
			 $.each(data,function(i,n){
				 var item = $(tempItem);
				 $('#modal_tempSelect .list-group').append(item);
				 item.find(".ui_modal_title").html(n.title);
				item.find(".ui_modal_content").html(n.content);
				item.find("img").attr("src", n.imgName);
				item.find(".ui_modal_urlName").html(n.urlName);
				item.find(".ui_modal_url").html(n.url);
			 });
		 }else{
			 $('#modal_tempSelect .modal_ul').html("还没有设置模板消息内容!");
		 }
	 });
	 var tempItem=$("#modal_selectServiceTemp .rows").html();
	 function loadTemple(){
		 $('#modal_selectServiceTemp .rows').html("");
		 $.get('../manager/getJSONArrayByFile.do',{
			 "path":"weixinTemplate"
		 },function(data){
			 if(data&&data.length>0){
				 $.each(data,function(i,n){
					 var item = $(tempItem);
					 $('#modal_selectServiceTemp .rows').append(item);
					 item.find(".ui_modal_title").html(n.title);
					 item.find(".ui_modal_content").html(n.content);
					 item.find(".template_id").html(n.template_id);
					 item.find(".ui_modal_example").html(replaceAll(n.example, "\n", "<br>"));
				 });
				 filterList($("#modal_selectServiceTemp .rows"),".item");
			 }else{
				 $('#modal_selectServiceTemp .modal_ul').html("还没有设置模板消息内容!");
			 }
		 });
	 }
	 $("#modal_selectServiceTemp .find").click(function(){
		 $("#modal_selectServiceTemp #searchKey").change();
	 });
	 loadTemple();
	 $(".newtemp").click(function(){
		 $.get("../temp/tongbuWeixinTemplate.do",function(data){
			 if (data.success) {
				 loadTemple();
			}
		 });
	 });
	 
	 /////////获取订单流程参数	
	 ///选择职务
	function headshipClick(item){
		item.find(".ui_headship button").click(function(){
			var headship=$(this).parents(".ui_headship").find("input").val();
			$("#modal_headship").show();
			$("#modal_headship .modal_ul>li").find("input").prop("checked",false);
			for (var i = 0; i < $("#modal_headship .modal_ul>li").length; i++) {
				var item_M=$($("#modal_headship .modal_ul>li")[i]);
				if(headship.indexOf(item_M.find("span").html())>=0){
					item_M.find("input").prop("checked",true);
				}
			}
			$("#zhiwuSelect").unbind("click");
			$("#zhiwuSelect").click({"headship":$(this).parents(".ui_headship").find("input")},function(event){
				var zhiwus=$("#modal_headship").find("ul").find("input:checked");
				if(zhiwus&&zhiwus.length>0){
					var zhiwu="";
					for (var i = 0; i < zhiwus.length; i++) {
						var item_M=$(zhiwus[i]).parent();
						if(zhiwu==""){
							zhiwu=$.trim(item_M.find("span").text());
						}else{
							zhiwu=zhiwu+","+$.trim(item_M.find("span").text());
						}
					}
					event.data.headship.val(zhiwu);
					$("#modal_headship").hide();
				}else {
					pop_up_box.showMsg("请至少选择一个职务!");
				}
			});
		});
	}
	//选择图片
	function imgClick(item){
		item.find(".ui_img img").click(function(){
			var imgName=$(this).attr("src");
			$("#modal_imgSelect").show();
			$("#modal_imgSelect .modal_ul>li").find("input").prop("checked",false);
			for (var i = 0; i < $("#modal_imgSelect .modal_ul>li").length; i++) {
				var item_M=$($("#modal_imgSelect .modal_ul>li")[i]);
				if(imgName==item_M.find("img").attr("src")){
					item_M.find("input").prop("checked",true);
					break;
				}
			}
			$("#imgSelect").unbind("click");
			$("#imgSelect").click({"img":$(this)},function(event){
				var img=$("#modal_imgSelect").find("ul").find("input:checked");
				if(img){
					event.data.img.attr("src",img.parent().find("img").attr("src"));
					$("#modal_imgSelect").hide();
				}else {
					pop_up_box.showMsg("请选择图片!");
				}
			});
		});
	}
	//选择模板消息
	function selectTemp(item){
		item.find(".selectTemp").click(function(){
			$("#modal_tempSelect").show();
			$("#tempSelect").unbind("click");
			$("#tempSelect").click({"temp":$(this).parent()},function(event){
				var temp=$("#modal_tempSelect").find("ul").find("input:checked");
				if(temp){
					event.data.temp.find(".ui_title").val(temp.parent().find(".ui_modal_content").html());
					event.data.temp.find(".ui_content").val(temp.parent().find(".ui_temp_content").html());
					event.data.temp.find(".ui_url").val(temp.parent().find(".ui_temp_url").html());
					$("#modal_tempSelect").hide();
				}else {
					pop_up_box.showMsg("请选择模板!");
				}
			});
			
		});
	}
	function selectServiceTemp(item){
		item.find(".selectServiceTemp").click(function(){
			$("#modal_selectServiceTemp").show();
			$("#selectServiceTemp").unbind("click");
			$("#selectServiceTemp").click({"temp":$(this).parent()},function(event){
				var temp=$("#modal_selectServiceTemp").find(".rows").find("input:checked").parent();
				if(temp){
					event.data.temp.find(".ui_tempName").html(temp.find(".ui_modal_title").html());
					event.data.temp.find(".template_id").html(temp.find(".template_id").html());
					$("#modal_selectServiceTemp").hide();
				}else {
					pop_up_box.showMsg("请选择模板!");
				}
			});
			
		});
	}
	/**
	 * 更新订单数据,在改变流程名称的时候
	 */
	function updateOrder(item){
		item.find(".updateOrder").click(function(){
			var t=$(this).parents(".ui_item_header");
			var newname=ifnull(t.find(".ui_input input").val());
			var oldname=ifnull(t.find(".ui_input span").html());
			if(newname==""){
				pop_up_box.showMsg("请先输入订单流程名称!",function(){
					t.find(".ui_input input").focus();
				});
				return;
			}
			pop_up_box.postWait();
			$.post("../manager/updateOrderStatus.do",{
				"newname":newname,
				"oldname":oldname
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					t.find(".ui_input span").html(newname);
					pop_up_box.toast("操作成功!",1000);
				} else {
					if (data.msg) {
						pop_up_box.showMsg("操作错误!" + data.msg);
					} else {
						pop_up_box.showMsg("操作错误!");
					}
				}
			});
		});
	}
	function btninit(item){
		headshipClick(item);
		imgClick(item);
		selectTemp(item);
		selectServiceTemp(item);
		updateOrder(item);
		item.find(".item-btnT").click(function(){
			var item=$(itemhtml);
			$(this).parents(".ui_item").after(item);
			btninit(item);
			item.find(".ui_input input").focus();
		});
	}
	$.get("../manager/getOrderProces.do",function(data){
		if (data&&data.length>0) {
			$.each(data,function(i,n){
				var item=$(itemhtml);
				$(".ui_list").append(item);
				item.find(".ui_name input").val(n.processName);
				item.find(".ui_input span").html(n.processName);
				item.find(".ui_down_ware input").prop("checked",n.down_ware);
				//页面显示控制部分
				item.find(".ui_show input").prop("checked",n.show);//下拉框中显示
				if(n.page){
					item.find(".ui_comfirm_ware input").prop("checked",n.page.comfirm_ware);//确认拉货库房
					item.find(".ui_tihuoTime input").prop("checked",n.page.tihuoTime);//确认拉货库房
					item.find(".ui_operation input").prop("checked",n.page.operation);//显示操作按钮
					item.find(".ui_select_wuliu input").prop("checked",n.page.select_wuliu);//选择物流方式
					item.find(".ui_purchase_btn_show input").prop("checked",n.page.purchase_btn_show);//选择物流方式
					item.find(".ui_pPlan_btn_show input").prop("checked",n.page.pPlan_btn_show);//选择物流方式
				}
				//员工消息参数
				item.find(".ui_employee .ui_send input").prop("checked",n.Esend);
				item.find(".ui_employee .ui_salesperson input").prop("checked",n.salesperson);
				item.find(".ui_employee .ui_headship input").val(n.Eheadship);
				item.find(".ui_employee .ui_title input").val(n.Etitle);
				item.find(".ui_employee .ui_content textarea").val(n.Econtent);
				item.find(".ui_employee .ui_url select").val(n.Eurl);
				item.find(".ui_employee .ui_tempName").html(n.EtempName);
				item.find(".ui_employee .template_id").html(n.Etemplate_id);
				if(n.imgName){
					item.find(".ui_employee .ui_img img").attr("src",n.imgName);
				}
				//客户消息参数
				item.find(".ui_client .ui_send input").prop("checked",n.send);
				if(n.role){
					item.find(".ui_client .ui_role select").val(n.role);
				}
				item.find(".ui_client .ui_headship input").val(n.headship);
				item.find(".ui_client .ui_title input").val(n.title);
				item.find(".ui_client .ui_content textarea").val(n.content);
				item.find(".ui_client .ui_url select").val(n.url);
				item.find(".ui_client .ui_tempName").html(n.tempName);
				item.find(".ui_client .template_id").html(n.template_id);
				if(n.CimgName){
					item.find(".ui_client .ui_img img").attr("src",n.CimgName);
				}
				btninit(item);
			});
		}else{
			var item=$(itemhtml);
			$(".ui_list").append(item);
			btninit(item);
		}
		$.get("../manager/getJSONObjectByFile.do",{"path":"orderProcessConfig.json"},function(data){
			if(data.usePPlan=="false"){
				data.usePPlan=false;
			}else{
				data.usePPlan=true;
			}
			if(data.usePurchase=="false"){
				data.usePurchase=false;
			}else{
				data.usePurchase=true;
			}
			$("#usePurchase").prop("checked",data.usePurchase);
			$("#usePPlan").prop("checked",data.usePPlan);
			if(data.usePPlan){
				$("input[name='pPlan_btn_show']").parent().show();
			}else{
				$("input[name='pPlan_btn_show']").prop("checked",false);
				$("input[name='pPlan_btn_show']").parent().hide();
			}
			if(data.usePurchase){
				$("input[name='purchase_btn_show']").parent().show();
			}else{
				$("input[name='purchase_btn_show']").prop("checked",false);
				$("input[name='purchase_btn_show']").parent().hide();
			}
		});
	});
	$(".ui_list").sortable();
	$("#zhiwuClose,.close").click(function(){
		$("#modal_headship").hide();
	});
	$("#imgClose,.close").click(function(){
		$("#modal_imgSelect").hide();
	});
	$("#tempClose,.close").click(function(){
		$("#modal_tempSelect,#modal_selectServiceTemp").hide();
	});
	///保存
	$("#save").click(function(){
		var ui_item=$(".ui_item");
		var list=[];
		if (ui_item&&ui_item.length>0) {
			function getJson(item){
				var processName=item.find(".ui_name input").val();
				var down_ware=item.find(".ui_down_ware input").prop("checked");//下库存
				//页面显示 部分
				var operation=item.find(".ui_operation input").prop("checked");//显示操作按钮
				var show=item.find(".ui_show input").prop("checked");//下拉框中显示
				var comfirm_ware=item.find(".ui_comfirm_ware input").prop("checked");//订单跟踪页面使用,用于核货或者通知拉货时确认库房,替换提货地点选择
				var tihuoTime=item.find(".ui_tihuoTime input").prop("checked");//订单跟踪页面使用,用于核货或者通知拉货时确认库房,替换提货地点选择
				var select_wuliu=item.find(".ui_select_wuliu input").prop("checked");//选择物流方式
				var purchase_btn_show=item.find(".ui_purchase_btn_show input").prop("checked");//显示下采购订单按钮
				var pPlan_btn_show=item.find(".ui_pPlan_btn_show input").prop("checked");//显示下采购订单按钮
				//员工消息参数部分
				var Esend=item.find(".ui_employee .ui_send input").prop("checked");
				var salesperson=item.find(".ui_employee .ui_salesperson input").prop("checked");//向业务员发送消息
				var Eheadship=item.find(".ui_employee .ui_headship input").val();
				var Etitle=item.find(".ui_employee .ui_title input").val();
				var Econtent=item.find(".ui_employee .ui_content textarea").val();
				var Eurl=item.find(".ui_employee .ui_url select").val();
				var Etemplate_id=item.find(".ui_employee .template_id").html();
				var EtempName=item.find(".ui_employee .ui_tempName").html();
				var imgName=item.find(".ui_employee .ui_img img").attr("src").replace("..","");
				//客户消息参数部分
				var send=item.find(".ui_client .ui_send input").prop("checked");
				var role=item.find(".ui_client .ui_role select").val();
				var headship=item.find(".ui_client .ui_headship input").val();
				var title=item.find(".ui_client .ui_title input").val();
				var content=item.find(".ui_client .ui_content textarea").val();
				var url=item.find(".ui_client .ui_url select").val();
				var template_id=item.find(".ui_client .template_id").html();
				var tempName=item.find(".ui_client .ui_tempName").html();
				var CimgName=item.find(".ui_client .ui_img img").attr("src").replace("..","");//二期增加自主上传个性图片
				if(processName==""){
					pop_up_box.showMsg("请填写流程名称",function(){
						item.find(".ui_name input").focus();
					});
				}else{
					var page={
							"select_wuliu":select_wuliu,"comfirm_ware":comfirm_ware,"tihuoTime":tihuoTime,
							"operation":operation,"purchase_btn_show":purchase_btn_show,"pPlan_btn_show":pPlan_btn_show
					}
					var json={
							"processName":processName,"down_ware":down_ware,"show":show,
							"Esend":Esend,"salesperson":salesperson,"Eheadship":Eheadship,"Etitle":Etitle,"Econtent":Econtent,
							"Eurl":Eurl,"Etemplate_id":Etemplate_id,"EtempName":EtempName,
							"imgName":imgName,"template_id":template_id,"tempName":tempName,
							"send":send,"headship":headship,"title":title,"role":role,
							"content":content,"url":url,"CimgName":CimgName,"page":page
					};
					list.push(JSON.stringify(json));
				}
			}
			if(ui_item.length>1){
				for (var i = 0; i < ui_item.length; i++) {
					var item=$(ui_item[i]);
					getJson(item);
				}
			}else{
				if(ui_item.find(".ui_name input").val()!=""){
					if(ui_item.find(".ui_name input")){
						getJson(ui_item);
					}
				}
			}
		}
		if(list.length>0){
			pop_up_box.postWait();
			$.post("../manager/saveOrderProcess.do",{
				"usePurchase":$("#usePurchase").prop("checked"),
				"usePPlan":$("#usePPlan").prop("checked"),
				"list":"["+list.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("保存成功!", 1000);
				}else{
					pop_up_box.showMsg("保存错误,请联系管理员!");
				}
			});
		}else{
			pop_up_box.showMsg("请设置流程");
		}
	});
});