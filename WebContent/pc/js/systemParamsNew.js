var headshiphtml;
var headshiptype=0;
$(function(){
	var o2o=$("#o2o");
	if(window.location.href.indexOf("cdsydq")>0){
		$("#saiyuElecSet").show();
	}
	function orderProcess(name){
		var div=$($("#salesOrder_ProcessItem").html());
		return $(div);
	}
	var roleitem=$("#agentJsons").html();//模板
	$.get("getSystemParams.do",function(data){
		///////////////////
		var inps=$("input[type='text'],input[type='tel'],input[type='email']");
		for (var i = 0; i < inps.length; i++) {
			var inp=$(inps[i]);
			var name=inp.attr("name");
			if(name&&name!=""){
				inp.val(data[name]);
			}
		}
		var inps=$("input[type='checkbox']");
		for (var i = 0; i < inps.length; i++) {
			var inp=$(inps[i]);
			var name=inp.attr("name");
			if (data[name]=="true") {
				inp.prop("checked",true);
			}
		}
		var inps=$("select");
		for (var i = 0; i < inps.length; i++) {
			var inp=$(inps[i]);
			var name=inp.attr("name");
			inp.val(data[name]);
		}
		$("input[name='NoticeStyle'][value="+data.NoticeStyle+"]").prop("checked",true);
		$("input[name='smsType'][value="+data.smsType+"]").prop("checked",true);
		$("input[name='ordersMessageReceivedType'][value="+data.ordersMessageReceivedType+"]").prop("checked",true);
		$("input[name='PlanPush'][value="+data.PlanPush+"]").prop("checked",true);
		$("input[name='PlanSource'][value="+data.PlanSource+"]").prop("checked",true);
		$("input[name='QCWay'][value="+data.QCWay+"]").prop("checked",true);
		$("input[name='kuanOrHuo'][value="+data.kuanOrHuo+"]").prop("checked",true);
		$("input[name='weixinType'][value="+data.weixinType+"]").prop("checked",true);
		var inps=$(".Wdate");
		for (var i = 0; i < inps.length; i++) {
			var inp=$(inps[i]);
			var name=inp.attr("name");
			inp.val(data[name]);
		}
		var industry=o2o.find("input[value='"+data.o2o+"']");
		if (industry.length<=0) {
			industry=o2o.find("input[value='jiaju']");
		}
		industry.parent().addClass("active");
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
					item.find("#role").val(n.name);
					item.find("#roleAgentId").val(n.agentid);
					item.find(".roleAdd").click(function(){
						var item=$(roleitem);
						$("#agentJsons").append(item);
						$("#agentJsons .roleAdd").click(function(){
							var item=$(roleitem);
							$("#agentJsons").append(item);
							item.find("#role").val("");
						});
					});
				});
			}
		}
		$("#agentJsons .roleAdd").click(function(){
			var item=$(roleitem);
			$("#agentJsons").append(item);
			$("#agentJsons .roleAdd").click(function(){
				var item=$(roleitem);
				$("#agentJsons").append(item);
				item.find("#role").val("");
			});
		});
		////////////////////
		$("#salesOrder_Process").sortable();
		$("#ProductionSection").sortable();
		$(".up,.down").hide();
	});
/////////////////////
	$(".btn-info").click(function(){
		function getVal(val){
			if(val){
				return val;
			}else{
				return "";
			}
		}
		var YxSmsUsername=$.trim($("input[name='YxSmsUsername']").val());
		var SmsUsername=$.trim($("input[name='SmsUsername']").val());
		if(YxSmsUsername==SmsUsername){
			pop_up_box.showMsg("通知类短信用户名和营销类不能是同一个账号!");
			$("input[name='YxSmsUsername']").focus();
			return;
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
				var role=roleitem.find("#role").val();
				var roleAgentId=roleitem.find("#roleAgentId").val();
				agentList.push(JSON.stringify({"name":role,"agentid":roleAgentId}));
			}
		}
		var params=$("form").serializeJSON();
		params.ProductionSection=ProductionSection;
		params.agentList="["+agentList.join(",")+"]";
		params.o2o=o2o.find(".active").find("input").val();
		var chs=$("input[type='checkbox']");
		for (var i = 0; i < chs.length; i++) {
			var ch=$(chs[i]);
			var name=ch.attr("name");
			var b=ch.prop("checked");
			params[name]=b;
		}
		var chs=$("select");
		for (var i = 0; i < chs.length; i++) {
			var ch=$(chs[i]);
			var name=ch.attr("name");
			params[name]=ch.val();
		}
		params.NoticeStyle=$("input[name='NoticeStyle']:checked").val();
		params.smsType=$("input[name='smsType']:checked").val();
		params.ordersMessageReceivedType=$("input[name='ordersMessageReceivedType']:checked").val();
		params.PlanPush=$("input[name='PlanPush']:checked").val();
		params.PlanSource=$("input[name='PlanSource']:checked").val();
		params.QCWay=$("input[name='QCWay']:checked").val();
		params.kuanOrHuo=$("input[name='kuanOrHuo']:checked").val();
		params.weixinType=$("input[name='weixinType']:checked").val();
		pop_up_box.postWait();
		$.post("saveSystemParams.do",params,function(data){
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