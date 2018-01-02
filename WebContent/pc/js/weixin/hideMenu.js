var hideMenu={
		init:function(){
			$.get("/employee/getSignature.do", {
				"timeStamp" : new Date().getTime()+"",
				"url" : window.location.href
			}, function(data) {
				try{
					wx.config({
						debug : false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
						appId : data.split(",")[2], // 必填，企业号的唯一标识，此处填写企业号corpid
						timestamp : data.split(",")[1], // 必填，生成签名的时间戳
						nonceStr : data.split(",")[3], // 必填，生成签名的随机串
						signature : data.split(",")[0],// 必填，签名，见附录1
						jsApiList : ["hideOptionMenu","hideAllNonBaseMenuItem","showMenuItems"]
					// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
					});
				} catch (e) {
				}
				wx.ready(function() {
// 		wx.hideOptionMenu();
					wx.hideAllNonBaseMenuItem();
// 		wx.showMenuItems({
// 		    menuList: ["menuItem:refresh","menuItem:setFont"] // 要显示的菜单项，所有menu项见附录3
// 		});
				});
			});
		}
}