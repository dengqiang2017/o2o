var orderitem=$("#item");
var page=0;
var totalPage=0;
var count=0;
function showImg(m){
	window.location.href="../pc/image-view.html?"+m;
//	pop_up_box.showImg(m);
}
function addItem(data){
	if(data&&data.rows&&data.rows.length>0){
		$.each(data.rows,function(i,n){
			var item=$(orderitem.html());
			$(".orderbox").append(item);
			item.find("#orderNo").html(n.ivt_oper_listing);
			item.find("#corp_name").html(n.corp_sim_name);
			item.find("#customer_id").html(n.customer_id);
			if (n.sum_si>0) {
				item.find("#sum_si").parent().html("金额:"+numformat2(n.sum_si));
			}
			if (n.info) {
				item.find("#demandInfo").html(n.info.demandInfo);
				item.find("#deliveryDate").html(n.info.deliveryDate);
				item.find("#imgs").html("");
				for (var k = 0; k < n.imgs.length; k++) {
					var m=n.imgs[k];
					var imghtml=$('<div class="swiper-slide"><img onclick="showImg(\'..'+m+'\')"></div>');
					item.find("#imgs").append(imghtml);
					imghtml.find("img").attr("src",".."+m);
				}
			}
		});
		initNumInput();
		totalPage=data.totalPage;
		count=data.totalRecord;
		var mySwiper = new Swiper ('.swiper-container', {
			loop: true,
			slidesPerView : 3,
			centeredSlides : true
		})
	}
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
		$(".orderbox").html("");
		page=0;count=0;
		loadData();
		$("#findlistpage").hide();
		$("#listpage").show();
	});
});
//////查询//end/////
$(".orderbox").html("");
function loadData(){
	pop_up_box.loadWait();
	$.get("../tailorMade/getTailorMadeInfoPage.do",{
		"sum_si":0,
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
var addindex=0;
$(window).scroll(function(){
	if (addindex==0) {
		if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
			addindex=1;
			if (page==totalPage) {
			}else{ 
				page+=1;
				pop_up_box.loadWait();
				loadData();addindex=0;
			}
		}
	}
 });
 $("#qrbjia").click(function(){
	 var items=$(".orderbox>.orderbox01");
		var reg = new RegExp("^[0-9.]*$");
		var showb=false;
		var list=[];
		for (var i = 0; i < items.length; i++) {
			var sum_si=parseFloat($.trim($(items[i]).find("#sum_si").val()));
			if (sum_si>0) {
				var orderNo=$(items[i]).find("#orderNo").html();
				var customer_id=$(items[i]).find("#customer_id").html();
				list.push(JSON.stringify({"orderNo":orderNo,"sum_si":sum_si,"customer_id":customer_id}));
			}
		}
		if (list&&list.length>0) {
			pop_up_box.postWait();
			$.post("../tailorMade/saveSum_si.do",{
				"orderlist":"["+list.join(",")+"]",
				"title":"订单已报价通知",
				"url":"/pc/await_pay.html",
				"description":":@comName内勤已经为您的订单进行了报价,请点击进入进行查看"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						window.location.reload();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("没有找到已报价的订单!");
		}
 });