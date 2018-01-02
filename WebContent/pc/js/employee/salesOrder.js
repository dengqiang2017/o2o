$(function(){
	var customer_id;
	var com_id=$.trim($("#com_id").html());
	$(".form-inline input").val("");
	selectClient.init(function(customerId) {
		tabsIndex=0;
		customer_id=customerId;
		$(".find:eq(0)").click();
		var lxr=$.trim($(".sim-msg li:eq(0)").text());
		var phone=$.trim($(".sim-msg li:eq(1)").text());
		$("#fhr").val(lxr+"-"+phone);
		/////
		$.get("/"+com_id+"/fhdz/"+customer_id+".log",function(data){
			$("#dropdownMenu1").attr("disabled","disabled");
			$(".dropdown-menu").html("");
			if(data&&data.length>0){
				data=$.parseJSON(data);
				for (var i = 0; i < data.length; i++) {
					var n=data[i];
					var li=$("<li><a></a></li>")
					$(".dropdown-menu").append(li);
					li.find("a").html(n.lxr+"-"+n.lxPhone);
					li.find("a").attr("title",n.fhdz);
					li.click(function(){
						$("#fhr").val($(this).find("a").html());
						$("#shdz").val($(this).find("a").attr("title"));
					});
				}
				$("#dropdownMenu1").removeAttr("disabled");
			}
		});
	});
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
	$("#confirm_flag").change(function(){
		$(".find:eq(1)").click();
	});
	//货运司机信息浏览选择表
	$("#drivexz").click(function(){
		  pop_up_box.loadWait(); 
		   $.get("../tree/getDeptTree.do",{"type":"driver"},function(data){
			   pop_up_box.loadWaitClose();
			   $("body").append(data);
			   driver.init(false,function(){
				   var td=$(".modal").find("tr.activeTable").find("td");
				   $("#driverinfo").val($.trim(td.eq(0).text())+"-"+$.trim(td.eq(1).text()));
				   $("#Kar_paizhao").val($.trim(td.eq(2).text()));
			   });
		   });
	});
	$("#jiesuan").click(function(){
		pop_up_box.loadWait(); 
		$.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			settlement.init(function(){
				$("#settlement_type_id").html("");
				$("#settlement_type_name").val("");
				o2otree.selectInfo("settlement_type_id","settlement_type_name",function(id,name){
					$("#settlement_type_id").html(id);
					$("#settlement_type_name").val(name);
				});
			});
		});
	});
	////////提货地点选择begin/////////////////// 
	$("#thdixz").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do",{
			"type":"warehouse"
		},function(data){
			pop_up_box.loadWaitClose();
			if($("#warehouseTreePage").length>0){
				$("#warehouseTreePage").remove();
			}
			$("body").append(data);
			warehouse.init(function(){
				$("#didian").val("");
				$("#store_struct_id").html("");
				o2otree.selectInfo("store_struct_id","didian",function(id,name){
					$("#didian").val(name);
					$("#store_struct_id").html(id);
				});
			});
		});
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-01"); 
	$(".Wdate:eq(0)").val(nowStr);
	$(".Wdate:eq(1)").val(nowStr);
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(2)").val(nowStr);
	/////
	$('body,html').animate({scrollTop:0},500);
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
	//TODO 加载数据
	function loadData(page,count){
		var lia = $(".nav li").index($(".nav .active"));
		var searchKey=$.trim($($(".form")[lia]).find("#searchKey").val());
		var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
		var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
		var confirm_flag=$.trim($("#confirm_flag").val());
		var url;
		if(lia==0){
			url="../product/getOrderProduct.do";//带库存数的
		}else{
			url="../employee/getSalesKdList.do";
		}
		pop_up_box.loadWait();
		$.get(url,{
			"searchKey":searchKey ,
			"page":page,
			"count":count,
			"customer_id" : customer_id,
			"status":"1",
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
		if (customer_id) {
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
	function addItem(data){
		if (data&&data.rows.length>0) {
			var lia = $(".nav li").index($(".nav .active"));
			var tabs= $(".tabs-content:eq("+lia+")");
			var item1 = tabs.find("#item01"); 
			$(".num").unbind("input propertychange blur");
			var lia = $(".nav li").index($(".nav .active"));
			$.each(data.rows,function(i,n){
				var item=$($("#item").html());
				$(".tabs-content").eq(lia).find("#list").append(item);
				loadProInfo(item, n);
				item.find("#ivt_num_detail").val($.trim(n.ivt_num_detail));
				var sd_unit_price=n.sd_unit_price;
				item.find("#store_struct_name").html(n.store_struct_name);    
				item.find("#store_struct_id").val(n.store_struct_id);
				if(lia==0){//报价单
					item.find("#kc").html(common.isnull0(n.use_oq));
					item.find("#discount_rate").val(100);
					item.find("#sd_unit_price").val(n.sd_unit_price);
					///
					item.find("#sd_unit_price_o").parent().remove();
					item.find("#discountRate").parent().remove();
					item.find("#ivt_oper_listing").html($.trim(n.ivt_oper_listing));
					item.find("#kd_name").parent().remove();
					item.find("#customer_name").parent().remove();
					item.find("#datetime").parent().remove();
					item.find("#sd_oq").parent().remove();
					item.find("#zsum_o").parent().remove();
				}else{//销售订单
					item.find("#kc").parent().remove();
					item.find("#discount_rate").parent().remove();
					item.find("#sd_unit_price").parent().remove();
					item.find("#pronum").parent().remove();
					item.find(".zsum").parent().remove();
					///////
					if(n.pack_num){
						if(n.pack_num>1){
							item.find("#zsum_o").html(n.sd_oq);
						}else{
							item.find("#zsum_o").html(n.sd_oq*n.pack_num);
						}
					}else{
						item.find("#zsum_o").html(n.sd_oq);
					}
					item.find("#sd_unit_price_o").html(n.sd_unit_price);
					item.find("#sd_oq").html(common.isnull0(n.sd_oq));
					item.find("#sum_si").html(n.sum_si);
					item.find("#discountRate").html((n.discount_rate)*100);
					item.find("#ivt_oper_listing").html($.trim(n.ivt_oper_listing));
					item.find("#kd_name").html(n.kd_name);
					item.find("#customer_name").html(n.corp_sim_name);
					item.find("#datetime").html(new Date(n.so_consign_date).Format("yyyy-MM-dd hh:mm:ss"));
				}
				if(lia==0){
					productpage.initNumIpt(item);
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
			$("#saveOrder,#return,.form-inline").hide();
			$("#confirm,#delete").show();
		}else{
			$("#saveOrder,.form-inline").show();
			$("#confirm,#delete,#return").hide();
			$("#allcheck").show();
		}
		$(".form").parent().hide();
		$(".form").eq(lia).parent().show();
	});
$(".btn-add").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
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
	var chekcs=tabs.find("#check:checked");
	var item_ids=[];
	var store_structId="";
	var vendors=[];
	var store_struct_id=$.trim($("#store_struct_id").html());
	if(store_struct_id==""){
		pop_up_box.showMsg("请选择发货仓库!");
	}else if (chekcs&&chekcs.length>0) {
		var b=true;
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var num=parseFloat($.trim(item.find("#pronum").val()));
			if(num&&num>0){
			}else{
				pop_up_box.showMsg("销售数量必须大于0!");
				item.find("#pronum").focus().select();
				b=false;break;
			}
			var sd_unit_price=parseFloat($.trim(item.find("#sd_unit_price").val()));
			if(sd_unit_price&&sd_unit_price>0){
			}else{
				pop_up_box.showMsg("请输入销售单价!");
				item.find("#sd_unit_price").focus().select();
				b=false;break;
			}
			var discount_rate=parseFloat($.trim(item.find("#discount_rate").val()));
			if(discount_rate&&discount_rate>0){
			}else{
				pop_up_box.showMsg("请输入折扣!");
				item.find("#discount_rate").focus().select();
				b=false;break;
			}
//			var kcNum=$.trim(item.find("#kc").html());
//			if(num-kcNum>0){
//				pop_up_box.showMsg("销售数量大于库存数量!");
//				b=false;break;
//			}
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
				if (item_id!="") {
					var sd_unit_price=$.trim(item.find("#sd_unit_price").val());
					var pronum=item.find("#pronum").val();
					var discount_rate=$.trim(item.find("#discount_rate").val());
					var sum_si=item.find("#sum_si").html();
					var store_struct_id=$.trim(item.find("#store_struct_id").val());
					var ivt_num_detail=$.trim(item.find("#ivt_num_detail").val());
					var kcNum=$.trim(item.find("#kc").html());
					var item_color=$.trim(item.find(".colorActive").html());
					var item_type=$.trim(item.find(".specActive").html());
					var itemdata={
						"item_id":item_id, 
						"pronum":pronum,
						"sum_si":sum_si,
						"item_color":item_color,
						"item_type":item_type,
						"sd_unit_price":sd_unit_price,
						"discount_rate":discount_rate,
						"store_struct_id":store_struct_id,
						"ivt_num_detail":ivt_num_detail,
						"kcNum":kcNum
					};
					if (store_structId==store_struct_id) {
						vendors.push(JSON.stringify(itemdata));
					}else if(!store_structId){
						store_structId=store_struct_id;
						vendors.push(JSON.stringify(itemdata));
					}else{
						store_structId=store_struct_id;
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
			$("#sure").unbind("click");
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
					$.post("../employee/saveSalesOrder.do",{
						"store_struct_id":$.trim($("#store_struct_id").html()),
						"settlement_type_id":$.trim($("#settlement_type_id").html()),
						"driverinfo":$("#driverinfo").val(),
						"wlfs":$("#wlfs").val(),
						"fhtime":$("#fhtime").val(),
						"fhdz":$("#fhr").val()+"-"+$("#shdz").val(),
						"Kar_paizhao":$("#Kar_paizhao").val(),
						"item_ids":"["+item_ids.join(",")+"]",
						"clerk_id":clerk_id,
						"dept_id":dept_id,
						"c_memo":c_memo,
						"customer_id":customer_id
					},function(data){
						pop_up_box.loadWaitClose();
						$("#sure").unbind("click");
						if (data.success) {
							pop_up_box.showMsg("已生成销售订单,等待审核!",function(){
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
	var ivtOper="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());
			var pronum=$.trim(item.find("#pronum").html());
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
		if(window.confirm("系统自动将同一个销售单号下所有产品一起审核,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/confirmOrder.do",{
				"item_ids":"["+item_ids.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("审核成功!",function(){
						$("#allcheck").html("全选");
						tabs.find("#list #check").prop("checked",false)
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
		var ivtOper="";
		var items=[];
		if(chekcs&&chekcs.length>0){
			for(var i=0;i<chekcs.length;i++){
				var ivt_oper_listing=$.trim($(chekcs[i]).parents(".dataitem").find("#ivt_oper_listing").html());
				var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
				var deleteData={
						"ivt_oper_listing":ivt_oper_listing,
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
//弃审
$("#return").click(function(){
	var lia = $(".nav li").index($(".nav .active"));
	var tabs= $(".tabs-content:eq("+lia+")");
	var chekcs=tabs.find("#list #check:checked");
	var item_ids=[];
	var ivtOper="";
	var vendors=[];
	if (chekcs&&chekcs.length>0) {
		for (var i = 0; i < chekcs.length; i++) {
			var item=$(chekcs[i]).parents(".dataitem");
			var item_id=$.trim($(chekcs[i]).parents(".dataitem").find("#item_id").html());
			var ivt_oper_listing=$.trim(item.find("#ivt_oper_listing").html());
			var store_struct_id=$.trim(item.find("#store_struct_id").val());
			var pronum=$.trim(item.find("#pronum").html());
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
		if(window.confirm("系统自动将同一个销售单号下所有产品一起弃审,请确认?")){
			pop_up_box.postWait();
			$.post("../employee/returnConfirm.do",{
				"item_ids":"["+item_ids.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("弃审成功!",function(){
						$("#allcheck").html("全选");
						tabs.find("#list #check").prop("checked",false)
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
