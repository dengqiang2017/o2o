var customer_id;
$(function(){
	salesReceipts.init();
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
	},"../employee/");
});
var salesReceipts={
		init:function(){
			expandClient.init();
			var pagegz=0;
			var countgz=0;
			var totalgz=0;
			$(".find").click(function(){
				if (findflag==1) {
					return;
				}else{
					$("#customer_id").val(customer_id);
					pagegz=1;
					countgz=0;
					totalgz=0;
					loadData();
				}
			});
			function loadData(page){
				if (!page) {
					page="";
				}
				pop_up_box.loadWait(); 
				$("tbody").html("");
				$.get("salesReceiptsList.do",$("form").serialize(),function(data){
					pop_up_box.loadWaitClose();
					$.each(data.rows,function(i,n){
						var tr=getTr(8);
						$("tbody").append(tr);
						tr=$(tr);
						var now = new Date(n.ivt_oper_cfm_time);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
						tr.find("td:eq(0)").html(nowStr);
						tr.find("td:eq(1)").html(n.corp_sim_name);
						tr.find("td:eq(2)").html(n.sum_si);
						tr.find("td:eq(3)").html(n.settlement_sim_name);
						tr.find("td:eq(4)").html(n.recieved_id);
						tr.find("td:eq(5)").html(n.dept_sim_name);
						tr.find("td:eq(6)").html(n.clerk_name);
						tr.find("td:eq(7)").html(n.rejg_hw_no);
					});
					countgz=data.totalRecord;
					totalgz=data.totalPage;
				});
			}
			$("#addSales").click(function(){
				if (customer_id) {
					pop_up_box.loadWait(); 
					$.get("salesReceiptsAdd.do",function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						addSales.init();
						$("#clientIdAdd").val(customer_id);
					});
				}else{
					pop_up_box.showMsg("请先选择客户!",function(){
						$("#seekh").click();
					});
				}
			});
			$(".btn-success:eq(0)").click(function(){
				pop_up_box.loadWait(); 
				$.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
					pop_up_box.loadWaitClose();
					 $("body").append(data);
					 settlement.init(function(){
						$("#settlement_id").val(treeSelectId);
						$("#settlement_name").html(treeSelectName);
					 });
				 });
			});
		}
}

var addSales={
		init:function(){
			$("#close,.close").click(function(){
				$(".modal-cover-first,.modal-first").remove();
			});
			selectTree.clearSelect();
			$(".btn-success").click(function(){
				 var n = $(".btn-success").index(this);
				 pop_up_box.loadWait(); 
				if (n==1) {
					$.get("../tree/getDeptTree.do",{"type":"dept","ver":Math.random()},function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						dept.init(function(){
							$("#dept_id").val(treeSelectId);
							$("#dept_name").html(treeSelectName);
						});
					});
				}else if (n==2) {
					$.get("../tree/getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						employee.init(function(){
							$("#clerk_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
							$("#clerk_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
						});
					});
				}else{
					$.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
						pop_up_box.loadWaitClose();
						 $("body").append(data);
						 settlement.init(function(){
							$("#settlement_id2").val(treeSelectId);
							$("#settlement_name2").html(treeSelectName);
						 });
					 });
				}
			});
			initNumInput();
			$("#saveSales").click(function(){
				var dept_id=$.trim($("#dept_id").val());
				var clerk_id=$.trim($("#clerk_id").val());
				var sum_si=$.trim($("input[name='sum_si']").val());
				var sum_si2=$.trim($("input[name='recieve_type']").val());
				var rcv_hw_no=$.trim($("#settlement_id2").val());
				var xsdh=$("#xsdh").val();
				if (rcv_hw_no=="") {
					pop_up_box.showMsg("请选择结算方式");
				}else if (sum_si=="") {
					pop_up_box.showMsg("请输入实收金额!");
				}else{
					pop_up_box.postWait();
					$("#paystyletxt").val($("#settlement_name2").html());
					$.post("savePaymoney.do",$("#addFrom").serialize(),function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("数据提交成功!");
							$(".modal-cover-first,.modal-first").remove();
						}else{
							pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
						}
					});
				}
				
			});
		}
		
}