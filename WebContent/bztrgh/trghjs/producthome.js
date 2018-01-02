//1.判断是否登录
$.get("../customer/getCustomer.do",function(data){
	 if(!data){
		//没有登录就去登录
		 $.cookie("backurl",window.location.href,{ path: '/', expires: 1 });
		 window.location.href="../pc/login.jsp";
	 }else{
		 product.init();
	 }
});
var product={
		init:function(){
			document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
				$('textarea').blur();
			});
			$('textarea').bind('focus',function(){
				$('.logo_container').css('position','static');
				$('.body_04').css('display','none');
			}).bind('blur',function(){
				$('.logo_container').css({'position':'fixed','bottom':'0'});
				$('.body_04').css({'position':'fixed','bottom':'66px','display':'block'})
			});
			if(is_weixin()){
				$("#scxq").show();
				$("#upload-btn").hide();
				weixinfileup.init();
				$("#scxq").click(function(){
					var myDate=new Date().getTime();
					var imgPath="/temp/001/xq/"+myDate+".jpg";
					var imgitem=$('<div class="upload-img"><img></div>');
					$("#imglist").append(imgitem);
					weixinfileup.imguploadToWeixin(this, imgPath, imgitem.find("img"),function(){
						imgitem.find("img").attr("src",".."+imgPath);
					});
				});
			}else{
				$("#scxq").hide();
				$("#upload-btn").show();
			}
			$("#postxuqiu").click(function(){
				var demandInfo=$("textarea").val();
				var deliveryDate=$(".Wdate").val();
				if(deliveryDate==""){
					pop_up_box.showMsg("请选择要交货日期!");
					return;
				}
				var imgs=$("#imglist").find("img");
				if(imgs.length==0&&demandInfo==""){
					pop_up_box.showMsg("请上传需求图片或者录入需求文字");
					return;
				}
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
					pop_up_box.postWait();
					$.post("../tailorMade/saveTailorMadeInfo.do",{
						"demandInfo":demandInfo,
						"deliveryDate":deliveryDate,
						"item_id":"CP000001",
						"Eheadship":"内勤",
						"url": "/employee/add.do",
						"title":"客户上报定制需求通知",
						"description":"@comName-@Eheadship-@clerkName:客户@customerName,已经上报定制需求请尽快进行报价",
						"imgPath":imgPath
					},function(data){
						pop_up_box.loadWaitClose();
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
		}
}
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