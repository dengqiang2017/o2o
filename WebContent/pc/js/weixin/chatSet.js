$(function(){
	var add_user_list=[];
	var del_user_list=[];
	delPerson();
	function delPerson(){
		$(".del").click(function(){
			//1.
			$(this).parent().remove();
			//2.
			var  val=$(this).parent().find("input").val();
			if ($.inArray(val,del_user_list)<0) {
				del_user_list.push(val);
			}
		});
	}
	var item=$("#item");
	$(".add-mem").click(function(){
		$.get("selectPerson.do",function(data){
			$("body").append(data);
			selectPerson.init(function(weixinID,name){
				for (var i = 0; i < name.length; i++) {
					var item0=$(item.html());
					$(".chat-mem-ctn>div:eq(0)").append(item0);
					item0.find(".chat-mem-name").html(name[i]);
					item0.find("input").val(weixinID[i]);
					selectPerson.setImg(weixinID[i]);
					if ($.inArray(weixinID[i],add_user_list)<0) {
						add_user_list.push(weixinID[i]);
					}
				}
				delPerson();
			});
		});
	});
	//退出并删除会话
	$(".btn-danger").click(function(){
		$.get("chatQuit.do",{
			"chatid":$("#chatid").val()
		},function(data){
			pop_up_box.resultMsg(data,"退出成功","退出失败",function(){
				window.location.href="chatList.do";
			});
		});
	});
	//确定
	$(".btn-primary").click(function(){
		var chatTitle=$.trim($("#chatTitle").val());
		var weixinID=$(".chat-mem-ctn>div").find("input");
		if (chatTitle=="") {
			pop_up_box.showMsg("请输入会话标题");
		}else if(!weixinID||weixinID.length<1){
			pop_up_box.showMsg("请选择成员!");
		}else{
//			var ids=[];
//			for (var i = 0; i < weixinID.length; i++) {
//				var id=$(weixinID[i]).val();
//				ids.push(id);
//			}
//			if (ids.length<3||ids.length>999) {
//				pop_up_box.showMsg("会话成员必须在3人或以上，1000人以下");
//				return;
//			}
			$.post("chatCreate.do",{
				"add_user_list":add_user_list,
				"del_user_list":del_user_list,
				"chatTitle":chatTitle,
				"chatid":$("#chatid").val()
			},function(data){
				pop_up_box.resultMsg(data,"修改成功","修改失败",function(){
					window.location.href="sendChatMsg.do?"+$("#chatid").val();
				});
			});
		}
	});
});