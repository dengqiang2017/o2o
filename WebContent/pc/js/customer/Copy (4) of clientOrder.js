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
	/////////////////////////////////////////
	var account_zf_je=0;
	pop_up_box.loadWait();
	$.get("getPayOderRecord.do",function(data){
		pop_up_box.loadWaitClose();
		var list=data.list;
		if (!list||data.list.length==0) {
			window.location.href="order.do";
		}
		for (var i = 0; i < data.list.length; i++) {
			var tr=getTr(4);
			$("tbody:eq(0)").append(tr);
			tr.find("td:eq(0)").html(list[i].ivt_oper_listing);
			tr.find("td:eq(1)").html(list[i].item_name+"<input type='hidden' value='"+list[i].item_id+"'>");
			tr.find("td:eq(2)").html(list[i].sd_oq);
			tr.find("td:eq(3)").html(list[i].je);
			tr.find("a").attr("href","myorder.do");
			$("#orderNo").val(list[i].ivt_oper_listing);//该支付的订单编号
			orderlist.push(JSON.stringify({"ivt_oper_listing":list[i].ivt_oper_listing,"seeds_id":list[i].seeds_id,"item_id":list[i].item_id,"item_name":list[i].item_name}));
		}
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
		///////////////////////
		$("#ysk").html(numformat(acct_recieve_sum,2));//应收款
		//账户总余额
		var zhye=numformat(parseFloat(acct_recieve_sum)*-1,2);
		$("#zhye").html(zhye);
		/////////
		function jsfslsitTr(){
			var tr="<tr><td width='50'><div class='checkbox'><input type='hidden'></div></td>";
            tr+="<td></td><td></td><td></td>";
            tr+="<td width='200'><input type='text' class='tableinput' data-number='n' value='0'></td></tr>";
            return tr;
		}
		////////////
		//订单总金额
		var ddzje=parseFloat($(".order-msg li:eq(4)>span").html());
		var yue=ddzje;//计算余额
		//////////
		var zsk_yue=0;//结算方式余额累加;
		var yck_yue=0;//预存款累加
		////////20115-10-24 20:08/////
		$.each(data.jsfslsit,function(i,n){
			var acct_recieve_sum=parseFloat(n.acct_recieve_sum);
			if ("账上款"==n.cheque_flag) {
				zsk_yue+=acct_recieve_sum;
			}else{
				yck_yue+=acct_recieve_sum;
			}
		});
		yue=zsk_yue;
		////////////////////////////
		$.each(data.jsfslsit,function(i,n){
			var tr=$(jsfslsitTr());
			$("tbody:eq(1)").append(tr);
			tr.find("td:eq(0)").find("input[type='hidden']").val(n.sort_id);
			tr.find("td:eq(1)").html(n.cheque_flag);
			tr.find("td:eq(2)").html(n.settlement_sim_name);
			tr.find("td:eq(3)").html(n.acct_recieve_sum);
			var acct_recieve_sum=parseFloat(n.acct_recieve_sum);
			if ("账上款"==n.cheque_flag) {
				if (acct_recieve_sum>0) {
					//总余额减去账户余额 
					var nyue=yue-acct_recieve_sum;//当前余额
					if (yue>0) {
						if (nyue>=0) {
							yue=nyue;
							tr.find("td:eq(4)>input").val(numformat(acct_recieve_sum,2));
						}else{
							tr.find("td:eq(4)>input").val(numformat(yue,2));
							yue=0;
						}
						account_zf_je+=parseFloat(tr.find("td:eq(4)>input").val());
						tr.find("td:eq(0)>.checkbox").addClass("checkedbox");
						tr.find("td:eq(4)>input").prop("disabled",false);
					}else{
						tr.find("td:eq(4)>input").prop("disabled",true);
					}
				}else{
					tr.find("td:eq(4)>input").prop("disabled",true);
				}
			}else{
				tr.find("td:eq(4)>input").prop("disabled",true);
			}
			if ($("#settlementModal").val()=="1") {
				$("thead:eq(1)").find("th:eq(0)").hide();
				tr.find("td:eq(0)").hide();
				tr.find("td:eq(4)>input").prop("readonly",true);
			}else{
				$("thead:eq(1)").find("th:eq(0)").show();
				tr.find("td:eq(0)").show();
				tr.find("td:eq(4)>input").prop("readonly",false);
			}
		});
//		yue=parseFloat(numformat(yue,2));
		$("tbody:eq(2)").html("");
		var ztr=$("<tr><td></td><td></td></tr>");
		$("tbody:eq(2)").append(ztr);
		ztr.find("td:eq(0)").html("账上款");
		ztr.find("td:eq(1)").html(numformat(zsk_yue,2));
		if (yck_yue>0) {
			ztr=$("<tr><td></td><td></td></tr>");
			$("tbody:eq(2)").append(ztr);
			if (zhye<ddzje) {
				ztr.find("td:eq(0)").html("预存款");
			}else{
				ztr.find("td:eq(0)").html("<div class='checkbox'></div>预存款");
			}
			ztr.find("td:eq(1)").html(numformat(yck_yue,2));
		}
		///////2015-10-24 20:00
		//金额小于等于0的时,需要差额就是订单总金额
		//////
//		订单金额大于账上款金额,
		///////
//		if (zsk_yue<=0) {
//				$("#jeMsg>span").html(numformat(ddzje,2));
//				$("#jeMsg>label:eq(0)").html("总");
//				$("#jeMsg>label:eq(1)").html("");
//				$("#jeMsg").show();
//		}else{
//			if ( ddzje>zsk_yue) {
//				$("#jeMsg>span").html(numformat(ddzje,2));
//				$("#jeMsg>label:eq(0)").html("[账上款]");
//				$("#jeMsg>label:eq(1)").html("但您可勾选申请使用预存款!");
//				$("#jeMsg").show();
//			}
//		}
//		if (yck_yue>=ddzje) {
//			$("#jeMsg>span").html(numformat(yck_yue-ddzje,2));
//			$("#jeMsg>label:eq(0)").html("[账上款]");
//			$("#jeMsg>label:eq(1)").html("但您可勾选申请使用预存款!");
//			$("#jeMsg").show();
//		}
		///////////////////////////////
		if (zhye>=ddzje) {
			if (zsk_yue>ddzje) {
				$("#jeMsg>label:eq(0)").html("[账上款]");
				$("#jeMsg>label:eq(1)").html("但您可勾选申请使用预存款!");
				$("#jeMsg").show();
			}
		}else{
			$("#jeMsg>span").html(numformat(ddzje,2));
			$("#jeMsg>label:eq(0)").html("总");
			$("#jeMsg>label:eq(1)").html("");
			$("#jeMsg").show();
		}
		
		///////////////////////////
		setcheckbox(true);
		$(".checkbox").click(function(){
			var b=$(this).hasClass("checkedbox");
			if (b) {
				$(this).parents("tr").find("td:eq(4)>input").prop("disabled",false);
			}else{
				$(this).parents("tr").find("td:eq(4)>input").val("0");
				$(this).parents("tr").find("td:eq(4)>input").prop("disabled",true);
			}
		});

		//预存款选择事件
		ztr.find(".checkbox").click(function(){
			//订单总金额
			var ddzje=parseFloat($(".order-msg li:eq(4)>span").html());
			///账上款余额
			var zfje_ins=parseFloat($.trim($("tbody:eq(2)").find("tr:eq(0)>td:eq(1)").html()));
			///预存款余额
			var yck_yue=$.trim($("tbody:eq(2)").find("tr:eq(1)>td:eq(1)").html());
			///需要给预存款结算方式设置值
			var yck_ins=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('预存款')");
			if ($(this).hasClass("checkedbox")) {
				var zf_val=0;
				if (ddzje>zfje_ins) {
					//预存款支付金额
					var yck_zfje;//=ddzje-zfje_ins;//预存款需要支付金额
					/////////2015-10-24 20:10//////
					if (zfje_ins>0) {
						yck_zfje=ddzje-zfje_ins;
					}else{
						yck_zfje=ddzje;
					}
				///////////
					if (yck_zfje>0) {
						for (var i = 0; i < yck_ins.length; i++) {
							var yck_tr=$(yck_ins[i]).parents("tr");
							var yck_je=parseFloat(yck_tr.find("td:eq(3)").html());
							if (yck_je>0) {///查找结算方式列表中预存款金额大于0
								if (yck_je>yck_zfje) {
									yck_tr.find("td:eq(4)>input").val(yck_zfje);
									break;
								}else{
									yck_zfje= yck_zfje-yck_je;//预存款支付金额-预存款金额=下一笔预存款需要支付的金额
								}
								if (yck_zfje>0) {//下一笔预存款支付大于0
									yck_tr.find("td:eq(4)>input").val(yck_je);
								}else{//下一笔预存款支付小于等于0
									yck_tr.find("td:eq(4)>input").val((yck_zfje*-1));
								}
							}
						}
						//订单总金额-账上款-预存款=还需要另外支付的金额
//						var cha_je=ddzje-zfje_ins-yck_yue;
//						if (zfje_ins<0) {
//							cha_je=ddzje-yck_yue;
//						}
//						if (cha_je>0) {
//							$("#jeMsg>span").html(numformat(ddzje,2));
//							$("#jeMsg>label:eq(0)").html("总");
//							$("#jeMsg>label:eq(1)").html("");
//							$("#jeMsg").show();
//						}else{
							$("#jeMsg>span").html("0");
							$("#jeMsg").hide();
//						}
					}
				}
			}else{
				for (var i = 0; i < yck_ins.length; i++) {
					var yck_tr=$(yck_ins[i]).parents("tr");
					yck_tr.find("td:eq(4)>input").val(0);
				}
//				var cha_je=ddzje-zfje_ins;
//				if (cha_je>0) {
					$("#jeMsg>span").html(numformat(ddzje,2));
					$("#jeMsg>label:eq(0)").html("[账上款]");
					$("#jeMsg>label:eq(1)").html("但您可勾选申请使用预存款!");
					$("#jeMsg").show();
//				}else{
//					$("#jeMsg>span").html("0");
//					$("#jeMsg").hide();
//				}
			}
			
		});
		$(".tableinput").click(function(){
			
		});
		////////////////////////		
		initNumInput();
	});
	///////////////////////////////////////////////////
	$("#jstable").click(function(){
		if($(".table-responsive:eq(1)").css("display")=="none"){
			$(".table-responsive:eq(1)").show();
		}else{
			$(".table-responsive:eq(1)").hide();
		}
	});
	//////////////////////////////////
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
			///获取结算方式支付金额大于0 的
