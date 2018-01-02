<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<style>
	.modal_ul>li{
	float:left;
	list-style:none;
	margin-right:9px;
	width:70px;
	text-align:center;
	}
	.modal_ul{
	padding-left:0;
	}
	</style>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
			<li><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../manager.do">员工首页</a></li>
			<li><span class="glyphicon glyphicon-triangle-right"></span><a id="personnelEdit_a">员工维护</a></li>
			<li class="active"><span
				class="glyphicon glyphicon-triangle-right"></span>员工详细</li>
		</ol>
		<div class="header-title">
			员工-员工详细 <a href="personnel.do" class="header-back"><span
				class="glyphicon glyphicon-menu-left"></span></a>
		</div>
		<div class="header-logo"></div>
	</div>
	<div class="container">
		<form  id="editForm" style="margin-bottom:60px">
			<div class="ctn-fff box-ctn">
<!-- 				<div class="box-head"> -->
<!-- 					<h4 class="pull-left">基本信息</h4> -->
<%-- 					<c:if test="${requestScope.auth.qxfp!=null||sessionScope.userInfo.clerk_id=='001'}"> --%>
<!-- 					<a id="qxfp" style="margin-top:6px; margin-left:5px;" class="btn btn-danger btn-sm">权限分配</a> -->
<%-- 					</c:if> --%>
<%-- 					<input type="hidden" name="qxfpcontent" id="qxfpcontent" value="${requestScope.authitem}"> --%>
<%-- 					<c:if test="${requestScope.client.weixinStatus=='4'||requestScope.client.weixinStatus==null}"> --%>
<!-- 			          <button type='button' id='inviteID' class='btn btn-danger btn-sm' style='margin-right:2px;'  -->
<%-- 				onclick="weixininviteEdit('${requestScope.client.weixinID}');">邀请关注</button> --%>
<%-- 				<button type="button" onclick="employeeToWeixin('employee','${requestScope.personnel.clerk_id}');" --%>
<!-- 				 class="btn btn-danger btn-sm">备份数据到微信</button> -->
<%-- 					</c:if> --%>
<!-- 				</div> -->
				<div class="box-body">
					<div class="form">
					<%@include file="edit.jsp" %>
					</div>
				</div>
			</div>

			<div class="ctn-fff box-ctn">
				<div class="box-head">
					<h4 class="pull-left">附件上传</h4>
				</div>
				<div class="box-body">
					<div class="container">
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
								<label>个人身份证照</label> <span class="btn upload-btn">点击上传图像
								<input type="file" class="input-upload" accept="image/*" name="imgFile" id="imgFile" onchange="imgUpload(this);"></span>
								<input type="hidden" name="filePath" id="filePath">
								<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<img src="${requestScope.sfzpath}" >
							</div>
						</div>
					</div>
				</div>
			</div>
			<input type="hidden" name="clerk_id" value="${requestScope.clerk_id}">
		</form>
		<%@include file="modal/orderNameSelect.jsp" %>
	</div>