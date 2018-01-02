$(function(){
	$("#issue").click(function(){
		$("#listpage").hide();
		$("#pushpage").show();
	});
	$("#pushpage .pull-left").click(function(){
		$("#listpage").show();
		$("#pushpage").hide();
	});
	$("#save").click(function(){
		pop_up_box.postWait();
		$.post("../user/saveNoticeInfo.do",{
		"seeds_id":$("#pushpage #seeds_id").html(),
		"notice_title":$("#pushpage input").val(),
		"notice_content":$("#pushpage textarea").val()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!",function(){
					//清空发布
					$("#pushpage input,#pushpage textarea").val("");
					$("#listpage").show();
					$("#pushpage").hide();
					$(".find").click();
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}); 
});