//			var jiescheck=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('账上款')");
//			var jiesList=[];
//			var zsk_zfje=0;//账上款支付金额
//			for (var i = 0; i < jiescheck.length; i++) {
//				var item=$(jiescheck[i]).parents("tr");
//				var jies_no=$.trim(item.find("input").val());
//				var jies_je=$.trim(item.find("td:eq(4)>input").val());
//				if (jies_je&&jies_je!="0") {
//					zsk_zfje+=parseFloat(jies_je);
//					var jies_cls=$.trim(item.find("td:eq(1)").html());
//					var jies_name=$.trim(item.find("td:eq(2)").html());
//					jiesList.push(JSON.stringify({"jies_no":jies_no,"jies_je":jies_je,"jies_name":jies_name,"jies_cls":jies_cls}));
//				}
//			}
			var jiesYck=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('预存款')");
			var jiesListYCK=[];
			var yck_zfje=0;//预存款支付金额
			for (var i = 0; i < jiesYck.length; i++) {
				var item=$(jiesYck[i]).parents("tr");
				var jies_no=$.trim(item.find("input").val());
				var jies_je=$.trim(item.find("td:eq(4)>input").val());
				if (jies_je&&jies_je!="0") {
					yck_zfje+=parseFloat(jies_je);
					var jies_cls=$.trim(item.find("td:eq(1)").html());
					var jies_name=$.trim(item.find("td:eq(2)").html());
					jiesListYCK.push(JSON.stringify({"jies_no":jies_no,"jies_je":jies_je,"jies_name":jies_name,"jies_cls":jies_cls}));
				}
			}
			////
			var zhye=parseFloat(numformat($.trim($("#zhye").html(),2)));
			var ddzje=parseFloat(numformat($.trim($(".order-msg li:eq(4)>span").html()),2));
			var b=false;
			var ljje=0;
			$("#mzhye").html(zhye);
			var jeMsg=$("#jeMsg>span").html();
			
			jeMsg=parseFloat(numformat($.trim(jeMsg,2)));
			if (jeMsg<=0) {
				b=true;
			}
			var ifUseCredit=$("#ifUseCredit").val();
			////////////////////
			$.cookie("Kar_Driver",$.trim(Kar_Driver.val()));
			$.cookie("Kar_paizhao",$.trim(Kar_paizhao.val()));
			$.cookie("transport_AgentClerk_Reciever",$.trim(transport_AgentClerk_Reciever.val()));
			$.cookie("Kar_Driver_Msg_Mobile",$.trim(Kar_Driver_Msg_Mobile.val()));
			$.cookie("FHDZ",$.trim(FHDZ.val()));
			/////////////////
