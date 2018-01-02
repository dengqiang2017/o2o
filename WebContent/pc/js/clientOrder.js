$(function(){
	var tritem=$("tbody:eq(0) tr");
	var jsitem=$("tbody:eq(1) tr");
	$("tbody").html("");
	var zsksum=0;
	var ycksum=0;
	var edksum=0;
	var orderlist=[];
	$.get("getPayOderRecord.do",function(data){
		var list=data.list;
		for (var i = 0; i < data.list.length; i++) {
			var tr=tritem.clone(true);
			$("tbody:eq(0)").append(tr);
			var td=$(tr.find("td")[0]);
			td.find("a").html(list[i].ivt_oper_listing);
			$(tr.find("td")[1]).html(list[i].item_name+"<input type='hidden' value='"+list[i].item_id+"'>");
			$(tr.find("td")[2]).html(list[i].pack_num);
			$(tr.find("td")[3]).html(list[i].je);
			td.find("a").attr("href","myorder.do");
			$("#orderNo").val(list[i].ivt_oper_listing);//该支付的订单编号
			orderlist.push(JSON.stringify({"ivt_oper_listing":list[i].ivt_oper_listing,"seeds_id":list[i].seeds_id,"item_id":list[i].item_id}));
		}
		var now = new Date();
		var nowStr = now.Format("yyyy-MM-dd"); 
		$($(".order-msg li")[0]).html(nowStr);
		if (data.ordercount) {
			$($(".order-msg li")[1]).html(data.ordercount.pack_num);
			$($(".order-msg li>span")[0]).html(data.ordercount.zje);
			$($(".order-msg li>span")[2]).html(data.ordercount.zje);
			$("#zje").html(data.ordercount.zje);
			$("#fhdz").html(data.customerinfo.FHDZ);
			$("#HY_tyle").html(data.customerinfo.HY_style);
		}
		////////////////////////
		function getTdY(je){
			return "<td width='10%'>"+je+"</td>";
		}
		function getTd(je){
			return "<td width='10%'><input type='tel' data-number='n' maxlength='10' class='tableinput' value='"+je+"'></td>";
		}
		var zsksy=0;
		var ycksy=0;
		var edksy=0;
		for (var i = 0; i < data.jsfslsit.length; i++) {
			var item=data.jsfslsit[i];
			var trjs=jsitem.clone(true);
			$("tbody:eq(1)").append(trjs);
			$(trjs.find("td")[0]).html(item.settlement_sim_name+"<input type='hidden' value='"+item.sort_id+"'>"); 
			$(trjs.find("td")[1]).html(item.cheque_flag);
			$(trjs.find("td")[2]).html(item.acct_recieve_sum);
			var cheque_flag=$.trim(item.cheque_flag);
			if (cheque_flag=="账上款") {
				var je=parseFloat(item.acct_recieve_sum);
				zsksum+=je;
				if (je>0&&ycksy>=0) {
					if (je>data.ordercount.zje) {//余额大于总金额直接付款不需要预存款
						ycksy=-1;
					}else{//总金额大于余额,总金额-总余额
						if (zsksum>data.ordercount.zje) {
							ycksy=-1;
						}else{
							ycksy=data.ordercount.zje-zsksum;
						}
					}
				}else{//余额小于0进入预存款
					ycksy=data.ordercount.zje;
				}
			}else if (cheque_flag=="预存款") {
				var yckye=parseFloat(item.acct_recieve_sum);
				ycksum+=yckye;
				if (yckye>0&&ycksy>0) {
					var je=0;
					if (yckye>ycksy) {//预存款余额减去剩余支付的
						je=ycksy;
						ycksy=0;
					}else{
						je=yckye;
						ycksy=ycksy-je;
						if (ycksy<0) {
							ycksy=ycksy*-1;
						}
					}
					trjs.append(getTdY(je));
				}else{
					trjs.append(getTdY(0));
				}
			}else{
				var edkye=parseFloat(item.acct_recieve_sum);
				edksum+=edkye;
				if (ycksy<0) {
					trjs.append(getTd(0));
				}else{
					if (edkye>ycksy) {
						trjs.append(getTd(0));
					}else{
						trjs.append(getTd(ycksy-edkye));
					}
				}
			}
		}
		initNumInput();
		/////////////////
		var zje=parseFloat($(".order-msg li:eq(4) span").html());
		$("h4").hide();
		if (zje<=(zsksum+edksum)) {
			$("h4:eq(0)").show();
		}else if(zje>(zsksum+ycksum+edksum)){
			$("h4:eq(2)").show();
		}else if(zje>(zsksum+edksum)){
			$("h4:eq(1)").show();
		}
	});
	$(".btn-success").click(function(){
		 pop_up_box.loadWait();
		 $.get("./tree/getDeptTree.do",{"type":"settlement"},function(data){
			   pop_up_box.loadWaitClose();
			 $("body").append(data);
		 });
	});
	$(".btn-info").click(function(){
		var fhdz=$.trim($("#fhdz").val());
		 if ($.trim($("tbody:eq(0)").html())=="") {
			pop_up_box.showMsg("还没有要支付的产品,去选择产品吧!");
		}else if(fhdz==""){
			pop_up_box.showMsg("请输入发货地址!");
		}else{
			var zje=parseFloat($(".order-msg li:eq(4) span").html());
			var spje=0;
			var splist=[];
			//1.计算总付款金额和支付金额是否符合条件
			//1.1计算总付款金额
			var zfkje=[];
			///账上款金额列表
			var zsklsit=[];
			///账上款金额信息列表
			var zskjsonlist=[];
			//预存款金额列表
			var yckjsonlist=[];
			//信用额度金额列表
			var edkjsonlist=[];
			
			for (var i = 0; i < $("tbody:eq(1) tr").length; i++) {
				var sqje=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(3) input").val());//申请金额
				if ($("tbody:eq(1) tr:eq("+i+") td:eq(3) input").length<=0) {
					sqje=0;
				}
				var je=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(2)").html());//金额
				if (sqje>0) {
					zfkje.push(parseFloat(sqje));
				}
				if (je>0) {
					zfkje.push(parseFloat(je));
				}
				var jsfstype=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(1)").html());//结算类型
				var jsfssort_id=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(0) input").val());//账户id
				if (jsfstype=="账上款") {
					zsklsit.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id}));
				}else if (jsfstype=="预存款") {
					var ycsqje=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(3)").html());//申请金额
					yckjsonlist.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id,"sqje":ycsqje}));
				}else{
					edkjsonlist.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id,"sqje":sqje}));
				}
			}
			var zfje=0;
			for (var i = 0; i < zfkje.length; i++) {
				zfje=zfje+zfkje[i];
			}
			if (zfje<zje) {
				pop_up_box.showMsg("您的账户可用金额小于支付金额!");
				return;
			}
				$.post("orderPayment.do",{
					"zje":zje,
					"transport_AgentClerk_Reciever":$("#transport_AgentClerk_Reciever").val(),//物流方式
					"fhdz":$("#fhdz").html(),//发货地址
					"zsklsit":zsklsit,//账上款json列表
					"yckjsonlist":yckjsonlist,//预存款json列表
					"edkjsonlist":edkjsonlist,//额度款json列表
					"orderlist":orderlist//订单信息列表
				},function(data){
					if (data.success) {
						pop_up_box.showMsg("保存成功",function(){
							window.location.href="../customer.do";
						});
					}else{
						pop_up_box.showMsg("保存数据异常!错误:"+data.msg);
					}
				});
		}
	});
});