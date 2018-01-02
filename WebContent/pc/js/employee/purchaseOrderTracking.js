$(function(){
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
	var page=0;
	var totalPage=0;
	var count=0;
	$("tbody").html("");
	$("select").change(function(){
		loadData();
	})
	function loadData(){
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		var beginDate=$.trim($($("#gzform")).find(".Wdate:eq(0)").val());
		var endDate=$.trim($($("#gzform")).find(".Wdate:eq(1)").val());
		var m_flag=$.trim($("select:eq(0)").val());
		$.get("getProcurementList.do",{//getProcurementList.do
			"beginDate":beginDate,
			"endDate":endDate,
			"page":page,
			"count":count,
			"client":"2",
			"m_flag":m_flag
		},function(data){//vendorOrderList//$("#gzform").serialize()
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(18);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.st_auto_no);
					var now = new Date(n.at_term_datetime);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
					tr.find("td:eq(1)").html(nowStr);
					tr.find("td:eq(2)").html(n.rep_qty);
					if(n.rksl){
						tr.find("td:eq(3)").html(n.rksl);
						tr.find("td:eq(4)").html(parseFloat(n.rep_qty)-parseFloat(n.rksl));
					}else{
						tr.find("td:eq(3)").html(0);
						tr.find("td:eq(4)").html(parseFloat(n.rep_qty)-0);
					}
					if(n.m_flag==0){
						tr.find("td:eq(5)").html("未处理");
					}else if(n.m_flag==1){
						tr.find("td:eq(5)").html("已作废");
					}else if(n.m_flag==2){
						tr.find("td:eq(5)").html("已处理有货");
					}else if(n.m_flag==3){
						tr.find("td:eq(5)").html("已处理无货");
					}else if(n.m_flag==4){
						tr.find("td:eq(5)").html("已发货");
					}else if(n.m_flag==5){
						tr.find("td:eq(5)").html("已收货");
					}else if(n.m_flag==8){
						tr.find("td:eq(5)").html("已通知安排物流");
					}else if(n.m_flag==9){
						tr.find("td:eq(5)").html("已提交物流信息");
					}
					tr.find("td:eq(6)").html(n.corp_name);
					tr.find("td:eq(7)").html(n.movtel);
					tr.find("td:eq(8)").html(n.item_id);
					tr.find("td:eq(9)").html(n.item_name);
					tr.find("td:eq(10)").html(n.price);
					tr.find("td:eq(11)").html(n.item_spec);
					tr.find("td:eq(12)").html(n.item_type);
					tr.find("td:eq(13)").html(n.item_color);
					tr.find("td:eq(14)").html(n.item_unit);
					tr.find("td:eq(15)").html(n.casing_unit);
					tr.find("td:eq(16)").html((n.price)*(n.rep_qty));
					tr.find("td:eq(17)").html(n.discount_rate);
				});
				totalPage=data.totalPage;
				count=data.totalRecord;
				$("#page").html("当前页:"+page);
			}
		});
	}
    //////////////////////
	$(".find").click(function(){
		loadData();
	});
	////////////从外部直接进入处理
	var params=window.location.href.split("?");
	if (params&&params.length>1) {
		
	}else{
		loadData();
	}
	////////////////
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