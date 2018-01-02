$(function(){
	var tabs1=$($(".tabs-content")[0]);
	var tabs2=$($(".tabs-content")[1]);
	var tabs3=$($(".tabs-content")[2]);
	tabs1.find("#item").find("span").html("");
	tabs2.find("#item").find("span").html("");
	tabs3.find("#item").find("span").html(""); 
	var tabs=tabs1;
	var item01=tabs.find("#item01");
	var item02=tabs.find("#item02");
	var itemhtml=tabs.find("#item");//准备克隆数据,在清空div前
	var clicktype=0;
	$(".tabs-content").find("#item01,#item02").html("");
	var clicktype=1;
	var type=window.location.href;
	var types=type.split("?");
	if (types.length>1) {
		type=types[1].split("=")[1];
		if(type==0){
			$(".tabs-content").hide();
			$(".tabs-content:eq(2)").show();
			$(".nav li:eq(2)").addClass('active');
			$.get("orderRecord.do",function(data){
				addItem(data,tabs3);
			});
		}
	}else{
		$(".tabs-content").hide();
		$(".tabs-content:eq(0)").show();
		$(".nav li:eq(0)").addClass('active');
		$.get("orderRecord.do",{type:1},function(data){
			addItem(data,tabs1);
		});
	}
	$("#tabs1").click(function(){
		clicktype=1;
		tabs=tabs1;
		$(".tabs-content").hide();
		$(".tabs-content:eq(0)").show();
		$(".tabs-content").find("#item01,#item02").html("");
		$(".btn-add").parent().show();
		$.get("orderRecord.do",{type:clicktype},function(data){
			$(".reset").click();
			addItem(data,tabs1);
			if (data.totalPage<data.page) {
				$(".btn-add").parent().hide();
			}
		});
	});
	$(".find").click(function(){
		$("#page").val("0");
		$("#count").val("");
		$("input[name='type']").remove();
		$("#findForm").append("<input name='type' type='hidden' value='"+clicktype+"'>");
		$(".tabs-content").find("#item01,#item02").html("");
		$(".btn-add").parent().show();
		$.get("orderRecord.do",{"searchKey":$("#searchKey").val()},function(data){
			addItem(data,tabs);
			if (data.totalPage<data.page) {
				$(".btn-add").parent().hide();
			}
		});
	});
	$("#tabs2").click(function(){
		clicktype=2;
		tabs=tabs2;
		$(".tabs-content").hide();
		$(".tabs-content:eq(1)").show();
		$(".tabs-content").find("#item01,#item02").html("");
		tabs=tabs2;
		$(".reset").click();
		$(".btn-add").parent().show();
		$.get("orderRecord.do",{type:clicktype},function(data){
			addItem(data,tabs2);
			if (data.totalPage<data.page) {
				$(".btn-add").parent().hide();
			}
		});
	});
	$("#tabs3").click(function(){
		clicktype=0;
		tabs=tabs3;
		$(".tabs-content").hide();
		$(".tabs-content:eq(2)").show();
		$(".tabs-content").find("#item01,#item02").html("");
		tabs=tabs3;
		$(".reset").click();
		$.get("orderRecord.do",function(data){
			addItem(data,tabs3);
			if (data.totalPage<data.page) {
				$(".btn-add").parent().hide();
			}
		});
	});
	$("#allcheck").click(function(){
		tabs.find("input:checkbox").prop("checked",!tabs.find("input:checkbox").prop("checked"));
		if (tabs.find("input:checkbox").prop("checked")) {
			tabs.find(".pro-check").removeClass("pro-checked");
		  }else{
			  tabs.find(".pro-check").addClass("pro-checked");
		}
	});
	$(".btn-add").click(function(){
			$.get("orderRecord.do",{"type":clicktype,"page":parseInt($("#page").val())+1},function(data){
				$("#page").val(data.page);
				if (data.totalPage<data.page) {
					$(".btn-add").parent().hide();
				}
					addItem(data,tabs);
			});
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
	function addItem(data,tabs){
		var item01=tabs.find("#item01");
		var item02=tabs.find("#item02");
		
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				var item=itemhtml.clone(true);
				if (i%2==0) {
					item01.append(item);
				}else{
					item02.append(item);
				}
				item.find("#seeds_id").val(n.seeds_id);
				item.find("#ivt_oper_listing").val(n.ivt_oper_listing);
				item.find("#item_id").val(n.item_id);
				item.find("#sd_unit_price").val(n.sd_unit_price);

				item.find("#item_name").html(n.item_name); 
				item.find("#pronum").val(n.pack_num);
				item.find("#item_spec").html(n.item_spec);
				item.find("#item_type").html(n.item_type);
				item.find("#item_color").html(n.item_color);
				item.find("#class_card").html(n.class_card);
				item.find("#quality_class").html(n.quality_class);
				item.find("#price_type").html(n.price_type);
				item.find("#unit_id").html(n.unit_id);
				item.find("#sd_order_id").html(n.sd_order_id);
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
			});
			detailClick();
		}else{
			if (item01.html()!="") {
				pop_up_box.showMsg("已全部加载!");
			}else{
				$(".btn-add").parent().hide();
				item02.html("无记录!");
			}
		}
	} 
	function detailClick(){
		$(".p-ctn").find("img").click(function(){
			var item_id=$(this).parents(".p-ctn").find("#item_id").val();
			$.cookie("item_id",item_id);
			window.location.href="../product/productDetail.do?item_id="+item_id;
		});
		$("#pronum").change(function(){
			if($.trim($(this).val())==""){
				$(this).val("1");
			}
		});
		$(".pro-check .check").click(function(){
			  if ($(this).prop("checked")) {
				  $(this).parent().addClass("pro-checked");
			  }else{
				  $(this).parent().removeClass("pro-checked");
			  }
			});
	}
	
	$("#all2").click(function(){
		tabs3.find("input:checkbox").prop("checked",!tabs3.find("input:checkbox").prop("checked"));
	});
	$("#all1").click(function(){
		tabs1.find("input:checkbox").prop("checked",!tabs1.find("input:checkbox").prop("checked"));
	});

	$("#queren").click(function(){//确认订单
		var chekcs=tabs3.find("input:checked");
		if (chekcs&&chekcs.length>0) {
			var seeds_ids=[];
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents("#item");
				seeds_id=item.find("#seeds_id").val();
				var num=item.find("#pronum").val();
				if ($.trim(item.find("#pronum").val())=="") {
					num=1;
				}
				
				seeds_ids.push(JSON.stringify({"seeds_id":seeds_id,"num":num}));
			}
			pop_up_box.postWait();
			$.post("orderSelectConfirm.do",{"seeds_ids":seeds_ids},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					$("#tabs1").click();
				}else{
					pop_up_box.showMsg("保存失败,错误:"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
	$("#zhifu").click(function(){
		var chekcs=tabs1.find("input:checked");
		if (chekcs&&chekcs.length>0) {
			var seeds_ids=[];
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents("#item");
				seeds_id=item.find("#seeds_id").val();
				if ($.trim(item.find("#pronum").val())=="") {
					item.find("#pronum").val("1");
				}
				seeds_ids.push(JSON.stringify({"seeds_id":seeds_id,"num":item.find("#pronum").val()}));
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
});