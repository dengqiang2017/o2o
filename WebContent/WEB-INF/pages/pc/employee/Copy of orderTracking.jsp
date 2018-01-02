 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/order_gz.js${requestScope.ver}"></script>
</head>
	 <style>
	 @media(max-width: 770px){
	.xsmargin{
	 margin-bottom:40px;
	 }
	 }
	 ul>li{
	 list-style:none;
	 }
	 ul{
	  padding-left:0
	 }
	 </style>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>订单跟踪</li>
	</ol>
	<div class="header-title">员工-订单跟踪
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-body">
					<!-- 分客户 -->
					<div class="tabs-content">	
					<input type="hidden" id="emplHeadship" value="${sessionScope.userInfo.personnel.headship}">
					<input type="hidden" id="emplclerk_name" value="${sessionScope.userInfo.personnel.clerk_name}">
					<input type="hidden" id="isAutoFind" value="${sessionScope.isAutoFind}">
						<div class="ctn">
							<div class="folding-btn m-t-b">
					            <button type="button" class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button> 
					        </div>
					        <%@include file="../orderTrackingFind.jsp" %>
					        <div class="col-sm-12 m-t-b">
<!-- 				            	<button type="button" class="btn btn-danger btn-sm excel">导出</button> -->
				            	<c:forEach items="${requestScope.processName}" var="name">
				            	<button type="button" class="btn btn-danger btn-sm handle">${name}</button>
						   	 	</c:forEach>
				            	<button type="button" class="btn btn-danger btn-sm" id="showQian" style="display: none;">查看客户签字</button>
				            	<button type="button" class="btn btn-danger btn-sm" id="showPingjia" style="display: none;">查看评价</button>
				            	<button type="button" class="btn btn-danger btn-sm handle" title="产品没有或者不够时">下采购订单</button>
					        </div>
							<div class="text-center">
								<h3>订单跟踪</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th><div class="checkbox"></div></th>  
									       <th>客户</th>   
									       <th>产品简称</th>
									       <th>单价</th>
									       <th>订单数量</th>
									       <th>金额</th>
									       <th>库存数</th>
									       <th>基本单位</th>
									       <th>订货日期</th> 
									       <th>应收金额</th> 
									       <th>追溯</th> 
									       <th>状态</th> 
									       <th>订单号</th> 
									       <th style="display: none;">安装状态</th> 
									    </tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>

						    <div class="pull-right"> 
							    <button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
							    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
<%@include file="../smsweixinselect.jsp" %>
<div style="display: none;;" id="houyun_Select">
	<!--<div class="modal-cover-first"></div>-->
	<div style="display:block;" class="modal-first">
		<div class="modal-dialog">
			<div class="modal-content modal-height" style="max-height:450px;overflow-y:scroll">
				<div class="modal-header">
					<button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span>
						<span class="sr-only">Close</span></button>
					<h4 class="modal-title">通知拉货</h4>
				</div>
				<div style="padding: 10px;" class="modal-body">
					<form class="form-horizontal" style="margin-bottom: 20px">
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">物流方式</label>
							<div class="col-lg-10" style="line-height: 30px">
								<select class="form-control">
									<option value="公司配送" selected="selected">公司配送</option>
									<option value="供应商配送">供应商配送</option>
									<option value="客户自提">客户自提</option>
									<option value="第三方配送">第三方配送</option>
								</select>
							</div>
						</div>
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">司机信息</label>
							<div class="col-lg-10" style="line-height: 30px">
								<div class="input-group">
									<input type="text" class="form-control" maxlength="40" id="driverinfo">
                            <span class="input-group-btn">
                                <button type="button" class="btn btn-primary">浏览</button>
                            </span>
								</div>
							</div>
						</div>
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">提货地点</label>
							<div class="col-lg-10" style="line-height: 30px">
								<div class="input-group">
									<input type="text" class="form-control" maxlength="40" id="didian">
                            <span class="input-group-btn">
                                <button type="button" class="btn btn-primary">浏览</button>
                            </span>
								</div>
							</div>
						</div>
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">提货时间</label>
							<div class="col-lg-10" style="line-height: 30px">
									<input type="date" class="form-control Wdate" id="tihuoDate" maxlength="40" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false})" >
							</div>
						</div>
					</form>
					<div style="padding-left:20px;margin-bottom:5px;">
						<span style="font-size: 20px">请选择通知方式</span>
					</div>
					<div style="padding-left:20px;margin-bottom:5px;" class="ctn">
						<label class="radio-inline">
							<input type="radio" checked="checked" value="0" name="NoticeStyle"> 仅微信通知
						</label>
					</div>
					<div style="padding-left:20px;margin-bottom:5px;" class="ctn">
						<label class="radio-inline">
							<input type="radio" value="1" name="NoticeStyle"> 仅短信通知
						</label>
					</div>
					<div style="padding-left:20px;margin-bottom:5px;" class="ctn">
						<label class="radio-inline">
							<input type="radio" value="2" name="NoticeStyle"> 微信和短信通知
						</label>
					</div>
					<div style="padding-left:20px;margin-bottom:5px;" class="ctn">
						<label class="radio-inline">
							<input type="radio" value="3" name="NoticeStyle">不通知微信和短信
						</label>
					</div>
				</div>
				<div class="modal-footer xsmargin">
					<button class="btn btn-default" type="button">取消通知拉货</button>
					<button class="btn btn-primary" type="button">确定通知拉货</button>
				</div>
			</div> 
		</div> 
	</div> 
</div>

<div id="thdd_smsSelect" style="display: none;">
<div class="modal-cover-first" style="z-index: 99996;"></div>
<div class="modal-first" style="display:block;z-index: 99999;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">提货地点选择</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
				<label>提货地点选择列表</label>
					<ul>
					</ul>
<!-- 					<li><input type="radio" value="" name="thdd"><span></span><input type='button' value='删除'></li> -->
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<textarea rows="5" cols="5" style="width: 520px; height: 127px;"></textarea>
					<button type="button" class="btn btn-primary">增加提货地点到列表</button>
				</div>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div>
	</div>
</div>
</div>

</body>
</html>

    