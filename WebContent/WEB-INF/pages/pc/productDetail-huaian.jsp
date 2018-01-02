<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>产品详情</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<link rel="stylesheet" href="../pcxy/css/bootstrap.css${requestScope.ver}"> 
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <link rel="stylesheet" href="../pc/css/product_details.css"> <link rel="stylesheet" href="../pc/css/kefutc.css"> 
    <script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/huaianjs/huaian.js${requestScope.ver}"></script>
</head>
<body style="font-family: '微软雅黑';">
<div class="container" style="padding-right: 0;padding-left: 0">
<!-- header-->
   <div class="header">淮安通威
    <a href="../pc/personal_center.html" class="personal_center">
        <img src="../pc/images/01_user.png">
    </a>
       <a class="glyphicon glyphicon-chevron-left header_a" onclick="javascript:history.go(-1);"></a>
    </div>
    <div style="display: none;" id="com_id">${requestScope.product.com_id}</div>
    <div style="display: none;" id="item_id">${requestScope.product.item_id}</div>
<div class="product">
    <a class="pro-img">
        <img class="img-responsive" src="../pc/images/banner2.png">
    </a>
    <div class="pro-msg">
        <ul>
            <li style="text-align: center;">
                <div style="display: inline-block;">
                    <a id="item_name" class="name">${requestScope.product.item_name}</a>
                </div>
            </li>
            <li style="color: #F40936;text-align: center;margin-top: 20px">
                         <span id="sd_unit_price" style="display: none;"><fmt:formatNumber type="number" value="${requestScope.product.sd_unit_price}" pattern="0.00"/></span>
                         <span class="price" id="sd_unit_price_UP">
                         <span style="font-size: 35px;font-weight: bold;margin-left: 50px">¥</span>
                         <strong style="font-size: 35px;font-weight: bold">
                         <fmt:formatNumber type="number" value="${requestScope.product.sd_unit_price}" pattern="0.00"/></strong>
                             </span>
                         <span>/${requestScope.product.item_unit}</span>
            </li>
            <li class="li_margin" style="display: none;">
                <div class="col-xs-3" style="margin-top: 5px"><span style="font-size:17px;color:#000">单位：</span></div>
                <div class="col-xs-9">
                    <div class="xs_btn">
                        <div class="left">
                            <button type="button" class="">${requestScope.product.casing_unit}</button>
                        </div>
                        <div class="right btn_style" style="">
                            <button type="button">${requestScope.product.item_unit}</button>
                        </div>
                        <span id="pack_unit" style="display: none;">${requestScope.product.pack_unit}</span>
                        <input class="zsum" type="hidden">
                    </div>
                </div>
                <div class="clear"></div>
            </li>
            <li class="li_margin">
                <div class="col-xs-3" style="margin-top: 15px;"><span class="pro-num-L" style="width: 100%;text-align: left;color: #000;font-size: 17px;">数量：</span></div>
                <div class="col-xs-9">
                    <div class="pro-num-I" style="margin-left: 0">
                        <span class="add">+</span>
                        <span class="sub">-</span>
                 <input type="tel" class="num" id="pronum" data-number="n" value="1" style="text-align:center;height:100%;outline: none;border: none">
                    </div>
                </div>
                <div class="clear"></div>
            </li>
        </ul>
    </div>
</div>
    <script>window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"1","bdMiniList":["qzone","tsina","weixin","sqq"],"bdPic":"","bdStyle":"0","bdSize":"16"},"slide":{"type":"slide","bdImg":"2","bdPos":"right","bdTop":"163"}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];</script>
   <div class="details">
       <ul>
           <li>产品特点：</li>
           <li>1.经通威精心研制而成，富含鱼体健康快速生长所需的各种营养物质</li>
           <li>粉碎细度高。60目过筛率65%以上。</li>
           <li>塑料调质温度高，耐水性好，浪费少。</li>
           <li>适口性好。</li>
       </ul>
       <ul>
           <li>产品功效：</li>
           <li>1.配方平衡、抗营养因子少，鱼体健康，抗病力强。</li>
           <li>2.高温季节抗应激能力强。</li>
           <li>3.鱼体条形好，体色亮</li>
       </ul>
   </div>
    </div>
    <div class="modal fade" id="mymodal">
    <div class="modal-dialog" style="margin: 150px auto;width: 85%">
    <div class="modal-content" style="border-radius: 0">
    <div class="modal-header" style="display: none">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">模态弹出窗标题</h4>
    </div>
    <div class="modal-body" style="padding: 0">
    <div class="kefu" id="kefulist" style="opacity:1;">
    <input type="hidden" id="platformsHeadship" value="客服">
    <ul>

    </ul>
    </div>
    </div>
    <div class="modal-footer" style="display: none">
    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
    <button type="button" class="btn btn-primary">保存</button>
    </div>
    </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <div id="copy_bottom"></div>
    <!-- footer-->
    <div class="home_footer">
    <a class="home_footer_left" >
    <div class="footer_left_img">
    <img class="center-block" src="../pc/images/01_phone.png">
    </div>
    <span>客服</span>
    </a>
    <div class="home_footer_center">
    <span>合计：</span>
    <br>
    <span style="color: #8F0624;">¥</span><span style="color: #8F0624;" id="orderzje"></span>
    </div>
    <a class="home_footer_right" id="orderpay"  style="color: #FFFFFF">立即支付</a>
    <span style="display: none;" id="orderNo">${requestScope.product.ivt_oper_listing}</span>
    <div class="clear"></div>
    </div>
