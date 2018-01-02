$(function(){
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
				}
				delPerson();
			});
		});
	});
	
	function delPerson(){
		$(".del").click(function(){
			$(this).parent().remove();
		});
	}
	
	$(".btn-primary").click(function(){
		var chatTitle=$.trim($("input[name='chatTitle']").val());
		var weixinID=$(".chat-mem-ctn>div").find("input");
		if (chatTitle=="") {
			pop_up_box.showMsg("请输入会话标题");
		}else if (!weixinID||weixinID.length<1) {
			pop_up_box.showMsg("请选择成员!");
		}else{
			var ids=[];
			for (var i = 0; i < weixinID.length; i++) {
				var id=$(weixinID[i]).val();
				ids.push(id);
			}
			if (ids.length<3||ids.length>999) {
				pop_up_box.showMsg("会话成员必须在3人或以上，1000人以下");
				return;
			}
			$.post("chatCreate.do",{
				"chatTitle":chatTitle,
				"userlist":ids
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("创建成功!",function(){
						window.location.href="sendChatMsg.do?"+data.msg;
					});
				}else{
					pop_up_box.showMsg("创建失败!"+data.msg);
				}
			});
		}
	});
	
});
