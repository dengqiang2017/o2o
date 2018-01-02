<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" content="-1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>上传定位</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script charset="utf-8" src="http://res.wx.qq.com/open/js/jweixin-1.1.0.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
    <script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp"></script>
</head>
  <style>
      .section{
          padding: 0 30px;
      }
  </style>
<body>
<!--------section--------->
<div class="section">
    <div class="row">
        <div class="col-xs-12">
            <div class="center-dt" id="container" style="height: 200px;background-color: #000;margin-top: 20px"></div>
            <div id="address" style="margin-top:20px">当前位置:</div>
        </div>
    </div>
    <div class="row" style="padding:20px 0">
        <div class="col-xs-4">订单号：</div>
        <div class="col-xs-8"><span id="orderNo">${requestScope.ivt_oper_listing}</span></div>
    </div>
    <div class="row" style="margin-bottom:30px">
        <div class="col-xs-4">订单内容：</div>
        <div class="col-xs-8">
        <c:forEach items="${requestScope.list}" var="item">
            <p><span>${item.item_sim_name},数量:${item.sd_oq}/${item.casing_unit}</span></p>
        </c:forEach>
        </div>
    </div>
</div>
<!------footer-------->
<input type="hidden" id="customer_id" value="${requestScope.customer_id}">
<a class="btn btn-primary" id="dingwei" style="position: fixed;bottom: 10px;left: 30px;width: 85%">上传定位</a>
<script type="text/javascript" src="../pc/js/saiyu/evalUpAdress.js${requestScope.ver}"></script>
<script type="text/javascript">
init('${requestScope.lat}','${requestScope.lng}','${requestScope.corp_sim_name}');
</script>
</body>
</html>