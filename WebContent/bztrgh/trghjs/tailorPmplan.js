var tabsIndex=0;	
$(function(){
	var tabs0=$(".tabs-content:eq(0)");
	var tabs1=$(".tabs-content:eq(1)");
	$(".box-head").find(".nav li").click(function() {
		var n = $(".box-head").find(".nav li").index(this);
		$(".box-head").find(".nav li").removeClass('active');
		$(this).addClass('active'); 
		$(".tabs-content").hide(); 
		$(".tabs-content").eq(n).show(); 
		tabsIndex = n;
		if (n == 1) {
			if ($.trim($(".orderbox:eq(1)").html())=="") {
				tailorOrderpmplan.loadData();
			}
			$("#save").parent().hide();
		}else{
			$("#save").parent().show();
		}
	});
	$(".box-head").find(".nav li").removeClass("active");
	$(".box-head").find(".nav li:eq(0)").addClass("active");
	tailorOrder.init();
	$(".find").click(function(){
		if (tabsIndex==0) {
			$(".orderbox:eq(0)").html("");
			tailorOrder.page=0;
			tailorOrder.count=0;
			tailorOrder.loadData();
		}else{
			tailorOrderpmplan.page=0;
			tailorOrderpmplan.count=0;
			$(".orderbox:eq(1)").html("");
			tailorOrderpmplan.loadData();
		}
	});
	$(".find:eq(0)").click();
	$(".select").click(function() {//选择部门
		if($.trim($(".modal .modal-title").html())=="部门选择"){
			$(".modal,.modal-cover").show();
			dept.init(function(){
				if (tabsIndex==0) {
					$(".verify #deptId").val(treeSelectId);
					$(".verify #dept_name").html(treeSelectName);
				}else{
					tabs1.find("#deptId").val(treeSelectId);
					tabs1.find("#dept_name").html(treeSelectName);
				}
			});
		}else{
			$.get("../manager/getDeptTree.do", {
				"type" : "dept"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				dept.init(function(){
					if (tabsIndex==0) {
						$(".verify #deptId").val(treeSelectId);
						$(".verify #dept_name").html(treeSelectName);
					}else{
						tabs1.find("#deptId").val(treeSelectId);
						tabs1.find("#dept_name").html(treeSelectName);
					}
				});
			});
		}
	});
	var addindex=0;
	$(window).scroll(function(){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (tabsIndex==0) {
					if (tailorOrder.page==tailorOrder.totalPage) {
					}else{
						tailorOrder.page+=1;
						tailorOrder.loadData();
						addindex=0;
					}
				}else{
					if (tailorOrderpmplan.page==tailorOrderpmplan.totalPage) {
					}else{
						tailorOrderpmplan.page+=1;
						tailorOrderpmplan.loadData();
						addindex=0;
					}
				}
			}
		}
	});
//	$("body").append("<div class='back-top' id='scroll'></div>");
});	

