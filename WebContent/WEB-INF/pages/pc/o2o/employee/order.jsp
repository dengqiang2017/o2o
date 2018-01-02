<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div style="display: none;">
	<div class="p-ctn" id="item">
		<input type="hidden" id="item_id">
		<input type="hidden" id="seeds_id">
		<div class="p-msg">
		<div class="p-top">
			<div class="col-sm-3 col-xs-5 pimg-ctn">
				<a href="../product/productDetail.do"><img class="p-img"
					src="" alt=""></a>
			</div>
			<div class="col-sm-9 col-xs-7 pmsg-ctn">
				<span class="p-name" id="item_name"></span>
				<div class="ctn">
					<span class="p-class" id="item_spec"></span> <span
						class="p-class" id="item_type"></span> <span
						class="p-class" id="item_color"></span> <span
						class="p-class" id="class_card"></span> <span
						class="p-class" id="quality_class" style="width: 100%;"></span>
				</div>
			</div>
		</div>
		<div class="p-middle">
		<input type="hidden" id="sd_unit_price">
		<input type="hidden" id="price_display">
		<input type="hidden" id="price_prefer">
		<input type="hidden" id="price_otherDiscount">
			<div class="pro-check"></div>
			<div class="p-form col-sm-6" style="display: none;">
			<label for="">类别</label> <select name="price_type" id="">
				<option value="">零售</option>
				<option value="">批发</option>
				<option value="">协议</option>
			</select>
		</div>
		<div class="p-form col-sm-6" style="display: none;">
			<label for="">促销</label> <select id="" name="discount_ornot">
				<option value="Y">有</option>
				<option value="N">无</option>
			</select>
		</div>
		<div class="p-form col-sm-6" style="display: none;">
				<label for="">时间</label> <input type="text"
					name="discount_time_begin" class="p-xs"> <span
					class="p-xs-m">~</span> <input type="text"
					name="discount_time" class="p-xs">
			</div>
			<div class="p-form col-sm-6">
				<label for="">单价</label> <span id="sd_unit_price_DOWN"
					class="p-content-xs red"></span> <span class="p-xs-m">~</span>
				<span id="sd_unit_price_UP" class="p-content-xs red"></span>
			</div>
			<div class="p-form col-sm-6">
					<label for="">库存数</label>
					<span id="use_oq"></span>
					<span>(库存数不足,<span id="qz_days"></span>天后发货)</span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">数量</label> 
					<div class="num-input-xs">
                      <span class="add"></span>
                      <span class="sub"></span>
						<input type="text" class="num" id="pronum" data-number="n"> 
                    </div>
						<span class="p-content-xs" id="casing_unit"></span>
				</div>
				
				<div class="p-form col-sm-6">
					<label for="">折算数量</label> <span id="pack_unit"
						style="display: none;"></span> <input type="text"
						class="p-xs zsum" data-number="n" disabled="disabled"> <span
						id="item_unit"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">金额</label> <span class="p-content red"
						id="sum_si"></span>
				</div>

				<div class="" id="ivt_oper_listingMyPlan"></div>
				<div class="" id="ivt_oper_listing"></div>
				 <c:if test="${requestScope.moreMemo}">
				<div>
               		<button type="button" id="moreMemo">特殊工艺备注</button>
               		<span id="c_memo"></span>
               		<span id="memo_color"></span>
               		<span id="memo_other"></span>
                </div>
				 </c:if>
			</div>
		</div>
	</div>
</div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>