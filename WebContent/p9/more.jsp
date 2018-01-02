<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title></title>
    <link rel="stylesheet" href="http://www.pulledup.cn/pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/more.css">
</head>
<body>
<!--公用头部-->
<div class="index01_top navbar-fixed-top">
    <div class="center">
        <div class="pull-left">
            <a href="index.html"><img class="img-responsive" src="images/LOGO.png"></a>
        </div>
        <div class="pull-right">
            <ul>
                <li><a href="index.html">首页</a></li>
                <li><a href="serve.html">服务</a></li>
                <li><a class="active" href="case.html">案例</a></li>
                <li><a href="about.html">关于我们</a></li>
                <li style="margin-right: 0"><a href="relation.html">联系我们</a></li>
                <div class="clearfix"></div>
            </ul>
            <img src="images/tc.png" style="width: 24px;margin-top: 12px;">
        </div>
        <div class="clearfix"></div>
    </div>
</div>
<!---->
<div class="zz_box"></div>
<div class="zz">
    <ul style="margin-bottom: 0;">
        <a href="index.html"><li>首页</li></a>
        <a  href="serve.html"><li>服务</li></a>
        <a href="case.html"><li class="active">案例</li></a>
        <a href="about.html"><li>关于我们</li></a>
        <a href="relation.html"><li style="margin-right: 0">联系我们</li></a>
        <div class="clearfix"></div>
    </ul>
</div>

    <div class="more-container">
        <a class="btn btn-default" href="javascript:history.back();">返回</a>
        <h1></h1>
        <span style="display: none;" class="ui_type"></span>
        <div class="more-ul">
        <ul>
        </ul>
            <div class="clearfix"></div>
        </div>
    </div>
    <div id="item" style="display: none;">
   		<li>
          <div class="more-left pull-left ui_title">这里是标题，可能有点长，多的用省略号......</div>
          <div class="more-right pull-right ui_time">2016.11.25</div>
          <div class="clearfix"></div>
       </li>
    </div>
<script src="http://www.pulledup.cn/js_lib/jquery.11.js"></script>
<script type="text/javascript" src="js/url.js"></script>
<script type="text/javascript">
<!--
    $('.center>.pull-right img').click(function(){
        $('.zz_box').toggle();
        $('.zz').slideToggle();
    });
    $('.zz_box').click(function(){
        $('.zz_box').hide();
        $('.zz').slideUp();
    });
//-->
</script>
</body>
</html>