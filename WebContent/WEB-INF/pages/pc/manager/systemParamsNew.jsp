<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<!-- 	<link rel="stylesheet" href="../pcxy/css/function.css"> -->
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/systemParamsNew.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/serializeJSON.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-body" style="min-height: 500px;margin-top: 50px;">
				<ul class="nav nav-tabs">
					<li role="presentation" class="active"><a>设置中心</a></li>
					<li role="presentation"><a>系统控制</a></li>
					<li role="presentation"><a>微信相关设置</a></li>
					<li role="presentation"><a>流程控制与信息控制</a></li>
					<li role="presentation" style="display: ;"><a>生产计划控制</a></li>
					<li role="presentation" style="display: none;"><a>行业分类控制</a></li>
				</ul>
				<form>
					<div class="tabs-content">
						<div class="col-sm-6" style="display: none;">
							<div class="form-group-double">
								<label for="" class="col-sm-3">准确提货时段</label>
								<div class="double-input col-sm-9">
									<input type="tel" id="dayN1_SdOutStore_Of_SdPlan"
										name="dayN1_SdOutStore_Of_SdPlan" data-number="num" value="3">
									<span>~</span> <input type="tel"
										id="dayN2_SdOutStore_Of_SdPlan"
										name="dayN2_SdOutStore_Of_SdPlan" data-number="num" value="2">
								</div>
							</div>
						</div>
						<div class="col-sm-6" style="display: none;">
							<div class="form-group-double">
								<label for="" class="col-sm-3">插单提货时段</label>
								<div class="double-input col-sm-9">
									<input type="tel" id="dayM1_SdOutStore_Of_SdPlan"
										name="dayM1_SdOutStore_Of_SdPlan" data-number="num" value="3">
									<span>~</span> <input type="tel"
										id="dayM2_SdOutStore_Of_SdPlan" data-number="num" value="3">
								</div>
							</div>
						</div>
						<div class="col-sm-6" style="display: none;">
							<div class="form-group-double">
								<label for="" class="col-sm-3">计划查询时段</label>
								<div class="double-input col-sm-9">
									<input type="text" class="Wdate"
										onFocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})"
										id="dayTime_Of_SdPlan" value="14:00:00"
										name="dayTime_Of_SdPlan">
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group-double">
								<label for="" class="col-sm-3">每天下计划结束点</label>
								<div class="double-input col-sm-9">
									<input type="date" class="Wdate"
										onFocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})"
										id="planEndTime" value="21:00:00"
										name="planEndTime">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<div style="display: none;">
									<label>
									<input type="checkbox" name="orderplan">下订单选计划
									</label> 
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="accnIvt">显示库存数
									</label> 
									</div>
									<div>
									<label>
									<input type="checkbox" name="moreMemo">业务员代下订单特殊工艺备注
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="moreColor">客户自主下单特殊工艺备注
									</label>
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="safe">微信消息是否加密
									</label>
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="isAutoFind">微信消息进入自动查询
									</label>
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="isShowAllProduct">在首页显示其他运营商产品
									</label>
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="isGenerateSaturday">生成星期六签到初始记录
									</label>
									</div>
									<div style="display: none;">
									<label>
									<input type="checkbox" name="isGenerateSunday">生成星期天签到初始记录
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="weixinMoreDept">成员微信通讯录中多部门
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="zeroStockOrder">0库存下订单
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="autoRegister">客户进入自动注册
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="payTestOne">支付测试1分钱
									</label>
									</div>
									<div>
									<label>
									<input type="checkbox" name="moreAdd">报价单中产品重复报价
									</label>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<div>
									<label>注册送金币</label> 
									<input type="tel" data-num="num" name="zhuce_jinbi" value="1000">
									</div>
									<div>
									<label>分享送金币</label> 
									<input type="tel" data-num="num" name="fenx_jinbi" value="30">
									</div>
									<div>
									<label>评价送金币</label> 
									<input type="tel" data-num="num" name="pingjia_jinbi" value="30">
									</div>
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">客户登录后提醒员工的职务</span><input
										type="text" id="loginNoticeHeadship" name="loginNoticeHeadship">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">收款确认到账后通知客户的职务</span><input
										type="text" id="paymentConfirmationHeadship" name="paymentConfirmationHeadship">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">系统名称设置</span>
									<input type="text" name="systemName">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;display: none;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">支付宝合作身份者ID(支付宝商家号)</span> <input
										type="text" name="alipay_partner"
										placeholder="以2088开头由16位纯数字组成的字符串">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;display: none;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">收款支付宝账号</span><input
										type="text" name="alipay_seller_email">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0;display: none;">
							<div class="col-sm-6">
								<div class="single-input col-sm-9">
									<span style="margin-right: 10px;">支付宝商户的私钥</span><input
										type="text" name="alipay_key">
								</div>
							</div>
						</div>
						<div class="ctn" style="padding: 6px 0; display: none;"
							id="saiyuElecSet">
							<div class="col-sm-6">
								<div
									style="border: 1px solid #666; margin-bottom: 10px; padding: 5px;">
									<div class="single-input col-sm-9" style="margin-bottom: 10px;">
										<span style="margin-right: 10px;">预约电工选择后：通知客户员工职务</span><input
											type="text" name="clientElecHeadship">
									</div>
									<div class="single-input col-sm-10">
										<span style="margin-right: 10px;">预约电工选择后：通知平台内部员工职务</span><input
											type="text" name="employeeElecHeadship">
									</div>
									<div style="clear: both"></div>
								</div>
								<div
									style="border: 1px solid #666; margin-bottom: 10px; padding: 5px;">
									<div class="single-input col-sm-9" style="margin-bottom: 10px;">
										<span style="margin-right: 10px;">电工安装后：通知客户员工职务</span><input
											type="text" name="elecClientHeadship">
									</div>
									<div class="single-input col-sm-9">
										<span style="margin-right: 10px;">电工安装后：通知平台内部员工职务</span><input
											type="text" name="elecEmployeeHeadship">
									</div>
									<div style="clear: both"></div>
								</div>
								<div
									style="border: 1px solid #666; margin-bottom: 10px; padding: 5px;">
									<div class="single-input col-sm-9" style="margin-bottom: 10px;">
										<span style="margin-right: 10px;">客户验收评价后：通知客户员工职务</span><input
											type="text" name="acceptanceNoticeClientHeadship">
									</div>
