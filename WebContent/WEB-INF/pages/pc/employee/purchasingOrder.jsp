<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
//采购订单
BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<head>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
@media(max-width:770px){
.center_div{width:100%;}
select{display: inline-block !important;width: 80% !important;}
}
@media(min-width:770px){
#c_memo{margin-bottom: -4px;}
#findForm label{float:left; width:auto;margin-top:2px}
#findForm .Wdate{float:left; margin-left:2%; width:38%;height:27px;}
.center_div{width:70%;margin:auto;}
#findForm .col-sm-3{width: 160px;}
#findForm select{width:121px;float:left;height:30px;}
#findForm .col-md-3{width: 200px;}
}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
	<div class="center_div">
		<div class="ctn-fff box-ctn" style="min-height: 500px;margin-bottom: 65px;">
			<div class="box-head" style="border:none">
			<%@include file="purchaseFind.jsp"%>
			</div>
			<!-- 列表区域 -->
			<div class="box-body">
				<div class="tabs-content" style="display: block;">
					<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">预计交货日期</label>
                		<input type="text" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" name="plan_end_date">
              		</div>
            	</div>
          	</div>
			<div class="ctn" id="list"></div>
			 <div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				<div class="tabs-content" style="display: block;">
				<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">预计交货日期</label>
                		<input type="text" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" name="plan_end_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">备注</label>
                		<input type="text" class="form-control input-sm" id="c_memoMain" maxlength="50">
              		</div>
            	</div>
          	</div>
				<div class="ctn" id="list"></div>
				<div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				 <div class="tabs-content" style="display: block;">
               <div class="ctn" id="list"></div>
	          <div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
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
		<label><input type="checkbox" id="allcheck" style="width: 20px;height: 20px;">全选 </label>
			<button class="btn btn-info" id="saveOrder">提交</button>
			<button class="btn btn-info" id="tzanpai" style="display: none;">通知安排物流</button>
			<a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
		</div>
	</div>
<%@include file="../smsweixinselect.jsp" %>
<div style="display: none;" id="houyun_Select">
	<!--<div class="modal-cover-first"></div>-->
	<div style="display:block;" class="modal-first">
		<div class="modal-dialog">
			<div class="modal-content modal-height" style="max-height:550px;overflow-y:scroll">
				<div class="modal-header">
					<button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span>
						<span class="sr-only">Close</span></button>
					<h4 class="modal-title">提交物流</h4>
				</div>
				<div style="padding: 10px;" class="modal-body">
					<form class="form-horizontal" style="margin-bottom: 20px">
					<span style="display: none;" id="item_id"></span>
					<span style="display: none;" id="st_auto_no"></span>
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">物流方式</label>
							<div class="col-lg-10" style="line-height: 30px">
								<select class="form-control">
									<option value="公司自提" selected="selected">公司自提</option>
									<option value="供应商配送">供应商配送</option>
								</select>
							</div>
						</div> 
						<div style="padding-left:8px;margin-bottom:5px;display: none;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">送货对象</label>
							<div class="col-lg-10" style="line-height: 30px">
								<select class="form-control">
									<option value="公司仓库" selected="selected">公司仓库</option>
									<option value="客户直接收货">客户直接收货</option>
								</select>
							</div>
						</div> 
						<div style="padding-left:8px;margin-bottom:5px;" class="form-group">
							<label class="col-lg-2 text-right" style="line-height: 30px">物流信息</label>
							<div class="col-lg-10" style="line-height: 30px">
								 <textarea  class="form-control" rows="5" cols="3" placeholder="送货地点,收货人姓名,联系电话等信息"  id="didian" ></textarea>
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
					<button class="btn btn-default" type="button">取消提交物流</button>
					<button class="btn btn-primary" type="button">确定提交物流</button>
				</div>
			</div> 
		</div> 
	</div> 
</div>
<!-- 数据展示模板 -->
<div style="display: none;" id="item">
<div class="col-xs-12 col-sm-12 col-md-6 dataitem" style="border: 1px solid aqua;">
			<input type="hidden" id="sid">
			<input type="hidden" id="seeds_id">
			<input type="hidden" id="mps_id">
	<%@include file="proinfo.jsp"%>
	<div style="border-bottom: 1px solid aqua;">
		<div class="col-xs-12 col-sm-12 col-md-6">
		<label>采购数量:</label>
		<input type="number" class="num" id="pronum" data-num="num">
	</div>
	<div class="col-xs-12 col-sm-12 col-md-6">
		<label>采购单价:</label>
		<input type="number" id="item_cost" data-num="num2">
	</div>

	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>采购数量:</label><span id="hav_rcv"></span>/<span class="item_unit"></span>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>采购单价:</label><span id="price"></span>元</span>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>订单数量:</label><span id="sd_oq"></span>/<span class="item_unit"></span>
	</div>
         	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>库存数量:</label><span id="use_oq"></span>/<span class="item_unit"></span>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>金额</label>
		<span>¥</span><span id="sum_si"></span>
	</div>
	<div class="col-xs-12 col-sm-6 col-md-6">
		<label>订单状态</label><span id="m_flag"></span>
	</div>
     <div class="col-xs-12 col-sm-12 col-md-6">
		<label>客户名称:</label> <span id="corp_sim_name"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-6">
		<label>客户电话:</label> <span id="movtel"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-6">
		<label>供应商名称:</label>
		<span id="gys_sim_name"></span>
		<span id="vendor_id" style="display: none;"></span>
	<span id="weixinID" style="display: none;"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-sm-6">
		<label>供应商电话:</label> <span id="gys_movtel"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-12">
		<label>销售订单单号:</label> <span id="ivt_oper_listing"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-12">
		<label>采购单号:</label> <span id="st_auto_no"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-12">
		<label>备注:</label> <span id="c_memo"></span>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-12">
	<label>采购备注:</label><input type="text" maxlength="150" id="c_memo_inp" style="width: 85%">
</div>
	<div class="clearfix"></div>
	</div>
	<div style="height: 30px;">
		<button type="button" class="btn btn-primary" id="cuidan"
		style="height: 28px; line-height: 0; margin-right: 0">催单</button>
		<c:if test="${sessionScope.auth.purchase_order_m_flag!=null}">
		<button type="button" class="btn btn-primary" id="comfirm"
		style="height: 28px; line-height: 0; margin-right: 0">审核</button>
		</c:if>
	<button type="button" class="btn btn-primary changGys"
		style="height: 28px; line-height: 0; margin-right: 0">选择供应商</button>
	<button type="button" class="btn btn-primary" id="zuofei"
		style="height: 28px; line-height: 0; margin-right: 0">作废</button>
	<button type="button" class="btn btn-primary" id="tongzhiwuliu"
		style="display: none; height: 28px; line-height: 0; margin-right: 0">提交物流方式</button>
	<button type="button" class="btn btn-primary" id="tongzhianpai"
		style="display: none; height: 28px; line-height: 0; margin-right: 0">通知安排物流</button>
	</div>
</div>
</div>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/purchasingOrder.js${requestScope.ver}"></script>
</body>
</html>