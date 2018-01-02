$(function(){
	var type=0;
	var customer_id=$.cookie("customer_id");
	if (!customer_id||customer_id=="") {
		customer_id= $("#customer_id").val();
		type=1;
	}
	if ($("#customer_id").length>0&&$("#customer_id").val()!="") {
		customer_id= $("#customer_id").val();
		type=1;
	}
	var m = 0;
	var timer = setInterval(function(){
		if(m < $(".img-lg img").length-1){
			m = m + 1;
		}
		else{
			m = 0;
		}
		$(".img-lg img").hide();
		$(".img-lg img:eq("+m+")").show();
		$(".img-ctn img").addClass("display: none;");
		$(".img-ctn img:eq("+m+")").addClass("display: block;");
	},4000); 
	var item01=$("#item01");
	var item02=$("#item02");
	var itemhtml=$("#item");
//	$("#item").find("span").html("");
//	item01.html("");
//	item02.html("");
	$(".copyright,.cover").remove();
	function addItem(data){
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				var item=itemhtml.clone(true);
				if (i%2==0) {
					item01.append(item);
				}else{
					item02.append(item);
				}
				item.find("#ivt_oper_listing").val(n.ivt_oper_listing);
				item.find("#item_id").val(n.item_id);
				item.find("#sd_unit_price").val(n.sd_unit_price);
				
				item.find("#item_name").html(n.item_name);
				item.find("#item_spec").html(n.item_spec);
				item.find("#item_type").html(n.item_type);
				item.find("#item_color").html(n.item_color);
				item.find("#class_card").html(n.class_card);
				item.find("#quality_class").html(n.quality_class);
				item.find("#price_type").html(n.price_type);
				if (n.discount_ornot=="Y") {
					item.find("#discount_ornot").html("有");
				}else{
					item.find("#discount_ornot").html("无");
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
				item.find("#sd_unit_price_DOWN").html(n.sd_unit_price_DOWN);
				item.find("#sd_unit_price_UP").html(n.sd_unit_price_UP);
				item.find("img").attr("src","../phone/img/"+$.trim(n.item_id)+"/cp/0.png");
				item.find("img").error(function(){
					this.src="../phone/img/"+$.trim(n.item_id)+"/cp/0.jpg";
					$(this).unbind("error");
				});
				$("#page").val(data.page);
				$("#totalPage").val(data.totalPage);
				$("#count").val(data.totalRecord);
				item.find("input:checkbox").parent().click(function(){
				//	item.find("input:checkbox").prop("checked",!item.find("input:checkbox").prop("checked"));
				});
			});
			detailClick();
		}else{
			if (item01.html()!="") {
				pop_up_box.showMsg("已全部加载!");
			}else{
			$(".btn-add").parent().hide();
			item02.html("还没有增加产品,快去增加吧!");
			}
		}
	}
	$("#pronum").click(function(){
		
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
//	pop_up_box.loadWait();
//	$.get("../product/getOrderProduct.do",{"customer_id":customer_id},function(data){
//		pop_up_box.loadWaitClose();
//		addItem(data);
//	});
	detailClick();
	function detailClick(){
		$(".p-ctn").find("img").click(function(){
			var item_id=$(this).parents(".p-ctn").find("#item_id").val();
			$.cookie("item_id",item_id);
			window.location.href="../product/productDetail.do?item_id="+item_id;
		});
	}
	$(".btn-add").click(function(){
		if ($("#page").val()==$("#totalPage").val()) {
			pop_up_box.showMsg("已全部加载!");
		}else{
			pop_up_box.loadWait();
			$.get("../product/getOrderProduct.do",$("#findForm").serialize(),function(data){
				pop_up_box.loadWaitClose();
				addItem(data);
			});
		}
	});
	$("#page").val("1");
	$(".find").click(function(){
		$("#page").val("0");
		$("#count").val("");
		item01.html("");
		item02.html("");
		pop_up_box.loadWait();
		$.get("../product/getOrderProduct.do",$("#findForm").serialize(),function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	});
	$("#allcheck").click(function(){
		$(":checkbox").prop("checked",!$(":checkbox").prop("checked"));
	});
	$("#saveOrder").click(function(){
		var chekcs=$("input:checked");
		if (chekcs&&chekcs.length>0) {
			
			pop_up_box.showMsg("您还没有登录,去登录吧!",function(){
				window.location.href="login-kehu.html";
			});
			return;
			var item_ids=[];
//			var price_type=$(chekcs[0]).parents("#item").find("#price_type").val();
			for (var i = 0; i < chekcs.length; i++) {
				var item_id=$(chekcs[i]).parents("#item").find("#item_id").val();
				item_id=$.trim(item_id);
				if (item_id!="") {
					var item=$(chekcs[i]).parents("#item");
					
					var sd_unit_price=item.find("#sd_unit_price").val();
					var ivt_oper_listing=item.find("#ivt_oper_listing").val();
					var pronum=item.find("#pronum").val();
					if (pronum=="") {
						pronum="1";
					}
					var itemdata={
							"ivt_oper_listing":ivt_oper_listing,
							"item_id":item_id,
							"pronum":pronum,
							"sd_unit_price":sd_unit_price}
						item_ids.push(JSON.stringify(itemdata));
				}
			}
			pop_up_box.postWait();
			$.post("../product/addOrder.do",{
				"customer_id":customer_id,
				itemIds:item_ids,
				"type":type
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("订单提交成功!",function(){
						window.location.href="myorder.do?type=0";
					});
				}else{
					pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
	
	///////////////////
	
	$("#item_name").bind("input propertychange blur",function(){
		$("input[name='item_name']").val($(this).val());
	});
	$("input[name='item_name']").bind("input propertychange blur",function(){
		$("#item_name").val($(this).val());
	});
	
	$("#item_spec").bind("input propertychange blur",function(){
		$("input[name='item_spec']").val($(this).val());
	});
	$("input[name='item_spec']").bind("input propertychange blur",function(){
		$("#item_spec").val($(this).val());
	});
	
	$("#item_type").bind("input propertychange blur",function(){
		$("input[name='item_type']").val($(this).val());
	});
	$("input[name='item_type']").bind("input propertychange blur",function(){
		$("#item_type").val($(this).val());
	});
	
	$("#class_card").bind("input propertychange blur",function(){
		$("input[name='class_card']").val($(this).val());
	});
	$("input[name='class_card']").bind("input propertychange blur",function(){
		$("#class_card").val($(this).val());
	});
	
	$("#item_color").bind("input propertychange blur",function(){
		$("input[name='item_color']").val($(this).val());
	});
	$("input[name='item_color']").bind("input propertychange blur",function(){
		$("#item_color").val($(this).val());
	});
	
	$("#quality_class").bind("input propertychange blur",function(){
		$("input[name='quality_class']").val($(this).val());
	});
	$("input[name='quality_class']").bind("input propertychange blur",function(){
		$("#quality_class").val($(this).val());
	});
	
	$("#peijian_id").bind("input propertychange blur",function(){
		$("input[name='peijian_id']").val($(this).val());
	});
	$("input[name='peijian_id']").bind("input propertychange blur",function(){
		$("#peijian_id").val($(this).val());
	});
	
	$("#easy_id").bind("input propertychange blur",function(){
		$("input[name='easy_id']").val($(this).val());
	});
	$("input[name='easy_id']").bind("input propertychange blur",function(){
		$("#easy_id").val($(this).val());
	});
	
	$("#goods_origin").bind("input propertychange blur",function(){
		$("select[name='goods_origin']").val($(this).val());
	});
	$("select[name='goods_origin']").bind("input propertychange blur",function(){
		$("#goods_origin").val($(this).val());
	});
	
	$("#item_style").bind("input propertychange blur",function(){
		$("select[name='item_style']").val($(this).val());
	});
	$("select[name='item_style']").bind("input propertychange blur",function(){
		$("#item_style").val($(this).val());
	});
});