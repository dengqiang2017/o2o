$(function(){
    ////////////////获取流程名称列表////////
    $.get("../customer/getProcessNameList.do",function(data){
    	ordercenter.init(data);
    });
});
if(window.location.href.split("?")==1){
	window.location.href=window.location.href+"?ver="+math
}
var ordercenter={
		init:function(processNames){
			var page={"0":0,"1":0,"2":0,"3":0};
			var count={"0":0,"1":0,"2":0,"3":0};
			var totalPage={"0":0,"1":0,"2":0,"3":0};
			function page0(index){
				page[index]=0;
		        count[index]=0;
		        totalPage[index]=0;
			}
			var pageindex=0;
			$('.cut-page>ul>li').eq(0).click(function(){
				$('.orderlist').css({display:'none'});
		        $('.orderlist:eq(0)').css({display:'block'});
		        $('.title1_1').removeClass('title1_1').addClass('title1');
		        $('.title2').removeClass('title2').addClass('title2_2');
		        $('.title3').removeClass('title3').addClass('title3_3');
		        $('.title4').removeClass('title4').addClass('title4_4');
		        $('.cut-page>ul>li>span').removeClass('span_color');
		        $('.cut-page>ul>li span').eq(0).addClass('span_color');
//				$('.search').show();
		        page0(0);
		        loadData(0);
		        pageindex=0;
		    });
		    $('.cut-page>ul>li').eq(1).click(function(){
		    	$('.orderlist').css({display:'none'});
		        $('.orderlist:eq(1)').css({display:'block'});
		        $('.title1').removeClass('title1').addClass('title1_1');
		        $('.title2_2').removeClass('title2_2').addClass('title2');
		        $('.title3').removeClass('title3').addClass('title3_3');
		        $('.title4').removeClass('title4').addClass('title4_4');
		        $('.cut-page>ul>li>span').removeClass('span_color');
		        $('.cut-page>ul>li span').eq(1).addClass('span_color');
//				$('.search').hide();
		        page0(1);
		        loadData(1);
		        pageindex=1;
		    });
		    $('.cut-page>ul>li').eq(2).click(function(){
		    	$('.orderlist').css({display:'none'});
		        $('.orderlist:eq(2)').css({display:'block'});
		        $('.title1').removeClass('title1').addClass('title1_1');
		        $('.title2').removeClass('title2').addClass('title2_2');
		        $('.title3_3').removeClass('title3_3').addClass('title3');
		        $('.title4').removeClass('title4').addClass('title4_4');
		        $('.cut-page>ul>li>span').removeClass('span_color');
		        $('.cut-page>ul>li span').eq(2).addClass('span_color');
				$('.search').hide();
		        page0(2);
		        loadData(2);
		        pageindex=2;
		    });
		    $('.cut-page>ul>li').eq(3).click(function(){
		    	$('.orderlist').css({display:'none'});
		        $('.orderlist:eq(3)').css({display:'block'});
		        $('.title1').removeClass('title1').addClass('title1_1');
		        $('.title2').removeClass('title2').addClass('title2_2');
		        $('.title3').removeClass('title3').addClass('title3_3');
		        $('.title4_4').removeClass('title4_4').addClass('title4');
		        $('.cut-page>ul>li>span').removeClass('span_color');
		        $('.cut-page>ul>li span').eq(3).addClass('span_color');
				$('.search').hide();
		        page0(3);
		        loadData(3);
		        pageindex=3;
		    });
		    $(".find").click(function(){
		    	loadData(pageindex);
		    	$('.allorderk_zz').hide();
		    });
		    //////////////////////
		    var param=window.location.href.split("?")[1];
		    if (!param) {
				param="type=0";
			}
		    var params=param.split("&");
		    var json={};
		    for (var i = 0; i < params.length; i++) {
				var key=params[i].split("=")[0];
				var val=params[i].split("=")[1];
				json[key]=val;
			}
		    $('.cut-page>ul>li').eq(json.type).click();
		    /**
		     * 获取待查询的订单状态
		     */
		    function getorderstate(index){
		    	if (index==1) {
		    		return getProcessIndex("安排司机");
				}else if (index==2) {
					return getProcessIndex("已发货").split("安排司机")[1]+"已发货";
				}else if(index==3){
					return "待评价";
				}else{
					return "";
				}
		    }
		    function getProcessIndex(txt){
		    	var name="";
		    	for (var i = 0; i < processNames.length; i++) {
		    		name+=processNames[i];
					if(processNames[i].indexOf(txt)>=0){
						break;
					}
				}
		    	return name;
		    }
		    ////////////
		    var orderitem=$("#orderitem");
		    function addItem(data,index){
		    	if(data&&data.rows&&data.rows.length>0){
		    		var listhtml=$(".orderitemlist").eq(index);
	    			$.each(data.rows,function(i,n){
	    				var item=$(orderitem.html());
	    				listhtml.append(item);
	    				item.find("#item_name>span").html($.trim(n.item_name));
	    				item.find("#sum_si>span").html(numformat2(n.sum_si));
	    				item.find("#sd_oq>span").html(n.sd_oq+"/"+n.item_unit);
	    				item.find("#orderNo").html(n.ivt_oper_listing);
	    				item.find("#Status_OutStore").html($.trim(n.Status_OutStore));
	    				item.find("#HYS").html($.trim(n.HYS));
	    				item.find("#com_id").html($.trim(n.com_id));
	    				item.find("#item_id").html($.trim(n.item_id));
	    				item.find("#seeds_id").html($.trim(n.seeds_id));
	    				var url="../product/productDetail.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
	    				item.find("#zcgm").attr("href",url);
	    				item.find(".list_a_img>img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
	    				item.find(".list_a_img>img").error(function(){
							$(this).remove();
						});
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
	    				
	    				count[index]=data.totalRecord;
	    				totalPage[index]=data.totalPage;
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
	    				item.find("#pjdd").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),
	    					"com_id":$.trim(n.com_id)},
	    					function(event){
	    						var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
	    						window.location.href="evaluate.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
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
//	    						window.location.href="order_tracking.html?orderNo="+event.data.orderNo
//	    						+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id+"&seeds_id="+event.data.seeds_id;
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
		    //选择多个司机
		    $("#xzsjall").click(function(){
		    	var listhtml=$(this).parents(".all_order").next();
		    	var checks=listhtml.find(".pro-checked");
		    	if(checks&&checks.length>0){
		    		var productList=[];
		    		var seeds_ids="";
		    		for (var i = 0; i < checks.length; i++) {
		    			var item=$(checks[i]).parents(".all_order_list");
		    			var orderNo=item.find("#orderNo").html();
		    			var item_id=item.find("#item_id").html();
		    			var com_id=item.find("#com_id").html();
		    			var seeds_id=item.find("#seeds_id").html();
		    			if (seeds_ids=="") {
		    				seeds_ids=seeds_id;
		    			}else{
		    				seeds_ids=seeds_id+","+seeds_ids;
		    			}
		    			productList.push(JSON.stringify({"orderNo":orderNo,"item_id":item_id,"com_id":com_id}));
		    		}
		    		var params={"orderlist":"["+productList.join(",")+"]","seeds_id":seeds_ids};
		    		ordercenter.selectDriveHtml(params,checks);
		    	}else{
		    		pop_up_box.showMsg("请选择一个产品!");
		    	}
		    });
		    //确认收货多个产品
		    $("#qrshall").click(function(){
		    	var listhtml=$(this).parents(".all_order").next();
		    	var checks=listhtml.find(".pro-checked");
		    	if(checks&&checks.length>0){
		    		var productList=[];
		    		var json={};
		    		var seeds_ids="";
		    		for (var i = 0; i < checks.length; i++) {
		    			var item=$(checks[i]).parents(".all_order_list");
		    			var orderNo=item.find("#orderNo").html();
		    			var item_id=item.find("#item_id").html();
		    			var item_name=item.find("#item_name").html();
		    			var com_id=item.find("#com_id").html();
		    			json.orderNo=orderNo;
		    			json.item_id=item_id;
//								json.item_name=item_name;
		    			json.com_id=com_id;
		    			json.Status_OutStore="已结束";
		    			productList.push(JSON.stringify(json));
		    			var seeds_id=item.find("#seeds_id").html();
		    			if (seeds_ids=="") {
		    				seeds_ids=seeds_id;
		    			}else{
		    				seeds_ids=seeds_id+","+seeds_ids;
		    			}
		    		}
		    		var params={"orderlist":"["+productList.join(",")+"]","seeds_id":seeds_ids};
		    		params.headship="内勤";
		    		params.title="客户已收货通知";
		    		params.addName="description";
		    		params.description="订单产品已确认验收,收货人:@customerName";
//	    					params.description="订单编号:"+productList[0].orderNo+",产品名称:"+productList[0].item_name+"...";
		    		pop_up_box.postWait();
		    		$.get("../orderTrack/confimShouhuo.do",params,function(data){
		    			pop_up_box.loadWaitClose();
		    			if (data.success) {
		    				pop_up_box.toast("确认收货成功,", 500);
		    				loadData(2);
		    				window.location.href="deal_success.html";//?["+productList.join(",")+"]";
		    			} else {
		    				if (data.msg) {
		    					pop_up_box.showMsg("保存错误!" + data.msg);
		    				} else {
		    					pop_up_box.showMsg("保存错误!");
		    				}
		    			}
		    		});
		    	}else{
		    		pop_up_box.showMsg("请选择一个产品!");
		    	}
		    });
		    
		    function loadData(index){
		    	pop_up_box.loadWait();
		    	$.get("../customer/orderTrackingRecord.do",{
		    		"orderstate":getorderstate(index),
		    		"searchKey":$.trim($("#searchKey").val()),
		    		"beginDate":$(".Wdate:eq(0)").val(),
		    		"endDate":$(".Wdate:eq(1)").val(),
		    		"page":page[index],
					"count":count[index]
		    	},function(data){
		    		pop_up_box.loadWaitClose();
		    		var listhtml=$(".orderitemlist").eq(index);
		    		listhtml.html("");
		    		addItem(data,index);
		    	});
		    }
		    var addindex=0;
			$(window).scroll(function(){
				if (addindex==0) {
					if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
						addindex=1;
						if (page[pageindex]==totalPage[pageindex]) {
						}else{
							pop_up_box.loadWait();
							page[pageindex]+=1;
							pop_up_box.loadWait();
					    	$.get("../customer/orderTrackingRecord.do",{
					    		"orderstate":getorderstate(pageindex),
					    		"page":page[pageindex],
								"count":count[pageindex]
					    	},function(data){
					    		pop_up_box.loadWaitClose();
					    		addItem(data,pageindex);
					    	});
						}
					}
				}
		     });
			///////////////////////
			$(".all_order").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
		        var b=$(this).hasClass("pro-checked");
		        var tab=$(this).parents(".all_order").next();
		        if (b) {
		        	$(this).removeClass("pro-checked");
		        	tab.find(".pro-check").removeClass("pro-checked");
		        }else{
		        	$(this).addClass("pro-checked");
		        	tab.find(".pro-check").addClass("pro-checked");
		        }
		    });
		},selectDriveHtml:function(params,t){
	    	var show_check_driver=$("#show_check_driver");
			if(show_check_driver.length<=0){
				$.get("check_driver.html",function(data){
					$("#orderList").after(data);
					$("#orderList").hide();
					driveselect.init(params,t);
				})
			}else{
				$("#orderList").hide();
				show_check_driver.show();
				driveselect.init(params,t);
			}
	    }
}