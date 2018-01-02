var orderitem=$("#item");
var page=0;
var totalPage=0;
var count=0;
function addItem(data){
	if(data&&data.rows&&data.rows.length>0){
		$.each(data.rows,function(i,n){
			var item=$(orderitem.html());
			$(".orderbox").append(item);
			item.find("#orderNo").html(n.ivt_oper_listing);
			if (n.sum_si>0) {
				item.find("#sum_si").parent().html("金额:"+numformat2(n.sum_si));
			}
			if (n.info) {
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
loadData();
$(".orderbox").html("");
function loadData(){
	pop_up_box.loadWait();
	$.get("../tailorMade/getTailorMadeInfoPage.do",{
		"sum_si":0,
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
				list.push(JSON.stringify({"orderNo":orderNo,"sum_si":sum_si}));
			}
		}
		if (list&&list.length>0) {
			pop_up_box.postWait();
			$.post("../tailorMade/saveSum_si.do",{
				"orderlist":"["+list.join(",")+"]"
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