function is_weixin(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			return true;
	 	} else {
			return false;
		}
}
var address="";
var accuracy="";
var img_url="";
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":10
	},t,function(imgUrl){
		img_url=imgUrl;
		pop_up_box.loadWaitClose();
		$.get("getImageInfo.do",{
			"imgUrl":imgUrl
		},function(data){
			$("#imginfo").html("");
			if (data.Original) {
				$("#imginfo").html("<p>照片信息:</p>");
				$("#imginfo").append("<p>"+data.Make+" "+data.Model+"</p>");
				$("#imginfo").append("<p>拍摄时间:"+data.Original+"</p>");
			}else{
//				pop_up_box.showMsg("上传失败,请重新上传!");
			}
		});
	});
}

var loadtime;
$(function(){
		$("#sxin").click(function(){
			window.location.href="sgin2.do?ver="+Math.random();
		});
	/////////////////////////////
	var timestamp = new Date().getTime();
	var latitude;
	var longitude;
		pop_up_box.dataHandling("初始化中...");
		loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
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
			jsApiList : ["getLocation","openLocation","chooseImage","uploadImage"]
		// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		});
		} catch (e) {
			pop_up_box.loadWaitClose();
		}
		$("#txun").click(function(){
	    	   window.location.href="http://apis.map.qq.com/tools/locpicker?search=1&type=0&backurl=http://www.my-tw.com:8080/o2o/employee/sign2.do&key=KDPBZ-MLJCV-A4TP2-UF7RY-NEU2E-MDF34&referer=O2O智能营销平台";
	       });
		wx.ready(function() {
			pop_up_box.loadWaitClose();
			pop_up_box.dataHandling("获取地理位置中...");
			loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
			try{
			wx.getLocation({
				type:"gcj02",// 'wgs84', //
								// 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
				success : function(res) {
					latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
					longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
					var speed = res.speed; // 速度，以米/每秒计
					accuracy = res.accuracy; // 位置精度
					codeLatLng(latitude, longitude);
					pop_up_box.loadWaitClose();
					document.querySelector('#openLocation').onclick = function () {
			            wx.openLocation({
			                latitude: latitude, // 纬度，浮点数，范围为90 ~ -90
			                longitude: longitude, // 经度，浮点数，范围为180 ~ -180。
			                name: '牵引软件', // 位置名
			                address: address, // 地址详情说明
			                scale: 28, // 地图缩放级别,整形值,范围从1~28。默认为最大
			                infoUrl: '' // 在查看位置界面底部显示的超链接,可点击跳转
			            });
			       };
				},
				cancel : function(res) {
					alert('用户拒绝授权获取地理位置');
				}
			});
			}catch (e) {
				pop_up_box.loadWaitClose();
			}
		});
		wx.error(function(res) {
			// config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
		});
	});
	////////////////////////////////////////
	$("#qiandao").click(function(){
		var imginfo=$.trim($("#imginfo").text());
		if (imginfo=="") {
			pop_up_box.showMsg("上传图片没有获取到拍摄时间等信息,不能进行签到!请上传手机照相机的原始图片!");
			return;
		}
		pop_up_box.dataHandling("生成签到数据...");
		$.get("../employee/weixinSign.do",{
			"imgUrl":img_url,
			"memo":$("textarea").val(),
			"latitude": latitude,  
            "longitude": longitude, 
			"address":address+","+$("#imginfo").text()
		},function(data){
			pop_up_box.loadWaitClose();
			if(data.success){
				if (data.msg) {
					alert("签到成功!"+data.msg);
				}else{
					alert("签到成功!");
				}
				window.location.href="../employee.do";
			}else{
				if (data.msg) {
					alert("签到失败!"+data.msg);
				}else{
					alert("签到失败!");
				}
			}
		});
	});
});
var geocoder,map, marker = null;
var init = function() {
    var center = new qq.maps.LatLng(30.6256, 104.04276);
    map = new qq.maps.Map(document.getElementById('container'),{
        center: center,
        zoomLevel: 16,
        zoom: 16
    });
    geocoder = new qq.maps.Geocoder();
} 
function codeLatLng(lat,lng) {
    //获取输入框的经纬度
    var latLng = new qq.maps.LatLng(lat, lng);
    //对指定经纬度进行解析
    geocoder.getAddress(latLng);
    //设置服务请求成功的回调函数
    geocoder.setComplete(function(result) {
        map.setCenter(result.detail.location);
        var marker = new qq.maps.Marker({
            map: map,
            position: result.detail.location
        });
        //点击Marker会弹出反查结果
        var info = new qq.maps.InfoWindow({
            map: map
        });
        address=result.detail.address;
        $("#address").html(address);
        qq.maps.event.addListener(marker, 'click', function() {
            info.open();
            info.setContent('<div style="width:280px;height:100px;">' +
                result.detail.address + '</div>');
            info.setPosition(result.detail.location);
        });
    });
    //若服务请求失败，则运行以下函数
    geocoder.setError(function() {
        alert("出错了，请输入正确的经纬度！");
    });

}
