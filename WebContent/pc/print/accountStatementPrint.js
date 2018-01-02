$(function(){
	var customer_id;
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
		var corp_name=$(".sim-msg>li:eq(0)").html();
		var telno=$(".sim-msg>li:eq(1)").html();
		$("#corp_name").html(corp_name);
		$("#telno").html(telno);
	},"../../employee/");
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
		pop_up_box.loadWait();
		 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
			   pop_up_box.loadWaitClose();
			 $("body").append(data);
			 settlement.init(function(){
				 $("#settlement_name").html(treeSelectName);
				 $("#settlement_id").val(treeSelectId);
			 });
		});
	});
	$(".print").click(function(){
		$("#print").jqprint();
	});
	$("input[name='if_check']").click(function(){
		$(".find").click();
	});
	$(".find").click(function(){
		$("#qianming").attr("src","");
			if (!customer_id||$.trim(customer_id)=="") {
				$("#seekh").click();
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
			$.get("../../report/accountStatementList.do",json,function(data){
				pop_up_box.loadWaitClose();
				var qianmingTime="";
				$.each(data.rows,function(i,n){
					var tr=getTr(11);
					$("tbody").append(tr);
					if (n.openbill_date>0) {
						var now = new Date(n.openbill_date);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(0)").html(nowStr);
					}
					tr.find("td:eq(1)").html(n.sd_order_id);
					if($.trim(n.openbill_type)=="账上款"){
						tr.find("td:eq(2)").html("收款");
					}else if(n.openbill_type=="合计"){
						tr.find("td:eq(2)").html("合计");
					}else{
						tr.find("td:eq(2)").html("发货");
					}
//					style="WORD-WRAP: break-word" width="20"
//					tr.find("td").css("word-wrap","break-word");
//					tr.find("td").css("width","20px");
					tr.find("td:eq(3)").html(n.item_sim_name);
					tr.find("td:eq(4)").html(n.item_spec);
					tr.find("td:eq(5)").html(n.item_type);
					
					tr.find("td:eq(6)").html(numformat(n.sd_oq,0));
					tr.find("td:eq(7)").html(numformat2(n.accept_sum));
					tr.find("td:eq(8)").html(numformat2(n.surplus_sum));
					tr.find("td:eq(9)").html(numformat2(n.allaccept_sum));
//					tr.find("td:eq(10)").html(n.qianming);
					if(n.qianmingTime>0){
						var now = new Date(n.qianmingTime);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(10)").html(nowStr);
						qianmingTime=n.qianmingTime;
					}
					tr.click({"qianmingTime":n.qianmingTime},function(event){
						$("#qianming").attr("src","");
						$.get("../../report/getQianmingimg.do",{"qianmingTime":event.data.qianmingTimem,"type":"ard"},function(data){
							if(data.msg){
								$("#qianming").attr("src",data.msg);
							}
						});
					});
				});
					$("#qianming").attr("src","");
					$.get("../../report/getQianmingimg.do",{"qianmingTime":qianmingTime,"type":"ard"},function(data){
						if(data.msg){
							$("#qianming").attr("src",data.msg);
						}
					});
			});
	});
	
	try {
	var  url=window.location.href.split("?")[1].split("|");
	customer_id=url[0];
	$("input[name='beginDate']").val(url[1]);
	$("input[name='endDate']").val(url[2]);
	if(url.length==6){
		$("#corp_name").html(decodeURI(url[3]).split("|")[0]);
		$("#telno").html(decodeURI(url[3]).split("|")[1]);
		$("input[name='key_words']").val(decodeURI(url[4]));
		$("input[value='"+decodeURI(url[5])+"']").attr("checked","checked");
	}else{
		var url2=decodeURI(url[3]).split("|");
		$("#corp_name").html(decodeURI(url2[0]));
		$("#telno").html(url2[1]);
		$("input[name='key_words']").val(decodeURI(url[4]));
	}
	$(".find:eq(0)").click();
} catch (e) {
	alert("参数错误,请手动查询!");
	$(".box-head").show();
	}
});