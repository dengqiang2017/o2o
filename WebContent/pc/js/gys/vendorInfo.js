var vendorInfo={
		init:function(){
			var corp_id=$.trim($("#corp_id").html());
			if (corp_id!= "") {
				$.get("../saiyu/getevalimg.do", {
					"customer_id" : corp_id
				}, function(data) {
					if (data && data.length > 0) {
						$.each(data, function(i, n) {
							if (corp_id != "") {
								var com_id = $.trim($("#com_id").html());
								var path="../" + com_id+"/evalimg/"+ corp_id + "/" + n+ "?ver=" + Math.random();
								$("#"+n.split(".")[0].split("_")[1]).attr("src",path);
							}
						});
					}
				});
			}
			$("#savevendor").click(function(){
				var corp_name=$.trim($("input[name='corp_name']").val());
				var corp_sim_name=$.trim($("input[name='corp_name']").val());
				var movtel=$.trim($("input[name='corp_name']").val());
				var corp_reps=$.trim($("input[name='corp_reps']").val());
				var corp_addr=$.trim($("#corp_addr").val());
				if(corp_name==""){
					pop_up_box.showMsg("请输入公司全称!");
				}else if(corp_sim_name==""){
					pop_up_box.showMsg("请输入公司简称!");
				}else if(movtel==""){
					pop_up_box.showMsg("请输入业务联系人电话!");
				}else if(corp_reps==""){
					pop_up_box.showMsg("请输入业务联系人名称!");
				}else if(corp_addr==""){
					pop_up_box.showMsg("请输入公司发货详细地址!");
				}else{
					pop_up_box.postWait();
					var ipts=$(".secition-one-body input");
					var json={};
					for (var i = 0; i < ipts.length; i++) {
						var ipt=$(ipts[i]).val();
						var name=$(ipts[i]).attr("name");
						json[name]=ipt;
					}
					json.working_range=$("#working_range").val();
					json.corp_addr=corp_addr;
					$.post("saveSupplierInfo.do",json,function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("保存成功!",function(){
								window.location.hef="supplier.do";
							});
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
		}
}
function imgCLientUpload(t, key, img) {
	pop_up_box.postWait();
	var path="/@com_id/evalimg/"+$("#corp_id").html()+"/"+key+".jpg";
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImageZs.do?fileName="+key+"&quality=1&imgPath="+path,
		"msgId" : "msg",
		"fileId" : key,
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 50
	}, t, function(imgurl) {
		pop_up_box.loadWaitClose();
		$("#" + img).attr("src", imgurl + "?ver=" + Math.random());
		pop_up_box.toast("已保存!", 1000);
	});
}