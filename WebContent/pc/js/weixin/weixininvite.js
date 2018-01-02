/**
 * 邀请列表中的成员关注
 * j--微信通讯录账号
 * k--状态列
 */
function weixininvitemore(j,k){
	var tr=$("tbody").find("tr");
	if (tr) {
		if (tr.length>0) {
			pop_up_box.dataHandlingWait("邀请已发出请等待微信发出邀请!");
//			pop_up_box.showMsg("邀请已发出请等待微信发出邀请!");
			for (var i = 0; i < tr.length; i++) {
				var weixinID=$.trim($(tr[i]).find("td:eq("+j+")").html());
				if (ifnull(weixinID)!="") {
					weixininvite(weixinID,false,function(msg){
						pop_up_box.loadWaitClose();
						if (msg.indexOf("已关注")) {
							$(tr[i]).find("td:eq("+k+")").html("已关注");
						}else {
							$(tr[i]).find("td:eq("+k+")").html("已邀请");
						}
					});
				}
			}
		}
	}
}
/**
 * 邀请列表中的成员关注
 * @param t
 */
function weixininviteone(t){
	var weixinID=$.trim($(t).parents("tr").find("td:eq(4)").html());
	pop_up_box.dataHandlingWait();
		weixininvite(weixinID,true,function(msg){
			pop_up_box.loadWaitClose();
			if (msg=="已关注") {
				$(t).parent().html("已关注");
			}else {
				$(t).parent().html("已邀请");
			}
		});
}
function weixininviteEdit(weixinID){
	weixininvite(weixinID,true,function(msg){
		$('#inviteID').hide();
		 if (msg=="已关注") {
			$("#weixinStatus").val("1");
		}
	});
}
function weixininvite(weixinID,t,func){
	$.get("../employee/invite_send.do",{
		"weixinID":weixinID
	},function(data){
		if (data.success) {
			if (func) {
				func(data.msg);
			}
			if (t) {
				if (data.msg) {
					pop_up_box.showMsg(data.msg);
				}else{
					pop_up_box.showMsg("已邀请,请关注微信发出邀请结果,并将结果同步到系统中!");
				}
			}
		}else{
			pop_up_box.showMsg("数据提交错误:"+data.msg);
		}
	});
}

function employeeToWeixin(type,id){
	pop_up_box.dataHandlingWait();
	$.get("../employee/employeeToWeixin.do",{
		"type":type,
		"id":id,
		"searchKey":id
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			if (data.msg) {
				pop_up_box.showMsg(data.msg);
			}else{
				pop_up_box.showMsg("数据同步成功");
			}
		}else{
			pop_up_box.showMsg("数据同步错误:"+data.msg);
		}
	});
}
