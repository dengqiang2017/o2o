$(function(){
			var com_id=$.trim($("#com_id").html());
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".form .Wdate:eq(0)").val(nowStr.split("-")[0]+"-"+nowStr.split("-")[1]+"-01");
			$(".form .Wdate:eq(1)").val(nowStr);
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
			var purPage={
					page:0,
					count:0,
					totalPage:0
			};
			productpage.initBtnClick(function(lia){
				if (lia==0) {
					orderPage.page=0;
				}else if(lia==1){
					productPage.page=0;
				}else{
					purPage.page=0;
				}
				loadData(0,0);
			});
			//切换li标签时模拟搜索框点击事件自动获取数据
			productpage.navLiClick(function(item,lia){
				if(lia!=2){
					$("#allcheck,#saveOrder").show();
					$("#tzanpai").hide();
				}else{
					$("#saveOrder").hide();
					$("#allcheck").parent().hide();
				}
			});
			//加载更多数据 
			productpage.btnAddClick(function(page,count,totalPage){
				if (lia==0) {
					orderPage.page+=1;
					page=orderPage.page;
					count=orderPage.count;
					totalPage=orderPage.totalPage;
				}else if(lia==1){
					productPage.page+=1;
					page=productPage.page;
					count=productPage.count;
					totalPage=productPage.totalPage;
				}else{
					purPage.page+=1;
					page=purPage.page;
					count=purPage.count;
					totalPage=purPage.totalPage;
				}
				if (page<=totalPage) {
					loadData(page, count);
				}
			});
			function loadData(page,count){
				pop_up_box.loadWait();
				var lia = $(".nav li").index($(".nav .active"));
				var searchKey=$($(".form")[lia]).find("#searchKey").val();
				var beginDate=$($(".form")[lia]).find(".Wdate:eq(0)").val();
				var endDate=$($(".form")[lia]).find(".Wdate:eq(1)").val();
				var m_flag=$($(".form")[lia]).find("#m_flag").val();
				var lia = $(".nav li").index($(".nav .active"));
				var url="";
				if (lia==0) {
					url="../orderTrack/getWaitingHandleOrderPage.do?type=采购";
				}else if(lia==1){
					url="../product/getProductWarePage.do?type=采购";
				}else{
					url="vendorOrderList.do";
				}
				$.get(url,{
					"searchKey":$.trim(searchKey),
					"type_id":common.getVal("#findForm #type_id"),
					"quality_class":common.getVal("#findForm #quality_class"),
					"item_style":common.getVal("#findForm #item_style"),
					"class_card":common.getVal("#findForm #class_card"),
					"item_spec":common.getVal("#findForm #item_spec"),
					"item_struct":$.trim($("#item_struct").val()),
					"item_type":$.trim($("#item_type").val()),
					"item_color":$.trim($("#item_color").val()),
					"beginDate":beginDate,
					"seeds_id":seeds_id,
					"endDate":endDate,
					"m_flag":m_flag,
					"page":page,
					"count":count
				},function(data){
					pop_up_box.loadWaitClose();
					addItem(data); 
					if(lia==0){
						orderPage.totalPage = data.totalPage;
						orderPage.count = data.totalRecord;
					}else if (lia==1) {
						productPage.totalPage = data.totalPage;
						productPage.count = data.totalRecord;
					}else{
						purPage.totalPage = data.totalPage;
						purPage.count = data.totalRecord;
					}
				});
			}
			function addItem(data){
				if (data&&data.rows.length>0) {
					var lia = $(".nav li").index($(".nav .active"));
					$(".num").unbind("input propertychange blur");
					$.each(data.rows,function(i,n){
						var item=$($("#item").html());
						$(".tabs-content").eq(lia).find("#list").append(item);
						loadProInfo(item,n);
//						item.find("#price_type").html(n.price_type);
						item.find("#vendor_id").html(n.vendor_id);
						item.find("#seeds_id").val(n.seeds_id);
						item.find("#mps_id").val(n.mps_id);
						////////
						var item_cost=n.item_cost;
						if(lia==2){//已下采购
							if(n.m_flag==6){
								item.find("#hav_rcv").parent().remove();
								item.find("#price").parent().remove();
								item.find("#item_cost").val(numformat2(n.price));
								item.find("#pronum").val(n.hav_rcv);
							}else{
								item.find("#price").html(numformat2(n.price));
								item.find("#hav_rcv").html(n.hav_rcv);
								item.find("#item_cost").parent().remove();
								item.find("#pronum").parent().remove();
							}
							item.find("#sum_si").html(numformat2(n.hav_rcv*n.price));
							item.find("#use_oq").parent().remove();
							item.find("#sd_oq").parent().remove();
							item.find("#gys_sim_name").html(n.corp_sim_name);
							item.find("#gys_movtel").html(n.movtel);
							item.find("#weixinID").html(n.weixinID);
							item.find("#m_flag").html($("#m_flag option[value='"+n.m_flag+"']").text());
							item.find("#corp_sim_name").parent().remove();
							item.find("#movtel").parent().remove();
							item.find("#c_memo_inp").parent().remove();
						}else{
							item.find("#comfirm").remove();
							item.find("#m_flag").parent().remove();
							item.find("#gys_sim_name").html(n.gys_sim_name);
							item.find("#gys_movtel").html(n.gys_movtel);
							item.find("#weixinID").html(n.gys_weixinID);
							item.find("#price").parent().remove();
							item.find("#hav_rcv").parent().remove();
							item.find("#item_cost").val(numformat2(n.item_cost));
							var use_oq=n.use_oq;
							if(use_oq){//库存数量
								item.find("#use_oq").append(n.use_oq);
							}else{
								use_oq=0
								item.find("#sum_si").html(0);
								item.find("#use_oq").append(0);
							}
							if(lia==1){
								item.find("#corp_sim_name").parent().remove();
								item.find("#movtel").parent().remove();
								item.find("#sd_oq").parent().remove();//订单数量
								item.find("#c_memo").parent().remove();//订单数量
							}else{
								item.find("#corp_sim_name").html(n.corp_sim_name);
								item.find("#movtel").html(n.movtel); 
								item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
								item.find("#sd_oq").append(n.sd_oq);//订单数量
								if(n.sd_oq>use_oq){
									var cha=n.sd_oq-use_oq;
									item.find("#pronum").val(cha);
									item.find("#sum_si").html(numformat2(cha*n.item_cost));
								}else{
									item.find("#pronum").val(0);
								}
							}
						}
						/////////////////////// 
						if(n.ivt_oper_listing){
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
						}else if(n.mps_id){
							item.find("#ivt_oper_listing").html(n.mps_id);
						}else{
							item.find("#ivt_oper_listing").parent().remove();	
						}
						if(n.st_auto_no){
							item.find("#st_auto_no").html(n.st_auto_no);
						}else{
							item.find("#st_auto_no").parent().remove();	
						}
						if(n.c_memo&&n.wuliudx){
							item.find("#c_memo").html("物流信息:"+n.c_memo+"地点:"+n.wuliudx);
						}else{
							item.find("#c_memo").html(n.c_memo);
						}
						if(lia!=2){
							item.find("#pronum").bind("input propertychange blur",function(){
								var item_cost=parseFloat($(this).parents(".dataitem").find("#item_cost").val());
								var val=$.trim($(this).val());
								var num=parseFloat(val);
								if (val==""||val=="0") {
									num=0;
									$(this).parents(".dataitem input[type='checkbox']").prop("checked",false);
								}else{
									$(this).parents(".dataitem input[type='checkbox']").prop("checked",true);
								}
							    $(this).parents(".dataitem").find("#sum_si").html(num*item_cost);
							});
							item.find("#item_cost").bind("input propertychange blur", function(){
								var sd_unit_price=parseFloat(this.value);
								var num=parseFloat($(this).parents(".dataitem").find("#pronum").val());
								var sumsi=sd_unit_price*num;
								if(!sumsi){
									sumsi=0;
									$(this).parents(".dataitem input[type='checkbox']").prop("checked",false);
								}else{
									$(this).parents(".dataitem input[type='checkbox']").prop("checked",true);
								}
								$(this).parents(".dataitem").find("#sum_si").html(sumsi);
							});
							item.find("#zuofei,#cuidan").hide();
							item.find(".changGys").show();
						}else{////已下采购订单部分
							item.find(".changGys").remove();
							item.find("#cuidan").hide();
							item.find("#changGys").hide();
							item.find("#tongzhiwuliu").hide();
							item.find("input[type='checkbox']").hide();
							if(n.m_flag==0){//0未处理,为1作废,2-已处理,3-无货
								item.find("#flag").append("未处理");
								item.find("#cuidan").show();
							}else if(n.m_flag==1){
								item.find("#flag").append("已作废");
							}else if(n.m_flag==2){
								item.find("#flag").append("已处理有货");
								item.find("#tongzhiwuliu").show();
								if(n.mps_id){//采购订单中有销售订单,改走订单流程统一物流方式
									item.find("#tongzhianpai").show();
									$("#tzanpai").show();
									item.find("input[type='checkbox']").show();
								}else{//直接下采购订单,使用单独提交物流方式
									item.find("#tongzhiwuliu").show();
									item.find("#tongzhianpai").hide();
								}
								item.find("#tongzhianpai").hide();
								item.find("#tongzhiwuliu").show();
							}else if(n.m_flag==9){
								item.find("#flag").append("已通知安排物流");
								item.find("#zuofei").hide();
							}else if(n.m_flag==8){
								item.find("#flag").append("已提交物流信息");
								item.find("#zuofei").hide();
							}else if(n.m_flag==3){//无货
								item.find("#flag").append("<span style='color:red;'>已处理无货<span>");
								item.find("#changGys").show();
							}else if(n.m_flag==4){//已发货
								item.find("#zuofei").hide();
								item.find("#flag").append("已发货");
							}else if(n.m_flag==5){//5-已收货
								item.find("#zuofei").hide();
								item.find("#flag").append("已收货");
							}
							///采购订单审核
							if(n.m_flag==6){
								item.find("#zuofei").show();
								item.find("#comfirm").click({"st_auto_no":$.trim(n.st_auto_no),
									"seeds_id":n.seeds_id,
									"weixinID":$.trim(n.weixinID),
									"corp_sim_name":$.trim(n.corp_sim_name),
									"item_name":$.trim(n.item_name),
									"movtel":$.trim(n.movtel)
									},function(event){
										$("#modal_smsSelect").show();
										var t=$(this);
										var item=t.parents(".dataitem");
										$("#modal_smsSelect").find(".btn-primary").unbind("click");
										$("#modal_smsSelect").find(".btn-primary").click(function(){
											var checks=$("tbody").find(".checkedbox");
											var NoticeStyle=$("input[name='NoticeStyle']:checked").val();
											$("#modal_smsSelect,#houyun_Select").hide();
											var price=item.find("#item_cost").val();
											var hav_rcv=item.find("#pronum").val();
											pop_up_box.postWait();
											$.post("purchasingOrderComfirm.do",{
												"m_flag":"0",//6-未审核,0-未处理
												"type":NoticeStyle,
												"seeds_id":event.data.seeds_id,
												"weixinID":event.data.weixinID,
												"price":price,
												"hav_rcv":hav_rcv,
												"corp_sim_name":event.data.corp_sim_name,
												"item_name":event.data.item_name,
												"movtel":event.data.movtel,
												"st_auto_no":event.data.st_auto_no
											},function(data){
												pop_up_box.loadWaitClose();
												if (data.success) {
													pop_up_box.toast("审核成功,已通知供应商.", 1500);
													item.find("#m_flag").html("未处理");
													t.remove();
												}else{
													pop_up_box.showMsg("操作错误:"+data.msg);
												}
											});
										});
								});
							}else{
								item.find("#comfirm").remove();
							}
//							item.find("#pronum").parent().hide();
//							item.find("#changGys").hide();
							item.find("#tongzhiwuliu").click({"item_id":$.trim(n.item_id),"seeds_id":n.seeds_id,"st_auto_no":$.trim(n.st_auto_no)},function(event){
								$("#houyun_Select").find("#item_id").html(event.data.item_id);
								$("#houyun_Select").find("#seeds_id").html(event.data.seeds_id);
								$("#houyun_Select").find("#st_auto_no").html(event.data.st_auto_no);
								$("#houyun_Select").show();
							});
							item.find("#tongzhianpai").hide();
							item.find("#tongzhianpai").click({"item_id":$.trim(n.item_id),"seeds_id":n.seeds_id,
								"mps_id":n.mps_id,"st_auto_no":$.trim(n.st_auto_no),
								"item_name":$.trim(n.item_name)},function(event){
								pop_up_box.postWait();
								$.get("../orderTrack/noticeAnPaiWuliu.do",{//通知安排物流拉货
									"item_id":event.data.item_id,
									"seeds_id":event.data.seeds_id,
									"st_hw_no":event.data.st_auto_no,
									"mps_id":event.data.mps_id,
									"m_flag":9,
									"msg":"采购人员已向供应商核实有货,请安排物流到供应商提货!",
									"description":"采购单号:"+event.data.st_auto_no+",产品名称:"+event.data.item_name
								},function(data){
									pop_up_box.loadWaitClose();
									 if (data.success) {
											pop_up_box.showMsg("通知成功!");
											$(".find:eq(2)").click();
										} else {
											if (data.msg) {
												pop_up_box.showMsg("通知错误!" + data.msg);
											} else {
												pop_up_box.showMsg("通知错误!");
											}
										}
								});
							});
							
							item.find("#zuofei").click({"item_id":$.trim(n.item_id),"seeds_id":n.seeds_id,"st_auto_no":$.trim(n.st_auto_no),"orderNo":n.mps_id},function(event){
								var item_id=event.data.item_id;
								var seeds_id=event.data.seeds_id;
								var orderNo=event.data.orderNo;
								var st_auto_no=event.data.st_auto_no;
								var t=this;
								if (confirm("是否将该采购产品作废!")) {
									pop_up_box.postWait();
									$.post("zuofeiPOrder.do",{
										"item_id":item_id,
										"seeds_id":seeds_id,
										"orderNo":orderNo,
										"st_auto_no":st_auto_no
									},function(data){
										pop_up_box.loadWaitClose();
										if (data.success) {
											pop_up_box.showMsg("作废成功!",function(){
												$(t).parents(".dataitem").remove();
											});
										} else {
											if (data.msg) {
												pop_up_box.showMsg("作废错误!" + data.msg);
											} else {
												pop_up_box.showMsg("作废错误!");
											}
										}
									});
								}
								
							});
							item.find("#cuidan").click({"item_id":$.trim(n.item_id),"seeds_id":n.seeds_id,"st_auto_no":$.trim(n.st_auto_no)},function(event){
								var item_id=event.data.item_id;
								var seeds_id=event.data.seeds_id;
								var st_auto_no=event.data.st_auto_no;
								pop_up_box.postWait();
									$.get("cuidan.do",{
										"item_id":item_id,
										"seeds_id":seeds_id,
										"type":"0",
										"st_auto_no":st_auto_no
									},function(data){
										pop_up_box.loadWaitClose();
										if (data.success) {
											pop_up_box.showMsg("提交成功!");
										} else {
											if (data.msg) {
												pop_up_box.showMsg("提交错误!"
														+ data.msg);
											} else {
												pop_up_box.showMsg("提交错误!");
											}
										}
									});
							});
						}
						if(lia==1){
							item.find("#ivt_oper_listing").parent().hide();
						}
					});
					common.initNumInput();
					$(".changGys").bind("click",function(){
						  var lia = $(".nav li").index($(".nav .active"));
						  pop_up_box.loadWait(); 
						  var div=$(this).parents(".dataitem");
						  var t=$(this);
						  $.get("../manager/getDeptTree.do",{"type":"vendor"},function(data){
							  pop_up_box.loadWaitClose();
							  $("body").append(data);
							  vendor.init(function(){
								  div.find("#vendor_id").html($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
								  div.find("#gys_sim_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
								  div.find("#gys_movtel").html($(".modal").find("tr.activeTable").find("td:eq(1)").text());
								  div.find("#weixinID").html($(".modal").find("tr.activeTable").find("td:eq(2)").text());
								  div.find("input[type='checkbox']").prop("checked",true);
								  if (lia==2) {
									  var gys=$('<button type="button" class="btn btn-primary">确认更改供应商</button>');
									  t.after(gys);
									  gys.click(function(){
										  var t=$(this);
										  pop_up_box.postWait();
										  var orderNo=t.parents(".dataitem").find("#ivt_oper_listing").html();
										  $.post("confirmGys.do",{
											  "vendor_id":div.find("#vendor_id").html(),
											  "corp_sim_name":div.find("#corp_sim_name").html(),
											  "movtel":div.find("#movtel").html(),
											  "weixinID":div.find("weixinID").html(),
											  "st_auto_no":orderNo
										  },function(data){
											  pop_up_box.loadWaitClose();
											  if (data.success) {
												pop_up_box.showMsg("保存成功!");
												t.remove();
											} else {
												if (data.msg) {
													pop_up_box.showMsg("保存错误!"
															+ data.msg);
												} else {
													pop_up_box.showMsg("保存错误!");
												}
											}
										  });
									  });
								  }
							  });
						  });
					});
					productpage.detailClick(true,function(t){
						$(t).parents(".dataitem").find("input[data-number]:eq(0)").focus().select();
					},0);
					$(".dataitem").find("img").unbind("click");
				}
				
				$("#sum_si").parent().show();
			}
			
			var url=window.location.href.split("?");
			var seeds_id="";
			if(url&&url.length>1){
				seeds_id=getQueryString("seeds_id");
				if(seeds_id!=null&&seeds_id!=undefined&&seeds_id!=""){
					$(".find:eq(0)").click();
				}else{
					var st_auto_no=getQueryString("st_auto_no");
					var m_flag=getQueryString("m_flag");
					if(st_auto_no!=null&&st_auto_no!=undefined){
						$("#searchKey").val(st_auto_no);
						$(".nav li:eq(2)").click();
					}else if(m_flag!=null&&m_flag!=undefined){
						$($(".form")[2]).find("#m_flag").val(m_flag);
						$(".nav li:eq(2)").click();
					}else{
						var seurl=url[1].split("&");
						var namekey=seurl[0].split("=")[0];
						if(namekey=="type"){
							seeds_id=seurl[1].split("=")[1];
							$(".find:eq(0)").click();
						}else if(namekey!="ver"){
							var sear=url[1].split("=")[1];
							$("#finded").find("#searchKey").val(sear);
							$(".form").eq(2).find("#searchKey").val(sear);
							var tabs= $(".tabs-content:eq(2)");
							$(".nav li").removeClass("active");
							$(".nav li:eq(2)").addClass("active");
							$(".tabs-content").hide();
							$("#finding").hide();
							$("#finded").show();
							tabs.show();
							var item=$.trim(tabs.find("#list").html());
							if (item=="") {
								$("#finded").find(".find").click();
							}
							$("#allcheck,#saveOrder").hide();
						}else{
							$(".find:eq(0)").click();
						}
					}
				}
			}else{
				$(".find:eq(0)").click();
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
			/////////////////////
			var handleindex=0;
			$(".btn-default,.close").click(function(){
				$("#modal_smsSelect,#houyun_Select").hide();
				handleindex =0;
			});
			$("#houyun_Select").find(".btn-primary").unbind("click");
			$("#houyun_Select").find(".btn-primary").click(function(){
				var NoticeStyle=$("input[name='NoticeStyle']:checked").val();
				$("#modal_smsSelect,#houyun_Select").hide();
				handleindex =0;
				pop_up_box.postWait();
				var wuliufs=$("#houyun_Select").find("select:eq(0)").val();//物流方式
				var wuliudx=$("#houyun_Select").find("select:eq(1)").val();//物流送货对象
				wuliufs=wuliufs+","+$("#didian").val();
				wuliufs=wuliufs+","+$("#tihuoDate").val();
				var st_auto_no=$("#houyun_Select").find("#st_auto_no").html();
				 $.post("../supplier/noticeGysWuliu.do",{
					 "wuliufs":wuliufs,
					 "wuliudx":wuliudx,
					 "m_flag":9,
					 "title":"采购订单物流消息通知",
					 "description":"@comName采购@clerkName,已经提交物流,请尽快安排发货,订单编号:"+st_auto_no,
					 "item_id":$("#houyun_Select").find("#item_id").html(), 
					 "imgName":"driveShou.png",
					 "st_auto_no":st_auto_no, 
					 "index":NoticeStyle
				 },function(data){
					 pop_up_box.loadWaitClose();
					 
				 });
			});
			///////////////////{"item_id":$.trim(n.item_id),"st_auto_no":$.trim(n.st_auto_no),"item_name":$.trim(n.item_name)},
			$("#tzanpai").click(function(){
				var chekcs=$(".tabs-content:eq(2)").find("#list input[type='checkbox']:checked"); 
				if (chekcs&&chekcs.length>0) {
					var orders=[];
					for (var i = 0; i < chekcs.length; i++) {
						var item_id=$(chekcs[i]).parents(".dataitem").find("#item_id").html();
						var seeds_id=$(chekcs[i]).parents(".dataitem").find("#seeds_id").val();
						var mps_id=$(chekcs[i]).parents(".dataitem").find("#mps_id").val();
						var st_auto_no=$(chekcs[i]).parents(".dataitem").find("#st_auto_no").html();
						var item_name=$(chekcs[i]).parents(".dataitem").find("#item_name").html();
						var json=JSON.stringify({"item_id":item_id,"seeds_id":seeds_id,"mps_id":mps_id,"st_hw_no":st_auto_no});
						orders.push(json);
					}
					pop_up_box.postWait();
					$.get("../orderTrack/noticeAnPaiWuliu.do",{//通知安排物流拉货
						"orders":"["+orders.join(",")+"]",
						"m_flag":9,
						"msg":"采购人员已向供应商核实有货,请核实物流到供应商提货!",
						"description":""
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("通知成功!");
							$(".find:eq(2)").click();
						} else {
							if (data.msg) {
								pop_up_box.showMsg("通知错误!" + data.msg);
							} else {
								pop_up_box.showMsg("通知错误!");
							}
						}
					});
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
				
			});
			//////////////////////////
			$("#saveOrder").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				var tabs= $(".tabs-content:eq("+lia+")");
				var chekcs=tabs.find("#list input[type='checkbox']:checked");
				if (chekcs&&chekcs.length>0) {
					var b=true;
					for (var i = 0; i < chekcs.length; i++) {
					var vendor_id=$(chekcs[i]).parents(".dataitem").find("#vendor_id").html();
					if(vendor_id==""){
						pop_up_box.showMsg("请选择供应商!");
						b=false;
						break;
					}
					}
					if(b){
//						$("#modal_smsSelect").show();
						saveOrder(0);
					}
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
			function saveOrder(index){
				var lia = $(".nav li").index($(".nav .active"));
				var tabs= $(".tabs-content:eq("+lia+")");
				var plan_end_date=$.trim($(".tabs-content").eq(lia).find("input[name='plan_end_date']").val());
				if(plan_end_date==""){
					pop_up_box.showMsg("请输入预计完成时间");
					return;
				}
				var chekcs=tabs.find("#list input[type='checkbox']:checked"); 
				var item_ids=[];
				var vendorId="";
				var vendors=[];
				for (var i = 0; i < chekcs.length; i++) {
					var item_id=$(chekcs[i]).parents(".dataitem").find("#item_id").html();
					item_id=$.trim(item_id); 
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
						var ivt_oper_listing=item.find("#ivt_oper_listing").html();
						var pack_unit=$.trim(item.find("#pack_unit").html());//换算数量
						var casing_unit=item.find("#casing_unit").html();//包装单位
						var item_unit=item.find(".item_unit").html();//基本单位
						var sum_si=item.find("#sum_si").html();// 
						var movtel=$.trim(item.find("#gys_movtel").html());//供应商手机
						var corp_sim_name=$.trim(item.find("#gys_sim_name").html());//供应商手机
						var weixinID=$.trim(item.find("#weixinID").html());//供应商微信通讯录账号
						var vendor_id=$.trim(item.find("#vendor_id").html());//供应商
						var c_memo=$.trim(item.find("#c_memo_inp").val());//供应商
						var itemdata={
								"ivt_oper_listing":ivt_oper_listing,
								"item_id":item_id, 
								"c_memo":c_memo, 
								"pronum":pronum,
								"pack_unit":pack_unit,
								"casing_unit":casing_unit,
								"item_unit":item_unit,
								"sum_si":sum_si,
								"item_cost":item_cost,
								"vendor_id":vendor_id,
								"corp_sim_name":corp_sim_name,
								"weixinID":weixinID,
								"movtel":movtel
								};
						item_ids.push(JSON.stringify(itemdata)); 
					}
				}
				if(item_ids.length>0){
					pop_up_box.postWait();
					$("#saveOrder").attr("disabled", "disabled");
					$.post("savePurchasingOrder.do",{
						"item_ids":"["+item_ids.join(",")+"]",
						"cgt_day":plan_end_date,
						"type":index,
						"headship":"采购经理",
						"lia":lia,
						"len":item_ids.length
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("订单提交成功",function(){
								$(".find").eq(lia).click();
							});
						}else{
							pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
						}
						$("#saveOrder").removeAttr("disabled");
					}); 
				}else{
					pop_up_box.showMsg("请选择采购产品!");
				}
			} 
			
			
});
