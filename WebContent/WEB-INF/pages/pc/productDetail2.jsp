<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/product.css">
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/productDetail.js${requestScope.ver}"></script>
<!-- 主流浏览器支持视频 <video src="video.mp4" width="320" height="240" controls autobuffer></video>-->
<link href="../lightSlider/css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../lightSlider/css/lightSlider.css" />
<link rel="stylesheet" href="../lightSlider/css/prettify.css" />
<script src="../js_lib/jquery.lightSlider.min.js"></script>
</head>
<body>
    <div class="header">
      <div class="header-title">产品详细
      </div>
      <div class="header-logo"></div>
    </div>
    <div class="container"> 
    	<div class="product-ctn">
    		<div class="product-img product-img01">
                <ul id="imageGallery" class="gallery list-unstyled">
                </ul>
            </div>
            <div class="product-img product-img02">
                <ul id="fade" class="gallery list-unstyled clearfix">
                </ul>
            </div>

    		<div class="product-text">
    			<div class="product-name" id="item_name"></div>
    			<div class="product-value" style="display:none;">促销价:<span id="">&yen;</span></div>
                <div class="product-value" style="display:none;">单价:<span id="item_zeroSell">&yen;</span></div>
                <div class="product-value" style="display:none;">批发价:<span id="item_Sellprice">&yen;</span></div>
                <div class="product-value" style="display:none;">协议价:<span id="">&yen;</span></div>
    			<div class="pstyle">
    				<span class="pstyle-label">规格</span><span class="pstyle-content" id="item_spec"></span>
    			</div>
    			<div class="pstyle">
                    <span class="pstyle-label">颜色</span><span class="pstyle-content" id="item_color"></span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">型号</span><span class="pstyle-content" id="item_type"></span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">品牌</span><span class="pstyle-content" id="class_card"></span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">质量等级</span><span class="pstyle-content" id="quality_class"></span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">库存数</span><span class="pstyle-content" id="use_oq"></span>
                    <span>(如果库存数不足,供货周期为:<span id="qz_days"></span>天)</span>
                </div>
                <div class="pro-num">
                    <span class="pro-num-L">数量</span>
                    <input type="text" class="pro-num-I" value="1" data-number="num">
                    <span class="pro-num-U" id="casing_unit">件</span>
                </div>
    		</div>
    	</div>
        <ul class="nav nav-tabs" style="margin-top:20px;">
          <li role="presentation"><a>产品详细</a></li>
          <li role="presentation"><a>规格参数</a></li>
          <li role="presentation"><a>包装售后</a></li>
        </ul>
        <div class="tabs-content">
            <div class="pro-img"> 
            </div> 
        </div>
        <div class="tabs-content">
            <div class="pro-parameter">
                <div class="col-lg-4 col-sm-6">
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品名称:</span>
                        <span class="pro-para-content" id="item_name"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">型号:</span>
                        <span class="pro-para-content" id="item_type"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">重量单位:</span>
                        <span class="pro-para-content" id="item_unit_weight"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">包装单位:</span>
                        <span class="pro-para-content" id="casing_unit"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品类别:</span>
                        <span class="pro-para-content" id="type_name"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品来源:</span>
                        <span class="pro-para-content" id="item_style"></span>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品编码:</span>
                        <span class="pro-para-content" id="peijian_id"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">颜色:</span>
                        <span class="pro-para-content" id="item_color"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">品牌:</span>
                        <span class="pro-para-content" id="class_card"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">包装换算数量:</span>
                        <span class="pro-para-content" id="pack_unit"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">重量:</span>
                        <span class="pro-para-content" id="i_weight"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">有效期:</span>
                        <span class="pro-para-content" id="d_usefullife"></span>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="pro-para-gp">
                        <span class="pro-para-label">规格:</span>
                        <span class="pro-para-content" id="item_spec"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">结构:</span>
                        <span class="pro-para-content" id="item_struct"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产地厂家:</span>
                        <span class="pro-para-content" id="vendor_id"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">基本单位:</span>
                        <span class="pro-para-content" id="item_unit" ></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品用途:</span>
                        <span class="pro-para-content" id="goods_origin"></span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">质量等级:</span>
                        <span class="pro-para-content" id="quality_class"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="tabs-content">
            <div class="pro-package">
                <span class="pro-package-label">包装内容:</span>
                <span class="pro-package-content"></span>
            </div>
        </div>
    </div>
    <div class="back-top" id="scroll"></div>

    <div class="footer">
    <c:if test="${sessionScope.userInfo!=null}">
    	  员工:${sessionScope.userInfo.user_id}
    </c:if>
    <c:if test="${sessionScope.customerInfo!=null}">
     	 客户: ${sessionScope.customerInfo.user_id}
    </c:if>
      <span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
      <c:if test="${sessionScope.userInfo==null&&sessionScope.customerInfo==null}">
      <button class="btn btn-info" id="saveOrder_no">提交</button>
      </c:if>
        <a href=javascript:history.go(-1); class="btn btn-primary">返回</a>
      </div>
    </div>
</body>
</html>

