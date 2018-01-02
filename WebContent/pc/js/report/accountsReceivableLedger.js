$(function(){
	var customer_id;
	selectClient.init(function(customerId) {
		customer_id=customerId;
//		$(".find").click();
	},"../employee/");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr);
	
	$("#expand").click(function(){
		var form=$("form");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".folding-btn").css("display")=="none"){
		$("form").show();
	}else{
		$("form").hide();
	}
	$(".btn-default").click(function(){
		$(this).parents("input-group").find("span.input-sm").html("");
		$(this).parents("input-group").find("input.input-sm").val("");
	});
	
	//导出Excel
	$(".excel").click(function(){
		var searchKey=$("form").serialize();
		var ver = Math.random();
		searchKey = searchKey + "&ver="+ver;
		pop_up_box.loadWait();
		$.get("accountsReceivableLedgerListExport.do",searchKey,function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
	
	$(".btn-success:eq(0)").click(function(){
//		 $.get("../tree/getDeptTree.do",{"type":"regionalism"},function(data){
//			   pop_up_box.loadWaitClose();
//			 $("body").append(data);
//			 regionalism.init(function(){
//				 $("#regionalism_name_cn").html(treeSelectName);
//				 $("#regionalismId").val(treeSelectId);
//			 });
//		 });
		 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
			   pop_up_box.loadWaitClose();
			 $("body").append(data);
			 settlement.init(function(){
				 $("#settlement_name").html(treeSelectName);
				 $("#settlement_id").val(treeSelectId);
			 });
		 });
	});
	$(".find").click(function(){
		if (findflag==1) {
			return;
		}else{
//			if (!customer_id||$.trim(customer_id)=="") {
//				$("#seekh").click();
//				findflag=0;
//				return;
//			}
			if ($.trim($("#customer_id").val())=="") {
				$("#customer_id").val(customer_id);
			}
			findflag=0;
			pop_up_box.loadWait(); 
			$("tbody").html("");
			$.get("accountsReceivableLedgerList.do",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
				var tr=getTr(10);
				$("tbody").append(tr);
				tr.find("td:eq(0)").html(n.customer_name);
				tr.find("td:eq(1)").html(numformat(n.oh_sum,2));	
			
				tr.find("td:eq(2)").html(numformat(n.addi_sum,2));
				tr.find("td:eq(3)").html(numformat(n.rev_sum,2));				
				tr.find("td:eq(4)").html(numformat(n.tax_invoice_sum,2));	
				tr.find("td:eq(5)").html(numformat(n.acct_recieve_sum,2));

				tr.find("td:eq(6)").html(n.regionalism_name);	
				tr.find("td:eq(7)").html(numformat(n.creditSum,2));
				tr.find("td:eq(8)").html(n.accountPeriod);				
				
				
				tr.find("td:eq(9)").html(numformat(n.balance,2));				
				
				
				});
				
				pop_up_box.loadWaitClose();
				findflag=0;
			});
		}
	});
	
	
});