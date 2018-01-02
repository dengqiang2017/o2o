$(function(){
	//给经办人经办部门设置默认值
	$.get("setDefaultByClerkId.do",function(data){
		$.each(data,function(i,n){
			$("#clerk_name").html(n.clerk_name);
			$("#clerkId").val(n.clerk_id);
			$("#dept_name").html(n.dept_name);
			$("#deptId").val(n.dept_id);
		})
	});
	var rs=$(".row label");
	for (var i = 0; i < rs.length; i++) {
		$(rs[i]).html($(rs[i]).html()+"：");
	}
	$(".qx,.close").click(function(){
		$("#info").hide();
		$("#sure").unbind("click");
	});
	$("select").change(function(){
		$(".find:eq(1)").click();
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
	/////////////
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
	//切换时候获取产品和新增验收入库的产品信息
	function loadData(){
		var lia = $(".nav li").index($(".nav .active"));
		var url;
		if(lia==0){
			url="purchasingCheckList.do?status=1";	
		}else{
			url="purchasingReturnList.do";
		}
		var searchKey=$($(".form")[lia]).find("#searchKey").val();
		var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
		var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
		var confirm_flag=$.trim($($(".form")[lia]).find("select:eq(0)").val());
		pop_up_box.loadWait();
		$.get(url,{
			"searchKey":searchKey ,
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
	productpage.initBtnClick(function(lia){
		if (lia==0) {
			productPage.page=0;
		}else{
			orderPage.page=0;
		}
		loadData(0,0);
	});
	//点击加载更多
	$(".btn-add").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var page=0;
		var count=0;
		var totalPage=0;
		if (lia==0) {
			productPage.page+=1;
			page=productPage.page;
			count=productPage.count;
			totalPage=productPage.totalPage;
		}else{
			orderPage.page+=1;
			page=orderPage.page;
			count=orderPage.count;
			totalPage=orderPage.totalPage;
		}
		if (page<=totalPage) {
			loadData(page, count);
		}
	});
	///////////
	treeGetPrex="../manager/";
	function addItem(data){
		if(data&&data.rows.length>0){
			var lia = $(".nav li").index($(".nav .active"));
			$.each(data.rows,function(i,n){
				var item=$($("#item").html());
				$(".tabs-content:eq("+lia+")").find("#list").append(item); 
				loadProInfo(item, n);
				item.find("#seeds_id").val(n.seeds_id);
				item.find("#price").html(n.price);
				item.find("#threp_qty").html(n.rep_qty);
				item.find("#zk").html(n.discount_rate);
				item.find("#st_sum").html(n.st_sum);
				item.find("#stSum").html(0);
				item.find("#vendor_id").val(n.vendor_id);
				item.find("#corp_name").html(n.corp_name);
				item.find("#movtel").html(n.movtel);
				if(!common.isPC()){
					item.find("#movtel").click(function(){
						window.location.href="tel:"+$(this).html();
					});
				}
				item.find("#storeStruct").html(n.store_struct_name);
				item.find("#thDate").html(n.store_date);
				item.find("#thst_sum").html(n.st_sum);
				item.find("#store_struct_id").val(n.store_struct_id);
				item.find("#jb_name").html(n.kd_name);
				item.find("#thrcv_auto_no").html(n.rcv_auto_no);
				item.find("#st_auto_no").html(n.st_auto_no);
				item.find("#c_memo").html(n.c_memoMain);
				item.find("#use_oq").html(isnull0(n.use_oq));
				item.find("#store_struct_id").val(n.store_struct_id);
//				item.find("#use_oq").html(isnull0(n.accn_ivt));
				item.find("#cgno").html(n.cgno);
				item.find("#cgsl").html(n.cgsl);
				item.find("#cgrq").html(n.cgrq);
				
				if(lia==0){
					item.find("#rukuNum").html(n.rep_qty);
					item.find("#rukuTime").html(n.at_term_datetime);
					item.find("#st_auto_no").html(n.rcv_auto_no);//入库单号
					item.find("#repQty").bind("input propertychange blur",function(){
						var discount_rate=$.trim(parseFloat($(this).parents(".dataitem").find("#zk").html()));
						var item_cost=$.trim(parseFloat($(this).parents(".dataitem").find("#price").html()));
						var rep_qty=$.trim(parseFloat($(this).parents(".dataitem").find("#rep_qty").html()));
						var val=$.trim($(this).val());
						var num=parseFloat(val);
						if(num>rep_qty){
							pop_up_box.showMsg("退货数量大于入库数量!");
						}
						if (val==""||val=="0") {
							num=0;
							$(this).parents(".dataitem").find("#check").prop("checked",false);
						}else{
							$(this).parents(".dataitem").find("#check").prop("checked",true);
						}
						if(discount_rate=="0"||discount_rate==""){
							$(this).parents(".dataitem").find("#stSum").html(numformat2(num*item_cost));
						}else{
							$(this).parents(".dataitem").find("#stSum").html(numformat2(num*item_cost*discount_rate/parseFloat("100")));
						}
					});
					item.find("#thrcv_auto_no").parent().remove();
					item.find("#thDate").parent().remove();
					item.find("#stSum").parent().remove();
					item.find("#c_memo").parent().remove();
					item.find("#threp_qty").parent().remove();
				}else{
					item.find("#repQty").parent().remove();
					
					item.find("#rukuTime").html(n.rukuTime);
					item.find("#rukuNum").html(n.rukuNum);
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
			}
	}
	$(".nav li").click(function(){
		var lia = $(".nav li").index(this);
		var tabs= $(".tabs-content:eq("+lia+")");
		var item=$.trim(tabs.find("#list").html());
		if(lia==1){
			$("#returnOrder,#return,#confirm").hide();
			$("#delete").show();
		}else{
			$("#returnOrder").show();
			$("#delete,#confirm,#return").hide();
		}
		if (item=="") {
			$(".find:eq("+lia+")").click();
		}
		$(".form").parent().hide();
		$(".form").eq(lia).parent().show();
	});
	//获取当前请求路径
	$(".find:eq(0)").click();
	//全选
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
	$("#delete").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var checkIn=[];
		var rcvNo="";
		var stores=[];
		if(chekcs&&chekcs.length>0){
			for(var i=0;i<chekcs.length;i++){
				var item=$($(chekcs[i]).parents(".dataitem"));
				var rcv_auto_no=$.trim(item.find("#thrcv_auto_no").html());
				var st_auto_no=$.trim(item.find("#st_auto_no").html());
				var thNum=$.trim(item.find("#threp_qty").html());
				var price=$.trim(item.find("#price").html());
				var item_id=$.trim(item.find("#item_id").html());
				var store_struct_id=$.trim(item.find("#store_struct_id").val());
				var deleteData={
						"rcv_auto_no":rcv_auto_no,
//						"st_auto_no":st_auto_no,
//						"thNum":thNum,
//						"price":price,
//						"client":"cgth",
						"item_id":item_id,
						"store_struct_id":store_struct_id
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
	//提交
	$("#returnOrder").click(function(){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var item_ids=[];
		var rcvNo="";
		var vendors=[];
		var thNum;
			if (chekcs&&chekcs.length>0) {
				var b=true;
				for(var i=0;i<chekcs.length;i++){
					var item=$(chekcs[i]).parents(".dataitem");
					var rep_qty=parseFloat(item.find("#rep_qty").html());
					thNum=parseFloat(item.find("#repQty").val());
					if(thNum<=0||!thNum){
						pop_up_box.showMsg("退货数量必须大于0!");
						b=false;
					}
					if(thNum-rep_qty>0){
						pop_up_box.showMsg("退货数量大于入库数量!");
						b=false;
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
					for(var i=0;i<chekcs.length;i++){
						var item=$(chekcs[i]).parents(".dataitem");
						var rcv_auto_no=$.trim(item.find("#st_auto_no").html());
						var rep_qty=parseFloat($.trim(item.find("#rukuNum").html()));//已入库数量
						thNum=parseFloat(item.find("#repQty").val());//退货数量
						var sdOq=parseFloat($.trim(item.find("#cgsl").html()));//采购数量
						var st_sum=parseFloat($.trim(item.find("#thst_sum").html()));//退货金额
						var item_cost=parseFloat($.trim(item.find("#price").html()));//退货数量
						var item_id=$.trim(item.find("#item_id").html());
						var item_spec=$.trim(item.find("#item_spec").html());
						var item_type=$.trim(item.find("#item_type").html());
						var discount_rate=$.trim(item.find("#zk").html());
						var st_auto_no=$.trim(item.find("#cgno").html());//采购单号
						var vendor_id=$.trim(item.find("#vendor_id").val());//供应商ID
						var vendor_name=$.trim(item.find("#corp_name").html());
						var store_struct_id=$.trim(item.find("#store_struct_id").val());
						var store_struct_name=$.trim(item.find("#storeStruct").html());
						var item_color=$.trim(item.find(".colorActive").html());
						var item_type=$.trim(item.find(".specActive").html());
						var itemdata={
								"rcv_auto_no":rcv_auto_no,
								"rep_qty":rep_qty,
								"thNum":thNum,
								"item_color":item_color,
								"item_type":item_type,
								"st_sum":st_sum,
								"item_cost":item_cost,
								"item_id":item_id,
								"item_spec":item_spec,
								"item_type":item_type,
								"discount_rate":discount_rate,
								"st_auto_no":st_auto_no,
								"vendor_id":vendor_id,
								"vendor_name":vendor_name,
								"sd_oq":sdOq,
								"store_struct_name":store_struct_name,
								"store_struct_id":store_struct_id
						}
						if (rcvNo==rcv_auto_no) {
							vendors.push(JSON.stringify(itemdata));
						}else if(!rcvNo){
							rcvNo=rcv_auto_no;
							vendors.push(JSON.stringify(itemdata));
						}else{
							rcvNo=rcv_auto_no;
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
						$.post("../manager/purchaseReturn.do",{
							"item_ids":"["+item_ids.join(",")+"]",
							"clerk_id":clerk_id,
							"dept_id":dept_id,
							"c_memo":c_memo
						},function(data){
							pop_up_box.loadWaitClose();
							$("#sure").unbind("click");
							if (data.success) {
								pop_up_box.showMsg("已成功生成采购退货单,等待审核!",function(){
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
	function confirmReturn(comfirm_flag,name){
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		if (chekcs&&chekcs.length>0) {
			var rcv_auto_no="";
			for(var i=0;i<chekcs.length;i++){
				rcv_auto_no=rcv_auto_no+","+$.trim($(chekcs[i]).parents(".dataitem").find("#thrcv_auto_no").html());
			}
			if(window.confirm("系统自动将同一个采购退货单号下所有产品一起"+name+",请确认?")){
				pop_up_box.postWait();
				$.post("../manager/confirmReturn.do",{
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
			pop_up_box.showMsg("请选择一个产品!");
		}
	}
	$("#confirm").click(function(){
		confirmReturn("Y","审核");
		return;
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var item_ids=[];
		var rcvNo="";
		var vendors=[];
		if (chekcs&&chekcs.length){
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents(".dataitem");
				var vendor_id=$.trim(item.find("#vendor_id").val());
				var rcv_auto_no=$.trim(item.find("#thrcv_auto_no").html());
				var item_id=$.trim(item.find("#item_id").html());
				var store_struct_id=$.trim(item.find("#store_struct_id").val());
				var thNum=parseFloat(item.find("#threp_qty").html());//退货数量
				var itemdata={
						"rcv_auto_no":rcv_auto_no,
						"thNum":thNum,
						"item_id":item_id,
						"store_struct_id":store_struct_id
				}
				if (rcvNo==rcv_auto_no) {
					vendors.push(JSON.stringify(itemdata));
				}else if(!rcvNo){
					rcvNo=rcv_auto_no;
					vendors.push(JSON.stringify(itemdata));
				}else{
					rcvNo=rcv_auto_no;
					item_ids.push(vendors);
					vendors=[];
					vendors.push(JSON.stringify(itemdata));
				}
				if (i==(chekcs.length-1)) {
					item_ids.push(vendors);
				}
			}
			if(window.confirm("相同采购退货单号必须全选,请确认?")){
				pop_up_box.postWait();
				$.post("../manager/confirmReturn.do",{
					"item_ids":item_ids,
					"len":item_ids.length
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("审核成功!",function(){
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
			pop_up_box.showMsg("请选择一个产品!");
		}
	})
	$("#return").click(function(){
		confirmReturn("N","审核弃审");
		return;
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var chekcs=tabs.find("#list #check:checked");
		var item_ids=[];
		var rcvNo="";
		var vendors=[];
		if (chekcs&&chekcs.length>0) {
			for(var i=0;i<chekcs.length;i++){
				var item=$(chekcs[i]).parents(".dataitem");
				var vendor_id=$.trim(item.find("#vendor_id").val());
				var rcv_auto_no=$.trim(item.find("#thrcv_auto_no").html());
				var item_id=$.trim(item.find("#item_id").html());
				var store_struct_id=$.trim(item.find("#store_struct_id").val());
				var thNum=parseFloat(item.find("#threp_qty").html());//退货数量
				var itemdata={
						"rcv_auto_no":rcv_auto_no,
						"thNum":thNum,
						"item_id":item_id,
						"store_struct_id":store_struct_id
				}
				if (rcvNo==rcv_auto_no) {
					vendors.push(JSON.stringify(itemdata));
				}else if(!rcvNo){
					rcvNo=rcv_auto_no;
					vendors.push(JSON.stringify(itemdata));
				}else{
					rcvNo=rcv_auto_no;
					item_ids.push(vendors);
					vendors=[];
					vendors.push(JSON.stringify(itemdata));
				}
				if (i==(chekcs.length-1)) {
					item_ids.push(vendors);
				}
			}
			if(window.confirm("相同采购入库单号必须全选,请确认?")){
				pop_up_box.postWait();
				$.post("../manager/returnConfirm.do",{
					"item_ids":item_ids,
					"len":item_ids.length
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("弃审成功!",function(){
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
			pop_up_box.showMsg("请选择一个产品!");
		}
	})
	//经办人
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
	//经办部门
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