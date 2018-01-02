var excelpro;
function excelimport(t,typeName) {
	if (!typeName) {
		typeName="";
	}
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=xls"+typeName,
		"msgId" : "msg",
		"fileId" : "xls"+typeName,
		"msg" : "",
		"fid" : "",
		"uploadFileSize" : 10000
	}, t, function(imgurl) {
		setTimeout(function() {
			pop_up_box.dataHandling("导入数据后台处理中.....");
			$.get("../product/excelImport.do", {
				url : imgurl,
				"typeName":typeName
			}, function(data) {
				clearInterval(excelpro);
				pop_up_box.loadWaitClose();
				if (data.success) {
					var msg = data.msg;
					if (!msg) {
						msg = "";
					}
					pop_up_box.showMsg("数据导入成功!" + msg, function() {
						$.get("../product/excelOrderMsg.do", {
							"key" : "excelordermsg"
						}, function(data) {
							if (data.success && data.msg) {
								if (data.msg) {
//									pop_up_box.showMsg("有导入数据不全信息!", function() {
//										window.open("user/showFile.do?url=../"+data.msg);
//									});
								}
							}
						});
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("数据导入失败,错误:" + data.msg);
					} else {
						pop_up_box.showMsg("数据导入失败,请联系管理员!");
					}
				}
			});
			excelpro = setInterval(function() {
				$.get("../product/excelOrderMsg.do", {
					"key" : "exceprogress"
				}, function(data) {
					if (data.success && data.msg) {
						pop_up_box.loadWaitClose();
						pop_up_box.dataHandling("导入数据后台处理中," + data.msg);
					}else{
						clearInterval(excelpro);
					}
				});
			}, 2000);/**/
		}, 1000);

	});
}
function sendSms(){
	if (confirm("是否要发送短信!")) {
		var empl="";
		if (confirm("是否同步发送给业务员?")) {
			empl="?empl=empl";
		}
		pop_up_box.dataHandling("短信发送中.....");
		$.get("../product/sendSms.do"+empl,function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("发送完成,本次共发送:"+data.msg);
			}else{
				pop_up_box.showMsg("发送失败:错误:"+data.msg);
			}
		});
	}
}