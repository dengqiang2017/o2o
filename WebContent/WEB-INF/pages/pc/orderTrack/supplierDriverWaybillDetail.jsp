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
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.min.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/fenjie.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript">
<!--
//1.判断是否登录
// $.get("../customer/getCustomer.do",function(data){
// 	 if(!data){
// 		//没有登录就去登录
// 		 $.cookie("backurl","/orderTrack/supplierDriverWaybillDetail.do?"+window.location.href.split("?")[1],{ path: '/', expires: 1 });
// 		 window.location.href="../pc/loginSupplier.html";
// 	 }
// });
//-->
</script>
</head>
	<style>
	    ul>li{
	   list-style:none;
	}
	</style>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title">
        <a  data-title="phone">提货产品单</a>
        <a class="header-back" style="margin-top: 5px" href="../supplier/supplier.do"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
</div>
<!----------------------secition------------------------->
<div class="secition-one">
    <div class="container">
<div class="secition-two">
    <div class="secition-two-2">
        <c:forEach items="${requestScope.list}" var="item">
        <ul style="border:1px solid #ddd">
			<div class="pro-check"></div>
            <li>订单编号：${item.ivt_oper_listing}</li>
<%--             <li>客户姓名：${item.corp_name}</li> --%>
<!--             <li>发货地址： -->
<%--             <c:if test="${item.FHDZ!=null}"> --%>
<%--             ${item.FHDZ} --%>
<%--             </c:if> --%>
<%--             <c:if test="${item.FHDZ==null}"> --%>
<%--             ${item.addr1} --%>
<%--             </c:if> --%>
<!--             </li> -->
            <li>产品名称：${item.item_name}</li>
            <li>型号：${item.item_type}</li>
			<c:if test="${item.item_spec!=null}">
            <li>堆垛：${item.item_spec}</li>
            </c:if>
            <li>数量：${item.sd_oq}${item.casing_unit}
            <span id="seeds_id" style="display: none;">${item.seeds_id}</span></li>
            <c:if test="${item.item_spec!=null}">
            <li>折算数量:${item.sd_oq/item.pack_unit}${item.item_unit}</li>
            </c:if>
            <li>司机:${item.HYS}</li>
            <li>车牌号:${item.Kar_paizhao}</li>
            <li>提货地点:${item.c_memo}</li>
            <div style="clear:both"></div>
        </ul>
        </c:forEach>
    </div>
</div>
		<div class="footer2" >
			<button type="button" class="btn bg-primary" id="tzfhgly">请点此确认产品出库</button>
		</div>
    </div>

</div>
<!--  margin-left:100px; -->

<script type="text/javascript">
<!--
$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
	var b=$(this).hasClass("pro-checked");
	if (b) {
		$(this).removeClass("pro-checked");
	}else{
		$(this).addClass("pro-checked");
	}
});
var se=$.trim($(".secition-two-2").html());
if(se==""){
	$(".footer2").html("该订单已出库!");
}
$("#tzfhgly").click(function(){
	var phs=$(".pro-checked");
	if(phs&&phs.length>0){
		var seeds_id="";
		for (var i = 0; i < phs.length; i++) {
			var ph=$(phs[i]).parent().find("#seeds_id").html();
			if(seeds_id==""){
			seeds_id=ph;
			}else{
			seeds_id=ph+","+seeds_id;
			}
		}
	if (confirm("是否确认出库!")) {
		pop_up_box.postWait();
		$.get("../supplier/noticeShippingManager.do",{
			"seeds_id":seeds_id,
			"new":"new",
			"processName":"库管装货",//"${requestScope.proName}",
			"type":"已发货",
			"m_flag":4,
			"addName":"description",
			"description":"您有订单产品装车出库，请注意收货并验收，届时将有司机联系您。点开消息查看清单并验收（此条信息重要，务请保留，直至收货验收完毕）",
			"msg":"您的货物已装车出库，请注意收货并验收",
			"shipped":"已发货"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					window.location.href="../supplier/supplier.do";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	}
	}else{
		pop_up_box.showMsg("请选择出库产品!");
	}
});
//-->

</script>
</body>
</html>