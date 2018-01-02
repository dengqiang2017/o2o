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
		$.get("getSalesBonus.do",{
			"count":count,
			"searchKey":$.trim($("#searchKey").val()),
			"upper_customer_id":"%"+$.trim($("#customer_id").val())+"%",
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			totalPage=data.totalPage;
			count=data.totalRecord;
			
		});
	}
	$("#find").click(function(){
		$("tbody").html("");
		page=0;
		loadData();
	});
	
});