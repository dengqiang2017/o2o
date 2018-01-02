<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="res.jsp" %>
<link rel="stylesheet" href="../pc/cms/css/global.css">
<link rel="stylesheet" href="../pc/css/kefutc.css">
<link rel="stylesheet" href="../pcxy/css/product-o2o.css${requestScope.ver}">
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<link href="../lightSlider/css/base.css" rel="stylesheet">
<link rel="stylesheet" href="../lightSlider/css/lightSlider.css" />
<link rel="stylesheet" href="../lightSlider/css/prettify.css" />
<script src="../js_lib/jquery.lightSlider.min.js"></script>
<script type="text/javascript" src="../pc/js/headproduct.js"></script>
<script type="text/javascript" src="../pc/js/productDetailEwm.js${requestScope.ver}"></script>
    <style>
    @media(max-width:770px){
    .product-ctn{
    margin-top:60px;
    }
    }
    @media(min-width:780px){
    .product-ctn{
    margin-top:10px;
    }
    }
    </style>
</head>
<body>
<span style="display: none;" id=nowid>
<c:if test="${sessionScope.userInfo!=null}">
${sessionScope.userInfo.personnel.clerk_id}
</c:if>
<c:if test="${sessionScope.customerInfo!=null}">
${sessionScope.customerInfo.customer_id}
</c:if>
</span>
<script type="text/javascript">
<!--
function getFenxiangid(){
	var nowid=$.trim($("#nowid").html());
	if(nowid&&nowid!=""){
		var url=window.location.href;
		if(url.indexOf("fenxiangid")<0){
			window.location.href=url+"&fenxiangid="+nowid;
		}
	}
}
getFenxiangid();
//-->
</script>
    <div class="header">
      <div class="header-title">产品详细
      </div>
      <div class="header-logo"></div>
    </div>
    <div class="container" style="margin-bottom:30px">
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
           <div style="display: none;" id="com_id">${requestScope.product.com_id}</div>
    			<div class="product-name">${requestScope.product.item_name}</div>
    			<div class="product-value" style="display:none;">促销价:<span id="">&yen;</span></div>
                <div class="product-value" >单价:<span>&yen;</span><span id="item_zeroSell">
                <fmt:formatNumber type="number" value="${requestScope.product.sd_unit_price}" pattern="0.00"/></span></div>
                <div class="product-value" style="display:none;">批发价:<span id="item_Sellprice">&yen;
                <fmt:formatNumber value="${requestScope.product.item_Sellprice}" pattern="0.00"/></span></div>
                <div class="product-value" style="display:none;">协议价:<span id="">&yen;</span></div>
    			<div class="pstyle">
    				<span class="pstyle-label">规格</span><span class="pstyle-content">${requestScope.product.item_spec}</span>
    			</div>
    			<div class="pstyle">
                    <span class="pstyle-label">颜色</span><span class="pstyle-content">${requestScope.product.item_color}</span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">型号</span><span class="pstyle-content">${requestScope.product.item_type}</span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">品牌</span><span class="pstyle-content">${requestScope.product.class_card}</span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">质量等级</span><span class="pstyle-content">${requestScope.product.quality_class}</span>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">库存数</span><span class="pstyle-content" id="use_oq">${requestScope.product.use_oq}</span>
<%--                     <span>(如果库存数不足,供货周期为:<span>${requestScope.product.qz_days}</span>天)</span> --%>
                </div>
                
                <div class="pro-num">
                    <span class="pro-num-L">数量</span>
    <span class="pro-num-U" style="margin-left: 4.3%;">(${requestScope.product.item_unit})</span>
                    <div class="pro-num-I">
                        <span class="add">+</span>
                        <span class="sub">-</span>
                        <input type="tel" value="1" class="num">
                    </div>

                </div>
                <div class="pro-num">
                    <span class="pro-num-L">数量</span>
    <span class="pro-num-U" style="margin-left: 4.3%;">(${requestScope.product.casing_unit})</span>
                    <div class="pro-num-I">
                        <input type="tel" class="zsum" readonly="readonly">
                    </div>
                </div>
                <div class="pstyle">
                    <span class="pstyle-label">金额</span><span class="pstyle-content" id="cpje"></span>
                </div>
                <div class="ctn" style="margin-top:30px;line-height: 50px;">
                    <a class="btn btn-danger" id="orderpay">我要订购</a>
                  <!--  <a class="btn btn-danger" id="addShopping">加入购物车</a>
                    <a href="../pc/shopping.html" class="btn btn-danger">查看购物车</a>-->
                    <a class="btn btn-danger home_footer_left">在线咨询</a>
                </div>
    		</div>
    	</div>
    	<%--<div class="row">--%>
            <%--<ul class="pro-ad">--%>
