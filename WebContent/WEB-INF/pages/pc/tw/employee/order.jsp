﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="item" style="display: none;">
	<div class="p-ctn">
		<input type="hidden" id="item_id">
		<input type="hidden" id="seeds_id">
		<div class="p-img pimg-ctn" style="display: none;">
<!-- 			<a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a> -->
		</div>
		<div class="p-msg">
			<div class="p-top">
				<div class="pro-check">
<!-- 					<input type="checkbox" class="check"> -->
				</div>
				<div class="pmsg-ctn">
					<span class="p-name" id="item_name"></span>
					<div class="ctn" style="display: none;">
						<span class="p-class" id="item_spec"></span> <span
							class="p-class" id="item_type"></span> <span
							class="p-class" id="item_color"></span> <span
							class="p-class" id="class_card"></span> <span
							class="p-class" id="quality_class"
							style="width: 100%;"></span>
					</div>
				</div>
			</div>
			<div class="p-middle">

		<input type="hidden" id="sd_unit_price">
		<input type="hidden" id="price_display">
		<input type="hidden" id="price_prefer">
		<input type="hidden" id="price_otherDiscount">
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">类别</label> <span class="p-content" id="price_type"
						 ></span>
				</div>
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">促销</label> <span class="p-content"
						id="discount_ornot" ></span>
				</div>
				<div class="p-form col-sm-6" style="display: none;">
					<label for="">时间</label> <span class="p-content-xs"
						id="discount_time_begin"></span> <span
						class="p-xs-m">~</span> <span class="p-content-xs"
						id="discount_time"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">单价</label> <span class="p-content-xs red"
						id="sd_unit_price_DOWN"></span> <span
						class="p-xs-m">~</span> <span class="p-content-xs red"
						id="sd_unit_price_UP"></span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">库存数</label>
					<span id="use_oq"></span>
					<span>(如果库存数不足,供货周期为:<span id="qz_days"></span>天)</span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">数量</label> <input type="number" class="p-xs num" id="pronum"
						data-number="n"> <span id="casing_unit">包装单位</span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">折算数量</label> <span id="pack_unit"
						style="display: none;"></span> <input type="number"
						class="p-xs zsum" data-number="n" disabled="disabled"> <span
						id="item_unit">基本单位</span>
				</div>
				<div class="p-form col-sm-6">
					<label for="">金额</label> <span class="p-content red"
						id="sum_si"></span>
				</div>
				<div class="" id="ivt_oper_listingMyPlan"></div>
				<div class="" id="ivt_oper_listing"></div>
			</div>
		</div>
	</div>
</div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>