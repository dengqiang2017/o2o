var userinfo={
		init:function(){
			$(".saveinfo").click(function(){
				var clerkName=$.trim($("#clerkName").val());
				if(clerkName==""){
					pop_up_box.showMsg("名称不能为空!",function(){
						$("#clerkName").focus();
					});
				}else{
					pop_up_box.postWait();
					$.post("../manager/saveUserInfo.do",$("#proForm").serialize(),function(data){
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("保存成功!");
						}else{
							
						}
					});
				}
			});
			//////////////
			if (common.isWeixin()) {
				$("#scpz").show();
				$("#upload-btn").hide();
				weixinfileup.init();
				$("#scpz").unbind("click");
				$("#scpz").click(function(){
					weixin=1;
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							$.get("../weixin/getWeixinFwqImg.do",{"url":url,"orderNo":orderNo},function(data){
								if (data.success) {
									pop_up_box.showMsg("上传成功!");
								} else {
									if (data.msg) {
										pop_up_box.showMsg("上传错误!" + data.msg);
									} else {
										pop_up_box.showMsg("上传错误!");
									}
								}
							});
						});
						$(".upload-img>img").attr("src",imgurl);
						$("#filePath").val(imgurl);
					});
				});
			}else{
				$("#scpz").hide();
				$("#upload-btn").show();
			}
		}
}
userinfo.init();
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"filePath",
		"uploadFileSize":5
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		$("#filePath").val(imgurl);
		$(".upload-img>img").attr("src",".."+imgurl);
	});
}