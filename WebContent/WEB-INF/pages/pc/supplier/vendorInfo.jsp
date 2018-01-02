<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
    <link rel="stylesheet" type="text/css" href="../pc/css/vendorEdit.css${requestScope.ver}">
     <!-------------------secition------------>
     <form class="secition" style="margin-top:0;margin-bottom:60px">
         <div class="container" style="margin-top: 10px">
         <span style="display: none;" id="corp_id">${requestScope.vendor.corp_id}</span>
         <span style="display: none;" id="com_id">${requestScope.vendor.com_id}</span>
             <div class="secition-one">
                 <div class="secition-one-body">
                     <div class="form">
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label style="color: red;">公司全称</label>
                                 <input type="text" class="form-control input-sm" name="corp_name" value="${requestScope.vendor.corp_name}" id="corp_name" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label style="color: red;">公司简称</label>
                                 <input type="text" class="form-control input-sm" name="corp_sim_name" value="${requestScope.vendor.corp_sim_name}" id="corp_name" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label style="color: red;">业务联系人</label>
                                 <input type="text" class="form-control input-sm" name="corp_reps" value="${requestScope.vendor.corp_reps}" maxlength="20">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label style="color: red;">手机号</label>
                                 <input type="text" class="form-control input-sm" name="movtel" value="${requestScope.vendor.movtel}" id="movtel" data-num="num" maxlength="11">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>微信号</label>
                                 <input type="text" class="form-control input-sm" name="weixin" value="${requestScope.vendor.weixin}" maxlength="30">
                             </div>
                         </div>
                      <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>总经理</label>
                                 <input type="text" class="form-control input-sm" name="ceo" value="${requestScope.vendor.ceo}" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>营业执照编号</label>
                                 <input type="text" class="form-control input-sm" name="corp_working_lisence" value="${requestScope.vendor.corp_working_lisence}" maxlength="30">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>传真</label>
                                 <input type="text" class="form-control input-sm" name="fax_no" value="${requestScope.vendor.prefix}" data-num="num" maxlength="25">
                             </div>
                         </div>

                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>开户银行</label>
                                 <input type="text" class="form-control input-sm" name="bank_id" value="${requestScope.vendor.bank_id}" data-num="num" maxlength="25">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>开户行账号</label>
                                 <input type="text" class="form-control input-sm" name="bank_accounts" value="${requestScope.vendor.bank_accounts}" data-num="num" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-12 mtb">
                         <div class="form-group">
                             <label>经营范围</label>
                             <textarea class="form-control" rows="2" maxlength="500" id="working_range">${requestScope.vendor.working_range}</textarea>
                         </div>
                     	</div>
                       <div class="col-lg-12 mtb">
                             <div class="form-group">
                                 <label style="color: red;">*发货详细地址</label>
                                 <textarea class="form-control" rows="2" maxlength="100" id="corp_addr">${requestScope.vendor.corp_addr}</textarea>
                             </div>
                         </div>
                     </div>
                 </div>
             </div>
             <div class="secition-one">
            <div class="box-head">
                <h4 class="pull-left">附件上传</h4>
            </div>
            <div class="box-body">
                <div class="container">
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>个人身份证照</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
<div class="footer" style="text-align: center;">
        <button class="btn btn-info xg" id="savevendor">保存修改</button>
</div>