if(is_weixin()){
	$("#scxq").show();
	$("#upload-btn").hide();
	weixinfileup.init();
	$("#scxq").click(function(){
		var myDate=new Date().getTime();
		var imgPath="/temp/"+com_id+"/xq/"+myDate+".jpg";
		var imgitem=$('<div class="upload-img"><img></div>');
 		$("#imglist").append(imgitem);
		weixinfileup.imguploadToWeixin(this, imgPath, imgitem.find("img"),function(){
			imgitem.find("img").attr("src",".."+imgPath);
			if($("#imglist img").length==5){
				$("#scxq").hide();
				$("#upload-btn").hide();	
			}
		});
	});
}else{
	$("#scxq").hide();
	$("#upload-btn").show();
}
 $(".btn-style").click(function(){
        var name=$.trim($(".lybox input:eq(0)").val());
        var phone=$.trim($(".lybox input:eq(1)").val());
        var miaos=$.trim($(".lybox textarea").val());
        if(name==""){
            pop_up_box.showMsg("请输入姓名!",function(){
                $(".lybox input:eq(0)").focus();
            });
        }else if(phone==""){
            pop_up_box.showMsg("请输入手机号!",function(){
                $(".lybox input:eq(1)").focus();
            });
        }else if(miaos==""){
            pop_up_box.showMsg("请填写简要说明!",function(){
                $(".lybox textarea").focus();
            });
        }else{
        	var imgs=$("#imglist img");
        	var imgUrl="";
        	if (imgs) {
	        	for (var i = 0; i < imgs.length; i++) {
					imgUrl=$(imgs[i]).attr("src")+","+imgUrl;
				}
			}
        	pop_up_box.postWait();
            $.post("../login/sendmail.do",{
            	"imgUrl":imgUrl,
                "com_id":com_id,//特种水产
                "subject":"客户留言",
                "text":"<h4>客户姓名:"+name+"<br>联系方式:"+phone+"<br>说明:"+miaos+"<br></h4><div style='color:red;'>该邮件为系统通知邮件,请勿直接回复,<br>如果需要回复请按照邮件内容中联系方式进行回复</div>"
            },function(data){
            	pop_up_box.loadWaitClose();
                pop_up_box.showMsg("提交成功,当前页面将自动关闭!",function(){
                $(".lybox input").val("");
                $(".lybox textarea").val("");
                $("#imglist").html("");
                if(is_weixin()){
                	WeixinJSBridge.call('closeWindow');
                }else{
                	window.close();
                }
                }); 
            });
        }
    });
 function imgUpload(t){
		var myDate=new Date().getTime();
		var imgPath="/temp/"+com_id+"/xq/"+myDate+".jpg";
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
	 		if($("#imglist img").length==5){
				$("#scxq").hide();
				$("#upload-btn").hide();	
			}
		});
	}