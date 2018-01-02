<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <link rel="stylesheet" type="text/css" href="../pc/css/dianEdit.css">
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js?ver=${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/weixin/weixininvite.js?ver=${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/manager/dianEdit.js?ver=${requestScope.ver}"></script>
     <!-------------------secition------------>
     <form class="secition" id="dianForm" style="margin-bottom:30px">
         <input type="reset" id="resetForm" style="display: none;">
         <input type="hidden" id="customerId" name="${sessionScope.prefix}customer_id" value="${requestScope.dian.customer_id}">
         <input type="hidden"  value="${requestScope.com_id}" id="com_id">
        <div class="container" style="margin-top:10px;">
             <div class="ctn-fff box-ctn">
			<div class="box-head">
                     <h4 class="pull-left">基本信息</h4>
                 </div>
                 <div class="secition-one-body">
                     <div class="form">
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>登录账号</label>
                                 <span class="form-control input-sm" >${requestScope.dian.user_id}</span>
                             </div>
                         </div>
                                 <input type="hidden" readonly="readonly" class="form-control input-sm" name="${sessionScope.prefix}user_id" value="${requestScope.dian.user_id}" data-num="num" id="userId" maxlength="11">
                                 <input type="hidden" class="form-control input-sm" name="${sessionScope.prefix}user_password" value="${requestScope.dian.user_password}" id="pwd" maxlength="16" title="修改密码请清空后重新输入" placeholder="6-16位，由数字、字母和标点符号组成">

                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label>微信状态操作</label>
                                 <select name="weixinStatus"  id="weixinStatus" class="form-control input-sm">
                                     <c:if test="${requestScope.dian.weixinStatus=='1'}">
                            	<option value="1" selected="selected">已关注</option>
                                <option value="2">已冻结</option>
                                <option value="4">未关注</option>
                            </c:if>
                            <c:if test="${requestScope.dian.weixinStatus=='2'}">
                                <option value="1">已关注</option>
                                <option value="2" selected="selected">已冻结</option>
                                <option value="4">未关注</option>
                            </c:if>
                            <c:if test="${requestScope.dian.weixinStatus=='4'}">
                                <option value="1">已关注</option>
                                <option value="2">已冻结</option>
                                <option value="4" selected="selected">未关注</option>
                            </c:if>
                            <c:if test="${requestScope.dian.weixinStatus!='1'&&requestScope.dian.weixinStatus!='2'&&requestScope.dian.weixinStatus!='4'}">
                            	<option></option>
                            	<option value="1">已关注</option>
                                <option value="2">已冻结</option>
                                <option value="4">未关注</option>
                            </c:if>
                                 </select>
                             </div>
                         </div>

                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label><span style="color:red">*联系电话</span></label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}tel_no" value="${requestScope.dian.tel_no}" data-num="num">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>QQ号</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}qq" value="${requestScope.dian.qq}" data-num="num" maxlength="30">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>微信号</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}weixin" value="${requestScope.dian.weixin}" maxlength="30">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label><span style="color:red">*微信通讯录账号</span></label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}weixinID" value="${requestScope.dian.weixinID}" maxlength="30">
                             </div>
                         </div> 
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label>开始合作日期</label>
                                  <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}'})" name="${sessionScope.prefix}star_cooperate_date" value="${requestScope.dian.star_cooperate_date}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label>结束合作日期</label>
                                 <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01'})"  name="${sessionScope.prefix}end_cooperate_date" value="${requestScope.dian.end_cooperate_date}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>电工职称</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_working_lisence" value="${requestScope.dian.corp_working_lisence}" maxlength="30">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>证件类型</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}license_type" value="${requestScope.dian.license_type}" maxlength="10">
                             </div>
                         </div>
<!--                          <div class="col-lg-3 col-sm-4 mtb"> -->
<!--                              <div class="form-group"> -->
<!--                                  <label>所属默认经办人</label> -->
<%--                                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}clerk_id" value="${requestScope.dian.clerk_id}" data-num="num" maxlength="35"> --%>
<!--                              </div> -->
<!--                          </div> -->
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label><span style="color:red">*工作状态</span></label>
                                 <select name="${sessionScope.prefix}working_status" class="form-control input-sm">
	                            <c:if test="${requestScope.dian.working_status=='是'}">
	                                <option value="是" selected="selected">是</option>
	                                <option value="否">否</option>
	                            </c:if>
	                            <c:if test="${requestScope.dian.working_status!='是'}">
	                                <option value="否" selected="selected">否</option>
	                                <option value="是">是</option>
	                            </c:if>
                                 </select>
                             </div>
                         </div>
                         <div class="col-lg-12 mtb">
                             <div class="form-group">
                                 <label><span style="color:red">*详细地址</span></label>
                                 <textarea class="form-control" rows="2" maxlength="100" name="${sessionScope.prefix}addr1">${requestScope.dian.addr1}</textarea>
                             </div>
                         </div>
                     </div>
                 </div>
             </div>

             <div class="ctn-fff box-ctn">
			<div class="box-head">
                     <h4 class="pull-left">业务信息</h4>
                 </div>
                 <div class="secition-one-body">
                     <div class="form">
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label>电工外码</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}self_id" value="${requestScope.dian.self_id}" id="self_id" maxlength="30">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>电工名称</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_name" value="${requestScope.dian.corp_name}" id="corp_name" maxlength="20">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label><span style="color:red">*电工简称</span></label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_sim_name" value="${requestScope.dian.corp_sim_name}" id="corp_sim_name" maxlength="20">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label>记忆码</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}easy_id" value="${requestScope.dian.easy_id}" id="easy_id" maxlength="40">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label><span style="color:red">*默认业务联系人</span></label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_reps" value="${requestScope.dian.corp_reps}" maxlength="20">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb" style="display: none;">
                             <div class="form-group">
                                 <label><span style="color:red">*手机号</span></label>
                                 <input type="hidden" class="form-control input-sm" name="${sessionScope.prefix}movtel" value="${requestScope.dian.movtel}" id="movtel" data-num="num" maxlength="11">
                             </div>
                         </div>
                          <input type="hidden" class="form-control input-sm" name="${sessionScope.prefix}pay_style" value="${requestScope.dian.pay_style}" maxlength="20">
                          <input type="hidden" name="${sessionScope.prefix}regionalism_id" value="${requestScope.dian.regionalism_id}" id="regionalismId">
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>电子邮件</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}e_mail" value="${requestScope.dian.e_mail}" data-number="num" maxlength="6">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>开户银行</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}bank_id" value="${requestScope.dian.bank_id}" data-num="num" maxlength="25">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>开户行账号</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}bank_accounts" value="${requestScope.dian.bank_accounts}" data-num="num" maxlength="50">
                             </div>
                         </div>
                         <div class="col-lg-12 mtb">
                         <div class="form-group">
                             <label>经营范围</label>
                             <textarea class="form-control" rows="2" maxlength="500" name="${sessionScope.prefix}working_range">${requestScope.dian.working_range}</textarea>
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
                            <label>电工证照片</label>
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
                            <label>电工等级证照片</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
                                                              name="Pic_BusinessLicense" id="Pic_BusinessLicense" onchange="imgCLientUpload(this,'Pic_BusinessLicense','BusinessLicense');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img id="BusinessLicense" src="../pcxy/image/upload-img.png" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                </div>
            </div>
        </div>
         </div>
         <button type="button" class="btn btn-lg btn-primary btn-block btn-margintop" id="savedian">保存</button>
     </form>