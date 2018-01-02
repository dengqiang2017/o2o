<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
            <div style="display: none;">
              <div class="p-ctn" id="item">
                <input type="hidden" id="item_id">
                <input type="hidden" id="sid">
                <div class="p-top">
                  <div class="col-sm-3 col-xs-5 pimg-ctn">
                    <a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a>
                  </div>
                  <div class="col-sm-9 col-xs-7 pmsg-ctn">
                    <span class="p-name"  id="item_name"></span>
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
                    <div class="pro-check"></div>
                    
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
                      <input type="date" name="discount_time_begin" id="discount_time_begin" class="p-xs Wdate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                      <span class="p-xs-m">~</span>
                      <input type="date" name="discount_time" id="discount_time" class="p-xs Wdate"  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">单价</label>
                      <input type="text" class="p-xs" name="sd_unit_price_DOWN" maxlength="17" data-number="n">
                      <span class="p-xs-m">~</span>
                      <input type="text" class="p-xs" name="sd_unit_price_UP" maxlength="17" data-number="n">
                    </div>
                    <c:if test="${sessionScope.userInfo.personnel.headship=='业务员'}">
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">其它折扣</label>
                      <input type="text" class="p-xs" id="price_otherDiscount" name="price_otherDiscount" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">对外标价</label>
                      <input type="text" class="p-xs" id="price_display" readonly="readonly" name="price_display" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">现金折扣</label>
                      <input type="text" class="p-xs" id="price_prefer" readonly="readonly" name="price_prefer" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6" style="display: none;">
                      <label for="">结算单价</label>
                      <input type="text" class="p-xs" id="sd_unit_price" readonly="readonly" name="sd_unit_price" maxlength="17" data-number="n">
                    </div>
                    </c:if>
                    <c:if test="${(sessionScope.userInfo.personnel.headship!='业务员'&&sessionScope.userInfo.personnel.headship!=null)||sessionScope.userInfo.personnel.clerk_name=='001'}">
                    <div class="p-form col-sm-6">
                      <label for="">其它折扣</label>
                      <input type="text" class="p-xs" id="price_otherDiscount" name="price_otherDiscount" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">对外标价</label>
                      <input type="text" class="p-xs" id="price_display" readonly="readonly" name="price_display" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">现金折扣</label>
                      <input type="text" class="p-xs" id="price_prefer" readonly="readonly" name="price_prefer" maxlength="17" data-number="n">
                    </div>
                    <div class="p-form col-sm-6">
                      <label for="">结算单价</label>
                      <input type="text" class="p-xs" id="sd_unit_price" readonly="readonly" name="sd_unit_price" maxlength="17" data-number="n">
                    </div>
                    </c:if>
                    <c:if test="${requestScope.moreMemo}">
                    <div>
                   		<button type="button" id="moreMemo">特殊工艺备注</button>
                   		<span id="c_memo"></span>
                   		<span id="memo_color"></span>
                   		<span id="memo_other"></span>
                    </div>
                    </c:if>
                  </div>
                 <div class="" id="ivt_oper_listing"></div>
              </div>
</div>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>