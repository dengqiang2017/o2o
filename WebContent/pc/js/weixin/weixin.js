var excelpro;
$(function(){
$("#weixinsyn").click(function(){
	if (confirm("是否要进行同步!")) {
		pop_up_box.dataHandlingWait();
		var b=true;
		$.get("employee/weixinAccountSyn.do",function(data){
			clearInterval(excelpro);
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("同步完成!");
			}else{
				b=false;
				pop_up_box.showMsg("同步失败!"+data.msg);
			}
		});
		setTimeout(function() {
			if (b) {
				pop_up_box.loadWaitClose();
				pop_up_box.dataHandling("数据后台处理中.....");
				excelpro = setInterval(function() {
					$.get("product/excelOrderMsg.do", {
						"key" : "exceprogress"
					}, function(data) {
						if (data.success && data.msg) {
							pop_up_box.loadWaitClose();
							pop_up_box.dataHandling("数据后台处理中," + data.msg);
						}else{
							clearInterval(excelpro);
						}
					});
				}, 1000);/**/
			}
		}, 1000);
	}
});
if($(".panel-body #backup").length>0){
	$(".panel-body #backup").click(function(){
		pop_up_box.dataHandlingWait();
		$.get("employee/backup.do",function(data){
			pop_up_box.loadWaitClose();
			if(data.success){
				window.location.href=data.msg;
			}
		});
	});
}
}); 