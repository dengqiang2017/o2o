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
			var height=$('#signature').css("height");
			var width=$('#signature').css("width");
			$('#signature').find("canvas").css("height",height);
			$('#signature').find("canvas").attr("height",height.split("px")[0]);
			$('#signature').find("canvas").css("width",document.body.clientWidth+"px");
			$('#signature').find("canvas").attr("width",document.body.clientWidth);
			$('#signature').jSignature('clear');
		 $("img").hide();
		$(".customerName").html($.cookie("customerName"));
		$(".date").html($.cookie("date"));
		$("#ddje").html($.cookie("ddje"));//订单金额
		$("#ddje_dx").html(AmountLtoU(parseFloat($.cookie("ddje"))));//订单金额大写
		$("#ljqk").html($.cookie("ljqk"));//累计欠款
		$("#Kar_Driver").html($.cookie("Kar_Driver"));//司机姓名
		$("#Kar_paizhao").html($.cookie("Kar_paizhao"));//车牌号
		$("#orderlist").html($.cookie("orderlist"));// 
		$("#confirmIou").click(function(){
			if (importImg($('#signature'))) {
				return;
			}
			$(".btn-default").remove();
			$("a").hide();
			var htmldiv=$("html").html();
			var param={
				"orderlist":$.cookie("orderlist"),
				"jiesList":$.cookie("jiesList"),
				"jiesListYCK":$.cookie("jiesListYCK"),
				"ddzje":$.cookie("ddzje"),
				"order":$.cookie("order"),
				"order_je":$.cookie("ddje"),
				"customerName":$.cookie("customerName"),
				"transport_AgentClerk_Reciever":$.cookie("transport_AgentClerk_Reciever"),
				"Kar_Driver":$.cookie("Kar_Driver"),
				"Kar_Driver_Msg_Mobile":$.cookie("Kar_Driver_Msg_Mobile"),
				"Kar_paizhao":$.cookie("Kar_paizhao"),
				"FHDZ":$.cookie("FHDZ"),
				"printdiv":htmldiv
			};
			pop_up_box.postWait();
			$.post("saveIou.do",param,function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("欠条生成成功",function(){
//						window.close();
//						window.location.href="../pc/product.html";
						window.location.href="myorder.do";
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