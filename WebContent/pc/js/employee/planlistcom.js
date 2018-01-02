var planlist = {
	init : function() {
		var itemhtml = $("#item");
		$("#save,#allcheck").removeAttr("disabled");
		$("#sd_order_direct option:first").prop("selected", 'selected'); 
		$("#ti").show(); 
		pickedFunc();
		$("#findForm .pull-left").hide();
		$("#findForm .pull-left:eq(8)").show();
		//切换li标签时模拟搜索框点击事件自动获取数据
		productpage.navLiClick(function(item,lia){
			var lia = $(".nav li").index($(".nav .active"));
			if (lia == 1) {
				if ($.trim($(".tabs-content:eq(1)").find("#list").html())=="") {
					$(".find:eq(1)").click();
				}
				$("#finded").show();$("#finding").hide();
				$("#save").hide();
				$("#allcheck").parent().hide();
			}else{
				$("#finding").show();$("#finded").hide();
				$("#save").show();
				$("#allcheck").parent().show();
				if ($.trim($(".tabs-content:eq(0)").find("#list").html())=="") {
					$(".find:eq(0)").click();
				}
			}
		});
		// /////////////已计划/////// 
		var planPage={
				page:1,
				count:0,
				totalPage:0
		};
		var productPage={
				page:0,
				count:0,
				totalPage:0
		};
		//加载更多数据 
		productpage.btnAddClick(function(page,count,totalPage){
			var lia = $(".nav li").index($(".nav .active"));
			if(lia==0){
				productPage.page+=1;
				page=productPage.page;
				count=productPage.count;
				totalPage=productPage.totalPage;
			}else{
				planPage.page+=1;
				page=planPage.page;
				count=planPage.count;
				totalPage=planPage.totalPage;
			}
			if (page<=totalPage) {
				loadData(page, count);
			}
		});
		productpage.initBtnClick(function(lia){
			if(customer_id){
				if (lia==0) {
					productPage.page=0;
				}else{
					planPage.page=0;
				}
				loadData(0,0);
			}else{
				$("#seekh").click();
			}
		});
		function loadData(page, count){
			var lia = $(".nav li").index($(".nav .active"));
			pop_up_box.loadWait();
			var url="";
			var searchKey="";
			var goods_origin="";
			if (lia == 0) {
				url="../product/getOrderProduct.do";
				searchKey=$.trim($("#finding").find("#searchKey").val());
			} else if(lia==1){
				url="../product/getPlanList.do";
				searchKey=$.trim($("#finded").find("#searchKey").val());
				goods_origin= "%"+$("#sd_order_direct").val()+"%";
			}
			$.get(url, {
				"searchKey" : searchKey,
				"customer_id" : customer_id,
				"goods_origin" :goods_origin
			}, function(data) {
				pop_up_box.loadWaitClose();
				addItem(data);
				productpage.setPageParam(data);
			});
		}
		function addItem(data) {
			if (data && data.rows.length > 0) {
				var lia = $(".nav li").index($(".nav .active"));
				$.each(data.rows,function(i, n) {
					var item=$($("#item").html());
					$(".tabs-content").eq(lia).find("#list").append(item);
					loadProInfo(item, n);
					item.find("#seeds_id").html(n.seeds_id);
					item.find("#com_id").append($.trim(n.com_id));
					item.find("#sd_unit_price").val(n.sd_unit_price);
					if (n.ivt_oper_listing) {
						item.find("#ivt_oper_bill").val(n.ivt_oper_listing);
					}else{
						item.find("#ivt_oper_bill").hide();
					}
					if (lia == 1) {
						item.find("#ivt_oper_listing").html("计划单号:"+n.ivt_oper_listing);
						var now = new Date(n.so_consign_date);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						item.find("#so_consign_date").html("下计划时间:"+nowStr);
					}else{
						item.find("#ivt_oper_listing").hide();
					}
					item.find("#clerk_id_sid").val(n.clerk_id);
					item.find(".num").val(n.sd_oq);
					if(n.pack_unit){
						if(n.pack_unit>1){
							item.find(".zsum").val(n.sd_oq/n.pack_unit);
						}else{
							item.find(".zsum").val(n.sd_oq*n.pack_unit);
						}
					}else{
						item.find(".zsum").val(n.sd_oq);
					}
					productpage.itemInit(n,item);
					item.find("#price_type").html(n.price_type);
					if (n.discount_ornot == "Y") {
						item.find("#discount_ornot").html("有");
					} else {
						item.find("#discount_ornot").html("无");
					}
					productpage.itemDateInit(n.discount_time_begin,item,"discount_time_begin");
					productpage.itemDateInit(n.discount_time,item,"discount_time");
					item.find("#sd_unit_price_DOWN").html(
							n.sd_unit_price_DOWN);
					item.find("#sd_unit_price_UP").html(
							n.sd_unit_price_UP);
					if (item.find("img").length>0) {
					item.find("img").attr("src",
							"../"+com_id+"/img/" + $.trim(n.item_id)
									+ "/sl.jpg");
					}
					if(lia==0){
						productpage.initNumIpt(item);
					}
					item.find("#saveEdit").click(function(){
						var item = $(this).parents(".dataitem");
						var num = $.trim(item.find(".num").val());
						var c_memo=$.trim(item.find("#c_memo").html());
						var memo_color=$.trim(item.find("#memo_color").html());
						var memo_other=$.trim(item.find("#memo_other").html());
						var seeds_id=$.trim(item.find("#seeds_id").html());
						var json={};
						pop_up_box.postWait();
						$.post("../product/savePlanEidt.do",{
							"num":num,
							"seeds_id":seeds_id,
							"c_memo":c_memo,
							"memo_color":memo_color,
							"memo_other":memo_other
						},function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.toast("保存成功!",1500);
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
				});
			}else{
				pop_up_box.toast("已全部加载!",300);
			}
		}  
		$("#sd_order_direct").change(function() {
			var p1 = $(this).children('option:selected').val();
			var lia = $(".nav li").index($(".nav .active"));
			if (p1 == "日计划") {
				$("#ti,#timespan").show();
				 $(".nav li:eq(1)>a").html("编辑当天计划");
			} else {
				if (p1=="周计划") {
					$(".nav li:eq(1)>a").html("编辑本周计划");
				}else{
					$(".nav li:eq(1)>a").html("编辑本月计划");
				}
				$("#ti,#timespan").hide();
			}
			if (lia==1) {
				$(".find:eq(1)").click();
			}
		});
		/////////
		$("#save").click(function() {
			if ($("#sd_order_direct").val() == "日计划") {
				if ($.trim($("#at").val()) == "") {
					pop_up_box.showMsg("请选择预计提货日期!");
					return;
				}
			}
			var chekcs = $(".tabs-content:eq(0)").find("#check:checked");
			if (chekcs && chekcs.length > 0) {
				var item_ids = [];
				for (var i = 0; i < chekcs.length; i++) {
					var item = $(chekcs[i]).parents(".dataitem");
					var item_id = item.find("#item_id").html();
					item_id = $.trim(item_id);
					if (item_id != "") {
						var num = $.trim(item.find(".num").val());
						if (num == ""||num=="0") {
							pop_up_box.showMsg("请输入计划数量!", function() {
								item.find(".num").focus().select();
							});
							return;
						}
						var pack_unit=$.trim(item.find("#pack_unit").html());
						var c_memo=$.trim(item.find("#c_memo").html());
						var memo_color=$.trim(item.find("#memo_color").html());
						var memo_other=$.trim(item.find("#memo_other").html());
						var itemdata = {
							"item_id" : item_id,
							"sid" : $("#seeds_id").html(),
							"ivt_oper_bill" : item.find("#ivt_oper_bill").val(),
							"clerk_id_sid" : item.find("#clerk_id_sid").val(),
							"num" : num,
							"c_memo" : c_memo,
							"memo_color" : memo_color,
							"memo_other" : memo_other,
							"pack_unit" : pack_unit
						}
						item_ids.push(JSON.stringify(itemdata));
						item.remove();
					}
				}
				// ////
				pop_up_box.postWait();
				var if_Insert_Plan="否";
				var insert_remark="";
				if (!$("#chadan").is(":hidden")) {
					if_Insert_Plan="是";
					insert_remark=$("#chadantext>textarea").text();
				}
				$("#"+customer_id).parents("ul").addClass("active");
				$("#save,#allcheck").attr("disabled", "disabled");
				$.post("../product/addPlan.do", {
					"customer_id" : customer_id,
					"itemIds" : "["+item_ids.join(",")+"]",
					"if_Insert_Plan" : if_Insert_Plan,
					"insert_remark" : insert_remark,
					// "so":$("#so").val(),
					"at" : $("#at").val(),
					"sd_order_direct" : $("#sd_order_direct").val(),
					"type" : "yg"
				}, function(data) {
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("计划提交成功,增加["+item_ids.length+"]个产品", function() {
								$(".nav li:eq(1)").click();
								$(".find:eq(1)").click();
						});
					} else {
						pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
					}
					$("#save,#allcheck").removeAttr("disabled");
				});
			} else {
				pop_up_box.showMsg("请至少选择一个产品!");
			}
		});
/////删除已下计划///
		$("#plandel").click(function(){
			var chekcs = $(".tabs-content:eq(1)").find("#check:checked");
			if (chekcs && chekcs.length > 0) {
				var item_ids = [];
				for (var i = 0; i < chekcs.length; i++) {
					var item = $(chekcs[i]).parents(".dataitem"); 
					var sid = item.find("#seeds_id").html();
					sid = $.trim(sid);
					if (sid != "") {
						var itemdata = {
							"sid" : sid ,
							"ivt_oper_bill" : item.find("#ivt_oper_bill").val()
						}
						item_ids.push(JSON.stringify(itemdata));
						item.remove();
					}
				}
				// ////
				pop_up_box.postWait();
				$.post("../product/delPlan.do", {
//					"customer_id" : customer_id,
					"itemIds" : item_ids,
					"type" : "yg"
				}, function(data) {
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("计划删除成功!");
					} else {
						pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
					}
				});
			} else {
				pop_up_box.showMsg("请至少选择一个产品!");
			}
		});
	}
}
function pickedFunc(){
	 var begin=new Date($("#at").val());
	 var n1time=new Date($("#n1time").html());
	 if (n1time>begin) {
		 $("#chadan,#chadantext").show();
	}else{
		$("#chadan,#chadantext").hide();
	}
}