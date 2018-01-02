<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../res.jsp" %>
	<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="../employee/selClient.jsp" %>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
		  	 <div class="box-head">
				<%@include file="../employee/showSelectClient.jsp" %>
       		</div>
				<div class="box-body">
					<!-- 所有sheet公用 -->
					<div class="tabs-content">
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
				        </div>
						<form action="" style="clear:both;overflow:hidden;">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">起始日期</label>
				                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="beginDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结束日期</label>
				                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="endDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">关键词</label>
				                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入搜索关键词">
				              </div>
				            </div>
				             <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结算方式</label>
				                <div class="input-group">
									<span class="form-control input-sm" id="settlement_name"></span>
									<span class="input-group-btn">
									<input type="hidden" class="form-control input-sm"  id="settlement_id" name="rcv_hw_no">
										<button type="button" class="btn btn-default btn-sm">X</button>	
								        <button class="btn btn-success btn-sm" type="button" id="settlement">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
				            <div class="col-sm-6 col-lg-4 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<span id="upload-btn" class="btn btn-sm btn-danger" style="margin-top:25px;">导入 -->
<!-- 									<input type="file"> -->
<!-- 								</span> -->
<!-- 				            	<button type="button" class="btn btn-danger btn-sm excel" id="hide" style="margin-top:25px;">导出</button> -->
				            </div>
						</form>
						<c:if test="${sessionScope.auth.client_order_confirm_cz!=null}">
				            <button type="button" class="btn btn-danger btn-sm" id="qrsk" style="margin-top:25px;">确认收款</button>
				        </c:if>
						<div class="text-center">
							<h3>客户收款确认</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>确认</th>   
								       <th>凭证</th>   
								       <th>收款日期</th>   
								       <th>客户名称</th>  
 								       <th>应收金额</th>   
 								       <th>实收金额</th>   
								       <th>结算方式</th>   
								       <th>收款单号</th>  
								       <th>支付方式</th> 
								       <th style="display: none;">收款部门</th> 
								       <th style="display: none;">收款人</th> 
								       <th style="display: none;">备注</th> 
								       <th>摘要</th> 
								    </tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<div class="pull-right">
						    <button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
						    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
						    <button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
						    <button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
<!-- <div class="image-zhezhao" style="display:none"> -->
<!--         <div class="img-ku" style="position: absolute;left: 44%;top: 26%;"> -->
<!--             <div id="imshow"></div> -->
<!--         </div> -->
<!-- 	    <button class="btn btn-danger" style="position: absolute;left: 49%;top: 61%;width:100px" id="print">打印凭证</button> -->
<!--     <div class="gb" id="closeimgshow"></div> -->
<!-- </div> -->
<%@include file="../smsweixinselect.jsp" %>
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

<div class="modal imgshow" style="display: none;">
   <div class="modal-dialog">
	 <div class="modal-content">
	    <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
		<span class="sr-only">Close</span></button>
		<h4 class="modal-title">查看凭证图片</h4>
		</div>
		<div class="modal-body" style="overflow:hidden ; padding: 10px;">
		<img id="imshow" src="" style="max-width: 100%;max-height: 400px;">
		</div>
		<div class="modal-footer">
				<button type="button" class="btn btn-info" id="print">打印凭证</button>
				<button type="button" class="btn btn-default">关闭</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/collectionConfirm.js${requestScope.ver}"></script>
</body>
</html>

    