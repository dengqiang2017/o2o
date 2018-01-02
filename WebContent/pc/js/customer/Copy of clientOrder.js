$(function(){
	var tritem=$("tbody:eq(0) tr");
	var jsitem=$("tbody:eq(1) tr");
	$("tbody").html("");
	var zsksum=0;
	var ycksum=0;
	var edksum=0;
	var orderlist=[];
	var transport_AgentClerk_Reciever=$("select[name='transport_AgentClerk_Reciever']");
	var Kar_Driver=$("input[name='Kar_Driver']");
	var Kar_Driver_Msg_Mobile=$("input[name='Kar_Driver_Msg_Mobile']");
	var Kar_paizhao=$("input[name='Kar_paizhao']");
	var FHDZ=$("textarea[name='FHDZ']");
	pop_up_box.loadWait();
	$.get("getPayOderRecord.do",function(data){
		var list=data.list;
		for (var i = 0; i < data.list.length; i++) {
			var tr=getTr(4);
			$("tbody:eq(0)").append(tr);
			tr.find("td:eq(0)").html(list[i].ivt_oper_listing);
			tr.find("td:eq(1)").html(list[i].item_name+"<input type='hidden' value='"+list[i].item_id+"'>");
			tr.find("td:eq(2)").html(list[i].sd_oq);
			tr.find("td:eq(3)").html(list[i].je);
			tr.find("a").attr("href","myorder.do");
			$("#orderNo").val(list[i].ivt_oper_listing);//该支付的订单编号
			orderlist.push(JSON.stringify({"ivt_oper_listing":list[i].ivt_oper_listing,"seeds_id":list[i].seeds_id,"item_id":list[i].item_id}));
		}
		pop_up_box.loadWaitClose();
		var now = new Date();
		var nowStr = now.Format("yyyy-MM-dd"); 
		$(".order-msg li:eq(0)").html(nowStr);
		  nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
		$("#nowdate").html(nowStr);
		if (data.ordercount) {
			$(".order-msg li:eq(1)").html(data.ordercount.sd_oq);
			$(".order-msg li:eq(2)>span").html(data.ordercount.zje);
//			$(".order-msg li:eq(3)>span").html(data.ordercount.zje);
			$(".order-msg li:eq(4)>span").html(data.ordercount.zje);
			$("#zje").html(data.ordercount.zje);
		}
			
		if (data.customerinfo.Kar_Driver) {
			Kar_Driver.val(data.customerinfo.Kar_Driver);
		}
		if (data.customerinfo.FHDZ) {
			FHDZ.val(data.customerinfo.FHDZ);
		}
		if (data.customerinfo.Kar_Driver_Msg_Mobile) {
			Kar_Driver_Msg_Mobile.val(data.customerinfo.Kar_Driver_Msg_Mobile);
		}
		if (data.customerinfo.Kar_paizhao) {
			Kar_paizhao.val(data.customerinfo.Kar_paizhao);
		}
		if (data.customerinfo.transport_AgentClerk_Reciever) {
			transport_AgentClerk_Reciever.val(data.customerinfo.transport_AgentClerk_Reciever);
		}
		////////////////////////
		var acct_recieve_sum=0;
		if (data.accounts&&data.accounts.acct_recieve_sum) {
			acct_recieve_sum=data.accounts.acct_recieve_sum;
		}
		$("#ysk").html(numformat(acct_recieve_sum,2));
		$("#zhye").html(numformat(parseFloat(acct_recieve_sum)*-1,2));
		initNumInput();
//		function getTdY(je){
//			return "<td width='10%'>"+je+"</td>";
//		}
//		function getTd(je){
//			return "<td width='10%'><input type='tel' data-number='n' maxlength='10' class='tableinput' value='"+je+"'></td>";
//		}
//		var zsksy=0;
//		var ycksy=0;
//		var edksy=0;
//		for (var i = 0; i < data.jsfslsit.length; i++) {
//			var item=data.jsfslsit[i];
//			var trjs=jsitem.clone(true);
//			$("tbody:eq(1)").append(trjs);
//			$(trjs.find("td")[0]).html(item.settlement_sim_name+"<input type='hidden' value='"+item.sort_id+"'>"); 
//			$(trjs.find("td")[1]).html(item.cheque_flag);
//			$(trjs.find("td")[2]).html(item.acct_recieve_sum);
//			var cheque_flag=$.trim(item.cheque_flag);
//			if (cheque_flag=="账上款") {
//				var je=parseFloat(item.acct_recieve_sum);
//				zsksum+=je;
//				if (je>0&&ycksy>=0) {
//					if (je>data.ordercount.zje) {//余额大于总金额直接付款不需要预存款
//						ycksy=-1;
//					}else{//总金额大于余额,总金额-总余额
//						if (zsksum>data.ordercount.zje) {
//							ycksy=-1;
//						}else{
//							ycksy=data.ordercount.zje-zsksum;
//						}
//					}
//				}else{//余额小于0进入预存款
//					ycksy=data.ordercount.zje;
//				}
//			}else if (cheque_flag=="预存款") {
//				var yckye=parseFloat(item.acct_recieve_sum);
//				ycksum+=yckye;
//				if (yckye>0&&ycksy>0) {
//					var je=0;
//					if (yckye>ycksy) {//预存款余额减去剩余支付的
//						je=ycksy;
//						ycksy=0;
//					}else{
//						je=yckye;
//						ycksy=ycksy-je;
//						if (ycksy<0) {
//							ycksy=ycksy*-1;
//						}
//					}
//					trjs.append(getTdY(je));
//				}else{
//					trjs.append(getTdY(0));
//				}
//			}else{
//				var edkye=parseFloat(item.acct_recieve_sum);
//				edksum+=edkye;
//				if (ycksy<0) {
//					trjs.append(getTd(0));
//				}else{
//					if (edkye>ycksy) {
//						trjs.append(getTd(0));
//					}else{
//						trjs.append(getTd(ycksy-edkye));
//					}
//				}
//			}
//		}
//		var zje=parseFloat($(".order-msg li:eq(4) span").html());
//		if (zje<=(zsksum+edksum)) {
//			$("h4:eq(0)").show();
//		}else if(zje>(zsksum+ycksum+edksum)){
//			$("h4:eq(2)").show();
//		}else if(zje>(zsksum+edksum)){
//			$("h4:eq(1)").show();
//		}
	});
//	$(".btn-success").click(function(){
//		 pop_up_box.loadWait();
//		 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
//			   pop_up_box.loadWaitClose();
//			 $("body").append(data);
//		 });
//	});
	/////////////////////
	$(".modal,.modal-cover").hide();
	$(".close").click(function(){
		$(".modal,.modal-cover").hide();
	});
	transport_AgentClerk_Reciever.val($.cookie("transport_AgentClerk_Reciever"));
	Kar_Driver.val($.cookie("Kar_Driver"));
	Kar_Driver_Msg_Mobile.val($.cookie("Kar_Driver_Msg_Mobile"));
	Kar_paizhao.val($.cookie("Kar_paizhao"));
	FHDZ.val($.cookie("FHDZ"));
	$(".btn-info").click(function(){
		 if ($.trim($("tbody:eq(0)").html())=="") {
			pop_up_box.showMsg("还没有要支付的产品,去选择产品吧!");
		}else if($.trim(transport_AgentClerk_Reciever.val())==""){
			pop_up_box.showMsg("请选择拉货方式!");
		}else if($.trim(Kar_Driver.val())==""){
			pop_up_box.showMsg("请输入司机姓名!");
		}else if($.trim(Kar_Driver_Msg_Mobile.val())==""){
			pop_up_box.showMsg("请输入司机手机!");
		}else if($.trim(Kar_paizhao.val())==""){
			pop_up_box.showMsg("请输入车牌号!");
		}
//		else if($.trim(FHDZ.val())==""){
//			pop_up_box.showMsg("请输入发货地址 !");
//		}
		else{
			var zhye=parseFloat($.trim($("#zhye").html()));
			var ddzje=parseFloat($.trim($(".order-msg li:eq(4)>span").html()));
			var b=false;
			var cha=0;
			var ljje=0;
			$("#mzhye").html(zhye);
			$("#mzje").html(ddzje);
			var ifUseCredit=$("#ifUseCredit").val();
			if (zhye>0) {//1.判断账户余额是否大于0
				if (zhye<ddzje) {//1.2判断账户余额小于订单总金额
					cha=ddzje-zhye;
				}else{
					b=true;
				}
			}else{
				ljje=(zhye*-1)+ddzje;
			}
			////////////////////
			$.cookie("Kar_Driver",$.trim(Kar_Driver.val()));
			$.cookie("Kar_paizhao",$.trim(Kar_paizhao.val()));
			$.cookie("transport_AgentClerk_Reciever",$.trim(transport_AgentClerk_Reciever.val()));
			$.cookie("Kar_Driver_Msg_Mobile",$.trim(Kar_Driver_Msg_Mobile.val()));
			$.cookie("FHDZ",$.trim(FHDZ.val()));
			/////////////////
			if (b) {
				pop_up_box.postWait();
				$.post("orderPayment.do",{
					"orderlist":orderlist,
					"transport_AgentClerk_Reciever":transport_AgentClerk_Reciever.val(),
					"Kar_Driver":Kar_Driver.val(),
					"Kar_Driver_Msg_Mobile":Kar_Driver_Msg_Mobile.val(),
					"Kar_paizhao":Kar_paizhao.val(),
					"FHDZ":FHDZ.val()
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.success){
						$.removeCookie("Kar_Driver");
						$.removeCookie("Kar_paizhao");
						$.removeCookie("transport_AgentClerk_Reciever");
						$.removeCookie("Kar_Driver_Msg_Mobile");
						$.removeCookie("FHDZ");
						 window.localtion.href="order.do";
					}else{
						pop_up_box.showMsg("保存出错,错误:"+data.msg);
					}
				});
			}else{
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd"); 
				$.cookie("customerName",$.trim($("#customerName").val()));
				$.cookie("date",nowStr);
				$.cookie("ddje",ddzje);
				$.cookie("ljqk",ljje);
				$.cookie("orderlist",orderlist);
				if (ifUseCredit=="是") {
					$(".modal,.modal-cover").show();
				}else{
					pop_up_box.showMsg("余额不足,请充值后再进行操作!",function(){
//						$("#paymoney").click();
						window.open("paymoney.do","_blank");
					});
				}
			}
			return;
//			var zje=parseFloat($(".order-msg li:eq(4) span").html());
//			var spje=0;
//			var splist=[];
//			//1.计算总付款金额和支付金额是否符合条件
//			//1.1计算总付款金额
//			var zfkje=[];
//			///账上款金额列表
//			var zsklsit=[];
//			///账上款金额信息列表
//			var zskjsonlist=[];
//			//预存款金额列表
//			var yckjsonlist=[];
//			//信用额度金额列表
//			var edkjsonlist=[];
//			
//			for (var i = 0; i < $("tbody:eq(1) tr").length; i++) {
//				var sqje=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(3) input").val());//申请金额
//				if ($("tbody:eq(1) tr:eq("+i+") td:eq(3) input").length<=0) {
//					sqje=0;
//				}
//				var je=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(2)").html());//金额
//				if (sqje>0) {
//					zfkje.push(parseFloat(sqje));
//				}
//				if (je>0) {
//					zfkje.push(parseFloat(je));
//				}
//				var jsfstype=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(1)").html());//结算类型
//				var jsfssort_id=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(0) input").val());//账户id
//				if (jsfstype=="账上款") {
//					zsklsit.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id}));
//				}else if (jsfstype=="预存款") {
//					var ycsqje=$.trim($("tbody:eq(1) tr:eq("+i+") td:eq(3)").html());//申请金额
//					yckjsonlist.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id,"sqje":ycsqje}));
//				}else{
//					edkjsonlist.push(JSON.stringify({"je":je,"jsfstype":jsfstype,"jsfssort_id":jsfssort_id,"sqje":sqje}));
//				}
//			}
//			var zfje=0;
//			for (var i = 0; i < zfkje.length; i++) {
//				zfje=zfje+zfkje[i];
//			}
//			if (zfje<zje) {
//				pop_up_box.showMsg("您的账户可用金额小于支付金额!");
//				return;
//			}
//				$.post("orderPayment.do",{
//					"zje":zje,
//					"transport_AgentClerk_Reciever":$("#transport_AgentClerk_Reciever").val(),//物流方式
//					"fhdz":$("#fhdz").html(),//发货地址
//					"zsklsit":zsklsit,//账上款json列表
//					"yckjsonlist":yckjsonlist,//预存款json列表
//					"edkjsonlist":edkjsonlist,//额度款json列表
//					"orderlist":orderlist//订单信息列表
//				},function(data){
//					if (data.success) {
//						pop_up_box.showMsg("保存成功",function(){
//							window.location.href="../customer.do";
//						});
//					}else{
//						pop_up_box.showMsg("保存数据异常!错误:"+data.msg);
//					}
//				});
		}
	});
});