<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div style="display: none;" id="item">
<div class="col-xs-12 col-sm-12 col-md-6 dataitem" style="border: 1px solid aqua;">
			<input type="hidden" id="sid">
			<input type="hidden" id="seeds_id">
			<input type="hidden" id="mps_id">
	<%@include file="../../employee/proinfo.jsp"%>
	<div style="border-bottom: 1px solid aqua;">
		<div class="col-xs-12 col-sm-12 col-md-6">
		<label style="float: left;">采购数量:</label>
		<input type="tel" class="num" id="pronum" data-num="num">
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
	<div class="col-xs-12 col-sm-12 col-sm-12">
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