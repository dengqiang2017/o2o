$(function(){
	var item0=$("#item");
	pop_up_box.loadWait();
	$.get("../user/getCharids.do",function(data){
		$(".box-body").html("");
		 $.each(data,function(i,n){
			 var item=$(item0.html());
			 $(".box-body").append(item);
			 item.find(".chat-member").html(n.name);
			 item.find("input").val(n.chatid);
			 item.find(".chat-group").click(function(){
				 var val=$(this).find("input").val();
				 window.location.href="sendChatMsg.do?"+val;
			 });
		 });
		 pop_up_box.loadWaitClose();
	});
});