/**
 * 判断是否是微信浏览器  
 * @returns true为微信浏览器,false为其它浏览器
 */
function is_weixin(){
	var ua = navigator.userAgent.toLowerCase();
	if(ua.match(/MicroMessenger/i)=="micromessenger") {
		return true;
 	} else {
		return false;
	}
}
var weixinShare={
		/**
		 * 
		 * @param title 分享标题
		 * @param desc 分享描述
		 * @param imgpath 分享图片路径
		 * @param 必须js引用
		 * http://res.wx.qq.com/open/js/jweixin-1.0.0.js
		 * ../pc/js/weixin/zepto.min.js
		 * ../pc/js/weixin/weixinShare.js
		 */
		init:function(title,desctxt,imgpath){
			if(!is_weixin()){
				return;
			}
			var timestamp = new Date().getTime();
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
						jsApiList : ["onMenuShareAppMessage","onMenuShareTimeline","onMenuShareQQ","onMenuShareQZone"]
					// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
					});
				} catch (e) {
				}
				wx.ready(function() {
					if(!imgpath||imgpath==""){
						if(document.getElementById("shareLogo")!=null){
							imgpath=document.getElementById("shareLogo").src;
						}else{
							if(document.getElementsByTagName("img")!=null){
								imgpath=document.getElementsByTagName("img")[0].src;
							}
						}
					}
					//分享产品送金币
					function fenxjinbi(){
						var item_id=$.trim(getQueryString("item_id"));
						if(item_id!=""){
							$.post("../client/saveJinbiInfo.do",{
								"type":"分享",
								"item_id":$.trim(getQueryString("item_id"))
							},function(data){
								if(data.success){
									pop_up_box.toast("分享成功金币已发放到您账户!", 1000);
								}
							});
						}
					}
					wx.onMenuShareAppMessage({
						title:title, // 分享标题
						desc: desctxt, // 分享描述
						link:  window.location.href, // 分享链接
						imgUrl: imgpath, // 分享图标
						type: 'link', // 分享类型,music、video或link，不填默认为link
						dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
						success: function () {
							// 用户确认分享后执行的回调函数
							fenxjinbi();
						},
						cancel: function () {
							// 用户取消分享后执行的回调函数
						}
					});
					wx.onMenuShareTimeline({
						title:title, // 分享标题
						link: window.location.href, // 分享链接
						imgUrl: imgpath, // 分享图标
						success: function () {
							// 用户确认分享后执行的回调函数
							fenxjinbi();
						},
						cancel: function () {
							// 用户取消分享后执行的回调函数
						}
					});
					wx.onMenuShareQQ({
					    title: title, // 分享标题
					    desc: desctxt, // 分享描述
					    link: window.location.href, // 分享链接
					    imgUrl:imgpath, // 分享图标
					    success: function () {
					       // 用户确认分享后执行的回调函数
					    	fenxjinbi();
					    },
					    cancel: function () {
					       // 用户取消分享后执行的回调函数
					    }
					});
					wx.onMenuShareQZone({
					    title:title, // 分享标题
					    desc:desctxt, // 分享描述
					    link:window.location.href, // 分享链接
					    imgUrl:imgpath, // 分享图标
					    success: function () { 
					       // 用户确认分享后执行的回调函数
					    	fenxjinbi();
					    },
					    cancel: function () { 
					        // 用户取消分享后执行的回调函数
					    }
					});
				});
			});
		}
}
