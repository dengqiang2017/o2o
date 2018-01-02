<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div style="display: none;">
              <div class="p-ctn" id="item">
                <input type="hidden" id="item_id">
                <div class="p-img">
                  <a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a>
                </div>
                <div class="p-msg">
                  <div class="p-top">
                    <div class="pro-check"><input type="checkbox" class="check"></div>
                    <div class="pmsg-ctn">
                      <span class="p-name" id="item_name"></span>
                      <div class="ctn">
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
                      <span class="p-content" id="price_type"></span>
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">促销</label>
                      <span class="p-content" id="discount_ornot"></span>
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">时间</label>
                      <span class="p-content-xs" id="discount_time_begin"></span>
                      <span class="p-xs-m">~</span>
                      <span class="p-content-xs" id="discount_time"></span>
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">单价</label>
                      <span class="p-content-xs red" id="sd_unit_price_DOWN"></span>
                      <span class="p-xs-m">~</span>
                      <span class="p-content-xs red" id="sd_unit_price_UP"></span>
                    </div>
                  </div>
                </div> 
              </div>
              </div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>