var tailorOrder={
		page:0,totalPage:0,count:0,
		init:function(){
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd");
			$(".verify #d4311").val(nowStr);
			//提交生产计划点击事件
		   $('#save').click(function(){
			   var prs=$(".pro-checked");
			   if(prs.length>0){
				   $('.verify').toggle();
				   if($('.verify').show()){
					   $('.close').show();
					   $("body").css("overflow","hidden");
				   }else{
					   $('.close').hide();
					   $("body").css("overflow","visible");
				   }
			   }else{
				   pop_up_box.showMsg("请至少选择一个订单");
			   }
		   });
		   $(".pro-check").click(function(){
			   var b=$(this).hasClass("pro-checked");
				if(b){
					$(".pro-check").removeClass("pro-checked");
				}else{
					$(".pro-check").addClass("pro-checked");
				}
		   });
		   $('.close').click(function(){
			   $('.verify').hide();
			   $('.close').hide();
			   $("body").css("overflow","visible");
		   });
			$(".verify .btn-danger:eq(0)").click(function(){
					if($.trim($(".verify #d4312").val())==""){
						pop_up_box.showMsg("请选择计划交货日期", function(){
							$(".verify #d4312").focus();
						});
					}else{
						var orders=$(".pro-checked");
						var orderlist=[];
						for (var i = 0; i < orders.length; i++) {
							var order=$(orders[i]).parents(".orderbox01");
							var item_id=$.trim(order.find("#item_id").html());
							var orderNo=$.trim(order.find("#orderNo").html()); 
							var customer_id=$.trim(order.find("#customer_id").html()); 
							orderlist.push(JSON.stringify({"orderNo":orderNo,"item_id":item_id,"customer_id":customer_id}));
						}
						pop_up_box.postWait();
						 $('.verify').hide();
						   $('.close').hide();
						   $("body").css("overflow","visible");
						$.post("../pm/addProductionPlan.do",{
							"batch_mark":$.trim($(".verify #batch_mark").val()),
							"dept_id":$.trim($(".verify #deptId").val()),
							"plan_end_date":$.trim($(".verify  input[name='plan_end_date']").val()),
							"sd_order_id":$.trim($(".verify #sd_order_id").val()),
							"JHSL":1,
							"orderlist":"["+orderlist.join(",")+"]"
						},function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("提交成功!",function(){
									$(".find:eq(0)").click();
								});
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
						$("#pmmodal").hide();
					}
			});
		},addItem:function(data){
			var orderitem=$("#item");
				if(data&&data.rows&&data.rows.length>0){
					$.each(data.rows,function(i,n){
						var item=$(orderitem.html());
						$(".orderbox:eq(0)").append(item);
						item.find("#orderNo").html($.trim(n.ivt_oper_listing));
						item.find("#com_id").html($.trim(n.com_id));
						item.find("#item_id").html($.trim(n.item_id));
						item.find("#customer_id").html($.trim(n.customer_id));
						item.find("#corp_name").html("客户名称:"+$.trim(n.corp_name));
						if (n.so_consign_date) {
							var now = new Date(n.so_consign_date);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
						}
						item.find("#so_consign_date").html(n.so_consign_date);
						if(n.info){
							item.find("#demandInfo").html(n.info.demandInfo);
							item.find("#deliveryDate").html(n.info.deliveryDate);
							item.find(".swiper-wrapper").html("");
							$.each(n.imgs,function(j,m){
								var imghtml=$('<div class="swiper-slide"><img class="center-block"></div>');
								item.find(".swiper-wrapper").append(imghtml);
								imghtml.find("img").attr("src",".."+m);
								imghtml.click(function(){
									pop_up_box.showImg(".."+m);
								});
							});
						}
						item.find(".pro-check").click(function(){
							var b=$(this).hasClass("pro-checked");
							if(b){
								$(this).removeClass("pro-checked");
							}else{
								$(this).addClass("pro-checked");
							}
						});
					});
					tailorOrder.totalPage=data.totalPage;
					tailorOrder.count=data.totalRecord;
					var mySwiper = new Swiper ('.swiper-container', {
						loop: true,
						slidesPerView : 3,
						centeredSlides : true
					})
			}
			
		},loadData:function(){
			pop_up_box.loadWait();
			$.get("../tailorMade/getTailorMadeOrderPage.do",{
				"pm":"pm",
//				"st":"开始生产",
				"searchKey":$.trim($(".input-group:eq(0)>#searchKey").val()),
				"page":tailorOrder.page,
				"count":tailorOrder.count
			},function(data){
				pop_up_box.loadWaitClose();
				tailorOrder.addItem(data);
			});
		}
}
var tailorOrderpmplan={
		page:0,totalPage:0,count:0,
		addItem:function(data){
			var orderitem=$("#scjhitem");
			if(data&&data.rows&&data.rows.length>0){
				$.each(data.rows,function(i,n){
					var item=$(orderitem.html());
					$(".orderbox:eq(1)").append(item);
					item.find("#orderNo").html($.trim(n.ivt_oper_listing));//生产计划单号
					item.find("#com_id").html($.trim(n.com_id));
					item.find("#auto_mps_id").html($.trim(n.auto_mps_id));//订单编号
					item.find("#PH").html($.trim(n.PH));//排产编号
					item.find("#dept_name").html($.trim(n.dept_name));//生产车间
					item.find("#corp_name").html($.trim(n.corp_name));//客户名称
//					if (n.plan_end_date) {
//						var now = new Date(n.plan_end_date);
//						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
//					}
					item.find("#send_date").html(n.send_date);
					item.find("#plan_end_date").html(n.plan_end_date);
					item.find("#so_consign_date").html(n.so_consign_date);
					item.find(".pro-check").hide();
					if(n.info){
						item.find("#demandInfo").html(n.info.demandInfo);
						item.find("#deliveryDate").html(n.info.deliveryDate);
						item.find(".swiper-wrapper").html("");
						$.each(n.imgs,function(j,m){
							var imghtml=$('<div class="swiper-slide"><img class="center-block"></div>');
							item.find(".swiper-wrapper").append(imghtml);
							imghtml.find("img").attr("src",".."+m);
							imghtml.click(function(){
								pop_up_box.showImg(".."+m);
							});
						});
					}
					item.find('.look').click(function(){
						$(this).parent().find('.orderbox01_bottom').slideToggle();
						var b=$(this).find('.center-block>div').eq(0).hasClass("arrows02");
						if (b) {
							$(this).find('.center-block>div').eq(0).removeClass("arrows02");
							$(this).find('.center-block>div').eq(1).text('点击查看订单状态')
						}else {
							$(this).find('.center-block>div').eq(0).addClass("arrows02");
							$(this).find('.center-block>div').eq(1).text('点击收起订单状态')
						}
					})
				});
				tailorOrderpmplan.totalPage=data.totalPage;
				tailorOrderpmplan.count=data.totalRecord;
				var mySwiper = new Swiper ('.swiper-container', {
					loop: true,
					slidesPerView : 3,
					centeredSlides : true
				})
			}
			
		},loadData:function(){
			pop_up_box.loadWait();
			$.get("../pm/getProductionPlanTailorInfo.do",{
//				"sd_order_id":$.trim($("#sd_order_id").val()),
//				"batch_mark":$.trim($("#batch_mark").val()),
				"send_date":$.trim($("#d4311").val()),
				"dept_id":$.trim($("#deptId").val()),
				"plan_end_date":$.trim($("#d4312").val()),
				"searchKey":$.trim($(".input-group:eq(1)>#searchKey").val()),
				"page":tailorOrderpmplan.page,
				"count":tailorOrderpmplan.count
			},function(data){
				pop_up_box.loadWaitClose();
				tailorOrderpmplan.addItem(data);
			});
		}
}
