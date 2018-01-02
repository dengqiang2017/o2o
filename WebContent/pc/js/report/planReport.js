$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	now=addDate(nowStr,1);
	nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(0)").val(nowStr);
	$(".Wdate:eq(1)").val(nowStr);
	$(".Wdate:eq(2)").val("21:00:00");
	var vendor_id="";
	var customer_id="";
	
	$(".caigou").click(function(){
		if(confirm("是否已经全部确认并立即向所有供应商采购订单?")){
			pop_up_box.dataHandling("数据后台处理中...");
			$.post("../employee/generatePurchaseOrderByPlan.do",{
				"beginDate":$(".Wdate:eq(0)").val(),
				"endDate":$(".Wdate:eq(1)").val(),
				"title":"青清源采购订单通知",
				"description":"供应商-@gysName:青清源已向您下采购订单,请尽快进入系统进行核实价格,数量并准备发货"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("处理成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("处理错误!" + data.msg);
					} else {
						pop_up_box.showMsg("处理错误!");
					}
				}
			});
		}
	});
	function selectTr(){
		$("tbody tr").removeClass('activeTable');
		$("tbody tr").click(function(){
			$("tbody tr").removeClass('activeTable');
			$(this).addClass('activeTable');
		});
	}
	//查询
	function loadDataCount(){
		pop_up_box.loadWait();
		$(".table-responsive:eq(0) tbody").html("");
//		var beginTime=$(".Wdate:eq(0)").val()+" "+$(".Wdate:eq(2)").val();
		$.get("planReportCount.do",{
			"searchKey":$("input[name='searchKey']").val(),
//			"beginTime":beginTime,
			"vendor_id":vendor_id,
			"customer_id":customer_id,
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItemCount(data);
			selectTr();
		});
	}
	function addItemCount(data){
		if(data&&data.length>0){
			var len=data.length;
			var thlen=$(".table-responsive:eq(0) th").length;
			$.each(data,function(i,n){
				var tr=getTr(thlen);
				$(".table-responsive:eq(0) tbody").append(tr);
				for (var i = 0; i < thlen; i++) {
					var th=$($(".table-responsive:eq(0) th")[i]);
					var name=th.attr("data-name");
					var j=$(".table-responsive:eq(0) th").index(th);
					if(j>=0){
						if(name=="corp_name"){
							tr.find("td:eq("+j+")").html("<span>"+n[name]+"</span><input type='hidden' value='"+n.vendor_id+"'>");
							if(n.corp_name!=""){//更改
								var changebtn=$("<button type='button' class='btn btn-danger'>更改</button>");
								tr.find("td:eq("+j+")").append(changebtn);
								changebtn.click({"item_id":n.item_id,"planTime":n.planTime,"item_cost":n.item_cost},function(event){
									selecgys(this,event.data.item_id,event.data.planTime,event.data.item_cost);
								});
							}else{//选择
								var selectbtn=$("<button type='button' class='btn btn-danger'>选择</button>");
								tr.find("td:eq("+j+")").append(selectbtn);
								selectbtn.click({"item_id":n.item_id,"planTime":n.planTime,"item_cost":n.item_cost},function(event){
									selecgys(this,event.data.item_id,event.data.planTime,event.data.item_cost);
								});
							}
							tr.find("td:eq("+j+")").addClass("minwidth");
						}else{
							tr.find("td:eq("+j+")").html(n[name]);
						}
						if(name=="item_cost"&&n.item_id){
							if($.trim($("#purchase_price").html())!=""){
								tr.find("td:eq("+j+")").click({"item_id":n.item_id,"vendor_id":n.vendor_id},function(event){
									var t=$(this);
									var val=$.trim(t.html());
									$("#modal_smsSelect").show();
									$("#modal_smsSelect .modal-title").html("更改价格");								
									$("#modal_smsSelect input:eq(0)").val(val).select();
									$("#modal_smsSelect input:eq(1)").val($(this).next().html()).select();
									$("#modal_smsSelect input:eq(0)").parents(".ctn").find("label:eq(0)").html("采购价");
									$("#modal_smsSelect input:eq(1)").parents(".ctn").show();
									$("#modal_smsSelect .btn-primary").unbind("click");
									$("#modal_smsSelect .btn-primary").click(function(){
										var v=$("#modal_smsSelect input:eq(0)").val();
										var item_zeroSell=$("#modal_smsSelect input:eq(1)").val();
										if(val!=""){//修改采购价数量
											$.post("../report/savePlanGys.do",{
												"discount_rate":v,
												"item_cost":v,
												"vendor_id":vendor_id,
												"item_zeroSell":item_zeroSell,
												"item_id":event.data.item_id,
												"beginDate":$(".Wdate:eq(0)").val(),
												"endDate":$(".Wdate:eq(1)").val()
											},function(data){
												 if (data.success) {
													 pop_up_box.toast("数据保存成功!", 1000);
												 }else{
													 if(data.msg){
														 pop_up_box.showMsg("数据存储异常");
													 }else{
														 pop_up_box.showMsg("数据存储异常,错误代码:"+data.msg);
													 }
												 }
											});
										}
										t.html(v);
										t.next().html(item_zeroSell);
										$("#modal_smsSelect input").val("");
										$("#modal_smsSelect input:eq(1)").parents(".ctn").hide();
										$("#modal_smsSelect input:eq(0)").parents(".ctn").find("label:eq(0)").html("");
										$("#modal_smsSelect").hide();//重新计算计划数量汇总
										var thindex=$("thead:eq(0) th").index($("thead:eq(0) th[data-name='planNum']"));
										var jei=$("thead:eq(0) th").index($("thead:eq(0) th[data-name='je']"));
										var planNum=parseFloat(t.parent().find("td:eq("+thindex+")").html());
										t.parent().find("td:eq("+jei+")").html(numformat2(parseFloat(v)*planNum));
										var countr=$("tbody").eq(0).find("tr").eq(0);
										getSumNum(countr,0,"je",2);
									});
								});
							}
						}
					}
				}
				var btn=$("<button type='button' class='btn btn-danger'>详情</button>");
				tr.find("td:eq(9)").html(btn);
				btn.click({"item_id":n.item_id},function(event){
					$(".nav li").removeClass("active");
					$(".nav li:eq(1)").addClass("active");
					$(".tabs-content").hide();
					$(".tabs-content:eq(1)").show();
					loadDataDetail(event.data.item_id);
				});
			});
			////计算计划数量汇总
			addCount(thlen, 0);
		}
	}
	/**
	 * 增加汇总行
	 */
	function addCount(thlen,index){
	////计算计划数量汇总
		if(!thlen){
			pop_up_box.showMsg("请输入表格列数!");
			return;
		}
		if(!index){
			index=0;
		}
		var tr=getTr(thlen);
		tr.find("td:eq(0)").html("汇总");
		getSumNum(tr,index,"planNum",2);
		getSumNum(tr,index,"kucun",2);
		getSumNum(tr,index,"je",2);
		$(".table-responsive:eq("+index+") tbody>tr:eq(0)").before(tr);
	}
	$("#vendorBtn").click(function(){
		pop_up_box.loadWait(); 
		$.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
			  pop_up_box.loadWaitClose();
			  $("body").append(data);
			  vendor.init(function(){
				   vendor_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
				  var name=$(".modal").find("tr.activeTable").find("td:eq(0)").text();
				  $("#vendorName").html(name);
			  });
		});
	});
	$("#clientBtn").click(function(){
		pop_up_box.loadWait(); 
		$.get("../manager/getDeptTree.do",{"type":"client"},function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			client.init(function(){
				customer_id=treeSelectId;
				$("#clientName").html(treeSelectName);
			});
		});
	});
	$(".btn-default").click(function(){
		var n=$(".btn-default").index(this);
		if(n==0){
			customer_id="";$("#clientName").html("");
		}else{
			vendor_id="";$("#vendorName").html("");
		}
	});
	function selecgys(t,item_id,planTime,item_cost){
		pop_up_box.loadWait(); 
		$.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
			  pop_up_box.loadWaitClose();
			  $("body").append(data);
			  vendor.init(function(){
				  var gysid=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
				  $(t).parent().find("input").val(gysid);
				  $(t).parent().find("span").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
				  $(t).html("更改");
				  $.post("savePlanGys.do",{
					  "item_cost":item_cost,
					  "gysid":gysid,
					  "item_id":item_id,
					  "planTime":planTime,
					  "beginTime":$(".Wdate:eq(0)").val(),
					  "endTime":$(".Wdate:eq(1)").val()
				  },function(data){
					  
				  });
			  });
		  });
	}
	var page=0;
	var count=0;
	var totalPage=0;
	function loadDataDetail(item_id,time,vendorId){
		if(!item_id){
			item_id="";
		}
		var beginTime="";
		var endTime="";
		var index=1;
		var mingxi="";
		var type=$("input[name='type']:checked").val();
		if(type==2){//追加
			beginTime=$(".Wdate:eq(0)").val()+" "+$(".Wdate:eq(2)").val();
		}else if(type==1){
			endTime=$(".Wdate:eq(1)").val()+" "+$(".Wdate:eq(2)").val();
		}
		if(time){
			index=2;
			beginTime="";
			endTime="";
			mingxi="mingxi";
		}
		pop_up_box.loadWait();
		var count=0;
		$.get("planReportDetail.do",{
			"item_id":item_id,
			"desc":$("input[name='desc']:checked").val(),
			"searchKey":$("input[name='searchKey']").val(),
			"beginTime":beginTime,
			"endTime":endTime,
			"mingxi":mingxi,
			"vendorId":vendorId,
			"vendor_id":vendor_id,
			"customer_id":customer_id,
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItemDetail(data,index);
			selectTr();
		});
	}
	function addItemDetail(data,index){
		$(".table-responsive:eq("+index+") tbody").html("");
		if(data&&data.length>0){
			var thlen=$(".table-responsive:eq("+index+") th").length;
			for (var tdi = 0; tdi < data.length; tdi++) {
				var n=data[tdi];
				var tr=getTr(thlen);
				$(".table-responsive:eq("+index+") tbody").append(tr);
				tr.find("td:eq(0)").html(n.c_corp_sim_name);
				tr.find("td:eq(1)").html(n.item_name);
				tr.find("td:eq(2)").html(n.planNum);
				tr.find("td:eq(3)").html(n.kucun);
				tr.find("td:eq(4)").html(n.item_unit);
				tr.find("td:eq(5)").html(n.item_cost);
				tr.find("td:eq(6)").html(n.je);
				tr.find("td:eq(7)").html(n.at_term_datetime);
				tr.find("td:eq(8)").html(n.corp_name);
//				for (var i = 0; i < thlen; i++) {
//					var th=$($(".table-responsive:eq("+index+") th")[i]);
//					var name=th.attr("data-name");
//					var j=$(".table-responsive:eq("+index+") th").index(th);
//					if(j>=0){
//						tr.find("td:eq("+j+")").html(n[name]);
//					}
//				}
				if(n.seeds_id){
					if($.trim($("#purchase_num").html())!=""){
						tr.find("td:eq(2)").click({"seeds_id":n.seeds_id},function(event){
							var t=$(this);
							var val=$.trim(t.html());
							$("#modal_smsSelect").show();
							$("#modal_smsSelect .modal-title").html("更改计划数量");
							$("#modal_smsSelect input:eq(0)").val(val).select();
							$("#modal_smsSelect input:eq(0)").parents(".ctn").find("label:eq(0)").html("");
							$("#modal_smsSelect input:eq(1)").parents(".ctn").hide();
							$("#modal_smsSelect .btn-primary").unbind("click");
							$("#modal_smsSelect .btn-primary").click(function(){
								var v=$("#modal_smsSelect input:eq(0)").val();
								if(val!=""&&v!=val){//修改计划数量
									$.post("../report/savePlanGys.do",{
										"sd_oq":v,
										"seeds_id":event.data.seeds_id
									},function(data){
										if (data.success) {
											 pop_up_box.toast("数据保存成功!", 1000);
										 }else{
											 if(data.msg){
												 pop_up_box.showMsg("数据存储异常");
											 }else{
												 pop_up_box.showMsg("数据存储异常,错误代码:"+data.msg);
											 }
										 }
									});
								}
								t.html(v);
								$("#modal_smsSelect input").val("");
								$("#modal_smsSelect").hide();//重新计算计划数量汇总
								var countr=$("tbody").eq(index).find("tr").eq(0);
								getSumNum(countr,index,"planNum",2);
								getSumNum(countr,index,"je",2);
							});
						});
					}
				}
			}
			//$.each(data,function(i,n){
				
		//	});
			////计算计划数量汇总
			addCount(thlen, index);
		}
	}
	///////////////////
	function loadBusinessAccontCount(type){
		pop_up_box.loadWait();
		var index=4;
		if(!type){
			type="";
			index=3;
		}
		$(".table-responsive:eq("+index+") tbody").html("");
		$.get("getPlanBusinessAccontCount.do",{
			"type":type,
			"searchKey":$("input[name='searchKey']").val(),
			"vendor_id":vendor_id,
			"customer_id":customer_id,
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			if(data&&data.length>0){
				var thlen=$(".table-responsive:eq("+index+") th").length;
				$.each(data,function(i,n){
					var tr=getTr(thlen);
					$(".table-responsive:eq("+index+") tbody").append(tr);
					for (var i = 0; i < thlen; i++) {
						var th=$($(".table-responsive:eq("+index+") th")[i]);
						var name=th.attr("data-name");
						var j=$(".table-responsive:eq("+index+") th").index(th);
						tr.find("td").eq(i).html(n[name]);
					}
					if(index==4){
						var xiang=$("<button type='button' class='btn btn-danger'>详情</button>");
						tr.find("td:eq(2)").html(xiang);
						xiang.click({"vendor_id":n.vendor_id},function(event){
							$(".nav li").removeClass("active");
							$(".nav li:eq(1)").addClass("active");
							$(".tabs-content").hide();
							$(".tabs-content:eq(1)").show();
							loadDataDetail("","",event.data.vendor_id);
						});
						if($("#purchase_gen").length>0){
							var send=$("<button type='button' class='btn btn-danger'>发送</button>");
							tr.find("td:eq(3)").html(send);
							send.click({"vendor_id":n.vendor_id},function(event){
								if(confirm("是否已经全部确认并立即向所有供应商采购订单?")){
									pop_up_box.dataHandling("数据后台处理中...");
									$.post("../employee/generatePurchaseOrderByPlan.do",{
										"beginDate":$(".Wdate:eq(0)").val(),
										"endDate":$(".Wdate:eq(1)").val(),
										"vendor_id":event.data.vendor_id,
										"ling":"13882243244",
										"title":"青清源采购订单通知",
										"description":"供应商-@gysName:青清源已向您下采购订单,请尽快进入系统进行核实价格,数量并准备发货"
									},function(data){
										pop_up_box.loadWaitClose();
										if (data.success) {
											pop_up_box.toast("处理成功!"+data.msg, 1000);
										} else {
											if (data.msg) {
												pop_up_box.showMsg("处理错误!" + data.msg);
											} else {
												pop_up_box.showMsg("处理错误!");
											}
										}
									});
								}
							});
						}
					}
				});
				////计算计划数量汇总
				var tr=getTr(thlen);
				tr.find("td:eq(0)").html("汇总");
				getSumNum(tr,index,"zje",2);
				$(".table-responsive:eq("+index+") tbody>tr:eq(0)").before(tr);
				selectTr();
			}
		});
	}
	///////////////////////////////
	$("#modal_smsSelect .btn-default,#modal_smsSelect .close").click(function(){
		$("#modal_smsSelect input").val("");
		$("#modal_smsSelect").hide();
	});
	//导出
	function excelDataCount(){
		pop_up_box.loadWait();
		$.get("planReportCountExcel.do",{
			"searchKey":$("input[name='searchKey']").val(),
			"beginDate":$(".Wdate:eq(0)").val(),
			"vendor_id":vendor_id,
			"customer_id":customer_id,
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				window.location.href=data.msg
			} else {
				if (data.msg) {
					pop_up_box.showMsg(data.msg);
				} else {
					pop_up_box.showMsg("没有获取到可导出!");
				}
			}
		});
	}
	function excelDataDetail(xlsx,time){
		pop_up_box.loadWait();
		var beginTime="";
		var endTime="";
		if(time){
			beginTime=$(".Wdate:eq(0)").val()+" "+time;
		}else{
			if(!$("#alldetail").prop("checked")){
				endTime=$(".Wdate:eq(1)").val()+" "+$(".Wdate:eq(2)").val();
			}
		}
		if(!xlsx){
			xlsx="";
		}
		$.get("planReportDetailExcel.do",{
			"desc":$("input[name='desc']:checked").val(),
			"searchKey":$("input[name='searchKey']").val(),
			"beginTime":beginTime,
			"endTime":endTime,
			"vendor_id":vendor_id,
			"customer_id":customer_id,
			"xlsx":xlsx,
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				if(!xlsx){
					window.open("../pc/excel.html?.."+data.msg,"_blank");
				}else{
					window.location.href=data.msg;
				}
			} else {
				if (data.msg) {
					pop_up_box.showMsg(data.msg);
				} else {
					pop_up_box.showMsg("没有获取到可导出!");
				}
			}
		});
	}
	//查询
	$(".find").click(function(){
		var n=$(".nav li").index($(".nav .active"));
		if(n==0){
			loadDataCount();
		}else if(n==1){
			page=0;
			count=0;
			$(".table-responsive:eq("+n+") tbody").html("");
			loadDataDetail();
		}else if(n==2){
			page=0;
			count=0;
			$(".table-responsive:eq("+n+") tbody").html("");
			loadDataDetail("",$(".Wdate:eq(2)").val());
		}else if(n==3){
			loadBusinessAccontCount();
		}else{
			loadBusinessAccontCount('gys');
		}
	});
	//导出
	$(".excel").click(function(){
		var n=$(".nav li").index($(".nav .active"));
		if(n==0){
			excelDataCount();
		}else if(n==1){
			excelDataDetail("");
		}else{
			excelDataDetail("",$(".Wdate:eq(2)").val());
		}
	});
	$(".xlsx").click(function(){
		var n=$(".nav li").index($(".nav .active"));
		if(n==0){
		}else if(n==1){
			excelDataDetail("xlsx");
		}else{
			excelDataDetail("xlsx",$(".Wdate:eq(2)").val());
		}
	});
	
	$(".nav li").click(function(){
		var n=$(".nav li").index(this);
		$("#zhuijia,.xlsx,.excel").hide();
		if(n==0){
			if($.trim($("tbody:eq(0)").html())==""){
				loadDataCount();
			}
			$(".excel").show();
		}else if(n==1){
			$("#zhuijia,.xlsx,.excel").show();
//			if($.trim($("tbody:eq(1)").html())==""){
//				loadDataDetail();
//			}
		}else if(n==2){
			$(".xlsx").show();
//			if($.trim($("tbody:eq(2)").html())==""){
//				loadDataDetail("",$(".Wdate:eq(2)").val());
//			}
		}else{
			
		}
	});
	$(".btn-folding").click(function(){
		var form=$("form");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".btn-folding").is(":hidden")){
		$("form").show();
	}else{
		$("form").hide();
	}
});