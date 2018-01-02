var imgsrc=document.getElementById("logoimg").src;
weixinShare.init("二维码免费生成工具","用户可以自定义二维码宽高,二维码中显示的图片,自定义生成二维码的内容");
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":0.3
	},t,function(imgUrl){
		pop_up_box.loadWaitClose();
		$("#logo").val(imgUrl);
		$("#logoimg").attr("src",".."+imgUrl);
	});
}

if(is_weixin()){
	$("#scxq").show();
	$("#upload-btn").hide();
	weixinfileup.init();
	$("#scxq").click(function(){
		var myDate=new Date().getTime();
		var imgPath="/temp/ewm/logo/"+myDate+".jpg";
		weixinfileup.imguploadToWeixin(this, imgPath, $("#logoimg"),function(){
			$("#logoimg").attr("src",".."+imgPath);
			$("#logo").val(imgPath);
			
		});
	});
}else{
	$("#scxq").hide();
	$("#upload-btn").show();
}

	$("#getrem").click(function() {
		if($("#qrURL").val()==""){
			pop_up_box.showMsg("请输入二维码生成内容!",function(){
				$("#qrURL").focus();
			});
			return;
		}else{
			 $('.code').css({'display':'block'});
			 $('.codeT').css({'display':'none'});
			pop_up_box.postWait();
			$.post('../employee/generateQRCode.do', {
				"qrUrl" : $("#qrURL").val(),
				"width" : $("#wd").val(),
				"height" : $("#hd").val(),
				"image_width" : $("#imgwd").val(),
				"logo" : true,
				"logopath" : $("#logo").val(),
				"image_height" : $("#imghd").val()
			}, function(data) {
				pop_up_box.loadWaitClose();
				if (data.success) {
					$('.codeT').hide();
					$('.code').show();
					$("#qrcode").attr("src", ".." + data.msg);
				} else {
					if (data.msg) {
						pop_up_box.showMsg("生成错误," + data.msg);
					} else {
						pop_up_box.showMsg("生成错误!");
					}
				}
			});
		}
	});
	$(".add").click(function() {
		var num = parseFloat($(this).parent().find(".num").val());
		if (!num) {
			num = 0;
		}
		$(this).parent().find(".num").val(num + 1);
		$(this).parent().find(".num").blur();
	});
	$(".sub").click(function() {
		var num = parseFloat($(this).parent().find(".num").val());
		if (!num) {
			$(this).parent().find(".num").val(0);
		} else {
			$(this).parent().find(".num").val(num - 1);
		}
		$(this).parent().find(".num").blur();
	});
	$("#imgymwd").bind("input propertychange blur", function() {
		$(".printitem").css("margin-left", this.value + "px");
	});
	$("#imgymhd").bind("input propertychange blur", function() {
		$(".printitem").css("height", this.value + "px");
	});
	$("#beginprint").click(function() {
		$("#printdiv").jqprint();
	});