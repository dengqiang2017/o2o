var com_id=getQueryString("com_id");
if(!com_id){
	com_id="001";
}
var itemhtml=$(".list-group").html();
$(".list-group").html("");
pop_up_box.loadWait();
$.get("../"+com_id+"/orderTrackThead.json",function(data){
	pop_up_box.loadWaitClose();
	if(data&&data.length>0){
	 $.each(data,function(i,n){
		 var item=$(itemhtml);
		 $(".list-group").append(item);
		 item.find("#show").prop("checked",n.show);
		 item.find("#find").prop("checked",n.find);
		 item.find("input[name='id']").val(n.id);
		 if(n.type){
			 item.find("select[name='type']").val(n.type);
		 }
		 item.find("input[name='findid']").val(n.findid);
		 item.find("input[name='name']").val(n.name);
	 });
	 $(".list-group").sortable({axis:"y"});
	}else{
		var item=$(itemhtml);
		 $(".list-group").append(item);	
	}
});
function addItem(t){
  var item=$(itemhtml);
  $(t).parents("li").after(item);
}
$(".btn-success").click(function(){
	var lis=$(".list-group-item");
	if(lis&&lis.length>0){
		var list=[];
		for (var i = 0; i < lis.length; i++) {
			var item=$(lis[i]);
			var id=$.trim(item.find("input[name='id']").val());
			var name=$.trim(item.find("input[name='name']").val());
			if(id!=""&&name!=""){
				var show=item.find("#show").prop("checked");
				var find=item.find("#find").prop("checked");
				var findid=$.trim(item.find("input[name='findid']").val());
				var type=$.trim(item.find("select[name='type']").val());
				list.push(JSON.stringify({"show":show,"find":find,"id":id,"findid":findid,"type":type,"name":name}));
			}
		}
		if(list.length>0){
			pop_up_box.postWait();
			$.post("../manager/saveJSONArrayFile.do",{
				"path":"orderTrackThead.json",
				"jsons":"["+list.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.toast("保存成功!",2000);
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}
	}
});