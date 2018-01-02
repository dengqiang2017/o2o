$(function() {
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
	var page=0;
	var totalPage=0;
	var count=0;
	$("tbody").html("");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	$(".find").click(function(){
		loadData();
	})
	function loadData(){
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
//		var searchKey=$.trim($(".form-control input-sm").val());
		var beginDate=$.trim($("#gzform").find(".Wdate:eq(0)").val());
		var endDate=$.trim($("#gzform").find(".Wdate:eq(1)").val());
		var customer_id=$.trim($(".sim-table").find("#corp_id").val());
		$.get("getFkAccount.do",{
//			"searchKey":searchKey,
			"beginDate":beginDate,
			"endDate":endDate,
			"customer_id":customer_id,
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(7);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.corp_name);
					tr.find("td:eq(1)").html(n.st_hw_no);
					var now=new Date(n.finacial_d);
					var nowStr=now.Format("yyyy-MM-dd hh:mm:ss");
					tr.find("td:eq(2)").html(nowStr);
					if(n.recieved_auto_id){
						tr.find("td:eq(3)").html(n.recieved_auto_id);
					}else{
						tr.find("td:eq(3)").html("未付款");
					}
					if(n.mainten_datetime){
						var now = new Date(n.mainten_datetime);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
						tr.find("td:eq(4)").html(nowStr);
					}else{
						tr.find("td:eq(4)").html();
					}
					tr.find("td:eq(5)").html(n.yfSum);
					if(n.sum_si){
						tr.find("td:eq(6)").html(n.sum_si);
					}else{
						tr.find("td:eq(6)").html(0);
					}
					totalPage=data.totalPage;
					count=data.totalRecord;
					$("#page").html("当前页:"+page);
					})
				}
			})
		}
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
	$(".btn-default").click(function(){
		$(this).parents("input-group").find("span.input-sm").html("");
		$(this).parents("input-group").find("input.input-sm").val("");
	});
});

	
	
