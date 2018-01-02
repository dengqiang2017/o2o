<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>O2O营销服务平台</title>
<%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../pcxy/css/product.css">
    <script src="../js/o2od.js"></script>
    <script src="../js/o2otree.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/employee/productpage.js"></script>
    <script type="text/javascript" src="../pc/js/customer/myorder.js?ver=002"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="customer.do">客户首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>个人信息</li>
    </ol>
    <div class="header-title">客户 -个人信息
        <a href="customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <div class="header-logo"></div>
</div>






                    <form id="clientForm">
                        <input type="reset" id="resetForm" style="display: none;">
                        <div class="container" style="margin-top:10px;">
                            <div class="ctn-fff box-ctn">
                                <div class="box-head">
                                    <h4 class="pull-left">基本信息</h4>
                                </div>
                                <div class="box-body">
                                    <div class="form">
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>姓名</label>
                                                <input type="text" class="form-control input-sm" name="cbeclerk_name" maxlength="20" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>联系电话</label>
                                                <input type="text" class="form-control input-sm" name="cbetel_no" maxlength="11" data-number="num" value="18224052021">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>QQ号</label>
                                                <input type="text" class="form-control input-sm" name="cbeqq" maxlength="30" data-number="num" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>微信号</label>
                                                <input type="text" class="form-control input-sm" name="cbeweixin" maxlength="30" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>微博</label>
                                                <input type="text" class="form-control input-sm" name="cbeweibo" maxlength="30" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-12 m-t-b">
                                            <div class="form-group">
                                                <label>收货地址</label>
                                                <textarea rows="2" class="form-control" name="cbeaddr1" maxlength="40"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="ctn-fff box-ctn">
                                <div class="box-head">
                                    <h4 class="pull-left">业务信息</h4>
                                </div>
                                <div class="box-body">
                                    <div class="form">
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>客户名称</label>
                                                <input type="text" class="form-control input-sm" id="corp_name" name="cbecorp_name" maxlength="20" value="邓强">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>职位</label>
                                                <input type="text" class="form-control input-sm" name="cbeheadship" maxlength="40" value="工程">
                                            </div>
                                        </div>
                                        <input id="clientId" type="hidden" name="cbeupper_customer_id" value="CS1C003242">
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>联系人</label>
                                                <input type="text" class="form-control input-sm" name="cbecorp_reps" maxlength="20" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>手机号</label>
                                                <input type="text" class="form-control input-sm" name="cbemovtel" id="movtel" maxlength="11" data-number="num" value="18224052021">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>所属部门</label>
                                                <div class="input-group">
                                                    <span id="dept_name" class="form-control input-sm" aria-describedby="basic-addon2"></span>
								<span class="input-group-btn">
									<input id="deptId" type="hidden" name="cbedept_id" value="">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>行政区划</label>
                                                <div class="input-group">
                                                    <span class="form-control input-sm" aria-describedby="basic-addon2" id="regionalism_name_cn"></span>
								<span class="input-group-btn">
									<input type="hidden" name="cberegionalism_id" id="regionalismId" value="">
							      	<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>老板姓名</label>
                                                <input type="text" class="form-control input-sm" name="cbeceo" value="" maxlength="25">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>货运方式</label>
                                                <input type="text" class="form-control input-sm" name="cbeHY_style" value="" maxlength="10">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>邮编</label>
                                                <input type="text" class="form-control input-sm" name="cbezip" data-number="num" maxlength="6" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>传真</label>
                                                <input type="text" class="form-control input-sm" name="cbefax_no" data-number="num" maxlength="25" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>税号</label>
                                                <input type="text" class="form-control input-sm" name="cbetax_no" value="" maxlength="40">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>开户银行</label>
                                                <input type="text" class="form-control input-sm" name="cbebank_id" value="" maxlength="25">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>银行卡账号</label>
                                                <input type="text" class="form-control input-sm" name="cbebank_accounts" value="" maxlength="50">
                                            </div>
                                        </div>
                                        <div class="col-lg-12 m-t-b">
                                            <div class="form-group">
                                                <label>经营范围</label>
                                                <textarea rows="2" class="form-control" name="cbeworking_range" maxlength="500"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="ctn-fff box-ctn">
                                <div class="box-head">
                                    <h4 class="pull-left">货运信息</h4>
                                </div>
                                <div class="box-body">
                                    <div class="form">
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>运货商名称</label>
                                                <input type="text" class="form-control input-sm" name="cbeHYS" value="" maxlength="20">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>司机名称</label>
                                                <input type="text" class="form-control input-sm" name="cbeKar_Driver" value="" maxlength="4">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>司机手机</label>
                                                <input type="text" class="form-control input-sm" name="cbeKar_Driver_Msg_Mobile" data-number="num" maxlength="11" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>运货商电话</label>
                                                <input type="text" class="form-control input-sm" name="cbeHYS_tel" data-number="num" maxlength="11" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>运货商手机</label>
                                                <input type="text" class="form-control input-sm" name="cbeHYS_Mobile" data-number="num" maxlength="11" value="">
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>运货商接收短信手机</label>
                                                <input type="text" class="form-control input-sm" name="cbeHYS_Msg_Mobile" data-number="num" maxlength="11" value="">
                                            </div>
                                        </div>

                                        <div class="col-lg-12 m-t-b">
                                            <div class="form-group">
                                                <label>发货商地址</label>
                                                <textarea rows="2" class="form-control" name="cbeFHDZ" maxlength="50"></textarea>
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
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_IDcard" id="Pic_IDcard" onchange="imgCLientUpload(this,'Pic_IDcard','IDcard');"></span>
                                                <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                                            </div>
                                            <div class="upload-img">
                                                <img id="IDcard" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                                            </div>
                                        </div>
                                        <div class="col-lg-4 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>个人上半身照</label>
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_You" id="Pic_You" onchange="imgCLientUpload(this,'Pic_You','You');"></span>
                                                <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                                            </div>
                                            <div class="upload-img">
                                                <img id="You" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                                            </div>
                                        </div>
                                        <div class="col-lg-4 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>办公场景照</label>
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_Inc" id="Pic_Inc" onchange="imgCLientUpload(this,'Pic_Inc','Inc');"></span>
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
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_BusinessLicense" id="Pic_BusinessLicense" onchange="imgCLientUpload(this,'Pic_BusinessLicense','BusinessLicense');"></span>
                                                <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                                            </div>
                                            <div class="upload-img">
                                                <img id="BusinessLicense" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                                            </div>
                                        </div>
                                        <div class="col-lg-4 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>组织机构代码证</label>
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_OrganizationCode" id="Pic_OrganizationCode" onchange="imgCLientUpload(this,'Pic_OrganizationCode','OrganizationCode');"></span>
                                                <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                                            </div>
                                            <div class="upload-img">
                                                <img id="OrganizationCode" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                                            </div>
                                        </div>
                                        <div class="col-lg-4 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>税务登记证</label>
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="Pic_TaxRegistration" id="Pic_TaxRegistration" onchange="imgCLientUpload(this,'Pic_TaxRegistration','TaxRegistration');"></span>
                                                <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                                            </div>
                                            <div class="upload-img">
                                                <img id="TaxRegistration" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                                            </div>
                                        </div>
                                        <div class="col-lg-4 col-sm-4 m-t-b">
                                            <div class="form-group">
                                                <label>电子签名</label>
                                                <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload" name="qianming" id="qianming" onchange="imgCLientUpload(this,'qianming','qianmingImg');"></span>
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
                        <input type="hidden" name="cbecustomer_id" value="C003236" id="customerId">
                        <input type="hidden" value="" id="com_id">
                    </form>




<div class="back-top" id="scroll"></div>
<div class="footer">
    客户: 18382906844<span class="glyphicon glyphicon-earphone" style="display: none;"></span>
    <a id="clearcache" style="float: right;">微信清缓存</a></div>
<a href="#cop" class="back-bottom"></a>
<div class="copyright" id="cop">蜀ICP备11015949号-1  <br>版权所有©1998～2030软件</div>
</body>
</html>