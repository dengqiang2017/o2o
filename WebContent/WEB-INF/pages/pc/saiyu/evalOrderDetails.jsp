<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>附近电工-订单详情</title>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/repair-xiangqing.css${requestScope.ver}">
</head>
<body>
<div class="section-one">
<div class="section-one-container">
 <ul>
     <li>订单号：<span>${requestScope.cusInfo.ivt_oper_listing}</span></li>
     <li>客户名称：<span>${requestScope.cusInfo.lxr}</span></li>
     <li>联系电话：<span>${requestScope.cusInfo.movtel}</span></li>
     <li>安装日期：<span><fmt:formatDate value="${requestScope.cusInfo.anz_datetime}" pattern="yyyy年MM月dd日HH点mm分" /></span></li>
     <li>安装地址：<span>${requestScope.cusInfo.address}</span></li>
     <li>订单内容：</li>
     <c:forEach items="${requestScope.orderlist}" var="item">
     <li>
         <div class="li-div-left">
                 <img class="img-responsive" src="${item.imgpath}">
         </div>
         <div class="li-div-right">
                 <ul>
                     <li><b>${item.item_sim_name}</b></li>
                     <li>品牌:${item.item_spec}</li>
                     <li>型号:${item.item_type}${item.item_color}</li>
                     <li>数量:${item.sd_oq}${item.casing_unit}</li>
                 </ul>
         </div>
         <div class="clear"></div>
     </li>
     </c:forEach>
 </ul>
 <h3 class="text-center text-primary">安装费用合计：<span style="font-size: 24px">${requestScope.cusInfo.confirm_je}元</span></h3>
</div>
<c:if test="${requestScope.cusInfo.dian_confirm_datetime==null&&requestScope.cusInfo.dian_complete_datetime==null}">
<button type="button" class="btn btn-primary center-block center-btn" id="cyanz">我要安装</button>
</c:if>
<c:if test="${requestScope.cusInfo.dian_confirm_datetime!=null&&requestScope.cusInfo.dian_complete_datetime==null}">
<button type="button" class="btn btn-primary center-block center-btn" id="confirmanz">确认安装</button>
</c:if>
<c:if test="${requestScope.cusInfo.dian_confirm_datetime!=null&&requestScope.cusInfo.dian_complete_datetime!=null}">
<button type="button" class="btn btn-primary center-block center-btn">安装已完成</button>
</c:if>
</div>
<script type="text/javascript">
$("#cyanz").click(function(){
	pop_up_box.postWait();
	$.get("cyanz.do",{
		"ivt_oper_listing":"${requestScope.cusInfo.ivt_oper_listing}",
		"Lat":Lat,
		"address":address,
		"Lng":Lng
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			pop_up_box.showMsg("提交成功!");
		} else {
			if (data.msg) {
				pop_up_box.showMsg("提交错误!" + data.msg);
			} else {
				pop_up_box.showMsg("提交错误!");
			}
		}
	});
});
$("#confirmanz").click(function(){
	pop_up_box.postWait();
	$.get("confirmanz.do",{
		"ivt_oper_listing":"${requestScope.cusInfo.ivt_oper_listing}"
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			pop_up_box.showMsg("提交成功!");
		} else {
			if (data.msg) {
				pop_up_box.showMsg("提交错误!" + data.msg);
			} else {
				pop_up_box.showMsg("提交错误!");
			}
		}
	});
});
</script>
</body>
</html>

