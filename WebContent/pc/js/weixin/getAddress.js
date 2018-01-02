var loadtime;
var address="";
var accuracy="";
var getAddress={
	init:function(){
		var timestamp = new Date().getTime();
//		pop_up_box.dataHandling("初始化中...");
//		loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
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
		wx.ready(function() {
//			pop_up_box.loadWaitClose();
			pop_up_box.dataHandling("获取地理位置中...");
			loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
			try{
			wx.getLocation({
				type:"gcj02",// 'wgs84', //
								// 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
				success : function(res) {
					var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
					var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
					var speed = res.speed; // 速度，以米/每秒计
					accuracy = res.accuracy; // 位置精度
					codeLatLng(latitude, longitude);
					pop_up_box.loadWaitClose();
					
				},
				cancel : function(res) {
					alert('用户拒绝授权获取地理位置');
				}
			});
			
			}catch (e) {
				pop_up_box.loadWaitClose();
			}
			// config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
		});
		wx.error(function(res) {
			// config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
		});
	});  
	}
}

var geocoder,map, marker = null;
var init = function() {
    var center = new qq.maps.LatLng(30.6256, 104.04276);
    map = new qq.maps.Map(document.getElementById('container'),{
        center: center,
        zoomLevel: 13
    });
    geocoder = new qq.maps.Geocoder();
}
if(is_weixin()){
	init();
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
        var address=result.detail.address;
        $("#address").html("当前地址:"+address);
        $.get("../customer/getComIdByAddress.do",{
        	"address":address
        },function(data){
        	$("select").val(data.com_id);
        });
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
