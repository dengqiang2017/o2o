<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
     <div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><a href="../employee.do">员工首页</a></li>
		  <li><a href="electrician.do"><span class="glyphicon glyphicon-triangle-right"></span>电工维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>电工维护详细</li>
		</ol>
    <div class="header-title">
    员工首页-电工维护详细<a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
		<input type="hidden" id="info" value="${requestScope.info}">
	</div>
     <!-------------------secition------------>
     <form class="secition" id="editForm" style="margin-bottom:30px">
         <input type="reset" id="resetForm" style="display: none;">
         <input type="hidden"  value="${requestScope.com_id}" id="com_id">
         <input type="hidden" id="customerId" name="customer_id" value="${requestScope.customer_id}">
         <input type="hidden" name="isclient" value="0">
        <div class="container" style="margin-top:10px;">
         <div class="ctn-fff box-ctn" >
         <div class="secition-one-body">
            <div class="form">
       			 <%@include file="../manager/edit.jsp"%>
               </div>
             </div>
         </div>
         <div class="ctn-fff box-ctn" >
			<div class="box-head">
                <h4 class="pull-left">附件上传</h4>
            </div>
            <div class="box-body">
                <div class="container">
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>个人身份证照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload"
                                                              name="Pic_IDcard" id="Pic_IDcard" onchange="imgCLientUpload(this,'Pic_IDcard','IDcard');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img id="IDcard" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>个人上半身照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload"
                                                              name="Pic_You" id="Pic_You" onchange="imgCLientUpload(this,'Pic_You','You');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img id="You" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>证件照片</label>
					<span class="btn upload-btn">点击上传图像<input type="file" accept="image/*" class="input-upload"
                                                              name="Pic_Inc" id="Pic_Inc" onchange="imgCLientUpload(this,'Pic_Inc','Inc');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img id="Inc" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
     </form>
<!-----------------------------------footer---------------------------->
<div class="footer">
    员工：${sessionScope.userInfo.personnel.clerk_name}
    <div class="btn-gp">
        <button class="btn btn-info xg" id="savedian" type="button">保存</button>
        <button class="btn btn-primary xg tolistpage" type="button">返回</button>
    </div>
</div>