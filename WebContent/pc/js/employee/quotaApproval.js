$(function(){
	var seeds_id=window.location.href.split("?")[1].split("=")[1];
	var file_icon_group=$(".file-icon-group");
	pop_up_box.loadWait();
	$.get("getOAInfo.do",{"seeds_id":seeds_id},function(data){
		pop_up_box.loadWaitClose();
		if(data.info.OA_who){
			$("#OA_who").append(data.info.OA_who);
		}else{
			$("#OA_who").append(data.info.clerk_name);
		}
		$("#accountStatement").attr("href","../report/accountStatement.do?clientId="+data.customer_id);
		$("#OA_what").append(data.info.OA_what);
		$("#content").html(data.info.content);
		$("#approvaler").val(data.info.approvaler);
		$("#ivt_oper_listing").val(data.info.ivt_oper_listing);
		$("#store_date").append(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		if (data.info.isfile) {
			$("#sqfujian .glyphicon-search").click({"OA_who":$.trim(data.info.approvaler)},function(event){
				 var t=$(this);
				 $.get("../pc/modalFile.html",function(data){
					 $("body").append(data);
					 modalFile.init(event.data.OA_who);
				 });
			});
		}else{
			$("#sqfujian").remove();
		}
		if (data.ioupath&&data.ioupath.length>5) {
			$("#iou").show();
			$("#ioupath").attr("href",data.ioupath);
		}
		$(".box-body").html("<h5>审批记录</h5>");
		 $.each(data.list,function(i,n){
			var item= spjil(n);
			 $(".box-body").append(item); 
			 $(item).find(".btn-primary").click({"url":$.trim(n.url)},function(event){
				 window.open(event.data.url);
			 });
		 });
//		 $("#fujian").bind("click",function(){
//			 var t=$(this);
//			 $.get("../pc/modalFile.html",function(data){
//				 $("body").append(data);
//				 var approvaler=t.parent().find("input").val();
//				 modalFile.init(approvaler);
//			 });
//		 });
	});
	$("#filelaoddiv .file-icon-group").hide();
	$("#saveSp").click(function(){
		var spyij=$(".input-sm").val();
		pop_up_box.postWait();
		$.post("saveOpinion.do",{
			"OA_what":$.trim($("#OA_what").html()),
			"content":$.trim($("#content").html()),
			"spyij":spyij,
			"spyijcontent":$("#spyij").val(),
			"ivt_oper_listing":$("#ivt_oper_listing").val()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				window.location.href="myOA.do";
			}else{
				pop_up_box.showMsg("提交失败:"+data.msg);
			}
		});
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

