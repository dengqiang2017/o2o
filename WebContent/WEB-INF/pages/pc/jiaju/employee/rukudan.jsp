<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="item" style="display: none;">
	<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
		<input type="hidden" id="sid">
		<input type="hidden" id="seeds_id">
		<input type="hidden" id="mps_id">
		<%@include file="../../employee/proinfo.jsp" %>
		<div style="border-bottom: 1px solid aqua;">
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label for="">单价</label> 
				<input type="number" id="item_cost" data-num="num2">
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label for="">收货数量</label> 
				<input type="number" id="pronum" data-num="num2" name="rep_qty" >
				<input type="hidden" name="pack_unit" id="pack_unit">
			</div>
			<div class="col-xs-12 col-sm-6 col-md-4">
				<label for="">折扣</label> 
				<input type="number" maxlength="5" id="discount_rate" value="100"><span>%</span>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-8" id="gysselect">
			  	<div class="form-group">
			    	<label style="float: left;">供应商</label>
			    	<div class="input-group" style="float: left;width: 80%;">
						<span class="form-control input-sm" id="vendor_name" aria-describedby="basic-addon2"></span>
						<span class="input-group-addon clearSelect">X</span>
						<span class="input-group-addon gys" style="cursor: pointer;">浏览</span>
						<input class="corp_id" type="hidden" name="vendor_id" id="vendor_id">
					</div>
					<div class="clearfix"></div>
			  	</div>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-12" id="storeselect">
				<div class="form-group">
				<label style="float: left;">入货仓库</label>
			    	<div class="input-group" style="float: left;width: 75%;">
						<span class="form-control input-sm" id='store_struct_name' aria-describedby="basic-addon2"></span>
						<span class="input-group-addon clearSelect">X</span>
						<span class="input-group-addon store" style="cursor: pointer;">浏览</span>
						<input type="hidden" name="store_struct_id" id="storestructId">
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>单价</label><span id="price"></span>元
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>数量</label><span id="rep_qty"></span>/<span id="item_unit"></span>
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>折扣</label><span id="zk"></span>%
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>金额</label><span>¥</span><span id="st_sum"></span>元
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>采购数量</label><span id="cgsl"></span>/<span id="item_unit"></span>
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>订单状态</label><span id="m_flag"></span>
			</div>
			<div class="col-xs-6 col-sm-6 col-md-6">
				<label>采购单号</label><span id="cgno"></span>
			</div>
			
			<!-- 已入库产品供应商 -->
			<div class="col-xs-12 col-sm-6 col-md-6" id="vendor">
				<input type="hidden" id="vendor_id">
				<label>供应商</label><span id="corp_name"></span>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label>联系电话</label><span id="movtel"></span>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label for="">经办人</label><span id="kd_name"></span>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label>库存</label><span id="use_oq"></span>/<span id="item_unit"></span>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6">
				<label>入货仓库</label><span id="store_struct_name_r"></span>
				<input type="hidden" id="rhStore">
				<input type="hidden" id="stock_type">
			</div>
			<div class="col-xs-12 col-sm-6 col-md-6" id="store">
				<input id="st_auto_no" type="hidden">
				<label>收货日期</label><span id="storeDate"></span>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-6" id="rcvautono">
				<label for="">入库单号</label><span id="rcv_auto_no"></span>
			</div>
			<div class="col-xs-12 col-sm-12 col-md-12" id="cMemo">
				<label>备注</label><span id="c_memo"></span>
			</div><div class="clearfix"></div>
		</div>
	</div>
</div>