<%--<!--                 <li><span>促销</span><p>订单满1000元，赠送***牌加湿器订单满1000元，赠送***牌加湿器</p></li> -->--%>
                <%--&lt;%&ndash;<li><span>分享</span><div id="fenxiang"></div><p style="display: none;">分享即可领取10元优惠券</p></li>&ndash;%&gt;--%>
            <%--</ul>--%>
        <%--</div>--%>
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
                        <span class="pro-para-content">${requestScope.product.item_name}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">型号:</span>
                        <span class="pro-para-content">${requestScope.product.item_type}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">重量单位:</span>
                        <span class="pro-para-content">${requestScope.product.item_unit_weight}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">包装单位:</span>
                        <span class="pro-para-content">${requestScope.product.casing_unit}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品类别:</span>
                        <span class="pro-para-content">${requestScope.product.type_name}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品来源:</span>
                        <span class="pro-para-content">${requestScope.product.item_style}</span>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
<!--                     <div class="pro-para-gp"> -->
<!--                         <span class="pro-para-label">产品编码:</span> -->
<%--                         <span class="pro-para-content" id="peijian_id">${requestScope.product.peijian_id}</span> --%>
<!--                     </div> -->
                    <div class="pro-para-gp">
                        <span class="pro-para-label">颜色:</span>
                        <span class="pro-para-content">${requestScope.product.item_color}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">品牌:</span>
                        <span class="pro-para-content">${requestScope.product.class_card}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">包装换算数量:</span>
                        <span class="pro-para-content" id="pack_unit">${requestScope.product.pack_unit}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">重量:</span>
                        <span class="pro-para-content">${requestScope.product.i_weight}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">有效期:</span>
                        <span class="pro-para-content">${requestScope.product.d_usefullife}</span>
                    </div>
                </div>
                <div class="col-lg-4 col-sm-6">
                    <div class="pro-para-gp">
                        <span class="pro-para-label">规格:</span>
                        <span class="pro-para-content">${requestScope.product.item_spec}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">结构:</span>
                        <span class="pro-para-content">${requestScope.product.item_struct}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产地厂家:</span>
                        <span class="pro-para-content">${requestScope.product.vendor_id}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">基本单位:</span>
                        <span class="pro-para-content">${requestScope.product.item_unit}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">产品用途:</span>
                        <span class="pro-para-content">${requestScope.product.goods_origin}</span>
                    </div>
                    <div class="pro-para-gp">
                        <span class="pro-para-label">质量等级:</span>
                        <span class="pro-para-content">${requestScope.product.quality_class}</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="tabs-content" style="margin-bottom:20px">
            <div class="pro-package">
                <span class="pro-package-label">包装内容:</span>
                <span class="pro-package-content"></span>
            </div>
        </div>
    </div>
    <div class="back-top" id="scroll"></div>
<div class="side_tools logo_container"></div>
<script type="text/javascript">
<!--
var pack=numformat(parseFloat($("#pack_unit").html()),0);
var use_oq=numformat(parseFloat($("#use_oq").html()),0);
$("#pack_unit").html(pack);
$(".zsum").val(pack);
$("#use_oq").html(use_oq);
if(use_oq==0){
	$("#use_oq").parent().hide();
}
$(".num").val(1);
$(".num").bind("input propertychange blur",function(){
	var item_zeroSell=parseFloat($("#item_zeroSell").html());
	var pack_unit=parseFloat($("#pack_unit").html());
	var val=parseFloat($.trim($(this).val()));
	if(val==""){
		val=0;
	}
	var num=0;
	if (val>0&&pack_unit!="0") {
		num=parseFloat(val)*parseFloat(pack_unit);
		if(!num){
			num=0;
		}
		$(".zsum").val(numformat(num,0));
	}
	$(".zsum").attr("readonly","readonly");
	$("#cpje").html("￥"+numformat2(num*item_zeroSell)+"元");
});
	var item_zeroSell=parseFloat($("#item_zeroSell").html());
	var num=parseFloat($(".zsum").val());
	$("#cpje").html("￥"+numformat2(num*item_zeroSell)+"元");
//-->
</script>
<div class="closed" style="width: 100%;height: 100%;position: fixed;left: 0;top: 0;display: none"></div>
<div id="mymodal" class="modal fade in" style="display: none; padding-right: 17px;" aria-hidden="false">
             <div style="margin: 150px auto;width: 85%" class="modal-dialog">
                 <div style="border-radius: 0" class="modal-content">
                     <div style="display: none" class="modal-header">
                         <button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                         <h4 class="modal-title">模态弹出窗标题</h4>
                     </div>
                     <div style="padding: 0" class="modal-body">
                         <div style="opacity:1;" id="kefulist" class="kefu">
                             <input type="hidden" value="客服" id="platformsHeadship">
                             <ul></ul>
                         </div>
                     </div>
                     <div style="display: none" class="modal-footer">
                         <button data-dismiss="modal" class="btn btn-default" type="button">关闭</button>
                         <button class="btn btn-primary" type="button">保存</button>
                     </div>
                 </div><!-- /.modal-content -->
             </div><!-- /.modal-dialog -->
         </div>
</body>
</html>

