<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<ul class="nav nav-tabs" style="margin-top: 10px;">
	<li class="active"><a>根据销售订单数下采购订单</a></li>
	<li class=""><a>直接下采购订单</a></li>
	<li class=""><a>已下采购订单跟踪</a></li>
	</ul>
	<div class="side-cover"></div>
	<div id="finding">
	<div class="form">
		<form id="findForm">
			<div class="col-sm-4 col-lg-3 m-t-b" >
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
		</form>
	</div>
</div>
	<div id="findplan" style="display: none;">
	<%@include file="find.jsp" %>
</div>
	<div id="finded" style="display: none;">
	<div class="form">
		<form id="findForm">
		<div class="col-xs-12 col-sm-4 col-md-4" style="margin-top: 10px;">
				<div class="form-group m-t-b">
					<label for="">订单日期</label>
					<input type="date" class="form-control input-sm Wdate"  
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
				</div>
			</div>
		<div class="col-xs-12 col-sm-3 col-md-3" style="margin-top:10px">
				<div class="form-group m-t-b">
					<label for="">订单状态</label>
					<select id="m_flag"  class="form-control input-sm">
					<option value=""></option>
					<option value="6">未审核</option>
					<option value="0">未处理</option>
					<option value="2">已处理有货</option>
					<option value="3">已处理无货</option>
					<option value="9">已安排物流</option>
					<option value="4">已发货</option>
					<option value="5">已收货</option>
					</select>
				</div>
			</div>
			<div class="col-xs-12 col-sm-4 col-md-4 m-t-b" style="margin-top: 10px;">
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
		</form>
	</div>
</div>
