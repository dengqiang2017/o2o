$(function(){
	//加载选择供应商页面,模拟搜索点击事件获取供应商信息
	choiceSupplier.init(function(corpId) {
		$("#corp_id").val(corpId);
		loadData();
	});
	$("#expand").click(function(){
		var form=$("#gzform");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".folding-btn").css("display")=="none"){
		$("#gzform").show();
	}else{
		$("#gzform").hide();
	}
	/////////////
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	///////////
	var page=0;
	var totalPage=0;
	var count=0;
	$("tbody").html("");
	function loadData(){
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		var beginDate=$.trim($("#gzform").find(".Wdate:eq(0)").val());
		var endDate=$.trim($("#gzform").find(".Wdate:eq(1)").val());
		var vendor_id=$.trim($("#corp_id").val());
		$.get("getCgmxStatistical.do",{
			"beginDate":beginDate,
			"endDate":endDate,
			"vendor_id":vendor_id,
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(14);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.rcv_auto_no);
					var now = new Date(n.at_term_datetime);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
					tr.find("td:eq(1)").html(nowStr);
					tr.find("td:eq(2)").html(n.corp_name);
					tr.find("td:eq(3)").html(n.price);
					tr.find("td:eq(4)").html(n.rep_qty);
					tr.find("td:eq(5)").html((n.price)*(n.rep_qty));
					tr.find("td:eq(6)").html(n.store_struct_name);
					tr.find("td:eq(7)").html(n.item_name);
					tr.find("td:eq(8)").html(n.item_id);
					tr.find("td:eq(9)").html(n.item_spec);
					tr.find("td:eq(10)").html(n.item_type);
					tr.find("td:eq(11)").html(n.item_color);
					tr.find("td:eq(12)").html(n.casing_unit);
					tr.find("td:eq(13)").html(n.discount_rate+"%");
				});
				totalPage=data.totalPage;
				count=data.totalRecord;
				$("#page").html("当前页:"+page);
			}
		});
	}
	$(".find").click(function(){
		loadData();
	});
	$("#onePage").click(function(){
		page=0;
		loadData();
	});
	$("#uppage").click(function(){
		page=parseInt(page)-1;
		if (page>=0) {
			loadData();
		}else{
			pop_up_box.showMsg("已到第一页!");
		}
	});
	$("#nextPage").click(function(){
		  page=parseInt(page)+1;
			if (page<=totalPage) {
				loadData();
			}else{
				pop_up_box.showMsg("已到最后一页!");
			}
	});
	$("#endPage").click(function(){
		page=totalPage;
		loadData();
	});
});