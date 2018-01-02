<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
<!-- 	<link rel="stylesheet" href="../pcxy/css/function.css"> -->
	<script type="text/javascript" src="../js/o2od.js"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../pc/js/systemParams.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>管理模式驾驶舱</li>
		</ol>
		<div class="header-title">管理模式驾驶舱
			<a href="../manager.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn">

			<div class="box-body" style="min-height:500px;">
				<ul class="nav nav-tabs">
				  <li role="presentation" class="active"><a>计划中心</a></li>
				  <li role="presentation"><a>系统控制</a></li>
				  <li role="presentation"><a>流程控制与信息控制</a></li>
				  <li role="presentation"><a>生产计划控制</a></li>
				  <li role="presentation" style="display: none;"><a>行业分类控制</a></li>
				  <li role="presentation"><a>赛宇流程参数</a></li>
				</ul>
			<form>
				<div class="tabs-content">
					<div class="col-sm-6">
						<div class="form-group-double">
							<label for="" class="col-sm-3">准确提货时段</label>
							<div class="double-input col-sm-9">
								<input type="tel" id="dayN1_SdOutStore_Of_SdPlan" name="dayN1_SdOutStore_Of_SdPlan" data-number="num" value="3">
								<span>~</span>
								<input type="tel" id="dayN2_SdOutStore_Of_SdPlan" name="dayN2_SdOutStore_Of_SdPlan" data-number="num" value="2">
							</div>
						</div>
					</div>
					<div class="col-sm-6" >
						<div class="form-group-double">
							<label for="" class="col-sm-3">插单提货时段</label>
							<div class="double-input col-sm-9" >
								<input type="tel" id="dayM1_SdOutStore_Of_SdPlan" name="dayM1_SdOutStore_Of_SdPlan" data-number="num" value="3">
								<span>~</span>
								<input type="tel" id="dayM2_SdOutStore_Of_SdPlan" data-number="num" value="3">
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group-double">
							<label for="" class="col-sm-3">计划查询时段</label>
							<div class="double-input col-sm-9">
								<input type="date" class="Wdate" onFocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" 
								id="dayTime_Of_SdPlan"  value="14:00:00" name="dayTime_Of_SdPlan"> 
							</div>
						</div>
					</div> 
					<div class="ctn" style="padding: 6px 0;">
						<div class="col-sm-6">
						<div class="single-input col-sm-9">
							<div class="pro-check" id="orderplan">下订单选计划</div>
							<div class="pro-check" id="accnIvt">显示库存数</div>
							<div class="pro-check" id="moreMemo">特殊工艺备注</div>
							</div>
						</div>
					</div>
				</div>
			   <div class="tabs-content">
					<div class="ctn" style="border-bottom:1px solid #ddd;padding: 6px 0;">
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
								<label for="" class="col-sm-3">短信平台用户名</label>
								<div class="single-input col-sm-9">
									<input type="text" maxlength="50" name="SmsUsername">
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">短信平台密码</label>
								<div class="single-input col-sm-9">
									<input type="text" maxlength="50" name="SmsPassword">
								</div>
							</div>
						</div>
					</div>
					<div class="ctn" style="border-bottom:1px solid #ddd;padding: 6px 0;">
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">账号短信验证码</label>
								<div class="single-input col-sm-9">
								<div class="pro-check" id="debug">不发送验证码短信</div>
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
						<div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">测试发货短信的发送号码</label>
								<div class="single-input col-sm-9">
								<div class="pro-check" id="order_sms_debug">勾我发送此手机的测试短信:</div>
									<input type="tel" maxlength="11" data-number="num" name="order_sms_no">
								</div>
									发送第一条微信到通讯录账号:<input type="text" maxlength="30" name="systemWeixin">
								</div>
							</div>
						</div>
						<div class="ctn">
							<div class="col-sm-6">
								<div class="form-group-p">
									<label for="" class="col-sm-3">发货短信格式<span style="font-weight:normal;">标点符号请使用中文格式</span></label>
									<div class="single-input col-sm-9">
										<input type="text" maxlength="20" name="sms_format1" value="">xxx<input type="text" maxlength="20"  name="sms_format2" value="">
										，订单编号为：xxx，发货日期xxx,明细如下：xxxx
										<input type="text" maxlength="20" name="sms_format3" value="">xxx元，请注意收货！
									</div>
								</div>
							</div>
						</div>
					 <div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">发送正式短信时所使用的个性签名</label>
								<div class="single-textarea col-sm-3">
									<input type="text" maxlength="20"  style="width: 80%;" name="sendSmsEnd">
								</div>
							</div>
						</div>
					 <div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号corpid</label>
								<div class="single-input col-sm-9">
									<input type="text"  name="corpid">
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
					 <div class="col-sm-6">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号应用ID</label>
								<div class="single-input col-sm-9">
									<input type="text"  name="agentid">
								</div>
							</div>
						</div>
					 <div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">微信企业号中的商家号</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="mch_id">
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
					 <div class="ctn">
							<div class="form-group-single">
								<label for="" class="col-sm-3">当前使用域名</label>
								<div class="single-textarea col-sm-9">
									<input type="text" style="width: 80%;" name="urlPrefix">
								</div>
							</div>
					</div>
					</div>

				<div class="tabs-content" style="display: none;">
			 	<div class="col-sm-6">
			 			<label for="">订单流程定义</label>
						<div class="form-group" id="salesOrder_Process">
						<div><input maxlength='20'><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						<div><input value="核货" maxlength="20"><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						<div><input value="核款" maxlength="20"><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						<div><input value="通知拉货" maxlength="20"><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						<div><input value="通知收货" maxlength="20"><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label for="">信息发送参数控制</label>
							<div class="radio-group">
								<input type="radio" name="NoticeStyle" value="0">
								<label for="orderflow1">只发微信</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="NoticeStyle" value="1">
								<label for="orderflow2">只发短信</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="NoticeStyle" value="01">
								<label for="orderflow3">发微信发短信</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="NoticeStyle" value="2">
								<label for="orderflow3">不发消息</label>
							</div>
						</div>
					</div>
					</div>
				  <div class="tabs-content">
					 <div class="col-sm-6">
						<div class="form-group">
							<label for="">生产计划消息推送方式</label>
							<div class="radio-group">
								<input type="radio" name="PlanPush" value="0">
								<label for="orderflow1">离散型制造业</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="PlanPush" value="1">
								<label for="orderflow2">流程型制造业</label>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label for="">生产计划数据来源</label>
							<div class="radio-group">
								<input type="radio" name="PlanSource" value="0">
								<label for="orderflow1">产品</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="PlanSource" value="1">
								<label for="orderflow2">订单</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="PlanSource" value="2">
								<label for="orderflow2">客户+产品</label>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label for="">质检方式</label>
							<div class="radio-group">
								<input type="radio" name="QCWay" value="0">
								<label for="orderflow1">下工序工人检测上工序</label>
							</div>
							<div class="radio-group">
								<input type="radio" name="QCWay" value="1">
								<label for="orderflow2">专业质检员质检</label>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
			 			<label for="">生产工段定义</label>
						<div class="form-group" id="ProductionSection">
						<div><input maxlength='20'><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						</div>
					</div>
					<div class="col-sm-6">
			 			<label for="">产品工序类别定义</label>
						<div class="form-group" id="workType">
						<div><input maxlength='20'><button type='button' class='add'>+</button><button type='button' class='sub'>-</button></div>
						</div>
					</div>
				</div>
				  <div class="tabs-content">
					<div class="pay-form" id="account">
					<span class="pay-label">选择行业</span>
					<div class="paycheck-ctn" id="o2o">
						<div class="paycheck-box">家具行业<input type="hidden" value="jiaju"></div>
						<div class="paycheck-box">饲料行业<input type="hidden" value="tw"></div>
					</div>
				</div>
				</div>
				  <div class="tabs-content">
				  <div><span>系统采购订单微信推送</span>
					 <div><span>推送开始时间</span><input type="date" class="Wdate" name="cgOrderPush_beginTime" value="08:00:00" 
					 onFocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" ></div>
					 <div><span>推送结束时间</span><input type="date" class="Wdate" name="cgOrderPush_endTime" value="18:00:00" 
					 onFocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" ></div>
					 <div><span>推送间隔时间(小时)</span><input type="tel" data-num="num" name="cgOrderPush_jiange" maxlength="1"></div>
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