var customer_id="";
$(function(){
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
		$(".tabs-content:eq(1) #list").html("");
	});
	addpro.init();
	$(".print").click(function(){
		 $('#mymodal').modal("toggle");
		 var wd=parseFloat($("#wd").val())-40;
		 $(".printitem>div:eq(1)").css("max-width",wd+"px");
	});
	$("#imgymwd").bind("input propertychange blur",function(){
		$(".printitem").css("margin-left",this.value+"px");
	});
	$("#imgymhd").bind("input propertychange blur",function(){
		$(".printitem").css("height",this.value+"px");
	});
	$("#scewm").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var chekcs=$(".tabs-content:eq("+lia+")").find("#list .imgdiv input[type='checkbox']:checked");
		if (chekcs&&chekcs.length>0) {
			var qrUrls=[];$("#page1").html("");
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents(".dataitem"); 
				var item_id=$.trim(item.find("#item_id").html());
				var com_id=$.trim($("#com_id").html());
				
				var qrURL=$("#urlPrefix").html()+"/product/productDetail.do?item_id="+item_id+"&com_id="+com_id;
				qrUrls.push(qrURL);
				var printdiv=$($(".printdiv").html());
				$("#page1").append(printdiv);
				printdiv.find("a").click({"qrURL":qrURL},function(event){
					window.open(event.data.qrURL);
				});
				printdiv.find("#item_name").html(item.find("#item_name").html());
				printdiv.find("#item_spec").html(item.find("#item_spec").html());
				printdiv.find("#item_type").html(item.find("#item_type").html());
				printdiv.find("#item_color").html(item.find("#item_color").html());
				printdiv.find("#class_card").html(item.find("#class_card").html());
			}
			$.get('../employee/generateQRCode.do',{
				"qrUrls":qrUrls.join(","),
				"width":$("#wd").val(),
				"height":$("#hd").val(),
				"image_width":$("#imgwd").val(),
				"image_height":$("#imghd").val()
			},function(data){
				if (data.success) {
					if(data.msg){
						var urls=data.msg.split(",");
						for (var i = 0; i < $("#page1").find(".printitem").length; i++) {
							var item=$($("#page1").find(".printitem")[i]);
							item.find("img").attr("src",".."+urls[i]);
						}
					}
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
	$("#beginprint").click(function(){
		$("#page1").jqprint();
//		doPrint();
	});
});
var addpro={
	init:function(){
		var addPage={
				page:1,
				count:0,
				totalPage:0
		};
		var productPage={
				page:0,
				count:0,
				totalPage:0
		};
		productpage.initBtnClick(function(lia){
			if(customer_id){
				if (lia==0) {
					productPage.page=0;
				}else{
					addPage.page=0;
				}
				var customerId=getQueryString("customer_id");
				if(customerId){//从微信消息进入
					$(".nav li").eq(1).click();
				}else{
					loadData(0,0);
				}
			}else{
				$("#seekh").click();
			}
		});
		//切换li标签时模拟搜索框点击事件自动获取数据
		productpage.navLiClick(function(item,lia){
			if (lia == 1) {
				$("#finded").show();$("#finding").hide();
				$("#add").hide();
			}else{
				$("#finding").show();$("#finded").hide();
				$("#allcheck,#add").show();
				if ($.trim($(".tabs-content:eq(0)").find("#list").html())=="") {
					$(".find:eq(0)").click();
				}
			}
		});
		//加载更多数据 
		productpage.btnAddClick(function(page,count,totalPage){
			var lia = $(".nav li").index($(".nav .active"));
			if(lia==0){
				productPage.page+=1;
				page=productPage.page;
				count=productPage.count;
				totalPage=productPage.totalPage;
			}else{
				addPage.page+=1;
				page=addPage.page;
				count=addPage.count;
				totalPage=addPage.totalPage;
			}
			if (page<=totalPage) {
				loadData(page, count);
			}
		});
		$("input[name='comfrim']").click(function(){
			$(".tabs-content:eq(1)").find("#list").html("");
			addPage.page=0;
			loadData(0,0);
		});
		function loadData(page,count){
			var lia = $(".nav li").index($(".nav .active"));
			var searchKey;
			var url;
			var m_flag="";
			var json={};
			if(lia==0){
				searchKey=$.trim($("#finding").find("#searchKey").val());
				url="../product/productList.do";//带库存数的
//				json.searchKey=searchKey;
//				json.type_id=$.trim($("#findForm #type_id").val());
//				json.quality_class=$.trim($("#findForm #quality_class").val());
//				json.type_id=$.trim($("#findForm #type_id").val());
//				json.type_id=$.trim($("#findForm #type_id").val());
//				json.type_id=$.trim($("#findForm #type_id").val());
			}else{
				m_flag=$("input[name='comfrim']:checked").val();
				searchKey=$.trim($("#finded").find("#searchKey").val());
				url="../product/getClientAdded.do";
				
			}
			var rows=$("#rows").val();
			if(!rows){
				rows=10;
			}
			pop_up_box.loadWait();
			$.get(url,{
				"searchKey":searchKey ,
				"type_id":$.trim($("#findForm #type_id").val()) ,
				"quality_class":$.trim($("#findForm #quality_class").val()) ,
				"item_style":$.trim($("#findForm #item_style").val()) ,
				"class_card":$.trim($("#findForm #class_card").val()),
				"item_spec":$.trim($("#findForm #item_spec").val()),
				"item_struct":$.trim($("#findForm #item_struct").val()),
				"item_type":$.trim($("#findForm #item_type").val()),
				"item_color":$.trim($("#findForm #item_color").val()),
				"m_flag":m_flag,
				"page":page,
				"rows":rows,
				"count":count,
				"customer_id" : customer_id
				},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
			 if (lia==0) {
				productPage.totalPage = data.totalPage;
				productPage.count = data.totalRecord;
			}else{
				addPage.totalPage = data.totalPage;
				addPage.count = data.totalRecord;
			}
		});
		}
		function addItem(data){
			if (data&&data.rows.length>0) {
				var lia = $(".nav li").index($(".nav .active"));
				$.each(data.rows,function(i,n){
					var item=$($("#item").html());
					$(".tabs-content").eq(lia).find("#list").append(item);
					loadProInfo(item, n);					
					item.find("#item_id").html(n.item_id);
					item.find("#sid").val(n.seeds_id);
					item.find("#price_otherDiscount").val(n.price_otherDiscount);
					item.find("#price_display").val(n.price_display);
					item.find("#price_prefer").val(n.price_prefer);
					if (n.discount_ornot=="Y") {
						item.find("#discount_ornot").prop("checked",true);
					}else{
						item.find("#discount_ornot").prop("checked",false);
					}
					if(lia==0){
						item.find("#ivt_oper_listing").parent().remove();
					}else{
						item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
						item.find("#sd_unit_price").val(n.sd_unit_price);
						item.find("#no").val(n.no);
					}
					item.find("#sd_unit_price_DOWN").val(n.sd_unit_price_DOWN);
					item.find("#client_item_name").val(n.client_item_name);
					item.find("#peijian_id").val(n.peijian_id);
					item.find("#sd_unit_price_UP").val(n.sd_unit_price_UP);
					item.find("#ditch_type").val(n.ditch_type);
					if (n.discount_time_begin&&n.discount_time_begin!='') {
						item.find("input[name='discount_time_begin']").val(n.discount_time_begin);
					}
					if (n.discount_time&&n.discount_time!='') {
						item.find("input[name='discount_time']").val(n.discount_time);
					}
					var val=productpage.itemInit(n,item);
					if (lia == 0) {
						item.find("input[type='text'],input[type='tel']").prop("disabled",false);
						item.find("#confirm").remove();
						item.find("#m_flag").parent().remove();
						item.find("#noConfirm").remove();
					}else{
						if(n.m_flag=="1"){
							item.find("#confirm").hide();
							item.find("#m_flag").html("已审核");
						}else{
							item.find("#noConfirm").hide();
							item.find("#m_flag").html("未审核");
						}
						item.find("#noConfirm").click(function(){
							confirmAdd(this,"no","弃审");
						});
						item.find("#confirm").click(function(){
							confirmAdd(this,"confirm","审核");
						});
						item.find("#editPrice").show();
						item.find("#editPrice").click({
							"seeds_id":n.seeds_id
						},function(event){
							var t=$(this).parents(".dataitem");
							pop_up_box.postWait();
							var client_item_name=$.trim(t.find("#client_item_name").val());
							var peijian_id=$.trim(t.find("#peijian_id").val());
							$.post("editAddedInfo.do",{
								"seeds_id":event.data.seeds_id,
								"client_item_name":client_item_name,
								"peijian_id":peijian_id,
								"no":t.find("#no").val(),
								"sd_unit_price_DOWN":isnull0(t.find("input[name='sd_unit_price_DOWN']").val()),
								"sd_unit_price_UP":isnull0(t.find("input[name='sd_unit_price_UP']").val()),
								"price_display":isnull0(t.find("input[name='price_display']").val()),
								"price_otherDiscount":isnull0(t.find("input[name='price_otherDiscount']").val()),
								"price_prefer":isnull0(t.find("input[name='price_prefer']").val()),
								"sd_unit_price":isnull0(t.find("input[name='sd_unit_price']").val()),
								"discount_time_begin":t.find("input[name='discount_time_begin']").val(),
								"discount_time":t.find("input[name='discount_time']").val(),
								"c_memo":ifnull(t.find("#c_memo").html()),
								"memo_color":ifnull(t.find("#memo_color").html()),
								"memo_other":ifnull(t.find("#memo_other").html())
							},function(data){
								pop_up_box.loadWaitClose();
								if (data.success) {
									pop_up_box.showMsg("保存成功!");
									t.find("#m_flag").html("未审核");
									t.find("#noConfirm").hide();
									item.find("#confirm").show();
								} else {
									if (data.msg) {
										pop_up_box.showMsg("保存错误!" + data.msg);
									} else {
										pop_up_box.showMsg("保存错误!");
									}
								}
								
							});
						});
					}
				var headship=$.trim($("#headship").html());
				var clerk_id=$.trim($("#clerk_id").html());
				 item.find("#price_display").parent().show();
				 item.find("#price_prefer").parent().show();
				 item.find("#sd_unit_price").parent().show();
				 item.find("input[name='discount_ornot']").click(function() {
					 var lia = $(".nav li").index($(".nav .active"));
					 var t=$(this).parents(".dataitem");
					 if(lia==1){
						 var discount_ornot=$(this).prop("checked");
						 if(discount_ornot){
							 discount_ornot="Y";
						 }else{
							 discount_ornot="N";
						 }
						 var seeds_id=$(this).parents(".dataitem").find("#sid").val();
						 pop_up_box.postWait();
						 $.post("editAddedInfo.do",{
							 "seeds_id":seeds_id,
							 "discount_ornot":discount_ornot
						 },function(data){
							 pop_up_box.loadWaitClose();
							 if (data.success) {
								 pop_up_box.toast("提交成功!",500);
								 t.find("#m_flag").html("未审核");
								 t.find("#noConfirm").hide();
								 item.find("#confirm").show();
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
				});
				productpage.setPageShow(data);
				productpage.detailClick();
				$("input[name='price_otherDiscount'],input[name='price_display'],input[name='price_prefer']").bind("input propertychange blur",function(){
					var t=$(this);
					var reg = new RegExp("^[0-9.]*$");
					if (!reg.test(t.val().trim())) {
						t.val(t.val().substring(0, t.val().length - 1));
					}
					var oth=parseFloat(t.val());
					var price_otherDiscount=parseFloat(t.parents(".dataitem").find("input[name='price_otherDiscount']").val());
					var price_display=parseFloat(t.parents(".dataitem").find("input[name='price_display']").val());
					var price_prefer=parseFloat(t.parents(".dataitem").find("input[name='price_prefer']").val());
					if (!price_display) {
						price_display=0;
					}
					if (!price_prefer) {
						price_prefer=0;
					}
					if (!price_otherDiscount) {
						price_otherDiscount=0;
					}
					t.parents(".dataitem").find(".infodiv input[type='checkbox']").prop("checked",true);
					var vals=price_display-price_prefer-price_otherDiscount;
					if (vals<0) {
						t.val(t.val().substring(0, t.val().length - 1));
						t.parents(".dataitem").find("#check").prop("checked",false);
						return;
					}else{
						t.parents(".dataitem").find("#check").prop("checked",true);
						t.parents(".dataitem").find("input[name='sd_unit_price']").val(vals);
					}
				});
				$(".bootstrap-switch-handle-off").css("background-color","#337abc");
			}
		}
		function confirmAdd(t,confirm,msg){
			var item = $(t).parents(".dataitem");
			var sid =$.trim(item.find("#sid").val());
			pop_up_box.postWait();
			$.post("../product/confirmAddPro.do", {
				"sid" : sid,
				"confirm":confirm
			}, function(data) {
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.toast(msg+"成功!",1000);
//					pop_up_box.showMsg(msg+"成功!", function() {
//					});
					$(t).hide();
					if(confirm=="no"){
						item.find("#m_flag").html("未审核");
						item.find("#confirm").show();
					}else{
						item.find("#m_flag").html("已审核");
						item.find("#noConfirm").show();//弃审
					}
				} else {
					pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
				}
			});
		}

			loadTree("folding");
			loadTree("filter");
			function loadTree(folding){
				$("."+folding).find(".btn-success").unbind("click");
				$("."+folding).find(".btn-success").click(function(){
					var n = $("."+folding).find(".btn-success").index(this);
					if (n==1) {
						return;
					}
					pop_up_box.loadWait();
					$.get("../tree/getDeptTree.do",{"type":"cls"},function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						procls.init();
					});
				});
			}
			$("#add").unbind("click");
			$("#add").click(function(){
				var chekcs=$(".tabs-content:eq(0)").find("#list #check:checked");
				if (chekcs&&chekcs.length>0) {
					var item_ids=[];
					for (var i = 0; i < chekcs.length; i++) {
						var item=$(chekcs[i]).parents(".dataitem");
						var item_id=$.trim(item.find("#item_id").html());
						if (item_id&&item_id!="") {
							if($.trim(item.find("#item_color").html())!=""){
								var len=item.find(".colorActive").length;
								var item_color="";
								if(len>0){
									for (var j = 0; j < len; j++) {
										var la=$(item.find(".colorActive")[j]).html();
										if(item_color==""){
											item_color=la;
										}else{
											item_color=item_color+","+la;
										}
									}
								}
//								if(!item_color){
//									pop_up_box.showMsg("请选择颜色!");
//									b=false;break;
//								}
							}
							if($.trim(item.find("#item_type").html())!=""){
								var len=item.find(".colorActive").length;
								var item_type="";
								if(len>0){
									for (var j = 0; j < len; j++) {
										var la=$(item.find(".specActive")[j]).html();
										if(item_type==""){
											item_type=la;
										}else{
											item_type=item_type+","+la;
										}
									}
								}
//								if(!item_type){
//									pop_up_box.showMsg("请选择规格!");
//									b=false;break;
//								}
							}
							var item=$(chekcs[i]).parents(".dataitem");
							var discount_ornot=item.find("#discount_ornot").prop("checked");
							if(!discount_ornot){
								discount_ornot="N";
							}else{
								discount_ornot="Y";
							}
							var discount_time_begin=item.find("#discount_time_begin").val();
							var discount_time=item.find("#discount_time").val();
							var price_otherDiscount=item.find("#price_otherDiscount").val();
							var price_display=item.find("#price_display").val();
							var price_otherDiscount=item.find("#price_otherDiscount").val();
							var price_prefer=item.find("#price_prefer").val();
							
							var sd_unit_price_DOWN=item.find("input[name='sd_unit_price_DOWN']").val();
							var sd_unit_price_UP=item.find("input[name='sd_unit_price_UP']").val();
							if (sd_unit_price_DOWN=='') {
								sd_unit_price_DOWN=0;
							}
							if (sd_unit_price_UP=='') {
								sd_unit_price_UP=0;
							}
							if (price_otherDiscount=="") {
								item.find("#price_otherDiscount").val("0");
								price_otherDiscount=0;
							}
							if (price_prefer=="") {
								item.find("#price_prefer").val("0");
								price_prefer=0;
							}
							if (price_display=="") {
								item.find("#price_display").val("0");
								price_display=0;
							}
							var c_memo=$.trim(item.find("#c_memo").html());
							var memo_color=$.trim(item.find("#memo_color").html());
							var memo_other=$.trim(item.find("#memo_other").html());
							var client_item_name=$.trim(item.find("#client_item_name").val());
							var peijian_id=$.trim(item.find("#peijian_id").val());
							var no=item.find("#no").val();
							var itemdata={
									"item_id":item_id,
									"item_color":item_color,
									"no":no,
									"item_type":item_type,
									"discount_ornot":discount_ornot,
									"discount_time_begin":discount_time_begin,
									"discount_time":discount_time,
									"sd_unit_price_DOWN":sd_unit_price_DOWN,
									"price_otherDiscount":price_otherDiscount,
									"price_display":price_display,
									"price_prefer":price_prefer,
									"client_item_name":client_item_name,
									"peijian_id":peijian_id,
									"c_memo" : c_memo,
									"memo_color" : memo_color,
									"memo_other" : memo_other,
									"sd_unit_price_UP":sd_unit_price_UP}
							item_ids.push(JSON.stringify(itemdata));
							item.remove();
						}
					}
					if (item_ids.length==0) {
						pop_up_box.showMsg("没有获取到产品编码,请刷新页面重试!");
						return;
					}
					pop_up_box.postWait();
					$("#"+customer_id).parents("ul").addClass("active");
					$("#add").attr("disabled", "disabled");
					$.post("../product/addPro.do",{
						"item_ids":"["+item_ids.join(",")+"]",
						"customer_ids":customer_id,
						"ditch_type":$("#ditch_type").html()
						},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) { 
							pop_up_box.showMsg("数据提交成功,增加["+item_ids.length+"]个产品!",function(){
								$(".nav li:eq(1)").click();
							});
						}else{
							pop_up_box.showMsg("保存失败,错误:"+data.msg);
						}
						$("#add").removeAttr("disabled");
					});
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			}); 

		/////删除已增加产品///
		$("#deladd").unbind("click");
		$("#deladd").click(function(){
				var chekcs = $(".tabs-content:eq(1)").find("#list #check:checked");
				if (chekcs && chekcs.length > 0) {
					var item_ids = [];
					for (var i = 0; i < chekcs.length; i++) {
						var item = $(chekcs[i]).parents(".dataitem");
						var sid = item.find("#sid").val();
						sid = $.trim(sid);
						if (sid != "") {
							var itemdata = {
								"sid" : sid ,
								"ivt_oper_bill" : item.find("#ivt_oper_listing").html()
							}
							item_ids.push(JSON.stringify(itemdata));
							item.remove();
						}
					}
					// ////
					pop_up_box.postWait();
					$.post("../product/delAddPro.do", {
//						"customer_id" : customer_id,
						"itemIds" : item_ids ,
						"type" : "yg"
					}, function(data) {
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("品种删除成功!", function() {
								// window.location.href="myorder.do?type=0";
							});
						} else {
							pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
						}
					});
				} else {
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
		//////////////////////////
		$("#confirmAll").click(function(){
			pop_up_box.postWait();
			$.get("../employee/confirmAllAdded.do",{
				"customer_id" : customer_id,
				"m_flag":"1"				
				},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("审核成功", 2000);
					$(".find:eq(1)").click();
				}
			});
		});
		$("#noticeComfirm").click(function(){
			pop_up_box.postWait();
			$.post("../employee/noticeComfirm.do",{
				"customer_id" : customer_id,
				"m_flag":"0",
				"title":"客户报价单审核通知",
				"headship":"销售经理",
				"description":"@comName-@Eheadship-@clerkName:业务员"+$("#clerkName").html()+"已经为客户【"+$(".sim-msg>li:eq(0)").html()+"】产品报价,请尽快进行审核!"
				},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("通知成功", 2000);
				}
			});
		});
		$("#noticeAddedConfirmed").click(function(){
			pop_up_box.postWait();
			$.post("../employee/noticeAddedConfirmed.do",{
				"customer_id" : customer_id,
				"m_flag":"1",
				"title":"客户报价单已审核完成通知",
				"description":"@comName-业务员-@clerkName:销售经理"+$("#clerkName").html()+"已经审核客户【"+$(".sim-msg>li:eq(0)").html()+"】产品报价,可以开始下单了!"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("通知成功", 2000);
				}
			});
		});
	}
}