<!-- 									<div class="single-input col-sm-10"> -->
<!-- 										<span style="margin-right: 10px;">客户验收评价后：通知平台内部员工职务</span><input -->
<!-- 											type="text" id="acceptanceNoticeElpoyeeHeadship"> -->
<!-- 									</div> -->
									<div style="clear: both"></div>
								</div>
								<div style="border: 1px solid #666; margin-bottom: 10px; padding: 5px; display: none;">
									<div class="single-input col-sm-10"
										style="margin-bottom: 10px;">
										<span style="margin-right: 10px;">客户支付安装费后：通知客户员工职务</span><input
											type="text" name="payNoticeClientHeadship">
									</div>
									<div class="single-input col-sm-10">
										<span style="margin-right: 10px;">客户支付安装费后：通知平台内部员工职务</span><input
											type="text" name="payNoticeElpoyeeHeadship">
									</div>
									<div style="clear: both"></div>
								</div>
							</div>
						</div>
						<div style="margin-bottom: 10px; padding: 5px; ">
							<div class="single-input col-sm-6" style="margin-bottom: 10px;">
								<span style="margin-right: 10px;">运营商类型</span>
								<select name="operatorType">
								<option value="b-c">B-C 商家对消费者</option>
								<option value="b-b">B-B 商家对商家</option>
								</select>
							</div>
							<div class="single-input col-sm-6" style="margin-bottom: 10px;">
								<span style="margin-right: 10px;">零售产品首页排序方式</span>
								<select name="zeroDesc">
								<option value="View_productNum">按浏览量</option>
								<option value="View_productSdoq">按销售量</option>
								</select>
							</div>
							<div style="clear: both"></div>
						</div>
					</div>
					<div class="tabs-content">
						<div class="ctn"
							style="border-bottom: 1px solid #ddd; padding: 6px 0;">
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">短信平台企业ID</label>
									<div class="single-input col-sm-9">
										<input type="tel" maxlength="50" name="smsid">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">通知类短信用户名</label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="50" name="SmsUsername">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">通知类短信密码</label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="50" name="SmsPassword">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">营销类短信用户名</label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="50" name="YxSmsUsername">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">营销类短信密码</label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="50" name="YxSmsPassword">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
								<label>客户资料中短信发送账号类型</label>
								<label><input type="radio" name="smsType" value="0" checked="checked">营销账号</label>
       			 				<label><input type="radio" name="smsType" value="1">行业通知账号</label>
								</div>
							</div>
						</div>
						<div class="ctn"
							style="border-bottom: 1px solid #ddd; padding: 6px 0;">
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">留言邮箱</label>
									<div class="single-input col-sm-9">
										<input type="email" maxlength="50" name="tomail">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">账号短信验证码</label>
									<div class="single-input col-sm-9">
									<div>
									<label>
									<input type="checkbox" name="debug">不发送验证码短信
									</label>
									</div>
										<input type="text" maxlength="20" name="sendMsgBegin">
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group-single">
									<label for="" class="col-sm-3">账号短信验证码后缀</label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="20" name="sendMsgEnd">
									</div>
								</div>
							</div>
						</div>

						<div class="ctn" style="padding: 6px 0;">
							<div class=" ">
								<div class="form-group-single">
									<label for="" class="col-sm-3">测试发货短信的发送号码</label>
									<div class="single-input col-sm-9">
									<div><label>
									<input type="checkbox" name="order_sms_debug">勾我发送此手机的测试短信:
									</label></div>
										<input type="tel" maxlength="11" data-number="num"
											name="order_sms_no">
									</div>
									发送第一条微信到通讯录账号:<input type="text" maxlength="30"
										name="systemWeixin">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class=" ">
								<div class="form-group-p">
									<label for="" class="col-sm-3">发货短信格式<span
										style="font-weight: normal;">标点符号请使用中文格式</span></label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="20" name="sms_format1" value="">xxx<input
											type="text" maxlength="20" name="sms_format2" value="">
										，订单编号为：xxx，发货日期xxx,明细如下：xxxx <input type="text" maxlength="20"
											name="sms_format3" value="">xxx元，请注意收货！
									</div>
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">发送正式短信时所使用的个性签名</label>
								<div class="single-textarea col-sm-3">
									<input type="text" maxlength="20" style="width: 80%;"
										name="sendSmsEnd">
								</div>
							</div>
						</div>
						
						<div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">当前使用域名</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="urlPrefix">
								</div>
							</div>
						</div>
					</div>
					<div class="tabs-content">
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号corpid</label>
								<div class="single-input col-sm-9">
									<input type="text" name="corpid">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号corpsecret</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="corpsecret">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号-企业会话-Secret</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="corpsecret_chat">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="col-sm-3">
								<label for="" class="col-sm-6">微信企业号应用ID</label>
								<div class="single-input col-sm-3">
									<input type="tel" name="agentid" data-num="num" maxlength="3" style="width: 50px;">
								</div>
							</div>
							<div class="col-sm-3">
								<label for="" class="col-sm-6">应用在微信企业号中可见部门ID</label>
								<div class="single-input col-sm-3">
									<input type="tel" name="agentDeptId" data-num="num" maxlength="5" style="width: 50px;">
								</div>
							</div>
							<div class="col-sm-3">
								<label for="" class="col-sm-7">微信企业号中的商家号</label>
								<div class="single-textarea col-sm-5">
									<input type="tel" name="mch_id" data-num="num" maxlength="12"  style="width: 200px;">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号中的密钥</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="sEncodingAESKeyA">
								</div>
							</div>
						</div>
						<div style="margin-bottom: 10px; border: 1px solid #ddd; padding: 5px;">
							<label>微信企业号角色对应</label>
