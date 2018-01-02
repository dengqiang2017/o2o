var chatid=window.location.href.split("?")[1];
var chatinter;
var sendchatmsg={
		init:function(){
			$.get("../user/chatGet.do",{"chatid":chatid},function(data){
				 if (data.name||data.msg.indexOf("ok")>=0) {
					var info=data;
					$(".info").html("在线咨询");
					$("#chatid").val(data.chatid);
					chatid=data.chatid;
					avatar=data.avatar;
					username=data.username;
					chatinter=setInterval(function(){
						$.get("../user/getWeixinMsg.do",{
							"chatid":chatid
						},function(data){
							if(data){
								$(".message-box>div:eq(1)").html("");
								loadMsg(data);
							}
						});
					}, 2000);
				}else{
					alert("有未关注的客服员工!");
				}
			});
			$(".head-logo").click(function(){
				window.location.href="../user/chatSet.do?chatid="+chatid;
			}); 
			var backurl=getCookieval("backurl");
			if (backurl) {
				$(".breadcrumb").find("a:eq(0)").click(function(){
					window.location.href=backurl;
					return false;
				});
				$(".header-title").find("a").click(function(){
					window.location.href=backurl;
					return false;
				});
			}
			var avatar="";
			var username="";
			function loadMsg(msg){
				var now = new Date();
				var nowStr = now.Format("yyyy-MM-dd"); 
				$(".message-box>div:eq(1)").append("<p>"+nowStr+"</p>");
				if (msg) {
					$.each(msg,function(i,n){
						if (avatar==n.weixinimg) {
							$(".message-box>div:eq(1)").append(myMsg(n));
						}else{
							$(".message-box>div:eq(1)").append(leftMsg(n));
						}
					});
					$(".message-box").find("img:eq(0)").error(function(){
						$(this).parent().append($(this).attr("src"));
					});
				}
			}
			function leftMsg(n){
				var Content="";
				if (n.MsgType=="text") {
					Content=n.Content;
				}else{
					Content="<img style='width: 100px;height: 100px;' src='"+n.PicUrl+"'>";
				}
				var html="<div class='his-msg'><div class='his-head'><img src='"+n.weixinimg+"'>"+
				"</div><div class='his-content'>"+Content+"</div></div>";
				return html;
			}
			function myMsg(n){
				var Content="";
				if (n.MsgType=="text") {
					Content=n.Content;
				}else{
					Content="<img style='width: 100px;height: 100px;' src='"+n.PicUrl+"'>";
				}
				var html="<div class='my-msg'><div class='my-head'><img src='"+n.weixinimg+"'>";
				html+="</div><div class='my-content'><span>"+Content+"</span></div></div>";
				return html;
			}
			$("#historyDate").val("");
			$(".view-history").click(function(){
				var historyDate=$("#historyDate").val();
				if (historyDate=="") {
					var now = new Date();
					var nowStr = now.Format("yyyy-MM-dd"); 
					historyDate=nowStr;
				}
				$.get("../user/getChatHistory.do",{
					"chatid":chatid,
					"historyDate":historyDate
				},function(data){
					$("#historyDate").val(data[0]);
					if (data.length>1) {
						$(".view-history").after("<p>"+$("#historyDate").val()+"</p>");
						loadHistoryMsg($(".view-history"),data);
					}else{
//						$(".view-history").hide();
					}
				});
			});
			function loadHistoryMsg(t,msg){
				if (msg) {
					$.each(msg,function(i,n){
						if (i>1) {
							if (avatar==n.weixinimg) {
								t.after(myMsg(n));
							}else{
								t.after(leftMsg(n));
							}
						}
					});
					$(".message-box").find("img:eq(0)").error(function(){
						$(this).parent().append($(this).attr("src"));
					});
				}
			}

			$("textarea").bind("input propertychange blur",function(){
				var val=$.trim($(this).val());
				if (val!="") {
					$(".send").show();
				}else{
					$(".send").hide();
				}
			});
			$(".send").click(function(){
				var content=$.trim($("textarea").val());
				if (content!="") {
					var html="<div class='my-msg'><div class='my-head'><img src='"+avatar+"'>";
					html+="</div><div class='my-content'><span>"+content+"</span></div></div>"
					$(".message-box>div:eq(1)").append(html);
					$(html).find("img").error(function(){
						$(this).parent().append(username);				
					});
					$.post("../user/beginSendChatMSg.do",{
						"id":chatid,
						"content":content
					},function(data){
						$("textarea").val("");
					});
				}
			});
			jsconfig.init();
			$(".tools04").click(function(){
				$("#startRecord").show();
				$("textarea").hide();
				$(".tools04").hide();
				$(".tools01").show();
			});
			$(".tools02").click(function(){
				if($(".write-area").css("display")=="none"){
					$(".write-area").show();
				}else{
					$(".write-area").hide();
				}
			});
			$(".tools01").click(function(){
				$("#startRecord").hide();
				$("textarea").show();
				$(".tools04").show();
				$(".tools01").hide();
			})
			wx.ready(function() {
				pop_up_box.loadWaitClose();
				$("#startRecord").click(function(){
					wx.startRecord();
					wx.onVoiceRecordEnd({
					    // 录音时间超过一分钟没有停止的时候会执行 complete 回调
					    complete: function (res) {
					        var localId = res.localId;
					        $("#startRecord").show();
					        $("#stopRecord").hide();
					        uploadVoice(localId);
					    }
					});
					$("#startRecord").hide();
					$("#stopRecord").show();
				});
				$("#stopRecord").click(function(){
					$("#startRecord").show();
					$("#stopRecord").hide();
					wx.stopRecord({
					    success: function (res) {
					        var localId = res.localId;
					        uploadVoice(localId);
					    }
					});
				});
				$(".talk-icon04").click(function(){
					pop_up_box.dataHandling("获取地理位置中...");
					loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
					wx.getLocation({
						type:"gcj02",// 'wgs84', //
										// 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
						success : function(res) {
							var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
							var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
							var speed = res.speed; // 速度，以米/每秒计
							accuracy = res.accuracy; // 位置精度
							pop_up_box.loadWaitClose();
							codeLatLng(latitude, longitude);
						},
						cancel : function(res) {
							alert('用户拒绝授权获取地理位置');
						}
					});
				});
				$(".talk-icon01").click(function(){
					wx.chooseImage({
						count:1, // 默认9
						sizeType: ['compressed'], // 可以指定是原图还是压缩图，默认二者都有'original',
						sourceType: ['album'], // 可以指定来源是相册还是相机，默认二者都有 'album',camera
						success: function (res) {
							var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
							$("img").attr("src",localIds);
							uploadImage($("img").attr("src"));
						},error:function(data){
							alert(data);
						}
					});
				});
				$(".talk-icon02").click(function(){
					wx.chooseImage({
						count:1, // 默认9
						sizeType: ['compressed'], // 可以指定是原图还是压缩图，默认二者都有'original',
						sourceType: ['camera'], // 可以指定来源是相册还是相机，默认二者都有 'album',camera
						success: function (res) {
							var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
							$("img").attr("src",localIds);
							uploadImage($("img").attr("src"));
						},error:function(data){
							alert(data);
						}
					});
				});
				function uploadImage(localIds){
					wx.uploadImage({
						localId: localIds, // 需要上传的图片的本地ID，由chooseImage接口获得
						isShowProgressTips: 1,// 默认为1，显示进度提示
						success: function (res) {
							var serverId = res.serverId; // 返回图片的服务器端ID
							var html="<div class='my-msg'><div class='my-head'><img src='"+avatar+"'>";
							html+="</div><div class='my-content'><span><img style='width: 100px;height: 100px;' src='"+localIds+"'></span></div></div>"
							$(".message-box>div:eq(1)").append(html);
							$(html).find("img:eq(0)").error(function(){
								$(this).parent().append(username);				
							});
							$.post("../user/beginSendChatMSg.do",{
								"id":chatid,
								"type":"image",
								"content":serverId
							},function(data){
								$("textarea").val("");
							});
						}
					});
				}
				function uploadVoice(localId){
					wx.translateVoice({
					   localId: localId, // 需要识别的音频的本地Id，由录音相关接口获得
					    isShowProgressTips: 1, // 默认为1，显示进度提示
					    success: function (res) {
					        $("textarea").val(res.translateResult);
							$("textarea").show();
							$(".tools04").show();
							$(".send").show();
					    }
					}); 
				}
				
				$(".talk-icon04").click(function(){
					
				});
				
			});	

		}
}
function playVoice(localId,serverId){alert(localId+","+serverId);
	wx.playVoice({
		serverId:serverId,
	    localId:localId // 需要播放的音频的本地ID，由stopRecord接口获得
	});
}
var jsconfig={
		init:function(){
			pop_up_box.dataHandling("初始化中...");
			loadtime=window.setTimeout("pop_up_box.loadWaitClose()",5000);
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
					jsApiList : ["getLocation","openLocation","chooseImage",
					             "uploadImage","playVoice","startRecord","stopRecord"
					             ,"uploadVoice","onVoiceRecordEnd","translateVoice"]
				// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
				});
				} catch (e) {
					pop_up_box.loadWaitClose(); 
				}
			});
		}
}
var accuracy="";
var address="";
var geocoder,map, marker = null;
var init = function() {
	sendchatmsg.init();
    var center = new soso.maps.LatLng(30.6256, 104.04276);
    map = new soso.maps.Map(document.getElementById('container'),{
        center: center,
        zoomLevel: 13
    });
    geocoder = new soso.maps.Geocoder();
} 
function codeLatLng(lat,lng) {
    var latLng = new soso.maps.LatLng(lat, lng);
    var info = new soso.maps.InfoWindow({map: map});
    geocoder.geocode({'location': latLng}, function(results, status) {
        if (status == soso.maps.GeocoderStatus.OK) {
            map.setCenter(results.location);
            if (marker != null) {
                marker.setMap(null);
            }
            marker = new soso.maps.Marker({
                map: map,
                position:results.location
            });
            address=results.address;
            $("textarea").val("地址:"+address);
            $(".send").show();
            $(".write-area").hide();
			$("textarea").show();
			$(".tools01").hide();
            wx.openLocation({
                latitude: latitude, // 纬度，浮点数，范围为90 ~ -90
                longitude: longitude, // 经度，浮点数，范围为180 ~ -180。
                name: '牵引软件', // 位置名
                address: address, // 地址详情说明
                scale: 28, // 地图缩放级别,整形值,范围从1~28。默认为最大
                infoUrl: '' // 在查看位置界面底部显示的超链接,可点击跳转
            });
            soso.maps.Event.addListener(marker, 'click', function() {
                info.open('<div style="width:280px;height:100px;">'+
                    results.address+'</div>',
                    marker
                );
            });
        } else {
            alert("检索没有结果，原因: " + status);
        }
    });
}