//工序容器
var processData = null;
//工段
var workingProcedureSectionData = null;

$(function() {
	//初始化
	var processHtml = $("#process");
	var productionProcess = $("#productionProcess");
	
	(function(){
		pop_up_box.loadWait();
		$.get("../pm/getWorkingProcedureSection.do", {
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			workingProcedureSectionData = data;
		});
	})();
	
	//增加显示工序dom
	function addProcess(data) {
		productionProcess.html("");
		if (data && data.length > 0) {
			$.each(data,function(i, n) {
				var prop =processHtml.clone();
				productionProcess.append(prop);
				prop.find("#No_serial").html("序号："+n.No_serial);
				prop.find("#working_procedure_section_name").html(n.working_procedure_section);
				prop.find("#work_name").html(n.work_name);
				prop.find("#upMove").attr("onclick","upMove("+n.No_serial+")");
				prop.find("#downMove").attr("onclick","downMove("+n.No_serial+")");
				prop.find("#editProcess").attr("onclick","editProcess("+n.No_serial+")");
				prop.find("#deleteProcess").attr("onclick","deleteProcess("+n.No_serial+")");
			});
		}
	}
	
	//查找
	$("#find").click(function() {
		$("input[name='No_serial']").val("");
		$("input[name='work_name']").val("");
		$("#working_procedure_section").val("");
		$("#modal").hide();
		
		pop_up_box.loadWait();
		$.get("../pm/getProductionProcessInfo.do", {
			"work_type" : $.trim($("#work_type").val()),
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			addProcess(data);
			processData = data;
		});
	});	
	
	//打开模态框
	$("#addProcess").click(function(){
		pop_up_box.loadWait();
		$.get("../pm/getMaxNoSerial.do", {
			"work_type" : $.trim($("#work_type").val()),
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			$("input[name='No_serial']").val(data+1);
			$("input[name='work_name']").val("");
			$("input[name='No_serial']").attr("disabled",true);
			$("#working_procedure_section").attr("disabled",false);
			openModal();
		});
	});
	
	//关闭模态框
	$("#closeDiv,.close").click(function(){
		$("#modal").hide();
	});
	
	//新增工序
	$("#saveProcess").click(function(){
		var No_serial = $.trim($("input[name='No_serial']").val());
		var work_name = $.trim($("input[name='work_name']").val());
		var working_procedure_section = $.trim($("#working_procedure_section").val());
		if(No_serial && work_name && working_procedure_section){
			pop_up_box.loadWait();
			$.get("../pm/addProductionProcessInfo.do", {
				"No_serial" : No_serial,
				"work_name" : work_name,
				"working_procedure_section" : working_procedure_section,
				"work_type" : $.trim($("#work_type").val()),
				"ver" : Math.random()
			},function(data) {
				pop_up_box.loadWaitClose();
				if(data.success){
					$("#modal").hide();
					pop_up_box.showMsg("保存成功!",function(){$("#find").click();});
				}else{
					pop_up_box.showMsg("保存失败!");
				}
			});
		}else{
			pop_up_box.showMsg("请填将工序信息填写完整!");
		}
	});
	
	//工序类型改变时重新查找
	$("#work_type").change(function(){
		$("#find").click();
	});
	
	//查找执行
	$("#find").click();
});

//打开模态框
var openModal = function(){
	$("#working_procedure_section").html("");
	$("#working_procedure_section").html("<option value=''></option>");
	for(p in workingProcedureSectionData){
		$("#working_procedure_section").append("<option value="+workingProcedureSectionData[p]+">"+workingProcedureSectionData[p]+"</option>");
	}
	$("#modal").show();
};

//上移工序
var upMove = function(n){
	//找到最小的工序号
	var min = null;
	for(p in processData){
		if(!min){
			min = processData[p].No_serial;
		}else{
			min = processData[p].No_serial < min ? processData[p].No_serial : min;
		}
	}
	if(min == n){
		pop_up_box.showMsg("已经是第一个了!");
		return;
	}
	
	//找到当前工序的位置
	var index = null;
	for(var i=0;i<processData.length;i++){
		if(n==processData[i].No_serial){
			index = i;
		}
	}
	
	//交换工序位置
	pop_up_box.loadWait();
	$.get("../pm/moveProductionProcessInfo.do", {
		"work_type" : $.trim($("#work_type").val()),
		"No_serial_1" : processData[index].No_serial,
		"work_name_1" : processData[index].work_name,
		"working_procedure_section_1" : processData[index].working_procedure_section,
		"No_serial_2" : processData[index-1].No_serial,
		"work_name_2" : processData[index-1].work_name,
		"working_procedure_section_2" : processData[index-1].working_procedure_section,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
			pop_up_box.showMsg("上移成功!",function(){$("#find").click();});
		}else{
			pop_up_box.showMsg("上移失败!");
		}
	});
}

//下移工序
var downMove = function(n){
	//找到最小的工序号
	var max = null;
	for(p in processData){
		if(!max){
			max = processData[p].No_serial;
		}else{
			max = processData[p].No_serial > max ? processData[p].No_serial : max;
		}
	}
	if(max == n){
		pop_up_box.showMsg("已经是最后一个了!");
		return;
	}
	
	//找到当前工序的位置
	var index = null;
	for(var i=0;i<processData.length;i++){
		if(n==processData[i].No_serial){
			index = i;
		}
	}
	
	//交换工序位置
	pop_up_box.loadWait();
	$.get("../pm/moveProductionProcessInfo.do", {
		"work_type" : $.trim($("#work_type").val()),
		"No_serial_1" : processData[index].No_serial,
		"work_name_1" : processData[index].work_name,
		"working_procedure_section_1" : processData[index].working_procedure_section,
		"No_serial_2" : processData[index+1].No_serial,
		"work_name_2" : processData[index+1].work_name,
		"working_procedure_section_2" : processData[index+1].working_procedure_section,
		"working_procedure_section" : $.trim($("#working_procedure_section").val()),
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
			pop_up_box.showMsg("下移成功!",function(){$("#find").click();});
		}else{
			pop_up_box.showMsg("下移失败!");
		}
	});
}

//编辑工序
var editProcess = function(n){
	$("input[name='No_serial']").val(n);
	$("input[name='No_serial']").attr("disabled",true);
	$("#working_procedure_section").attr("disabled",true);
	openModal();
	for(p in processData){
		if(n == processData[p].No_serial){
			$("input[name='work_name']").val(processData[p].work_name);
			$("#working_procedure_section").val(processData[p].working_procedure_section);
		}
	}
}

//删除工序
var deleteProcess = function(n){
	var No_serial = n;
	var work_id = "";
	
	//找到当前工序的位置
	var index = null;
	for(var i=0;i<processData.length;i++){
		if(n==processData[i].No_serial){
			work_id = processData[i].work_id;
		}
	}
	
	if(No_serial && work_id){
		pop_up_box.loadWait();
		$.get("../pm/delProductionProcessInfo.do", {
			"work_type" : $.trim($("#work_type").val()),
			"No_serial" : No_serial,
			"work_id" : work_id,
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			if(data.success){
				pop_up_box.showMsg("删除成功!",function(){$("#find").click();});
			}else{
				pop_up_box.showMsg("删除失败!");
			}
		});
	}else{
		pop_up_box.showMsg("获取工序信息失败!");
	}
}