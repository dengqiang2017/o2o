var headshiphtml;
var headshiptype=0;
$(function(){
	var dayN1_SdOutStore_Of_SdPlan=$("#dayN1_SdOutStore_Of_SdPlan");
	var dayN2_SdOutStore_Of_SdPlan=$("#dayN2_SdOutStore_Of_SdPlan");
	var dayM1_SdOutStore_Of_SdPlan=$("#dayM1_SdOutStore_Of_SdPlan");
	var dayM2_SdOutStore_Of_SdPlan=$("#dayM2_SdOutStore_Of_SdPlan");
	var dayTime_Of_SdPlan=$("#dayTime_Of_SdPlan");
	var planEndTime=$("#planEndTime");
	////////////////////////
	var sendMsgBegin=$("input[name='sendMsgBegin']");
	var sendMsgEnd=$("input[name='sendMsgEnd']");
	var sendSmsEnd=$("input[name='sendSmsEnd']");
	var SmsUsername=$("input[name='SmsUsername']");
	var SmsPassword=$("input[name='SmsPassword']");
	var debug=$("#debug");
	var order_sms_debug=$("#order_sms_debug");
	var isShowAllProduct=$("#isShowAllProduct");
	var order_sms_no=$("input[name='order_sms_no']");
	var sms_format1=$("input[name='sms_format1']");
	var sms_format2=$("input[name='sms_format2']");
	var sms_format3=$("input[name='sms_format3']");
	var corpid=$("input[name='corpid']");//微信相关
	var corpsecret=$("input[name='corpsecret']");
	var corpsecret_chat=$("input[name='corpsecret_chat']");
	var mch_id=$("input[name='mch_id']");
	var agentid=$("input[name='agentid']");
	var agentDeptId=$("input[name='agentDeptId']");
	var sEncodingAESKeyA=$("input[name='sEncodingAESKeyA']");
	var smsid=$("input[name='smsid']");
	var systemWeixin=$("input[name='systemWeixin']");
	var tomail=$("input[name='tomail']");
	//////////////////////////
	var alipay_partner=$("#alipay_partner");
	var alipay_seller_email=$("#alipay_seller_email");
	var alipay_key=$("#alipay_key");
	////////////////////
	var urlPrefix=$("input[name='urlPrefix']");
	var emplName=$("input[name='emplName']");
	var Eheadshiped=$("input[name='Eheadshiped']");
	var o2o=$("#o2o");
	var orderplan=$("#orderplan");
	var accnIvt=$("#accnIvt");
	var moreMemo=$("#moreMemo");
	var safe=$("#safe");
	var clientElecHeadship=$("#clientElecHeadship");
	var employeeElecHeadship=$("#employeeElecHeadship"); 
	var elecEmployeeHeadship=$("#elecEmployeeHeadship"); 
	var elecClientHeadship=$("#elecClientHeadship"); 
	
	var payNoticeClientHeadship=$("#payNoticeClientHeadship"); 
	var payNoticeElpoyeeHeadship=$("#payNoticeElpoyeeHeadship"); 
	var acceptanceNoticeClientHeadship=$("#acceptanceNoticeClientHeadship"); 
	var acceptanceNoticeElpoyeeHeadship=$("#acceptanceNoticeElpoyeeHeadship"); 
	var loginNoticeHeadship=$("#loginNoticeHeadship"); 
	var paymentConfirmationHeadship=$("#paymentConfirmationHeadship"); 
	var isAutoFind=$("#isAutoFind"); 
	var isGenerateSunday=$("#isGenerateSunday"); 
	var isGenerateSaturday=$("#isGenerateSaturday"); 
	var weixinMoreDept=$("#weixinMoreDept"); 
	
	if(window.location.href.indexOf("cdsydq")>0){
		$("#saiyuElecSet").show();
	}
	
	$(".ctn").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
		}
	});
	function orderProcess(name){
		var div=$($("#salesOrder_ProcessItem").html());
		return $(div);
	}
	var roleitem=$("#agentJsons").html();//模板
	$.get("getSystemParams.do",function(data){
		if (data.dayN1_SdOutStore_Of_SdPlan&&data.dayN1_SdOutStore_Of_SdPlan!="") {
			dayN1_SdOutStore_Of_SdPlan.val(data.dayN1_SdOutStore_Of_SdPlan);
		}
		if (data.dayN2_SdOutStore_Of_SdPlan&&data.dayN2_SdOutStore_Of_SdPlan!="") {
			dayN2_SdOutStore_Of_SdPlan.val(data.dayN2_SdOutStore_Of_SdPlan);
		}
		if (data.dayM1_SdOutStore_Of_SdPlan&&data.dayM1_SdOutStore_Of_SdPlan!="") {
			dayM1_SdOutStore_Of_SdPlan.val(data.dayM1_SdOutStore_Of_SdPlan);
		}
		if (data.dayM2_SdOutStore_Of_SdPlan&&data.dayM2_SdOutStore_Of_SdPlan!="") {
			dayM2_SdOutStore_Of_SdPlan.val(data.dayM2_SdOutStore_Of_SdPlan);
		}
		if (data.dayTime_Of_SdPlan&&data.dayTime_Of_SdPlan!="") {
			dayTime_Of_SdPlan.val(data.dayTime_Of_SdPlan);
		}
		if (data.planEndTime&&data.planEndTime!="") {
			planEndTime.val(data.planEndTime);
		}
		if (data.debug&&data.debug=="true") {
			debug.addClass("pro-checked")
		}
		if (data.isAutoFind&&data.isAutoFind=="true") {
			isAutoFind.addClass("pro-checked")
		}
		if (data.isGenerateSaturday&&data.isGenerateSaturday=="true") {
			isGenerateSaturday.addClass("pro-checked")
		}
		if (data.isGenerateSunday&&data.isGenerateSunday=="true") {
			isGenerateSunday.addClass("pro-checked")
		}
		if (data.weixinMoreDept&&data.weixinMoreDept=="true") {
			weixinMoreDept.addClass("pro-checked")
		}
		if (data.accnIvt==undefined) {
			orderplan.addClass("pro-checked");
		}else if (data.orderplan&&data.orderplan=="true") {
			orderplan.addClass("pro-checked")
		}
		if (data.accnIvt==undefined) {
			accnIvt.addClass("pro-checked");
		}else if (data.accnIvt&&data.accnIvt=="true") {
			accnIvt.addClass("pro-checked");
		}
		if (data.order_sms_debug&&data.order_sms_debug=="true") {
			order_sms_debug.addClass("pro-checked");
		}
		if (data.moreMemo&&data.moreMemo=="true") {
			moreMemo.addClass("pro-checked");
		}
		if (data.isShowAllProduct&&data.isShowAllProduct=="true") {
			isShowAllProduct.addClass("pro-checked");
		}
		if (data.safe&&data.safe=="1") {
			safe.addClass("pro-checked");
		}
		tomail.val(data.tomail);
		sendMsgBegin.val(data.sendMsgBegin);
		sendMsgEnd.val(data.sendMsgEnd);
		sendSmsEnd.val(data.sendSmsEnd);
		SmsUsername.val(data.SmsUsername);
		SmsPassword.val(data.SmsPassword);
		order_sms_no.val(data.order_sms_no);
		sms_format1.val(data.sms_format1);
		sms_format2.val(data.sms_format2);
		sms_format3.val(data.sms_format3);
		Eheadshiped.val(data.Eheadshiped);
		emplName.val(data.emplName);
		corpid.val(data.corpid);
		corpsecret.val(data.corpsecret);
		corpsecret_chat.val(data.corpsecret_chat);
		mch_id.val(data.mch_id);
		sEncodingAESKeyA.val(data.sEncodingAESKeyA);
		agentid.val(data.agentid);
		agentDeptId.val(data.agentDeptId);
		smsid.val(data.smsid);
		systemWeixin.val(data.systemWeixin);
		///////////////////
		alipay_partner.val(data.alipay_partner);
		alipay_seller_email.val(data.alipay_seller_email);
		alipay_key.val(data.alipay_key);
		///////////////
		urlPrefix.val(data.urlPrefix);
		urlPrefix.val(data.urlPrefix);
		employeeElecHeadship.val(data.employeeElecHeadship);
		clientElecHeadship.val(data.clientElecHeadship);
		elecEmployeeHeadship.val(data.elecEmployeeHeadship);
		elecClientHeadship.val(data.elecClientHeadship);
		loginNoticeHeadship.val(data.loginNoticeHeadship);
		paymentConfirmationHeadship.val(data.paymentConfirmationHeadship);
		
		payNoticeClientHeadship.val(data.payNoticeClientHeadship);
		payNoticeElpoyeeHeadship.val(data.payNoticeElpoyeeHeadship);
		acceptanceNoticeClientHeadship.val(data.acceptanceNoticeClientHeadship);
		acceptanceNoticeElpoyeeHeadship.val(data.acceptanceNoticeElpoyeeHeadship);
		$("input[name='NoticeStyle'][value="+data.NoticeStyle+"]").prop("checked",true);
		$("input[name='ordersMessageReceivedType'][value="+data.ordersMessageReceivedType+"]").prop("checked",true);
		$("input[name='PlanPush'][value="+data.PlanPush+"]").prop("checked",true);
		$("input[name='PlanSource'][value="+data.PlanSource+"]").prop("checked",true);
		$("input[name='QCWay'][value="+data.QCWay+"]").prop("checked",true);
		
		var industry=o2o.find("input[value='"+data.o2o+"']");
		if (industry.length<=0) {
			industry=o2o.find("input[value='jiaju']");
		}
		industry.parent().addClass("active");
		if (data.processNameList&&data.processNameList.length>0) {
			$("#salesOrder_Process").html("");
			for (var i = 0; i < data.processNameList.length; i++) {
				var processhtml=$($("#salesOrder_ProcessItem").html());
				$("#salesOrder_Process").append(processhtml);
				var sopn=data.processNameList[i];
				if(sopn.processName){
					processhtml.find("input[name='processName']").val(sopn.processName);
				}
				if(sopn.headship){
					processhtml.find("input[name='headship']").val(sopn.headship);
				}
				if(sopn.Eheadship){
					processhtml.find("input[name='Eheadship']").val(sopn.Eheadship);
				}
				if(sopn.imgName){
					processhtml.find("img").attr("src","../weixinimg/"+sopn.imgName);
				}
			}
		}
		if (data.ProductionSection&&data.ProductionSection.length>0) {
//			$("#ProductionSection").html("");
			for (var i = 0; i < data.ProductionSection.length; i++) {
				var process=$($("#psitem").html());
				$("#ProductionSection").append(process);
				process.find("input").val(data.ProductionSection[i]);
			}
		}else{
			$("#ProductionSection").html($("#psitem").html());
		}
		
		function processadd(t){
			var process=$($("#psitem").html());
			if($.trim($(".active>a").html())=="流程控制与信息控制"){
				process=orderProcess("");
			}
			$(t).parent().after(process);
			process.find(".add").click(function(){
				processadd(this);
			});
			subclick();
		}
		subclick();
		function subclick(){
			$(".sub").click(function(){
				$(this).parent().remove();
			});
			$(".up").click(function(){
				var divtop=$(this).parent().parent();
				var index=divtop.find(".up").index(this);
				if (index>0) {
					 $(this).parent().insertBefore(divtop.find(".up:eq("+(index-1)+")").parent());
				}
			});
			$(".down").click(function(){
				var divtop=$(this).parent().parent();
				var index=divtop.find(".down").index(this);
				var len=divtop.find(".down").length-1;
				if (len>index) {
					$(this).parent().insertAfter(divtop.find(".down:eq("+(index+1)+")").parent());
				}
			});
		}
		$(".add").click(function(){
			processadd(this);
		});
		if(data.agentList){
			var agentList=$.parseJSON(data.agentList);
			if(agentList&&agentList.length>0){
				$("#agentJsons").html("");
				$.each(agentList,function(i,n){
					var item=$(roleitem);
					$("#agentJsons").append(item);
					item.find("input[name='role']").val(n.name);
					item.find("input[name='roleAgentId']").val(n.agentid);
				});
			}
		}
	});
	$("#agentJsons .roleAdd").click(function(){
		var item=$(roleitem);
		$("#agentJsons").append(item);
		$("#agentJsons .roleAdd").click(function(){
			var item=$(roleitem);
			$("#agentJsons").append(item);
		});
	});
