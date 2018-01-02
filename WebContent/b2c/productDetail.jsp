<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
    <link rel="stylesheet" href="css/mui.min.css"/>
    <link rel="stylesheet" href="css/animate.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/commodity.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/imgshow.css${requestScope.ver}">
	<link rel="stylesheet" href="../lightSlider/css/base.css">
	<link rel="stylesheet" href="../lightSlider/css/lightSlider.css"/>
	<link rel="stylesheet" href="../lightSlider/css/prettify.css" />
	<link rel="stylesheet" href="css/lightbox.css">
  <div class="container">
            <div class="side-cover">
                <div class="amend_sex" onclick="event.cancelBubble = true">
                    <div class="amend_sex_top">
                        <div class="title">
                            <div class="pic">
                                <img src="images/banner4.jpg" id="item_sl_jpg">
                            </div>
                            <div class="word">
                                <ul>
                                    <li>￥<span id="price"></span></li>
                                    <li>库存<span id="use_oq">9999</span>件</li>
                                    <li>请选择：<span id="s_item_color">颜色</span><span id="item_id" style="display: none;"></span></li>
                                </ul>
                            </div>
                            <i class="fa fa-times-circle-o" aria-hidden="true"></i>
                            <div class="clearfix"></div>
                        </div>
                        <div class="check-hue">
                            <div class="check-hue-title">颜色</div>
                            <div class="check-hue-box">
                                <ul id="selectList" class="clearfix"></ul>
                            </div>
                        </div>
                        <div class="check-hue">
                            <div class="check-hue-title">规格</div>
                            <div class="check-hue-box">
                                <ul id="typeList" class="clearfix"></ul>
                            </div>
                        </div>
                        <div class="number">
                            <div class="pull-left">购买数量</div>
                            <div class="pull-right">
                                <div class="pro-num-I">
                                    <span class="add">+</span>
                                    <span class="sub">-</span>
                                    <input type="tel" value="1" class="num">
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                    <div class="amend_sex_bottom">
                        <div class="commodity_footerT">
                            <a class="join addShopping" style="display: ;">加入购物车</a>
                            <a class="buy orderpay" style="display: ;">立即购买</a>
                            <a class="confim" style="display: none;">确定</a>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                </div>
            </div><!--------商品详情-------><div class="commodity">
                    <div class="product-imgPC">
                        <ul id="imageGallery" class="gallery list-unstyled">
                        </ul>
                    </div>
                    <div class="product-imgPH">
                        <ul id="fade" class="gallery list-unstyled clearfix">
                        </ul>
                        <div class="shopping_cart">
                            <a href="shopping_cart.jsp"><img src="images/gwc.png" class="center-block"></a>
                        </div>
                        <div class="shopping_back">
                            <a><img src="images/shopback.png" class="center-block"></a>
                        </div>
                    </div>

                    <!----产品介绍-->
                    <div class="commodity_word">
                        <div class="commodity_word_title" id="item_name"></div>
                        <div class="commodity_word_bottom">
                            <div class="word">￥<span id="sd_unit_price"></span>
                            <div class="pull-right" id="moreColor" style="display: none;">
