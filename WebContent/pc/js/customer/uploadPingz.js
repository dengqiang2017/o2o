$.get("../pc/uploadPingz.jsp",function(data){
	$("body").append(data);
});
var uploadPingz={
		init:function(orderNo,func){
///////////////////////////////上传凭证//begin//////////////////////////
			$(".modal-first").find(".btn-default,.close").unbind("click");
			$(".modal-first").find(".btn-default,.close").click(function(){
				$(".modal-cover-first,.modal-first").hide();
				if(func){
					func();
				}
//				window.location.href="personal_center.html";
			});
			var weixin=0;///用于在保存图片的时候判断上传类型
			$(".modal-first").find("#scpzpc").unbind("click");
			$(".modal-first").find("#scpzpc").click(function(){
				var imgurl=$.trim($(".modal-body").find("#filepath").val());
				if(imgurl!=""){
					$.post("../weixin/certificateImg.do",{
						"imgurl":imgurl,
						"weixin":weixin,
						"orderNo":orderNo
					},function(data){
						$(".modal-cover-first,.modal-first").hide();
						if (data.success) {
							pop_up_box.showMsg("上传成功!",function(){
								if(func){
									func();
								}
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
				}
			});
			if (is_weixin()) {
				$(".modal-first").find("#scpz").show();
				$(".modal-first").find("#upload-btn").hide();
				weixinfileup.init();
				$(".modal-first").find("#scpz").unbind("click");
				$(".modal-first").find("#scpz").click(function(){
					weixin=1;
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							$.get("../weixin/getWeixinFwqImg.do",{"url":url,"orderNo":orderNo},function(data){
								if (data.success) {
									pop_up_box.showMsg("上传成功!",function(){
//										window.location.href="personal_center.html";
										if(func){
											func();
										}
									});
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
				$(".modal-first").find("#scpz").hide();
				$(".modal-first").find("#upload-btn").show();
			}
			/////////////////////////上传凭证///end///////
		}
}
function imgUpload(t){
//	if (is_weixin()) {
//		weixinfileup.chooseImage(t,function(imgurl){
//			$(".modal-body").find("img").attr("src",imgurl);
//		});
//	}else{
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
			"msgId":"",
			"fileId":"imgFile",
			"msg":"",
			"fid":"filepath",
			"uploadFileSize":10
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			$("#filepath").val(imgurl);
			$(".modal-body").find("img").attr("src",".."+imgurl);
		});
//	}
	
}