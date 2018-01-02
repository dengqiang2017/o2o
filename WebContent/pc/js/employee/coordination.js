$(function(){
	$(".file-icon-group").hide();
	$(".Wdate").html(new Date().Format("yyyy-MM-dd"));
	$("#saveSp").click(function(){
		var OA_what=$("#OA_what").val();
		var content=$("#content").html();
		if (content=="") {
			content=$("#content").val();
		}
		if ($.trim(OA_what)=="") {
			pop_up_box.showMsg("请输入申请标题!");
		}else if ($.trim(content)=="") {
			pop_up_box.showMsg("请输入申请内容");
		}else{
			pop_up_box.postWait();
			$.post("saveCoordination.do",{
				"OA_what":OA_what,
				"item_name":$("#clsname").val(),
				"content":content,
				"store_date":$(".Wdate").val()
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						$("#OA_what").val("");
						$("#content").html("");
						window.location.reload();
					});
				} else {
					pop_up_box.showMsg("保存错误!" + data.msg);
				}
			});
		}
	});
	//////////////////////////
	if (is_weixin()) {
		var weixin=0;///用于在保存图片的时候判断上传类型
		$("#scpz").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scpz").click(function(){
			weixin=1;
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					var clerk_id=$.trim($("#clerk_id").val());
					var imgPath="temp/"+com_id+"/"+clerk_id+"/sp/"+Math.random()+".jpg";
					$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":imgPath},function(data){
						if (data.success) {
//							pop_up_box.showMsg("上传成功!");
							fileloadHandler(imgPath);
						} else {
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
					
				});
				$(".modal-body").find("img").attr("src",imgurl);
				$("#imgFile").val(imgurl);
			});
		});
	}else{
		$("#scpz").hide();
		$("#upload-btn").show();
	}
});
