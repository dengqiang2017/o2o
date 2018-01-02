$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	backOa();
});
$(function(){
	$('a[data-title="title"]').html("我的协同-协同审批");
	pop_up_box.loadWait();
	tijian.init();
//	var approval_step=0;
	$.get("../saiyu/getSaiyuOAInfo.do",{"spNo":$("#spNo").val(),"type":"order"},function(data){
		pop_up_box.loadWaitClose();
//		approval_step=data.approval_step;
		$("#sunSi").html(numformat2(data.sumSi));
	});
	
	$("#save").click(function(){
		pop_up_box.postWait();
		var pros=$(".pro-checked");
//		if (pros&&pros.length>0) {
//			var list=[];
//			for (var i = 0; i < pros.length; i++) {
//				var tr=$(pros[i]).parents("tr");
//				var ivt_oper_listing=tr.find("td:eq(1)").html();
//				list.push(ivt_oper_listing);
//			}
		$.post("saveApprovalInfo.do",{
			"spyj":$("#spyj").val(),
			"spNo":$("#spNo").val(),
			"approval_step":$("#approval_step").val(),
			"ivt_oper_listing":$("#no").html()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!",backOa);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
//		} else {
//			pop_up_box.showMsg("请至少选择一个产品!");
//		}
	});
});