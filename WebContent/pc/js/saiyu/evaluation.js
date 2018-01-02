$(function(){
	evaluation.init();
});
var evaluation={
		imageUrl:"",
		init:function(){
			var params=window.location.href.split("?");
			var show=true;
			var orderNo="";
			var item_id="";
			var com_id="";
			var orders="";
			params=params[1].split("&");
			if(params.length>=2){
				orderNo=params[0].split("=")[1];//orderNo
				item_id=params[1].split("=")[1];//item_id
				com_id=params[2].split("=")[1];//item_id
				try {
					show=params[3].split("=")[1];//item_id
					var se=params[3].split("=")[0];//item_id
					if(se=="seeds_id"){
						show=false;
					}else{
						$("#upimg").hide();
						$("#postEval").hide();
					}
				} catch (e) {
					show=false;
				}
			}else{
				orders=$.cookie("orderparams");
			}
			$.get("../orderTrack/getOrderEvalInfo.do",{
				"type":$("#type").val(),
				"orderNo":orderNo,
				"com_id":com_id,
				"item_id":item_id
			},function(data){
				if(data){
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
					if(data){
						$("#postEval").html("提交评价");
					}
					
					if($.trim(data.yijian)!=""){
						$("textarea").val($.trim(data.yijian));
					}
					
					if (data.imgs) {
						var imgs=data.imgs;//.split(",");
//					if (imgs) {
						for (var i = 0; i < imgs.length; i++) {
							if (imgs[i]&&imgs[i]!="") {
								$("#showpingjia").append('<img src="../'+imgs[i]+'" onclick="javascript:evaluation.showImg(this)">');
							}
						}
//					}
					}
					$('#postEval').hide();
					$('.star>img').unbind("click");
					$("#scpz").hide();
					$("#pingjia").hide();
					$("#upimg").hide();
					$("#pjtitle,.box-subject-header").html("查看订单");
				}
			});
			if(!show){
				$('#postEval').unbind("click");
				$("#postEval").click(function(){
					pop_up_box.postWait();
					var params=window.location.href.split("?")[1];
					$.post("../orderTrack/postEval.do",{
						"orderNo":orderNo,
						"item_id":item_id,
						"com_id":com_id,
						"params":orders,
						"yijian":$("textarea").val(),
						"type":$("#type").val(),
						"imageUrl":evaluation.imageUrl,
						"spzl":$("#spzl").find(".startranslate").length,
						"fwtd":$("#fwtd").find(".startranslate").length,
						"wlsd":$("#wlsd").find(".startranslate").length
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							try {
								pop_up_box.showMsg("评论成功!",backlist);
							} catch (e) {
								pop_up_box.showMsg("评论成功!",function(){
									try {
										if(backlist){
											window.location.href="historicalPurchase.do";
										}
									} catch (e) {
										window.location.href="myorder.do";
									}
								});
							}
						} else {
							if (data.msg) {
								pop_up_box.showMsg("评论错误!" + data.msg);
							} else {
								pop_up_box.showMsg("评论错误!");
							}
						}
					});
				});
				$('.star>img').unbind("click");
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
			}
			if (is_weixin()) {
				$("#scpz").show();
				$("#pingjia").hide();
				weixinfileup.init();
				$('#scpz').unbind("click");
				$("#scpz").click(function(){
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							var evalimgpath="/temp/eval"+Math.random()+".jpg";
							$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":evalimgpath},function(data){
								if (data.success) {
									pop_up_box.showMsg("上传成功!",function(){
										evaluation.imageUrl=data.msg+","+evaluation.imageUrl;
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
		});
}
