$(function(){
//计算前期需要支付的金额的百分比
	var payPercentage=100;
	var customerName="";
	$.get("../tailorMade/getPayPercentage.do",function(data){
		payPercentage=parseFloat(data.payPercentage)/100;
		customerName=data.corp_name;
		if($.trim(data.ifUseCredit)=="否"){//是否尅打欠条
			$(".verify_02").find("li:eq(2)").hide();
		}else{
			$(".verify_02").find("li:eq(2)").show();
		}
	});
////////////////////
	var orderitem=$("#item");
	var page=0;
	var totalPage=0;
	var count=0;
	var params={};
	function addItem(data){
		if(data&&data.rows&&data.rows.length>0){
			$.each(data.rows,function(i,n){
				var item=$(orderitem.html());
				$(".orderlist").append(item);
				item.find("#orderNo").html($.trim(n.ivt_oper_listing));
				item.find("#com_id").html($.trim(n.com_id));
				item.find("#Status_OutStore").html($.trim(n.Status_OutStore));
				item.find("#sum_si").html(numformat2(n.sum_si));
				if (n.so_consign_date) {
					var now = new Date(n.so_consign_date);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
				}
				item.find("#so_consign_date").html(n.so_consign_date);
				if(n.info){
					item.find("#demandInfo").html(n.info.demandInfo);
					item.find("#deliveryDate").html(n.info.deliveryDate);
					item.find("#imgs").html("");
					$.each(n.imgs,function(j,m){
						var imghtml=$('<div class="swiper-slide"><img onclick="pop_up_box.showImg(this.src)"></div>');
						item.find("#imgs").append(imghtml);
						imghtml.find("img").attr("src",".."+m);
					});
				} 
				var param={"item_id":$.trim(n.item_id),"orderNo":$.trim(n.ivt_oper_listing),"com_id":$.trim(n.com_id)};
				if(n.Status_OutStore=="已发货"){
					item.find(".order_04 button").show();
					item.find(".order_04 button").text("确认收货");
					item.find(".order_04 button").click(param,function(event){
						///1.计算是否有需要支付的尾款
						///1.1直接收货
						event.data.title="客户已收货通知";
						event.data.description="订单产品已收货,订单编号:"+event.data.orderNo+",收货人:@customerName";
						if(payPercentage==1){
							confimShouhuo(event.data);
						}else{
							//1.2计算支付金额
							var zje= parseFloat(item.find(".details").parent().find("#sum_si").html());//订单总金额
							zje=numformat2(zje*(1-payPercentage));
							//1.2
							$(".verify_01>span:eq(0)").html(zje);
							//1.3 显示支付界面
							$(".verify").show();
							params=event.data;
						}
					});
				}else if(n.pingjiaed){
					item.find(".order_04 button").show();
					item.find(".order_04 button").text("查看评价");
					item.find(".order_04 button").click(param,function(event){
						window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
					});
				}else if(n.Status_OutStore=="已结束"){
					item.find(".order_04 button").show();
					item.find(".order_04 button").text("评价订单");
					item.find(".order_04 button").click(param,function(event){
						window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
					});
				}
				item.find('.look').click({"item_id":$.trim(n.item_id),"orderNo":$.trim(n.ivt_oper_listing),"com_id":$.trim(n.com_id),"pingjiaed":$.trim(n.pingjiaed)},function(event){
					$(this).parent().find('.details').slideToggle();
					var b=$(this).find('.center-block>div').eq(0).hasClass("arrows02");
					if (b) {
						$(this).find('.center-block>div').eq(0).removeClass("arrows02");
						$(this).find('.center-block>div').eq(1).text('点击查看订单状态')
					}else{
						$(this).find('.center-block>div').eq(0).addClass("arrows02");
						$(this).find('.center-block>div').eq(1).text('点击收起订单状态')
						var t=$(this).parents(".item");
						$.get("../orderTrack/getOrderHistory.do",event.data,function(data){
							t.find(".details>ul").html("");
							var hisitem;
							var historyitem=$("#historyitem");
							for (var i = 0; i < data.length; i++) {
								var n=data[i];
								var item=$(historyitem.html());
								if (i==0) {
									t.find(".details>ul").append(item);
								}else{
									hisitem.before(item);
								}
								hisitem=item;
								item.find("ul").find("li:eq(0)").html(n.content);
								item.find("ul").find("li:eq(1)").html(n.time);
								if(i==0){
									item.find("ul").find("li:eq(0)").html(n.content+",您的订单已支付完成，请您耐心等待我们收款确认");
								}
							}
							////////////////////////////
//		            		var txt=t.find(".details>ul").text();
//		            		if(txt.indexOf("已评价")>0){
//		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">查看评价</button>');
////		            			t.find(".order_04 button").show();
////		            			t.find(".order_04 button").text("查看评价");
//		            			t.find(".details>ul").find("ul:eq(0)").click(event.data,function(event){
//		            				window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
//		            			});
//		            		}else if(txt.indexOf("已收货")>0){
//		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">评价订单</button>');
////		            			t.find(".order_04 button").show();
////		            			t.find(".order_04 button").text("评价订单");
//		            			t.find(".details>ul").find("ul:eq(0)").click(event.data,function(event){
//		            				window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
//		            			});
//		            		}else if(txt.indexOf("确认收货")>0){
//		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">追加评价</button>');
////		            			t.find(".order_04 button").text("追加评价");
////		            			t.find(".order_04 button").show();
//		            			t.find(".details>ul").find("ul:eq(0)").click(event.data,function(event){
//		            				window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
//		            			});
//		            		}
//		            			else if(txt.indexOf("已发货")>0||txt.indexOf("出库")>0){
////		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">确认收货</button>');
//		            			t.find(".order_04 button").show();
//		            			t.find(".order_04 button").text("确认收货");
//		            			t.find(".order_04 button").click(event.data,function(event){
//		            				///1.计算是否有需要支付的尾款
//		            				///1.1直接收货
//		            				event.data.title="客户已收货通知";
//			    					event.data.description="订单产品已收货,订单编号:"+event.data.orderNo+",收货人:@customerName";
//		            				if(payPercentage==1){
//		            					confimShouhuo(event.data);
//		            				}else{
//		            					//1.2计算支付金额
//		            					var zje= parseFloat(t.find(".details").parent().find("#sum_si").html());//订单总金额
//		            					zje=numformat2(zje*(1-payPercentage));
//		            					//1.2
//		            					$(".verify_01>span:eq(0)").html(zje);
//		            					//1.3 显示支付界面
//		            					$(".verify").show();
//		            					params=event.data;
//		            				}
//		            			});
//		            		}
							///////////////////////////////
						});
					}
				});
			});
			totalPage=data.totalPage;
			count=data.totalRecord;
			var mySwiper = new Swiper ('.swiper-container', {
				loop: true,
				slidesPerView : 3,
				centeredSlides : true
			})
		}
	}
	$(".verify_02 li").click(function(){
		var payzje=$(".verify_01>span").html();
		var orderparam={
				"amount":payzje 
		};
		var verify_02=$.trim($(this).html());
		if(verify_02=="打欠条"){
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
			$.cookie("customerName",customerName,{path:"/", expires: 1 });
			$.cookie("date",nowStr,{path:"/", expires: 1 });
			$.cookie("ddje",payzje,{path:"/", expires: 1 });
			$.cookie("ddzje",payzje,{path:"/", expires: 1 });
			$.cookie("order","tailorOrder",{path:"/", expires: 1 });
			$.cookie("ljqk",payzje,{path:"/", expires: 1 });
			window.location.href="../customer/iou.do";
		}else{
			pop_up_box.postWait();
			orderparam.paystyle="JS001";
			orderparam.account=verify_02;
			orderparam.sum_si_origin=verify_02;
			orderparam.paystyletxt="账上款";
			$.post("../customer/savePaymoney.do",orderparam,function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						uploadPingz.init(data.msg,function(){
							confimShouhuo(params);
						});
						$(".modal-cover-first,.modal-first").show();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}
	});
	function confimShouhuo(jsons){
		jsons.Status_OutStore="已结束";
		jsons.headship="内勤";
		pop_up_box.postWait();
		$.post("../orderTrack/confimShouhuo.do",jsons,function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				window.location.href="comment.html?orderNo="+jsons.orderNo+"&item_id="+jsons.item_id+"&com_id="+jsons.com_id;
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	}
	$(".orderlist").html("");
//	var type=window.location.href.split("?")[1];
	var st="";
	var type=getQueryString("type");
//	if(type&&type.indexOf("ver")<0){
//	}
//		type=type.split("=")[1];
	if(type){
		if(type==1){
			st="开始生产";
			$(".orient_02,.header,title").html("我的订单");
		}else if(type==2){
			st="已发货";
			$(".orient_02,.header,title").html("待收货订单");
		}else{
			st="待评价";
			$(".orient_02,.header,title").html("待评价订单");
		}
	}
	function loadData(){
		pop_up_box.loadWait();
		$.get("../tailorMade/getTailorMadeOrderPage.do",{
			"st":st,
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	}
//////查询//begin//
	$.get("query.jsp",function(data){
		$("body").append(data);
		var now = new Date();
		var nowStr = now.Format("yyyy-MM-dd"); 
		$(".input-sm").val("");
		var onedays=nowStr.split("-");
		$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01");
		$(".Wdate:eq(1)").val(nowStr);
		/////
		loadData();
		////////
		$("#query").click(function(){
			$("input").removeAttr("disabled");
			$("#findlistpage").show();
			$("#listpage").hide();
		});
		$("#findlistpage .closed").click(function(){
			$("#findlistpage").hide();
			$("#listpage").show();
		});
		$(".find").click(function(){
			$(".orderlist").html("");
			page=0;count=0;
			loadData();
			$("#findlistpage").hide();
			$("#listpage").show();
		});
	});
//////查询//end/////
	var addindex=0;
	$(window).scroll(function(){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (page==totalPage) {
				}else{
					pop_up_box.loadWait();
					page+=1;
					loadData();addindex=0;
				}
			}
		}
	});
});