<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getVer(request);
BaseController.setDescriptionAndKeywords(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="${requestScope.description}">
    <meta name="keywords" content="${requestScope.keywords}">
    <title>案例详情</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/lightbox.css">
    <link rel="stylesheet" href="../lightSlider/css/base.css">
    <link rel="stylesheet" href="../lightSlider/css/lightSlider.css" />
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/spruce_case.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
   <div class="header-phone">
            <a onclick="javascript:history.back();" class="header_left">返回</a>
            案例详细
        </div>
</nav>
<div class="container">
        <div class="">
        <div class="product-imgPH">
            <ul id="fade" class="gallery list-unstyled clearfix">
                <li class="active">
                    <a href="images/banner2.jpg" data-lightbox="roadtrip"><img class="img-responsive" src="images/banner2.jpg"></a>
                </li>
                <li>
                    <a href="images/banner3.jpg" data-lightbox="roadtrip"><img class="img-responsive" src="images/banner3.jpg"></a>
                </li>
                <li>
                    <a href="images/banner4.jpg" data-lightbox="roadtrip"><img class="img-responsive" src="images/banner4.jpg"></a>
                </li>
                <li>
                    <a href="images/banner5.jpg" data-lightbox="roadtrip"><img class="img-responsive" src="images/banner5.jpg"></a>
                </li>
            </ul>
        </div>
        <div class="spruce_case_box">
            <div class="box_title" id="proName">
                新桂广场
            </div>
            <div class="box_word">
                <ul>
                    <li>
                        风格 ：<span id="item_spec">现代简约</span>
                    </li>
                    <li>
                        户型 ：<span id="item_type">三居</span>
                    </li>
                    <li>
                        面积 ：<span id="item_struct">108㎡</span>
                    </li>
                    <li>
                        造价 ：<span style="color: #FE1112" id="price">18</span>万元
                    </li>
                    <li>
                        说明：<span id="miaosu">马可波罗瓷砖、创锐瓷砖、波斯王子瓷砖、东鹏瓷砖、大理石、墙纸、大理石油漆、石膏线等</span>
                    </li>
<!--                     <li> -->
<!--                         设计说明：<span>本案以现代简约风格为基调，设计造型优美、古朴低调，到处都是美式风格的经典体现。华丽、精致的吊灯使空间洋溢着一丝丝高贵与优雅的气息。</span> -->
<!--                     </li> -->
                </ul>
            </div>
        </div>
        <div class="spruce_case_bottom clearfix">
            <div class="col-xs-3">
                <img src="" id="tx">
            </div>
            <div class="col-xs-8">
                <ul>
                    <li>
                        <span style="color: #1A7674;font-weight: bold;font-size: 20px;" class="clerkName"></span>
                        <span style="color: #E80102;font-weight: bold;">[方案设计师]</span>
                    </li>
                    <li>
                        <span style="color: #E80102">8</span>年工作经验
                    </li>
                    <li id="describe">
                        创意是设计的源泉，生活是设计的本质
                    </li>
                </ul>
            </div>
            <div class="col-xs-1">
                <img src="images/backRight.png" class="center-block" style="width: 9px;">
            </div>
        </div>
        </div>
        <div class="spruce_case_footer clearfix">
               <ul>
                   <li>
                       <button type="button" id="chat" class="btn btn-primary">在线咨询</button>
                   </li>
                   <li>
                       <a id="tel" class="btn btn-primary">与<span style="color: #006766" class="clerkName">Jimmy</span>通话</a>
                   </li>
               </ul>
        </div>
        </div>
<script type="text/javascript" src="../js_lib/jquery.11.js">
</script><script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="lightbox.js"></script>
<script type="text/javascript" src="../js_lib/jquery.lightSlider.min.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/spruce_case.js${requestScope.ver}"></script>
</body>
</html>