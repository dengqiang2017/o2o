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
var now = new Date();
var nowStr = now.Format("yyyy-MM-01"); 
$(".Wdate:eq(0)").val(nowStr);
var nowStr = now.Format("yyyy-MM-dd"); 
$(".Wdate:eq(1)").val(nowStr);
$('body,html').animate({scrollTop:0},500);
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
productpage.initBtnClick(function(lia){
	if (lia==0) {
		productPage.page=0;
	}else if(lia==1){
		orderPage.page=0;
	}else{
		rukuPage.page=0;
	}
	loadData(0,0);
});
//切换li标签时模拟搜索框点击事件自动获取数据
productpage.navLiClick(function(item,lia){
	if(lia==1){
		$("#saveOrder,#return").hide();
		$("#confirm,#delete").show();
	}else{
		$("#saveOrder").show();
		$("#confirm,#delete,#return").hide();
		$("#allcheck").show();
	}
});
//点击加载更多
productpage.btnAddClick(function(page,count,totalPage){
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
		loadData(page, count);
	}
});
function loadData(page,count){
	var lia = $(".nav li").index($(".nav .active"));
	var url;
	if(lia==0){
		url="../product/getStoreProductList.do";//带库存数的
	}else{
		url="../employee/getTransfersBills.do";
	}
	var searchKey=$($(".form")[lia]).find("#searchKey").val();
	var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
	var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
	var confirm_flag=$.trim($("select:eq(0)").val());
	pop_up_box.loadWait();
	$.get(url,{
		"searchKey":searchKey ,
		"type_id":common.getVal("#findForm #sort_name"),
		"quality_class":common.getVal("#findForm #quality_class"),
		"item_style":common.getVal("#findForm #item_style"),
		"class_card":common.getVal("#findForm #class_card"),
		"item_spec":common.getVal("#findForm #item_spec"),
		"item_struct":$.trim($("#item_struct").val()),
		"item_type":$.trim($("#item_type").val()),
		"item_color":$.trim($("#item_color").val()),
		"beginDate":beginDate,
		"endDate":endDate,
		"confirm_flag":confirm_flag,
		"page":page,
		"count":count
		},function(data){
	pop_up_box.loadWaitClose();
	addItem(data);
	 if (lia==0) {
		productPage.totalPage = data.totalPage;
		productPage.count = data.totalRecord;
	}else{
		orderPage.totalPage = data.totalPage;
		orderPage.count = data.totalRecord;
	}
});
}
function addItem(data){
	if (data&&data.rows.length>0) {
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var item1 = tabs.find("#list"); 
		$(".num").unbind("input propertychange blur");
		$.each(data.rows,function(i,n){
			var item=$($("#item").html());
			$(".tabs-content").eq(lia).find("#list").append(item);
			loadProInfo(item, n);
			item.find("#kc").html(n.use_oq);
			item.find(".corp_id").val(n.corp_id);  
			if(lia==0){
				item.find(".store").bind("click",function(){
					var div=$(this).parents(".dataitem");
					pop_up_box.loadWait(); 
					//入货仓库
					$.get("../manager/getDeptTree.do", {
						"type" : "warehouse"
					}, function(data) {
						pop_up_box.loadWaitClose();
						$("body").append(data);
						warehouse.init(function(){
							div.find("#store_name").html(treeSelectName);
							div.find("#storeId").val(treeSelectId);
						});
					});
				});
				item.find(".gys").bind("click",function(){
					var div=$(this).parents(".dataitem");
					pop_up_box.loadWait(); 
					//入货仓库
					$.get("../manager/getDeptTree.do", {
						"type" : "vendor"
					}, function(data) {
						pop_up_box.loadWaitClose();
						$("body").append(data);
						vendor.init(function(){
							div.find(".corp_name").html(treeSelectName);
							div.find(".corp_id").val(treeSelectId);
						});
					});
				});
				item.find("#discount_rate").val(100);
				item.find("#item_cost").val(n.i_price);
				item.find("#store_struct_name").html(n.store_struct_name); 
				item.find("#store_struct_id").val(n.store_struct_id);
				item.find("#pronum").bind("input propertychange blur",function(){
					var item_cost=$(this).parents(".dataitem").find("#item_cost").val();
					var num=$.trim($(this).val());
					var discount_rate=$.trim($(this).parents(".dataitem").find("#discount_rate").val());
					var sumsi=numformat2(item_cost*num*discount_rate/100);
					if (num==""||num=="0") {
						num=0;
						$(this).parents(".dataitem").find("#check").prop("checked",false);
					}else{
						$(this).parents(".dataitem").find("#check").prop("checked",true);
					}
					if(discount_rate==""||discount_rate==0){
						$(this).parents(".dataitem").find("#sum_si").html((numformat2(num*item_cost)));
					}else{
						$(this).parents(".dataitem").find("#sum_si").html(sumsi);
					}
				});
				item.find("#itemCost").parent().remove();
				item.find("#hav_rcv").parent().remove();
				item.find("#ivt_oper_listing").parent().remove();
				item.find("#drck").remove();
				item.find("#db_name").parent().remove();
				item.find("#corp_name").parent().remove();
				item.find("#c_memo").parent().remove();
				item.find(".corp_name").html(n.corp_name);
			}else{
				item.find("#item_cost").parent().remove();
				item.find("#pronum").parent().remove();
				item.find("#storeStruct").remove();
				item.find("#gysselect").remove();
				
				item.find("#corp_name").html(n.corp_name);
				item.find("#itemCost").html(n.oper_price);//调拨单价
				item.find("#hav_rcv").html(n.oper_qty);//调拨数量
				item.find("#sum_si").html(n.oper_qty*n.oper_price);//调拨金额
//							item.find("#sum_si").html(n.plan_price);//调拨金额
				item.find("#ivt_oper_listing").html($.trim(n.ivt_oper_listing));
				item.find("#store_name").html(n.store_struct_name);//调入仓库
				item.find("#storeId").val(n.corpstorestruct_id);//调入仓库id
				item.find("#store_struct_name").html(n.store_name); //当前仓库
				item.find("#store_struct_id").val(n.store_struct_id);
				item.find("#db_name").html(n.clerk_name);
				item.find("#c_memo").html(n.c_memo);
				
			}
			item.find(".btn-default:eq(0)").click(function(){
				$(this).parents(".input-group").find("#storeId").val("");
				$(this).parents(".input-group").find("#store_name").html("");
			});
			item.find(".btn-default:eq(1)").click(function(){
				$(this).parents(".input-group").find(".corp_id").val("");
				$(this).parents(".input-group").find(".corp_name").html("");
			});
		});
		if(lia==1){
			if($("#confirm_flag").val()=='2'){
				$("#confirm,#delete").hide();
				$("#return").show();
			}else{
				$("#confirm,#delete").show();
				$("#return").hide();
			}
		}
		common.initNumInput();
		productpage.clearSelect();
	}
}
$(".find:eq(0)").click();
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
//生成库存调拨单
$("#saveOrder").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#list #check:checked");
	var item_ids=[];
	var itemId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		var b=true;
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var num=item.find("#pronum").val();//调拨数量
			var oper_price=$.trim(item.find("#item_cost").val());//调拨单价
			var store_struct_id=$.trim(item.find("#store_struct_id").val());//当前仓库
			var in_store_struct_id=$.trim(item.find("#storeId").val());//调入仓库
			var kcNum=$.trim(item.find("#kc").html());//库存
			if(num==""||num==0){
				num="1";
				pop_up_box.showMsg("调拨数量必须大于0!");
				item.find(".zsum").focus().select();
				b=false;
			}
			if(oper_price==""||oper_price=="0"){
				pop_up_box.showMsg("请输入调拨单价!");
				item.find("#item_cost").focus().select();
				b=false;
			}
			if(in_store_struct_id==""){
				pop_up_box.showMsg("请选择调入仓库!");
				b=false;
			}
			if(in_store_struct_id==store_struct_id){
				pop_up_box.showMsg("禁止调入仓库为当前仓库,请重新选择!");
				b=false;
			}
			if(num-kcNum>0){
				pop_up_box.showMsg("调拨数量大于库存数量!");
				b=false;
			}
		}
		if(b){
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents(".dataitem");
				var item_id=$.trim(item.find("#item_id").html());
				if (item_id!="") {
					var oper_price=$.trim(item.find("#item_cost").val());//调拨单价
					var oper_qty=item.find("#pronum").val();//调拨数量
					var store_struct_id=$.trim(item.find("#store_struct_id").val());//当前仓库
					var in_store_struct_id=$.trim(item.find("#storeId").val());//调入仓库
					var corp_id=$.trim(item.find(".corp_id").val());//供应商
					var plan_price=item.find("#sum_si").html();//调拨金额
					var unit_id=item.find(".item_unit:eq(0)").html();//基本单位
					var itemdata={
							"item_id":item_id, 
							"store_struct_id":store_struct_id,
							"in_store_struct_id":in_store_struct_id,
							"plan_price":plan_price,
							"oper_price":oper_price,
							"oper_qty":oper_qty,
							"corp_id":corp_id,
							"unit_id":unit_id
					};
					if (itemId==item_id) {
						vendors.push(JSON.stringify(itemdata));
					}else if(!itemId){
						itemId=item_id;
						vendors.push(JSON.stringify(itemdata));
					}else{
						itemId=item_id;
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
					if(clerk_id==''||clerk_id==null){
						pop_up_box.showMsg("请选择经办人!");
						return;
					}else if(dept_id==''||dept_id==null){
						pop_up_box.showMsg("请选择经办部门!");
						return;
					}
					$("#info").hide();
					pop_up_box.postWait();
					$("#sure").attr("disabled", "disabled");
					$.post("../employee/saveTransfersBills.do",{
						"item_ids":"["+item_ids.join(",")+"]",
						"clerk_id":clerk_id,
						"dept_id":dept_id,
						"c_memo":c_memo
					},function(data){
						pop_up_box.loadWaitClose();
						$("#sure").unbind("click");
						if (data.success) {
							pop_up_box.showMsg("已生成调拨单,等待审核!",function(){
								$("#allcheck").html("全选");
								tabs.find("#list #check").prop("checked",false);
								$(".find:eq(0)").click();
							});
						}else{
							pop_up_box.showMsg(data.msg);
						}
						$("#sure").removeAttr("disabled");
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
	var chekcs=tabs.find("#list #check:checked");
	var item_ids=[];
	var itemId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim(item.find("#item_id").html());
			var item_cost=$.trim(item.find("#item_cost").val());//调拨单价
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());//当前仓库
			var in_store_struct_id=$.trim(item.find("#storeId").val());//调入仓库
			var oper_qty=$.trim(item.find("#hav_rcv").html());//调拨数量
			var kcNum=$.trim(item.find("#kc").html());//库存数量
			var corp_id=$.trim(item.find(".corp_id").val());//供应商
			var itemdata={
					"item_id":item_id, 
					"item_cost":item_cost, 
					"corp_id":corp_id, 
					"store_struct_id":store_struct_id,
					"in_store_struct_id":in_store_struct_id,
					"ivt_oper_listing":ivt_oper_listing,
					"oper_qty":oper_qty,
					"kcNum":kcNum
			};
			if (itemId==item_id) {
				vendors.push(JSON.stringify(itemdata));
			}else if(!itemId){
				itemId=item_id;
				vendors.push(JSON.stringify(itemdata));
			}else{
				itemId=item_id;
				item_ids.push(vendors);
				vendors=[];
				vendors.push(JSON.stringify(itemdata));
			}
			if (i==(chekcs.length-1)) {
				item_ids.push(vendors);
			}
		}
		if(window.confirm("相同调拨单号必须全选,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/confirmTransfers.do",{
				"item_ids":"["+item_ids.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("审核成功!",function(){
						$("#allcheck").html("全选");
						tabs.find("#list #check").prop("checked",false);
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
//弃审
$("#return").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#list #check:checked");
	var item_ids=[];
	var itemId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim(item.find("#item_id").html());
			var item_cost=$.trim(item.find("#item_cost").val());//调拨单价
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());//当前仓库
			var in_store_struct_id=$.trim(item.find("#storeId").val());//调入仓库
			var oper_qty=$.trim(item.find("#hav_rcv").html());//调拨数量
			var kcNum=$.trim(item.find("#kc").html());//库存数量
			var corp_id=$.trim(item.find(".corp_id").val());//供应商
			var itemdata={
					"item_id":item_id, 
					"item_cost":item_cost, 
					"corp_id":corp_id, 
					"store_struct_id":store_struct_id,
					"in_store_struct_id":in_store_struct_id,
					"ivt_oper_listing":ivt_oper_listing,
					"oper_qty":oper_qty,
					"kcNum":kcNum
			};
			if (itemId==item_id) {
				vendors.push(JSON.stringify(itemdata));
			}else if(!itemId){
				itemId=item_id;
				vendors.push(JSON.stringify(itemdata));
			}else{
				itemId=item_id;
				item_ids.push(vendors);
				vendors=[];
				vendors.push(JSON.stringify(itemdata));
			}
			if (i==(chekcs.length-1)) {
				item_ids.push(vendors);
			}
		}
		if(window.confirm("相同调拨单号必须全选,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/returnTransfers.do",{
				"item_ids":"["+item_ids.join(",")+"]" 
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("弃审成功!",function(){
						$("#allcheck").html("全选");
						tabs.find("#list #check").prop("checked",false);
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
//删除
$("#delete").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var item_ids=[];
		var itemId="";
		var items=[];
		if(chekcs&&chekcs.length>0){
			for(var i=0;i<chekcs.length;i++){
				var ivt_oper_listing=$.trim($(chekcs[i]).parents(".dataitem").find("#ivt_oper_listing").html());
				var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
				var deleteData={
						"ivt_oper_listing":ivt_oper_listing,
						"item_id":item_id,
				}
				if (itemId==ivt_oper_listing) {
					items.push(JSON.stringify(deleteData));
				}else if(!itemId){
					itemId=ivt_oper_listing;
					items.push(JSON.stringify(deleteData));
				}else{
					itemId=ivt_oper_listing;
					item_ids.push(items);
					items=[];
					items.push(JSON.stringify(deleteData));
				}
				if(i==(chekcs.length-1)){
					item_ids.push(items);
				}
			}
			if(window.confirm("确认删除?")){
				pop_up_box.postWait();
				$.post("../employee/delInventoryRel.do",{
					"item_ids":"["+item_ids.join(",")+"]"
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("删除成功!",function(){
							$("#allcheck").html("全选");
							tabs.find("#list #check").prop("checked",false);
							$(".find:eq(1)").click();
						});
					}else{
						pop_up_box.showMsg(data.msg);
					}
				}); 
			}
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
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
