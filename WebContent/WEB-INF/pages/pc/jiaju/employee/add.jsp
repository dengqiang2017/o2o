<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
            <div id="item" style="display: none;">
              <div class="col-xs-12 col-sm-12 col-md-6 dataitem">
                <span id="item_id" style="display: none;"></span>
                <input type="hidden" id="sid">
                <%@include file="../../employee/proinfo.jsp" %>
                <div style="border-bottom: 1px solid aqua;">
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">促销时间</label>
                      <input type="date" name="discount_time_begin" id="discount_time_begin" class="p-xs Wdate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                      <span class="p-xs-m">~</span>
                      <input type="date" name="discount_time" id="discount_time" class="p-xs Wdate"  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">标价范围</label>
                      <input type="number" name="sd_unit_price_DOWN" maxlength="17" data-num="num2">
                      <span class="p-xs-m" style="margin-top:3px">~</span>
                      <input type="number" name="sd_unit_price_UP" maxlength="17" data-num="num2">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-6">
                      <label for="">对外标价</label>
                      <input type="number" id="price_display" readonly="readonly" name="price_display" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-6">
                      <label for="">其它折扣</label>
                      <input type="number" id="price_otherDiscount" name="price_otherDiscount" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-6">
                      <label for="">现金折扣</label>
                      <input type="number" id="price_prefer" readonly="readonly" name="price_prefer" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-6">
                      <label for="">结算单价</label>
                      <input type="number" class="p-xs" id="sd_unit_price" readonly="readonly" name="sd_unit_price" maxlength="17" data-number="n">
                    </div> 
<!--                     //////////////////// -->
                    <div class="col-xs-12 col-sm-12 col-md-6">
                      <label for="">是否促销</label>
					  <input type="checkbox" name="discount_ornot" id="discount_ornot" data-on-text="是" data-off-text="否">
                    </div> 
<!-- 			/////////////////////// -->
                    <c:if test="${requestScope.moreMemo}">
                    <div>
                   		<button type="button" class="btn btn-success" id="moreMemo">特殊工艺备注</button>
                   		<span id="c_memo"></span>
                   		<span id="memo_color"></span>
                   		<span id="memo_other"></span>
                    </div>
                    </c:if>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">报价单号</label>
                      <span id="ivt_oper_listing"></span>
                      <c:if test="${sessionScope.auth.add_edit!=null}">
	                   	<button type="button" class="btn btn-success" id="editPrice" style="display: none;">保存修改</button>
                      </c:if>
                    </div> 
                  </div>
              </div>
</div>
