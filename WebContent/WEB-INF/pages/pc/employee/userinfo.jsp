<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="../res.jsp"%>
<style type="text/css">
.modal_ul>li {
	float: left;
	list-style: margin-right:9px;
	width: 70px;
	text-align: center;
}

.modal_ul {
	padding-left: 0;
}
</style>
</head>
<body>
	<div id="personnelEdit">
		<div class="bg"></div>
		<%@include file="../header.jsp"%>
		<div class="container">
			<form id="proForm">
				<div class="ctn-fff box-ctn">
					<div class="box-body">
						<div class="form">
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label><span style="color: red">*员工姓名</span></label> <input
										type="text" class="form-control input-sm" name="clerk_name"
										id="clerkName" value="${requestScope.personnel.clerk_name}"
										maxlength="20">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label><span style="color: red">*手机号(登录账号)</span></label> <input
										type="text" id="userId" readonly="readonly"
										class="form-control input-sm" name="movtel" maxlength="11"
										placeholder="将作为登录账号" value="${requestScope.personnel.movtel}">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>英文姓名</label> <input type="text"
										class="form-control input-sm" name="clerk_name_en"
										value="${requestScope.personnel.clerk_name_en}" maxlength="40">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>身份证号</label> <input type="text"
										class="form-control input-sm" name="id_card"
										value="${requestScope.personnel.id_card}" maxlength="50">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>籍贯</label> <input type="text"
										class="form-control input-sm" name="navaddr"
										value="${requestScope.personnel.navaddr}" maxlength="40">
								</div>
							</div>

							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label><span style="color: red">*职务</span></label>
									<div class="input-group">
										<input type="text" readonly="readonly"
											class="form-control input-sm zhiwuchoice" id="headship"
											name="headship" value="${requestScope.personnel.headship}"
											maxlength="20">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="ctn-fff box-ctn">
					<div class="box-head">
						<h4 class="pull-left">其他信息</h4>
					</div>
					<div class="box-body">
						<div class="form">
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>开户银行</label> <input type="text"
										class="form-control input-sm" name="bank_id"
										value="${requestScope.personnel.bank_id}" maxlength="25">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>银行账号</label> <input type="text"
										class="form-control input-sm" name="acc_no"
										value="${requestScope.personnel.acc_no}" maxlength="50">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>电话</label> <input type="text"
										class="form-control input-sm" name="tel"
										value="${requestScope.personnel.tel}" maxlength="50">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>传真</label> <input type="text"
										class="form-control input-sm" name="fax"
										value="${requestScope.personnel.fax}" maxlength="50">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>地址</label> <input type="text"
										class="form-control input-sm" name="addr1"
										value="${requestScope.personnel.addr1}" maxlength="40">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>微信号</label> <input type="text"
										class="form-control input-sm" name="weixin"
										value="${requestScope.personnel.weixin}" id="weixin"
										maxlength="30">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label><span style="color: red">*微信通讯录账号</span></label> <input
										type="text" readonly="readonly" class="form-control input-sm"
										id=weixinID name="weixinID"
										value="${requestScope.personnel.weixinID}" maxlength="30">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>QQ</label> <input type="text"
										class="form-control input-sm" name="qq"
										value="${requestScope.personnel.qq}" maxlength="30">
								</div>
							</div>
							<div class="col-lg-3 col-sm-4 m-t-b">
								<div class="form-group">
									<label>电子邮箱</label> <input type="text"
										class="form-control input-sm" name="e_mail"
										value="${requestScope.personnel.e_mail}" maxlength="50">
								</div>
							</div>
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
									<label>个人身份证照</label>
									<span class="btn upload-btn" id="upload-btn">点击上传图像
										<input type="file" class="input-upload" name="imgFile" accept="image/*"
										id="imgFile" onchange="imgUpload(this);">
									</span>
									<span class="btn upload-btn" id="scpz">点击上传图像</span>
									<input type="hidden" name="filePath" id="filePath">
									<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
								</div>
								<div class="upload-img">
									<img src="${requestScope.sfzpath}"
										onerror="this.src='../pcxy/image/upload-img.png'">
								</div>
							</div>
						</div>
					</div>
				</div>
				<input type="hidden" name="clerk_id"
					value="${requestScope.personnel.clerk_id}">
			</form>
			<div style="height: 60px; text-align: center; margin-top: 30px;">
				<button type="button" class="btn btn-success saveinfo">保存</button>
				<a href="../employee.do" class="btn btn-success">返回</a>
			</div>
		</div>
	</div>
<script type="text/javascript"
	src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="../pc/js/userinfo.js${requestScope.ver}"></script>
</body>
</html>