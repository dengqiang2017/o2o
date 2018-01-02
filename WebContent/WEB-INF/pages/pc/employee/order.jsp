<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="selClient.jsp" %>
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
<!-- 			客户信息 -->
 <%@include file="showSelectClient.jsp" %>
			</div> 
		</div>
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn" style="min-height: 500px;">
			<div class="box-head">
				<%@include file="../find.jsp"%>
			</div>
			<!-- 列表区域 -->
			<div class="box-body" style="margin-bottom: 100px;">
				<div class="tabs-content" style="display: block;">
				<input type="checkbox" class="check" style="display: none;">
					<div class="ctn">
<%-- 						<%@include file="../list/employee/order.jsp"%> --%>
						<div id="list"></div>
					</div>
					<div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				<div class="tabs-content" style="display: block;">
					<div class="ctn"><div id="list"></div></div>
				<div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
				</div>
				 <div class="tabs-content" style="display: block;">
              		<div class="ctn">
              		<c:if test="${sessionScope.auth.order_del!=null}">
              		  <button type="button" class="btn btn-danger" id="orderdel" title="只有流程还没有开始的订单数据可以删除" onmouseenter="$('.alert').show();" onmouseleave="$('.alert').hide();">删除</button>
              		  <div class="alert alert-warning" role="alert" style="display: none;">
					  <strong>提示:</strong> 只有流程还没有开始的订单数据可以删除
					</div>
              		</c:if>
              		  <button type="button" class="btn btn-danger btn-sm m-t-b print">打印选中二维码</button>
              		</div>
               <div class="ctn" id="list"></div>
	          <div class="ctn" style="display: none;">
	            <button class="btn btn-add" type="button">点击加载更多</button>
	          </div>
              </div>
			</div>
		</div>
	</div>
	<div class="back-top" id="scroll"></div>

	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span> <input type="hidden"
			id="customer_id">
		<div class="btn-gp">
			<label><input type="checkbox" id="allcheck">全选</label>
			<button class="btn btn-info" id="saveOrder">提交</button>
			<a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
		</div>
	</div>
	<span style="display: none;" id="order_edit_price">${sessionScope.auth.order_edit_price}</span>
	<div style="display: none;" id="item">
	<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
		<span id="item_id" style="display: none;"></span>
		<input type="hidden" id="seeds_id">
		<input type="hidden" id="price_display">
		<input type="hidden" id="price_prefer">
		<input type="hidden" id="price_otherDiscount">
		<%@include file="proinfo.jsp" %>
		<div style="border-bottom: 1px solid aqua;">
		<div class="col-xs-6 col-sm-6 col-md-3" style="display: none;">
			<label for="">促销:</label><span id='discount_ornot'></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-9" style="display: none;">
			<label for="">时间:</label>
			<span id='discount_time_begin'></span><span>~</span><span id='discount_time'></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-12">
			<label for="">客户物料对应名称编码</label>
			<span id="client_item_name"></span>
			<span id="peijian_id"></span>
		</div>
		<div class="col-xs-12 col-sm-12 col-md-6">
			<label for="">单价</label>
			<input type="number" name="sd_unit_price" id="sd_unit_price" data-num="num2" readonly="readonly">
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
		<div class="col-xs-12 col-sm-6 col-md-6" style="display: none;">
			<label for="plan_num">计划数量</label>
			<span id="plan_num"></span>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6" style="display: none;">
			<label for="send_sum">计划已下数量</label>
			<span id="send_sum"></span>
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
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/ordercom.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/order.js${requestScope.ver}"></script>
<div class="modal-cover fujian" style="display:none;">
<div class="modal fujian" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请上传订单附件</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传订单附件
			<input type="file" name="imgFile" id="imgFile" onchange="fileLoad(this);">
			</a>
			<span style="display: none;" id="orderNo"></span>
			<div class="showimg" id="fujianList">
			
			</div>
			<div id="fujianItem" style="display: none;">
				<div class="pull-left" style="border: 1px solid aqua;">
				<a class="btn btn-info" target="_blank">查看</a>
				<button type="button" class="btn btn-default">删除</button>
				</div>
			</div>
			<div class="clearFix"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" onclick="$('.fujian').hide();">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>