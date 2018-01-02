<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div style="display: none;">
	<div class="p-ctn" id="item">
		<input type="hidden" id="item_id">
		<div class="p-img">
<!-- 			<a href="#"><img class="pimg" src="image/morencp.png" alt=""></a> -->
		</div>
		<div class="p-msg">
			<div class="p-top">
				<div class="pro-check">
<!-- 					<input type="checkbox" class="check"> -->
				</div>
				<div class="pmsg-ctn">
					<span class="p-name" id="item_name"></span>
					<div class="ctn" style="display: none;">
						<span class="p-class" id="item_spec"></span> 
						<span class="p-class" 
							id="item_type"></span> 
							<span class="p-class" id="item_color" ></span>
						<span class="p-class" id="class_card" ></span>
						 <span class="p-class" id="quality_class" style="width: 100%;"></span>
					</div>
				</div>
			</div>
			<div class="p-middle">
			<input type="hidden" id="sd_unit_price">
			<input type="hidden" id="price_display">
			<input type="hidden" id="price_prefer">
			<input type="hidden" id="price_otherDiscount">
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">类别</label> <span class="p-content" id="price_type"></span>
				</div>
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">促销</label> <span class="p-content"
						id="discount_ornot"></span>
				</div>
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">时间</label> <span class="p-content-xs"
						id="discount_time_begin"></span> <span class="p-xs-m">~</span> <span
						class="p-content-xs" id="discount_time"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">单价</label> <span class="p-content-xs red"
						id="sd_unit_price_DOWN"></span> <span class="p-xs-m">~</span> <span
						class="p-content-xs red" id="sd_unit_price_UP"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">数量</label> <input type="text" class="p-xs num"
						data-number="n"> <span id="pack_unit"
						style="display: none;"></span> <span id="casing_unit"
						class="p-content-xs"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">折算数量</label> <input type="text" class="p-xs zsum"
						id="plannum" data-number="n"> <span
						class="p-content-xs item_unit"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">剩余计划数</label> <span class="p-content-xs red" id="sd_oq"></span>
					<span class="p-content-xs item_unit"></span> <input type="hidden"
						id="planno"> <input type="hidden" id="sid">
				</div>
				<div class="p-form col-sm-6 red msg"></div>
				<div class="p-form col-sm-6">
					<label for="">金额</label> <span class="p-content red"
						id="sum_si"></span>
				</div>
				<c:if test="${requestScope.moreMemo}">
				<div>
              		<button type="button" id="moreMemo">特殊工艺备注</button>
              		<span id="c_memo"></span>
              		<span id="memo_color"></span>
              		<span id="memo_other"></span>
                </div>
                </c:if>
			</div>
			<div class="ctn" id="ivt_oper_listing"></div>
		</div>
	</div>
</div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>