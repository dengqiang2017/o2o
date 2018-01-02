$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	getContainerHtml("repair.do");
});
$(function(){
	$('a[data-title="title"]').html("我的协同");
	 var yesOrNo="";
	$(".nav-tabs li").click(function() {
		var n = $(".nav-tabs li").index(this);
		$(".nav-tabs li").removeClass("active"); 
		$(this).addClass("active"); 
		$(".tabs-content").hide(); 
		$(".tabs-content:eq("+n+")").show(); 
		$(".find").click();
	});
	var recordpage={
			page:0,
			totalPage:0,
			totalRecord:0
	}
	$(".find").click(function(){
		loadData(1);
	});
	$(".find:eq(0)").click();
	var addindex=0;
	$(window).scroll(function(){
		if($("#listoa").css("display")!="none"){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (recordpage.page==recordpage.totalPage) {
				}else{
					recordpage.page+=1;
					loadData(recordpage.page);
				}
			}
		}
		}
     });
	function loadData(page,count){
		if($("#listoa").css("display")=="none"){
			return;
		}
		var lia = $(".nav li").index($(".nav .active"));
		var param;
		var tabsContent=$(".tabs-content:eq("+lia+")");//代办事项
		var badge=$(".badge");//代办事项
		var danger;
		if (lia==0) {
			param={
				"item_name":$("#sd_order_id").val(),
				"OA_who":$("#OA_who").val(),
				"store_date":$("#store_date").val(),
				"type_id":$("#type_id").val(),
				"page":page,
				"count":0
			}
			danger=$(".alert-danger");//代办事项子项
		}else{
			danger=$(".alert-info");//已办事项子项
			param={
					"item_name":$("#sd_order_id").val(),
					"page":page,
					"count":count,
					"yesOrNo":"已办"
				  };
			yesOrNo="已办";
		}
		tabsContent.html("");
		pop_up_box.loadWait();
		$.get("getOAList.do",param,function(data){
			pop_up_box.loadWaitClose();
			var headshipG=$("#headshipG").val();
			$.each(data.rows,function(i,n){
				var item=$(danger.parent().html());
				tabsContent.append(item);
				item.find("#OA_who_item").html(n.OA_who);
				if (!n.OA_who) {
					item.find("#OA_who_item").html(n.OA_who2);
				}
				item.find("#OA_what").html(n.OA_what);
				item.find("#store_date_item").html(new Date(n.store_date).Format("yyyy-MM-dd hh:mm:ss"));
				var url;
				if(headshipG.indexOf("采购")>=0){//采购审批
					url="purchaseApproval.do?spNo="+n.ivt_oper_listing+"&seeds_id="+n.seeds_id+"&approval_step="+n.approval_step;
				}else if(headshipG.indexOf("工程")>=0){//工程部经理审批
					url="repair.do?spNo="+n.ivt_oper_listing+"&seeds_id="+n.seeds_id+"&approval_step="+n.approval_step;
				}else  if(headshipG.indexOf("出纳")>=0){//出纳支付
					var ors=n.OA_what.split("采购单号:");
					var orderNo="";
					if(ors&&ors.length>1){
						orderNo=ors[1];
					}
					url="cashierPayment.do?spNo="+n.ivt_oper_listing+"&seeds_id="+n.seeds_id+"&approval_step="+n.approval_step+"&orderNo="+orderNo;
				}else{///财务经理审批
					url="financialApproval.do?spNo="+n.ivt_oper_listing+"&seeds_id="+n.seeds_id+"&approval_step="+n.approval_step;
				}
//				url="purchaseApproval.do?spNo="+n.ivt_oper_listing+"&seeds_id="+n.seeds_id;
				var prUrl="edspalready.do?ivt_oper_listing="+n.ivt_oper_listing;
				item.find(".btn-danger").click(function(){
					pop_up_box.loadWait();
					$.get(url,function(data){
						pop_up_box.loadWaitClose();
						$("#listoa").hide();
						$("#itempage").html(data);
					});
				});
				item.find(".btn-primary").click(function(){
					pop_up_box.loadWait();
					$.get(prUrl,function(data){
						pop_up_box.loadWaitClose();
						$("#listoa").hide();
						$("#itempage").html(data);
					});
				});
				
			});
			if (lia==0) {
				badge.html(data.totalRecord);
			}
		});
	}
});
function backOa(){
	$("#itempage").html("");
	$("#listoa").show();
	$(".modal-cover-first,.modal-first").hide();
	getContainerHtml("myOA.do");
}