<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.checkClientLogin(request, response);
BaseController.getVer(request);
BaseController.getPctype(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>报价单</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/swiper-3.3.1.min.css">
    <link rel="stylesheet" href="css/await_pay.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="../pc/css/uploadPingz.css${requestScope.ver}">
<style type="text/css">
    .swiper-container {
        width: 100%;
        height: 100px;
    }
    .swiper-slide>img{
        width: 100px;
        height: 100px;
        padding: 10px;
    }
</style>
</head>
<body style="background-color: #E6E6E6;">
<div id=listpage>
<!---------------公用部分--------------------->
     <!-- 头部-->
      <div class="header navbar-fixed-top" style="font-size: 18px">报价单<a class="glyphicon glyphicon-menu-left a_position" href="personal_center.html" style=""></a>
      <a id=query style="position: absolute;right: 12px;top: 6px;">
          <img src="images/Search.png" style="width: 20px">
      </a>
      </div>
     <!-- 定位跳转-->
      <div class="orient" style="margin-top: 40px">
          <div class="orient_01"><a href="personal_center.html" style="text-decoration: none;">个人中心</a></div> <span style="color: #999999;font-size: 16px;">>></span> <div class="orient_02">报价单</div>
      </div>
<!---------------公用部分--------------------->

     <!-- 待支付订单展示-->
     <div class="orderbox">
     </div>
     <div id="item" style="display: none">
         <div class="orderbox01">
             <div class="order_01">
             <div>
                 <div class="pull-left"> <div class="pro-check" style="width: 30px"></div></div>
                 <div style="color: #666666;float: left;margin-top: 3px;margin-left: 3px;">
                     报价单编号：<span id="orderNo"></span><span id="com_id" style="display: none;"></span>
                 </div>
             </div>
                 <div class="pull-right" style="margin-top: 4px"> 
<!--                  <div> -->
                     <a id="del" style="cursor: pointer;text-decoration: none">删除</a>
<!--                  </div> -->
                 </div>

                 <div class="clear"></div>
             </div>
             <div class="order_02" id="demandInfo">
             </div>
             <div class="order_03" id="imgs">
                 <img src="images/06支付订单_03.jpg">
             </div>
             <div class="order_04">
                 <div>
                     要求交货时间：<span id="deliveryDate"></span>
                 </div>
                 <div style="margin-top: 10px;color: #E33230;font-size: 18px">
                     金额:¥<span id="sum_si"></span>
                     <span id="status"></span>
                 </div>
                 <div class="clear"></div>
             </div>
         </div>
     </div>
     <a class="pay btn" style="border-radius: 0;padding: 18px 0;font-size: 18px;color: #FFFFFF;">支付</a>
     <div class="closed" style="width: 100%;height: 100%;position: fixed;left: 0;top: 0;display: none"></div>
     <div class="reap">
         <div class="reapbox">
         <div class="reap_01">送货地址</div>
             <div class="reap_02k">
                 <div class="reapk">
                     <div class="kk" id="fhdzlist">
         </div>
         <div id="fhdzitem" style="display: none;">
                     <div class="reap_02" style="display: none;">
                 <div class="reap_02_div">
                     <div class="pull-left" style="padding-left: 20px;">
                         联系人:<input id="lxr" style="margin-left: 10px" placeholder="联系人">
                     </div>  
                     <div class="clear"></div>
                 </div>
                 <div class="reap_02_div">
                     <div style="padding-left: 6px;">
                         联系电话:<input id="lxhm" style="margin-left: 10px" placeholder="联系电话" maxlength="11" type="tel">
                     </div>
                     <div class="clear"></div>
                 </div>
                 <div class="reap_02_div">
                     <div style="padding-left: 6px;">
                         <div style="float: left;width: 25%;line-height: 60px">收货地址:</div><textarea style="float: left;width: 75%;margin-top: 18px" id="shdz" placeholder="收货地址"></textarea>
                     </div>
                     <div class="clear"></div>
                 </div>
         </div></div></div>
         </div>
         </div>
         <div class="reap_04">确认收货地址</div>
     </div>
     <div class="verify">
         <div class="verify_01">总金额:<label></label>元,应付定金：<span>1500.00</span>元：</div>
         <div class="verify_02">
             <ul>
<!--                  <li>微信支付</li> -->
                 <li>线下支付</li>
<!--                  <li>打欠条</li> -->
             </ul>
         </div>
         <a id="qrpay" class="reap_05 btn" style="border-radius: 0;font-size: 16px;color: #FFFFFF;background-color: #E03430;padding: 15px;display: none;">确认支付</a>
     </div>
<div id="copy_bottom" style="margin-bottom: 150px"></div>
     <div class="logo_container"></div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="trghjs/swiper-3.3.1.min.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/customer/uploadPingz.js${requestScope.ver}"></script>
<script type="text/javascript" src="cms/js/head.js${requestScope.ver}"></script>
<script type="text/javascript" src="trghjs/await.js${requestScope.ver}"></script>
</body>
</html>