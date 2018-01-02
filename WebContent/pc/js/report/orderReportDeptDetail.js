$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	$(".excel").click(function(){
		var i = $(".nav li").index($(".nav .active"));
		pop_up_box.loadWait(); 
		if (i==0) {//明细统计
			$.get("orderReportDeptDetailListExcel.do",$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				window.location.href=data.msg+"?owner=NTIwMDAwMDAy&media_id=2uHP_mzuSaWNu6hB9X2fc71g3sB2_kYoAskQvPYi3pMcQR0t-J1yRvONxPhCw7YZ1wB95badyetas3usHdhlghA";
			});
		}else if (i==1) {//客户统计
			$.get("orderReportDeptDetailListExcel.do?client=client",$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				window.location.href=data.msg;
			});
		}else if (i==2) {//业务统计
			$.get("orderReportDeptDetailListExcel.do?clerk=clerk",$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				window.location.href=data.msg;
			});
		}else{//销量明细统计
			$.get("orderRecordExcel.do",$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				window.location.href=data.msg;
			});
		}
	});
	
	
	$(".find").click(function(){
		if (findflag==1) {
			return;
		}else{
		var i = $(".nav li").index($(".nav .active"));
		pop_up_box.loadWait(); 
		if (i==0) {
			$("tbody:eq(0)").html("");
			$.get("orderReportDeptDetailList.do",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(10);
					$("tbody:eq(0)").append(tr);
					tr.find("td:eq(0)").html(n.dept_name);
					tr.find("td:eq(1)").html(n.clerk_name);
					tr.find("td:eq(2)").html(n.corp_sim_name);
					tr.find("td:eq(3)").html(n.sort_name);
					tr.find("td:eq(4)").html(n.item_sim_name);
					
					tr.find("td:eq(5)").html(numformat(n.monthnum,2));
					tr.find("td:eq(6)").html(numformat(n.upmonthnum,2));
					tr.find("td:eq(7)").html(numformat(n.yearsnum,2));
					tr.find("td:eq(8)").html(numformat(n.up_ninanum,2));
					tr.find("td:eq(9)").html(n.item_unit);
				});
				pop_up_box.loadWaitClose();
				findflag=0;
			});
		}else if (i==1) {//分客户
			$("tbody:eq(1)").html("");
			$.get("orderReportDeptDetailList.do?client=client",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(9);
					$("tbody:eq(1)").append(tr);
					tr.find("td:eq(0)").html(n.dept_name);
					tr.find("td:eq(1)").html(n.corp_sim_name);
					tr.find("td:eq(2)").html(n.sort_name);
					tr.find("td:eq(3)").html(n.item_sim_name);
					
					tr.find("td:eq(4)").html(numformat(n.monthnum,2));
					tr.find("td:eq(5)").html(numformat(n.upmonthnum,2));
					tr.find("td:eq(6)").html(numformat(n.yearsnum,2));
					tr.find("td:eq(7)").html(numformat(n.up_ninanum,2));
					tr.find("td:eq(8)").html(n.item_unit);
				});
				pop_up_box.loadWaitClose();
				findflag=0;
			});
		}else if (i==2) {//分员工
			$("tbody:eq(2)").html("");
			$.get("orderReportDeptDetailList.do?clerk=clerk",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(9);
					$("tbody:eq(2)").append(tr);
					tr.find("td:eq(0)").html(n.dept_name);
					tr.find("td:eq(1)").html(n.clerk_name);
					tr.find("td:eq(2)").html(n.sort_name);
					tr.find("td:eq(3)").html(n.item_sim_name);
					
					tr.find("td:eq(4)").html(numformat(n.monthnum,2));
					tr.find("td:eq(5)").html(numformat(n.upmonthnum,2));
					tr.find("td:eq(6)").html(numformat(n.yearsnum,2));
					tr.find("td:eq(7)").html(numformat(n.up_ninanum,2));
					tr.find("td:eq(8)").html(n.item_unit);
				});
				pop_up_box.loadWaitClose();
				findflag=0;
			});
		}else{//销售记录
			$("tbody:eq(3)").html("");
			$.get("orderRecord.do",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(10);
					$("tbody:eq(3)").append(tr);
					tr.find("td:eq(0)").html(n.dept_name);
					tr.find("td:eq(1)").html(n.clerk_name);
					tr.find("td:eq(2)").html(n.corp_sim_name);
					tr.find("td:eq(3)").html(n.sort_name);
					tr.find("td:eq(4)").html(n.item_sim_name);
					
					tr.find("td:eq(5)").html(numformat(n.sd_oq,0));
					tr.find("td:eq(7)").html(numformat(n.sum_si,1));
					tr.find("td:eq(6)").html(numformat(n.sd_unit_price,1));
					if (n.item_id) {
						var now = new Date(n.at_term_datetime_Act);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(8)").html(nowStr);
					}
					tr.find("td:eq(9)").html(n.sd_order_id);
				});
				pop_up_box.loadWaitClose();
				findflag=0;
			});
		}
		////
		}
	});
	
});