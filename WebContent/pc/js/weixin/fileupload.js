weixinfileup={
		/**
		 * 微信jsjdk上传图片初始化准备
		 */
		init:function(){
			var timestamp = new Date().getTime();
			pop_up_box.toast("初始化中...",500);
			$.get("../employee/getSignature.do", {
				"timestamp" : timestamp,
				"url" : window.location.href
			}, function(data) {
				try{
				wx.config({
					debug : false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
					appId : data.split(",")[2], // 必填，企业号的唯一标识，此处填写企业号corpid
					timestamp : data.split(",")[1], // 必填，生成签名的时间戳
					nonceStr : data.split(",")[3], // 必填，生成签名的随机串
					signature : data.split(",")[0],// 必填，签名，见附录1
					jsApiList : ["getLocation","chooseImage","uploadImage"]
				// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
				});
				} catch (e) {}
				wx.ready(function() {
					$("#weixinsign").click(function(){
						weixinfileup.chooseImage();
					});
					$("#uploadimg").click(function(){
						weixinfileup.uploadImage($("img").attr("src"));
					});
					// config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
					
				});
				wx.error(function(res) {
					// config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
				});
			});  
		},chooseImage:function(t,func){// 调用照相机
			wx.chooseImage({
			count:1, // 默认9
			sizeType: ['compressed'], // 可以指定是原图还是压缩图，默认二者都有'original',
			sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有 '',
			success: function (res) {
				var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
				if (func) {
					func(localIds);
				}else{
					$(t).parnet().find("img").attr("src",localIds);
				} 
				//weixinfileup.uploadImage($(t).find("img").attr("src"));
			},error:function(data){
				alert(data);
			}
		});
		},uploadImage:function(localIds,func){
			var localId = localIds[0];
            //解决IOS无法上传的坑
            if (localId.indexOf("wxlocalresource") != -1) {
                localId = localId.replace("wxlocalresource", "wxLocalResource");
            }
			wx.uploadImage({
				localId: localId, // 需要上传的图片的本地ID，由chooseImage接口获得
				isShowProgressTips: 1,// 默认为1，显示进度提示
				success: function (res) { 
					var serverId = res.serverId; // 返回图片的服务器端ID
					if(func){
						func(serverId);
					}
				}
			});
		},
		/**
		 * 使用微信jsjdk方式上传图片
		 * @param t this
		 * @param imgPath 上传图片服务器存放路径
		 * @param img 回显页面对象
		 * @param func 上传完成回调函数
		 */
		imguploadToWeixin:function(t,imgPath,img,func){
			weixinfileup.chooseImage(t,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":imgPath},function(data){
						if (data.success) {
							pop_up_box.toast("上传成功!", 500);
							if(func){
								func();
							}
						} else {
							if(img){
								img.remove();
							}
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
					
				});
//				if(img&&img.length>0){
//					img.attr("src",imgurl);
//				}
			});
		}
}


	
	