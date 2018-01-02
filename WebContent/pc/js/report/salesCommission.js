$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	treeGetPrex="../manager/";
	o2o.next_tree("client",function(n){
		return treeli(n.corp_name,n.customer_id);
	});
	$(".tree").find("span:contains('我公司')").click();
	var page=0;
	var count=0;
	var totalPage=0;
	function loadData(){
		pop_up_box.loadWait();
		$.get("getSalesCommission.do",{
			"count":count,
			"m_flag":$("#type").val(),
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"customer_id":$("#customer_id").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			totalPage=data.totalPage;
			count=data.totalRecord;
			if(data.rows.length>0){
				$.each(data.rows,function(i,n){
					var tr=getTr(7);
					$("tbody").append(tr);
					tr.find("td:eq(0)").html(n.corp_name);
					tr.find("td:eq(1)").html(numformat2(n.sum_si));
					tr.find("td:eq(2)").html(n.upper_corp_name);
					tr.find("td:eq(3)").html(n.percentageProportion);
					tr.find("td:eq(4)").html(n.sum_si*n.percentageProportion*0.01);
					if(n.m_flag==1){
						tr.find("td:eq(5)").html("是");
					}else{
						tr.find("td:eq(5)").html("否");//<div class="checkbox"><span>'+n.upper_customer_id+'</span></div>
						var btn=$('<button type="button" class="btn btn-primary">付款</button>');
						tr.find("td:eq(6)").html(btn);
						btn.click({"upper_customer_id":n.upper_customer_id,"customer_id":n.customer_id,"sum_si":(n.sum_si*n.percentageProportion)},function(event){
							pop_up_box.postWait();
							$.post("payCommission.do",{
								"upper_customer_id":event.data.upper_customer_id,
								"customer_id":event.data.customer_id,
								"sum_si":event.data.sum_si,
								"m_flag":$("#type").val(),
								"searchKey":$.trim($("#searchKey").val()),
								"beginDate":$(".Wdate:eq(0)").val(),
								"customer_id":$("#customer_id").val(),
								"endDate":$(".Wdate:eq(1)").val()
							},function(data){
								if (data.success) {
									pop_up_box.showMsg("提交成功!");
								} else {
									if (data.msg) {
										pop_up_box.showMsg("提交错误!" + data.msg);
									} else {
										pop_up_box.showMsg("提交错误!");
									}
								}
							});
						});
					}
					
				});
			}
		});
	}
	$("#find").click(function(){
		$("tbody").html("");
		page=0;
		loadData();
	});
	
});