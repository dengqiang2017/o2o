<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>O2O营销服务平台</title>
	 <%@include file="../res.jsp" %>
   <script src="../js/o2od.js"></script> 
   <script type="text/javascript" src="../pc/js/client.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>个人信息</li>
	</ol>
	<div class="header-title">客户个人信息
		<a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
	<div class="container" style="margin-top:10px;">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body">
				<div class="form">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>会员账号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}user_id"
					    	readonly="readonly"
					    	 placeholder="输入会员账号" maxlength="30" value="${requestScope.client.user_id}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>注册类型</label>
					    	<select name="" id="" class="form-control input-sm" name="${sessionScope.prefix}license_type">
					    		<c:if test="${requestScope.client.license_type==null}">
                             <option value="手机号" selected="selected">手机号</option>
                                <option value="QQ号">QQ号</option>
                                <option value="微信号">微信号</option>
                            </c:if>
                            <c:if test="${requestScope.client.license_type=='手机号'}">
                                <option value="手机号" selected="selected">手机号</option>
                                <option value="QQ号">QQ号</option>
                                <option value="微信号">微信号</option>
                            </c:if>
                            <c:if test="${requestScope.client.license_type=='QQ号'}">
                                <option value="手机号">手机号</option>
                                <option value="QQ号" selected="selected">QQ号</option>
                                <option value="微信号">微信号</option>
                            </c:if>
                            <c:if test="${requestScope.client.license_type=='微信号'}">
                                <option value="手机号">手机号</option>
                                <option value="QQ号">QQ号</option>
                                <option value="微信号" selected="selected">微信号</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>姓名</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}clerk_name" placeholder="输入姓名" maxlength="40">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>手机号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}movtel" placeholder="输入联系电话" maxlength="30" value="${requestScope.client.movtel}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>QQ号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}qq" placeholder="输入QQ号" maxlength="30" value="${requestScope.client.qq}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>微信号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}weixin" placeholder="输入微信号" maxlength="30" value="${requestScope.client.weixin}">
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>办公地址</label>
					    	<textarea rows="3" class="form-control" name="${sessionScope.prefix}addr1" placeholder="输入办公地址" maxlength="80">${requestScope.client.addr1}</textarea>
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>收货地址</label>
					    	<textarea rows="3" class="form-control" name="${sessionScope.prefix}FHDZ" placeholder="输入收货地址" maxlength="80">${requestScope.client.addr1}</textarea>
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
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>客户编码</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}self_id"
					    	 placeholder="自动生成" maxlength="30"  value="${requestScope.client.self_id}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>客户名称</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_name" placeholder="输入客户名称" maxlength="40" value="${requestScope.client.corp_name}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label><span style="color:red">*上级客户名称</span></label>
					    	<div class="input-group">
					    	<span class="form-control input-sm" id="upper_corp_name" aria-describedby="basic-addon2">
					    	<c:if test="${requestScope.client.upper_corp_name==null}">我公司(虚拟)</c:if>
					    	<c:if test="${requestScope.client.upper_corp_name!=null}">
					    	${requestScope.client.upper_corp_name}
					    	</c:if>
					    	</span>
								<span class="input-group-btn">
					    	<c:if test="${requestScope.client.upper_customer_id==null}">
					    			<input id="clientId" type="hidden" name="${sessionScope.prefix}upper_customer_id"  value="CS1">
							</c:if>
					    	<c:if test="${requestScope.client.upper_customer_id!=null}">
					    			<input id="clientId" type="hidden" name="${sessionScope.prefix}upper_customer_id"  value="${requestScope.client.upper_customer_id}">
					    	</c:if>
							       
							        <button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>联系人</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}corp_reps" placeholder="输入联系人" maxlength="50" value="${requestScope.client.corp_reps}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>联系电话</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}tel_no" placeholder="输入联系电话" maxlength="40" value="${requestScope.client.tel_no}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
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
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>所属销售代表</label>
					    	<div class="input-group">
								<span id="clerk_name" class="form-control input-sm"
								aria-describedby="basic-addon2">${requestScope.client.clerk_name}</span>
								<span class="input-group-btn">
									<input id="clerkId" type="hidden" name="${sessionScope.prefix}clerk_id" value="${requestScope.client.clerk_id}">
									<button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					  	<input type="hidden" name="${sessionScope.prefix}clerk_idAccountApprover" id="clerk_idAccountApprover" value="${requestScope.client.clerk_idAccountApprover}">
					  	<input type="hidden" name="${sessionScope.prefix}regionalism_id" id="regionalismId" value="${requestScope.client.regionalism_id}">
					</div> 
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
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
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>是否使用打欠条</label>
					    	<select name="${sessionScope.prefix}ifUseCredit" class="form-control input-sm">
				    		<c:if test="${requestScope.client.ifUseCredit=='是'}">
                               <option value="是" selected="selected">是</option>
                               <option value="否">否</option>
                            </c:if>
                            <c:if test="${requestScope.client.ifUseCredit!='是'}">
                                <option value="否" selected="selected">否</option>
                                <option value="是">是</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>是否使用预存款</label>
					    	<select name="${sessionScope.prefix}ifUseDeposit" class="form-control input-sm">
				    		<c:if test="${requestScope.client.ifUseDeposit=='是'}">
                               <option value="是" selected="selected">是</option>
                               <option value="否">否</option>
                            </c:if>
                            <c:if test="${requestScope.client.ifUseDeposit!='是'}">
                                <option value="否" selected="selected">否</option>
                                <option value="是">是</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>是否锁定单价</label>
					    	<select name="${sessionScope.prefix}price_type" class="form-control input-sm">
					    	<c:if test="${requestScope.client.price_type=='是'}">
                                <option value="是" selected="selected">是</option>
                                <option value="否">否</option>
                            </c:if>
                            <c:if test="${requestScope.client.price_type!='是'}">
                                <option value="否" selected="selected">否</option>
                                <option value="是">是</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>售价级别</label>
					    	<select name="${sessionScope.prefix}customer_third_type" class="form-control input-sm">
					    		<c:if test="${requestScope.client.customer_third_type=='零售价'}">
                                <option value="零售价" selected="selected">零售价</option>
                                <option value="批发价">批发价</option>
                            </c:if>
                            <c:if test="${requestScope.client.customer_third_type!='零售价'}">
                                <option value="零售价">零售价</option>
                                <option value="批发价" selected="selected">批发价</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>客户大类</label>
					    	<select  name="${sessionScope.prefix}customer_type" class="form-control input-sm">
					    	<c:if test="${requestScope.client.customer_type=='经销商'||requestScope.client.customer_type==null}">
					    		<option value="经销商" selected="selected">经销商</option>
					    		<option value="分销商">分销商</option>
					    		<option value="终端客户">终端客户</option>
					    	</c:if>
					    	<c:if test="${requestScope.client.customer_type=='分销商'}">
					    		<option value="经销商">经销商</option>
					    		<option value="分销商" selected="selected">分销商</option>
					    		<option value="终端客户">终端客户</option>
					    	</c:if>
					    	<c:if test="${requestScope.client.customer_type=='终端客户'}">
					    		<option value="经销商">经销商</option>
					    		<option value="分销商">分销商</option>
					    		<option value="终端客户" selected="selected">终端客户</option>
					    	</c:if>
					    	</select>
					  	</div>
					</div>
					
					
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>老板姓名</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.ceo}"  name="${sessionScope.prefix}ceo" placeholder="输入老板姓名" maxlength="50">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>货运方式</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HY_style" value="${requestScope.client.HY_style}" maxlength="10">
					  	</div>
					</div>
				 <div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>进货平均天数</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}schedule_days" data-number="num" value="${requestScope.client.schedule_days}" maxlength="4">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label><span style="color:red">*使用状态</span></label>
					    	<select name="${sessionScope.prefix}working_status" class="form-control input-sm">
					    		<c:if test="${requestScope.client.working_status=='是'}">
                                <option value="是" selected="selected">是</option>
                                <option value="否">否</option>
                            </c:if>
                            <c:if test="${requestScope.client.working_status!='是'}">
                                <option value="否" selected="selected">否</option>
                                <option value="是">是</option>
                            </c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>邮编</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.zip}" 
					    	name="${sessionScope.prefix}zip" placeholder="输入邮政编码" maxlength="10" data-number="num">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>传真</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.fax_no}" name="${sessionScope.prefix}fax_no" placeholder="输入传真号" maxlength="25">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>税号</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.tax_no}" name="${sessionScope.prefix}tax_no" placeholder="输入税号" maxlength="40">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>开户银行</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.bank_id}" name="${sessionScope.prefix}bank_id" placeholder="输入开户银行" maxlength="50">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>银行卡账号</label>
					    	<input type="text" class="form-control input-sm" value="${requestScope.client.bank_accounts}" name="${sessionScope.prefix}bank_accounts" placeholder="输入银行卡号" maxlength="50">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>进货平均天数</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}schedule_days" placeholder="输入进货平均天数" maxlength="1" data-number="num">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>市场类型</label>
					    	<select name="${sessionScope.prefix}market_type" class="form-control input-sm">
					    		<option value="经销商">经销商</option>
					    		<option value="分销商">分销商</option>
					    		<option value="终端客户">终端客户</option>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>经营范围</label>
					    	<textarea name="" id="" rows="3" class="form-control" name="${sessionScope.prefix}working_range" placeholder="输入经营范围" maxlength="500">${requestScope.client.working_range}</textarea>
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
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>货运方式</label>
					    	<select name="" id="" class="form-control input-sm" name="${sessionScope.prefix}market_type">
					    		<option value="0">客户自提</option>
					    		<option value="1">第三方物流</option>
					    		<option value="2">终端客户</option>
					    	</select>
					  	</div>
					</div>	
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>运货商联系人</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS" placeholder="输入运货商联系人" maxlength="40">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>运货商电话</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS_tel" placeholder="输入运货商电话" maxlength="30">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>运货商手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS_Mobile" placeholder="输入运货商手机" maxlength="30">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>运货商接收短信手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}HYS_Msg_Mobile" placeholder="输入运货商接收短信的手机号" maxlength="30">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>车牌号</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}Kar_paizhao" placeholder="请输入常用拉货车牌" maxlength="20">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>司机姓名</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}Kar_Driver" placeholder="请输入常用拉货司机姓名" maxlength="8">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>司机手机</label>
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}Kar_Driver_Msg_Mobile" placeholder="请输入常用拉货司机手机号" maxlength="30">
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
				<div class="form">
					<div class="ctn">
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>个人身份证</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>个人上半身照</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>办公场景照</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
					</div>

					<div class="ctn">
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>营业执照副本</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>组织机构代码证</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
						<div class="col-lg-4 col-sm-4 m-t-b">
							<div class="form-group">
							    <label>税务登记证</label>
							    <span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"></span>
							    <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
							</div>
							<div class="upload-img">
								<div class="whimg">
									<img src="pcxy/image/function-01.png" alt="">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>



