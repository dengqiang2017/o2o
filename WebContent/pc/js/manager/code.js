$(function(){
	weixinShare.init('邀请注册','邀请客户注册');
	function getQueryString(key) {
	    var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) {
	    	return unescape(r[2]); 
	    }
	    return null;
	}
	var com_id=getQueryString("com_id"); 
	if (!com_id) {
		com_id="";
	}else{
		$("#qrcode").parent().show();
		$("#qrcode").attr("src","../"+com_id+"/register.jpg");
		$("#qrcode").error(function(){
			$.get('../user/userRegisterQRCode.do',{
				"com_id":com_id,
				"width":300,
				"height":300,
				"image_width":90,
				"image_height":90
			},function(dataimg){
				if (dataimg.success) {
					$("#qrcode").attr("src",".."+dataimg.msg);  
				}
			});
		});
	}
});
