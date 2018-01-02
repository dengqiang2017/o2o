/**
 * ajaxFileUpload上传文件
 * @param params 参数json以下是具体子项
 * @param fid 返回上传文件id值的文本框id
 * @param msgId 返回信息的id
 * @param fileId 上传file组件的id或者name
 * @param msg 提示信息
 * @param uploadUrl 上传地址url
 * @param type 上传文件类型控制
 * @param callback(boolean) 回调函数用于数据状态的返回
 */

/**
 * logo图片上传
 * @param t
 */
function modalLogoUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl=$("#filepath").val();
	if (imgurl&&imgurl.indexOf("advantage")<0) {
		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	}else{
		imgurl="";
	}
	ajaxUploadFile({
		"uploadUrl" :"../upload/uploadImage.do?fileName=imgFile&type=logo&templateName="+templateName+imgurl,
		"msgId" : "logogmsg",
		"fileId" : "imgFile",//
		"msg" : "logo图片",
		"fid" : "filepath",
		"uploadFileSize" :0.5,
		"type":"img"
	}, t, function(imgUrl) {
		$(".logo_image").find("#filepath").val(imgUrl);
		$(".logo_image").find("#imginput").val(imgUrl);
		$(".logo_image").find("img").attr("src",".."+imgUrl+"?ver="+Math.random());
	});
	
}

function imgonlyUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl="";//$("#filepath").val();
	if (imgurl&&imgurl.indexOf("advantage")<0) {
		//imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	}else{
		imgurl="";
	}imgurl="";
	ajaxUploadFile({//type=imgonly&
		"uploadUrl" :"../upload/uploadImage.do?fileName=imgFile&templateName="+templateName+imgurl,
		"msgId" : "msg",
		"fileId" : "imgFile",//
		"msg" : "图片",
		"fid" : "filepath",
		"uploadFileSize" :1,
		"type":"img"
	}, t, function(imgUrl) {
		if(imgUrl){
			$(".logo_image:eq(0)").find("#filepath").val(imgUrl);
//			$(".logo_image:eq(0)").find("#imginput").val(imgUrl);
			$(".logo_image:eq(0)").find("img").attr("src",".."+imgUrl+"?ver="+Math.random());
		}
	});
}
function imgonlyUploadPhone(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl=$("#filepath").val();
	if (!imgurl&&imgurl.indexOf("advantage")<0) {
		alert("请先上传PC端图片!");
		return;
	}
		imgurl=imgurl.replace(".", "-phone.");
		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	ajaxUploadFile({//type=imgonly&
		"uploadUrl" :"../upload/uploadImage.do?fileName=imgFilephone&templateName="+templateName+imgurl,
		"msgId" : "msg",
		"fileId" : "imgFilephone",//
		"msg" : "图片",
		"fid" : "filepathphone",
		"uploadFileSize" :1,
		"type":"img"
	}, t, function(imgUrl) {
		$(".logo_image:eq(1)").find("#filepathphone").val(imgUrl);
//		$(".logo_image:eq(1)").find("#imginputphone").val(imgUrl);
		$(".logo_image:eq(1)").find("img").attr("src",".."+imgUrl+"?ver="+Math.random());
	});
}
function videoimgUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl=$("#filepath").val();
	if (imgurl&&imgurl.indexOf("advantage")<0) {
		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	}else{
		imgurl="";
	}
	ajaxUploadFile({//type=imgonly&
		"uploadUrl" :"../upload/uploadImage.do?fileName=videoimgFile&templateName="+templateName+imgurl,
		"msgId" : "msg",
		"fileId" : "videoimgFile",//
		"msg" : "图片",
		"fid" : "videofilepath",
		"uploadFileSize" :10,
		"type":"img"
	}, t, function(imgUrl) {
		$(".logo_image:eq(1)").find("#videofilepath").val(imgUrl);
		$(".logo_image:eq(1)").find("#videoimginput").val(imgUrl);
		$(".logo_image:eq(1)").find("img").attr("src",".."+imgUrl+"?ver="+Math.random());
	});
}
function videoUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl=$("#videoaddress").val();
	if (imgurl&&imgurl.indexOf("advantage")<0) {
		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	}else{
		imgurl="";
	}
	ajaxUploadFile({//type=imgonly&
		"uploadUrl" :"../upload/uploadImage.do?fileName=videoFile"+imgurl,
		"msgId" : "msg",
		"fileId" : "videoFile",//
		"msg" : "",
		"fid" : "videoaddress",
		"uploadFileSize" :100,
		"type":"MP4"
	}, t, function(imgUrl) {
		$("#videoaddress").val(imgUrl);
//		$(".logo_image").find("img").attr("src","../content/"+$.cookie("loginName")+"/"+templateName+"/"+imgUrl+"?ver="+Math.random());
	});
}
function articleUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
	var imgurl=$("#articleaddress").val();
	if (imgurl&&imgurl.indexOf("advantage")<0) {
		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
	}else{
		imgurl="";
	}
	ajaxUploadFile({//type=imgonly&
		"uploadUrl" :"../upload/uploadImage.do?fileName=articleFile&templateName="+templateName+imgurl,
		"msgId" : "msg",
		"fileId" : "articleFile",//
		"msg" : "文章",
		"fid" : "",
		"uploadFileSize" :100,
		"type":"doc"
	}, t, function(imgUrl) {
		$("#articleaddress").html(imgUrl);
//		$(".logo_image").find("img").attr("src","../content/"+$.cookie("loginName")+"/"+templateName+"/"+imgUrl+"?ver="+Math.random());
	});
}
function imgBannerUpload(t){
	var templateName=$("input[name='templateName']",parent.document).val();
//	var imgurl=$("#filepath").val();
//	if (imgurl) {
//		imgurl="&imgurl="+imgurl+"&ver="+Math.random();
//	}else{
//		imgurl="";
//	}
	ajaxUploadFile({
		"uploadUrl" :"../upload/uploadImage.do?fileName=imgFile&banner=1&templateName="+templateName,
		"msgId" : "msg",
		"fileId" : "imgFile",//
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" :10,
		"type":"img"
	}, t, function(imgUrl) {
		$(".logo_image").find("#filepath").val(imgUrl);
		$(".logo_image").find("#imginput").val(imgUrl);
		$(".logo_image").find("img").attr("src",".."+imgUrl+"?ver="+Math.random());
	});
}