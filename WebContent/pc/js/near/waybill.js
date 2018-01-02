 $(function(){
    $(".header-back").click(function(){
    	if(common.isWeixin()){
    		WeixinJSBridge.call('closeWindow');
    	}else{
    		window.close();
    	}
    });
    if($.trim($("#Status_OutStore").html())=="库管备货"){
    	$(".btn_style").show();
    }else{
    	$(".btn_style").hide();
    }
    var processName=common.decode(common.getQueryString("processName"));
    var seeds_id=common.getQueryString("seeds_id");
    var com_id=common.getQueryString("com_id");
    if(!seeds_id){
    	pop_up_box.showMsg("打开错误:缺少必须参数!");
    	return;
    }
    $.get("../orderTrack/getDriveOrderInfo.do",{
    	"processName":processName,
    	"seeds_id":seeds_id,
    	"com_id":com_id
    },function(data){
    	if(data&&data.length>0){
    		$.each(data,function(i,n){
    			var item=$($("#item").html());
    			$("#list").append(item);
    			item.find("#cmemo").html(n.c_memo);
    			item.find("#date").html(n.tihuodate);
    			if (n.FHDZ) {
					var lxs=n.FHDZ.split(";");
					if(lxs.length>=3){
						item.find("#shlxr").html(lxs[0]);
						item.find("#tel_no").html(lxs[1]);
						if (common.isPC()) {
							item.find("#tel_no").attr("href:","tel:"+lxs[1]);
						}
						item.find("#tel_no").prev().show();
						item.find("#shdz").html(lxs[2]);
						if(lxs.length>=4){
							item.find("#shdz").html(lxs[2]+";"+lxs[3]+",请凭出库单收款");
						}
					}else{
						item.find("#shlxr").html(n.corp_reps);
						item.find("#tel_no").html(n.movtel);
						if (common.isPC()) {
							item.find("#tel_no").attr("href:","tel:"+n.movtel);
						}
						item.find("#shdz").html(n.FHDZ);
					}
				}
    		});
    	}
    });
	var xiaoxi=0;
	function callneiqing(url){
		if(xiaoxi==0){
		xiaoxi=1;
		pop_up_box.loadWait();
		$.get("../user/noticeNeiqing.do",{
			"seeds_id":seeds_id,
			"headship":"内勤",
			"processName":"库管备货",
			"title":"提前通知库管备货",
			"description":""
			},function(data){
			pop_up_box.loadWaitClose();
			pop_up_box.toast("已发送微信消息!", 500);
			window.location.href=url;
		});
		}
	}
	$("#qrsh").hide();
	$("#qrsh").click(function(){
		if (confirm("是否确认用户已收货,并通知发货管理员!")) {
			pop_up_box.postWait();
			$.get("noticeShippingManager.do",{
				"seeds_id":seeds_id,
				"type":"已发货"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("提交成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}
	});
	/////////////////////////
	var weixin=0;///用于在保存图片的时候判断上传类型
	if (is_weixin()) {
		$("#scpz").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scpz").unbind("click");
		$("#scpz").click(function(){
			weixin=1;
			var date=new Date();
			var nowStr = date.Format("yyyy-MM-dd hh:mm:ss");
			var com_id=$.trim($("#com_id").html());
			var imgPath="/"+com_id+"/orderHistory/"+common.getQueryString("seeds_id")+"/"+date.getTime()+".jpg";
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":imgPath},function(data){
						if (data.success) {
							pop_up_box.showMsg("上传成功!");
							$("#imgList").append("<img src='"+imgPath+"'>");
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
 function fileLoad(t){
		var date=new Date();
		var nowStr = date.Format("yyyy-MM-dd hh:mm:ss");
		var com_id=$.trim($("#com_id").html());
		var imgPath="/"+com_id+"/orderHistory/"+common.getQueryString("seeds_id")+"/"+date.getTime()+".jpg";
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
			"msgId":"",
			"fileId":"imgFile",
			"msg":"",
			"fid":"",
			"uploadFileSize":5
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			$("#imgList").append("<img src='"+imgPath+"'>");
		});
	}