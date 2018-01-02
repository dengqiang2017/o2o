function getContainerHtml(url){
	if (!url||url=="") {
		return;
	}
	pop_up_box.loadWait();
	$.get(url,function(data){
		pop_up_box.loadWaitClose();
		$(".container:eq(0)").html(data);
	});
}
$(function(){
	var container=$(".container:eq(0)");
	var leftmemu=$("li[data-url],div[data-url]");
	//菜单点击事件
	leftmemu.click(function(){
		leftmemu.removeClass("active");
		$(this).addClass("active");
		$('a[data-title="title"]').html($(this).text());
		getContainerHtml($(this).attr("data-url"));
	});
	$(".med").find("ul>li").click(function(){
		$(".medli-tac").hide();
		var med=$(this).attr("data-index");
		if (med==0) {
			$(this).next(".medli-tac").show();
			$(".med").find("li[data-index]").attr("data-index",0);
			$(this).attr("data-index",1);
		}else{
			$(this).next(".medli-tac").hide();
			$(this).attr("data-index",0);
		}
	});
    $('.dht').click(function(){
    	if($(".zz").css("display")=="none"){
        $('.zz,.con-shade').show();
    	}else{
    		$('.zz,.con-shade').hide();
    	}
    });
	$(".zz").find("ul>li").click(function(){
		$(".zz2,.con-shade").hide();
		var n=$(this).attr("data-index");
		if ($(".zz2:eq("+n+")").length>0) {
			$(".zz2:eq("+n+"),.con-shade").show();
		}else{
			$(".zz,.con-shade").hide();
		}
	});
	$(".zz2").find("ul>li").click(function(){
		$(".zz2,.zz,.con-shade").hide(); 
	});
	$("a[data-head]").unbind("click");
	$("a[data-head]").click(function(){
		window.location.href="../pc/index.html";
	});
	$('.con-shade').click(function(){
		$('.zz,.zz2,.con-shade').hide();
	});
	$('.footer2').click(function() {
		$('.process-zz').toggle('slow')
	})
	$('.medli-tac-div').click(function(){
		$('.medli-tac-div').css('backgroundColor','');
		$(this).css('backgroundColor','#44566')
	});
	
});
/*
var contextPath = "";
var findflag=0;//查询标志用于判断查询是否完成,为0就可以继续查询
var login_url="../pc/index.html";
$.ajaxSetup({
	contentType : "application/x-www-form-urlencoded;charset=utf-8",
	 cache:false , 
	 dataFilter:function(response){
			 if(response.indexOf("<title>登录</title>") > 0) {
				alert("登录超时,请重新登录!");
				window.location.href=login_url;  
				//一定要返回一个字符串不能不返回或者不给返回值，否则会进入success方法  
				return "";  
         }else{
             //如果没有超时直接返回  
             return response;  
         } 
	 },
	 beforeSend:function(xhr,textStatus){
		 var responseText = xhr.responseText;
		 if (responseText){
			 if(responseText.indexOf("<title>登录</title>") > 0) {
				 pop_up_box.showMsg("登录超时,请重新登录!",function(){
					 window.location.href = login_url;
				 });
			 }
		 }
	 },
	success: function (xhr) {
		findflag=0;  
		},
	 error: function(jqXHR, textStatus, errorMsg){ // 出错时默认的处理函数
		 pop_up_box.loadWaitClose();
		 findflag=0;
		 findflag=0;
//		 alert("出错了,请联系管理员!");
	 },
	complete : function(XMLHttpRequest, textStatus) {
		var responseText = XMLHttpRequest.responseText;
		findflag=0;
		if (responseText) {
			if (responseText.indexOf("<title>登录</title>") > 0) {
				window.location.href = login_url;
			}
			try {
				var sessionstatus = eval('(' + responseText + ')');
				if (sessionstatus && sessionstatus.sessionstatus == "timeout") {
					alert("会话超时,重新登录!");
					// 这里怎么处理在你，这里跳转的登录页面
					window.location.href = login_url;
				}
			} catch (e) {}
		}
	}
});*/