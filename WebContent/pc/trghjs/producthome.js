//1.判断是否登录
$.get("../customer/getCustomer.do",function(data){
	 if(!data){
		//没有登录就去登录
		 $.cookie("backurl","product.html",{ path: '/', expires: 1 });
		 window.location.href="../pc/login.html";
	 }
});
if(is_weixin()){
	$("#scxq").show();
	$("#upload-btn").hide();
	$("#scxq").click(function(){
		var myDate=new Date().getTime();
		var imgPath="/temp/001/xq/"+myDate+".jpg";
		var imgitem=$('<div class="upload-img"><img src="images/register_19.jpg"></div>');
 		$("#imglist").append(imgitem);
		weixinfileup.imguploadToWeixin(this, imgPath, imgitem.find("img"));
	});
}
$("#postxuqiu").click(function(){
	var demandInfo=$("textarea").val();
	var deliveryDate=$(".Wdate").val();
	var imgs=$("#imglist").find("img");
	var imgPath="";
	for (var i = 0; i < imgs.length; i++) {
		var path=$(imgs[i]).attr("src");
		if(imgPath==""){
			imgPath=path;
		}else{
			imgPath+=","+path;
		}
	}
	if(demandInfo||imgs){
		$.post("../tailorMade/saveTailorMadeInfo.do",{
			"demandInfo":demandInfo,
			"deliveryDate":deliveryDate,
			"item_id":"CP000001",
			"imgPath":imgPath
		},function(data){
			if (data.success) {
				pop_up_box.showMsg("提交成功,请等待报价!",function(){
				window.location.href="await_pay.html";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}else{
		pop_up_box.showMsg("请输入需求或者上传需求图片!");
	}
});
function imgUpload(t){
	var myDate=new Date().getTime();
	var imgPath="/temp/001/xq/"+myDate+".jpg";
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":0.3
	},t,function(imgUrl){
		pop_up_box.loadWaitClose();
		var imgitem=$('<div class="upload-img"><img src="..'+imgUrl+'"></div>');
 		$("#imglist").append(imgitem);
	});
}