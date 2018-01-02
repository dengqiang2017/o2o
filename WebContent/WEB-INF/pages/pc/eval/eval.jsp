<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <!--     <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <link rel="stylesheet" href="../pcxy/css/function.css">
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.min.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
    <script src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/saiyu/evalMemu.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/saiyu/eval.js${requestScope.ver}"></script>
</head>
<style>
    @media(min-width: 1200px){
        .zz{
            width: 0;
            overflow: hidden;
        }
    }
</style>
<body>
<!------------------------header------------------------->
<div class="header">
    <ol class="breadcrumb" style="height: 100%;line-height: inherit;">
        <li style="height: 100%;float: left;margin-top: -10px;"><img  style="height: 70%;margin-bottom: 15px;margin-right: 10px" src="../pc/image/logo.png" ><span style="font-size: 36px;">赛宇电器</span></li>
        <li><a style="color: white;font-size: 24px;line-height:60px" data-title="title">我的安装</a></li>
    </ol>
    <div class="header-title">
        <a style="color: white;" data-title="phone">我的安装</a>
        <a class="header-back" href="../login/exitLogin.do?type=2" style="margin-top: 5px" data-head="url"><span class="glyphicon glyphicon-menu-left" style="color: white;"></span></a>
    </div>
    <div class="dht pull-right" style="margin-top: 2px">
        <img  src="../pc/repair-images/icon01.png"></div>
    <!-- 		<div class="header-logo"></div> -->
    <div class="zz">
        <ul>
            <li><a href="eval.do">我的安装</a></li>
<!--             <li data-url="evalEdit.do">管理个人信息</li> -->
<!--             <li data-url="../pc/saiyu/editPhone.jsp?type=eval">修改绑定手机号</li> -->
<!--             <li data-url="../pc/saiyu/editPass.jsp?type=eval">修改密码</li> -->
<!--             <li><a href="../consult/repair-zhixun.jsp">在线咨询</a></li> -->
<!--             <li><a href="../toJoin01/diangong-fujin.html">加盟附近电工</a></li> -->
            <li onclick="window.location.href='../login/exitLogin.do?type=2'">回到首页</li>
        </ul>
    </div>
</div>
<!------------------------section------------------------->
<div class="con">
    <div class="con-shade"></div>
    <div class="med">
        <ul>
            <li><a href="eval.do">我的安装</a></li>
<!--             <li data-url="evalEdit.do">管理个人信息</li> -->
<!--             <li data-url="../pc/saiyu/editPhone.jsp?type=eval">修改绑定手机号</li> -->
<!--             <li data-url="../pc/saiyu/editPass.jsp?type=eval">修改密码</li> -->
<!--             <li><a href="../consult/repair-zhixun.jsp">在线咨询</a></li> -->
<!--             <li data-url="myOA"><a href="../toJoin01/diangong-fujin.html">加盟附近电工</a></li> -->
            <li onclick="window.location.href='../login/exitLogin.do?type=2'">回到首页</li>
        </ul>
    </div>
    <div class="container tbd">
        <div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;用户中心->我的安装</div>
        <div class="container-one" style="margin-bottom:60px">
            <div class="form-group">
                <div class="row">
                    <div class="col-lg-3">
                        <label class="label-lg">发起日期</label>
                        <input type="date" class="form-control Wdate input-height" name="beginTime" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
<!--                         <input type="date" class="form-control Wdate input-height" name="endTime" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"> -->
                    </div>
                    <div class="col-lg-3">
				         <label class="label-lg">安装类别</label>
				         <select class="form-control input-height" id="elecState">
				             <option></option>
				             <option value="0">未预约</option>
				             <option value="1">已预约未安装</option>
				             <option value="2">已安装未支付</option>
				             <option value="3">已支付未验收评价</option>
				             <option value="4">已确认评价</option>
				         </select>
				     </div>
                    <div class="col-lg-3">
                        <label class="label-lg">输入关键字</label>
                        <input type="text" class="form-control input-height" id="searchKey" name="searchKey" placeholder="输入关键字">
                    </div>
                    <div class="col-lg-3">
                        <button type="button" class="btn btn-primary btn-lg btn-position find" style="margin-top:20px">查询</button>
                    </div>
                </div>
            </div>
            <div id="evallist" class="row">
            
            </div>
            <div id="evalitem" style="display: none;">
            <div class="col-lg-3 center-block center-row">
    		<div class="pro-check" style="float:left;margin-top:5px;display: none;"></div>
    		<input type="hidden" id="item_id">
               <ul style="background-color:#fff;padding-left:20px">
<!--                 <li></li> -->
<!--                 <li>数量:</li> -->
<!--                 <li>安装单价:</li> -->
                <li>订单编号:<span></span></li>
                <li>安装金额:￥</li>
                <li>状态:</li>
                <li>安装时间:</li>
                <li id="azwcbtn"><button type="button" class="btn btn-primary">我已完成</button></li>
                <li id="ckxqbtn"><button type="button" class="btn btn-primary">查看详情</button></li>
    			</ul>
            </div>
            </div>
<!-- 				<div class="xfooter" style="width:100%;height:60px;background-color:#F4F0F0;position:fixed;bottom:0;margin-left:-15px"> -->
<!-- 				<div class="pro-check" id="allcheck" style="margin-top:18px;margin-left:25px;margin-right:10px;width:30px;float:left"></div> -->
<!-- 				<div style="margin-top:23px;margin-right:10px;float:left"><span>全选</span></div> -->
<!-- 				<button type="button" class="btn btn-sm btn-primary" id="diangongbtn" style="margin-top:18px;">我已完成</button> -->
<!-- 			</div> -->
        </div>
    </div>
     <div class="container tbd" style="display: none;">
     <div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;
用户中心-><span><a href="javaScript:backlist();">我的安装</a>-></span><span>安装明细</span></div>
        <div class="container-one" style="background-color:#fff">
        <input type="hidden" id="orderNo" value="${requestScope.orderNo}">
        <input type="hidden" id="dian_customer_id" value="${requestScope.dian_customer_id}">
          <div>总服务费用：￥<span id="azfy"></span>元</div>
        	<div id="anz_orderlist" class="row"> 
        	</div>
	            <div id="an_item" style="display:none">
	            <div class="col-lg-4 col-sm-6 fl">
        		<div class="div-bg">
	            <ul>
	                <li>订单号：<span></span></li>
	                <li>产品名称：<span></span></li>
	                <li>数量:<span></span></li>
	                <li>安装单价:<span></span></li>
	            </ul>
	            </div>
	            </div>
	            </div>
<!--             <button type="button" class="btn btn-sm btn-primary center-block container-btn">在线咨询</button> -->
<!--             <div class="text-center fl" style="margin-top: 20px">如有异议可以点击在线咨询了解详情</div> -->
            <div class="clear"></div>
        </div>
        <button type="button" class="btn btn-primary" onclick='javaScript:backlist();'>返回</button>
     </div>
</div>
</body>
</html>