var getlatIndex=0;
/**
 * 调用在线咨询
 * @param name 电工名称
 * @param dian_customer_id 电工id
 */
function clientAndElectricianChat(name,dian_customer_id){
	pop_up_box.loadWait();
	$.get("clientAndElectricianChat.do",{
		"name":name,
		"dian_customer_id":dian_customer_id,
		"orderNo":$("#orderNo").val()
	},function(data){
		pop_up_box.loadWaitClose();
		$("#electr").hide();
		$("#clientLiaotian").html(data);
		$("#clientLiaotian").show();
//		clearInterval(getlatIndex);
		$("#autoElec").removeClass("pro-checked");
		clientAndEle.init();
		if($.trim($("#chatname").val())!=""){
			$('a[data-title="title"]').html($("#chatname").val());
		}else{
			$('a[data-title="title"]').html("在线咨询");
		}
	});
}
/**
 * 确认预约电工
 * @param name 电工名称
 * @param dian_customer_id 电工id
 * @param weixinID
 * @param phone
 */
function confirmSelectEval(name,dian_customer_id,weixinID,phone){
	var movtel=$.trim($("#movtel").val());
	var lxr=$.trim($("#lxr").val());
	var address=$.trim($("#address").val());
	if(movtel==""){
		pop_up_box.showMsg("请输入联系人电话!");
		$("#movtel").focus();
	}else if(lxr==""){
		pop_up_box.showMsg("请输入联系人姓名!");
		$("#lxr").focus();
	}else if(address==""){
		pop_up_box.showMsg("请输入安装地址!");
		$("#address").focus();
	}else{
		if(confirm("是否确认预约电工:"+name)){
			var confirm_je=$("#confirm_je").html();
			if(confirm_je==""){
				confirm_je="0";
			}
			$.post("confirmSelectEval.do",{
				"name":name,
				"dian_customer_id":dian_customer_id,
				"weixinID":weixinID,
				"phone":phone,
				"ivt_oper_listing":$("#orderNo").val(),//订单编号
				"movtel":movtel,//客户联系人电话
				"lxr":$("#lxr").val(),//联系人
				"confirm_je":confirm_je,//安装金额
				"address":$("#address").val()//安装地址
			},function(data){
				if (data.success) {
					pop_up_box.showMsg("预约成功!",function(){
						backlist();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}
	}
		
}
//////////////////////////////////
var geocoder,map, marker = null;
var init = function(latlng,data) {
	var center = new qq.maps.LatLng(30.694260,104.01430);  
	if(latlng&&latlng.lat){
		center = new qq.maps.LatLng(latlng.lat,latlng.lng);
	}	
	  map = new qq.maps.Map(document.getElementById("container"), {
	    center: center,
	    zoom: 14
	});  
	var infoWin = new qq.maps.InfoWindow({
	    map: map  
	}); 
	infoWin.open();
//	infoWin.setContent('客户名称');
//	infoWin.setPosition(map.getCenter());
	var anchor = new qq.maps.Point(6, 6),
	size = new qq.maps.Size(24, 24),
	origin = new qq.maps.Point(0, 0),
	icon = new qq.maps.MarkerImage('../pc/images/center.gif', size, origin, anchor);
	  marker = new qq.maps.Marker({
	    icon: icon,
	    map: map,
	    position:map.getCenter()});
	qq.maps.event.addListener(marker, 'click', function() {
	    infoWin.open(); 
	}); 
	  if(data&&data.length>0){
		for (var i = 0; i < data.length; i++) {
			latlngs=new qq.maps.LatLng(parseFloat(data[i].Lat),parseFloat(data[i].lng));
			var name=$.trim(data[i].corp_sim_name);
			if(data[i].customer_id){
				var dianinfo=name
			+"<a class='btn btn-primary btn-sm' href='tel:"+data[i].phone+"' style='margin-left:10px'>打电话</a>" +
//				+"<button class='btn btn-primary btn-sm' onclick='clientAndElectricianChat(\""+name+"\",\""+data[i].customer_id+"\")' style='margin-left:10px'>咨询</button>" +
				"<button class='btn btn-primary btn-sm' onclick='confirmSelectEval(\""+name+"\",\""+data[i].customer_id+"\",\""+data[i].weixinID+"\",\""+data[i].phone+"\")' " +
				" style='margin-left:10px'>确认预约</button>";
				(function(n){
					var info = new qq.maps.InfoWindow({
						map: map  
					});
					var marker = new qq.maps.Marker({
						position: latlngs, 
						animation:qq.maps.MarkerAnimation.DROP,
						map: map 
					}); 
					info.open(); 
					info.setContent(dianinfo); 
					info.setPosition(latlngs); 
					qq.maps.event.addListener(marker, 'click', function() {
						info.open(); 
					}); 
				})(i); 
			}
		}
	  } 
	}
///////////////////////////////
	$("#autoElec").click(function(){
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
		}
	});
	$("#dgsfxz").click(function(){
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
			$("#yqdgxg").show();
			$("#dgsfxz").unbind("click");
		}
	});
	var latlng={};
	$("#yqdg").click(function(){
	$.post("inviteEval.do",{
		"orderNo":$("#orderNo").val(),
		"type":0,
		"lat":latlng.lat,
		"lng":latlng.lng
	},function(data){
		if(data){
			pop_up_box.showMsg("已经发出邀请请等待附近电工回应!");
			getlatIndex=setInterval(function(){
				var b=$("#autoElec").hasClass("pro-checked");
				if(b){
					$.get("getLatlng.do",function(data){
						init(latlng,data);
					});
				}
			}, 5000);
			}
		});
	});
	$("#refreshElec").click(function(){
		$.get("getLatlng.do",function(data){
			init(latlng,data);
		});
	});
	$("#showMingxi").click(function(){
		pop_up_box.loadWait();
		$.get("../pc/saiyu/diangongpay.html",function(data){
			pop_up_box.loadWaitClose();
//			$('a[data-title="title"]').html("电工安装费明细");
			$("#itempage").hide();
			$("#backelec").html(data);
			diangongpay.init();
		});
	});
	function backElec(){
		$("#itempage").show();
		$("#backelec").html("");
		$('a[data-title="title"]').html("实时预约电工");
	}
/////////////////////////////
var timestamp = new Date().getTime();
//    pop_up_box.dataHandling("初始化中...");
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
//	   pop_up_box.dataHandling("获取地理位置中...");
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
				  latlng.lat=latitude;
				  latlng.lng=longitude;
			   },
			   cancel : function(res) {
				   alert('用户拒绝授权获取地理位置');
			   }
		   });
	   }catch (e) {
//		   pop_up_box.loadWaitClose();
	   }
   });
   wx.error(function(res) {
	   // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
   });
});  
function backelec(){
	$("#itempage").show();
	$("#backelec").html("");
}
////////////////////////////////////////
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
        $("#address").val(address);
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