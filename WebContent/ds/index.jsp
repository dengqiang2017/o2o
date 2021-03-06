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
    <title>首页-${requestScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<!--     <link rel="stylesheet" href="css/swiper-3.3.1.min.css"> -->
    <link rel="stylesheet" href="css/index.css${requestScope.ver}">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<!--     <link rel="stylesheet" href="css/lightbox.css"> -->
    <link rel="stylesheet" href="../lightSlider/css/base.css">
    <link rel="stylesheet" href="../lightSlider/css/lightSlider.css" />
    <link rel="stylesheet" href="../lightSlider/css/prettify.css" />
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <style type="text/css">
    .wordT {
    color: #bebebe;
    font-size: 14px;
}
.col-lg-2 p{
text-align: center;
}
.container{
margin-bottom: 50px;
}
    </style>
</head>
<body>
  <div class="container">
      <div class="product-imgPH">
          <ul id="fade" class="gallery list-unstyled clearfix" style="margin-bottom: 0">
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
<!-------------分类------------>
<div class="">
<div class="col-xs-4 col-md-4 col-lg-2">
            <a href="spruce.jsp">
                <div class="classify-box-img home-backcolor">
                    <img class="img-responsive center-block" src="images/l2.png">
                </div>
                <p>装修案例</p>
            </a>
        </div>
        <div class="col-xs-4 col-md-4 col-lg-2">
            <a href="stylisty.jsp">
                <div class="classify-box-img home-backcolor" style="background-color: #CC374B">
                    <img class="img-responsive center-block" src="images/shejis.png">
                </div>
                <p>设计师</p>
            </a>
        </div>
        <div class="col-xs-4 col-md-4 col-lg-2">
            <a href="product_display.jsp">
                <div class="classify-box-img fitment-backcolor">
                    <img class="img-responsive center-block" src="images/l3.png">
                </div>
                <p>家居饰品</p>
            </a>
        </div>
 <div class="col-xs-4 col-md-4 col-lg-2">
            <a href="jinbi.jsp">
                <div class="classify-box-img fitment-backcolor" style="background-color: rgb(255,201,14);">
                    <img class="img-responsive center-block" style="width: 30px;" src="images/jinbi.png">
                </div>
                <p>领金币</p>
            </a>
        </div>
        <div class="col-xs-4 col-md-4 col-lg-2">
            <a href="coupon.jsp">
                <div class="classify-box-img fitment-backcolor" style="background-color: rgb(255,201,14);">
                    <img class="img-responsive center-block" style="width: 30px;" src="images/jinbi.png">
                </div>
                <p>领券</p>
            </a>
        </div>
        <div class="col-xs-4 col-md-4 col-lg-2">
            <a href="activity.jsp">
                <div class="classify-box-img fitment-backcolor" style="background-color: rgb(255,201,14);">
                    <img class="img-responsive center-block" style="width: 30px;" src="images/jinbi.png">
                </div>
                <p>活动</p>
            </a>
        </div>
</div>
<!-- 头条 -->
<div style="padding-top: 10px;padding-bottom: 10px;">
<div class="pull-left" style="color: red;font-size: 20px;font-weight: bold;margin-left: 5px;height: 50px;padding-top: 10px;">头条</div>

<div style="cursor: pointer;margin-left: 3px;float: left;">
<div id=rp1>
<span class="reping">热评</span>
<span style="font-size: 12px;float: left;margin-left: 5px;" id="rptitle"></span><span id="htmlname" style="display: none;"></span>
<div class="clearfix"></div>
</div>
<div id=rp2>
<span class="reping">热评</span>
<span style="font-size: 12px;float: left;margin-left: 5px;" id="rptitle"></span><span id="htmlname" style="display: none;"></span>
<div class="clearfix"></div>
</div>
</div>
<div class="clearfix"></div>
</div>
<!-----------优秀案例-------------->
<div class="case">
    <!-- 新品推送-->
        <div class="case_title">
            <div class="case_title_box clearfix center-block" style="width: 75%">
            <div class="new_title_left"></div>
            <div class="new_title_center">新品推送</div>
            <div class="new_title_right"></div>
            </div>
        </div>
    <div class="case_list clearfix">
    </div>
<div id="xptsitem" style="display: none;">
       <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
           <div class="case_list_box">
               <a>
                   <img class="img-responsive">
               </a>
               <div id="item_name" style="font-size: 14px;text-align: left;">地中海风</div>
               <div style="text-align: left;"><span id="cost_name" style="color: #F00101;font-size: 14px;"></span>
               <span class="wordT" id="price_display" style="text-decoration:line-through;font-size: 12px;">13999.00</span></div>
           </div>
       </div>
</div>
    <!-- 活动促销-->
    <div class="case_title">
        <div class="case_title_box clearfix center-block" style="width: 75%">
            <div class="case_title_leftT"></div>
            <div class="case_title_centerT">活动促销</div>
            <div class="case_title_rightT"></div>
        </div>
    </div>
    <div class="sales_list clearfix" id="saleslist">
    </div>
    <!-- 精彩案例-->
    <div class="case_title">
        <div class="case_title_box clearfix center-block" style="width: 75%">
            <div class="case_title_left"></div>
            <div class="case_title_center">精彩案例</div>
            <div class="case_title_right"></div>
        </div>
    </div>
    <div class="case_listT clearfix" id="jzlist">
    </div>
<div id="jzitem" style="display: none;">
        <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
            <div class="case_list_boxT">
            <div class="pic"><img src=""></div>
            <div class="word">
                <span id="typeName">现代简约</span>
                <span id="proName">简化整合，改变后的主卧空间</span>
            </div>
          </div>
        </div>
</div>
    <!-- 设计师-->
    <div class="case_title">
        <div class="case_title_box clearfix center-block" style="width: 75%">
            <div class="stylist_title_left"></div>
            <div class="stylist_title_center">设计师</div>
            <div class="stylist_title_right"></div>
        </div>
    </div>
    <div class="stylist clearfix" id="sjslist">
    </div>
    <div id="sjsitem" style="display: none;">
    <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
            <div class="stylist_box">
                <img src="">
                <span id="clerkName"></span>
                <span id="describe"></span>
            </div>
        </div>
    </div>
</div>
    </div>
    <!-------------固定尾部------------>
  <div class="footer navbar navbar-default navbar-fixed-bottom" style="height: 50px;">
  <div class="container">
  <div class="col-xs-4">
          <a href="index.jsp">
              <span class="fa fa-home fa-fw active" aria-hidden="true"></span>
              <span class="active">首页</span>
          </a>
      </div><div class="col-xs-4">
          <a href="shopping_cart.jsp">
              <span class="fa fa-shopping-cart" aria-hidden="true"></span>
              <span>购物车</span>
          </a>
      </div><div class="col-xs-4">
          <a href="personal_center.jsp">
              <span class="fa fa-user fa-fw" aria-hidden="true"></span>
              <span>我</span>
          </a>
      </div>
      <div class="clearfix"></div>
      </div>
  </div>
  <div style="margin-bottom: 30px;text-align: center;"><a class="btn btn-info" href="/employee.do">运营管理入口</a></div>
  <div id='copyright'>
<div class="text">蜀ICP备15034477号-1</div>
<div>©2017 牵引互联 版权所有</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery.lightSlider.min.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<!-- <script type="text/javascript" src="js/lightbox.js"></script> -->
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="../cmsjs/banner.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/index.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
weixinShare.init($("title").html(),"${requestScope.description}","http://www.pulledup.cn/ds/images/banner2.jpg");
//-->
</script>
</body>
</html>