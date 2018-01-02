pop_up_box.loadWait();
$.get("../manager/getJSONArrayByFile.do",{
	"path":path
},function(data){
	pop_up_box.loadWaitClose();
	if(data&&data.length>0){
		$.each(data,function(i,n){
			var item=$($("#item").html());
			$("#list").append(item);
			item.find("input").val(n.val);
			item.find(".input-group-addon").click(function(){
				$(this).parents(".form-group").remove();
				pop_up_box.showMsg("请点击保存彻底删除");
			});
		});
	}else{
		var item=$($("#item").html());
		$("#list").append(item);
		item.find(".input-group-addon").click(function(){
			$(this).parents(".form-group").remove();
		});
		item.find("input").focus();
	}
});
$("#add").click(function(){
	var item=$($("#item").html());
	$("#list").append(item);
	item.find(".input-group-addon").click(function(){
		$(this).parents(".form-group").remove();
	});
	item.find("input").focus();
});
///拖动
$("#list").sortable();
/////////
$("#save").click(function(){
	var list=$("#list>.form-group");
	if(list&&list.length>0){
		var jsons=[];
		for (var i = 0; i < list.length; i++) {
			var val=$(list[i]).find("input").val();
			jsons.push(JSON.stringify({"val":val}));
		}
		pop_up_box.postWait();
		$.post("../manager/saveJSONArrayFile.do",{
			"path":path,
			"jsons":"["+jsons.join(",")+"]"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!");
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}
});