//			2015-10-24版结算方式
			//1.账户余额为负数时不带结算方式相关
			var ddje=jeMsg;
			function jiesyckinit(){
				ddje=ddzje;
				jiesList="";
				jiesListYCK="";
			}
			if (zhye<=0) {//账户总余额小于等于0或者订单总金额大于账户余额
				//不带结算方式里面的金额
				jiesyckinit();
				ljje=(zhye*-1)+ddzje;
			}
			if (ddzje>zhye) {
//				ddje=jeMsg;
				jiesyckinit();
			}
			var yckshi=$("tbody:eq(1)").find(".checkedbox");
			if (yckshi&&jeMsg>0) {//使用预存款并且支付余额大于0
				jiesyckinit();
			}
//			$("#mzje").html(jeMsg);
			$("#mzje").html(ddje);
			/////////////////////////
			if (b) {
				pop_up_box.postWait();
				$.post("orderPayment.do",{
					"orderlist":orderlist,
//					"jiesList":jiesList,
					"jiesListYCK":jiesListYCK,
					"transport_AgentClerk_Reciever":transport_AgentClerk_Reciever.val(),
					"Kar_Driver":Kar_Driver.val(),
					"Kar_Driver_Msg_Mobile":Kar_Driver_Msg_Mobile.val(),
					"Kar_paizhao":Kar_paizhao.val(),
					"FHDZ":FHDZ.val()
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.success){
						pop_up_box.showMsg("提交成功",function(){
							removeOrder();
							window.location.href="order.do";
						});
					}else{
						pop_up_box.showMsg("保存出错,错误:"+data.msg);
					}
				});
			}else{
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd");
				$.cookie("customerName",$.trim($("#customerName").val()));
				$.cookie("date",nowStr);
				$.cookie("ddje",numformat(ddje,2));
				$.cookie("ddzje",numformat(ddzje,2));/////2015-10-24 21:23
				$.cookie("ljqk",numformat(ljje,2));
				$.cookie("orderlist",orderlist);
//				$.cookie("jiesList",jiesList);/////2015-10-24 21:31
				$.cookie("jiesListYCK",jiesListYCK);
					$(".modal,.modal-cover").show();
			}
			return;
		}
	});
});