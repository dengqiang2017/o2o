<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>供应商</title>
    <link rel="stylesheet" href="../pcxy/css/function.css">
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
</head>
<body onload='getContainerHtml("gysOrder.do");'>
<!------------------------header------------------------->
<div class="header">
    <ol class="breadcrumb" style="height: 100%;line-height: inherit;">
        <li style="height: 100%;float: left;margin-top: -10px;"><img  style="height: 70%;margin-bottom: 15px;margin-right: 10px" src="../pc/image/logo.png" ><span style="font-size: 36px;">供应商</span></li>
        <li><a style="color: white;font-size: 24px;line-height:60px" data-title="title">我的订单</a></li>
    </ol>
    <div class="header-title">
        <a style="color: white;" data-title="phone">我的订单</a>
<!--         <a class="header-back" style="margin-top: 5px" href="../login/exitLogin.do"><span class="glyphicon glyphicon-menu-left" style="color: white;"></span></a> -->
    </div>
    <div class="dht pull-right" style="margin-top: 2px">
        <img  src="../pc/repair-images/icon01.png"></div>
    <div class="zz">
        <ul>
            <li class="backcolor" data-url="gysOrder">我的订单</li>
            <li data-url="receipt">我的收款单</li>
            <li data-url="vendorInfo">管理个人信息</li>
<!--             <li data-url="editPhone.jsp?type=gys">修改绑定手机号</li> -->
<!--             <li data-url="editPass.jsp?type=gys">修改密码</li> -->
<!--             <li><a href="../在线咨询/repair-zhixun.html">在线咨询</a></li> -->
            <li class="exitLogin">退出登录</li>
        </ul>
    </div>
</div>
<!------------------------section------------------------->
<div class="con">
    <div class="con-shade"></div>
    <div class="med">
        <ul>
            <li class="backcolor" data-url="gysOrder">我的订单</li>
            <li data-url="receipt">我的收款单</li> 
            <li data-url="vendorInfo">管理个人信息</li>
<!--             <li data-url="editPhone.jsp?type=gys">修改绑定手机号</li> -->
<!--             <li data-url="editPass.jsp?type=gys">修改密码</li> -->
<!--             <li><a href="../在线咨询/repair-zhixun.html">在线咨询</a></li> -->
            <li class="exitLogin">退出登录</li>
        </ul>
    </div>
    <div class="container tbd" id="containerhtml">
    
    
    </div>
    </div>
    <script type="text/javascript">
    function getContainerHtml(url){
    	pop_up_box.loadWait();
    $.get(url+".do",function(data){
		pop_up_box.loadWaitClose();
		$("#containerhtml").html(data);
		if(url=="vendorInfo"){
			vendorInfo.init();
		}
	});
    }
	//菜单点击事件
	var leftmemu=$("li[data-url],div[data-url]");
	leftmemu.click(function(){
		leftmemu.removeClass("active");
		$(this).addClass("active");
		leftmemu.removeClass("backcolor");
		$(this).addClass("backcolor");
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
    $(".exitLogin").click(function(){
    	var login_url="/pc/loginSupplier.jsp?com_id=${sessionScope.customerInfo.com_id}";
    	$.get("../login/exitLogin.do?type=2",function(){
    		window.location.href=login_url;
    	});
    });
    </script>
        <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/gys/vendorInfo.js${requestScope.ver}"></script>
</body>
</html>