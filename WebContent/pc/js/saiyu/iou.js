$(function(){
	$("#print").click(function(){
		$("#printdiv").jqprint();
	});
	
	if($("#confirmIou").length>0){
	    function importImg(sig){///保存
	    	var data=$.trim(sig.jSignature('getData'));
	    	if (data.length>6000) {
	    		$("img").attr("src",data);
	    		$("#signature,#clear").remove();
	    		$("img").show();
	    		return false;
			}else{
				alert("请签名!");
				return true;
			}
	    }
		 $("#signature").jSignature();
		 $("img").hide();
		$(".customerName").html($.cookie("customerName"));
		$(".date").html($.cookie("date"));
		$("#ddje").html($.cookie("ddje"));//订单金额
		$("#ddje_dx").html(AmountLtoU(parseFloat($.cookie("ddje"))));//订单金额大写
		$("#orderlist").html($.cookie("orderlist"));// 
		$("#confirmIou").click(function(){
			if(importImg($('#signature'))){
				return;
			}
			$("a").hide();
			$(".btn-default").remove();
			var htmldiv=$("html").html(); 
			var param={
				"orderlist":$.cookie("orderlist"),
				"order_je":$.cookie("ddje"),
				"customerName":$.cookie("customerName"),
				"FHDZ":$.cookie("FHDZ"),
				"bxNo":$.cookie("bxNo"),
				"approval_step":$.cookie("approval_step"),
				"spNo":$.cookie("spNo"),
				"orderNo":$.cookie("orderNo"),
				"printdiv":htmldiv
			};
			pop_up_box.postWait();
			$.post("saveIou.do",param,function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("欠条生成成功",function(){
						window.close(); 
					});
					removeOrder();
				}else{
					if (data.msg=="error101") {
						pop_up_box.showMsg("保存出错,没有找到客户欠条审批相关流程,请联系管理员!");
					}else{
						pop_up_box.showMsg("保存出错,错误:"+data.msg);
					}
				}
			});
			////////
		});
	} 
});