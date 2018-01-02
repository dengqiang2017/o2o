$(function(){
	var names=$.cookie("customer_name");
	var ditch_type=$.cookie("ditch_type");
	if (names) {
		names=names.split(",");
		var lis=$(".sim-msg");lis.html("");
		for (var i = 0; i < names.length; i++) {
			if (names[i]!="") {
				lis.append("<li>"+names[i]+"</li>");
			}
		}
	}
	$("#item").find("span").html("");
	if (ditch_type=="消费者") {
		$("#price_type option[value='协议']").remove();
		$("#price_type option[value='批发']").remove();
	}else if (ditch_type=="普通消费者") {
		$("#price_type option[value='零售']").remove();
		$("#price_type option[value='协议']").remove();
	}else{
		$("#price_type option[value='零售']").remove();
		$("#price_type option[value='批发']").remove();
	}
	var tabs0 = $(".tabs-content:eq(0)");
	var tabs1 = $(".tabs-content:eq(1)");
	var item01 = tabs0.find("#item01");
	var item02 = tabs0.find("#item02");
	var item03 = tabs1.find("#item01");
	var item04 = tabs1.find("#item02");
	var itemhtml=$("#item");
	item01.html("");
	item02.html("");
	var tabsIndex = 0;
	function addItem(data){
		if (data&&data.rows.length>0) {
			if (tabsIndex == 0) {
				item1 = item01;
				item2 = item02;
			} else {
				item1 = item03;
				item2 = item04;
			}
			$.each(data.rows,function(i,n){
				var item=itemhtml.clone();
				if (i%2==0) {
					item1.append(item);
				}else{
					item2.append(item);
				}
				//item_Sellprice	decimal(17,6)	批发价
				//item_zeroSell	decimal(17,6)	零售价
				item.find("#item_name").html(n.item_name);
				item.find("#item_id").val(n.item_id);
				item.find("#item_spec").html(n.item_spec);
				item.find("#item_type").html(n.item_type);
				item.find("#item_color").html(n.item_color);
				item.find("#class_card").html(n.class_card);
				item.find("#quality_class").html(n.quality_class);
				
				item.find("#price_otherDiscount").val(n.price_otherDiscount);
				item.find("#price_display").val(n.price_display);
				item.find("#price_prefer").val(n.price_prefer);
				item.find("#sd_unit_price").val(n.sd_unit_price);
				
				item.find("#item_unit").html(n.item_unit);
				item.find("img").attr("src","../phone/img/"+$.trim(n.item_id)+"/cp/0.png");
				item.find("img").error(function(){
					this.src="../phone/img/"+$.trim(n.item_id)+"/cp/0.jpg";
					$(this).unbind("error");
				});
				$("#page").val(data.page);
				$("#totalPage").val(data.totalPage);
				var price_type=item.find("#price_type").val();
				var sd_unit_price_DOWN=item.find("input[name='sd_unit_price_DOWN']");
				var sd_unit_price_UP=item.find("input[name='sd_unit_price_UP']");
				var item_zeroSell="0";
				if (n.item_zeroSell&&n.item_zeroSell!='') {
					item_zeroSell=n.item_zeroSell;
				}
				var item_Sellprice="0";
				if (n.item_Sellprice&&n.item_Sellprice!='') {
//					item_Sellprice=n.item_Sellprice;
					item_Sellprice=n.price_display;
				}
				if (sd_unit_price_DOWN.length>0) {
					if(price_type=="零售"){
						sd_unit_price_DOWN.val(item_zeroSell);
						sd_unit_price_UP.val(item_zeroSell);
					}else if (price_type=="批发") {
						sd_unit_price_DOWN.val(item_Sellprice);
						sd_unit_price_UP.val(item_Sellprice);
					}
				}else{
					  sd_unit_price_DOWN=item.find("#sd_unit_price_DOWN");
					  sd_unit_price_UP=item.find("#sd_unit_price_UP"); 
					  if(price_type=="协议"){
							
						}else if (price_type=="批发") {
							sd_unit_price_DOWN.html(item_Sellprice);
							sd_unit_price_UP.html(item_Sellprice);
						}else{
							sd_unit_price_DOWN.html(item_zeroSell);
							sd_unit_price_UP.html(item_zeroSell);
						}
				}
				if (tabsIndex == 0) {
					item.find("input").prop("disabled",false);
					$("#page").val(data.page);
					$("#totalPage").val(data.totalPage);
					$("#count").val(data.totalRecord);
				} else {
					item.find("input").prop("disabled",true);
					$("#paged").val(data.page);
					$("#totalPaged").val(data.totalPage);
					$("#counted").val(data.totalRecord);
				}
			});
			detailClick();
		}else{
			item1.html("无记录!");
		}
	}
	pop_up_box.loadWait();
		$.get("../product/proPageList.do",function(data){
			addItem(data);
			$("#page").val(data.page);
			if (data.totalPage<data.page) {
				$(".btn-add").parent().hide();
			}
			pop_up_box.loadWaitClose();
		});
		// 数据展示
		$(".nav li").click(function() {
			var n = $(".nav li").index(this);
			tabsIndex = n;
			if (n == 1) {
				pop_up_box.loadWait();
				var customer_id=$.cookie("customer_id");
					customer_id=customer_id.split(",")[0];
				$("#allcheck,#add").hide();
				item03.html("");
				item04.html("");
				$.get("../product/getClientAdded.do", {
					"customer_id" : customer_id,
					"ver" : Math.random()
				}, function(data) {
					pop_up_box.loadWaitClose();
					addItem(data);
					if (data.totalPage < data.page) {
						$(".btn-add:eq(1)").parent().hide();
					}
				});
			}else{
				$("#allcheck,#add").show();
			}
		});
		
		$(".btn-add").click(function(){
			var lia = $(".nav li").index($(".nav .active"));
			if (lia == 0) {
			if ($("#page").val()==$("#totalPage").val()) {
				pop_up_box.showMsg("已全部加载!");
			}else{
				pop_up_box.loadWait();
				$("#page").val(parseInt($("#page").val())+1);
				$.get("../product/proPageList.do",$("#findForm").serialize(),function(data){
					addItem(data);
					$("#page").val(data.page);
					if (data.totalPage<data.page) {
						$(".btn-add").parent().hide();
					}
					pop_up_box.loadWaitClose();
				});
			}
			}else{
				pop_up_box.loadWait();
				var customer_id=$.cookie("customer_id");
					customer_id=customer_id.split(",")[0];
					$("#paged").val(parseInt($("#paged").val())+1);
				$.get("../product/getClientAdded.do", {
					"customer_id" : customer_id,
					"ver" : Math.random()
				}, function(data) {
					pop_up_box.loadWaitClose();
					addItem(data);
					if (data.totalPage < data.page) {
						$(".btn-add:eq(1)").parent().hide();
					}
				});
			}
		});
		loadTree("folding");
		loadTree("filter");
		function loadTree(folding){
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
		$(".find").click(function(){
			$("#page").val("0");
			item01.html("");
			item02.html("");
			pop_up_box.loadWait();
//				$.get("../product/proPageList.do",$("#findForm").serialize(),function(data){
			$.get("../product/proPageList.do",{"searchKey":$.trim($("#searchKey").val())},function(data){
				addItem(data);
				$("#page").val(data.page);
				if (data.totalPage<data.page) {
					$(".btn-add").parent().hide();
				}
				pop_up_box.loadWaitClose();
			});
		});
		
		function detailClick(){
			$(".p-ctn").find("img").click(function(){
				var item_id=$(this).parents(".p-ctn").find("#item_id").val();
				$.cookie("item_id",item_id);
				window.location.href="../product/productDetail.do?item_id="+item_id;
			});
			initNumInput();
			$(".pro-check .check").click(function(){
				  if ($(this).prop("checked")) {
					  $(this).parent().addClass("pro-checked");
				  }else{
					  $(this).parent().removeClass("pro-checked");
				  }
				});
		}

		$("#allcheck").click(function(){
			$("input:checkbox").prop("checked",!$("input:checkbox").prop("checked"));
			if ($("input:checkbox").prop("checked")) {
			    $(".pro-check").removeClass("pro-checked");
			  }else{
			    $(".pro-check").addClass("pro-checked");
			  }
		});
		$("#add").click(function(){
			var chekcs=$("input:checked");
			if (chekcs&&chekcs.length>0) {
				var item_ids=[];
				var price_type=$(chekcs[0]).parents("#item").find("#price_type").val();
				for (var i = 0; i < chekcs.length; i++) {
					var item_id=$(chekcs[i]).parents("#item").find("#item_id").val();
					if (item_id&&item_id!="") {
						var item=$(chekcs[i]).parents("#item");
						
						var discount_ornot=item.find("#discount_ornot").val();
						if(!discount_ornot){
							discount_ornot="N";
						}
						var discount_time_begin=item.find("#discount_time_begin").val();
						var discount_time=item.find("#discount_time").val();
						var price_otherDiscount=item.find("#price_otherDiscount").val();
						var price_display=item.find("#price_display").val();
						var price_otherDiscount=item.find("#price_otherDiscount").val();
						var price_prefer=item.find("#price_prefer").val();
						
						
						var sd_unit_price_DOWN=item.find("input[name='sd_unit_price_DOWN']").val();
						var sd_unit_price_UP=item.find("input[name='sd_unit_price_UP']").val();
						if (!sd_unit_price_DOWN) {
							  sd_unit_price_DOWN=item.find("#sd_unit_price_DOWN").html();
							  sd_unit_price_UP=item.find("#sd_unit_price_UP").html(); 
						}
						if (sd_unit_price_DOWN=='') {
							sd_unit_price_DOWN=0;
							
						}
						if (sd_unit_price_UP=='') {
							sd_unit_price_UP=0;
							
						}
//						if (!sd_unit_price_DOWN||sd_unit_price_DOWN==""||!sd_unit_price_UP||sd_unit_price_UP=="") {
//							pop_up_box.showMsg("请输入价格区间!");
//							return;
//						}
						if (price_otherDiscount=="") {
							item.find("#price_otherDiscount").val("0");
						}
						if (price_prefer=="") {
							item.find("#price_prefer").val("0");
						}
						if (price_display=="") {
							item.find("#price_display").val("0");
						}
							var itemdata={
									"item_id":item_id,
									"discount_ornot":discount_ornot,
									"discount_time_begin":discount_time_begin,
									"discount_time":discount_time,
									"sd_unit_price_DOWN":sd_unit_price_DOWN,
									"price_otherDiscount":price_otherDiscount,
									"price_display":price_display,
									"price_prefer":price_prefer,
									"sd_unit_price_UP":sd_unit_price_UP}
							item_ids.push(JSON.stringify(itemdata));
							item.remove();
					}
					
				}
				var customer_id=$.cookie("customer_id");
				if ($("#customer_id").length>0) {
					customer_id=[];
					customer_id.push($("#customer_id").val());
				}else{
					customer_id=customer_id.split(",");
				}
				if (!item_ids||item_ids.length<=0) {
					pop_up_box.showMsg("没有获取到产品编码,请刷新页面重试!");
				}
				pop_up_box.postWait();
				$.post("../product/addPro.do",{"itemIds":item_ids,"customer_ids":customer_id,"price_type":"零售"},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						$.cookie("customer_id",undefined);
						pop_up_box.showMsg("数据提交成功!");
					}else{
						pop_up_box.showMsg("保存失败,错误:"+data.msg);
					}
				});
			}else{
				pop_up_box.showMsg("请至少选择一个产品!");
			}
		}); 
	/////删除已增加产品///
		$(".btn-danger").click(function(){
			var chekcs = tabs1.find("input:checked");
			if (chekcs && chekcs.length > 0) {
				var item_ids = [];
				for (var i = 0; i < chekcs.length; i++) {
					var item = $(chekcs[i]).parents("#item");
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
					"itemIds" : item_ids,
					"type" : "yg"
				}, function(data) {
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("品种删除成功!", function() {
						});
					} else {
						pop_up_box.showMsg("数据提交失败!错误:" + data.msg);
					}
				});
			} else {
				pop_up_box.showMsg("请至少选择一个产品!");
			}
		});
});