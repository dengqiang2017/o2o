<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="modal_orderSelect" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">请选择销售订单流程</h4>
</div>
<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
	<ul class="modal_ul">
	<c:forEach items="${requestScope.processNames}" var="processName">
		<li>
		<div class="pro-check" style="width:30px;margin:auto"></div><span>${processName}</span>
		<div>
		<form>
		<div><input type="radio" name="chuli" value="处理" checked="checked">处理 </div>
		<div><input type="radio" name="chuli" value="查看">查看</div>
		</form>
		</div>
		</li>
	</c:forEach>
		<li>
		<div class="pro-check" style="width:30px;margin:auto"></div><span>收款确认</span>通知
		</li>
	</ul>
			</div>
			<div class="modal-footer">
	           <div class="pro-check" style="float:left" id="allchecked"><span style="line-height:30px;margin-left:30px">全选</span></div>
				<button type="button" class="btn btn-default guanbizhiwu" id="orderClose">取消</button>
				<button type="button" class="btn btn-primary guanbizhiwu" id="orderSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>