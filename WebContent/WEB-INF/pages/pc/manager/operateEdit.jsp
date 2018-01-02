<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <meta http-equiv="Pragma" content="no-cache" >
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <%@include file="../pcxy_res.jsp" %>
    <link rel="stylesheet" type="text/css" href="../pc/css/vendorEdit.css">
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js?ver=${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/weixin/weixininvite.js?ver=${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/manager/operateEdit.js?ver=${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<!---------------- header------------------------>
<div class="header">
    <ol class="header-ul">
        <li><a href="../employee.do">员工首页</a></li>
        <li><a href="operate.do"><span class="glyphicon glyphicon-triangle-right"></span>运营商维护</a>
        </li><li class="active"><a><span class="glyphicon glyphicon-triangle-right"></span>运营商详细</a></li>
    </ol>
    <input type="hidden" id="info" value="${requestScope.info}">
</div>
<!-------------------secition------------>
<form class="secition" id="operateForm">
    <input type="reset" id="resetForm" style="display: none;">
         <input type="hidden" id="comId" name="${sessionScope.prefix}com_id" value="${requestScope.operate.com_id}">
         <input type="hidden"  value="${requestScope.com_id }" id="com_id">
    <input type="hidden" id="math" name="math">
    <div class="container" style="margin-top: 10px">
        <div class="secition-one">
            <div class="secition-one-header">
                <h4 class="pull-left">基本信息</h4>
            </div>
            <div class="secition-one-body">
                <div class="form">
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>运营商名称</label>
                            <input type="text" class="form-control input-sm" name="${sessionScope.prefix}com_name" value="${requestScope.operate.com_name}" id="com_name" maxlength="20">
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>运营商简称</label>
                            <input type="text" class="form-control input-sm" name="${sessionScope.prefix}com_sim_name" value="${requestScope.operate.com_sim_name}" id="com_sim_name" maxlength="20">
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>联系人（法人）</label>
                            <input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_reps" value="${requestScope.operate.corp_reps}" maxlength="25">
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>公司联系电话</label>
                            <input type="text" class="form-control input-sm" name="${sessionScope.prefix}tel_no" id="tel_no"
                            value="${requestScope.operate.tel_no}" data-num="num" maxlength="11">
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>行业类型</label>
                            <input type="text" class="form-control input-sm" name="${sessionScope.prefix}trade_type" value="${requestScope.operate.trade_type}" >
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>运营状态</label>
                                 <select name="${sessionScope.prefix}working_status" class="form-control input-sm">
                                     <c:if test="${requestScope.operate.working_status=='是'}">
                                <option value="是" selected="selected">是</option>
                                <option value="否">否</option>
                            </c:if>
                            <c:if test="${requestScope.operate.working_status=='否'||requestScope.operate.working_status==null}">
                                <option value="否" selected="selected">否</option>
                                <option value="是">是</option>
                            </c:if>
                                 </select>
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>总经理</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}ceo" value="${requestScope.operate.ceo}" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>所属地区</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}regionalism_name" value="${requestScope.operate.regionalism_name}" maxlength="50">
                             </div>
                         </div>
                    <div class="col-lg-3 col-sm-4 mtb">
                        <div class="form-group">
                            <label>上级运营商编码</label>
                            <div class="input-group">
                                     <span class="form-control input-sm" id="upper_com_name" aria-describedby="basic-addon2">${requestScope.operate.upper_com_name}</span>
                                     <span class="input-group-btn">
                                         <input id="upper_com_id" type="hidden" name="${sessionScope.prefix}upper_com_id"  value="${requestScope.operate.upper_com_id}">
                                         <button class="btn btn-success btn-sm" type="button">浏览</button>
                                     </span>
                            </div>
                        </div>
                    </div> 
                    <div class="col-lg-12 mtb">
                        <div class="form-group">
                            <label>公司邮政地址</label>
                            <textarea class="form-control" rows="2" maxlength="100" name="${sessionScope.prefix}com_addr">${requestScope.operate.com_addr}</textarea>
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
<div class="footer">
    员工：${sessionScope.userInfo.personnel.clerk_name}
    <div class="btn-gp">
        <button class="btn btn-info xg" id="saveOperate">保存</button>
        <button class="btn btn-primary xg" onclick="window.location.href='operate.do'">返回</button>
    </div>
    <a id="clearcache" class="ss" style="float: right;">微信清缓存</a>
</div>
</body>
</html>