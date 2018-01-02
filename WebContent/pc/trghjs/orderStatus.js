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
			 item.find('.look').click({"item_id":$.trim(n.item_id),"orderNo":$.trim(n.ivt_oper_listing),"com_id":$.trim(n.com_id)},function(event){
		            $(this).parent().find('.details').slideToggle();
		            var b=$(this).find('.center-block>div').eq(0).hasClass("arrows02");
		            if (b) {
		            	$(this).find('.center-block>div').eq(0).removeClass("arrows02");
		            	$(this).find('.center-block>div').eq(1).text('点击查看订单状态')
		            }else{
		            	$(this).find('.center-block>div').eq(0).addClass("arrows02");
		            	$(this).find('.center-block>div').eq(1).text('点击收起订单状态')
		            	var t=$(this).parent();
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
		            		if(t.find(".details>ul").text().indexOf("确认收货")>0){
		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">追加评价</button>');
		            			t.find(".details>ul").find("button").click(function(){
		            				window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
		            			});
		            		}else if(n.content.indexOf("待评价")>0){
		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">订单评价</button>');
		            			t.find(".details>ul").find("button").click(function(){
		            				window.location.href="comment.html?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
		            			});
		            		}else if(n.content.indexOf("已发货")>0){
		            			t.find(".details>ul").find("ul:eq(0)").after('<button type="button" class="btn btn-danger">确认收货</button>');
		            			t.find(".details>ul").find("button").click(function(){
		            				///1.计算是否有需要支付的尾款
		            				///1.1直接收货
		            				if(payPercentage==1){
		            					confimShouhuo(event.data);
		            				}else{
		            					//1.2计算支付金额
		            					var zje= parseFloat(t.find(".details").parent().find("#sum_si").html());//订单总金额
		            					zje=numformat2(zje*(1-payPercentage));
		            					//1.2
		            					$(".verify_01>span").html(zje);
		            					//1.3 显示支付界面
		            					$(".verify").show();
		            					params=event.data;
		            				}
		            			});
		            		}
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
$(".verify_02").click(function(){
	var payzje=$(".verify_01>span").val();
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
					confimShouhuo(params);
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
	jsons.Status_OutStore="待评价";
	jsons.headship="内勤";
	pop_up_box.postWait();
	$.post("../orderTrack/confimShouhuo.do",jsons,function(data){
		pop_up_box.loadWaitClose();
		window.location.href="comment.html?orderNo="+jsons.orderNo+"&item_id="+jsons.item_id+"&com_id="+jsons.com_id;
	});
}
$(".orderlist").html("");
var type=window.location.href.split("?")[1];
var st="";
if(type){
	if(type==2){
		st="已发货";
		$(".orient_02,.header,title").html("待收货订单");
	}else{
		st="待评价";
		$(".orient_02,.header,title").html("待评价订单");
	}
}
loadData();
function loadData(){
	pop_up_box.loadWait();
	$.get("../tailorMade/getTailorMadeOrderPage.do",{
		"st":st,
		"page":page,
		"count":count
	},function(data){
		pop_up_box.loadWaitClose();
		addItem(data);
	});
}
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