<script type="text/javascript">
<!--

    $('input').bind('focus',function(){
    $('.home_footer').css('position','static');
    $('#copy_bottom').css({'padding-bottom':'10px'});
    }).bind('blur',function(){
    $('.home_footer').css({'position':'fixed','bottom':'0'});
    $('#copy_bottom').css({'padding-bottom':'80px'});
    });
    document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
    $('input').blur();
    $('.home_footer').css('position','fixed');
    });
$(".num").bind("input propertychange blur",function(){
	jisunje();
});
/**
 * 计算金额
 */
function jisunje(){
	var sd_unit_price=parseFloat($.trim($("#sd_unit_price").html()));
	var num=parseFloat($.trim($(".num").val()));
	var sum_si=numformat2(productOrder.detailProductNum()*sd_unit_price);
	$("#orderzje").html(sum_si);
// 	$("#sd_unit_price_UP>strong").html(numformat2(sum_si/num));
}
var com_id=$.trim($("#com_id").html());
var item_id=$.trim($("#item_id").html());
$.get("../product/getImgUrl.do",{"item_id":item_id,"com_id":com_id},function(data){
	if (data.cps) {
		var name=data.cps[0];
		var imgUrl="../"+com_id+"/img/"+item_id+"/cp/"+name;
		$(".pro-img>img").attr("src",imgUrl);
	}
});
//单位切换
$('.xs_btn button').click(function(){
    var c=$(this).hasClass('btn_style');
    $('.xs_btn button').removeClass("btn_style");
    if (c) {
        $(this).removeClass("btn_style");
    }else{
        $(this).addClass("btn_style");
    }
    jisunje();
});
$(".add").click(function(){
	var num=parseFloat($(this).parent().find(".num").val());
	if (!num) {
		num=1;
	}
	$(this).parent().find(".num").val(num+1);
	$(this).parent().find(".num").blur();
	jisunje();
});
$(".sub").click(function(){
	var num=parseFloat($(this).parent().find(".num").val());
	if (!num||num=="0") {
		$(this).parent().find(".num").val(1);
	}else{
		if ((num-1)==0) {
			$(this).parent().find(".num").val(1);
		}else{
			$(this).parent().find(".num").val(num-1);
		}
	}
	$(this).parent().find(".num").blur();
	jisunje();
});
jisunje();
$("#orderpay").click(function(){
	 //1.1获取产品id,报价单号,下单数量,放入cookie中
	var num=parseFloat($.trim($(".num").val()));
	var zsnum=num;
	var sd_unit_price=$.trim($("#sd_unit_price_UP>strong").html());
	var index=$('.xs_btn button').index($(".btn-danger"));
	var pack_unit=$.trim($("#pack_unit").html());
	if (!pack_unit) {
		pack_unit=1;
	}
	if(index==0){//表示是件单位需要计算折算数量
		zsnum=num*pack_unit;
// 		sd_unit_price=numformat2((1/pack_unit)*sd_unit_price);
	}
	var productList=[];
	 var json={
			"com_id":com_id,
			"item_id":item_id,
			"orderNo":$("#orderNo").html(),
			"item_name":$("#item_name").html(),
			"pack_unit":$("#pack_unit").html(),
			"sd_unit_price":sd_unit_price,
			"zsum":num
	 };
	 productList.push(JSON.stringify(json));
	 //放入cookie中
	 $.cookie("productDetail","["+productList.join(",")+"]",{ path: '/', expires: 1 });
	 //1.2判断是否登录
	 $.get("../customer/getCustomer.do",function(data){
		 if(data){
	 //1.4已经登录就直接到支付页面
			 window.location.href="../pc/pay.html";
		 }else{
	 //1.3没有登录就去登录,登录后到支付页面
	 		 $.cookie("backurl","../pc/pay.html",{ path: '/', expires: 1 });
			 window.location.href="../pc/login.html";
		 }
	 });
});
//-->
</script>
</body>
</html>