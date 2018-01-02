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
<!-- <script type="text/javascript" src="../datepicker/WdatePicker.js"></script> -->
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/OAFile.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/coordination.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="myOA.do">我的协同</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>协同申请</li>
		</ol>
		<div class="header-title">员工-协同申请
			<a href="myOA.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div> 
	</div>
<input type="hidden" id="clerk_id" value="${sessionScope.userInfo.personnel.clerk_id}">
<input type="hidden" id="com_id" value="${sessionScope.userInfo.com_id}">
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				员工-协同申请
			</div>
			<div class="box-body">				
		        <div class="ctn">
		        	<div class="col-sm-3 m-t-b">
		              <div class="form-group">
		                <label for="">类别</label>
		                <select  id="clsname" class="form-control input-sm">
		                	<option value="用车办事">用车办事</option>
		                	<option value="市场活动">市场活动</option>
		                	<option value="请款报告">请款报告</option>
		                	<option value="业务报告">业务报告</option>
		                	<option value="项目建设">项目建设</option>
		                	<option value="投资申请">投资申请</option>
		                	<option value="一天内请假">一天内请假</option>
		                	<option value="3天内请假">3天内请假</option>
		                	<option value="5天内请假">5天内请假</option>
		                	<option value="10天以上请假">10天以上请假</option>
		                </select>
		              </div>
		            </div>
		        	<div class="col-sm-3 m-t-b">
		              <div class="form-group">
		                <label for="">标题</label>
		                <input type="text" class="form-control input-sm" id="OA_what">
		              </div>
		            </div>
		            <div class="col-sm-3 m-t-b">
		              <div class="form-group">
		                <label for="">发起人</label>
		                <span class="form-control input-sm" >${sessionScope.userInfo.personnel.clerk_name}</span>
		              </div>
		            </div>
		            <div class="col-sm-3 m-t-b">
		              <div class="form-group">
		                <label for="">日期</label>
		                <span class="form-control input-sm Wdate"></span>
		              </div>
		            </div>
		            <div class="ctn">
		            	<div class="form-group">
			            	<label for="">申请内容</label>
			            	<textarea id="content" id="" cols="30" rows="3" class="form-control" placeholder="申请事项详细描述"></textarea>
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
			              </div>
			              <div class="file-icon-group">
								<span class="glyphicon glyphicon-file file-icon"></span> <span
									class="file-name"></span><input type="hidden" id="fileurl">
								<span class="glyphicon glyphicon-trash file-operate"></span> <span
									class="glyphicon glyphicon-search file-operate"></span>
							</div>
		            </div>
		            
		            <div class="ctn">
		            	<button class="btn btn-primary" type="button"  id="saveSp">提交</button>
		            	<a class="btn btn-primary" href="myOA.do">返回</a>
		            </div>
		        </div>
			</div>
		</div>
	</div>

	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
	</div>
</body>
</html>