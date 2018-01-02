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
						var item_cost=n.item_cost;
						if(n.price){
							item.find("#item_cost").val(n.price);
						}else{
							item.find("#item_cost").val(n.item_cost);
						}
						item.find("#seeds_id").val(n.seeds_id);
						item.find("#mps_id").val(n.mps_id);
						item.find("#item_unit").html(n.item_unit);
						item.find(".item_unit").html(n.item_unit);
						item.find("#pack_unit").html(n.pack_unit);
						item.find("#casing_unit").html(n.casing_unit);
						item.find("#item_name").html(n.item_name);
						item.find("#item_spec").html(n.item_spec);
						item.find("#item_type").html(n.item_type);
						item.find("#item_color").html(n.item_color);
						item.find("#class_card").html(n.class_card);
						item.find("#quality_class").html(n.quality_class);
						item.find("#price_type").html(n.price_type);    
						item.find("#corp_sim_name").html(n.corp_name);
						item.find("#weixinID").html(n.weixinID);    
						item.find("#movtel").html(n.movtel);    
						if(lia==0){
							item.find("#ddzk").show();
							item.find("#discount_rate").val(100);
							item.find("#cgzk").hide();
							
							item.find("#pronum").bind("input propertychange blur",function(){
								var item_cost=$(this).parents(".dataitem").find("#item_cost").val();
								var num=$.trim($(this).val());
								var discount_rate=$.trim($(this).parents(".dataitem").find("#discount_rate").val());
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
							item.find("#item_cost").bind("input propertychange blur", function(){
								var item_cost=parseFloat(this.value);
								var num=$(this).parents(".dataitem").find("#pronum").val();
								var discount_rate=$.trim($(this).parents(".dataitem").find("#discount_rate").val());
								var sumsi=numformat2(item_cost*num*discount_rate/100);
								if(item_cost==""||item_cost=="0"){
									item_cost=0;
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
							item.find("#discount_rate").bind("input propertychange blur", function(){
								var item_cost=$(this).parents(".dataitem").find("#item_cost").val();
								var num=parseFloat($(this).parents(".dataitem").find("#pronum").val());
								var discount_rate=$.trim(this.value);
								var sumsi=numformat2(item_cost*num*discount_rate/100);
								if(discount_rate==""||discount_rate=="0"){
									discount_rate=0;
									$(this).parents(".dataitem").find(".pro-check").removeClass("pro-checked");
									$(this).parents(".dataitem").find("#sum_si").html((numformat2(num*item_cost)));
								}else{
									$(this).parents(".dataitem").find(".pro-check").addClass("pro-checked");
									$(this).parents(".dataitem").find("#sum_si").html(sumsi);
								}
							});
							initNumInput();
							$(".changGys").unbind("click");
							$(".changGys").bind("click",function(){
								  var lia = $(".nav li").index($(".nav .active"));
								  pop_up_box.loadWait(); 
								  var div=$(this).parents(".dataitem");
								  var t=$(this);
								  $.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
									  pop_up_box.loadWaitClose();
									  $("body").append(data);
									  vendor.init(function(){
										  div.find("#vendor_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
										  div.find("#corp_sim_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
										  div.find("#movtel").html($(".modal").find("tr.activeTable").find("td:eq(1)").text());
										  div.find("#weixinID").html($(".modal").find("tr.activeTable").find("td:eq(2)").text());
										  div.find(".pro-check").addClass("pro-checked");
									  });
								  });
							});
							productpage.detailClick(true,function(t){
								$(t).parents(".dataitem").find("input[data-number]:eq(0)").focus().select();
							},0);
							$(".dataitem").find("img").unbind("click");
						}else{
							item.find("#ddzk").hide();
							item.find("#discountRate").html(n.discount_rate);
							item.find("#cgzk").show();
							item.find("#kdr,#cMemo").show();
							item.find("#kd_name").html(n.clerk_name);
							item.find("#c_memo").html(n.c_memo);
							
							item.find("#dhsl").hide();
							item.find(".changGys").hide();
							item.find("#ddCost").hide();
							item.find("#cgCost").show();
							item.find("#item_cost").html(n.price);
							item.find("#dhDate").show();
							var now = new Date(n.at_term_datetime);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
							item.find("#cgDate").html(nowStr);
							item.find("#dhNo").show();
							item.find("#st_auto_no").html(n.st_auto_no);
							item.find("#vendor_id").val(n.vendor_id); 
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
						if (n.cha) {
							item.find("#pronum").val(n.cha);
							item.find("#sum_si").html(numformat2(n.cha*item_cost*n.discount_rate/100));
						}else{
							item.find("#hav_rcv").html(n.hav_rcv);
							item.find("#sum_si").html(numformat2(n.hav_rcv*n.price*n.discount_rate/100));
						}
					});
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
		$("#delOrder").show();
	}else{
		$("#saveOrder").show();
		$("#delOrder").hide();
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
		url="../product/proPageList.do?client=2";
	}else{
		url="getProcurementList.do?client=1";// vendorOrderList//getProcurementList
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
	$.get(url,{
		"searchKey":$.trim(searchKey),
		"beginDate":beginDate,
		"endDate":endDate,
		"page":page,
		"count":count
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
$("#delOrder").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#item01").find(".pro-checked");
	var item_ids=[];
	var vendorId="";
	var vendors=[];
	if(chekcs&&chekcs.length>0){
		for(var i=0;i<chekcs.length;i++){
			var st_auto_no=$.trim($(chekcs[i]).parents(".dataitem").find("#st_auto_no").html());
			var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").val());
			var itemdata={
					"st_auto_no":st_auto_no,
					"item_id":item_id
			}
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
		if(window.confirm("确认删除订单?")){
			pop_up_box.postWait();
			$.post("../manager/delOrderByNo.do",{
				"item_ids":"["+item_ids.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("删除成功!",function(){
						$("#allcheck").html("全选");
						tabs.find(".pro-check").removeClass("pro-checked");
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
//////////////////////////
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
			var vendor_id=$.trim($(chekcs[i]).parents(".dataitem").find("#vendor_id").val());
			if(vendor_id==""){
				pop_up_box.showMsg("请选择供应商!");
				b=false;
			}
		}
		if(b){
			for (var i = 0; i < chekcs.length; i++) {
				var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").val());
				if (item_id!="") {
					var item=$(chekcs[i]).parents(".dataitem");
					var item_cost=$.trim(item.find("#item_cost").val());//产品成本价
					var pronum=item.find("#pronum").val();
					if (pronum==""||pronum=="0") {
						pronum="1";
						alert("请输入订单数量!");
						item.find(".zsum").focus().select();
						return ;
					}
					if(item_cost==""||item_cost=="0"){
						alert("请输入订单单价!");
						item.find("#item_cost").focus().select();
						return ;
					}
					var pack_unit=$.trim(item.find("#pack_unit").html());//换算数量
					var casing_unit=item.find("#casing_unit").html();//包装单位
					var item_unit=item.find(".item_unit").html();//基本单位
					var sum_si=item.find("#sum_si").html();// 
					var movtel=$.trim(item.find("#movtel").html());//供应商手机
					var corp_sim_name=$.trim(item.find("#corp_sim_name").html());//供应商
					var weixinID=$.trim(item.find("#weixinID").html());//供应商微信通讯录账号
					var vendor_id=$.trim(item.find("#vendor_id").val());//供应商
					var discount_rate=$.trim(item.find("#discount_rate").val());//折扣
					var item_type=$.trim(item.find("#item_type").html());
					var itemdata={
						"item_id":item_id, 
						"pronum":pronum,
						"pack_unit":pack_unit,
						"casing_unit":casing_unit,
						"item_unit":item_unit,
						"sum_si":sum_si,
						"item_cost":item_cost,
						"vendor_id":vendor_id,
						"corp_sim_name":corp_sim_name,
						"weixinID":weixinID,
						"movtel":movtel,
						"discount_rate":discount_rate,
						"item_type":item_type
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
				var clerk_id=$.trim($(this).parent().parent().find("#clerkId").val());//经办人ID
				var dept_id=$.trim($(this).parent().parent().find("#deptId").val());//经办部门ID
				var c_memo=$.trim($(this).parent().parent().find("#c_memo").val());//备注
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
				$.post("saveDirectOrder.do",{
					"item_ids":"["+item_ids.join(",")+"]",
					"clerk_id":clerk_id,
					"dept_id":dept_id,
					"c_memo":c_memo
				},function(data){
					pop_up_box.loadWaitClose();
					$("#sure").unbind("click");
					if (data.success) {
						pop_up_box.showMsg("已生成订货单!",function(){
							$("#allcheck").html("全选");
							tabs.find(".pro-check").removeClass("pro-checked");
							$(".find").click();
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
});
