$(function(){
			$.get("setDefaultByClerkId.do",function(data){
				$.each(data,function(i,n){
					$("#clerk_name").html(n.clerk_name);
					$("#clerkId").val(n.clerk_id);
					$("#dept_name").html(n.dept_name);
					$("#deptId").val(n.dept_id);
				})
			});
			$(".qx,.close").click(function(){
				$("#info").hide();
				$("#sure").unbind("click");
			});
			$("select").change(function(){
				$(".find:eq(1)").click();
			});
			var item01 = $("#item01"); 
			var itemhtml=$("#item");
			item01.html(""); 
			///////
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".Wdate:eq(1)").val(nowStr);
			/////
			$('body,html').animate({scrollTop:0},500);
			function addItem(data){
				if (data&&data.rows.length>0) {
					var lia = $(".nav li").index($(".nav .active"));
					var tabs= $(".tabs-content:eq("+lia+")");
					var item1 = tabs.find("#item01"); 
					$(".num").unbind("input propertychange blur");
					$.each(data.rows,function(i,n){
						var item=$(itemhtml.html());
						item1.append(item); 
						item.find("#item_id").val($.trim(n.item_id));
						item.find("#ivt_num_detail").val($.trim(n.ivt_num_detail));
						var item_cost=n.item_cost;
						item.find("#item_unit").html(n.item_unit);
						item.find("#pack_unit").html(n.pack_unit);
						item.find("#casing_unit").html(n.casing_unit);
						item.find("#item_name").html(n.item_name);
						item.find("#item_type").html(n.item_type);
						item.find("#class_card").html(n.class_card);
						item.find("#store_struct_name").html(n.store_struct_name);    
						item.find("#store_struct_id").val(n.store_struct_id);    
						if(lia==0){
							item.find("#ddzk").show();
							item.find("#discount_rate").html(100);
							item.find("#cgzk").hide();
							item.find("#item_cost").html(n.i_price);
							item.find("#kc").html(n.use_oq);
							item.find("#vendor_id").val(n.customer_id);
							item.find("#vendor_name").val(n.corp_name);
							item.find("#item_spec").html(n.item_spec);
						}else{
							item.find("#thdh").show();
							item.find("#ddzk").hide();
							item.find("#cgzk").show();
							item.find("#ddCost").hide();
							item.find("#cgCost").show();
							item.find("#ddNum").hide();
							item.find("#cgNum").show();
							item.find("#item_cost").html(n.price);
							item.find("#kc").html(n.useOq);
							item.find("#pronum").html(n.rep_qty);
							item.find("#sum_si").html(n.st_sum);
							item.find("#discountRate").html(n.discount_rate);
							item.find("#rcv_auto_no").html(n.rcv_auto_no);
							item.find("#item_spec").html(n.lot_number);
							item.find("#kc").html(n.use_oq);
							if(n.comfirm_flag=='Y'){
								$("#confirm,#allcheck").hide();
								item.find("#checkbox").hide();
							}else{
								$("#confirm,#allcheck").show();
								item.find("#checkbox").show();
							}
						}
						if (item.find("img").length>0) {
							item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
							if($.trim(n.com_id)=="001Y8"){
								var url="../product/productDetailEwm.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
								item.find("a").attr("href",url);
							}else{
								var url="../product/productDetail.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
								item.find("a").attr("href",url);
							}
						}
						if(lia==1){
							
						}
						if(lia==0){
							item.find("#pronum").bind("input propertychange blur",function(){
								var item_cost=$(this).parents(".dataitem").find("#item_cost").html();
								var num=$.trim($(this).val());
								var discount_rate=$.trim($(this).parents(".dataitem").find("#discount_rate").html());
								var sumsi=numformat2(item_cost*num*discount_rate/100);
								if (num==""||num=="0") {
									num=0;
									$(this).parents(".dataitem").find(".pro-check").removeClass("pro-checked");
								}else{
									$(this).parents(".dataitem").find(".pro-check").addClass("pro-checked");
								}
								if(discount_rate==""||discount_rate==0){
									$(this).parents(".dataitem").find("#sum_si").html((numformat2(num*item_cost)));
								}else{
									$(this).parents(".dataitem").find("#sum_si").html(sumsi);
								}
							});
						}
					});
					
					productpage.detailClick(true,function(t){
						$(t).parents(".dataitem").find("input[data-number]:eq(0)").focus().select();
					},0);
					$(".dataitem").find("img").unbind("click");
				}
			}
$(".nav li").click(function(){
	var lia = $(".nav li").index(this);
	var tabs= $(".tabs-content:eq("+lia+")");
	var item=$.trim(tabs.find("item01").html());
	if (item=="") {
		$(".find:eq("+lia+")").click();
	}
	if(lia==1){
		$("#saveOrder").hide();
		$("#confirm").show();
	}else{
		$("#saveOrder").show();
		$("#confirm").hide();
		$("#allcheck").show();
	}
	$(".form").parent().hide();
	$(".form").eq(lia).parent().show();
});
var orderPage={
		page:0,
		count:0,
		totalPage:0
};
var productPage={
		page:0,
		count:0,
		totalPage:0
};

$(".btn-add").click(function(){
	var url;
	var lia =getFindUrl(function(ulr){
		url=ulr;
	});
	var page=0;
	var count=0;
	var totalPage=0;
	if (lia==0) {
		orderPage.page+=1;
		page=orderPage.page;
		count=orderPage.count;
		totalPage=orderPage.totalPage;
	}else{
		productPage.page+=1;
		page=productPage.page;
		count=productPage.count;
		totalPage=productPage.totalPage;
	}
	if (page<=totalPage) { 
		loadData(url, lia, page, count);
	}
});
function getFindUrl(func){
	var lia = $(".nav li").index($(".nav .active"));
	var url="";
	if (lia==0) {
		url="../product/getStoreProductList.do";
	}else{
		url="purchasingReturnList.do";
	}
	func(url);
	return lia;
}
$(".find").click(function(){
	var url;
	var lia =getFindUrl(function(ulr){
		url=ulr;
	}); 
	var tabs= $(".tabs-content:eq("+lia+")");
	tabs.find("#item01").html("");
	var url;
	var page=0;
	var count=0; 
	loadData(url, lia, page, count);
});
function loadData(url,lia,page,count){
	pop_up_box.loadWait();
	var searchKey=$($(".form")[lia]).find("#searchKey").val();
	var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
	var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
	var confirm_flag=$.trim($("select:eq(0)").val());
	$.get(url,{
		"searchKey":$.trim(searchKey),
		"beginDate":beginDate,
		"endDate":endDate,
		"page":page,
		"count":count,
		"confirm_flag":confirm_flag
	},function(data){
		pop_up_box.loadWaitClose();
		addItem(data); 
		productpage.setPageParam(data);
		if(lia==0){
			orderPage.totalPage = data.totalPage;
			orderPage.count = data.totalRecord;
		}else{
			productPage.totalPage = data.totalPage;
			productPage.count = data.totalRecord;
		}
	});
}
var url=window.location.href.split("?");
var seeds_id="";
if(url&&url.length>1){
	var sear=url[1].split("=")[1];
	$("#finded").find("#searchKey").val(sear);
	$(".form").eq(1).find("#searchKey").val(sear);
	var tabs= $(".tabs-content:eq(1)");
	var item=$.trim(tabs.find("item01").html());
	$(".nav li").removeClass("active");
	$(".nav li:eq(1)").addClass("active");
	$(".tabs-content").hide();
	$("#finding").hide();
	tabs.show();
	if (item=="") {
		$("#finding").find(".find").click();
	}
}else{
	$(".find:eq(0)").click();
}
$("#allcheck").click(function() {
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	if ($.trim(tabs.find("#item01").html())!="") {
		if ($(this).html()=="全选") {
			tabs.find(".pro-check").addClass("pro-checked");
			$(this).html("取消");
		} else {
			$(this).html("全选");
			tabs.find(".pro-check").removeClass("pro-checked");
		}
	}
});
//去除数组中重复项
function unique(arr) {
    var result = [], hash = {};
    for (var i = 0, elem; (elem = arr[i]) != null; i++) {
        if (!hash[elem]) {
            result.push(elem);
            hash[elem] = true;
        }
    }
    return result;
}

$("#saveOrder").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#item01").find(".pro-checked");
	var item_ids=[];
	var vendorId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		var b=true;
		for (var i = 0; i < chekcs.length; i++) {
			var num=$(chekcs[i]).parents(".dataitem").find("#pronum").val();
			if(num==""||num==0){
				pop_up_box.showMsg("数量必须大于0!");
				b=false;
			}
		}
		if(b){
			for (var i = 0; i < chekcs.length; i++) {
				var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").val());
				if (item_id!="") {
					var item=$(chekcs[i]).parents(".dataitem");
					var pronum=item.find("#pronum").val();
					if (pronum==""||pronum=="0") {
						pronum="1";
						alert("请输入退货数量!");
						item.find(".zsum").focus().select();
						return ;
					}
					var discount_rate=$.trim(item.find("#discount_rate").html());
					var item_cost=$.trim(item.find("#item_cost").html());
					var sum_si=item.find("#sum_si").html();
					var store_struct_id=$.trim(item.find("#store_struct_id").val());
					var ivt_num_detail=$.trim(item.find("#ivt_num_detail").val());
					var kcNum=$.trim(item.find("#kc").html());
					var lot_number=$.trim(item.find("#item_spec").html());
					var store_struct_name=$.trim(item.find("#store_struct_name").html());
					var item_name=$.trim(item.find("#item_name").html());
					var item_type=$.trim(item.find("#item_type").html());
					var vendor_id=$.trim(item.find("#vendor_id").val());
					var vendor_name=$.trim(item.find("#vendor_name").val());
					var itemdata={
						"item_id":item_id, 
						"thNum":pronum,
						"st_sum":sum_si,
						"price":item_cost,
						"discount_rate":discount_rate,
						"store_struct_id":store_struct_id,
						"ivt_num_detail":ivt_num_detail,
						"kcNum":kcNum,
						"lot_number":lot_number,
						"store_struct_name":store_struct_name,
						"item_name":item_name,
						"item_type":item_type,
						"vendor_id":vendor_id,
						"vendor_name":vendor_name
					};
					if (vendorId==vendor_id) {
						vendors.push(JSON.stringify(itemdata));
					}else if(!vendorId){
						vendorId=vendor_id;
						vendors.push(JSON.stringify(itemdata));
					}else{
						vendorId=vendor_id;
						item_ids.push(vendors);
						vendors=[];
						vendors.push(JSON.stringify(itemdata));
					}
					if (i==(chekcs.length-1)) {
						item_ids.push(vendors);
					}
				}
			}
			$("#info").show();
			$("#sure").click(function(){
					var clerk_id=$.trim($(this).parent().parent().find("#clerkId").val());
					var dept_id=$.trim($(this).parent().parent().find("#deptId").val());
					var c_memo=$.trim($(this).parent().parent().find("#c_memo").val());
					pop_up_box.postWait();
					$("#saveOrder").attr("disabled", "disabled");
					$.post("../manager/itemReturn.do",{
						"item_ids":"["+item_ids.join(",")+"]",
						"clerk_id":clerk_id,
						"dept_id":dept_id,
						"c_memo":c_memo
					},function(data){
						pop_up_box.loadWaitClose();
						$("#sure").unbind("click");
						if (data.success) {
							$("#info").hide();
							pop_up_box.showMsg("开单成功!",function(){
								$(".find:eq(0)").click();
							});
						}else{
							$("#info").hide();
							pop_up_box.showMsg(data.msg);
						}
						$("#saveOrder").removeAttr("disabled");
					}); 
				})
			}
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
});

