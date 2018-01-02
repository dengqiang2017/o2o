$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	backOa();
});
$(function(){
	$('a[data-title="title"]').html("我的协同-采购审批");
	tijian.init();
	$("#saveOrder").click(function(){
		var pros=$(".pro-checked");
		if(pros&&pros.length>0){
			var list=[];
			for (var i = 0; i < pros.length; i++) {
				var tr=$(pros[i]).parents("tr");
				var ivt_oper_listing=tr.find("td[data-name='ivt_oper_listing']").html();
				var bx_oper_listing=tr.find("td[data-name='bx_oper_listing']").html();
				var zt=tr.find("td[data-readonly]").html();
				if(zt!="运行中"){
					
//					var numkey=tr.find("").html();
//					var item_idKey=tr.find("").html();
					list.push(ivt_oper_listing);
				}
			}
			if(list&&list.length>0){
				pop_up_box.postWait();
				$.post("savePurchaseOrder.do",{
					"list":list,
					"approval_step":$("#approval_step").val(),
					"spNo":$("#spNo").val()
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						 if(data.msg){
							 pop_up_box.loadWait();
							 var url="";
							 if(data.msg.indexOf("?")>0){
								 url="&spNo="+$("#spNo").val()+"&seeds_id="+$("#seeds_id").val();
							 }else{
								 url="?spNo="+$("#spNo").val()+"&seeds_id="+$("#seeds_id").val();
							 }
							 $.get(data.msg+url,function(data){
								 pop_up_box.loadWaitClose();
								 $("#listoa").hide();
								 $("#itempage").html(data);
							 });
						 }else{
							 pop_up_box.showMsg("提交成功!",backOa);
						 }
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}else{
				pop_up_box.showMsg("请选择一条报修中的记录");
			}
		}else{
			pop_up_box.showMsg("请选择一条报修中的记录");
		}
	});
});