<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/repair-xiangqing.css${requestScope.ver}">
<div class="section-one">
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a>
               &emsp;用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span><span>订单详情</span></div>
<div class="section-one-container">
 <ul>
     <li>订单号：<span>${requestScope.info.ivt_oper_listing}</span></li>
     <li>发生日期：<span>${requestScope.info.so_consign_date}</span></li>
     <li>订单内容：</li>
     <c:forEach items="${requestScope.list}" var="item">
     <li>
     <input type="hidden" value="${item.item_id}">
         <div class="li-div-left">
                 <img class="img-responsive" src="${item.imgpath}">
         </div>
         <div class="li-div-right">
         <c:if test="${item.Status_OutStore=='已发货'}">
         <div class="pro-check" style="float:left;margin-top:5px"></div>
         </c:if>
                 <ul>
                     <li><b>${item.item_sim_name}</b></li>
                     <li>品牌:${item.item_spec}</li>
                     <li>型号:${item.item_type}${item.item_color}</li>
                     <li>数量:${item.sd_oq}${item.casing_unit}</li>
<%--                      <li>单价:${item.sd_unit_price}</li> --%>
                     <li>状态:${item.Status_OutStore}</li>
                 </ul>
         </div>
         <div class="clear"></div>
     </li>
     </c:forEach>
 </ul>
<%--  <h3 class="text-center text-primary">合计：<span style="font-size: 24px">${requestScope.info.sum_si}元</span></h3> --%>
</div>
    <div><div class="pro-check" id="allcheck" style="width:30px;float:left"></div><div style="line-height: 30px;">全选</div></div>
<c:if test="${requestScope.Status_OutStore=='已发货'}">
<button type="button" class="btn btn-primary center-block center-btn" id="qrsh">确认收货</button>
</c:if>
<c:if test="${requestScope.Status_OutStore=='待支付'||requestScope.Status_OutStore=='支付中'}">
<button type="button" id="orderpay" class="btn btn-primary center-block center-btn">去支付</button>
</c:if>
<button type="button" class="btn btn-primary center-block center-btn" onclick="backlist();">返回我的订单</button>
<script type="text/javascript">
<!--
$("#itempage").find("#orderpay").click(function(){
	var orderNo=event.data.orderNo;
	pop_up_box.loadWait();
	$.get("cashierPayment.do",{
		"orderNo":"${requestScope.orderNo}"
	},function(data){
		pop_up_box.loadWaitClose();
		$('a[data-title="title"]').html("我的订单-订单支付");
		$("#orderlist").hide();
		$("#itempage").html(data);
		$("a[data-head]").unbind("click");
		$("a[data-head]").click(backlist);
	});
});
$("#itempage").find("#allcheck").click(function(){
	var b=$(this).hasClass("pro-checked");
    if (b) {
    $("#itempage").find(".pro-check").removeClass("pro-checked");
    }else{
    $("#itempage").find(".pro-check").addClass("pro-checked");
    }
});
$("#itempage").find(".section-one-container").find(".pro-check").click(function(){
	var b=$(this).hasClass("pro-checked");
	if (b) {
		$(this).removeClass("pro-checked");
	}else{
		$(this).addClass("pro-checked");
	}
});
$("#itempage").find("#qrsh").click(function(){
	var t=$(this);
	var items=$("#itempage").find(".pro-checked");
	if(items&&items.length>0){
		var itemids=[];
		for (var i = 0; i < items.length; i++) {
			itemids.push($(items[i]).parents("li").find("input").val());
		}
		if(confirm("是否对勾选的商品进行收货操作!")){
		$.post("confimShouhuo.do",{
			"orderNo":"${requestScope.orderNo}",
			"itemids":"["+itemids.join(",")+"",
			},function(data){
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					backlist();
					myOrder.loadData();
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
		pop_up_box.showMsg("请至少选择一个产品进行收货!");
	}
});
//-->
</script>
</div>