<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="https://necolas.github.io/normalize.css/6.0.0/normalize.css">
<link rel="stylesheet" href="../ds/css/font-awesome.min.css">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.item{
height: 80px; border: 1px solid #F00;margin-top: 5px;
/* margin-left: 5px; */
}
</style>
</head>
<body>
<div class="container" style="margin-top: -94px;">
<div class="page-header" style="text-align: center;">
<ol class="breadcrumb pull-left">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
<h1>${requestScope.pageName}</h1></div>
<div>
<div class="col-xs-12 col-sm-6 col-md-4">
  <div class="form-group">
    <label for="exampleInputName2">优惠券发布时间</label>
    </div>
    <div class="col-xs-6 col-sm-6 col-md-6">
    <input type="date" id="d4311"
    class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" name="beginDate">
    </div>
    <div class="col-xs-6 col-sm-6 col-md-6">
    <input type="date" id="d4312" class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" name="endDate">
  </div>
</div>
<div class="col-xs-4 col-sm-4 col-md-2">
<div class="form-group">
    <label for="exampleInputName2">优惠券金额</label>
    <input type="tel" class="form-control" data-num="num" maxlength="5" id="amount" placeholder="输入优惠券金额">
  </div>
</div>
<div class="col-xs-8 col-sm-8 col-md-3">
  <div class="form-group">
    <label for="exampleInputEmail2">关键词</label>
    <input type="text" class="form-control" id="searchKey" maxlength="20" placeholder="请输入关键词">
  </div>
</div>
<div class="col-xs-12 col-sm-6 col-md-3" style="margin-top: 25px;">
<div class="form-group">
  <button type="button" class="btn btn-primary find">搜索</button>
  <c:if test="${sessionScope.auth.coupon_add!=null}">
  <button type="button" class="btn btn-primary add">增加</button>
  </c:if>
  </div>
</div>
</div>
<div id="list"></div>
		<div id="item" style="display: none;">
		<div class="col-xs-12 col-md-6 col-lg-4 item">
		<span id="ivt_oper_listing" style="display: none;"></span>
		<span id="type_id" style="display: none;"></span>
				<div class="col-xs-3 col-md-3 col-lg-4" style="height: 100%; background-color: #337ab7; color: white; padding-top: 5px;margin-left: -5px;">
					<div style="text-align: center;">
						￥<span style="font-size: 20px;" id="f_amount">5</span>
					</div>
					<div style="font-size: 10px; padding-top: 5px;text-align: center;">
						满<span id="up_amount">100</span>元可用
					</div>
				</div>
				<div class="col-xs-9 col-md-9 col-lg-8">
					<div style="padding-top: 10px;" id="type_name"></div>
					<div style="display: none;" id="type_id"></div>
					<div style="padding-top: 10px">
						<span style="font-size: 10px;"> <span id="begin_use_date">2017.04.05</span>~<span id="end_use_date">2017.05.05</span>
						</span> <span></span>
				<div class="pull-right" style="margin-right: -14px; margin-top: -4px;">
					<c:if test="${sessionScope.auth.coupon_edit!=null}">
					<button class="btn btn-info btn-xs edit">修改</button>
					</c:if>
					<c:if test="${sessionScope.auth.coupon_del!=null}">
					<button class="btn btn-info btn-xs del">删除</button>
					</c:if>
				</div>
					</div>
				</div>
			</div>
			</div>
<!-- 			增加编辑模态框 -->
	<div style="display: none;" class="modal-first">
		<div class="modal-dialog">
			<div class="modal-content modal-height"
					style="max-height: 450px; overflow-y: scroll">
				<div class="modal-header">
					<button data-dismiss="modal" class="close" type="button">
						<span aria-hidden="true">×</span> <span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">编辑优惠券</h4>
				</div>
				<div style="padding: 10px;overflow: hidden;" class="modal-body">
				<form>
				<input type="hidden" name="ivt_oper_listing">
				<div class="col-xs-6 col-sm-6 col-md-6">
					<div class="form-group">
						<label>优惠券金额</label>
							<input type="tel" class="form-control" name="f_amount" data-num="num"
								maxlength="5">
					</div>
				</div>
				<div class="col-xs-6 col-sm-6 col-md-6">
					<div class="form-group">
						<label>使用上限金额</label>
							<input type="tel" class="form-control" name="up_amount" data-num="num"
								maxlength="5">
					</div>
				</div>
				<div class="col-xs-12 col-sm-12 col-md-6">
					<div class="form-group">
					<label>使用时间段</label>
					</div>
				<div class="col-xs-6 col-sm-6 col-md-6">
				    <input type="date" id="d4301"
				    class="form-control Wdate"
				    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4302\')||\'2120-10-01\'}'})" name="begin_use_date">
				</div>
				<div class="col-xs-6 col-sm-6 col-md-6">
				   <input type="date" id="d4302" class="form-control Wdate"
				    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4301\')}',maxDate:'2120-10-01'})" name="end_use_date">
				</div>
				</div>
				<div class="col-xs-6 col-sm-6 col-md-6">
					  <div class="form-group">
					 	<label>
					  <input type="radio" name="typeid" checked="checked" value="cls">产品类别
					  <input type="radio" name="typeid" value="pro">产品</label>
						<div class="input-group">
							<input id="type_id" name="type_id" type="hidden">
						<span class="form-control input-sm" style="width: 200px;margin-top: 5px;" id="sort_name"></span>
						<span class="input-group-btn">
							<button class="btn btn-default btn-sm" type="button" id="cleartype">X</button>
						    <button class="btn btn-success btn-sm" type="button" id="cls">浏览</button>
						</span>
						</div>
				  	</div>
				</div>
				<div class="clearfix"></div>
				</form>
				</div>
				<div class="modal-footer xsmargin">
						<button class="btn btn-default" type="button" id="closedig">取消</button>
						<button class="btn btn-primary" type="button" id="save">保存</button>
					</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/couponRelease.js${requestScope.ver}"></script>
</body>
</html>