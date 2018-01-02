<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="item"  style="display: none;">
              <div class="p-ctn" >
                <input type="hidden" id="item_id">
                <input type="hidden" id="sid">
                <div class="p-img pimg-ctn" style="display: none;">
<!--                   <a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a> -->
                </div>
                <div class="p-msg">
                  <div class="p-top">
                  <div class="pro-check">
<!--                   <input type="checkbox" class="check"> -->
                  </div>
                    <div class="pmsg-ctn">
                      <span class="p-name"  id="item_name"></span>
                      <div class="ctn" style="display: none;">
                        <span class="p-class" id="item_spec"></span>
                        <span class="p-class" id="item_type"></span>
                        <span class="p-class" id="item_color"></span>
                        <span class="p-class" id="class_card"></span>
                        <span class="p-class" id="quality_class" style="width:100%;"></span>
                      </div>
                    </div>
                  </div>
                  <div class="p-middle">
                    
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">类别</label>
                      <select name="price_type" id="">
                        <option value="零售">零售</option>
                      <option value="批发">批发</option>
                      <option value="协议">协议</option>
                      </select>
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">促销</label>
                      <select id="" name="discount_ornot">
                        <option value="Y">有</option>
                        <option value="N">无</option>
                      </select>
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">时间</label>
                      <input type="date" name="discount_time_begin" id="discount_time_begin" class="p-xs Wdate" 
                     onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    <span class="p-xs-m">~</span>
                    <input type="date" name="discount_time" id="discount_time" class="p-xs Wdate"  
                    onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">单价</label>
                      <input type="number" class="p-xs" name="sd_unit_price_DOWN" maxlength="17" data-number="n">
                    <span class="p-xs-m">~</span>
                    <input type="number" class="p-xs" name="sd_unit_price_UP" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6">
                    <label for="">其它折扣</label>
                    <input type="number" class="p-xs" id="price_otherDiscount" name="price_otherDiscount" maxlength="17" data-number="n">
                  </div>
                  <div class="p-form col-sm-6">
                    <label for="">对外标价</label>
                    <input type="number" class="p-xs" id="price_display" readonly="readonly" name="price_display" maxlength="17" data-number="n">
                  </div>
                  <div class="p-form col-sm-6">
                    <label for="">现金折扣</label>
                    <input type="number" class="p-xs" id="price_prefer" readonly="readonly" name="price_prefer" maxlength="17" data-number="n">
                  </div>
                  <div class="p-form col-sm-6">
                    <label for="">结算单价</label>
                    <input type="number" class="p-xs" id="sd_unit_price" readonly="readonly" name="sd_unit_price" maxlength="17" data-number="n">
                  </div>
                 <div class="" id="ivt_oper_listing"></div>
                 <button type="button" class="btn btn-success" id="editPrice" style="display: none;">修改价格</button>
                  </div>
                </div>
              </div>
</div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>