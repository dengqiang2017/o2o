$(function(){
	var url01=window.location.href.split("?")[0];
	var url02=url01.split("/");
	url01=url02[url02.length-1];
	parent.edit_url=url01;
	function isPC() {
	    var userAgentInfo = navigator.userAgent;
	    var Agents = ["Android", "iPhone",
	                "SymbianOS", "Windows Phone",
	                "iPad", "iPod"];
	    var flag = true;
	    for (var v = 0; v < Agents.length; v++) {
	        if (userAgentInfo.indexOf(Agents[v]) > 0) {
	            flag = false;
	            break;
	        }
	    }
	    return flag;
	}
	$.get("head.html?ver="+Math.random(),function(data){
		$(".logo_container").html(data);
		var ahtmls=$(".header > ul >li>a");
		ahtmls.parent().removeClass("active");
		for (var i = 0; i < ahtmls.length; i++) {
			var ah=$(ahtmls[i]);
			 if(ah.attr("href")==url01){
				 ah.parent().addClass("active");
			 }
		}
		var atxt=$(".logo_container").find("a");
		if ($("#type").val()=="1") {//服务
			$(".main_title,title").html($(atxt[3]).text());
			$("title").html("牵引互联-"+$("title").html());
		}else if ($("#type").val()=="2"){//案例
			$(".main_title,title").html($(atxt[2]).text());
			$("title").html("牵引互联-"+$("title").html());
		}else if ($("#type").val()=="3"){//口碑
			$(".main_title,title").html($(atxt[4]).text());
			$("title").html("牵引互联-"+$("title").html());
		}else if (window.location.href.indexOf("product")>0) {
			$(".main_title,title").html($(atxt[1]).text());
			$("title").html("牵引互联-"+$("title").html());
		}else if (window.location.href.indexOf("index")>0) {
			$(".main_title,title").html($(atxt[0]).text());
			$("title").html("牵引互联-"+$("title").html());
		}
		try {
			$(".qq-icon").hide();
			edithtml.init();
		} catch (e) {
			$(".qq-icon").show();
			$(".tools_icon").click(function(){
				if ($(this).find("a").attr("href")) {
					window.location.href=$(this).find("a").attr("href");
				}
			});
			$(".tools_icon>.icon").click(function(){
				if ($(this).parent().find("a").attr("href")) {
					window.location.href=$(this).parent().find("a").attr("href");
				}
			});
		}
		$.get("fenxiang.jsp",function(data){
			$("#fenxiang").html(data);
		});
	});
//	$.get("head-login.html",function(data){
//		$(".login").html(data);
//		$(".close").click(function(){
//			$(".login").hide();
//		});
//		if(isPC) {
//			$(".login").find("li:eq(0)").hide();
//		}
//	});
	$.get("footer.html",function(data){
		$(".footer").html(data);
		try {
			edithtml.init();
		} catch (e) {
		}
	});
	$(".login,.login-fix").remove();
	$(".btn_01").hide();
	$(".btn_02").click(function(){
		removeCookie();
		setCookieval("zhixun","zhixun");
		setCookieval("backurl",window.location.href);
		window.location.href="../login/toUrl.do?url=../user/sendChatMsg.do";
		return false;
	});
    $("#back-to-top").click(function(){
        $('body,html').animate({scrollTop:0},500);
        return false;
    }); 
    	var timestamp = new Date().getTime();
//		pop_up_box.dataHandling("初始化中...");
//		loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
	$.get("../employee/getSignature.do", {
		"timestamp" : timestamp,
		"url" : window.location.href
	}, function(data) {
		try{//alert("初始化");
		wx.config({
			debug : false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
			appId : data.split(",")[2], // 必填，企业号的唯一标识，此处填写企业号corpid
			timestamp : data.split(",")[1], // 必填，生成签名的时间戳
			nonceStr : data.split(",")[3], // 必填，生成签名的随机串
			signature : data.split(",")[0],// 必填，签名，见附录1
			jsApiList : ["getLocation","openLocation","chooseImage","uploadImage"]
		// 必填，需要使用的JS接口列表，所有JS接口列表见附录2
		});
		} catch (e) {//alert("初始化失败");
//			pop_up_box.loadWaitClose();
		}
		wx.ready(function() {//alert("开始分享");
//			pop_up_box.loadWaitClose();
		setTimeout(function(){
			wx.onMenuShareAppMessage({
	    	    title: '牵引互联', // 分享标题
	    	    desc: '牵引互联O2O分享', // 分享描述
	    	    link: window.location.href, // 分享链接
	    	    imgUrl: 'http://www.my-tw.com:8080/o2o/pc/image/logo.png', // 分享图标
	    	    type: 'link', // 分享类型,music、video或link，不填默认为link
	    	    dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
	    	    success: function () {
	    	        alert("分享成功!");
	    	    },
	    	    cancel: function () {
	    	        // 用户取消分享后执行的回调函数
	    	    	alert("分享失败!");
	    	    }
	    	});
		}, 3000);
		});
	});
	
	
$.post("https://graph.qq.com/t/add_pic_t ",{
	"format":"json",
	"content":"牵引互联",
	"pic":"http://www.my-tw.com:8080/o2o/pc/image/logo.png",
	"syncflag":"0"
},function(data){
	console.debug(data);
});
});   
function setCookieval(key,val){
	$.cookie(key,val);
	localStorage.setItem(key,val);
}
function getCookieval(key){
	var shopping=$.cookie(key);
	if(!shopping){
		shopping=localStorage.getItem(key);
	}
	return shopping;
}
function removeCookie(){
	$.removeCookie("orderpay");
	localStorage.removeItem("orderpay");
	
	$.removeCookie("ordershopping");
	localStorage.removeItem("ordershopping");
	
	$.removeCookie("zhixun");
	localStorage.removeItem("zhixun");
}
function hoverFenxiang(div,display){
	div.nextElementSibling.nextElementSibling.style.display=display;
}
function hoverFenxiangMe(div,display){
	var fenxiang=div.style.display=display;
}
function clickFenxiangMe(div){
	if($("#fenxiang").css("display")=='none'){
		$("#fenxiang").show();
	}else{
		$("#fenxiang").hide();
	}
}