<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
     <div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a> &emsp;用户中心-><span><a href="javaScript:backOrder();">我的订单</a>-></span><span>订单详情</span></div>
     <div class="section-container">
     <c:forEach items="${requestScope.listinfo}" var="info">
         <ul>
             <li>采购员：<span>${info.clerk_name}</span></li>
             <li>联系电话：<span>${info.movtel}</span></li>
             <li>收货地址：<span>赛宇物流中心C1仓库</span></li>
<!--              <li>要求到货时间：<span>2015-01-03 13:30</span></li> -->
             <li>采购时间：<span>${info.at_termDatetime}</span></li>
             <li>采购内容：<span id="orderInfo">产品名称:${info.item_name},采购数量:${info.rep_qty}</span></li>
             <li>采购状态:
             <c:if test="${info.m_flag==0}">未处理
             <button type="button" class="btn btn-primary" onclick="orderReceipt('${info.item_id}','${requestScope.st_auto_no}',2,this);">有货并准备发货</button>
             <button type="button" class="btn btn-primary" onclick="orderReceipt('${info.item_id}','${requestScope.st_auto_no}',3,this);">无货</button>
             </c:if>
             <c:if test="${info.m_flag==1}">已作废</c:if>
             <c:if test="${info.m_flag==2}">已处理有货</c:if>
             <c:if test="${info.m_flag==3}">已处理无货</c:if>
             </li>
<%--              <li>物流司机：<span>${info.HYS}</span></li> --%>
<!--              <li>赛宇客服：<span>028-8868878</span></li> -->
         </ul>
     </c:forEach>
     </div>
     <script type="text/javascript">
<!--
function orderReceipt(item_id,st_auto_no,type,t){
	pop_up_box.postWait();
	$.get("orderReceipt.do",{
		"item_id":item_id,
		"st_auto_no":st_auto_no,
		"type":type,
		"corp_name":"${requestScope.corp_name}",
		"orderInfo":$.trim($(t).parents("ul").find("#orderInfo").html())
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			pop_up_box.showMsg("提交成功!");
			if(type==2){
				$(t).parent().html("订单状态:已处理有货");
			}else{
				$(t).parent().html("订单状态:已处理无货");
			}
		} else {
			if (data.msg) {
				pop_up_box.showMsg("提交错误!" + data.msg);
			} else {
				pop_up_box.showMsg("提交错误!");
			}
		}
	});
}
//-->
</script>
    <button type="button" class="btn btn-primary center-block btn-size" onclick="backOrder();">返回订单列表</button> 
 