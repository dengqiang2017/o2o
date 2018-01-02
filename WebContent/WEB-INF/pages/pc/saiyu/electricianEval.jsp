<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="../pc/saiyu/repair-pingjia.css${requestScope.ver}">
 <div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>
 &emsp;用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span><span>电工安装验收和评价</span></div>
 <input type="hidden" id="orderNo" value="${requestScope.orderNo}">
  <form class="fl">
  <div class="form-group">
      <textarea class="form-control" rows="9" placeholder="您的意见是我们前进的动力，请留下你的意见"><c:if test="${requestScope.map!=null}">${requestScope.map.yijian}</c:if></textarea>
      </div>
    <div class="section-container-pingjia">
    <ul>
    <li id="fwtd"><div class="col-lg-1 col-sm-2 col-xs-3" style="margin-top:3px;">服务态度</div><div class="col-lg-11 col-sm-10 col-xs-9"><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div><div class="star" style="width:30px;height:30px;float:left;"><img src="../pc/images/xing2.png" class="endranslate"></div></div></li>
    <div style="clear:both;"></div>
    </ul>
    </div>
      <a  class="btn btn-primary" style="position:relative;margin-top:20px;cursor: pointer;">上传照片
    <input type="hidden" name="typeImg" id="filePath">
    <input type="file" class="ct input-upload" name="pingjia" id="pingjia"
     onchange="imgUpload(this,'pingjia');" style="width:100%;height:100%">
    </a>
    <div id="showpingjia" style="margin-top:20px;margin-bottom:20px">
    <c:forEach items="${requestScope.list}" var="imgurl">
        <img src="../${imgurl}" onclick="javascript:evaluation.showImg(this)">
    </c:forEach>
    </div>
    <input type="hidden" value="eval" id="type">
    </form>
<button type="button" class="btn btn-primary center-block" id="postEval">确认验收并评价</button>
<button type="button" class="btn btn-primary center-block" onclick="javaScript:backlist();">返回我的订单</button>