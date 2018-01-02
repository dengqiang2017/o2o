URLFiltering();
$(function(){
	if(!IsPC()){
		$(".footer").addClass("navbar-fixed-bottom");
		$(".header").addClass("navbar-fixed-top");
	}
	 window.onbeforeunload=function(event){
			if ($("#infopage").css("display")=="none") {
				return '请点击左上角返回,回到上一页面!';
			}
		}
	$('.side-cover').hide();
	$('.btn-center button').eq(0).click(function(){
		$('.side-cover').fadeIn('fast');
		$('.amend_sex').fadeIn('fast');
	});
	$('.cancel').click(function(){
		$('.side-cover').fadeOut('fast');
		$('.amend_sex').fadeOut('fast');
	});
	$('.del-btn').click(function(){
		$('.side-cover').fadeOut('fast');
		$('.amend_sex').fadeOut('fast');
	});
	var page=0;
	var count=0;
	 $(".find").click(function(){
		 page=0;
		 count=0;
	    loadData();
	 });
	 $("#searchKey").change(function(){
		 page=0;
		 count=0;
	    loadData();
	 });
	 loadData();
	 function loadData(){
	    	pop_up_box.loadWait();
	    	$.get("../customer/orderTrackingRecord.do",{
	    		"searchKey":$.trim($("#searchKey").val()),
//	    		"beginDate":$(".Wdate:eq(0)").val(),
//	    		"endDate":$(".Wdate:eq(1)").val(),
	    		"isDate":false,
	    		"page":page,
	    		"type":"11",
				"count":count
	    	},function(data){
	    		pop_up_box.loadWaitClose();
	    		$(".all_order>ul").html("");
	    		addItem(data);
	    	});
	    }
	
    var orderitem=$("#orderitem");
    function addItem(data,index){
    	if(data&&data.rows&&data.rows.length>0){
			$.each(data.rows,function(i,n){
				var item=$(orderitem.html());
				$("#list").append(item);
				item.find("#item_name").html($.trim(n.item_name));
				item.find("#item_name").attr("title",$.trim(n.item_name));
				item.find("#item_color").html($.trim(n.item_color)+" "+$.trim(n.item_type));
				if(n.memo_color){
					item.find("#memo_color").html($.trim(n.memo_color));
					item.find("#memo_color").click({"memo":$.trim(n.memo_color)},function(event){
						pop_up_box.showMsg(event.data.memo);
					});
				}else{
					item.find("#memo_color").parent().hide();
				}
				item.find("#sum_si").html(numformat2(n.sum_si));
				item.find("#sd_oq").html("x"+n.sd_oq);
				item.find("#price").html("￥"+n.sd_unit_price);
				item.find("#orderNo").html(n.ivt_oper_listing);
				item.find("#Status_OutStore").html($.trim(n.Status_OutStore));
				var url="commodity.jsp?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
				item.find("#zcgm").attr("href",url);
				item.find("#tuijian").attr("href",url);
				item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
				item.find("#pjdd,#evaluatemmsg").hide();
				item.find("#delorder").hide();
				item.find("#qrsh").hide();
				if($.trim(n.Status_OutStore)=="已结束"){
					item.find("#pjdd,#evaluatemmsg").show();
					item.find("#delorder").show();
				}else if($.trim(n.Status_OutStore)=="已发货"){
					item.find("#qrsh").show();
				}
				////评价产品
				item.find("#pjdd").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),
					"com_id":$.trim(n.com_id)},
					function(event){
						var t=$(this);//用于选择司机后隐藏司机按钮,显示司机信息
						window.location.href="evaluate.jsp?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
				});
				item.find("#viewLogistics").click({
					"item_name":$.trim(n.item_name),
					"item_color":$.trim(n.item_color),
					"seeds_id":n.seeds_id,
					"orderNo":$.trim(n.ivt_oper_listing),
					"item_id":$.trim(n.item_id),
					"com_id":$.trim(n.com_id),
					"sd_oq":n.sd_oq,
					"price":numformat2(n.sd_unit_price)
				},function(event){
					$("#wuliupage").find("#item_name").html(event.data.item_name);
					$("#wuliupage").find("#item_color").html(event.data.item_color);
					$("#wuliupage").find("#sd_oq").html(event.data.sd_oq);
					$("#wuliupage").find("#price").html(event.data.price);
					$("#wuliupage").find(".pic>img").attr("src","../"+$.trim(event.data.com_id)+"/img/"+$.trim(event.data.item_id)+"/sl.jpg?ver="+Math.random());
					$("#infopage,.header:eq(0),.search").hide();
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
							window.location.href="evaluate.jsp?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
						} else {
							if (data.msg) {
								pop_up_box.showMsg("保存错误!" + data.msg);
							} else {
								pop_up_box.showMsg("保存错误!");
							}
						}
					});
				});
			});
			count=data.totalRecord;
			totalPage=data.totalPage;
		}
    }
});