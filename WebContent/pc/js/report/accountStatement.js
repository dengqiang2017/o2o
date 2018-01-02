$(function(){
	var customer_id="";
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
		
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
	
	$("#printdzd").click(function(){
		var beginDate=$.trim($("input[name='beginDate']").val());
		var endDate=$.trim($("input[name='endDate']").val());
		var key_words=$.trim($("input[name='key_words']").val());
		var name=$(".sim-msg>li:eq(0)").html();
		var phone=$(".sim-msg>li:eq(1)").html();
		var if_check=$("input[name='if_check']:checked").val();
		window.location.href="../pc/print/khdzd.html?"+customer_id+"|"+
		beginDate+"|"+endDate+"|"+name+"|"+phone+"|"+key_words+"|"+if_check;
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
	$("#settlement").click(function(){
		var i=$(".btn-success").index(this);
		pop_up_box.loadWait();
//		if (i==0) {
//			 $.get("../tree/getDeptTree.do",{"type":"client"},function(data){
//				   pop_up_box.loadWaitClose();
//				 $("body").append(data);
//				 client.init(function(){
//					 $("#customer_name").html(treeSelectName);
//					 $("#customer_id").val(treeSelectId);
//				 });
//			 });
//		}else{
			 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
				   pop_up_box.loadWaitClose();
				 $("body").append(data);
				 settlement.init(function(){
					 $("#settlement_name").html(treeSelectName);
					 $("#settlement_id").val(treeSelectId);
				 });
			 });
//		}
	});
	
	var surplus_sum=0;//欠款金额,用于催款
	$("#cuikuan").click(function(){
		if (!customer_id||$.trim(customer_id)=="") {
			$("#seekh").click();
		}else{
			if(surplus_sum>0){
//				var customerName=$.trim($(".sim-msg li:eq(0)").html());
				var title="您(单位)欠平台货款请尽快打款!";
				var description="截止到:"+nowStr+",累计金额:￥"+numformat2(surplus_sum)+"元.";
				pop_up_box.postWait();
				$.post("../employee/cuikuan.do",{
					"customer_id":customer_id,
					"title":title,
					"description":description,
					"headship":"财务"
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!");
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}else{
				pop_up_box.showMsg("该客户现目前不欠平台钱!");
			}
		}
	});
	$("input[name='if_check']").click(function(){
		$(".find").click();
	});
	$("#yqdz").click(function(){
		if (!customer_id||$.trim(customer_id)=="") {
			$("#seekh").click();
		}else{
			pop_up_box.postWait();
			$.post("inviteReconciliation.do",{
				"customer_id":customer_id,
				"title":"邀请客户对账",
				"description":",@comName邀请您进行对账.",
				"url":"/customer/accountStatement.do"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("邀请成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("邀请错误!" + data.msg);
					} else {
						pop_up_box.showMsg("邀请错误!");
					}
				}
			});
		}
	});
	
	$("th:eq(3)").hide();
	$(".find").click(function(){
		$("#qianming").attr("src","");
			if (!customer_id||$.trim(customer_id)=="") {
				$("#seekh").click();
				findflag=0;
				return;
			}
			if ($.trim($("#customer_id").val())=="") {
				$("#customer_id").val(customer_id);
			}
			pop_up_box.loadWait(); 
			$("tbody").html("");
			var corp_sim_name="";
			if ($.trim($(".sim-msg>li:eq(0)").html())!="") {
				corp_sim_name=$.trim($(".sim-msg>li:eq(0)").html());
			}
			var json={"client_id":customer_id,
					"beginDate":$("input[name='beginDate']").val(),
					"endDate":$("input[name='endDate']").val(),
					"key_words":$("input[name='key_words']").val(),
					"if_LargessGoods":"否",
//					"if_check":"全部",
					"if_check":$("input[name='if_check']:checked").val(),
					"settlement_sortID":$("input[name='settlement_sortID']").val()};
			$.get("accountStatementList.do",json,function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(13);
					$("tbody").append(tr);
					tr.find("td:eq(0)").html(n.sd_order_id);
					if (n.openbill_date>0) {
						var now = new Date(n.openbill_date);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(1)").html(nowStr);
					}
//					tr.find("td:eq(2)").html(n.openbill_type);
					if(n.sd_order_id){
						if(n.sd_order_id.indexOf("XSKD")>0){
							tr.find("td:eq(2)").html("下订单");
						}else if(n.sd_order_id.indexOf("XSSK")>0){
							tr.find("td:eq(2)").html("付款");
						}
					}
					
					if(n.beizhu){
						tr.find("td:eq(3)").html(n.beizhu.split("订单编号")[0]);
					}
					tr.find("td:eq(3)").hide();
					tr.find("td:eq(4)").html(n.settlement_sim_name);
					$("th:eq(4)").hide();
					tr.find("td:eq(4)").hide();
					tr.find("td:eq(5)").html(numformat2(n.accept_sum));
					tr.find("td:eq(6)").html(numformat2(n.allaccept_sum));
					tr.find("td:eq(7)").html(numformat2(n.surplus_sum));
					tr.find("td:eq(8)").html(n.item_sim_name);
					tr.find("td:eq(9)").html(numformat2(n.sd_oq));
					if (corp_sim_name!="") {
						tr.find("td:eq(10)").html(corp_sim_name);
					}else{
						tr.find("td:eq(10)").html(n.corp_sim_name);
					}
					if(n.qianmingTime>0){
						var now = new Date(n.qianmingTime);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(11)").html(nowStr);
					}
					tr.find("td:eq(12)").html(n.beizhu);
					if(i==(data.rows.length-1)){
						surplus_sum= parseFloat(n.surplus_sum);
					}
					tr.click({"qianmingTime":n.qianmingTime},function(event){
						$("#qianming").attr("src","");
						$.get("../report/getQianmingimg.do",{"qianmingTime":event.data.qianmingTime,"type":"ard"},function(data){
							if(data.msg){
								$("#qianming").attr("src",data.msg);
							}
						});
					});
				});
				pop_up_box.loadWaitClose();
				findflag=0;
			});
			if(surplus_sum>0){
				$("#cuikuan").show();
			}else{
				$("#cuikuan").hide();
			}
	});
	/////////////////
	try {
		var params=window.location.href.split("?")[1].split("&");
		customer_id=params[0].split("=")[1];
		$(".sim-msg>li:eq(0)").html(decodeURI(params[1].split("=")[1]));
		$(".sim-msg>li:eq(1)").html(params[2].split("=")[1]);
		$(".find:eq(0)").click();
	} catch (e) {
		// TODO: handle exception
	}
});