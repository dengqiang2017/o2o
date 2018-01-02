<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${requestScope.order!=null}">
	<ul class="nav nav-tabs" style="margin-top: 10px;">
		<c:if test="${requestScope.order=='order'}">
			<li class="active"><a>直接新增订单</a></li>
		<c:if test="${requestScope.orderplan}">
			<li><a>根据计划下订单</a></li>
		</c:if>
		<c:if test="${!requestScope.orderplan}">
			<li><a>根据计划下订单</a></li>
		</c:if>
			<li><a>待支付订单</a></li>
		</c:if>
		<c:if test="${requestScope.order=='add'}">
			<li class="active"><a>增加品种</a></li>
			<li><a>已增加品种</a></li>
		</c:if>
		<c:if test="${requestScope.order=='plan'}">
			<li class="active"><a>下计划</a></li>
			<li><a>编辑当天计划</a></li>
		</c:if>
	</ul>
</c:if>
	<div class="side-cover"></div>
	<div id="finding">
	<%@include file="employee/find.jsp" %>
</div>
<c:if test="${requestScope.order=='order'}">
	<div id="findplan" style="display: none;">
	<div class="form">
		<form id="findForm">
			<div class="col-sm-6">
				<div class="form-group m-t-b">
					<label for="" style="float:left; width:40px;">计划日期</label>
					<input type="date" class="form-control input-sm Wdate" value="${requestScope.beginTime }"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',isShowClear:false})" 
					style="float:left; margin-left:2%; width:40%;">
					<span style="float:left; margin-left:2%">~</span>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',isShowClear:false})" 
					style="float:left; margin-left:2%; width:40%;">
				</div>
			</div>
			<div class="col-sm-12">
				<p>时间段以${requestScope.time}为起始和结束时间</p>
			</div>
			<div class="col-sm-6">
				<div class="form-group m-t-b" style="clear:both; margin-top:5px;">
					<input type="text" class="form-control input-sm" style="float:left; margin-left:2%; width:50%;" placeholder="请输入搜索关键词" id="plangjc">
					<button type="button" class="btn btn-primary btn-sm find"  style="float:left; margin-left:2%;" >搜索</button>
				</div>
			</div>
		</form>
	</div>
</div>
</c:if>
	<div id="finded" style="display: none;">
	<div class="form">
		<form id="findForm">
			<div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px">
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control input-sm" maxlength="50"
							placeholder="请输入搜索关键词" id="searchKey"> <span
							class="input-group-btn">
							<button class="btn btn-success btn-sm find" type="button">搜索</button>
						</span>
					</div>
				</div>
			</div>
			<input type="hidden" id="page" name="page" value="0">
			<input type="hidden" id="totalPage" value="0">
		</form>
	</div>
</div>

