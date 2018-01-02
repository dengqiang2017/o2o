$(function(){
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
//				"if_check":$("input[name='if_check']:checked").val(),
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
//					item.find('.look').hide();
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
//			$(".pro-check").unbind("click");
//			$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
//				var b=$(this).hasClass("pro-checked");
//				if (b) {
//					$(this).removeClass("pro-checked");
//				}else{ 
//					$(this).addClass("pro-checked");
//				}
//			});
		});
	}
	$(".find").click(function(){
		loadData();	
	});
	$(".closedig,.close").click(function(){
		$("#addbeizhu").hide();
	});
	$(".find").click();
});