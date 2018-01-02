<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<link rel="stylesheet" href="../pcxy/css/product.css?ver=002">
<%@include file="../res.jsp"%>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/directOrder.js${requestScope.ver}"></script>
</head>
	<style>
	@media(max-width:770px){
	.center_div{
	width:100%;
	}
	}
	@media(min-width:770px){
	.center_div{
	width:70%;
	margin:auto;
	}
	}

	</style>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../employee.do">员工首页</a></li>
			<li class="active"><span
				class="glyphicon glyphicon-triangle-right"></span>采购订货</li>
		</ol>
		<div class="header-title">
			员工-采购订货 <a href="../employee.do" class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
		<input type="hidden" id='accnIvt' value="${requestScope.accnIvt}">
	</div>
	<div class="center_div">
		<div class="ctn-fff box-ctn" style="min-height: 500px;">
			<div class="box-head" style="border:none">
			<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class=""><a>采购订货</a></li>
			<li class=""><a>已下采购订单</a></li>
			</ul>
			<div class="side-cover"></div>
			<div id="finding">
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
				</form>
			</div>
			</div>
			<div id="finded" style="display: none;">
		<div class="form">
		<form id="findForm">
			<div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px;" id="search">
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
			<div class="col-sm-6" style="margin-top:20px;height:30px;" id="rkDate">
				<div class="form-group m-t-b">
					<label for="" style="float:left; width:60px;margin-top:5px">查询日期</label>
					<input type="date" class="form-control input-sm Wdate" 
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
					style="float:left; margin-left:2%; width:28%;">
					<span style="float:left; margin-left:2%">~</span>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
					style="float:left; margin-left:2%; width:28%;">
				</div>
			</div>
		</form>
		</div>
		</div>
			</div>
			<!-- 列表区域 -->
			<div class="box-body">
				<div class="tabs-content" style="display: block;">
				<input type="checkbox" class="check" style="display: none;">
					<div class="ctn">
						<div style="display:none;" id="item">
						<div class="col-lg-6 col-sm-6">
              			<div class="p-ctn dataitem">
		                <div class="p-top">
		                <input type="hidden" id="item_id">
		                <input type="hidden" id="sid">
		                <input type="hidden" id="seeds_id">
		                <input type="hidden" id="mps_id">
		                  <div class="col-sm-6 col-xs-5 pimg-ctn" style="position:relative">
		                    <a><img class="img-responsive"></a>
    					<div class="pro-check" style="position:absolute;left:0;top:0;width:30px">
    					</div>
                  </div>
                  <div class="col-sm-6 col-xs-7 pmsg-ctn">
	              <ul style="margin-bottom:0">
	               <li style="margin-bottom:17px">
                    <span id="item_name"></span>
	               <div style="clear:both"></div>
	               </li>
	               <li style="margin-bottom:17px">
	                规格:<span id="item_spec" style="margin-left:5px"></span>
	                  <div style="clear:both"></div>
	               </li>
	               <li style="margin-bottom:17px">
	                型号:<span id="item_type" style="margin-left:5px"></span>
	                <div style="clear:both"></div>
	                </li>
	                <li style="display:none">
	                <span id="item_color"></span>
	                <div style="clear:both"></div>
	                </li>
	                <li style="margin-bottom:17px">
	                品牌:<span id="class_card" style="margin-left:5px"></span>
	                <div style="clear:both"></div>
	                </li>
	                <li style="display:none">
                    <span id="quality_class" style="width:100%;"></span>
	                <div style="clear:both"></div>
	                </li>
	               </ul>
                  </div>
                </div>
                <div class="p-middle">
                  <div class="p-form col-sm-6" style="margin-bottom:5px;" id="ddCost">
                    <label for="" style="margin-bottom:0;width:21%" data-number="n">单价</label>
                    <input type="tel" id="item_cost"  style="height: 30px;width: 66%;"><span id="casing_unit"></span>
                  </div>
                   <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="cgCost">
                    <label for="" style="margin-bottom:0;" data-number="n">单价</label>
                    <span id="item_cost"  style="height: 30px;width: 66%;"></span><span id="casing_unit"></span>
                  </div>
                    <div class="p-form col-sm-6" style="margin-bottom:5px">
                    <label for="" style="margin-bottom:0">订货数量</label>
                    <span id="hav_rcv"></span>
                   <div class="num-input-xs" id="dhsl">
                      <span class="sub"></span>
						<input type="text" class="num" id="pronum" data-number="n"> 
                      <span class="add"></span>
                    </div>
                  </div>
                   <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="ddzk">
                    <label for="" style="margin-bottom:0;width:21%" data-number="n">折扣</label>%
                    <input type="tel" id="discount_rate"  style="height: 30px;width: 66%;">
                  </div>
                    <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="cgzk">
                    <label for="" style="margin-bottom:0">折扣</label>
                    <span id="discountRate"></span>%
                  </div>
                  <div class="p-form col-sm-6" style="margin-bottom:5px">
                    <label for="" style="margin-bottom:0">金额</label>
                  <span style="float: left;">¥</span>
                  <span class="p-content red" id="sum_si" style="margin-top: 3px;"></span>
                  </div>
                  <div class="p-form col-sm-6" style="margin-bottom:5px">
                    <label for="" style="margin-bottom:0">供应商</label>
                     <span id="corp_sim_name"></span><input type="hidden" id="vendor_id">
                    <span id="weixinID" style="display: none;"></span>
                  </div>
                  <div class="p-form col-sm-6" style="margin-bottom:5px">
                    <label for="" style="margin-bottom:0">供应商电话</label>
                    <span id="movtel"></span>
                  </div>
                  <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="dhDate">
                    <label for="" style="margin-bottom:0">订货时间</label>
                    <span id="cgDate"></span>
                  </div>
                  <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="dhNo">
                    <label for="" style="margin-bottom:0">订货单号</label>
                    <span id="st_auto_no"></span>
                  </div>
                  <div class="p-form col-sm-6">
                    <span id="c_corp_sim_name"></span>
                  </div>
                  <button style="height: 28px; line-height: 0; margin-right: 0px;" class="btn btn-primary changGys" type="button">选择供应商</button>
                  <div class="p-form col-sm-6" style="margin-bottom:5px;display:none;" id="kdr">
                    <label for="" style="margin-bottom:0">经办人</label>
                    <span id="kd_name"></span>
                  </div>
                  <div class="p-form col-sm-6" id="cMemo" style="display:none;">
					<label for="" style="margin-bottom:0">备注</label>
					<span id="c_memo"></span>
				</div>
                </div>
              </div>
            </div>
            </div>
            <div id="item01"></div>
			</div>
			<div class="ctn">
	        <button class="btn btn-add" type="button">点击加载更多</button>
	        </div>
				</div>
                <div class="tabs-content" style="display: block;">
           		<div id="item01"></div>
       			<div class="ctn">
         			<button class="btn btn-add load" type="button">点击加载更多</button>
       			</div>
         </div>
            </div>
			</div>
		</div>
		<div class="back-top" id="scroll"></div>
		<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span> <input type="hidden"
			id="customer_id">
		<div class="btn-gp">
			<button class="btn btn-info" id="allcheck">全选</button>
			<button class="btn btn-info" id="saveOrder">提交</button>
			<button class="btn btn-info" id="delOrder" style="display:none;">删除</button>
			<a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
		</div>
	</div>

<div id="info" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">经办信息</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setReceivable">
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptId" type="hidden"  name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm dept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerk_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerkId" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="col-lg-6 col-sm-4 m-t-b">
			<div class="form-group">
				<label>备注</label>
				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="sure" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>