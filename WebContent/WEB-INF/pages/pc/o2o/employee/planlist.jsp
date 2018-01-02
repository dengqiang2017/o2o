<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>
<div style="display: none;">
	<div class="p-ctn" id="item">
		<input type="hidden" id="item_id"> <input type="hidden"id="sid">
		<input type="hidden" id="ivt_oper_bill"> 
		<input type="hidden" id="clerk_id_sid">
		<div class="p-top">
			<div class="col-sm-3 col-xs-5 pimg-ctn">
	            <a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a>
	        </div>
	        <div class="col-sm-9 col-xs-7 pmsg-ctn">
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
        	<div class="pro-check"></div>
        	<div class="p-form col-sm-6">
	            <label for="">数量</label> 
	            <input type="text" class="p-xs num" data-number="n"> 
	            <span id="casing_unit"></span>
        	</div>
          	<div class="p-form col-sm-6">
	            <label for="">折算数量</label> 
	            <span id="pack_unit" style="display: none;"></span> 
	            <input type="text" class="p-xs zsum" data-number="n" disabled="disabled"> 
	            <span id="item_unit"></span>
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
        <div class="p-middle" id="ivt_oper_listing"></div>
	</div>
</div>