<!-- 						改版页面时需要保留id,name和roleitem -->
						<div id="agentJsons">
							<div class="ctn roleitem">
							<div class="form-group-single">
							<span>角色:</span><input type="text" placeholder="角色" id="role" value="员工">
							<span>对应的企业号应用id</span><input type="tel" data-num="num" maxlength="3" id="roleAgentId" placeholder="该角色对应的企业号应用id">
							<button type="button" class="roleAdd">增加</button><button type="button" onclick="$(this).parents('.roleitem').remove()">删除</button>
							</div>
							</div>
						</div>
						</div>
						<h2>微信服务号设置</h2>
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信服务号appid</label>
								<div class="single-input col-sm-9">
									<input type="text" name="appid_service">
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信服务号secret</label>
								<div class="single-input col-sm-9">
									<input type="text"  name="secret_service">
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信服务号中的商家号</label>
								<div class="single-input col-sm-9">
									<input type="text"  name="mch_id_service">
								</div>
							</div>
						</div>
						<div class="col-sm-9" style="border: 1px solid #F00">
							<div class="form-group-single">
							    <label for="">系统默认使用微信公众号类型</label>
								<label class="col-sm-3"><input type="radio" name="weixinType" value="0">微信服务号</label>
								<label class="col-sm-3"><input type="radio" name="weixinType" value="qiye">微信企业号</label>
								<label class="col-sm-3"><input type="checkbox" name="weixinAuth">微信公众号是否认证</label>
 							</div>  
 						</div>  
					</div>
					<div class="tabs-content" style="display: none;">
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">信息发送参数控制</label>
								<div class="radio-group">
								<label for="orderflow1">
									<input type="radio" name="NoticeStyle" value="0">
								只发微信</label>
								</div>
								<div class="radio-group">
								<label for="orderflow2">
									<input type="radio" name="NoticeStyle" value="1">
								只发短信</label>
								</div>
								<div class="radio-group">
									<label for="orderflow3">
									<input type="radio" name="NoticeStyle" value="01"> 
									发微信发短信</label>
								</div>
								<div class="radio-group">
									<label for="orderflow3">
									<input type="radio" name="NoticeStyle" value="2"> 
									不发消息</label>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">消息接收类型</label>
								<div class="radio-group">
									<input type="radio" name="ordersMessageReceivedType" value="0">
									<label for="orderflow1">根据流程中设置的职务</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="ordersMessageReceivedType" value="1">
									<label for="orderflow2">根据员工客户资料中对应的步骤</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="ordersMessageReceivedType" value="2">
									<label for="orderflow3">以上都使用</label>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">款项与订单流程顺序</label>
								<div class="radio-group">
									<input type="radio" name="kuanOrHuo" value="0">
									<label for="orderflow1">先核款再发货</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="kuanOrHuo" value="1">
									<label for="orderflow2">收货后付款</label>
								</div> 
							</div>
						</div>
					</div>
					<div class="tabs-content">
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">生产计划消息推送方式</label>
								<div class="radio-group">
									<input type="radio" name="PlanPush" value="0"> <label
										for="orderflow1">离散型制造业</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="PlanPush" value="1"> <label
										for="orderflow2">流程型制造业</label>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">生产计划数据来源</label>
								<div class="radio-group">
									<input type="radio" name="PlanSource" value="0"> <label
										for="orderflow1">市场预测表驱动(产品基础资料)</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="PlanSource" value="1"> <label
										for="orderflow2">销售订单产品</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="PlanSource" value="2"> <label
										for="orderflow2">定制订单</label>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label for="">质检方式</label>
								<div class="radio-group">
									<input type="radio" name="QCWay" value="0"> <label
										for="orderflow1">下工序工人检测上工序</label>
								</div>
								<div class="radio-group">
									<input type="radio" name="QCWay" value="1"> <label
										for="orderflow2">专业质检员质检</label>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<label for="">生产工段定义</label>
							<div class="form-group" id="ProductionSection">
								 
							</div>
							<div id="psitem" style="display: none;">
								<div>
									<input maxlength='20'>
									<button type='button' class='add'>+</button>
									<button type='button' class='sub'>-</button>
									<button type='button' class='up btn btn-default btn-sm'>&uarr;</button>
									<button type='button' class='down btn btn-default btn-sm'>&darr;</button>
								</div>
							</div>
						</div>
					</div>
					<div class="tabs-content">
						<div class="pay-form" id="account">
							<span class="pay-label">选择行业</span>
							<div class="paycheck-ctn" id="o2o">
								<div class="paycheck-box">
									家具行业<input type="hidden" value="jiaju">
								</div>
								<div class="paycheck-box">
									饲料行业<input type="hidden" value="tw">
								</div>
								<div>
									<input type="text" value="" name="emplName">
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a href="../manager.do" class="btn btn-primary">返回</a>
		</div>
	</div>
</body>
</html>