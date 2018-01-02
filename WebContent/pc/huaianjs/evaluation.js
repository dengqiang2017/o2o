$(function(){
	evaluation.init();
});
var evaluation={
		imageUrl:"",
		init:function(){
			var params=window.location.href.split("?")[1];
			params=params.replace(/%22/g,"\"");
			params=decodeURIComponent(params);
			$.get("../orderTrack/getOrderEvalInfo.do",{
				"type":$("#type").val(),
				"params":params
			},function(data){
				for (var i = 0; i < parseInt(data.spzl); i++) {
					$("#spzl").find("img").eq(i).removeClass("endranslate");
					$("#spzl").find("img").eq(i).addClass("startranslate");
					$("#spzl").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				for (var i = 0; i < parseInt(data.fwtd); i++) {
					$("#fwtd").find("img").eq(i).removeClass("endranslate");
					$("#fwtd").find("img").eq(i).addClass("startranslate");
					$("#fwtd").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				for (var i = 0; i < parseInt(data.wlsd); i++) {
					$("#wlsd").find("img").eq(i).removeClass("endranslate");
					$("#wlsd").find("img").eq(i).addClass("startranslate");
					$("#wlsd").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				$("#yijian").html(data.yijian);
				if (data.imgs) {
					var imgs=data.imgs.split(",");
					if (imgs) {
						for (var i = 0; i < imgs.length; i++) {
							if (imgs[i]&&imgs[i]!="") {
								evaluation.imageUrl=imgs[i]+","+evaluation.imageUrl;
								$("#showpingjia").append('<img src="../'+imgs[i]+'" onclick="javascript:evaluation.showImg(this)">');
							}
						}
						$(".position_right").hide();
					}
				}
				if(data){
					$("#postEval").html("提交评价");
				}
			});
			$("#postEval").click(function(){
				pop_up_box.postWait();
				$.post("../orderTrack/postEval.do",{
					"yijian":$("textarea").val(),
					"type":$("#type").val(),
					"imageUrl":evaluation.imageUrl,
					"params":params,
					"spzl":$("#spzl").find(".startranslate").length,
					"fwtd":$("#fwtd").find(".startranslate").length,
					"wlsd":$("#wlsd").find(".startranslate").length
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("评论成功!" ,function(){
							window.location.href="order_center.html?type=0";
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("评论错误!" + data.msg);
						} else {
							pop_up_box.showMsg("评论错误!");
						}
					}
				});
			});
		    $('.star>img').click(function(){
		       var li=$(this).parents("li");
		       var n= li.find('.star>img').index(this);//01234
		       if($(this).hasClass("startranslate")){
			       $(this).removeClass("startranslate");
			       $(this).addClass("endranslate");
			       $(this).attr("src","../pc/images/xing2.png");
			       //把之前的前全部取消掉
			       for (var i = n; i < 5; i++) {
			    	   li.find('.star>img').eq(i).removeClass("startranslate");
			    	   li.find('.star>img').eq(i).addClass("endranslate");
			    	   li.find('.star>img').eq(i).attr("src","../pc/images/xing2.png");
					}
		       }else{
			       $(this).addClass("startranslate");
			       $(this).removeClass("endranslate");
			       $(this).attr("src","../pc/images/xing.png");
			     	//把之后的全部加上
			     	for (var i = 0; i <n; i++) {
			    	   li.find('.star>img').eq(i).addClass("startranslate");
			    	   li.find('.star>img').eq(i).removeClass("endranslate");
			    	   li.find('.star>img').eq(i).attr("src","../pc/images/xing.png");
					}
		       }
		 });
			if (is_weixin()) {
				$("#scpz").show();
				$("#pingjia").hide();
				weixinfileup.init();
				$("#scpz").click(function(){
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							var evalimgpath="/temp/eval"+Math.random()+".jpg";
							$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":evalimgpath},function(data){
								if (data.success) {
									pop_up_box.showMsg("上传成功!",function(){
										evaluation.imageUrl=data.msg+","+evaluation.imageUrl;
										$(".position_right").hide();
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
						$("#showpingjia").append('<img src="'+imgurl+'" onclick="javascript:evaluation.showImg(this)">');
					});
				});
			}else{
				$("#scpz").hide();
				$("#pingjia").show();
			}
		},showImg:function(t){
			$(".image-zhezhao").show();
			$("#imshow").html("");
			var index=$("#showpingjia img").index(t);
			 for (var i = 0; i < $("#showpingjia img").length; i++) {
				var img=$($("#showpingjia img")[i]);
				$("#imshow").append("<img style='display: none;' src='"+img.attr("src")+"'>");
			}
			$("#imshow").find("img:eq("+index+")").show();
			$("#closeimgshow").unbind("click");
			$("#closeimgshow").click(function(){
				$(".image-zhezhao").hide();
			});
		}
}
function imgUpload(t,name){
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImage.do?fileName="+name,
			"msgId":"",
			"fileId":name,
			"msg":"",
			"fid":"",
			"uploadFileSize":50
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			$("#showpingjia").append('<img src="..'+imgurl+'" onclick="javascript:evaluation.showImg(this)">');
			evaluation.imageUrl=imgurl+","+evaluation.imageUrl;
			$(".position_right").hide();
		});
}
