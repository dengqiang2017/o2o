$(function(){
	function loadSelect(index){
		$(".qh>ul>li").eq(index).show();
		if($(".body2").eq(index).find("select:eq(0)").html()==""){
			var type=$(".body01_top .active").find("span").html();
			var type_id=$(".box .active2").find("span").html();
			$.get("../pre/getProductByClassName.do",{
				"type":type,
				"type_id":type_id,
			},function(data){
				for (var i = 0; i < data.length; i++) {//內杂猪-仔猪0-3
					var op="<option value='"+data[i].item_id+"' data-zxts='"+numformat2(data[i].AZTS_free)+"'>"+data[i].item_spec+"</option>";
					$(".body2").eq(index).find("select:eq(0)").append(op);
				}
				$(".body2").eq(index).find(".recommend>span").html(numformat2(data[0].AZTS_free));
				$(".body2").eq(index).find("select:eq(0)").change(function(){
					var zxts=$(this).find("option:selected").attr("data-zxts");
					$(this).parents(".body2").find(".recommend>span").html(zxts);
				});
			});
		}
	}
//	$(".address,.latlng").show();
	function showTab(){
		var topindex=$('.body01_top>ul>li').index($(".body01_top .active"));
		var box2index=$('.box>ul>li').index($(".box .active2"));
		$(".qh>ul>li").hide();
		if(topindex==0){
			if(box2index==0){
				loadSelect(0);
			}else{
				loadSelect(1);
			}
		}else if(topindex==1){
			if(box2index==0){
				loadSelect(2);
			}else{
				loadSelect(3);
			}
		}else{
			if(box2index==0){
				loadSelect(4);
			}else{
				loadSelect(5);
			}
		}
	}
	$('.body01_top>ul>li').click(function(){
		$('.body01_top>ul>li').removeClass('active');
		$(this).addClass('active');
	});
	$('.box>ul>li').click(function(){
		$('.box>ul>li').removeClass('active2');
		$(this).addClass('active2');
	});
	$('.body03>.pull-right').click(function(){
		$('.pos').css({'opacity':'1'})
	});
	$('.box2>.box2top').click(function(){
		var i = $('.box2>.box2top').index(this);
		$('.box2>.box2bottom').eq(i).toggle();
		if($('.box2top>.a2').eq(i).hasClass('a22')){
			$('.box2top>.a2').eq(i).removeClass('a22');
		}
		else{
			$('.box2top>.a2').eq(i).addClass('a22');
		}
	});
	$('.body01_top>ul>li').click(function(){
		$('.body01_top>ul>li').removeClass('active');
		$(this).addClass('active');
		showTab();
	});
	$('.box>ul>li').click(function(){
		$('.box>ul>li').removeClass('active2');
		$(this).addClass('active2');
		showTab();
	}); 
	$('.cell').click(function(){
    $('#mymodal').modal('toggle');
    });
	$('.pull-right').click(function(){
       $('#mymodal').modal('toggle');
    });
    document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
    $('input').blur();
    //$('.home_footer').css('position','static');
    });
    $('input').bind('focus',function(){
    $('.buy_footer').css('position','static');
    }).bind('blur',function(){
    $('.buy_footer').css({'position':'fixed','bottom':'0'});
    });
	$(".top input").val("");
	$(".body2").find("select:eq(0)").html("");
	showTab();
	$("input[data-number]").val("");
	/////////////////////////
	$(".imglist").html("");
	var weixin=0;///用于在保存图片的时候判断上传类型
