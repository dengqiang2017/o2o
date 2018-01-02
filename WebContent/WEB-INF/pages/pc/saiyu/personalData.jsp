<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
        <link rel="stylesheet" type="text/css" href="../pc/saiyu/myweihu.css">
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script> 
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script src="../js/O2O.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/client.js${requestScope.ver}"></script>
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a></div>
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
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}clerk_name" maxlength="20"
					    	value="${requestScope.client.clerk_name}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>联系电话</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}tel_no" 
                    maxlength="11" data-number="num" value="${requestScope.client.tel_no}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>QQ号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}qq" maxlength="30"
                    data-number="num" value="${requestScope.client.qq}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>微信号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}weixin" maxlength="30"
					    	 value="${requestScope.client.weixin}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>微博</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}weibo" maxlength="30"
					    	value="${requestScope.client.weibo}">
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>收货地址</label>
					    	<textarea rows="2" class="form-control" name="${sessionScope.prefix}addr1" maxlength="40">${requestScope.client.addr1}</textarea>
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
					    	<input type="text" class="form-control input-sm" id="corp_name" name="${sessionScope.prefix}corp_name" maxlength="20"
					    	value="${requestScope.client.corp_name}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>职位</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}headship" maxlength="40" 
					    	value="${requestScope.client.headship}">
					  	</div>
					</div>
					<input id="clientId" type="hidden" name="${sessionScope.prefix}upper_customer_id"  value="${requestScope.client.upper_customer_id}">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>联系人</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_reps" maxlength="20"
					    	value="${requestScope.client.corp_reps}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>手机号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}movtel" id="movtel" 
                    maxlength="11" data-number="num" value="${requestScope.client.movtel}">
					  	</div>
					</div> 
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>所属部门</label>
					    	<div class="input-group">
								<span id="dept_name" class="form-control input-sm" 
								aria-describedby="basic-addon2" >${requestScope.client.dept_name}</span>
								<span class="input-group-btn">
									<input id="deptId" type="hidden" name="${sessionScope.prefix}dept_id" value="${requestScope.client.dept_id}">
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
								<span class="form-control input-sm" aria-describedby="basic-addon2" 
								id="regionalism_name_cn" >${requestScope.client.regionalism_name_cn}</span>
								<span class="input-group-btn">
									<input type="hidden" name="${sessionScope.prefix}regionalism_id" id="regionalismId" value="${requestScope.client.regionalism_id}">
							      	<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>老板姓名</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}ceo" value="${requestScope.client.ceo}" maxlength="25">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>货运方式</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HY_style" value="${requestScope.client.HY_style}" maxlength="10">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>邮编</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}zip" data-number="num" maxlength="6" value="${requestScope.client.zip}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>传真</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}fax_no"  data-number="num" maxlength="25" value="${requestScope.client.fax_no}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>税号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}tax_no" value="${requestScope.client.tax_no}" maxlength="40">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>开户银行</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}bank_id" value="${requestScope.client.bank_id}" maxlength="25">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>银行卡账号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}bank_accounts" value="${requestScope.client.bank_accounts}" maxlength="50">
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>经营范围</label>
					    	<textarea rows="2" class="form-control" name="${sessionScope.prefix}working_range" maxlength="500">${requestScope.client.working_range}</textarea>
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
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS" value="${requestScope.client.HYS}" maxlength="20">
					  	</div>
					</div> 
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>司机名称</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}Kar_Driver" value="${requestScope.client.Kar_Driver}" maxlength="4">
					  	</div>
					</div> 
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>司机手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}Kar_Driver_Msg_Mobile" data-number="num" maxlength="11" value="${requestScope.client.Kar_Driver_Msg_Mobile}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>运货商电话</label>
					    	<input type="text" class="form-control input-sm"name="${sessionScope.prefix}HYS_tel" data-number="num" maxlength="11" value="${requestScope.client.HYS_tel}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>运货商手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS_Mobile" data-number="num" maxlength="11" value="${requestScope.client.HYS_Mobile}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>运货商接收短信手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS_Msg_Mobile" data-number="num" maxlength="11" value="${requestScope.client.HYS_Msg_Mobile}">
					  	</div>
					</div>

					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>发货商地址</label>
					    	<textarea rows="2" class="form-control" name="${sessionScope.prefix}FHDZ" maxlength="50">${requestScope.client.FHDZ}</textarea>
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
			<div class="col-lg-4 col-sm-4 m-t-b">
				<div class="form-group">
					<label>电子签名</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
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
		<input type="hidden" name="${sessionScope.prefix}customer_id" value="${requestScope.client.customer_id}" id="customerId">
		<input type="hidden"  value="${requestScope.com_id}" id="com_id">
	</form>