/////////////////////
	$("#zhiwuSelect").click(function(){
		var zhiwus=$("#modal_smsSelect").find("ul").find(".pro-checked");
		if(zhiwus&&zhiwus.length>0){
			var zhiwu="";
			for (var i = 0; i < zhiwus.length; i++) {
				var item=$(zhiwus[i]).parent();
				if(zhiwu!=""){
					zhiwu=zhiwu+","+$.trim(item.find("span").text());
				}else{
					zhiwu=zhiwu+$.trim(item.find("span").text());
				}
			}
			if(headshiptype==0){
				$(headshiphtml).parents(".input-group").find("input[name='headship']").val(zhiwu);
			}else if(headshiptype==1){
				$(headshiphtml).parents(".input-group").find("input[name='Eheadship']").val(zhiwu);
			}else{//收货
				$(headshiphtml).parents(".input-group").find("#acceptanceNoticeElpoyeeHeadship").val(zhiwu);
			}
			$("#modal_smsSelect").hide();
		}else {
			pop_up_box.showMsg("请至少选择一个职务!");
		}
	});
	$("#imgSelect").click(function(){
		var zhiwus=$("#modal_imgSelect").find("ul").find(".pro-checked");
		if(zhiwus&&zhiwus.length>0){
			var zhiwu="";
			for (var i = 0; i < zhiwus.length; i++) {
				var item=$(zhiwus[i]).parent();
				$(headshiphtml).parents(".input-group").find("img").attr("src",item.find("img").attr("src"));
			}
			$("#modal_imgSelect").hide();
		}else {
			pop_up_box.showMsg("请至少选择一个职务!");
		}
	});
	$("#modal_smsSelect").find(".pro-check").unbind("click");
	$("#modal_smsSelect").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
		}
	});
	$("#modal_imgSelect").find(".pro-check").unbind("click");
	$("#modal_imgSelect").find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
		}
	});
	$("#modal_smsSelect").find("#allchecked").unbind("click");
	$("#modal_smsSelect").find("#allchecked").click(function(){//注册图片选择框 选择或者取消功能
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$("#modal_smsSelect").find(".pro-check").removeClass("pro-checked");
		}else{
			$("#modal_smsSelect").find(".pro-check").addClass("pro-checked");
		}
	});
	$("#zhiwuClose,.close").click(function(){
		$("#modal_smsSelect").hide();
	});
	$("#imgClose,.close").click(function(){
		$("#modal_imgSelect").hide();
	});
	//////////////////////////
	$(".btn-info").click(function(){
		pop_up_box.postWait();
		var debug_b=false;
		if (debug.hasClass("pro-checked")) {
			debug_b=true;
		}
		var orderplan_b=false;
		if (orderplan.hasClass("pro-checked")) {
			orderplan_b=true;
		}
		var accnIvt_b=false;
		if (accnIvt.hasClass("pro-checked")) {
			accnIvt_b=true;
		}
		var order_sms_debug_b=false;
		if (order_sms_debug.hasClass("pro-checked")) {
			order_sms_debug_b=true;
		}
		var moreMemo_b=false;
		if (moreMemo.hasClass("pro-checked")) {
			moreMemo_b=true;
		}
		var isAutoFind_b=false;
		if (isAutoFind.hasClass("pro-checked")) {
			isAutoFind_b=true;
		}
		var isShowAllProduct_b=false;
		if (isShowAllProduct.hasClass("pro-checked")) {
			isShowAllProduct_b=true;
		}
		var isGenerateSaturday_b=false;
		if (isGenerateSaturday.hasClass("pro-checked")) {
			isGenerateSaturday_b=true;
		}
		var isGenerateSunday_b=false;
		if (isGenerateSunday.hasClass("pro-checked")) {
			isGenerateSunday_b=true;
		}
		var weixinMoreDept_b=false;
		if (weixinMoreDept.hasClass("pro-checked")) {
			weixinMoreDept_b=true;
		}
		var safe_b=0;
		if (safe.hasClass("pro-checked")) {
			safe_b=1;
		}
//		////////////////////////////////
		function getVal(val){
			if(val){
				return val;
			}else{
				return "";
			}
		}
		//{"订单流程名称":"订单流程名称","员工对应职务":员工职务,"客户对应职务","消息对应logo图片":logo图片名称,"发送消息格式":消息格式}
		//{"processName":"","Eheadship":"","headship":"","imgName":"","msgFormat":""}
		var  items=$("#salesOrder_Process").find(".item");
		var processNameList=[];
		for (var i = 0; i < items.length; i++) {
			var item=$(items[i]);
			var json={};
			var processName=getVal($.trim(item.find("input[name='processName']").val()));
			var headship=getVal($.trim(item.find("input[name='headship']").val()));
			var Eheadship=getVal($.trim(item.find("input[name='Eheadship']").val()));
			var imgName=$.trim(item.find("img").attr("src"));
			if(imgName){
				var names=imgName.split("/");
				imgName=names[names.length-1];
			}else{
				imgName="";
			}
			json.processName=processName;
			json.headship=headship;
			json.Eheadship=Eheadship;
			json.imgName=imgName;
			processNameList.push(JSON.stringify(json));
		}
		//////////////////////////////
		var sectionNames=$("#ProductionSection").find("input");
		var ProductionSection="";
		for (var i = 0; i < sectionNames.length; i++) {
			var name=$.trim($(sectionNames[i]).val());
			if (i==0) {
				ProductionSection=name;
			}else{
				ProductionSection=ProductionSection+","+name;
			}
		}
		//////////
		var agentJsons=$("#agentJsons .roleitem");
		var agentList=[];
		if(agentJsons.length>0){
			for (var i = 0; i < agentJsons.length; i++) {
				var roleitem=$(agentJsons[i]);
				var role=roleitem.find("input[name='role']").val();
				var roleAgentId=roleitem.find("input[name='roleAgentId']").val();
				agentList.push(JSON.stringify({"name":role,"agentid":roleAgentId}));
			}
		}
		$.post("saveSystemParams.do",{
			"dayN1_SdOutStore_Of_SdPlan":dayN1_SdOutStore_Of_SdPlan.val(),
			"dayN2_SdOutStore_Of_SdPlan":dayN2_SdOutStore_Of_SdPlan.val(),
			"dayM1_SdOutStore_Of_SdPlan":dayM1_SdOutStore_Of_SdPlan.val(),
			"dayM2_SdOutStore_Of_SdPlan":dayM2_SdOutStore_Of_SdPlan.val(),
			"smsid":smsid.val(),
			"tomail":tomail.val(),
			"agentList":"["+agentList.join(",")+"]",
			"employeeElecHeadship":employeeElecHeadship.val(),
			"clientElecHeadship":clientElecHeadship.val(),
			"elecEmployeeHeadship":elecEmployeeHeadship.val(),
			"elecClientHeadship":elecClientHeadship.val(),
			"payNoticeClientHeadship":payNoticeClientHeadship.val(),
			"payNoticeElpoyeeHeadship":payNoticeElpoyeeHeadship.val(),
			"acceptanceNoticeClientHeadship":acceptanceNoticeClientHeadship.val(),
			"acceptanceNoticeElpoyeeHeadship":acceptanceNoticeElpoyeeHeadship.val(),
			"loginNoticeHeadship":loginNoticeHeadship.val(),
			"paymentConfirmationHeadship":paymentConfirmationHeadship.val(),
			"processNameList":"["+processNameList+"]",
			"systemWeixin":systemWeixin.val(),
			"alipay_partner":alipay_partner.val(),
			"alipay_seller_email":alipay_seller_email.val(),
			"alipay_key":alipay_key.val(),
			"sendMsgBegin":sendMsgBegin.val(),
			"emplName":emplName.val(),
			"urlPrefix":urlPrefix.val(),
			"sendMsgEnd":sendMsgEnd.val(),
			"dayTime_Of_SdPlan":dayTime_Of_SdPlan.val(),
			"planEndTime":planEndTime.val(),
			"sendSmsEnd":sendSmsEnd.val(),
			"SmsUsername":SmsUsername.val(),
			"SmsPassword":SmsPassword.val(),
			"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
			"ordersMessageReceivedType":$("input[name='ordersMessageReceivedType']:checked").val(),
			"PlanPush":$("input[name='PlanPush']:checked").val(),
			"PlanSource":$("input[name='PlanSource']:checked").val(),
			"QCWay":$("input[name='QCWay']:checked").val(),
			"debug":debug_b,
			"orderplan":orderplan_b,
			"accnIvt":accnIvt_b,
			"moreMemo":moreMemo_b,
			"isAutoFind":isAutoFind_b,
			"isGenerateSaturday":isGenerateSaturday_b,
			"isGenerateSunday":isGenerateSunday_b,
			"weixinMoreDept":weixinMoreDept_b,
			"safe":safe_b,
			"isShowAllProduct":isShowAllProduct_b,
			"ProductionSection":ProductionSection,
			"order_sms_debug":order_sms_debug_b,
			"order_sms_no":order_sms_no.val(),
			"sms_format1":sms_format1.val(),
			"sms_format2":sms_format2.val(),
			"corpid":corpid.val(),
			"corpsecret":corpsecret.val(),
			"corpsecret_chat":corpsecret_chat.val(),
			"agentid":agentid.val(),
			"agentDeptId":agentDeptId.val(),
			"mch_id":mch_id.val(),
			"sEncodingAESKeyA":sEncodingAESKeyA.val(),
			"sms_format3":sms_format3.val(),
			"o2o":o2o.find(".active").find("input").val()
		},function(data){
			pop_up_box.loadWaitClose();
			   if (data.success) {
				   pop_up_box.showMsg("保存成功!",function(data){
					   window.location.href="../manager.do";
				   });
			}else{
				pop_up_box.showMsg("保存失败,错误:"+data.msg);
			}
		});
	});
});