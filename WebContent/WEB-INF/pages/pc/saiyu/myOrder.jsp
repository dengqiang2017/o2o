<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<link rel="stylesheet" href="../pc/saiyu/repair-dingdan.css${requestScope.ver}">
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/saiyu/myOrder.js${requestScope.ver}"></script>
<div id="orderlist" style="margin-bottom:30px">
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a></div><form class="form-horizontal" role="form">
    <div class="form-group">
        <div class="col-xs-12 col-lg-3 col-lg-offset-1 col-sm-offset-1">
    <label class="section-container-xy" style="display:block">关键词</label>
    <input type="text" class="input-sm form-control" id="searchKey" name="searchKey" maxlength="20" placeholder="关键词">
</div>
<div class="col-lg-3 col-xs-12 orderSelect">
    <label class="label-lg">订单状态</label>
    <select class="form-control input-height" id="orderSelect" style="height:30px">
        <option></option>
        	<c:forEach items="${requestScope.processName}" var="name">
		    <option value="${name}">${name}</option>
			</c:forEach>
    </select>
</div>
<div class="col-lg-3 col-xs-12 xs1margin">
    <label class="label-lg">安装类别</label>
    <select class="form-control input-height" id="elecState" style="height:30px">
        <option></option>
        <option value="0">未预约</option>
        <option value="1">已预约未安装</option>
        <option value="2">已安装未验收评价</option>
        <option value="3">已验收未支付</option>
        <option value="4">已支付</option>
    </select>
</div>
<div class="col-xs-12 col-lg-3 xsmargin" style="margin-top:0">
 <label class="section-container-xy" style="display:block;">订单日期</label>
<input type="date" class="form-control input-sm Wdate" name="store_date" id="store_date" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
        </div>
        <div class="col-xs-2 xsmargin" >
            <div class="section-container-ss"><button type="button" class="btn btn-sm btn-primary find" id="searchKey" name="searchKey">搜索</button></div>
        </div>
    </div>
    <div class="clear"></div>
</form><div class="section-container" style="margin-bottom:70px">
    <div class="row">
        
    </div>
    <div id="orderitem" style="display: none;">
<div class="col-lg-4 col-sm-6 fl">
        <div class="div-bg">
    <div class="pro-check" style="float:left;margin-top:5px"></div>
        <ul style="padding-left:10px">
            <li>订单编号:</li>
<!--             <li>产品名称:</li> -->
            <li>订单日期:</li>
            <li>订单总数：</li>
            <li>订单状态：</li>
            <li>电工安装：</li>
            <li>电工信息：</li>
            <li>
			    <button type="button" class="btn btn-xs btn-primary" id="pingjiabtn" style="display: none;">评价订单</button> 
			    <button type="button" class="btn btn-xs btn-primary" id="orderdetailsbtn">查看详情</button>
			    <button type="button" class="btn btn-xs btn-primary" id="orderpay" style="display: none;">去支付</button>
			    <button type="button" class="btn btn-xs btn-primary" id="diangongbtn" style="display: none;">预约电工</button>
                <button type="button" class="btn btn-xs btn-danger" id="shouhuobtn" style="display: none;">确认收货</button>
                <button type="button" class="btn btn-xs btn-danger" id="diangongPay" style="display: none;">电工安装费支付</button>
                <button type="button" class="btn btn-xs btn-danger" id="diangongPingjia" style="display: none;">电工安装验收</button>
            </li>
        </ul>
            </div>
        </div>
    </div>
</div>
<div class="clear"></div>
    <div class="xfooter" style="width:100%;height:60px;background-color:#F4F0F0;position:fixed;bottom:0;margin-left:-15px">
    <div class="pro-check" id="allcheck" style="margin-top:18px;margin-left:25px;margin-right:10px;width:30px;float:left"></div>
    <div style="margin-top:23px;margin-right:10px;float:left"><span>全选</span></div>
    <button type="button" class="btn btn-sm btn-primary" id="diangongbtn" style="margin-top:18px;">预约电工</button>
    <button type="button" class="btn btn-sm btn-primary" id="electrPay" style="margin-top:18px;display: none;">电工安装费支付</button>
<!--     <button type="button" class="btn btn-sm btn-primary" id="diangongPingjia" style="margin-top:18px;display: none;">电工安装验收</button> -->
    </div>
<div class="modal-cover-first" style="display:none;"></div>
<div class="modal-first" style="display:none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请上传支付凭证</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
	<a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传凭证
	<input type="file" name="imgFile" id="imgFile" onchange="imgUpload(this);">
	<input type="hidden" id="filepath">
	</a>
	<div class="showimg">
	<img src="">
	</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="certificateBtn">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
<div id="itempage">

</div>
<div id="backelec"></div>
