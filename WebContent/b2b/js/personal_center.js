URLFiltering();
var personalCenter={
		init:function(){
		    $('.order_classify .col-xs-4').click(function(){
		        $('.order_classify .col-xs-4').removeClass('active');
		        $(this).addClass('active');
		        $('.order_list').html("");
		        loadData();
		    });
		    $('.order_list').niceScroll({cursoropacitymax: 0});
		function getorderstate(index){
			if(index==0){
				return "发货";
			}else if(index==1){
				return "已发货";
			}else{
				return "已结束";
			}
		}
		    ///
	    $(".order_list:eq(0)").html("");
			var type=getQueryString("type");
			if(type=="sh"){
				$('.order_classify .col-xs-4:eq(1)').click();
			}else{
				loadData();
			}
			function loadData(){
				var index=$('.order_classify .col-xs-4').index($(".order_classify .active"));
				pop_up_box.loadWait();
				 $(".order_list").html("");
				$.get("../customer/getOrderStateRecord.do",{
					"orderState":getorderstate(index)
				},function(data){
					pop_up_box.loadWaitClose();
					addItem(data,index);
				});
			}
		    function addItem(data,index){
		    	if(data&&data.length>0){
		    		$(".order_list").html("");
					$.each(data,function(i,n){
						var item=$($("#item").html());
						$(".order_list").append(item);
						item.find("#item_name").html($.trim(n.item_name));
						item.find("#item_name").attr("title",$.trim(n.item_name));
						item.find("#item_color").html($.trim(n.item_color)+" "+$.trim(n.item_type));
//						item.find("#sum_si>span").html(numformat2(n.sum_si));
						item.find("#sd_oq").html(n.sd_oq);
						item.find("#price").html(numformat2(n.sd_unit_price));
						item.find("#orderNo").html($.trim(n.ivt_oper_listing));
						item.find("#Status_OutStore").html($.trim(n.Status_OutStore));
						item.find("#HYS").html($.trim(n.HYS));
						item.find("#com_id").html($.trim(n.com_id));
						item.find("#item_id").html($.trim(n.item_id));
						if(n.memo_color){
							item.find("#memo_color").html($.trim(n.memo_color));
							item.find("#memo_color").click({"memo":$.trim(n.memo_color)},function(event){
								pop_up_box.showMsg(event.data.memo);
							});
						}else{
							item.find("#memo_color").parent().hide();
						}
						item.find("#seeds_id").html($.trim(n.seeds_id));
//		 				var url="commodity.jsp?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
						var url="commodity.jsp?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
						item.find("#zcgm").attr("href",url);
						item.find(".pic>img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
						item.find(".pic>img").error(function(){
							$(this).parents(".pic").remove();
						});
						if(index==0){//待发货
							item.find("#reminderDelivery").show();//提醒发货
							item.find("#reminderDelivery").click({
								"seeds_id":n.seeds_id,
								"orderNo":$.trim(n.ivt_oper_listing),
								"item_name":$.trim(n.item_name)
							},function(event){
								pop_up_box.postWait();
								$.post("../orderTrack/noticeNeiqing.do",{
									"headship":"内勤",
									"msg":"客户发货提醒",
									"seeds_id":event.data.seeds_id,
									"description":"@comName-@Eheadship-@clerkName:客户【@customerName】提醒您及时发货,产品名称:"+event.data.item_name+",订单编号:"+event.data.orderNo
								},function(data){
									pop_up_box.loadWaitClose();
									pop_up_box.toast("已提醒", 1000);
								});
							});
						}else if(index==1){//待收货
							item.find("#viewLogistics").show();//显示物流
							item.find("#confirmReceipt").show();//确认收货
							item.find("#viewLogistics").click({
								"item_name":$.trim(n.item_name),
								"item_color":$.trim(n.item_color),
								"seeds_id":n.seeds_id,
								"orderNo":$.trim(n.ivt_oper_listing),
								"item_id":$.trim(n.item_id),
								"com_id":$.trim(n.com_id),
								"Status_OutStore":$.trim(n.Status_OutStore),
								"sd_oq":n.sd_oq,
								"price":numformat2(n.sd_unit_price)
							},function(event){
								$("#wuliupage").find("#item_name").html(event.data.item_name);
								$("#wuliupage").find("#item_color").html(event.data.item_color);
								$("#wuliupage").find("#sd_oq").html(event.data.sd_oq);
								$("#wuliupage").find("#price").html(event.data.price);
								$("#wuliupage").find("#Status_OutStore").html(event.data.Status_OutStore);
								$("#infopage,.header:eq(0)").hide();
								$("#wuliupage,.header:eq(1)").show();
								$.get("../"+event.data.com_id+"/orderHistory/"+event.data.orderNo+"/"+event.data.item_id+".log",function(data){
									data="["+data.substr(0,data.length-1)+"]";
									data=$.parseJSON(data);
									$("#historylist").html("");
									var hisitem;
									for (var i = 0; i < data.length; i++) {
										var n=data[i];
										var item=$($("#historyitem").html());
										if (i==0) {
											$("#historylist").append(item);
										}else{
											hisitem.before(item);
										}
										hisitem=item;
										item.find("#time").html(n.time);
										item.find("#content").html(n.content);
										if(i==(data.length-1)){
											item.find(".state_img02>img").attr("src","images/07_ring.png");
											item.find(".state_img02").addClass("state_img01");
											item.find(".li_margin02").addClass("li_margin");
										}
									}
								});
							});
						////确认收货
		    				item.find("#confirmReceipt").click({
		    					"orderNo":$.trim(n.ivt_oper_listing),
		    					"item_id":$.trim(n.item_id),
		    					"item_name":$.trim(n.item_name),
		    					"com_id":$.trim(n.com_id),
		    					"seeds_id":n.seeds_id
		    					},function(event){
		    					var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
		    					event.data.headship="内勤";
		    					event.data.Status_OutStore="已结束";
		    					event.data.title="客户已收货通知";
		    					event.data.description="订单编号:"+event.data.orderNo+",产品名称:"+event.data.item_name;
		    					pop_up_box.postWait();
		    					$.post("../orderTrack/confimShouhuo.do",event.data,function(data){
		    						pop_up_box.loadWaitClose();
		    						if (data.success) {
		    							pop_up_box.toast("确认收货成功,", 500);
		    							t.parents(".col-xs-12").remove();
//		    							window.location.href="evaluate.jsp?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
									} else {
										if (data.msg) {
											pop_up_box.showMsg("保存错误!" + data.msg);
										} else {
											pop_up_box.showMsg("保存错误!");
										}
									}
		    					})
		    				});
						}else{//待评价
							item.find("#evaluate,#evaluatemmsg").show();
//							window.location.href="evaluate.jsp?orderNo="+$.trim(n.orderNo)+"&item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
						}
						if(index==0){//全部订单
							item.find("#zcgm").show();
							if($.trim(n.Status_OutStore).indexOf("已结束")>=0){
							if(n.pingjiaed){
								item.find("#pjdd").html("查看评价");
							}else{
								item.find("#pjdd").html("评价");
							}
							item.find("#pjdd").show();
							}
							item.find("#showWuliu").html("查看订单");
							item.find("#showWuliu").show();
							item.find(".pro-check").parent().remove();
						}else if(index==1){
							if($.trim(n.Status_OutStore).indexOf("安排司机")>=0){
								item.find("#xzsj").show();
								item.find(".pro-check").parent().show();
							}else{
								item.find(".pro-check").parent().remove();
							}
							item.find("#showWuliu").html("查看订单");
							item.find("#showWuliu").show();
						}else if(index==2){
							if ($.trim(n.Status_OutStore)=="已发货") {
								item.find("#qrsh").show();
							}
							item.find("#showWuliu").show();
							item.find(".pro-check").parent().show();
						}else{
							item.find("#pjdd").show();
							item.find(".pro-check").parent().remove();
						}
						item.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
					        var b=$(this).hasClass("pro-checked");
					        if (b) {
					            $(this).removeClass("pro-checked");
					        }else{
					            $(this).addClass("pro-checked");
					        }
					    });
						////选择司机
						item.find("#xzsj").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),
							"com_id":$.trim(n.com_id),"seeds_id":n.seeds_id},
							function(event){
							var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
							ordercenter.selectDriveHtml(event.data,t);
						});
						////评价产品
						item.find("#evaluate").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),
							"com_id":$.trim(n.com_id)},
							function(event){
								var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
								window.location.href="evaluate.jsp?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
							});
						item.find("#showWuliu").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),
							"com_id":$.trim(n.com_id),"seeds_id":n.seeds_id},
							function(event){
								var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
								$.get("order_tracking.html?ver="+Math.random(),function(data){
									$("#orderList").hide();
									$("#orderinfo").html(data);
									tracking.init(event.data);
								});
//								window.location.href="order_tracking.html?orderNo="+event.data.orderNo
//								+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id+"&seeds_id="+event.data.seeds_id;
							});
						////确认收货
						item.find("#qrsh").click({
							"orderNo":$.trim(n.ivt_oper_listing),
							"item_id":$.trim(n.item_id),
							"item_name":$.trim(n.item_name),
							"com_id":$.trim(n.com_id),"seeds_id":n.seeds_id
							},function(event){
							var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
							event.data.headship="内勤";
							event.data.Status_OutStore="已结束";
							event.data.title="客户已收货通知";
							event.data.description="订单编号:"+event.data.orderNo+",产品名称:"+event.data.item_name;
							pop_up_box.postWait();
							$.post("../orderTrack/confimShouhuo.do",event.data,function(data){
								pop_up_box.loadWaitClose();
								if (data.success) {
									pop_up_box.toast("确认收货成功,", 500);
									window.location.href="deal_success.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
								} else {
									if (data.msg) {
										pop_up_box.showMsg("保存错误!" + data.msg);
									} else {
										pop_up_box.showMsg("保存错误!");
									}
								}
							})
						});
						
					});
				}
		    }
		}
}
/**
 * 设置客户信息
 * @param datainfo
 */
function setCustomerInfo(datainfo){
	$("#clerk_name").html(datainfo.corp_sim_name);
	var imgPath=datainfo.com_id+"/userpic/"+datainfo.customer_id+"/Pic_You.png";
	if(datainfo.weixin_img){
		$("#user_logo").attr("src",datainfo.weixin_img);
	}else{
		$("#user_logo").attr("src","../"+imgPath+"?ver="+Math.random());
	}
	try {
		if(!datainfo.corp_sim_name||parseInt(datainfo.corp_sim_name)>0){
			$("#corp_sim_name").val(datainfo.weixin_name);
			$("#clerk_name").html(datainfo.weixin_name);
		}
	} catch (e) {}
}
customer.getCustomerInfo(function(data){
	setCustomerInfo(data);
	personalCenter.init();
});