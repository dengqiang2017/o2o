<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div style="display: none;" id="item">
	<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
	<span id="item_id" style="display: none;"></span>
		<input type="hidden" id="seeds_id">
		<input type="hidden" id="price_display">
		<input type="hidden" id="price_prefer">
		<input type="hidden" id="price_otherDiscount">
		<%@include file="../../employee/proinfo.jsp" %>
		<div style="border-bottom: 1px solid aqua;">
		<div class="col-xs-6 col-sm-6 col-md-3">
			<label for="">促销:</label><span id='discount_ornot'></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-9">
			<label for="">时间:</label>
			<span id='discount_time_begin'></span><span>~</span><span id='discount_time'></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">单价</label>
			<input type="number" name="sd_unit_price" id="sd_unit_price" data-num="num2">
		</div>
		<div class="col-xs-6 col-sm-6 col-md-6">
			<label for="">单价￥</label><span id="sd_unit_price_o"></span>元
		</div>
		<div class="col-xs-6 col-sm-6 col-md-6">
			<label for="">数量</label><span id="sd_oq"></span>/<span class="item_unit"></span>
		</div>
		<div class="col-xs-6 col-sm-6 col-md-6">
			<label for="">折算数量</label><span id="sd_zsum"></span>/<span class="casing_unit"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">下单数量</label> 
			<input type="number" class="num" id="pronum" data-num="num2"> 
			<span class="item_unit"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">折算数量</label>
			<span id="pack_unit" style="display: none;"></span>
			<input type="number" class="zsum" data-num="num2" >
			<span id="casing_unit"></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6">
			<label for="sum_si">金额￥</label>
			<span id="sum_si"></span>元
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6">
			<label for="proName">订单状态</label>
			<span id="proName"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="ivt_oper_listing">单号</label>
			<span id="ivt_oper_listing"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="ivt_oper_listingMyPlan">计划单号</label>
			<span id="ivt_oper_listingMyPlan"></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6">
			<label for="use_oq">库存数</label>
			<span id="use_oq"></span>
			<span>(库存数不足时,<span id="qz_days"></span>天后发货)</span>
		</div>
		 <c:if test="${requestScope.moreMemo}">
		<div class="col-xs-12 col-sm-12 col-md-12">
             		<button type="button" class="btn btn-success" id="moreMemo">特殊工艺备注</button>
             		<span id="c_memo"></span>
             		<span id="memo_color"></span>
             		<span id="memo_other"></span>
              </div>
		 </c:if>
		</div>
	</div>
</div>