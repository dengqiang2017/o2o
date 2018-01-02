<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="modal_imgSelect" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">请选择订单跟踪中微信消息对应的logo图片</h4>
</div>
<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
	<ul class="modal_ul">
	<c:forEach items="${requestScope.imgs}" var="img">
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><img alt="" src="../weixinimg/${img}" style="max-height: 100px;max-width: 100px;">
	</li>
	</c:forEach>
	</ul>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default guanbizhiwu" id="imgClose">取消</button>
				<button type="button" class="btn btn-primary guanbizhiwu" id="imgSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>