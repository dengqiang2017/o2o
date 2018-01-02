<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head lang="en">
    <meta charset="UTF-8">
    <title>供应商维护</title>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
</head>
<body>
    
     <div class="bg"></div>
     <!---------------- header------------------------>
     <div class="header">
         <ol class="header-ul">
             <li>
                 <a href="../employee.do">员工首页</a>
             </li>
             <li>
                 <a class="tolistpage">
                     <span class="glyphicon glyphicon-triangle-right "></span>
                     供应商维护
                 </a>
             </li>
             <li>
                     <span class="glyphicon glyphicon-triangle-right"></span>
                       供应商维护详细
             </li>
         </ol>
         <input type="hidden" id="info" value="${requestScope.info}">
     </div>
     <!-------------------secition------------>
     <form class="secition" id="editForm">
         <input type="reset" id="resetForm" style="display: none;">
         <input type="hidden" id="corpId" name="corp_id" value="${requestScope.corp_id}">
         <input type="hidden"  value="${requestScope.com_id }" id="com_id">
         <div class="container" style="margin-top: 10px">
             <div class="secition-one">
<%--                ${sessionScope.prefix}      <c:if test="${requestScope.vendor.weixinStatus=='4'||requestScope.vendor.weixinStatus==null}"> --%>
<%--                      <button type="button" class="btn btn-danger btn-sm" style="margin-right: 2px" onclick="weixininviteEdit('${requestScope.vendor.weixinID}');">邀请关注</button> --%>
<%-- 				</c:if> --%>
                 <div class="secition-one-body">
                     <div class="form">
                     <%@include file="edit.jsp"%>
                     </div>
                 </div>
             </div>
 <input type="hidden" id="math" name="math">
             <div class="secition-one" >
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
                    <div class="col-lg-4 col-sm-4 m-t-b">
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
                    <div class="col-lg-4 col-sm-4 m-t-b">
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
                    <div class="col-lg-4 col-sm-4 m-t-b">
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
                    <div class="col-lg-4 col-sm-4 m-t-b">
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
                    <div class="col-lg-4 col-sm-4 m-t-b">
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
                </div>
            </div>
        </div>
         </div>
     </form>
<!-----------------------------------footer---------------------------->
<div class="footer">
    员工：${sessionScope.userInfo.personnel.clerk_name}
    <div class="btn-gp">
        <button class="btn btn-info xg" id="savevendor" type="button">保存</button>
        <button class="btn btn-primary xg tolistpage"  type="button">返回</button>
    </div>
    <a id="clearcache" class="ss" style="float: right;">微信清缓存</a>
</div>
</body>
</html>