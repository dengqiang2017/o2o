$(function(){
	//给经办人经办部门设置默认值
	$.get("setDefaultByClerkId.do",function(data){
		$.each(data,function(i,n){
			$("#clerk_name").html(n.clerk_name);
			$("#clerkId").val(n.clerk_id);
			$("#dept_name").html(n.dept_name);
			$("#deptId").val(n.dept_id);
		});
	});
	var rs=$(".row label");
	for (var i = 0; i < rs.length; i++) {
		$(rs[i]).html($(rs[i]).html()+"：");
	}
	$(".qx,.close").click(function(){
		$("#info").hide();
		$("#sure").unbind("click");
	});
	//页面产品展示
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-01"); 
	$(".form .Wdate:eq(0)").val(nowStr);
	$(".form .Wdate:eq(2)").val(nowStr);
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".form .Wdate:eq(1)").val(nowStr);
	$(".form .Wdate:eq(3)").val(nowStr);
	$('body,html').animate({scrollTop:0},500);
	///////////////////
	var productPage={
			page:0,
			count:0,
			totalPage:0
	};
	var orderPage={
			page:0,
			count:0,
			totalPage:0
	};
	var rukuPage={
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
		if(lia==0){
			$("#allcheck,#saveOrder").show();
			$("#saveAccount,#delete,#return").hide();
			$(".product").show();
			$(".rukudan").hide();
		}else if(lia==1){
			$("#allcheck,#saveOrder").show();
			$("#saveAccount,#delete,#return").hide();
			$(".product").show();
			$(".rukudan").hide();
		}else{
			$("#delete").show();
			$("#saveOrder,#return,#saveAccount").hide();
			$(".product").hide();
			$(".rukudan").show();
		}
	});
	//点击加载更多
	productpage.btnAddClick(function(page,count,totalPage){
		if (lia==0) {
			productPage.page+=1;
			page=productPage.page;
			count=productPage.count;
			totalPage=productPage.totalPage;
		}else if(lia==1){
			orderPage.page+=1;
			page=orderPage.page;
			count=orderPage.count;
			totalPage=orderPage.totalPage;
		}else{
			rukuPage.page+=1;
			page=rukuPage.page;
			count=rukuPage.count;
			totalPage=rukuPage.totalPage;
		}
		if (page<=totalPage) {
			loadData(page, count);
		}
	});
	function loadData(page,count){
		var lia = $(".nav li").index($(".nav .active"));
		var url;
		if(lia==0){
			url="../product/getProductWarePage.do?type=采购";			
		}else if(lia==1){//根据采购订单入库
			url="vendorOrderList.do";
		}else{
			url="purchasingCheckList.do";
		}
		var searchKey=$($(".form")[lia]).find("#searchKey").val();
		var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
		var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
		var comfirm_flag=$.trim($($(".form")[lia]).find("#comfirm_flag").val());
		var m_flag=$.trim($($(".form")[lia]).find("#m_flag").val());
		pop_up_box.loadWait();
		$.get(url,{
			"searchKey":searchKey ,
			"type_id":common.getVal("#findForm #type_id"),
			"quality_class":common.getVal("#findForm #quality_class"),
			"item_style":common.getVal("#findForm #item_style"),
			"class_card":common.getVal("#findForm #class_card"),
			"item_spec":common.getVal("#findForm #item_spec"),
			"item_struct":$.trim($("#item_struct").val()),
			"item_type":$.trim($("#item_type").val()),
			"item_color":$.trim($("#item_color").val()),
			"beginDate":beginDate,
			"endDate":endDate,
			"comfirm_flag":comfirm_flag,
			"m_flag":m_flag,
			"page":page,
			"count":count
			},function(data){
		pop_up_box.loadWaitClose();
		addItem(data);
		 if (lia==0) {
			productPage.totalPage = data.totalPage;
			productPage.count = data.totalRecord;
		}else if(lia==1){
			orderPage.totalPage = data.totalPage;
			orderPage.count = data.totalRecord;
		}else{
			rukuPage.totalPage = data.totalPage;
			rukuPage.count = data.totalRecord;
		}
	});
	}
	//////////
	treeGetPrex="../manager/";
	function addItem(data){
		if(data&&data.rows.length>0){
			var lia = $(".nav li").index($(".nav .active"));
			$(".num").unbind("input propertychange blur");
			$.each(data.rows,function(i,n){
				var item=$($("#item").html());
				$(".tabs-content:eq("+lia+")").find("#list").append(item); 
				loadProInfo(item, n);
				item.find("#seeds_id").val(n.seeds_id);
				//供应商
				item.find("#vendor_name").html(n.corp_name);
				item.find("#vendor_id").val(n.vendor_id);
				item.find("#item_cost").val(n.item_cost);
				item.find("#store_struct_name").html(n.store_struct_name);
				item.find("#storestructId").val(n.store_struct_id);
				if(lia!=2){
					if(n.discount_rate){
						item.find("#discount_rate").val(n.discount_rate);
					}else{
						item.find("#discount_rate").val(100);
					}
					item.find(".gys").bind("click",function(){
						var div=$(this).parents(".dataitem");
						pop_up_box.loadWait(); 
						$.get("../manager/getDeptTree.do", {
							"type" : "vendor"
						}, function(data){
							pop_up_box.loadWaitClose();
							$("body").append(data);
							vendor.init(function(){
									div.find("#vendor_id").val(treeSelectId);
									div.find("#vendor_name").html(treeSelectName);
							});
						});
					});
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
								div.find("#store_struct_name").html(treeSelectName);
								div.find("#storestructId").val(treeSelectId);
							});
						});
					});
					item.find("#pronum").bind("input propertychange blur",function(){
						var item=$(this).parents(".dataitem");
						var discount_rate=$.trim(parseFloat(item.find("#discount_rate").val()));
						var item_cost=parseFloat(item.find("#item_cost").val());
						var val=$.trim($(this).val());
						var num=parseFloat(val);
						var rkAmount=parseFloat(item.find("#rkAmount").html());
						var sd_oq=parseFloat(item.find("#sd_oq").html());
						if(num+rkAmount>sd_oq){
							pop_up_box.showMsg("已超出采购订单数量!");
						}
						if (val==""||val=="0") {
							num=0;
							item.find("#check").prop("checked",false);
						}else{
							item.find("#check").prop("checked",true);
						}
						if(discount_rate=="0"||discount_rate==""){
							 item.find("#st_sum").html(numformat2(num*item_cost));
						}else{
							item.find("#st_sum").html(numformat2(num*item_cost*discount_rate/100));
						}
					});
					item.find("#discount_rate").bind("input propertychange blur",function(){
						var item=$(this).parents(".dataitem");
						var num=$.trim(parseFloat(item.find("#pronum").val()));
						var item_cost=parseFloat(item.find("#item_cost").val());
						var val=$.trim($(this).val());
						var discount_rate=parseFloat(val);
						if (discount_rate==""||discount_rate=="0") {
							discount_rate=0;
							item.find("#check").prop("checked",false);
							item.find("#st_sum").html(numformat2(num*item_cost));
						}else{
							item.find("#check").prop("checked",true);
							item.find("#st_sum").html(numformat2(num*item_cost*discount_rate)/100);
						}
					});
					item.find("#item_cost").bind("input propertychange blur", function(){
						var item=$(this).parents(".dataitem");
						var num=$.trim(parseFloat(item.find("#pronum").val()));
						var discount_rate=$.trim(parseFloat(item.find("#discount_rate").val()));
						var val=$.trim($(this).val());
						var item_cost=parseFloat(val);
						if (item_cost==""||item_cost=="0") {
							item_cost=0;
							item.find("#check").prop("checked",false);
						}else{
							item.find("#check").prop("checked",true);
						}
						item.find("#st_sum").html(numformat2(num*item_cost*discount_rate)/100);
					});
					
					item.find("#price").parent().remove();
					item.find("#rep_qty").parent().remove();
					item.find("#zk").parent().remove();
					item.find("#corp_name").parent().remove();
					item.find("#movtel").parent().remove();
					item.find("#store_struct_name_r").parent().remove();
					item.find("#storeDate").parent().remove();
					item.find("#rcv_auto_no").parent().remove();
					item.find("#c_memo").parent().remove();
					item.find("#kd_name").parent().remove();
					item.find("#use_oq").parent().remove();
					if(lia==0){
						item.find("#cgsl").parent().remove();
						item.find("#cgno").parent().remove();
						item.find("#m_flag").parent().remove();
					}else{
						item.find("#cgsl").html(n.hav_rcv);
						item.find("#pronum").val(n.hav_rcv);
						item.find("#cgno").html(n.st_auto_no);
						item.find("#item_cost").val(n.price);//采购单价
						item.find("#st_sum").html(n.price*n.hav_rcv);
						item.find("#m_flag").html($("#m_flag option[value='"+n.m_flag+"']").text());
					}
				}else{
					item.find("#cgno").html(n.st_auto_no);
					item.find("#gysselect").remove();
					item.find("#storeselect").remove();
					item.find("#item_cost").parent().remove();
					item.find("#pronum").parent().remove();
					item.find("#discount_rate").parent().remove();
					item.find("#m_flag").parent().remove();
					
					item.find("#storeDate").val(n.store_date);
					item.find("#c_memo").html(n.c_memoMain);
					
					item.find("#movtel").html(n.movtel);
					if(!common.isPC()){
						item.find("#movtel").click(function(){
							window.location.href="tel:"+$(this).html();
						});
					}
					item.find("#corp_name").html(n.corp_name);
					item.find("#vendor_id").val(n.vendor_id);
					if(n.st_sum){
						item.find("#st_sum").html(n.st_sum);
					}else{
						item.find("#st_sum").html(numformat2(n.price*n.rep_qty));
					}
					item.find("#stock_type").val(n.stock_type);
					item.find("#kd_name").html(n.kd_name);
					var now = new Date(n.finacial_d);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
					if(n.discount_rate){
						item.find("#zk").html(n.discount_rate);
					}else{
						item.find("#zk").html(100);
					}
					item.find("#store_struct_name_r").html(n.store_struct_name);//赋值
					item.find("#item_spec").html(n.lot_number);
					item.find("#rhStore").val(n.store_struct_id);
					item.find("#price").html(n.price);
					var now = new Date(n.at_term_datetime);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
					item.find("#storeDate").html(nowStr);
					item.find("#stautono").val(n.st_auto_no);
					item.find("#rcv_auto_no").html(n.rcv_auto_no);
					item.find("#rep_qty").html(n.rep_qty);
					//库存数量
					if(!n.accn_ivt){
						item.find("#use_oq").html(0);
					}else{
						item.find("#use_oq").html(n.accn_ivt);
					}
				}
				if(n.use_oq){
					item.find("#use_oq").html(n.use_oq);
				}
			});
			if(lia==2){
				if($("#comfirm_flag").val()=="Y"){
					$("#saveAccount,#delete").hide();//审核删除隐藏
					$("#return").show();
				}else{
					$("#saveAccount,#delete").show();
					$("#return").hide();
				}
			}
			common.initNumInput();
			productpage.clearSelect();
		}
	}
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
	function saveAccount(comfirm_flag,name){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		if(chekcs&&chekcs.length>0){
			var rcv_auto_no="";
			for (var i = 0; i < chekcs.length; i++) {
				rcv_auto_no=rcv_auto_no+","+$.trim($(chekcs[i]).parents(".dataitem").find("#rcv_auto_no").html());
			}
			if(window.confirm("系统自动将同一个采购入库单号下所有产品一起"+name+",请确认?")){
				pop_up_box.postWait();
				$.post("../manager/saveAccount.do",{
					"comfirm_flag":comfirm_flag,
					"rcv_auto_no":rcv_auto_no
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.toast(name+"成功!",2000);
						$("#allcheck").html("全选");
						tabs.find("#list #check").prop("checked",false);
						$(".find:eq(1)").click();
					}else{
						pop_up_box.showMsg(data.msg);
					}
				}); 
			}
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	}
	$("#saveAccount").click(function(){
		saveAccount("Y","审核");
	});
	$("#return").click(function(){
		saveAccount("N","弃审");
	});
	$("#delete").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var checkIn=[];
		var rcvNo="";
		var stores=[];
		if(chekcs&&chekcs.length>0){
			for(var i=0;i<chekcs.length;i++){
				var item=$(chekcs[i]).parents(".dataitem");
				var rcv_auto_no=$.trim(item.find("#rcv_auto_no").html());
				var st_auto_no=$.trim(item.find("#stautono").val());
				var item_id=$.trim(item.find("#item_id").html());
				var client=$.trim($("select:eq(0)").val());
				var deleteData={
						"rcv_auto_no":rcv_auto_no,
						"item_id":item_id,
						"client":client,
						"st_auto_no":st_auto_no
				}
				if (rcvNo==rcv_auto_no) {
					stores.push(JSON.stringify(deleteData));
				}else if(!rcvNo){
					rcvNo=rcv_auto_no;
					stores.push(JSON.stringify(deleteData));
				}else{
					rcvNo=rcv_auto_no;
					checkIn.push(stores);
					stores=[];
					stores.push(JSON.stringify(deleteData));
				}
				if(i==(chekcs.length-1)){
					checkIn.push(stores);
				}
			}
			if(window.confirm("确认删除?")){
				pop_up_box.postWait();
				$.post("../manager/delPurchasingCheck.do",{
					"checkIn":checkIn,
					"len":checkIn.length
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
	//生成入库单
	$("#saveOrder").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var item_ids=[];
		var vendorId="";
		var vendors=[];
		if(lia!=2){
			if (chekcs&&chekcs.length>0) {
				var b=true;//开关
				//对必填数据进行控制
				for (var i = 0; i < chekcs.length; i++) {
					var item=$(chekcs[i]).parents(".dataitem");
					 var store_struct_id=$.trim(item.find("#storestructId").val());
					 var rep_qty=$.trim(item.find("#pronum").val());
					 var vendor_id=$.trim(item.find("#vendor_id").val());
					if(vendor_id==""){
						pop_up_box.showMsg("请选择供应商!");
						b=false;break;
					}
					if(store_struct_id==""){
						pop_up_box.showMsg("请选择入货仓库!");
						b=false;break;
					}
					if(rep_qty==""||rep_qty==0){
						pop_up_box.showMsg("入库数量必须大于1!");
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
						//获取数据
						var item=$(chekcs[i]).parents(".dataitem");
						var item_id=$.trim(item.find("#item_id").html());//产品ID
						var item_type=$.trim(item.find("#item_type").html());//型号
						var lot_number=$.trim(item.find("#item_spec").html());//规格
						var vendor_id=$.trim(item.find("#vendor_id").val());//供应商ID
						var vendor_name=$.trim(item.find("#vendor_name").html());//供应商名字
						var store_id=$.trim(item.find("#storestructId").val());//入货仓库ID
						var item_cost=$.trim(item.find("#item_cost").val());//产品单价
						var rep_qty=$.trim(item.find("#pronum").val());//入库数量
						var discount_rate=$.trim(item.find("#discount_rate").val());//折扣
						var st_sum=$.trim(item.find("#st_sum").html());//入库金额
						var store_struct_id=$.trim(item.find("#storestructId").val());//入货仓库ID
						var store_struct_name=$.trim(item.find("#store_struct_name").html());//入货仓库名字
						var item_color=$.trim(item.find(".colorActive").html());
						var item_type=$.trim(item.find(".specActive").html());
						var cgsl=$.trim(item.find("#cgsl").html());
						var st_auto_no=$.trim(item.find("#cgno").html());
						var itemdata={
							"item_id":item_id, 
							"item_type":item_type, 
							"item_color":item_color, 
							"item_type":item_type, 
							"price":item_cost, 
							"rep_qty":rep_qty,
							"st_sum":st_sum,
							"store_struct_id":store_struct_id,
							"store_struct_name":store_struct_name,
							"discount_rate":discount_rate,
							"lot_number":lot_number,
							"vendor_id":vendor_id,
							"vendor_name":vendor_name,
							"cgsl":cgsl,
							"st_auto_no":st_auto_no,
							"store_struct_id":store_id
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
					$("#info").show();
					$("#sure").click(function(){
						var clerk_id=$.trim($(this).parent().parent().find("#clerkId").val());//经办人ID
						var dept_id=$.trim($(this).parent().parent().find("#deptId").val());//经办部门ID
						var c_memo=$.trim($(this).parent().parent().find("#c_memo").val());//备注
						pop_up_box.postWait();
						$("#sure").attr("disabled", "disabled");
						$.post("../manager/addPurchasingCheck.do",{
							"item_ids":"["+item_ids.join(",")+"]",
							"clerk_id":clerk_id,
							"dept_id":dept_id,
							"c_memo":c_memo
						},function(data){
							pop_up_box.loadWaitClose();
							$("#sure").unbind("click");
							if (data.success) {
								$("#info").hide();
								pop_up_box.showMsg("已生成采购入库单,等待审核!",function(){
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
		}
	});
	//产品默认仓库
	$(".mrstore").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "warehouse"
		}, function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			warehouse.init(function(){
				//将值赋给所有产品的仓库
				tabs.find(".dataitem").find("#store_struct_name").html(treeSelectName);
				tabs.find(".dataitem").find("#storestructId").val(treeSelectId);
			});
		});
	});
	$(".mrcorp").click(function(){
		pop_up_box.loadWait();
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		$.get("../manager/getDeptTree.do", {
			"type" : "vendor"
		}, function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			vendor.init(function(){
				tabs.find(".dataitem").find("#vendor_id").val(treeSelectId);
				tabs.find(".dataitem").find("#vendor_name").html(treeSelectName);
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
})