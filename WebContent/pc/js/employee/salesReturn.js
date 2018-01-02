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
///////
var now = new Date();
var nowStr = now.Format("yyyy-MM-01"); 
$(".Wdate:eq(0)").val(nowStr);
$(".Wdate:eq(2)").val(nowStr);
var nowStr = now.Format("yyyy-MM-dd"); 
$(".Wdate:eq(1)").val(nowStr);
$(".Wdate:eq(3)").val(nowStr);
$('body,html').animate({scrollTop:0},500); 
/////
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
//TODO 加载数据
function loadData(page,count){
	var lia = $(".nav li").index($(".nav .active"));
	var searchKey=$.trim($($(".form")[lia]).find("#searchKey").val());
	var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
	var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
	var confirm_flag=$.trim($("#confirm_flag").val());
	var url;
	if(lia==0){
		confirm_flag=2;
		url="../employee/getSalesKdList.do";
	}else{
		url="../employee/getSalesReturnList.do";
	}
	pop_up_box.loadWait();
	$.get(url,{
		"searchKey":searchKey ,
		"page":page,
		"count":count,
		"beginDate":beginDate,
		"endDate":endDate,
		"confirm_flag":confirm_flag
		},function(data){
	pop_up_box.loadWaitClose();
	addItem(data);
	 if (lia==0) {
		productPage.totalPage = data.totalPage;
		productPage.count = data.totalRecord;
	}else if(lia==2){
		orderPage.totalPage = data.totalPage;
		orderPage.count = data.totalRecord;
	}
});
}
$(".find").unbind("click");
$(".find").click(function() {
		var lia = $(".nav li").index($(".nav .active"));
		var n=$(".find").index(this);
		pop_up_box.loadWait();
		$(".tabs-content").eq(lia).find("#list").html("");
		if (lia==0) {
			orderPage.page=0;
		}else{
			productPage.page=0;
		}
		loadData(0,0);
});
$("#allcheck").prop("checked",false);
$("#allcheck").click(function() {
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var b=$(this).prop("checked");
	tabs.find("#list #check").prop("checked",b);
});
function addItem(data){
	if (data&&data.rows.length>0) {
		var lia = $(".nav li").index($(".nav .active"));
		$.each(data.rows,function(i,n){
			var item=$($("#item").html());
			$(".tabs-content").eq(lia).find("#list").append(item);
			loadProInfo(item, n);
			
			if(lia==0){
				item.find("#sd_oq_t").parent().remove();
				item.find("#kd_name").parent().remove();
				item.find("#sd_oq").html(n.sd_oq);    
			}else{
				item.find("#pronum").parent().remove();
				item.find("#discount_rate").parent().remove();
				item.find("#sd_oq").parent().remove();
				item.find("#sd_oq_t").html(n.sd_oq);    
				item.find("#kd_name").html(n.kd_name);    
			}
			
			item.find("#ivt_num_detail").val($.trim(n.ivt_num_detail));
			var sd_unit_price=n.sd_unit_price;
			item.find("#store_struct_name").html(n.store_struct_name);    
			item.find("#store_struct_id").val(n.store_struct_id);    
			item.find("#sd_unit_price").html(n.sd_unit_price);    
			item.find("#discount_rate").html((n.discount_rate)*100);    
			item.find("#sum_si").html(n.sum_si);
			if(!n.sd_oq){
				item.find("#kc").html(0);  
			}else{
				item.find("#kc").html(n.sd_oq);  
			}
			item.find("#datetime").html(new Date(n.so_consign_date).Format("yyyy-MM-dd hh:mm:ss"));
			item.find("#customer_name").html(n.corp_sim_name);
			item.find("#customer_id").val(n.customer_id);
			if(lia==0){
				item.find("#sd_oq").html(n.sd_oq);
				item.find("#xsdh").show();
				item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
				item.find("#thdh,#kdr").hide();
				item.find("#pronum").bind("input propertychange blur",function(){
					var item=$(this).parents(".dataitem");
					var num=$.trim($(this).val());
					if(num==""){
						num=0;
					}else{
						num=parseFloat(num);
					}
					if (num<=0) {
						item.find("#check").prop("checked",false);
					}else{
						item.find("#check").prop("checked",true);
					}
				});
			}else{
				item.find("#pronum").html(n.sd_oq);
				item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
				item.find("#kd_name").html(n.kd_name);
				item.find("#st_hw_no").val(n.st_hw_no);
			}
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
$(".nav li").click(function(){
	var lia = $(".nav li").index(this);
	var tabs= $(".tabs-content:eq("+lia+")");
	var item=$.trim(tabs.find("#list").html());
	if (item=="") {
		$(".find:eq("+lia+")").click();
	}
	if(lia==1){
		$("#saveOrder,#return").hide();
		$("#confirm,#delete").show();
	}else{
		$("#saveOrder").show();
		$("#confirm,#delete,#return").hide();
		$("#allcheck").show();
	}
	$(".form").parent().hide();
	$(".form").eq(lia).parent().show();
});
$(".btn-add").click(function(){
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
		loadData(page, count);
	}
});
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
$("#saveOrder").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#list").find("#check:checked");
	var item_ids=[];
	var ivtOper="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		var b=true;
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var pronum=item.find("#pronum").val();//退货数量
			var sd_oq=$.trim(item.find("#sd_oq").html());//销售数量
			if(pronum>sd_oq){
				pop_up_box.showMsg("退货数量超出销售数量!");
				item.find("#pronum").focus().select();
				b=false;break;
			}
			if(pronum==""||pronum=="0"){
				pop_up_box.showMsg("请输入退货数量!");
				item.find("#pronum").focus().select();
				b=false;break;
			}
			if($.trim(item.find("#item_color").html())!=""){
				var item_color=$.trim(item.find(".colorActive").html());
				if(!item_color){
					pop_up_box.showMsg("请选择颜色!");
					b=false;break;
				}
			}
			if($.trim(item.find("#item_type").html())!=""){
				var item_type=$.trim(item.find(".specActive").html());
				if(!item_type){
					pop_up_box.showMsg("请选择规格!");
					b=false;break;
				}
			}
		}
		if(b){
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents(".dataitem");
				var item_id=$.trim(item.find("#item_id").html());
				var sd_unit_price=$.trim(item.find("#sd_unit_price").html());
				var pronum=item.find("#pronum").val();//退货数量
				var discount_rate=$.trim(item.find("#discount_rate").html());
				var sum_si=item.find("#sum_si").html();
				var store_struct_id=$.trim(item.find("#store_struct_id").val());
				var customer_id=$.trim(item.find("#customer_id").val());
				var ivt_oper_listing=$.trim(item.find("#ivtOperListing").html());
				var kcNum=$.trim(item.find("#kc").html());
				var sd_oq=$.trim(item.find("#sd_oq").html());//销售数量
				var item_color=$.trim(item.find(".colorActive").html());
				var item_type=$.trim(item.find(".specActive").html());
				var itemdata={
					"item_id":item_id, 
					"customer_id":customer_id, 
					"pronum":pronum,
					"item_color":item_color,
					"item_type":item_type,
					"sum_si":sum_si,
					"sd_unit_price":sd_unit_price,
					"discount_rate":discount_rate,
					"store_struct_id":store_struct_id,
					"ivt_oper_listing":ivt_oper_listing,
					"kcNum":kcNum,
					"sd_oq":sd_oq
				};
				if (ivtOper==ivt_oper_listing) {
					vendors.push(JSON.stringify(itemdata));
				}else if(!ivtOper){
					ivtOper=ivt_oper_listing;
					vendors.push(JSON.stringify(itemdata));
				}else{
					ivtOper=ivt_oper_listing;
					item_ids.push(vendors);
					vendors=[];
					vendors.push(JSON.stringify(itemdata));
				}
				if (i==(chekcs.length-1)) {
					item_ids.push(vendors);
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
					$.post("../employee/saveSalesReturn.do",{
						"item_ids":"["+item_ids.join(",")+"]",
						"clerk_id":clerk_id,
						"dept_id":dept_id,
						"c_memo":c_memo
					},function(data){
						pop_up_box.loadWaitClose();
						$("#sure").unbind("click");
						if (data.success) {
							pop_up_box.showMsg("已生成销售退货单,等待审核!",function(){
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
	var chekcs=tabs.find("#list").find("#check:checked");
	var item_ids=[];
	var ivtOper="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());
			var pronum=$.trim(item.find("#sd_oq_t").html());
			var kcNum=$.trim(item.find("#kc").html());
			if(kcNum==""){
				kcNum=0;
			}
			var itemdata={
					"item_id":item_id, 
					"store_struct_id":store_struct_id,
					"ivt_oper_listing":ivt_oper_listing,
					"pronum":pronum,
					"kcNum":kcNum
			};
			if (ivtOper==ivt_oper_listing) {
				vendors.push(JSON.stringify(itemdata));
			}else if(!ivtOper){
				ivtOper=ivt_oper_listing;
				vendors.push(JSON.stringify(itemdata));
			}else{
				ivtOper=ivt_oper_listing;
				item_ids.push(vendors);
				vendors=[];
				vendors.push(JSON.stringify(itemdata));
			}
			if (i==(chekcs.length-1)) {
				item_ids.push(vendors);
			}
		}
		
		if(window.confirm("系统自动将同一个销售退货单号下所有产品一起审核,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/confirmOrder.do",{
				"item_ids":"["+item_ids.join(",")+"]",
				"status":"退货"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("审核成功!",function(){
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
		var chekcs=tabs.find("#list").find("#check:checked");
		var item_ids=[];
		var ivtOper="";
		var items=[];
		if(chekcs&&chekcs.length>0){
			for(var i=0;i<chekcs.length;i++){
				var ivt_oper_listing=$.trim($(chekcs[i]).parents(".dataitem").find("#ivt_oper_listing").html());
				var st_hw_no=$.trim($(chekcs[i]).parents(".dataitem").find("#st_hw_no").val());
				var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
				var store_struct_id=$.trim($(chekcs[i]).parents(".dataitem").find("#store_struct_id").val());
				var pronum=$.trim($(chekcs[i]).parents(".dataitem").find("#sd_oq_t").html());
				var deleteData={
						"ivt_oper_listing":ivt_oper_listing,
						"st_hw_no":st_hw_no,
						"store_struct_id":store_struct_id,
						"pronum":pronum,
						"item_id":item_id,
				}
				if (ivtOper==ivt_oper_listing) {
					items.push(JSON.stringify(deleteData));
				}else if(!ivtOper){
					ivtOper=ivt_oper_listing;
					items.push(JSON.stringify(deleteData));
				}else{
					ivtOper=ivt_oper_listing;
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
				$.post("../employee/delSalesOrder.do",{
					"item_ids":"["+item_ids.join(",")+"]",
					"client":"xsth"
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
$("#return").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#list").find("#check:checked");
	var item_ids=[];
	var vendorId="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());
			var pronum=$.trim(item.find("#sd_oq_t").html());
			var kcNum=$.trim(item.find("#kc").html());
			if(kcNum==""){
				kcNum=0;
			}
			if(pronum==""){
				pronum=1;
			}
			var itemdata={
					"item_id":item_id, 
					"store_struct_id":store_struct_id,
					"ivt_oper_listing":ivt_oper_listing,
					"pronum":pronum,
					"kcNum":kcNum
			};
			if (vendorId==ivt_oper_listing) {
				vendors.push(JSON.stringify(itemdata));
			}else if(!vendorId){
				vendorId=ivt_oper_listing;
				vendors.push(JSON.stringify(itemdata));
			}else{
				vendorId=ivt_oper_listing;
				item_ids.push(vendors);
				vendors=[];
				vendors.push(JSON.stringify(itemdata));
			}
			if (i==(chekcs.length-1)) {
				item_ids.push(vendors);
			}
		}
		if(window.confirm("系统自动将同一个销售退货单号下所有产品一起弃审,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/returnConfirm.do",{
				"item_ids":"["+item_ids.join(",")+"]", 
				"status":"退货"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("弃审成功!",function(){
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
