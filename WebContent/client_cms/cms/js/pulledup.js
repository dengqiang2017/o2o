$(function(){

	// 登录

	$(".login-fix").click(function(){
		$(".login").slideDown('fast');
	})

	$(".close").click(function(){
		$(".login").slideUp('fast');
	})

	//banner
	$(".banner").hide();
	$(".banner:eq(0)").show();
	$(".ctrl_btn").removeClass("activeB");
	$(".ctrl_btn:eq(0)").addClass("activeB");
	var n = 0;
	var timer = setInterval(auto,1500);
	function auto(){
		if(n<$(".banner").length-1){
			n = n+1;	
		}
		else{
			n = 0;
		}
		$(".banner").hide();
		$(".banner:eq("+n+")").show();
		$(".ctrl_btn").removeClass("activeB");
		$(".ctrl_btn:eq("+n+")").addClass("activeB");
	};
	$(".arrow_group,.ctrl_btn_group").hover(function(){
		clearInterval(timer);	
	},function(){
		timer = setInterval(auto,1500);
	});
	$(".arrow_left").click(function(){
		if(n>0){
			n = n-1;
		}
		else{
			n = $(".banner").length-1;
		}
		$(".banner").hide();
		$(".banner:eq("+n+")").show();
		$(".ctrl_btn").removeClass("activeB");
		$(".ctrl_btn:eq("+n+")").addClass("activeB");
	})
	$(".arrow_right").click(function(){
		if(n<$(".banner").length-1){
			n = n+1;
		}
		else{
			n = 0;
		}
		$(".banner").hide();
		$(".banner:eq("+n+")").show();
		$(".ctrl_btn").removeClass("activeB");
		$(".ctrl_btn:eq("+n+")").addClass("activeB");
	});
	$(".ctrl_btn").click(function(){
		var m = $(".ctrl_btn").index(this);
		$(".banner").hide();
		$(".banner:eq("+m+")").show();
		$(".ctrl_btn").removeClass("activeB");
		$(".ctrl_btn:eq("+m+")").addClass("activeB");
	})

	$(".sm_nav li").removeClass("sm_nav_activeLi");
	$(".sm_nav li:eq(0)").addClass("sm_nav_activeLi");
	$(".sm_nav li i").removeClass("sm_nav_activeI");
	$(".sm_nav li i:eq(0)").addClass("sm_nav_activeI");
	$(".content_ctn").hide();
	$(".content_ctn:eq(0)").show();
	$(".sm_nav li").click(function(){
		var n = $(".sm_nav li").index(this);
		$(".sm_nav li").removeClass("sm_nav_activeLi");
		$(".sm_nav li:eq("+n+")").addClass("sm_nav_activeLi");
		$(".sm_nav li i").removeClass("sm_nav_activeI");
		$(".sm_nav li i:eq("+n+")").addClass("sm_nav_activeI");
		$(".content_ctn").hide();
		$(".content_ctn:eq("+n+")").show();
	})

	//手机banner
	var n = 0;
	var timing = setInterval(phone_auto,1500);
	if(n<$(".banner-xs").length-1){
		n = n+1;	
	}
	else{
		n = 0;
	}
	function phone_auto(){
		$(".phone-banner").animate({"left":-n*100+"%"},1000);
	};

	//侧边工具栏（触屏设备）
	$(".qq-icon").toggle(function(){
		$(".qq_icon").slideDown(200);
	},function(){
		$(".qq_icon").slideUp(200);
	});

	$(".phone-icon").toggle(function(){
		$(".phone_icon").slideDown(200);
	},function(){
		$(".phone_icon").slideUp(200);
	});

	$(".qr-icon").toggle(function(){
		$(".qr_code").slideDown(200);
	},function(){
		$(".qr_code").slideUp(200);
	});

	//回到顶部
	$("#back-to-top").click(function(){
        $('body,html').animate({scrollTop:0},500);
        return false;
    });

	//产品详细页选项卡
    $(".tabstitle").removeClass("activeTabs");
	$(".tabstitle:eq(0)").addClass("activeTabs");
	$(".tabs_content").hide();
	$(".tabs_content:eq(0)").show();
	$(".tabstitle").click(function(){
		var n = $(".tabstitle").index(this);
		$(".tabstitle").removeClass("activeTabs");
		$(".tabstitle:eq("+n+")").addClass("activeTabs");
		$(".tabs_content").hide();
		$(".tabs_content:eq("+n+")").show();	
	});

	$(".p-c-group>ul").hide();
	$(".p-c-title").click(function(){
		var n = $(".p-c-title").index(this);
		$(".p-c-group>ul").hide();
		$(".p-c-group>ul:eq("+n+")").show();
	});

	$(".p-c-group>ul>li").click(function(){
		var n = $(".p-c-group>ul>li").index(this);
		$(".p-c-group>ul>li i").hide();
		$(".p-c-group>ul>li:eq("+n+") i").show();
	});

	$(".side-cover").hide();
	$(".product-check").hide();
	$("#product-check").click(function(){
		$(".side-cover").slideDown('fast');
		$(".product-check").slideDown('fast');
	});

	$(".side-cover").click(function(){
		$(".side-cover").slideUp('fast');
		$(".product-check").slideUp('fast');
	});
})