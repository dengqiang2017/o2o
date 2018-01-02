var order ={
		init:function(){
			///////
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".Wdate:eq(1)").val(nowStr);
			var orderPage={
					page:1,
					count:0,
					totalPage:0
			};
			var productPage={
					page:0,
					count:0,
					totalPage:0
			};
			var planPage={
					page:0,
					count:0,
					totalPage:0
			};
			function loadData(page,count){
				var lia = $(".nav li").index($(".nav .active"));
				var searchKey;
				var url;
				var goods_origin="";
				var beginDate="";
				var endDate="";
				if(lia==0){
					searchKey=$.trim($("#finding").find("#searchKey").val());
					url="../product/getOrderProduct.do";//带库存数的
				}else if(lia==1){
					searchKey=$.trim($("#findForm").find("#searchKey").val());
					url="../product/getPlanList.do";
					goods_origin="%日计划%";
					beginDate=$("#findplan .Wdate:eq(0)").val();
					endDate=$("#findplan .Wdate:eq(1)").val();
				}else if(lia==2){
					searchKey=$.trim($("#finded").find("#searchKey").val());
					url="../product/getClientOrdered.do";
				}
				$.get(url,{
					"searchKey":searchKey ,
					"page":page,
					"count":count,
					"beginDate":beginDate,
					"endDate":endDate,
					"goods_origin":goods_origin,
					"customer_id" : customer_id
					},function(data){
				pop_up_box.loadWaitClose(); 
				addItem(data);
				 if (lia==0) {
					productPage.totalPage = data.totalPage;
					productPage.count = data.totalRecord;
				}else if(lia==1){
					planPage.totalPage = data.totalPage;
					planPage.count = data.totalRecord;
				}else{
					orderPage.totalPage = data.totalPage;
					orderPage.count = data.totalRecord;
				}
			});
			}
			//////////////////////
			$(".find").unbind("click");
			$(".find").click(function() {
				if (customer_id) {
					var lia = $(".nav li").index($(".nav .active"));
					var n=$(".find").index(this);
					pop_up_box.loadWait();
					$(".tabs-content").eq(lia).find("#list").html("");
					if (lia==0) {
						orderPage.page=0;
					}else if(lia==1){
						planPage.page=0;
					}else{
						productPage.page=0;
					}
					loadData(0,0);
				}else{
					$("#seekh").click();
				}
			});
			$("#allcheck").prop("checked",false);
			$("#allcheck").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				var tabs= $(".tabs-content:eq("+lia+")");
				var b=$(this).prop("checked");
				tabs.find("#list #check").prop("checked",b);
			});
			///////////////////////////////
			$("#findForm .pull-left").hide();
			$("#findForm .pull-left:eq(8)").show();
			function addItem(data){
				if (data&&data.rows.length>0) {
					var lia = $(".nav li").index($(".nav .active"));
					$.each(data.rows,function(i,n){
						var item=$($("#item").html());
						$(".tabs-content").eq(lia).find("#list").append(item);
						loadProInfo(item, n);
						item.find("#seeds_id").val(n.seeds_id);
						item.find("#com_id").append($.trim(n.com_id));
						if (n.client_item_name) {
							item.find("#client_item_name").html(n.client_item_name);
							item.find("#peijian_id").html(n.peijian_id);
						}
						var sd_unit_price=n.sd_unit_price;
						
						if(lia==2){
							if(n.pack_unit>1){
								item.find("#sd_zsum").html(n.sd_oq/n.pack_unit);
							}else{
								item.find("#sd_zsum").html(n.sd_oq*n.pack_unit);
							}
							item.find("#sd_oq").html(n.sd_oq);
							item.find("#sum_si").html(numformat2(n.sd_oq*n.sd_unit_price));
							item.find("#sd_unit_price_o").html(numformat2(n.sd_unit_price));
							item.find("#sd_unit_price").parent().remove();
							item.find("#pronum").parent().remove();
							item.find(".zsum").parent().remove();
						}else{
							item.find("#sd_unit_price_o").parent().remove();
							item.find("#sd_oq").parent().remove();
							item.find("#sd_zsum").parent().remove();
						}
						if(lia==0){
							if (n.discount_time_begin&&n.discount_time_begin!='') {
								item.find("#discount_time_begin").html(n.discount_time_begin);
							}
							if (n.discount_time&&n.discount_time!='') {
								item.find("#discount_time").html(n.discount_time);
							}
							if (n.discount_ornot=="Y") {
								item.find("#discount_ornot").html("有");
							}else{
								item.find("#discount_ornot").html("无");
							}
							if(n.accn_ivt){
								item.find("#qz_days").html(n.qz_days);
								item.find("#use_oq").html(n.accn_ivt);
							}else{
								item.find("#use_oq").html(0);
								item.find("#qz_days").html(3);
							}
						}else if(lia==1){
							item.find("#pronum").val(n.sd_oq-n.send_sum);
							item.find("#sd_unit_price").val(n.sd_unit_price);
							item.find("#plan_num").html(n.sd_oq);
							item.find("#plan_num").parent().show();
							if(n.send_sum){
								item.find("#send_sum").html(n.send_sum);
							}else{
								item.find("#send_sum").html(0);
							}
							item.find("#send_sum").parent().show();
						}else{
							item.find("#use_oq").parent().remove();
							item.find("#discount_time_begin").parent().remove();
							item.find("#discount_ornot").parent().remove();
						}
						 if(lia!=1){
							 if(n.pack_unit){
								 if(n.pack_unit>1){
									 item.find(".zsum").val(n.sd_oq/n.pack_unit);
								 }else{
									 item.find(".zsum").val(n.sd_oq*n.pack_unit);
								 }
							 }else{
								 item.find(".zsum").val(n.sd_oq);
							 }
						 }
						///////////////////////
						var val=productpage.itemInit(n,item);
						if (val) {
							item.find("#sum_si").html(numformat2(val*sd_unit_price));
						}
						if(n.Status_OutStore){
							item.find("#proName").html(n.Status_OutStore);
							item.find(".pro-check").hide();//$.trim(n.Status_OutStore)=="核货"||
							if($.trim(n.Status_OutStore).indexOf("订单")>=0){//等于核货并且没有下采购订单,可以反悔删除
								item.find(".pro-check").show();
							}else{
								item.find(".pro-check").hide();
							}
						}else{
							item.find("#proName").parent().remove();
						}
						item.find("#c_memo").html(n.c_memo);
						item.find("#memo_other").html(n.memo_other);
						item.find("#memo_color").html(n.memo_color);
						item.find("#price_type").html(n.price_type);
						if ($.trim(n.ivt_oper_listingMyPlan)!="") {
							item.find("#ivt_oper_listingMyPlan").html(n.ivt_oper_listingMyPlan);
						}else{
							item.find("#ivt_oper_listingMyPlan").parent().remove();
						}
						item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
//						if ($.trim(n.discount_time)!="") {
//							var now = new Date(n.discount_time_begin);
//							var nowStr = now.Format("yyyy-MM-dd"); 
//							item.find("#discount_time_begin").html(nowStr);
//						}
//						if ($.trim(n.discount_time)!="") {
//							var now = new Date(n.discount_time);
//							var nowStr = now.Format("yyyy-MM-dd"); 
//							item.find("#discount_time").html(nowStr);
//						}
						productpage.itemDateInit(n.discount_time_begin,item,"discount_time_begin");
						productpage.itemDateInit(n.discount_time,item,"discount_time");
						item.find("#sd_unit_price").val(numformat2(sd_unit_price));
						item.find("#price_display").val(numformat2(n.price_display));
						item.find("#price_prefer").val(numformat2(n.price_prefer));
						item.find("#price_otherDiscount").val(numformat2(n.price_otherDiscount));
						if(lia!=2){
							productpage.initNumIpt(item);
						}
						if($.trim($("#order_edit_price").html())!=""){
							item.find("#sd_unit_price").removeAttr("readonly");
						}else{
							item.find("#sd_unit_price").attr("readonly","readonly");
						}
					});
				}else{
					pop_up_box.toast("已全部加载!",300);
				} 
				$("#sum_si").parent().show();
			}
			$(".nav li").click(function(){
				var n = $(".nav li").index(this);
				$(".nav li").removeClass('active');
				$(this).addClass('active'); 
				$(".tabs-content").hide(); 
				var tab=$(".tabs-content:eq("+n+")");
				tab.show();
				if (n == 1) {//选择计划
					if (tab.find("#list").html()=="") {
						$(".find:eq(1)").click();
					}
					$("#findplan").show();
					$("#finded,#finding,.allcheck").hide();
					$("#saveOrder,.allcheck:eq(1),#xiaorder").show();
				}else if(n==0){//直接下订单
					$("#finding").show();
					$("#finded,#findplan,.allcheck").hide();
					$("#saveOrder,.allcheck:eq(0),#xiaorder").show();
					if (tab.find("#list").html()=="") {
						$(".find:eq(0)").click();
					}
				}else{//已下订单
					if (tab.find("#list").html()=="") {
						$(".find:eq(2)").click();
					}
					$("#finded").show();
					$("#finding,#findplan,.allcheck").hide();
					$("#saveOrder,#xiaorder").hide();
				}
			});
			
			//加载更多数据 
			$(".btn-add").unbind("click");
			$(".btn-add").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				var page=0;
				var count=0;
				var totalPage=0;
				if(lia==0){
					productPage.page+=1;
					page=productPage.page;
					count=productPage.count;
					totalPage=productPage.totalPage;
				}else if(lia==1){
					planPage.page+=1;
					page=planPage.page;
					count=planPage.count;
					totalPage=planPage.totalPage;
				}else{
					orderPage.page+=1;
					page=orderPage.page;
					count=orderPage.count;
					totalPage=orderPage.totalPage;
				}
				if (page<=totalPage) { 
					loadData(page, count);
				}
			});
			$("#saveOrder").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				if (lia==1) {
					plansave();
					return;
				}
				var txt=$(this).html();
				var chekcs= $(".tabs-content:eq(0)").find("#check:checked");
				if (chekcs&&chekcs.length>0) {
					var item_ids=[];
					for (var i = 0; i < chekcs.length; i++) {
						var item=$(chekcs[i]).parents(".dataitem");
						var item_id=item.find("#item_id").html();
						item_id=$.trim(item_id);
						if (item_id!="") {
							var sd_unit_price=isnull0(item.find("#sd_unit_price").val());
							var pronum=isnull0(item.find(".num").val());
							var pack_unit=isnull0(item.find("#pack_unit").html());//换算数量
							var sum_si=isnull0(item.find("#sum_si").html());//基本单位
							var ivt_oper_listing=item.find("#ivt_oper_listing").html();
							var casing_unit=item.find("#casing_unit").html();//包装单位
							var item_unit=item.find(".item_unit").html();//基本单位
							var c_memo=$.trim(item.find("#c_memo").html());
							var memo_color=$.trim(item.find("#memo_color").html());
							var memo_other=$.trim(item.find("#memo_other").html());
							var client_item_name=$.trim(item.find("#client_item_name").html());
							var peijian_id=$.trim(item.find("#peijian_id").html());
							if (pronum==""||pronum=="0") {
								pronum="1";
								alert("请输入订单数量!");
								item.find(".num").focus().select();
								return ;
							}
							var itemdata={
									"ivt_oper_listing":ivt_oper_listing,
									"item_id":item_id, 
									"pronum":pronum,
									"pack_unit":pack_unit,
									"casing_unit":casing_unit,
									"client_item_name":client_item_name,
									"peijian_id":peijian_id,
									"item_unit":item_unit,
									"sum_si":sum_si,
									"c_memo":c_memo,
									"memo_color":memo_color,
									"memo_other":memo_other,
									"sd_unit_price":sd_unit_price
							}
							item_ids.push(JSON.stringify(itemdata));
							if (window.location.href.indexOf("customer")<=0) {
							item.remove();
							}
						}
					}
					pop_up_box.postWait();
					$("#"+customer_id).parents("ul").addClass("active");
					$("#saveOrder").attr("disabled", "disabled");
					$.post("../product/addOrder.do",{
						"customer_id":customer_id,
						"itemIds":"["+item_ids.join(",")+"]" 
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							$(".modal-body #orderNo").html(data.msg);
//							if (window.location.href.indexOf("customer")>0) {
//								if(txt.indexOf("购物车")>=0){
//									pop_up_box.showMsg("提交成功,请到待支付中查看并支付", function() {
//										
//									});
//								}else{
//									pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品,去支付吧!", function() {
//										window.location.href="orderConfirm.do";
//									});
//								}
//							}else{
								pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品.",function(){
									$(".fujian").show();
								});
//							}
						}else{
							pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
						}
						$("#saveOrder").removeAttr("disabled");
					});
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
			/////删除已增加产品///
			$("#orderdel").click(function(){
					var chekcs = $(".tabs-content:eq(2)").find("#check:checked");
					if (chekcs && chekcs.length > 0) {
						var item_ids = [];
						for (var i = 0; i < chekcs.length; i++) {
							var item = $(chekcs[i]).parents(".dataitem");
							var seeds_id = item.find("#seeds_id").val();
							seeds_id = $.trim(seeds_id);
							if (seeds_id != "") {
								var itemdata = {
									"seeds_id" : seeds_id ,
									"ivt_oper_bill" : item.find("#ivt_oper_listing").html()
								}
								item_ids.push(JSON.stringify(itemdata));
//								item.remove();
							}
						}
						// ////
						pop_up_box.postWait();
						$.post("../product/delOrderPro.do", {
//							"customer_id" : customer_id,
							"itemIds" : item_ids,
							"type" : "yg"
						}, function(data) {
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("品种删除成功!", function() {
									// window.location.href="myorder.do?type=0";
									for (var i = 0; i < chekcs.length; i++) {
										var item = $(chekcs[i]).parents(".dataitem");
											item.remove();
									}
								});
							} else {
								pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
							}
						});
					} else {
						pop_up_box.showMsg("请至少选择一个产品!");
					}
				});
			///////////选择计划////////
			function plansave(){
				var chekcs=$(".tabs-content:eq(1)").find("#check:checked");
				if (chekcs&&chekcs.length>0) {
					var item_ids=[];
					for (var i = 0; i < chekcs.length; i++) {
						var item=$(chekcs[i]).parents(".dataitem");
						var item_id=item.find("#item_id").html();
						item_id=$.trim(item_id);
						if (item_id!="") {
							var planno=item.find("#ivt_oper_listing").html();
							var seeds_id=item.find("#seeds_id").val();
							var sd_unit_price=isnull0(item.find("#sd_unit_price").html());
							var plannum=isnull0(item.find(".num").val());
							var pack_unit=isnull0(item.find("#pack_unit").html());//换算数量
							var sum_si=isnull0(item.find("#sum_si").html());//基本单位
							var ivt_oper_listing=item.find("#ivt_oper_listing").html();
							var casing_unit=item.find("#casing_unit").html();//包装单位
							var item_unit=item.find(".item_unit").html();//基本单位
							var c_memo=$.trim(item.find("#c_memo").html());
							var memo_color=$.trim(item.find("#memo_color").html());
							var memo_other=$.trim(item.find("#memo_other").html());
							var send_sum=isnull0(item.find("#send_sum").html());//计划已下订单数
							var plan_num=isnull0(item.find("#plan_num").html());//计划数
							if (plannum=="") {
								pop_up_box.showMsg("请输入订单数!",function(){
									item.find(".num").focus().select();
								});
								return;
							}else{
								plannum=parseFloat(plannum);
							}
							if (plan_num=="") {
								plan_num=0;
							}else{
								plan_num=parseFloat(plan_num);
							}
							if (send_sum=="") {
								send_sum=0;
							}else{
								send_sum=parseFloat(send_sum)+plannum;
							}
							var sy_num=plan_num-send_sum;
							var itemdata={
									"ivt_oper_listing":ivt_oper_listing,
									"item_id":item_id,
									"pronum":plannum,
									 "planno":ivt_oper_listing,
									 "pack_unit":pack_unit,
									 "casing_unit":casing_unit,
									 "item_unit":item_unit,
									 "sum_si":sum_si,
									 "send_sum":send_sum,
									 "sy_num":sy_num,
									 "seeds_id":seeds_id,
									 "c_memo":c_memo,
									 "memo_color":memo_color,
									 "memo_other":memo_other,
									"sd_unit_price":sd_unit_price}
								item_ids.push(JSON.stringify(itemdata));
							if (window.location.href.indexOf("customer")<=0) {
							item.remove();
							}
						}
					}
					pop_up_box.postWait();
					$("#"+customer_id).parents("ul").addClass("active");
					$("#planSave").attr("disabled", "disabled");
					$.post("../product/addOrder.do",{
						"customer_id":customer_id,
						"itemIds":"["+item_ids.join(",")+"]",
						"plan":"plan"
					},function(data){
						$("#planSave").removeAttr("disabled");
						pop_up_box.loadWaitClose();
						if (data.success) {
							if (window.location.href.indexOf("customer")>0) {
								pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品,去支付吧!", function() {
									window.location.href="orderConfirm.do";
								});
								
							}else{
								pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品.", function() {
								$(".nav li:eq(1)").click();
								$(".find:eq(1)").click();
								});
							}
						} else {
							pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
						}
					});
				} else {
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			}
			/////////////已下订单支付////////////
			$("#zhifu").click(function(){
				var chekcs=$(".tabs-content:eq(2)").find("#check:checked");
				if (chekcs&&chekcs.length>0) {
					var seeds_ids=[];
					for (var i = 0; i < chekcs.length; i++) {
						var item=$(chekcs[i]).parents(".dataitem");
						var seeds_id=item.find("#seeds_id").val();
						if ($.trim(item.find(".num").val())=="") {
							item.find(".num").val("1");
						}
						var sum_si=isnull0(item.find("#sum_si").html());
						seeds_ids.push(JSON.stringify({
							"seeds_id":seeds_id,
							"num":item.find(".num").val(),
							"sum_si":sum_si
							}));
					}
					pop_up_box.postWait();
					$.post("orderPay.do",{"seeds_ids":seeds_ids},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							window.location.href="orderConfirm.do";
						}else{
							pop_up_box.showMsg("保存失败,错误:"+data.msg);
						}
					});
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
		}
}
function fileLoad(t){
	if(!customer_id){
		$("#seekh").click();
	}
	var si=$.trim($(".showimg").html());
	var orderNo=$(".modal-body #orderNo").html();
	if(si!=""){
		var len=$(".showimg .pull-left").length;
		if(len>0){
			orderNo=orderNo+"_"+len;
		}
	}
	var imgPath="/@com_id/addFile/"+customer_id+"/"+orderNo+".jpg";
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":5
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		var item=$($("#fujianItem").html());
		$("#fujianList").append(item);
		item.find("a").attr("href",imgurl);
		item.find(".btn-default").click(function(){
			var item=$(this).parent();
			var url=item.find("a").attr("href");
			$.get("../upload/removeTemp.do",{"imgUrl":url},function(data){
				if(data.success){
					item.remove();
				}
			});
		});
		$.get("../employee/writeOperatingLog.do",{
			"content":"为客户上传客户订单附件,客户名称:"+$(".sim-msg>.col-xs-6").html()
		},function(data){
			if (data.success) {
				pop_up_box.toast("上传保存成功!",1000);
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