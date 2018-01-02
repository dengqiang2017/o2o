//基础数据导出
function excelExport(typeName) {
	pop_up_box.loadWait();
	var type_id;
	if(!type_id){
		type_id=$(".tree .activeT").find("input").val();
	}
	if(!type_id){
		type_id="";
	}else{
		type_id=type_id+"%";
	}
	$.get("../maintenance/" + typeName + "Export.do", {
		"searchKey":$.trim($("#searchKey").val()),
		"type_id":type_id,
		"ver" : Math.random()
	}, function(data) {
		pop_up_box.loadWaitClose();
		if (data.msg) {
			window.location.href = data.msg;
		}
	});
}
$(function(){
	$("input[type='file']").attr("accept","application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
});
// 基础数据导入
function excelImport(t, typeName) {
	if (!typeName) {
		typeName = "";
	}
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=xls" + typeName,
		"msgId" : "msg",
		"fileId" : "xls" + typeName,
		"msg" : "",
		"fid" : "",
		"uploadFileSize" : 10000
	}, t, function(imgurl) {
		setTimeout(function() {
			pop_up_box.dataHandling("导入数据后台处理中.....");
			$.get("../maintenance/" + typeName + "Import.do", {
				url : imgurl,
				"typeName" : typeName
			}, function(data) {
				pop_up_box.loadWaitClose();
				if (data.success) {
					var msg = data.msg;
					pop_up_box.showMsg("数据导入成功!", function() {
						if (msg) {
							pop_up_box.showMsg("有导入数据不全信息!", function() {
								var myWindow = window.open();
//								myWindow.document.write("重复数据项：");
								myWindow.document.write(msg);
								myWindow.focus();
							});
						}
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("数据导入失败,错误:" + data.msg);
					} else {
						pop_up_box.showMsg("数据导入失败,请联系管理员!");
					}
				}
			});
		}, 1000);
	});
}