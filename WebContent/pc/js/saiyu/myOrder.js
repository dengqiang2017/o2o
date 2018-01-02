function backlist(){
	$("#itempage").html("");
	$("#orderlist").show();
	getContainerHtml("myOrder.do");
	$('a[data-title="title"]').html("我的订单");
	$("a[data-head]").unbind("click");
	$("a[data-head]").click(function(){
		window.location.href="../pc/index.html";
	});
	myOrder.loadData();
	try {
		clearInterval(clientAndEle.index);
	} catch (e) {}
}
function zaixianzixun(){
	pop_up_box.loadWait();
	$.get("sendChatClient.do",{
		"orderNo":$("#orderNo").val()
	},function(data){
		pop_up_box.loadWaitClose();
		$("#clientLiaotian").html(data);
		init(); 
		$('a[data-title="title"]').html("在线咨询");
	});
}
var myorder={
		nowPage:1,
		count:0,
		totalPage:0,
		init:function(){
//			 var nowPage=1;
//			 var count=0;
//			 var totalPage=0;
			try {
				if(window.location.href.split("?")[1]=="order"){
					$("#orderSelect").val("已发货");
				}
			} catch (e) {}
			$(".find").click(function(){
				myorder.nowPage=1;
				$(".row").html("");
				myorder.loadData();
			});
			$("#orderlist").find("#allcheck").unbind("click");
			$("#orderlist").find("#allcheck").bind("click",function(){
				var b=$(this).hasClass("pro-checked");
		        if (b) {
		        $("#orderlist").find(".pro-check").removeClass("pro-checked");
		        }else{
		        $("#orderlist").find(".pro-check").addClass("pro-checked");
		        }
			});
			//
			$("#diangongsbtn").click(function(){
				var pros=$("#orderlist").find(".pro-checked");
				if(pros&&pros.length>0){
					var orderNoList=[];
					for (var i = 0; i < pros.length; i++) {
						var pro=$(pros[i]);
						var orderNo=$.trim(pro.parent().find("ul>li:eq(0)").html());
						orderNoList.push(orderNo.split("编号:")[1]);
					}
					pop_up_box.loadWait();
					$.post("reservationElectrician.do",{
						"orderNo":orderNoList
					},function(data){
						pop_up_box.loadWaitClose();
						$('a[data-title="title"]').html("我的订单-提前预约电工");
						$("#orderlist").hide();
						$("#itempage").html(data);
						$("a[data-head]").unbind("click");
						$("a[data-head]").click(backlist);
						initNumInput();
					});
				}
			});
			//电工安装费支付
			$("#electrPay").click(function(){
				var pros=$("#orderlist").find(".pro-checked");
				if(pros&&pros.length>0){
					var orderNoList=[];
					for (var i = 0; i < pros.length; i++) {
						var pro=$(pros[i]);
						var orderNo=$.trim(pro.parent().find("ul>li:eq(0)").html());
						orderNoList.push(orderNo.split("编号:")[1]);
					}
					myorder.diangongpay(orderNo);
				}
			});
			myorder.loadData(); 
			var addindex=0;
			$(window).scroll(function(){
				if($("#orderlist").css("display")!="none"){
					if (addindex==0) {
						if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
							addindex=1;
							if (myorder.nowPage>myorder.totalPage) {
							}else{
								myorder.nowPage+=1;
								myorder.loadData();
							}
						}
					}
				}
		     });

		},
		loadData:function(){
			var itemhtml=$("#orderitem");
			if($("#orderlist").css("display")=="none"){
				return;
			} 
			pop_up_box.loadWait();
			$.get("getOrderPage.do",{
				"searchKey":$("#searchKey").val(),
				"beginDate":$("#store_date").val(),
				"elecState":$("#elecState").val(),
				"Status_OutStore":$("#orderSelect").val(),
				"page":myorder.nowPage,
				"count":myorder.count
			},function(data){
				pop_up_box.loadWaitClose();
				$.each(data.rows,function(i,n){
					var item=$(itemhtml.html());
					$(".row").append(item);
//					item.find("li:eq(1)").append(n.item_sim_name);
					item.find("li:eq(0)").append(n.ivt_oper_listing);
					item.find("li:eq(1)").append(new Date(n.so_consign_date).Format("yyyy-MM-dd"));
					item.find("li:eq(2)").append(n.sd_oq);
					item.find("li:eq(3)").append(n.Status_OutStore);
					if($.trim(n.Status_OutStore)=="已结束"){
						item.find("#pingjiabtn").show();
					}else if($.trim(n.Status_OutStore)=="已发货"){
						if(n.HYS_SDd02021){
							item.find("li:eq(3)").append(",司机:"+n.HYS_SDd02021);
						}
						item.find("#shouhuobtn").show();
					}else if($.trim(n.Status_OutStore)=="已结束"&&n.elecState==0){//elecState  -- 0-未预约,1-已预约,2-已安装,3-已支付,4-已确认评价
						item.find("#diangongPingjia").show();
					}else if($.trim(n.Status_OutStore)=="待支付"||$.trim(n.Status_OutStore)=="支付中"){
						item.find("#orderpay").show();
						item.find("#orderpay").click({"orderNo":n.ivt_oper_listing},function(event){
							var orderNo=event.data.orderNo;
							pop_up_box.loadWait();
							$.get("cashierPayment.do",{
								"orderNo":orderNo
							},function(data){
								pop_up_box.loadWaitClose();
								$('a[data-title="title"]').html("我的订单-订单支付");
								$("#orderlist").html("");
								$("#itempage").html(data);
								$("a[data-head]").unbind("click");
								$("a[data-head]").click(backlist);
							});
						});
					}else{}
					if(n.elecState==1){
						item.find("li:eq(4)").append("已预约");
//						item.find("#diangongPay").show();
					}else if(n.elecState==2){
						item.find("li:eq(4)").append("已安装未验收评价");
						item.find("#diangongPingjia").show();
					}else if(n.elecState==3){
						item.find("li:eq(4)").append("已验收未支付");
						item.find("#diangongPingjia").html("查看安装评价");
						item.find("#diangongPingjia").show();
						item.find("#diangongPay").show();
					}else if(n.elecState==4){
						item.find("li:eq(4)").append("已支付");
						item.find("#diangongPingjia").html("查看安装评价");
						item.find("#diangongPingjia").show();
					}else{
						item.find("#diangongbtn").show();
					}
					if(n.dianName){
						item.find("li:eq(5)").append(n.dianName+",电话：<a href='tel:"+n.dianPhone+"'>"+n.dianPhone+"</a>");
					}
					if(n.pingjia){
						item.find("#pingjiabtn").html(n.pingjia);
					}
					item.find("#pingjiabtn").click({"orderNo":n.ivt_oper_listing},function(event){
						var orderNo=event.data.orderNo;
						pop_up_box.loadWait();
						$.get("evaluation.do",{
							"orderNo":orderNo
						},function(data){
							pop_up_box.loadWaitClose();
							$('a[data-title="title"]').html("我的订单-订单评价");
							$("#orderlist").hide();
							$("#itempage").html(data);
							evaluation.init();
							$("a[data-head]").unbind("click");
							$("a[data-head]").click(backlist);
						});
					});
					//电工验收评价
					item.find("#diangongPingjia").click({"orderNo":n.ivt_oper_listing},function(event){
						var orderNo=event.data.orderNo;
						pop_up_box.loadWait();
						$.get("evaluation.do",{
							"type":"eval",
							"orderNo":orderNo
						},function(data){
							pop_up_box.loadWaitClose();
							$('a[data-title="title"]').html("我的订单-电工验收评价");
							$("#orderlist").hide();
							$("#itempage").html(data);
//							evaluation.init();
							$("a[data-head]").unbind("click");
							$("a[data-head]").click(backlist);
						});
					});
					item.find("#diangongPay").click({"orderNo":n.ivt_oper_listing},function(event){
						var orderNo=event.data.orderNo;
						myorder.diangongpay(orderNo);
					});
					//订单详情
					item.find("#orderdetailsbtn").click({"orderNo":n.ivt_oper_listing,"Status_OutStore":n.Status_OutStore},function(event){
						var orderNo=event.data.orderNo;
						var Status_OutStore=event.data.Status_OutStore;
						pop_up_box.loadWait();
						$.get("orderDetails.do",{
							"orderNo":orderNo,
							"Status_OutStore":Status_OutStore
						},function(data){
							pop_up_box.loadWaitClose();
							$('a[data-title="title"]').html("我的订单-订单详情");
							$("#orderlist").hide();
							$("#itempage").html(data);
							$("a[data-head]").unbind("click");
							$("a[data-head]").click(backlist);
						});
					});
					//预约电工
					item.find("#diangongbtn").click({"orderNo":n.ivt_oper_listing},function(event){
						var orderNo=event.data.orderNo;
						pop_up_box.loadWait();
						$.get("electricianNear.do",{
							"orderNo":orderNo
						},function(data){
							pop_up_box.loadWaitClose();
							$('a[data-title="title"]').html("实时预约电工");
							$("#orderlist").hide();
							$("#itempage").html(data);
						});
					});
					//确认收货
					item.find("#shouhuobtn").click({"orderNo":n.ivt_oper_listing,"Status_OutStore":n.Status_OutStore},function(event){
						var orderNo=event.data.orderNo;
						var Status_OutStore=event.data.Status_OutStore;
						pop_up_box.loadWait();
						$.get("orderDetails.do",{
							"orderNo":orderNo,
							"Status_OutStore":Status_OutStore
						},function(data){
							pop_up_box.loadWaitClose();
							$('a[data-title="title"]').html("我的订单-订单详情");
							$("#orderlist").hide();
							$("#itempage").html(data);
							$("a[data-head]").unbind("click");
							$("a[data-head]").click(backlist);
						});
//						var t=$(this);
//	 					if(confirm("是否确定收货")){
//							$.post("confimShouhuo.do",{"orderNo":event.data.orderNo},function(data){
//								if (data.success) {
//									pop_up_box.showMsg("提交成功!",function(){
//										var bg=t.parents(".div-bg");
//										bg.find("#shouhuobtn").hide();
//										bg.find("#diangongbtn").show();
//										bg.find("#pingjiabtn").show();
//										bg.find("li:eq(3)").html("已结束");
//									});
//								} else {
//									if (data.msg) {
//										pop_up_box.showMsg("提交错误!" + data.msg);
//									} else {
//										pop_up_box.showMsg("提交错误!");
//									}
//								}
//							});
//						}
					});
					item.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
						var b=$(this).hasClass("pro-checked");
						if (b) {
							$(this).removeClass("pro-checked");
						}else{
							$(this).addClass("pro-checked");
						}
					});
					item.find("#certificateBtn").click({"orderNo":$.trim(n.ivt_oper_listing)},function(event){
						var imgurl=$.trim($(".modal-body").find("#filepath").val());
						if(imgurl!=""){
							$.post("certificateImg.do",{
								"imgurl":imgurl,
								"orderNo":event.data.orderNo
							},function(data){
								if (data.success) {
									pop_up_box.showMsg("上传成功!",function(){
										backOa();
										$(".modal-cover-first,.modal-first").hide();
									});
								} else {
									if (data.msg) {
										pop_up_box.showMsg("上传错误!" + data.msg);
									} else {
										pop_up_box.showMsg("上传错误!");
									}
								}
							});
						}
					});
				});
				myorder.count=data.totalRecord;
				myorder.totalPage=data.totalPage;
			});
		
		},
		diangongpay:function(orderNo){
			pop_up_box.loadWait();
			$.get("diangongpay.do",{
				"orderNo":orderNo
			},function(data){
				pop_up_box.loadWaitClose();
				$('a[data-title="title"]').html("我的订单-电工安装费支付");
				$("#orderlist").hide();
				$("#itempage").html(data);
				diangongpay.init();
				$("a[data-head]").unbind("click");
				$("a[data-head]").click(backlist);
			});
		}
}
$(function(){myorder.init();});
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"filepath",
		"uploadFileSize":10
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		$("#filepath").val(imgurl);
		$(".modal-body").find("img").attr("src",".."+imgurl);
	});
}