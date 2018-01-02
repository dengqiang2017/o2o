<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/tijianListClient.js${requestScope.ver}"></script>
<style type="text/css">
@media(max-width:770px){
.box-ctn{
display:none
}
}
@media(min-width:770px){
.box-ctn{
display: inline-block;
margin-bottom:0;
}
}
</style>
<div style="height: 40px;">
	<input type="hidden" value="${requestScope.autr}" id="autr">
	<input type="hidden" value="${requestScope.approval_step}" id="approval_step">
	<input type="hidden" id="customer_id" value="${requestScope.customer_id}">
	<input type="hidden" id="spNo" value="${requestScope.spNo}">
	<c:if test="${requestScope.auth.excel!=null}">
		<button type="button" class="btn btn-danger btn-sm m-t-b excel"
			onclick="excelExport('tijian');">导出</button>
	</c:if>
	<button type="button" class="btn btn-primary btn0"
		style="display: inline-block; margin-bottom: 0;">查询</button>
	<c:if test="${requestScope.spNo==null}">
		<button type="button" class="btn btn-primary" id="repairBtn">上报维修</button>
		<a class="btn btn-success btn-sm m-t-b" onclick="tijian.addTdHtml();">增加</a>
	</c:if>
	<c:if test="${requestScope.spNo!=null}">
		<button type="button" class="btn btn-primary" id="repairConfim">确认报修</button>
	</c:if>
	<c:if test="${requestScope.autr==1}">
		<button type="button" class="btn btn-primary" id="repairOver">已修复</button>
	</c:if>
</div>
<div class="box-body">
			<div class="table-responsive" id="box">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered" id="tab">
					<thead>
						<%@include file="tijianthead.jsp" %>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="box-footer" style="height: 40px;">
			<div class="pull-right" style="padding-top: 5px;">
<!-- 			<input type="text" id="page" value="0" style="width: 50px;"> -->
			总页数<span id="totalPage">${requestScope.pages.totalPage}</span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>
		</div>
    <div class="modal" id="mymodal">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">查询</h4>
    </div>
    <div class="modal-body">
    <div class="form">
    <form id="findForm">
    <div class="col-lg-12 col-sm-3">
    <label>位置大类</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="position_big">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>灯具名称</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="item_name">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>状态</label>
    <select class="form-control input-sm" id="workState">
    <c:if test="${requestScope.spNo==null}">
        <option value=""></option>
        <option value="运行">运行</option>
    </c:if>
    <c:if test="${requestScope.spNo!=null}">
        <option value="报修">报修</option>
    </c:if>
    <!--                                     <option value="采购">采购</option> -->
    <!--                                     <option value="审批">审批</option> -->
    <!--                                     <option value="支付">支付</option> -->
    <!--                                     <option value="配送">配送</option> -->
    </select>
    </div>
    <div class="col-sm-3 col-lg-12">
    <div class="form-group">
    <div class="input-group">
    <label>&nbsp;</label>
    <input type="text" class="form-control input-sm" maxlength="50" placeholder="请输入搜索关键词" id="searchKey"> <span class="input-group-btn">
    <button class="btn btn-success btn-sm find" style="margin-top: 26px" type="button">搜索</button>
    </span>
    </div>
    </div>
    </div>
    <div style="clear:both"></div>
    </form>
    </div>
    </div>
    <div class="modal-footer" >
    </div>
    </div>
    </div>
    </div>
  <%@include file="imgupload.jsp"%>
<script type="text/javascript">
<!--
$(function(){
	if(!IsPC()){
		var height=document.body.clientHeight;
		height=height-50-40-40;
		$(".box-body").css("height",height+"px");
		$("#tab").css("margin-bottom","5px");
		$("#box").css("height",(height-85)+"px");
	}
});
//-->
</script>