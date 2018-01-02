$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	$(".find").click(function(){
		$("tbody").html("");
		if (findflag==1) {
			return;
		}else{
			pop_up_box.loadWait(); 
			$.get("orderReportDeptCountlist.do",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(10);
					$("tbody").append(tr);
					tr.find("td:eq(0)").html(n.dept_name);//分部
					tr.find("td:eq(1)").html(numformat(n.monthnum,2));//本期销量
					tr.find("td:eq(2)").html(numformat(n.qu_years_monthnum,2));//同期销量,去年
					if (n.qu_years_monthnum>0) {
						tr.find("td:eq(3)").html(numformat((n.monthnum-n.qu_years_monthnum)/n.qu_years_monthnum,2));//本期同比
					}
					tr.find("td:eq(4)").html(numformat(n.upmonthnum,2));//上期销量
					if (n.upmonthnum>0) {
						tr.find("td:eq(5)").html(numformat((n.monthnum-n.upmonthnum)/n.upmonthnum,2));//本期环比
					}
					tr.find("td:eq(6)").html(numformat(n.yearsnum,2));//本年累计销量
					tr.find("td:eq(7)").html(numformat(n.up_ninanum,2));//上年同期累计销量
					if (n.up_ninanum>0) {
						tr.find("td:eq(8)").html(numformat((n.yearsnum-n.up_ninanum)/n.up_ninanum,2));//本年累计同比
					}
				});
				pop_up_box.loadWaitClose();
			});
		}
	});
	
});