<%@ page language="java" contentType="text/html; charset=UTF-8"
			 pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <title>库管装货</title>
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/fenjie.css">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" type="text/css" href="../lightSlider/lightGallery.css">
	<style type="text/css">
	    ul>li{
	   list-style:none;
	}
	.gallery img{
	display: none;
	}
	</style>
</head>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title" style="color: white;">
    <span style="font-weight: bold;">提货产品单</span>
        <a class="header-back" style="margin-top: 5px;color: white;" href="../employee.do"><span class="glyphicon glyphicon-menu-left"></span>返回</a>
    </div>
</div>
<!----------------------secition------------------------->
<div class="secition-one">
    <div class="container">
<div class="secition-two">
    <div class="secition-two-2">
    <p style="color: red;">注意事项:请先核实司机信息无误后再装车发货!</p>
    <c:if test="${requestScope.list!=null}">
        <c:forEach items="${requestScope.list}" var="item">
        <ul style="border:1px solid #ddd">
        	<li><div class="pro-check"></div></li>
            <li><label>订单编号：</label><span>${item.ivt_oper_listing}</span>
            <span style="display: none;" id="Status_OutStore">${item.Status_OutStore}</span>
            <span style="display: none;" id="com_id">${item.com_id}</span>
            <span style="display: none;" id="item_id">${item.item_id}</span>
            </li>
            <li><label>客户名称：</label><span id="corp_sim_name">${item.corp_sim_name}</span></li>
            <li><label>产品名称：</label>${item.item_name}</li>
            <li><label>型号：</label>${item.item_type}</li>
            <li><label>颜色：</label>${item.item_color}</li>
            <c:if test="${item.item_spec!=null}">
            <li><label class="dui">规格：</label>${item.item_spec}</li>
            </c:if>
            <li><label>数量：</label>${item.sd_oq}${item.item_unit}
            <span id="seeds_id" style="display: none;">${item.seeds_id}</span></li>
            <c:if test="${item.item_spec!=null}">
            </c:if>
            <li class="zhes"><label>折算数量:</label>${item.sd_oq/item.pack_unit}${item.casing_unit}</li>
            <li><label>司机信息:</label>${item.HYS}</li>
            <li><label>车牌号:</label>${item.Kar_paizhao}</li>
            <li><label>提货地点:</label>${item.c_memo}</li>
            <li><label>收货信息:</label>${item.FHDZ}</li>
            <li><a  class="btn btn-info btn-sm showimg">看实物图</a><ul class="gallery"></ul></li>
        </ul>
        <div style="clear:both"></div>
        </c:forEach>
        <p style="color: red;">注意事项:请先核实司机信息无误后再装车发货!</p>
			<button type="button" class="btn bg-primary center-block" id="tzfhgly">请点此确认产品出库</button>
    </c:if>
    </div>
    <c:if test="${requestScope.list==null}">
    	<div class="clearfix"></div>
   		<div style="text-align: center;">${requestScope.msg}</div>
    </c:if>
  </div>
</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<!-- <script type="text/javascript" src="../pcxy/js/bootstrap.js"></script> -->
<!-- <script type="text/javascript" src="../js/common.js"></script> -->
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/hideMenuItems.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/near/driverWaybillDetail.js${requestScope.ver}"></script>
<script type="text/javascript" src="../lightSlider/lightGallery.min.js"></script>
</body>
</html>