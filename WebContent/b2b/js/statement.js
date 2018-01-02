common.URLFiltering();
$(function(){
	$(".find").click(function(){
		loadData();	
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM");
	$(".Wdate:eq(0)").val(nowStr+"-01");
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	function loadData(){
		pop_up_box.loadWait(); 
		$("#list").html("");
		var json={
				"beginDate":$(".Wdate:eq(0)").val(),
				"endDate":$(".Wdate:eq(1)").val(),
				"key_words":$.trim($("#searchKey").val()),
				"if_LargessGoods":"否",
				"if_check":$("#if_check").val(),
//				"if_check":$("input[name='if_check']:checked").val(),
				"settlement_sortID":$("input[name='settlement_sortID']").val()};
		
		$.get("../report/accountStatementList.do",json,function(data){
			pop_up_box.loadWaitClose();
			if(data.rows){
				var len=data.rows.length;
				$("#zje").html(common.numformat(data.rows[len-1].accept_sum),1);
				$("#sfk").html(common.numformat(data.rows[len-1].allaccept_sum),1);
				$("#yfk").html(common.numformat(data.rows[len-1].surplus_sum),1);
//			$(".verify #surplus_sum").html(common.numformat2(data.rows[len-1].surplus_sum));
				for (var i = 0; i < len-1; i++) {
					var n=data.rows[i];
					
					var item=$($("#item").html());
					$("#list").append(item);
					if (n.openbill_date>0) {
						var now = new Date(n.openbill_date);
						var nowStr = now.Format("MM-dd hh:mm"); 
						item.find("#date").html(nowStr);
					}
					var ysje=0;
					if(n.sd_order_id.indexOf("XSKD")>0){
						item.find("#type").html("下订单");
						item.find("img").attr("src","images/buy.png");
						item.find("#no").html(n.sd_order_id);
						ysje=common.numformat(n.accept_sum,1)*-1;//应收金额
					}else if(n.sd_order_id.indexOf("XSSK")>0){
						item.find("#type").html("付款");
						item.find("#no").html(n.sd_order_id);
						ysje=common.numformat(n.allaccept_sum,1);//实收金额
					}else{
						item.find("#type").html("上期结余");
						item.find("input").remove();
						if(n.allaccept_sum!=0){
							ysje=common.numformat(n.allaccept_sum,1);
						}else{
							ysje=common.numformat(n.accept_sum,1);
						}
					}
					item.find("#ysje").html(ysje);
					item.find("#seeds_id").html(n.seeds_id);
					item.find("#jyje").html(common.numformat(n.surplus_sum,1)*-1);//结余金额  numformat2(n.allaccept_sum)//实收金额
					if(n.qianmingTime){
						item.find("input").remove();
					}else{
						item.click(function(){
							var b=$(this).find("input").prop("checked");
							$(this).find("input").prop("checked",!b);
						});
					}
				}
			}
		});
	}
	loadData();
	$("#signature").jSignature();
	var height=$('#signature').css("height");
	var width=$('#signature').css("width");
	$('#signature').find("canvas").css("height",height);
	$('#signature').find("canvas").attr("height",height.split("px")[0]);
	$('#signature').find("canvas").css("width",document.body.clientWidth+"px");
	$('#signature').find("canvas").attr("width",document.body.clientWidth);
	$('#signature').jSignature('clear');
	 $("#signature img").hide();
	///对账单签字
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
    $("#qianzi").click(function(){
    	var checks=$("#list input:checked");
		if(checks&&checks.length>0){
			$("#mymodal2").show();
		}else{
			pop_up_box.showMsg("请至少选择一项进行对账确认!");
		}
    });
    $(".gbi,.close").click(function(){
    	$("#mymodal2").hide();
    });
	$(".btnsize").click(function(){
		if (importImg($('#signature'))) {
			return;
		}
		var checks=$("#list input:checked");
		if(checks&&checks.length>0){
			var list=[];
			for (var i = 0; i < checks.length; i++) {
				var item=$(checks[i]).parents(".dataitem");
				var param={};
				var no=item.find("#no").html();
				param.no=no;
				var seeds_id=item.find("#seeds_id").html();
				param.seeds_id=seeds_id;
				list.push(JSON.stringify(param));
			}
			$.post("../customer/confirmQianming.do",{
				"list":"["+list.join(",")+"]",
				"img":$("img").attr("src")
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("提交成功!");
					window.location.href="../customer.do";
					$('#mymodal2').hide();
					$(".find:eq(0)").click();
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一项客户对账单!");
		}
	
	});
});
var st={
		init:function(){

			$('.verify_02>ul>li').click(function(){
			    $('.verify').slideToggle();
			    $('.closed').show();
			    var t=$(this);
			    $.get("../customer/getPaymoneyNo.do",function(data){
					uploadPingz.init(data,function(){
						loadData();
					});
					//1.提交数据
					var amount=$(".verify_01>#surplus_sum").html();
					var orderparam={
							"amount":amount
					};
					var verify_02=$.trim(t.html());
						pop_up_box.postWait();
						orderparam.orderNo=data;
						orderparam.paystyle="JS001";
						orderparam.account=verify_02;
						orderparam.sum_si_origin=verify_02;
						orderparam.paystyletxt="账上款";
						$.post("../customer/savePaymoney.do",orderparam,function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("保存成功!",function(){
									$(".modal-cover-first,.modal-first").show();
								});
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					
				});
			});
		//////查询//begin//
			$.get("query.jsp",function(data){
				$("body").append(data);
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd"); 
				$(".input-sm").val("");
				var onedays=nowStr.split("-");
				$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01");
				$(".Wdate:eq(1)").val(nowStr);
				/////
				loadData();
				////////
				$("#query").click(function(){
					$("input").removeAttr("disabled");
					$("#findlistpage").show();
					$("#listpage").hide();
				});
				$("#findlistpage .closed").click(function(){
					$("#findlistpage").hide();
					$("#listpage").show();
				});
				$(".find").click(function(){
					page=0;
					loadData();
					$("#findlistpage").hide();
					$("#listpage").show();
				});
			});
		//////查询//end/////
			function loadData(){
				pop_up_box.loadWait(); 
				$(".statementk").html("");
				var json={
						"beginDate":$(".Wdate:eq(0)").val(),
						"endDate":$(".Wdate:eq(1)").val(),
						"key_words":$.trim($("#searchKey").val()),
						"if_LargessGoods":"否",
						"if_check":"全部",
//						"if_check":$("input[name='if_check']:checked").val(),
						"settlement_sortID":$("input[name='settlement_sortID']").val()};
				$.get("../report/accountStatementList.do",json,function(data){
					pop_up_box.loadWaitClose();
					var len=data.rows.length;
					if(len<=0){
						$("#zje>span").html("0");
						$("#sfk>span").html("0");
						$("#yfk>span").html("0");
						return;
					}
					$("#zje>span").html(numformat2(data.rows[len-1].accept_sum));
					$("#sfk>span").html(numformat2(data.rows[len-1].allaccept_sum));
					$("#yfk>span").html(numformat2(data.rows[len-1].surplus_sum));
					$(".verify #surplus_sum").html(numformat2(data.rows[len-1].surplus_sum));
					if(data.rows[len-1].surplus_sum>0){
						$(".body_04").show();
					}else{
						$(".body_04").hide();
					}
					for (var i = 0; i < data.rows.length-1; i++) {
						var n=data.rows[i];
						var item=$($("#item").html());
						$(".statementk").append(item);
						if(n.sd_order_id.indexOf("XSKD")>0){
							item.find("#surplus_sum").html(numformat2(n.accept_sum));
							item.find("#openbill_type").html("下订单");
						}else if(n.sd_order_id.indexOf("XSSK")>0){
							item.find("#openbill_type").html("收款-"+n.openbill_type);
							item.find("#surplus_sum").html(numformat2(n.allaccept_sum));
						}else{
							item.find("#openbill_type").html(n.openbill_type);
							item.find("#surplus_sum").html(numformat2(n.allaccept_sum));
						}
						item.find("#sd_order_id").html(n.sd_order_id);
						if (n.openbill_date>0) {
							var now = new Date(n.openbill_date);
							var nowStr = now.Format("yyyy-MM-dd"); 
							item.find("#openbill_date").html(n.nowStr);
						}
						if(n.sd_order_id&&n.sd_order_id.indexOf("XSKD")>0){
							item.find('.look').click({"orderNo":$.trim(n.item_id),"item_id":$.trim(n.item_id),"com_id":$.trim(n.com_id)},function(event){
								$(this).prev('.details').slideToggle();
								var t=$(this).parents(".statement");
								var b=t.find('.center-block>div').eq(0).hasClass("arrows02");
								if (b) {
									t.find('.center-block>div').eq(0).removeClass("arrows02");
									t.find('.center-block>div').eq(1).text('查看详情')
								}else{
									t.find('.center-block>div').eq(0).addClass("arrows02");
									t.find('.center-block>div').eq(1).text('收起')
								}
								$.get("../tailorMade/getTailorMadeInfo.do",event.data,function(data){
									if(data.info){
										t.find("#demandInfo").html(data.info.demandInfo);
										t.find("#imgs").html("");
										$.each(data.imgs,function(j,m){
											var imghtml=$('<img onclick="pop_up_box.showImg(this.src)" src="../'+m+'">');
											t.find("#imgs").append(imghtml);
										});
									}
								});
							});
						}else{
//							item.find('.look').hide();
							item.find('.look').click({"orderNo":$.trim(n.sd_order_id),"com_id":$.trim(n.com_id)},function(event){
								$(this).prev('.details').slideToggle();
								var t=$(this).parents(".statement");
								var b=t.find('.center-block>div').eq(0).hasClass("arrows02");
								if (b) {
									t.find('.center-block>div').eq(0).removeClass("arrows02");
									t.find('.center-block>div').eq(1).text('查看详情')
								}else{
									t.find('.center-block>div').eq(0).addClass("arrows02");
									t.find('.center-block>div').eq(1).text('收起')
								}
								t.find("#demandInfo").hide();
								$.get("../customer/getCertificateImg.do",{
									"orderNo":event.data.orderNo,
									"com_id":event.data.com_id
								},function(data){
									if(data){
										t.find("#imgs").html("");
										$.each(data,function(j,m){
											var imghtml=$('<img onclick="pop_up_box.showImg(this.src)" src="../'+m+'">');
											t.find("#imgs").append(imghtml);
										});
									}else{
										t.find("#imgs").html("未上传凭证!");
									}
								});
							})
						}
					}
				});
			}

			$(".closedig,.close").click(function(){
				$("#addbeizhu").hide();
			});
			
		}
}