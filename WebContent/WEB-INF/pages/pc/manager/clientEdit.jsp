<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="bg"></div><div class="header">
		<ol class="breadcrumb">
		  <li><a href="../employee.do">员工首页</a></li>
		  <li class="tolistpage"><a><span class="glyphicon glyphicon-triangle-right"></span>客户维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户详细</li>
		</ol>
	    <div class="header-title">
	    客户详细 <a class="header-back tolistpage"><span class="glyphicon glyphicon-menu-left"></span></a>
	    </div>
		<input type="hidden" id="info" value="${requestScope.info}">
	</div><form id="editForm">
	<input type="reset" id="resetForm" style="display: none;">
	<input type="hidden" name="type">
	<div class="container" style="margin-top:10px;margin-bottom:30px">
		<div class="ctn-fff box-ctn">
			<div class="box-body">
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
			<div class="container">
			<div class="col-lg-4 col-sm-4 m-t-b">
				<div class="form-group">
					<label>个人身份证照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_IDcard" id="Pic_IDcard" onchange="imgCLientUpload(this,'Pic_IDcard','IDcard');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="IDcard" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
			<div class="col-lg-4 col-sm-4 m-t-b" style="display: none;">
				<div class="form-group">
					<label>个人上半身照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_You" id="Pic_You" onchange="imgCLientUpload(this,'Pic_You','You');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="You" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
			<div class="col-lg-4 col-sm-4 m-t-b" style="display: none;">
				<div class="form-group">
					<label>办公场景照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_Inc" id="Pic_Inc" onchange="imgCLientUpload(this,'Pic_Inc','Inc');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="Inc" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
		</div>

		<div class="container">
			<div class="col-lg-4 col-sm-4 m-t-b" style="display: none;">
				<div class="form-group">
					<label>营业执照副本</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_BusinessLicense" id="Pic_BusinessLicense" onchange="imgCLientUpload(this,'Pic_BusinessLicense','BusinessLicense');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="BusinessLicense" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
			<div class="col-lg-4 col-sm-4 m-t-b" style="display: none;">
				<div class="form-group">
					<label>组织机构代码证</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_OrganizationCode" id="Pic_OrganizationCode" onchange="imgCLientUpload(this,'Pic_OrganizationCode','OrganizationCode');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="OrganizationCode" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
			<div class="col-lg-4 col-sm-4 m-t-b" style="display: none;">
				<div class="form-group">
					<label>税务登记证</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="Pic_TaxRegistration" id="Pic_TaxRegistration" onchange="imgCLientUpload(this,'Pic_TaxRegistration','TaxRegistration');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="TaxRegistration" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
			<div class="col-lg-4 col-sm-4 m-t-b">
				<div class="form-group">
					<label>电子签名</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" accept="image/*"
					name="qianming" id="qianming" onchange="imgCLientUpload(this,'qianming','qianmingImg');"></span>
					<p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
				</div>
				<div class="upload-img">
					<img id="qianmingImg" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
				</div>
			</div>
		</div>
			</div>
		</div>
	</div>
		<input type="hidden" name="customer_id" value="${requestScope.customer_id}" id="customerId">
		<input type="hidden" value="${requestScope.com_id }" id="com_id">
		<input type="hidden" id="math" name="math">
	</form><%@include file="modal/orderNameSelect.jsp"%><div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<c:if test="${requestScope.info=='info' }">
			<button class="btn btn-warning" id="edit" type="button">修改</button>&emsp;&emsp;
			</c:if>
			<button class="btn btn-info" id="saveClient" type="button">保存</button>&emsp;&emsp;
			<c:if test="${requestScope.info!='show' }">
			<button class="btn btn-primary tolistpage" type="button">返回</button>&emsp;&emsp;
			</c:if>
			<c:if test="${requestScope.info=='show' }">
			<button class="btn btn-primary tolistpage" onclick="window.close();" type="button">关闭</button>&emsp;&emsp;
			</c:if>
		</div>
	</div>