<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <div style="display:none;">
<div class="p-ctn" id="item">
<div class="p-top">
<input type="hidden" id="item_id">
  <div class="col-sm-3 col-xs-5 pimg-ctn">
<a href="#"><img class="p-img" src=""></a>
  </div>
  <div class="col-sm-9 col-xs-7 pmsg-ctn">
<span class="p-name" id="item_name">品名:</span>
<div class="ctn">
  <span class="p-class" id="item_spec"></span>
  <span class="p-class" id="item_type"></span>
  <span class="p-class" id="item_color"></span>
  <span class="p-class" id="class_card"></span>
  <span class="p-class" id="quality_class"></span>
  <span class="p-class" id="item_unit"></span>
    </div>
  </div>
</div>
<div class="p-middle">
<div class="pro-check"><input type="checkbox" class="check"></div>
  <div class="p-form col-sm-6">
<label for="">类别</label>
<span class="p-content" id="price_type"></span>
  </div>
  <div class="p-form col-sm-6">
<label for="">促销</label>
<span class="p-content" id="discount_ornot"></span>
  </div>
  <div class="p-form col-sm-6">
<label for="">时间</label>
<span class="p-content-xs" id="discount_time_begin">2015-07-23</span>
<span class="p-xs-m">~</span>
<span class="p-content-xs" id="discount_time"></span>
  </div>
<div class="p-form col-sm-6">
	<label for="">单价</label>
	<span class="p-content-xs red" id="sd_unit_price_DOWN"></span>
	<span class="p-xs-m">~</span>
	<span class="p-content-xs red" id="sd_unit_price_UP"></span>元
</div>
    </div>
  </div>
    
  </div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02">
</div>