<div class="footer">
	客户:${sessionScope.customerInfo.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
	<div class="btn-gp">
			<button class="btn btn-info" id="saveClient">保存</button>
			<a href="../customer.do" class="btn btn-primary">返回</a>
		</div>	
</div>
 <script type="text/javascript">
 <!--
 
 $("#saveClient").click(function(){
	   if ($.trim($("#userId").val())=="") {
		pop_up_box.showMsg("请输入客户登录账号!");
	   }else if($.trim($("#pwd").val())==""){
		   pop_up_box.showMsg("请输入客户登录密码!");
	   }else if($.trim($("#corp_name").val())==""){
		   pop_up_box.showMsg("请输入客户名称!");
	   }else if($.trim($("#corp_sim_name").val())==""){
		   pop_up_box.showMsg("请输入客户简称!");
	   }else if($.trim($("#movtel").val())==""){
		   pop_up_box.showMsg("请输入手机号!");
	   }else if($.trim($("#clerk_idAccountApprover").val())==""){
		   pop_up_box.showMsg("请选择客户款项审批人!");
	   }
	   else{
		   pop_up_box.postWait();  
		   $("input[name='salesOrder_Process_Name']").val($("input:radio:checked").next().html());
		   $.post("saveClient.do",$("#clientForm").serialize(),function(data){
			   pop_up_box.loadWaitClose();
			   if (data.success) {
				   pop_up_box.showMsg("保存成功返回列表页面!",function(){
					   $("form>input").val("");
					   window.location.href="client.do";
				   });
			}else{
				pop_up_box.showMsg("保存失败,错误:"+data.msg);
			}
		   });
	   }
 });
 
 //-->
 </script>
</body>
</html>

    