$(function(){
	var tabs1=$($(".tabs-content")[0]);
	var tabs2=$($(".tabs-content")[1]);
	tabs1.find("#item").find("span").html("");
	tabs2.find("#item").find("span").html("");
	var tabs=tabs1;
	var item01=tabs.find("#item01");
	var item02=tabs.find("#item02");
	var itemhtml=tabs.find("#item");//准备克隆数据,在清空div前
	$(".tabs-content").find("#item01,#item02").html("");
	$(".nav li:eq(0)").addClass("active");
	
	$("#expand").click(function(){
		var form=$("#gzform");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
		$(".side-cover").hide();
	});
	
	if($(".tabs-content:eq(2)").find(".folding-btn").css("display")=="none"){
		$("#gzform").show();
	}else{
		$("#gzform").hide();
	}
	$(".find").click(function(){
		$("#page").val("0");
		$("#count").val("");
		var lia = $(".nav li").index($(".nav .active"));
		var tabs_content=$(".tabs-content:eq("+lia+")");
		tabs_content.find("#item01,#item02").html("");
		var searchKey;
		if (lia==0) {
			searchKey=$("#finding").find("#searchKey");
		}else{
//			searchKey=$("#finded").find("#searchKey");
		}
		pop_up_box.loadWait();
		if (lia==0) {
			$.get("../product/getClientOrdered.do",{
				"searchKey":$.trim(searchKey.val())
			},function(data){
				pop_up_box.loadWaitClose();
				addItem(data,tabs_content);
				if (data.totalPage<data.page) {
					tabs_content.find(".btn-add").parent().hide();
				}else{
					tabs_content.find(".btn-add").parent().show();
				}
			});
		}else if(lia==2){  
			pagegz=1;
			countgz=0;
			totalgz=0;
			order_gz();
		}else{
			$.get("orderRecord.do",{
				"searchKey":$.trim(searchKey.val()),"type":lia
			},function(data){
				pop_up_box.loadWaitClose();
				addItem(data,tabs_content);
				if (data.totalPage<data.page) {
					tabs_content.find(".btn-add").parent().hide();
				}else{
					tabs_content.find(".btn-add").parent().show();
				}
			});
		}
	});

	$(".nav>li:eq(0)").click(function(){
		$("#finded").hide();
		$("#finding").show();
		$(".tabs-content:eq(0)").show();
		$(".tabs-content:eq(2)").hide();
		if ($.trim($(".tabs-content:eq(0)").find("#item01").html())=="") {
			$(".find:eq(0)").click(); 
		}
	});
	$(".nav>li:eq(1)").click(function(){
		$("#finding").hide();
		$("#finded").show();
		$(".tabs-content:eq(0)").hide();
		$(".tabs-content:eq(1)").show();
		if ($.trim($(".tabs-content:eq(1)").find("#item01").html())=="") {
			$(".find:eq(1)").click(); 
		}
	});  
	$(".nav>li:eq(2)").click(function(){
		$("#finding").hide();
		$("#finded").hide();
		$(".tabs-content:eq(0)").hide();
		$(".tabs-content:eq(2)").show();
		if ($.trim($(".tabs-content:eq(2)").find("tbody").html())=="") {
			$(".find:eq(2)").click(); 
		}
	}); 
	/////////处理从外部直接进入事件////////
	var url=window.location.href.split("?");
	 if (url.length>1) {
		 var params=url[1].split("|");
		$("input[name='searchKey']").val(params[0]);
		$("select[name='type']").val(decode(params[1]));
		$(".nav>li:eq(2)").click();
	}else{
		$(".find:eq(0)").click(); 
	}
	 /////////////
	var page0=0;
	var count0=0;
	var totalPage0=0;
	var page1=0;
	var count1=0;
	var totalPage1=0;
	$(".btn-add").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs_content=$(".tabs-content:eq("+lia+")");
		var searchKey;
		var page;
		var totalPage;
		var count;
		if (lia==0) {
			searchKey=$("#finding").find("#searchKey");
			page=page0;
			count=count0;
			totalPage=totalPage0;
		}else{
			searchKey=$("#finded").find("#searchKey");
			page=page1;
			count=count1;
			totalPage=totalPage1;
		}
		if (page==totalPage) {
		}else{
			pop_up_box.loadWait();
			$.get("orderRecord.do",{
				"searchKey":$.trim(searchKey.val()),
				"type":lia,
				"page":parseInt(page)+1,
				"count":count
			},function(data){
				pop_up_box.loadWaitClose();
				addItem(data,tabs_content);
				if (lia==0) {
					page0=data.page;
					count0=data.totalRecord;
					totalPage0=data.totalPage;
				}else{
					page1=data.page;
					count1=data.totalRecord;
					totalPage1=data.totalPage;
				}
				if (data.totalPage<data.page) {
					tabs_content.find(".btn-add").parent().hide();
				}
			});
		}
	});
	
	
	function addItem(data,tabs){
		var item01=tabs.find("#item01");
		var item02=tabs.find("#item02");
		
		if (data&&data.rows&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				var item =$(itemhtml.parent().html());
				if (i%2==0) {
					item01.append(item);
				}else{
					item02.append(item);
				}
				item.find("#seeds_id").val(n.seeds_id);
				item.find("#ivt_oper_listing").val(n.ivt_oper_listing);
				item.find("#item_id").val(n.item_id);
				var sd_unit_price=n.sd_unit_price;
//				if (!n.sd_unit_price) {
//					sd_unit_price=parseFloat(n.price_display)-parseFloat(n.price_prefer);
//				}
				item.find("#sd_unit_price").val(sd_unit_price);

				item.find("#item_name").html(n.item_name); 
				item.find(".zsum").val(n.sd_oq);
				item.find("#item_spec").html(n.item_spec);
				item.find("#item_type").html(n.item_type);
				item.find("#item_color").html(n.item_color);
				item.find("#class_card").html(n.class_card);
				item.find("#pack_unit").html(n.pack_unit);
				item.find("#quality_class").html(n.quality_class);
				item.find("#price_type").html(n.price_type);
				item.find("#unit_id").html(n.unit_id);
//				item.find("#sd_order_id").html(n.sd_order_id);
				item.find("#item_unit").html(n.item_unit);
				item.find(".item_unit").html(n.item_unit);
				item.find("#pack_unit").html(n.pack_unit);
				item.find("#casing_unit").html(n.casing_unit);
				if (n.discount_ornot=="Y") {
					item.find("#discount_ornot").html("有");
				}else{
					item.find("#discount_ornot").html("无");
				}
				
				if ($.trim(n.ivt_oper_listingMyPlan)!="") {
					item.find("#ivt_oper_listingMyPlan").html(n.ivt_oper_listingMyPlan);
				}
				if ($.trim(n.ivt_oper_listing)!="") {
					item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
				}
				
				if ($.trim(n.discount_time)!="") {
					var now = new Date(n.discount_time_begin);
					var nowStr = now.Format("yyyy-MM-dd"); 
					item.find("#discount_time_begin").html(nowStr);
				}
				if ($.trim(n.discount_time)!="") {
					var now = new Date(n.discount_time);
					var nowStr = now.Format("yyyy-MM-dd"); 
					item.find("#discount_time").html(nowStr);
				}
				item.find("#sd_unit_price_DOWN").html(sd_unit_price);
				item.find("#sd_unit_price_UP").html(sd_unit_price);
				item.find("img").attr("src","../phone/img/"+$.trim(n.item_id)+"/cp/0.png");
				item.find("img").error(function(){
					this.src="../phone/img/"+$.trim(n.item_id)+"/cp/0.jpg";
					$(this).unbind("error");
				});
				/////////////////////
				var val=$.trim(item.find(".zsum").val());
				var pack_unit=n.pack_unit;
				if (val!=""&&pack_unit!="0"&&val!="0") {
					item.find(".p-middle").find(".num").val(numformat(parseFloat(val)/parseFloat(pack_unit),2));
//					if (val>=1) {
//						sd_unit_price=sd_unit_price-n.price_otherDiscount;
//						item.find("#sum_si").html(numformat(val*sd_unit_price,2));
//					}else{
//					}
					item.find("#sum_si").html(numformat(val*sd_unit_price,2));
				}else{
					item.find(".p-middle").find(".num").val(val);
				}
			});
			productpage.detailClick();
		}else{
			if (item01.html()!="") {
				pop_up_box.showMsg("已全部加载!");
			}else{
				$(".btn-add").parent().hide();
				item02.html("无记录!");
			}
		}
	}
	$("#all1").click(function(){
		if ($.trim($(".tabs-content:eq(0)").find("#item01").html())!="") {
			if ($(this).html()=="全选") {
				$(".tabs-content:eq(0)").find(".pro-check").addClass("pro-checked");
				$(this).html("取消");
			} else {
				$(this).html("全选");
				$(".tabs-content:eq(0)").find(".pro-check").removeClass("pro-checked");
			}
		}
	});
	/////删除已增加产品///
	$("#orderdel").click(function(){
			var chekcs = $(".tabs-content:eq(0)").find(".pro-checked");
			if (chekcs && chekcs.length > 0) {
				var item_ids = [];
				for (var i = 0; i < chekcs.length; i++) {
					var item = $(chekcs[i]).parents("#item");
					var seeds_id = item.find("#seeds_id").val();
					seeds_id = $.trim(seeds_id);
					if (seeds_id != "") {
						var itemdata = {
							"seeds_id" : seeds_id ,
							"ivt_oper_bill" : item.find("#ivt_oper_listing").html()
						}
						item_ids.push(JSON.stringify(itemdata));
						item.remove();
					}
				}
				// ////
				pop_up_box.postWait();
				$.post("../product/delOrderPro.do", {
//					"customer_id" : customer_id,
					"itemIds" : item_ids,
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
	$(".footer").append("v1.0.10.13");
	$("#zhifu").click(function(){
		var chekcs=$(".tabs-content:eq(0)").find(".pro-checked");
		if (chekcs&&chekcs.length>0) {
			var seeds_ids=[];
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents("#item");
				seeds_id=$.trim(item.find("#seeds_id").val());
				if ($.trim(item.find(".zsum").val())=="") {
					item.find(".zsum").val("1");
				}
				var sum_si=$.trim(item.find("#sum_si").html());
				if (seeds_id!="") {
					seeds_ids.push(JSON.stringify({
						"seeds_id":seeds_id,
						"sum_si":sum_si,
						"num":item.find(".zsum").val()
						}));
				}
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
	///////////////////////////
	var pagegz=1;
	var countgz=0;
	var totalgz=0;
	function order_gz(page){
		if (!page) {
			page="";
		}
		var tbody=$(".tabs-content:eq(2)").find("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		$.get("orderTrackingRecord.do"+page,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(7);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.item_sim_name);
					tr.find("td:eq(1)").html(n.sd_oq);
					tr.find("td:eq(2)").html(n.item_unit);
					if (n.so_consign_date) {
						var now = new Date(n.so_consign_date);
						var nowStr = now.Format("yyyy-MM-dd");
						tr.find("td:eq(3)").html(nowStr);
					}
					tr.find("td:eq(4)").html(n.sum_si);
					tr.find("td:eq(5)").html(n.Status_OutStore);
					tr.find("td:eq(6)").html(n.ivt_oper_listing);
				});
				countgz=data.totalRecord;
				totalgz=data.totalPage;
				
			}
		});
	}
	$("#onePage").click(function(){
		pagegz=1;
		var page="?page=1&count="+countgz;
		order_gz(page);
	});
	$("#uppage").click(function(){
		if (pagegz>1) {
			pagegz=pagegz+1;
			var page="?page="+pagegz+"&count="+countgz;
			order_gz(page);
		}else{
			pop_up_box.showMsg("已到第一页");
		}
	});
	$("#nextPage").click(function(){
		if (pagegz<totalgz) {
			pagegz=pagegz+1;
			var page="?page="+pagegz+"&count="+countgz;
			order_gz(page);
		}else{
			pop_up_box.showMsg("已到最后一页");
		}
	});
	$("#endPage").click(function(){
		pagegz=totalgz;
		var page="?page="+totalgz+"&count="+countgz;
		order_gz(page);
	});
});