<!--                             	<a href="../bztrgh/product.html">定制</a> -->
                            	<a class="btn btn-info" id="memo">特殊工艺备注</a>
                            	<span id="memo_color" style="display: none;"></span>
                            </div>
                            </div>
                            <div class="wordT">价格￥<span id="price_display" style="text-decoration:line-through;"></span></div>
                            <div class="word">分享该产品给微信好友即可得<span id="fenx_jinbi">30</span>金币</div>
                            <div class="words">
                                <div class="express" style="font-size: 12px;">快递:<span iid="AZTS_free" style="font-size: 12px;">10.00</span></div>
                                <div class="pin" style="font-size: 12px;">月销<span iid="salesVolume" style="font-size: 12px;">100</span>笔</div>
                                <div class="site" style="font-size: 12px;">四川成都</div>
                            </div>
                            <div class="clearfix"></div>
                        </div>
       <div class="delivery">
                    <div class="pull-left">选择 颜色分类:<span id="sctxt"></span></div>
                    <div class="pull-right">
                        <img class="img-responsive" src="images/backRight.png">
                    </div>
                    <div class="clearfix"></div>
        </div>
      <div class="commodity_footer">
                <div class="footer_left">
                      <a id="chat" href="chat.jsp?com_id=001Y10">
				<img src="images/wangwang.png">
                       <span>客服</span>
                      </a>
                </div>
                <div class="footer_right">
                    <a class="join">加入购物车</a>
                    <a class="buy">立即购买</a>
                </div>
                <div class="clearfix"></div>
            </div>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <ul class="nav nav-tabs" style="margin-top:10px;">
                    <li class="active"><a>产品详细</a></li>
                    <li><a>规格参数</a></li>
                    <li><a>产品评价</a></li>
                </ul><div class="tabs-content">
                    <div class="pro-img">
                        <ul> 
                        </ul>
                    </div>
                </div><div class="tabs-content">
                    <ul>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">产品名称:</span>
                                <span class="pro-para-content" id="itemName"> </span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">型号:</span>
                                <span class="pro-para-content" id="item_type"></span>
                            </li>
                            <li class="pro-para-gp" style="display: none;">
                                <span class="pro-para-label">重量单位:</span>
                                <span class="pro-para-content"></span>
                            </li>
                            <li class="pro-para-gp" style="display: none;">
                                <span class="pro-para-label">包装单位:</span>
                                <span class="pro-para-content" id="casing_unit">元起/套</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">产品类别:</span>
                                <span class="pro-para-content" id="typeName"></span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">产品来源:</span>
                                <span class="pro-para-content" id="item_style">主营产品</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">颜色:</span>
                                <span class="pro-para-content" id="item_color"></span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">品牌:</span>
                                <span class="pro-para-content" id="class_card">牵引</span>
                            </li>
                            <li class="pro-para-gp" style="display: none;">
                                <span class="pro-para-label">包装换算数量:</span>
                                <span class="pro-para-content" id="pack_unit">1</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">重量:</span>
                                <span class="pro-para-content" id="i_weight"></span>
                            </li>
                            <li class="pro-para-gp" style="display: none;">
                                <span class="pro-para-label">有效期:</span>
                                <span class="pro-para-content"></span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">规格:</span>
                                <span class="pro-para-content" id="item_spec">单机/网络</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">结构:</span>
                                <span class="pro-para-content" id="item_struct"></span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">产地厂家:</span>
                                <span class="pro-para-content" id="vendor_name">牵引软件</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">基本单位:</span>
                                <span class="pro-para-content" id="item_unit"></span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">产品用途:</span>
                                <span class="pro-para-content" id="goods_origin">自制</span>
                            </li>
                            <li class="pro-para-gp">
                                <span class="pro-para-label">质量保障:</span>
                                <span class="pro-para-content" id="quality_class"></span>
                            </li>
                    </ul>
                </div><div class="tabs-content">
                <div id="pingjiaitem" style="display: none;">
                            <li>
                               <div class="evaluation_name clearfix"><span id="name" style="float: left;margin-top: 4px;margin-right: 10px;    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    max-width: 50px"></span>
                               <div id="xinxin" style="float: left;">
                               </div>
                               </div>  
                                <div class="evaluation_word" id="yijian"></div>
                                <div class="evaluation_time">
                                    <div class="time"></div>
<!--                                     <div class="color">颜色分类：T66012-6</div> -->
                                    <div class="clearfix"></div>
                                </div>
                                <div class="evaluation_pic">
                                <div id="pingjia">
                                
                                </div>
                                    <div class="clearfix"></div>
                                </div>
                            </li>
                </div>
                    <div class="product_evaluation_list">
                        <ul>
                        </ul>
                    </div>
                </div></div>
    <div class="modal fade" id="mymodal" aria-hidden="true" style="display: none;">
        <div class="modal-dialog" style="margin: 150px auto;width: 85%">
            <div class="modal-content">
                <div class="modal-header" style="display: none">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title">模态弹出窗标题</h4>
                </div>
                <div class="modal-body" style="padding: 0">
                    <div class="kefu" id="kefulist" style="opacity:1;">
                        <input type="hidden" id="platformsHeadship" value="业务员">
                        <h3><a href="chat.jsp" target="_blank">联系客服</a></h3>
                        <ul><li><span>邓管理</span><a href="tel:18224052021">18224052021</a><div class="clear"></div></li></ul>
                    </div>
                </div>
                <div class="modal-footer" style="display: none">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>
    <div class="image-zhezhao" style="display:none">
        <div class="img-left"></div>
        <div class="img-ku">
            <div id="imshow">
            <img src="">
            </div>
        </div>
        <div class="img-right"></div>
    <div class="gb" id="closeimgshow"></div>
</div><div class="back-top" id="scroll"></div>
<script type="text/javascript" src="../js_lib/jquery.lightSlider.min.js"></script>
<script type="text/javascript" src="js/lightbox.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixinShare.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script> 
<script type="text/javascript" src="js/commodity.js${requestScope.ver}"></script>
</body>
</html>