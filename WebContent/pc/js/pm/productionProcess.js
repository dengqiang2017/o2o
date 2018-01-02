//工序容器
var processData = null;
$(function() {
	//初始化
	var processHtml = $("#process");
	var productionProcess = $("#productionProcess");
	//增加显示工序dom
	function addProcess(data) {
		productionProcess.html("");
		if (data && data.length > 0) {
			$.each(data,function(i, n) {
				var prop =$(processHtml.html());
				productionProcess.append(prop);
				prop.find("#No_serial").html(n.No_serial);
				prop.find("#work_name").html(n.work_name);
				prop.find("#work_type").html(n.work_type);
				prop.find("#work_id").html(n.work_id);
				prop.find("#sort_id").html(n.sort_id);
				prop.find("#easy_id").html(n.easy_id);
				prop.find("#upper_work_id").html(n.upper_work_id);
				prop.find("#work_price").html(n.work_price);
				if(n.work_type==1){
					prop.find("#workname").html("离散型");
				}else{
					prop.find("#workname").html("流程型");
				}
				prop.find("#upMove").attr("onclick","upMove("+n.No_serial+")");
				prop.find("#downMove").attr("onclick","downMove("+n.No_serial+")");
				prop.find("#editProcess").click(function(){
					var panel=$(this).parents(".panel");
					$("input[name='No_serial']").val(panel.find("#No_serial").html());
					$("input[name='work_name']").val(panel.find("#work_name").html());
					$("select[name='work_type']").val(panel.find("#work_type").html());
					$("input[name='work_id']").val(panel.find("#work_id").html());
					$("input[name='sort_id']").val(panel.find("#sort_id").html());
					$("input[name='easy_id']").val(panel.find("#easy_id").html());
					$("input[name='upper_work_id']").val(panel.find("#upper_work_id").html());
					$("input[name='work_price']").val(panel.find("#work_price").html());
					$("#modal").show();
				});
				prop.find("#deleteProcess").attr("onclick","deleteProcess("+n.No_serial+")");
			});
		}
	}
	var work_name=$("input[name='work_name']");
	work_name.change(function(){
    	$("input[name='easy_id']").val(makePy(work_name.val()));
    });
	//查找
	$("#find").click(function() {
//		$("input[name='No_serial']").val("");
//		$("input[name='work_name']").val("");
//		$("select[name='working_procedure_section']").val("");
		$("#modal").hide();
		pop_up_box.loadWait();
		$.get("../pm/getProductionProcessInfo.do", {
			"work_type" : $.trim($("#work_type").val()),
			"working_procedure_section" : $.trim($("select[name='working_procedure_section']").val())
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
			"work_type" : $.trim($("#work_type").html())			
		},function(data) {
			pop_up_box.loadWaitClose();
			$(".modal-body input").val("");
			$("input[name='No_serial']").val(data+1);
			$("#modal").show();
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
		if(No_serial && work_name){
			pop_up_box.loadWait();
			$.get("../pm/addProductionProcessInfo.do", {
				"No_serial" : No_serial,
				"work_name" : work_name,
				"working_procedure_section" : $.trim($("select[name='working_procedure_section']").val()),
				"work_type" : $.trim($("select[name='work_type']").val()),
				"work_id" : $.trim($("input[name='work_id']").val()),
				"sort_id" : $.trim($("input[name='sort_id']").val()),
				"easy_id" : $.trim($("input[name='easy_id']").val()),
				"upper_work_id" : $.trim($("input[name='upper_work_id']").val()),
				"work_price" : $.trim($("input[name='work_price']").val())
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
	$("select[name='working_procedure_section']").change(function(){
		$("#find").click();
	});
	
	//查找执行
	$("#find").click();
});

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
		"work_type_1" : processData[index].work_type,//$.trim($("#work_type").html()),
		"No_serial_1" : processData[index].No_serial,
		"work_name_1" : processData[index].work_name,
		"working_procedure_section" : $.trim($("#working_procedure_section").val()),
		"work_type_2" : processData[index-1].work_type,//$.trim($("#work_type").html()),
		"No_serial_2" : processData[index-1].No_serial,
		"work_name_2" : processData[index-1].work_name,
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
//			pop_up_box.showMsg("上移成功!",function(){});
			$("#find").click();
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
		"work_type_1" : processData[index].work_type,
		"No_serial_1" : processData[index].No_serial,
		"work_name_1" : processData[index].work_name,
		"No_serial_2" : processData[index+1].No_serial,
		"work_name_2" : processData[index+1].work_name,
		"work_type_2" : processData[index+1].work_type,
		"working_procedure_section" : $.trim($("#working_procedure_section").val())
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
//			pop_up_box.showMsg("下移成功!",function(){});
			$("#find").click();
		}else{
			pop_up_box.showMsg("下移失败!");
		}
	});
}

//编辑工序
//var editProcess = function(n){
//	$("input[name='No_serial']").attr("disabled",true);
//	$("#working_procedure_section").attr("disabled",true);
	
//	$("input[name='No_serial']").val(n);
//	$("input[name='work_name']").html(n.work_name);
////	$("select[name='work_type']").html(n.work_type);
//	$("input[name='work_id']").html(n.work_id);
//	$("input[name='sort_id']").html(n.sort_id);
//	$("input[name='easy_id']").html(n.easy_id);
//	$("input[name='upper_work_id']").html(n.upper_work_id);
//	$("input[name='work_price']").html(n.work_price);
//	$("#modal").show();
//	for(p in processData){
//		if(n == processData[p].No_serial){
//			$("input[name='work_name']").val(processData[p].work_name);
//			$("#working_procedure_section").val(processData[p].working_procedure_section);
//		}
//	}
//}

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
			"work_type" : $.trim($("#work_type").html()),
			"No_serial" : No_serial,
			"work_id" : work_id
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