$(function() {
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$("#time").val(nowStr);
	var orderNo=$("input[name='orderNo']");
	var amount=$("input[name='amount']");
	$.get("getPaymoneyNo.do",function(data){
		orderNo.val(data);
	});
	function loadItemName(name,id){
		return "<div class='paycheck-box'>"+name+"<span class='glyphicon glyphicon-ok'></span><input type='hidden' value='"+id+"'></div>";
	}
	$(".paycheck-box").click(function(){
		var lia=$(".paycheck-box").index(this);
		if (lia==0) {
			loadItem("账上款");
		}else if (lia==1) {
			loadItem("预存款");
		}
	});
	$(".paycheck-box:eq(0)").click();
	function loadItem(type){
		$(".paycheck-ctn:eq(1)").html("");
		pop_up_box.loadWait();
		$.get("getSettlementList.do",{"type":type},function(data){
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
				$(".paycheck-ctn:eq(1)").append(loadItemName(n.settlement_sim_name,n.sort_id));
			});
//			$(".paycheck-box").removeClass("active");
			$("#paystyle").find(".paycheck-box:eq(0)").addClass("active");
			$(".paycheck-box").click(function(){
				$(this).parents(".paycheck-ctn").find(".paycheck-box").removeClass("active");
			  $(this).addClass("active");
			});
		});
	}
	
	$(".btn-info").click(function(){
		var account=$("#account").find(".active");
		var paystyle=$("#paystyle").find(".active>input");
		var zftl=$("#zftl").find(".active");
		var paystyletxt=$("#paystyle").find(".active");
		if (account.length<=0) {
			pop_up_box.showMsg("请选择充值账户类型!");
		}else if ($.trim(paystyle.val())=="") {
			pop_up_box.showMsg("请选择结算方式!");
		}else if ($.trim(zftl.text())=="") {
			pop_up_box.showMsg("请支付通路!");			
		}else if ($.trim(amount.val())==""||amount.val()=="0") {
			pop_up_box.showMsg("请输入充值金额!",function(){
				amount.focus().select();
			});
		}else{
			var params;
			if (order) {
//				var czje=parseFloat($.trim(amount.val()));//充值金额
//				if (czje<ddje) {
//					pop_up_box.showMsg("你的账户充值金额不足以支付本次交易："+ddje+"元，请重新填写!",function(){
//						amount.val(numformat(ddje,1));
//						amount.focus().select();
//					});
//					return;
//				}else{
					params={
							"orderNo":$.trim(orderNo.val()),
							"amount":$.trim(amount.val()),
							"account":$.trim(account.text()),
							"paystyletxt":$.trim(paystyletxt.text()),
							"sum_si_origin":$.trim(zftl.text()),
							"paystyle":$.trim(paystyle.val()),
							"ddje":$.cookie("ddzje"),
//							"ddje":$.cookie("ddzje"),/////2015-10-24 21:23
							"orderlist":$.cookie("orderlist"),
//							"fuddje":$.cookie("fuddje"),
							"jiesList":$.cookie("jiesList"),
							"jiesListYCK":$.cookie("jiesListYCK"),
							"transport_AgentClerk_Reciever":$.cookie("transport_AgentClerk_Reciever"),
							"Kar_Driver":$.cookie("Kar_Driver"),
							"Kar_Driver_Msg_Mobile":$.cookie("Kar_Driver_Msg_Mobile"),
							"Kar_paizhao":$.cookie("Kar_paizhao"),
							"FHDZ":$.cookie("FHDZ")
					};
//				}
			}else{
				params={
						"orderNo":$.trim(orderNo.val()),
						"amount":$.trim(amount.val()),
						"account":$.trim(account.text()),
						"paystyletxt":$.trim(paystyletxt.text()),
						"sum_si_origin":$.trim(zftl.text()),
						"paystyle":$.trim(paystyle.val())
				};
			}
				pop_up_box.postWait();
				$.post("savePaymoney.do",params,function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						$("input[name='body']").val($.trim(account.text())+$.trim(paystyletxt.text()));
						if ($.trim(zftl.text())=="支付宝") {
							$("form").submit();
						}else if ($.trim(zftl.text())=="微信支付") {
							$("form").attr("action","../weixin/alipay.do");
							$("form").submit();
						}else if($.trim(zftl.text()).indexOf("第三方网银")>=0){
							window.open("../pc/changePay.html?"+$.trim(orderNo.val())+"|"+$.trim(amount.val()));
							$(".modal-cover-first,.modal-first").show();
						}else{
//							removeOrder();
//							return;
							if (order) {
								removeOrder();
								pop_up_box.showMsg("您已经提交了账户充值数据，请尽快办理银行业务并确认资金到账，以便于我们尽快为您办理订单或发货业务！",function(){
									$(".modal-cover-first,.modal-first").show();
//								window.location.href="../customer.do";
//									window.location.reload(true);
								});
							}else{
								pop_up_box.showMsg("数据提交成功,您还可以继续充值,若不需充值请点击返回!",function(){
									$(".modal-cover-first,.modal-first").show();
//									window.location.reload(true);
								});
							}
						}
					}else{
						pop_up_box.showMsg("保存失败,错误:"+data.msg);
					}
				});
		}
	});
	/////////////////////////////
	var url=window.location.href.split("?");
	var order;
	if (url.length>1) {
		//	订单支付充值通路
		var ddje=numformat(parseFloat($.cookie("ddje")),1);
		////设置订单总金额//////
		amount.val(numformat(ddje,1));
		$(".breadcrumb>li:eq(1)").html("<span class='glyphicon glyphicon-triangle-right'></span>订单支付");
		$(".box-head").text("订单支付");
		$(".pay-form:eq(0)>.pay-label").text("支付单号");
		$(".pay-form:eq(1)>.pay-label").text("支付金额");
		$(".pay-form:eq(2)>.pay-label").html("支付日期");
		$(".last").hide();
		order=true;
		$("input[name='attach']").val("订单支付");
		amount.change(function(){
			var nval=parseFloat($.trim($(this).val()));
			if (parseFloat(ddje)>nval) {//当前输入金额小于订单总金额时
				pop_up_box.showMsg("当前输入金额小于支付金额不能完成支付!",function(){
					amount.val(numformat(ddje,1));
				});
			}
		});
		$(".btn-primary:eq(0)").find("a").click(function(){
			window.location.href="clientOrder.do";
			return false;
		});
	}else{
		$("input[name='attach']").val("账户充值");
		order=false;
		amount.focus().select();
		removeOrder();
	}
	///////////////////////////////上传凭证//begin//////////////////////////
	$(".btn-default,.close").click(function(){
		$(".modal-cover-first,.modal-first").hide();
		if(order){
			window.location.href="../customer/myorder.do";
		}else{
			window.location.href="../customer/accountStatement.do";
		}
	});
	$("#scpzpc").click(function(){
		var imgurl=$.trim($(".modal-body").find("#filepath").val());
		if(imgurl!=""){
			$.post("../weixin/certificateImg.do",{
				"imgurl":imgurl,
				"weixin":weixin,
				"orderNo":$.trim(orderNo.val())
			},function(data){
				$(".modal-cover-first,.modal-first").hide();
				if (data.success) {
					pop_up_box.showMsg("上传成功!",function(){
						if(order){
							window.location.href="../customer/myorder.do";
						}else{
							window.location.href="../customer/accountStatement.do";
						}
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
	var weixin=0;///用于在保存图片的时候判断上传类型
	if (is_weixin()) {
		$("#scpz").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scpz").click(function(){
			weixin=1;
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					$.get("../weixin/getWeixinFwqImg.do",{"url":url,"orderNo":orderNo.val()},function(data){
						if (data.success) {
							pop_up_box.showMsg("上传成功!",function(){
								if(order){
									window.location.href="../customer/myorder.do";
								}else{
									window.location.href="../customer/accountStatement.do";
								}
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
					
				});
				$(".modal-body").find("img").attr("src",imgurl);
				$("#imgFile").val(imgurl);
			});
		});
	}else{
		$("#scpz").hide();
		$("#upload-btn").show();
	}
	/////////////////////////上传凭证///end///////
});
function imgUpload(t){
	if (is_weixin()) {
		weixinfileup.chooseImage(t,function(imgurl){
//			$("#filepath").val(imgurl);
			$(".modal-body").find("img").attr("src",imgurl);
		});
	}else{
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
	
}