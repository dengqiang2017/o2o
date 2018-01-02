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