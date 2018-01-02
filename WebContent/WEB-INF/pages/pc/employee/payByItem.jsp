<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../pcxy/css/function.css"> 
    <script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
    <script src="../js/o2otree.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
   	<script type="text/javascript"  src="../pc/js/report/choiceSupplier.js?ver=589080"></script>
    <script type="text/javascript" src="../pc/js/employee/payByItem.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="../employee/selSupplier.jsp"%>		
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
		<%@include file="../employee/showSelectSupplier.jsp" %>
		<input type="hidden" id="customer_id"> 
		</div>
		<div class="box-body">
			<form action="alipay.do" method="post">
					<div class="pay-form">
						<span class="pay-label">付款单号</span>
						<input type="text" readonly="readonly" class="payinput" name="orderNo">
					</div>
					<div class="pay-form">
						<span class="pay-label">付款金额</span>
						<input class="payinput" name="amount" data-number="n" maxlength="10" type="tel">
					</div>
					</form>
					<div class="pay-form">
						<span class="pay-label">付款日期</span>
						<input type="text" class="payinput" value="2015-10-13" readonly="readonly" id="time">
					</div>
					<div class="pay-form" id="account" style="display: none;">
						<span class="pay-label">账户类型</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box">账上款
								<span class="glyphicon glyphicon-ok"></span>
							</div>
							<div class="paycheck-box last">预存款
								<span class="glyphicon glyphicon-ok"></span>
							</div>
						</div>
					</div>
					<div class="pay-form" id="paystyle" style="display: none;">
						<span class="pay-label">结算方式</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box">银联线下转账
								<span class="glyphicon glyphicon-ok"></span>
							</div> 
						</div>
					</div>
					<div class="pay-form" id="zftl">
						<span class="pay-label">支付通路</span>
						<div class="paycheck-ctn">
							<div class="paycheck-box">银联线下转账
								<span class="glyphicon glyphicon-ok"></span>
							</div>
<!-- 							<div class="paycheck-box">银联线下代扣 -->
<!-- 								<span class="glyphicon glyphicon-ok"></span> -->
<!-- 							</div> -->
<!-- 							<div class="paycheck-box">银联在线支付 -->
<!-- 								<span class="glyphicon glyphicon-ok"></span> -->
<!-- 							</div> -->
							<div class="paycheck-box">微信支付
								<span class="glyphicon glyphicon-ok"></span>
							</div>
							<div class="paycheck-box">支付宝
								<span class="glyphicon glyphicon-ok"></span>
							</div>
							<div class="paycheck-box">其他
								<span class="glyphicon glyphicon-ok"></span>
							</div>
						</div>
					</div>
					
				
			
			
		</div>
      </div>
    </div>

    <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button type="button" class="btn btn-info">提交</button>
        <a href="JavaScript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
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
			<button type="button" id="scpz"  class="btn btn-primary btn-sm m-t-b">上传凭证</button>
			<div class="showimg">
			<img src="">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="scpzpc">确定</button>
			</div>
		</div>
	</div>
</div>
<div id="info" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">经办信息</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setReceivable">
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptId" type="hidden"  name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm dept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerk_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerkId" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="sure" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>