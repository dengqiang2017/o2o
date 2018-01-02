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
		$("#ysk").html(numformat(acct_recieve_sum,2));//应收款
		var zhye=numformat(parseFloat(acct_recieve_sum)*-1,2);//账户余额
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
		$.each(data.jsfslsit,function(i,n){
			var tr=$(jsfslsitTr());
			$("tbody:eq(1)").append(tr);
			tr.find("td:eq(0)").find("input[type='hidden']").val(n.sort_id);
			tr.find("td:eq(1)").html(n.cheque_flag);
			tr.find("td:eq(2)").html(n.settlement_sim_name);
			tr.find("td:eq(3)").html(n.acct_recieve_sum);
			var acct_recieve_sum=parseFloat(n.acct_recieve_sum);
			if ("账上款"==n.cheque_flag) {
				zsk_yue+=acct_recieve_sum;
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
				yck_yue+=acct_recieve_sum;
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
		
//		if (ddzje>zhye) {
		if (yue>0) {
			$("#jeMsg>span").html(yue);
			$("#jeMsg").show();
		}else{
			$("#jeMsg").hide();
		}
		
		$("tbody:eq(2)").html("");
		var ztr=$("<tr><td></td><td></td></tr>");
		$("tbody:eq(2)").append(ztr);
		ztr.find("td:eq(0)").html("账上款");
		ztr.find("td:eq(1)").html(numformat(zsk_yue,2));
		if (yck_yue>0) {
			ztr=$("<tr><td></td><td></td></tr>");
			$("tbody:eq(2)").append(ztr);
			ztr.find("td:eq(0)").html("<div class='checkbox'></div>预存款");
			ztr.find("td:eq(1)").html(numformat(yck_yue,2));
			//预存款选择事件
		}
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
		ztr.find(".checkbox").click(function(){
			//订单总金额
			var ddzje=parseFloat($(".order-msg li:eq(4)>span").html());
//			var zfje_ins=$("tbody:eq(1)").find("td:eq(4)>input");
			var zfje_ins=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('账上款')");
			var yck_ins=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('预存款')");
			if ($(this).hasClass("checkedbox")) {
				var zf_val=0;
//				for (var i = 0; i < zfje_ins.length; i++) {
//					zf_val+=parseFloat($(zfje_ins[i]).parents("tr").find("td:eq(4)>input").val());
//				}
				if (ddzje>account_zf_je) {
					var yck_zfje=ddzje-account_zf_je;//预存款需要支付金额
					if (yck_zfje>0) {
						var yck_zfje_yue=0;
						var yck_zfje_h4=0;
						for (var i = 0; i < yck_ins.length; i++) {
							var yck_tr=$(yck_ins[i]).parents("tr");
							var yck_je=parseFloat(yck_tr.find("td:eq(3)").html());
							if (yck_je>0) {
								yck_zfje= yck_zfje-yck_je;
								if (yck_zfje>0) {
									yck_tr.find("td:eq(4)>input").val(yck_je);
								}else{
									yck_tr.find("td:eq(4)>input").val((yck_zfje*-1));
								}
								yck_zfje_h4+=parseFloat(yck_tr.find("td:eq(4)>input").val());
							}
						}
						var h5je=parseFloat($("#jeMsg>span").html());
						if (h5je) {
							$("#jeMsg>span").html(yck_zfje_h4+h5je);
						}else{
							$("#jeMsg>span").html(yck_zfje_h4);
						}
						//////////////////
//						account_zf_je
					}
				}
			}else{
				for (var i = 0; i < yck_ins.length; i++) {
					var yck_tr=$(yck_ins[i]).parents("tr");
					yck_tr.find("td:eq(4)>input").val(0);
				}
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
			var jiescheck=$("tbody:eq(1)").find("tr").find("td:eq(1):contains('账上款')");
			var jiesList=[];
			var zsk_zfje=0;//账上款支付金额
			for (var i = 0; i < jiescheck.length; i++) {
				var item=$(jiescheck[i]).parents("tr");
				var jies_no=$.trim(item.find("input").val());
				var jies_je=$.trim(item.find("td:eq(4)>input").val());
				if (jies_je&&jies_je!="0") {
					zsk_zfje+=parseFloat(jies_je);
					var jies_cls=$.trim(item.find("td:eq(1)").html());
					var jies_name=$.trim(item.find("td:eq(2)").html());
					jiesList.push(JSON.stringify({"jies_no":jies_no,"jies_je":jies_je,"jies_name":jies_name,"jies_cls":jies_cls}));
				}
			}
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
			var zzf_je=zsk_zfje+yck_zfje;///账户总支付金额
			////
			var zhye=parseFloat($.trim($("#zhye").html()));
			var ddzje=parseFloat($.trim($(".order-msg li:eq(4)>span").html()));
			var b=false;
			var cha=0;
			if (zzf_je>=ddzje) {//账户总支付金额大于订单总金额为第一种情况
				b=true;
			}else{//账户总支付金额小于订单总金额按第二种方式
				cha=ddzje-zzf_je;
			}
			
			var ljje=0;
			$("#mzhye").html(zhye);
			$("#mzje").html($("#jeMsg>span").html());
			var ifUseCredit=$("#ifUseCredit").val();
			if (zhye>0) {//1.判断账户余额是否大于0
//				if (zhye<ddzje) {//1.2判断账户余额小于订单总金额
//					cha=ddzje-zhye;
//				}else{
//					b=true;
//				}
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
					"jiesList":jiesList,
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
				$.cookie("ddje",$("#jeMsg>span").html());
				$.cookie("ljqk",ljje);
				$.cookie("orderlist",orderlist);
				$.cookie("jiesList",jiesList);
				$.cookie("jiesListYCK",jiesListYCK);
//				if (ifUseCredit=="是") {
					$(".modal,.modal-cover").show();
//				}else{
//					pop_up_box.showMsg("余额不足,请充值后再进行操作!",function(){
//						$("#paymoney").click();
////						window.open("paymoney.do","_blank");
//					});
//				}
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