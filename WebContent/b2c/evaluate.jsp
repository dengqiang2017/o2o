<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getVer(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>评价</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<link rel="stylesheet" href="css/evaluate.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
      <a class="header_a" onclick="javascript:history.go(-1)" href="personal_center.jsp">返回</a>
      发表评价
  </div>
</nav>
<div class="container" style="margin-top: 50px;">
    <div style="padding-left: 0;padding-right: 0">
<div class="body_top">
    <div class="body_top_textarea">
<input type="hidden" id="orderNo">
<textarea rows="3" placeholder="分享你的购买心得..." id="yijian"></textarea>
<div class="body_top_position">
<div class="position_left">
<input type="hidden" name="typeImg" id="filePath"> 
<input type="file" class="ct input-upload" name="pingjia" id="pingjia" onchange="imgUpload(this,'pingjia');" style="width: 100%; height: 100%; cursor: pointer; position: absolute; left: 0; top: 0; opacity: 0;">
<input type="button" id="scpz" class="ct input-upload" style="width: 100%; height: 100%;cursor: pointer; position: absolute; left: 0; top: 0; opacity: 0; display: none;">
</div>
<div id="showpingjia" class="clearfix" style="float: left">

</div>
<div class="position_right">
    添加照片、视频<br>
    <span style="color: #FE4848">（上传照片加十五字好评可获得现金抵购卷哦！）</span>
            </div>

            <div class="clear"></div>
        </div>
    </div>
</div>
<div class="evaluate">
    <ul>
        <li id="spzl">
            <div style="margin-top:3px;float:left">商品质量：</div>
<div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div></div>
    <div class="clear"></div>
</li>
<li id="fwtd">
    <div style="margin-top:3px;float:left">服务态度：</div>
<div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div></div>
    <div class="clear"></div>
</li>
<li id="wlsd">
    <div style="margin-top:3px;float:left">物流速度：</div>
<div style="float:left;margin-left:10px"><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;margin-left: 5px"><img src="../pc/images/xing2.png" class="endranslate"></div></div>
            <div class="clear"></div>
        </li>
    </ul>
</div>
<!-- fotter-->
<p style="font-size: 16px;color: red;margin-left: 10px;">评价+晒单可得30金币</p>
<a class="btn btn-info center-block" style="width: 150px;margin-top: 20px;" id="postEval">
        提交评价 </a>
</div><div class="image-zhezhao" style="display:none">
<div style="width: 5%;float: left">
     <div class="img-left"></div>
</div>
 <div style="width: 90%;float: left;height: 100%;">
<div class="img-ku" style="float:left;">
        <div id="imshow">
        </div>
    </div>
</div>
<div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/evaluation.js${requestScope.ver}"></script>
</body>
</html>