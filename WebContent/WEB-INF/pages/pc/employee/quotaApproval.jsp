<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../pcxy/css/product.css">
<script src="../js/o2od.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/OAFile.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/quotaApproval.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../employee.do">员工首页</a></li>
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="myOA.do">我的协同</a></li>
			<li class="active"><span
				class="glyphicon glyphicon-triangle-right"></span>协同审批</li>
		</ol>
		<div class="header-title">
			员工-协同审批 <a href="myOA.do" class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
	</div>
<input type="hidden" id="clerk_id" value="${sessionScope.userInfo.personnel.clerk_id}">
<input type="hidden" id="com_id" value="${sessionScope.userInfo.com_id}">
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<div class="panel panel-danger">
					<div class="panel-heading">
						<span id="OA_what">标题:</span>
					</div>
					<div class="panel-body">
						<p id="OA_who">发起人:</p>
						<p id="store_date">发起时间:</p>
						<p>内容:<span id="content"></span></p>
						<input type="hidden" id="ivt_oper_listing">
						<p id="sqfujian">
							附件:<input type="hidden" id="approvaler">
							<span class="glyphicon glyphicon-search table-dld"></span>
						</p>
						<p id="iou" style="display: none;">
							<a id="ioupath" target="_blank">查看欠条</a>
							<a href="../report/receivablesReport.do" id="accountStatement" target="_blank">查看对账单</a>
						</p>
					</div>
				</div>
				<div class="ctn">
					<div class="col-sm-3 col-xs-6 m-t-b">
						<div class="form-group">
							<label for="">审批意见</label> <select class="form-control input-sm">
								<option value="同意">同意</option>
								<option value="不同意">不同意</option>
							</select>
						</div>
					</div>
					<div class="ctn">
						<div class="form-group" id="filelaoddiv">
							<div class="upload-group">
								<label for="">附件上传</label>
									<button type="button" class="btn btn-primary" style="display: none;" id="scpz">上传附件</button>
				                <div id="upload-btn">
				                <button type="button" class="btn btn-primary">点击上传</button>
				                <input type="file" class="upload" name="imgFile" id="imgFile" onchange="fileUpload(this);">
				                </div>
							</div>

							<div class="file-icon-group">
								<span class="glyphicon glyphicon-file file-icon"></span> <span
									class="file-name"></span><input type="hidden" id="fileurl">
								<span class="glyphicon glyphicon-trash file-operate"></span> <span
									class="glyphicon glyphicon-search file-operate"></span>
							</div>
						</div>
					</div>

					<div class="ctn">
						<div class="form-group">
							<label for="">审批意见</label>
							<textarea id="spyij" cols="30" rows="3" class="form-control"></textarea>
						</div>
					</div>
					<div class="ctn">
						<button class="btn btn-primary" type="button" id="saveSp">提交</button>
						<a class="btn btn-primary" href="myOA.do">返回</a>
					</div>
				</div>
			</div>
			<div class="box-body">
				<h5>审批记录</h5>
					<div class="alert alert-success">
						<div class="ctn">
							<div class="col-sm-2 m-t-b" style="font-weight: 700;"></div>
							<div class="col-sm-1 m-t-b" style="font-weight: 700;"></div>
							<div class="col-sm-5 m-t-b"></div>
							<div class="col-sm-2 m-t-b"
								style="fong-size: 12px; color: #858585;"></div>
							<div class="col-sm-2 m-t-b">
								<button type="button" class="btn btn-primary" id="fujian">附件</button>
							</div> 
						</div>
					</div>
			</div>
		</div>
	</div>

	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span>
	</div>
</body>
</html>