//审核
$("#confirm").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#item01").find(".pro-checked");
	var item_ids=[];
	var vendorId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var rcv_auto_no=$.trim($(chekcs[i]).parents(".p-middle").find("#rcv_auto_no").html());
			var item_id=$.trim(item.find("#item_id").val());
			var rcv_auto_no=$.trim(item.find("#rcv_auto_no").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());
			var pronum=item.find("#pronum").html();
			var itemdata={
					"item_id":item_id, 
					"store_struct_id":store_struct_id,
					"rcv_auto_no":rcv_auto_no,
					"thNum":pronum
			};
			if (vendorId==rcv_auto_no) {
				vendors.push(JSON.stringify(itemdata));
			}else if(!vendorId){
				vendorId=rcv_auto_no;
				vendors.push(JSON.stringify(itemdata));
			}else{
				vendorId=rcv_auto_no;
				item_ids.push(vendors);
				vendors=[];
				vendors.push(JSON.stringify(itemdata));
			}
			if (i==(chekcs.length-1)) {
				item_ids.push(vendors);
			}
		}
		if(window.confirm("确认退货?")){
			pop_up_box.postWait();
			$.post("../manager/confirmReturn.do",{
				"item_ids":"["+item_ids.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("审核通过,退货成功!",function(){
						$(".find:eq(1)").click();
					});
				}else{
					pop_up_box.showMsg(data.msg);
				}
			})
		}
	}else{
		pop_up_box.showMsg("请选择一个产品!");
	}
})

$(".dept").click(function(){
	pop_up_box.loadWait();
	$.get("../manager/getDeptTree.do", {
		"type" : "dept"
	}, function(data) {
		pop_up_box.loadWaitClose();
		$("body").append(data);
		dept.init(function(){
				$("#deptId").val(treeSelectId);
				$("#dept_name").html(treeSelectName);
		});
	});
});
$(".clerk").click(function(){
	pop_up_box.loadWait();
	$.get("../manager/getDeptTree.do", {
		"type" : "employee"
	}, function(data) {
		pop_up_box.loadWaitClose();
		$("body").append(data);
		employee.init(function(){
				$("#clerkId").val(treeSelectId);
				$("#clerk_name").html(treeSelectName);
		});
	});
});
});
