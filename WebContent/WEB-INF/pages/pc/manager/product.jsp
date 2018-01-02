<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>牵引O2O营销服务平台</title>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a onclick="window.parent.location.href='../employee.do'" class="employee">${sessionScope.indexName}</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a class="tolistpage">产品维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>产品详细</li>
		</ol>
		<div class="header-title">${sessionScope.indexName}-产品详细
			<a class="header-back tolistpage"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container" style="margin-top:10px;">
	<form id="editForm">
		<div class="ctn-fff box-ctn">
			<div class="box-body">
			<input type="hidden" name="item_id" value="${requestScope.item_id}">
			<input type="hidden" name="com_id" id="com_id" value="${requestScope.com_id}">
				<div class="form">
				 <%@include file="edit.jsp"%>
				</div>
			</div>
		</div>

		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">附件上传</h4>
			</div>
			<div class="box-body">
					<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>产品图</label>
							    <span class="btn upload-btn">点击上传图像
							    <input type="file" class="input-upload" accept="image/*" name="imgFile" id="imgFile" onchange="imgUpload(this);"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K,其它格式5MB,建议尺寸:1200*900</p>
							</div>
							<div class="upload-img" id="cp" style="width: 100%">
							 
							</div>
						</div>
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>产品细节图文</label>
							    <a id="detail" target="_blank"><span class="btn upload-btn">编辑产品详情图文</span></a>
							    <p class="help-block" style="color: red;">请先保存后在列表中直接编辑产品详情图文编辑操作</p>
							</div>
						</div>
			</div>
		<div class="col-lg-4 col-sm-4 m-t-b">
				<div class="form-group">
					<label>产品封面图</label>
					<span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload"
					name="cpsl" id="cpsl" onchange="imgSlUpload(this,'cpsl');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,建议尺寸:500*500</p>
				</div>
				<div class="upload-img">
					<img id="cpslimg" src="../pcxy/image/upload-img.png" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
				<input type="hidden" name="cpslpath">
				<input type="hidden" name="cicun" value="600">
			</div>
		</div>
<!-- 		<div class="ctn-fff box-ctn"> -->
<!-- 			<div class="box-head"> -->
<!-- 				<h4 class="pull-left">附件上传</h4> -->
<!-- 			</div> -->
<!-- 			<div class="box-body"> -->
<!-- 					<div class="col-lg-4 col-sm-4 m-t-b"> -->
<!-- 							<div class="form-group"> -->
<!-- 							    <label>产品图</label> -->
<!-- 							    <input type="hidden" id="cpimg" value="0"> -->
<!-- 							    <input type="hidden" id="xjimg" value="0"> -->
<!-- 							    <span class="btn upload-btn">点击上传图像 -->
<!-- 							    <input type="file" class="input-upload" accept="image/*" name="imgFile" id="imgFile" onchange="imgUpload(this);"></span> -->
<!-- 							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K,其它格式5MB,建议尺寸:1200*900</p> -->
<!-- 							</div> -->
<!-- 							<div class="upload-img" id="cp" style="width: 100%"> -->
							 
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 						<div class="col-lg-4 col-sm-4 m-t-b"> -->
<!-- 							<div class="form-group"> -->
<!-- 							    <label>产品细节图</label> -->
<!-- 							    <span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload" name="imgxjFile" id="imgxjFile" onchange="imgUpxjload(this);"></span> -->
<!-- 							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K,其它格式5MB,建议尺寸:1200*900</p> -->
<!-- 							</div> -->
<!-- 							<div class="upload-img" id="xj" style="width: 100%"> -->
<!-- 							</div> -->
<!-- 						</div> -->
<!-- 			</div> -->
<!-- 		<div class="col-lg-4 col-sm-4 m-t-b"> -->
<!-- 				<div class="form-group"> -->
<!-- 					<label>产品封面图</label> -->
<!-- 					<span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload" -->
<!-- 					name="cpsl" id="cpsl" onchange="imgSlUpload(this,'cpsl');"></span> -->
<!-- 					<p class="help-block">图片格式支持JPG/JPEG/PNG,建议尺寸:500*500</p> -->
<!-- 				</div> -->
<!-- 				<div class="upload-img"> -->
<%-- 					<img id="cpslimg" src="../${requestScope.product.sl}${requestScope.ver}" alt="" onerror="this.src='../pcxy/image/upload-img.png'"> --%>
<!-- 				</div> -->
<!-- 				<input type="hidden" name="cpslpath"> -->
<!-- 				<input type="hidden" name="cicun" value="600"> -->
<!-- 			</div> -->
<!-- 		</div> -->
		</form>
	</div>

	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a class="btn btn-primary tolistpage">返回</a>
		</div>	
	</div> 
</body>
</html>