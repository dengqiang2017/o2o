$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	backOa();
});
$(function(){
	$('a[data-title="phone"]').html("我的协同-采购订单支付");
	pop_up_box.loadWait();
	var orderlist=[];
	var xsskNo;
	var orderNo;
	var approval_step;
	tijian.init();
	$.get("../customer/getPaymoneyNo.do",function(data){
		xsskNo=data;
	});
	$.get("../saiyu/getSaiyuOAInfo.do",{
		"seeds_id":$("#seeds_id").val(),
		"spNo":$("#spNo").val(),
		"orderNo":$("#orderNo").val(),
		"type":"order"
		},function(data){
		pop_up_box.loadWaitClose();
		var sumSi=numformat2(data.sumSi);
		if(data.info){
			var infos=data.info.content.split("|");
			$("#info").html(infos[0].replace( /&/gm,"<br>"));
			$("#bxNo").html(infos[1].split(":")[1]);
			orderNo=data.info.ivt_oper_listing;
			approval_step=data.info.approval_step;
			$("#itempage").find("#spNo").val(data.info.ivt_oper_listing);
			$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		}else{
			orderNo=$("#orderNo").val();
		}
//		$("#orderNo").html(data.ivt_oper_listing);
		$("#sumSi").html(sumSi);
		$("input[name='amount']").val(sumSi);
		$(".glyphicon-remove").click(function(){
			$(this).parents(".col-lg-6").remove();
		}); 
	});
	$('.footer2').click(function(){
        $('.process-zz').toggle('slow');
//        $(".process-zz").find("li:eq(1)").click();
    });
	var itempage=$("#itempage");
//	itempage.find("#saveOrder").click(function(){
	$(".process-zz").find("li").click(function(){
		var fhdz=$.trim($("#fhdz").val());
		var paystyle=$(this).find("span").text();
		if (fhdz=="") {
			pop_up_box.showMsg("请输入发货地址!");
		}else{
			if(paystyle=="打欠条"){
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
				$.cookie("customerName",$.trim($("#customerName").val()));
				$.cookie("date",nowStr);
				$.cookie("ddje",$.trim($("#sumSi").html()));
				$.cookie("ddje",numformat($("#sumSi").html(),2));
				//////审批相关////
				//报修单号,审批单号,审批步骤
				$.cookie("approval_step",approval_step);
				$.cookie("FHDZ",fhdz);
				$.cookie("orderlist",orderlist);
				$.cookie("bxNo",$("#bxNo").html());
				$.cookie("spNo",$("#spNo").val());
				$.cookie("orderNo",orderNo);
				$.cookie("amount",$.trim($("#sumSi").html()));//订单金额
				$.cookie("customerName",$.trim($("#customerName").val()));
				
				$.cookie("date",nowStr);
				$.cookie("ddzje",$.trim($("#sumSi").html())); 
//				$.cookie("ljqk",numformat((zhye*-1)+ddzje,2));
				$.cookie("ljqk","0");
				$.cookie("orderlist",orderlist);
				console.debug($.cookie("ddje"));
				 console.debug(orderlist);
				 console.debug($.cookie("orderlist"));
				pop_up_box.showMsg("欠条确认完成?",function(){
					backOa();
				});
				window.open("iou.do");
//				window.location.href="iou.do";
				return;
			}
			pop_up_box.postWait();
			$.post("saveOrderPay.do",{
				"orderlist":orderlist,
				"upper_customer_id":$("#customer_id").val(),
				"spNo":$("#spNo").val(),
				"FHDZ":fhdz,
				"approval_step":approval_step,
				"xsskNo":xsskNo,
				"approval_step":$("#approval_step").val(),
				"orderNo":orderNo,
				"spyj":"同意",
				"amount":$("#sumSi").text(),
				"paystyle":paystyle,
				"bxNo":$("#bxNo").html()
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
//					var zftl=$(".zf");
					if ($.trim(paystyle)=="支付宝") {
						$("form").submit();
						pop_up_box.showMsg("支付完成!",function(){
							backOa();
						});
					}else if ($.trim(paystyle)=="微信支付") {
						$("form").attr("action","../weixin/alipay.do");
						$("form").submit();
						pop_up_box.showMsg("支付完成!",function(){
							backOa();
						});
					}else if($.trim(paystyle).indexOf("第三方网银")>=0){
						window.open("../pc/changePay.html?"+$.trim(orderNo)+"|"+$.trim($("#sumSi").text()));
//						$(".modal-cover-first,.modal-first").show();
					}else{
//						$(".modal-cover-first,.modal-first").show();
//						return;
						pop_up_box.showMsg("数据提交成功,请尽快进行线下转账付款!",function(){
							backOa();
							getContainerHtml('paymentInfo');
						});
					}
				}else{
					pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
				}
				$("#saveOrder").removeAttr("disabled");
			});
		}
	});
	$(".btn-default,.close").click(function(){
		$(".modal-cover-first,.modal-first").hide();
		backOa();
	});
	$("#certificateBtn").click(function(){
		var imgurl=$.trim($(".modal-body").find("#filepath").val());
		if(imgurl!=""){
			$.post("certificateImg.do",{
				"imgurl":imgurl,
				"orderNo":$.trim(orderNo.val())
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("上传成功!",function(){
						backOa();
						$(".modal-cover-first,.modal-first").hide();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("上传错误!" + data.msg);
					} else {
						pop_up_box.showMsg("上传错误!");
					}
				}
			});
		}
	});
	
});
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"filepath",
		"uploadFileSize":10
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		$("#filepath").val(imgurl);
		$(".modal-body").find("img").attr("src",".."+imgurl);
	});
}