//	var latlng={};
	if (is_weixin()) {
		$("#scxq").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scxq").click(function(){
			var imgPath="/temp/pre/"+new Date().getTime()+".jpg";
			weixinfileup.imguploadToWeixin(this, imgPath, undefined,function(){
				var itemimg=$($("#itemimg").html());
				$(".imglist").eq(getLiactIndex()).append(itemimg);
				itemimg.find("img:eq(0)").attr("src",".."+imgPath);
				itemimg.find("span:eq(0)").html(imgPath);
				//获取当前地址
				wx.getLocation({
					type:"gcj02",// 'wgs84', //
									// 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
					success : function(res) {
						var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
						var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
						var speed = res.speed; // 速度，以米/每秒计
						accuracy = res.accuracy; // 位置精度
//						latlng.latitude=latitude;
//						latlng.longitude=longitude;
//						latlng.accuracy=accuracy;
						$(".latlng").eq(getLiactIndex()).html(latitude+","+longitude);
						codeLatLng(latitude, longitude);
						pop_up_box.loadWaitClose();
					},
					cancel : function(res) {
						pop_up_box.showMsg('用户拒绝授权获取地理位置');
					}
				});
			});
		});
	}else{
		$("#scxq").hide();
		$("#upload-btn").show();
	}
	$("#mymodal2 img").click(function(){
		$("#mymodal2").modal("toggle");
	});
	$("#save").click(function(){
		$(this).css({'color':'#fff'});
		var boxs= $(".body2");
		var list=[];
		for (var i = 0; i < boxs.length; i++) {
			var item=$(boxs[i]);
			var num=$.trim(item.find("input:eq(0)").val());
			var price=$.trim(item.find("input:eq(1)").val());
			
			if(price!=""&&num!=""&&time!=""){
				var time=$.trim(item.find(".Wdate").val());
				var item_id=$.trim(item.find("select:eq(0)").val());
				var imgs=item.next().find(".upload-img");
				var address=$.trim(item.find(".address").html());
				var latlng=$.trim(item.find(".latlng").html());
				var imglist=[];
				if(imgs.length>0){
					for (var j = 0; j < imgs.length; j++) {
						var img=$(imgs[j]);
						imglist.push(img.find("img:eq(0)").attr("src"));
					}
				}
				if(price&&num){
					var json={"item_id":item_id,"price":price,"num":num,"time":time,"address":address,"latlng":latlng,"imgs":imglist};
					list.push(JSON.stringify(json));
				}
			}
		}
		if(boxs&&boxs.length>0){
			pop_up_box.postWait();
			$.post("../pre/savePre.do",{
				"list":"["+list.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("挂价成功,请等待撮合!",function(){
						window.location.href="../pre/operate.do";
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请输入挂价相关信息!");
		}
	});
	init();
});
function showuploadImg(t){
	$("#mymodal2").modal("toggle");
    var s=$(t).attr("src");
    $('#mymodal2 img').attr('src',s);
}
function getLiactIndex(){
	var i=$(".body01>.body01_top ul>li").index($(".body01>.body01_top .active"));
	var j=$(".body01>.body01_bottom ul>li").index($(".body01>.body01_bottom .active2"));
	var index=0;
	if(i==0){//
		if(j==0){
			index=0;
		}else{
			index=1;
		}
	}else if(i==1){
		if(j==0){
			index=2;
		}else{
			index=3;
		}
	}else{
		if(j==0){
			index=4;
		}else{
			index=5;
		}
	}
	return index;
}

function imgUpload(t){
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
			"msgId":"",
			"fileId":"imgFile",
			"msg":"",
			"fid":"",
			"uploadFileSize":5
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			var itemimg=$($("#itemimg").html());
			$(".imglist").eq(getLiactIndex()).append(itemimg);
			itemimg.find("img:eq(0)").attr("src",".."+imgurl);
			itemimg.find("span:eq(0)").html(imgurl);
		});
}
/////////////////////////////////////////
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
        var address=result.detail.address;
        $(".address").eq(getLiactIndex()).html(address.replace("中国", ""));
        qq.maps.event.addListener(marker, 'click', function() {
            info.open();
            info.setContent('<div style="width:280px;height:100px;">' +
                result.detail.address + '</div>');
            info.setPosition(result.detail.location);
        });
    });
    //若服务请求失败，则运行以下函数
    geocoder.setError(function() {
    	pop_up_box.showMsg("出错了，请输入正确的经纬度！");
    });
}
