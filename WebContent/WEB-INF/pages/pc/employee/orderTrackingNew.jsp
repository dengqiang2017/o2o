<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<link href='../css/jquery-ui.min.css' rel='stylesheet'>
</head>
<style type="text/css">
@media ( max-width : 770px) {
	.xsmargin {
		margin-bottom: 40px;
	}
}
td .checkbox{float: left;}
.container ul>li {list-style: none;}
.container ul {padding-left: 0;}
.check{
width: 25px !important;
height: 25px !important;
display: inline-block !important;
}
</style>
<body>
<div id="orderlist"><div class="bg"></div>
	<%@include file="../header.jsp" %>
	<div class="alert alert-warning alert-dismissible" role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button> 
  操作提示:<span id="phoneMsg">请先点击【展开搜索】-></span><span>点【状态】下拉选择对应的流程步骤->勾选列表中的行->点击流程对应的红色按钮</span>
  <script type="text/javascript">
  <!--
  if(common.isPC()){
	  $("#phoneMsg").hide();
  }
  setTimeout(function(){
	  $("span[aria-hidden='true']").click();
  }, 5000);
  //-->
  </script>
</div>
	<div class="container" style="width:100%">
		<div class="row">
			<div class="ctn">
				<div class="ctn-fff box-ctn" style="min-height: 750px;">
					<div class="box-body">
						<!-- 分客户 -->
						<div class="tabs-content">
							<input type="hidden" id="emplHeadship" value="${sessionScope.userInfo.personnel.headship}">
							<input type="hidden" id="emplclerk_name" value="${sessionScope.userInfo.personnel.clerk_name}">
							<input type="hidden" id="isAutoFind" value="${sessionScope.isAutoFind}">
							<input type="hidden" id="orderTracking_operation" value="${sessionScope.auth.orderTracking_operation}">
							<input type="hidden" id="showAmount" value="${sessionScope.auth.showAmount}">
							<div class="ctn">
								<div class="folding-btn m-t-b">
									<button type="button" class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button>
<!-- 									<span style="color: red;">请先点击【展开搜索】->点【状态】选择对应的流程步骤->勾选列表中的行->点击流程对应的红色按钮</span> -->
								</div>
								<%@include file="../orderTrackingFind.jsp"%>
								<div class="col-sm-12 m-t-b">
									<!-- <button type="button" class="btn btn-danger btn-sm excel">导出</button> -->
									<c:forEach items="${requestScope.processName}" var="name">
										<button type="button" class="btn btn-danger btn-sm handle" style="display: none;">${name}</button>
									</c:forEach>
									<button type="button" class="btn btn-danger btn-sm" id="caigou" style="display: none;">通知下采购订单</button>
									<button type="button" class="btn btn-danger btn-sm" id="pPlan" style="display: none;">通知下生产计划</button>
								</div>
								<div class="table-responsive">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th style="min-width: 115px;"><label><input type="checkbox" id="check" class="check">&emsp;<span>全选</span></label></th>
<!-- 												<th style="min-width: 115px;"><div class="checkbox"></div></th> -->
												<c:forEach items="${requestScope.thead}" var="th">
												<c:if test="${th.show==true}">
													<th data-name="${th.id}">${th.name}</th>
												</c:if>
												<c:if test="${th.show==false}">
													<th style="display: none;" data-name="${th.id}">${th.name}</th>
												</c:if>
												</c:forEach>
											</tr>
										</thead>
<!-- 										 style="display:block; max-height:400px;overflow-y: scroll;" -->
										<tbody style=""></tbody>
									</table>
								</div>

								<div class="pull-right" style="margin-bottom: 50px;">
								<div>
								</div>
								<span>总条数:</span><span id="totalRecord"></span>
								<span>当前页:</span><span id="page"></span>
								<span>共:</span><span id="totalPage"></span><span>页</span>
								<span>每页显示条数:</span><select id="rows">
								<option value="10">10</option>
								<option value="20">20</option>
								<option value="30">30</option>
								<option value="40">40</option>
								<option value="50">50</option>
								<option value="60">60</option>
								<option value="70">70</option>
								<option value="80">80</option>
								<option value="90">90</option>
								<option value="100">100</option>
								</select>
									<button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
									<button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
									<button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
									<button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div><div class="footer">
		员工:${sessionScope.userInfo.clerk_name}</div></div>
<div id="orderinfo"></div>
<!-- 	选择通知方式,物流方式,提货仓库,提货司机 -->
	<div style="display: none;" id="houyun_Select">
		<!--<div class="modal-cover-first"></div>-->
		<div style="display: block;" class="modal-first">
			<div class="modal-dialog">
				<div class="modal-content modal-height" >
					<div class="modal-header">
						<button data-dismiss="modal" class="close" type="button">
							<span aria-hidden="true">×</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">订单协同信息</h4>
					</div>
					<div style="padding-right: 20px;overflow-y:auto;" class="modal-body">
						<form class="form-horizontal" style="margin-bottom: 20px">
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group" id="wuliufs">
								<label class="col-lg-2 text-right" style="line-height: 30px">物流方式</label>
								<div class="col-lg-10" style="line-height: 30px">
									<select class="form-control" id="wuliufsxz">
<!-- 									<option value=""></option> -->
										<optgroup label="公司库房">
											<option value="0-1" selected="selected">公司配送</option>
											<option value="0-2">客户自提</option>
											<!-- <option value="0-3">第三方物流配送</option> -->
										</optgroup>
										<optgroup label="供应商库房">
											<option value="1-1">公司配送</option>
											<option value="1-2">客户自提</option>
											<!--  <option value="1-3">第三方物流配送</option> -->
											<option value="1-4">供应商配送</option>
										</optgroup>
									</select>
								</div>
							</div>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group" id="selectWare">
								<label class="col-lg-2 text-right" style="line-height: 30px">提货地点(仓库)</label>
								<div class="col-lg-10" style="line-height: 30px">
									<div class="input-group">
										<span class="form-control" id="didian"></span>
										<span id="store_struct_id" style="display: none;"></span>
										<span class="input-group-btn">
											<button type="button" class="btn btn-primary" id="thdixz">浏览</button>
										</span>
									</div>
								</div>
							</div>
							<div id="wuliuxixin">
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<!-- 	 id="driveInfo" -->
								<label class="col-lg-2 text-right" style="line-height: 30px">司机信息</label>
								<div class="col-lg-10" style="line-height: 30px">
									<div class="input-group">
										<input type="text" class="form-control" maxlength="40"
											id="driverinfo"> <span class="input-group-btn">
											<button type="button" class="btn btn-primary"  id="drivexz">浏览</button>
										</span>
									</div>
								</div>
							</div>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">车牌号</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="text" class="form-control" id="Kar_paizhao"
										maxlength="20">
								</div>
							</div>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">司机身份证</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="text" class="form-control" id="sfz" maxlength="19"
										data-number="n">
								</div>
							</div>
							</div>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group" id="tihuoTime">
								<label class="col-lg-2 text-right" style="line-height: 30px">预计提货时间</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="date" class="form-control Wdate" id="tihuoDate"
										maxlength="40"
										onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true})">
								</div>
							</div>
						</form>
						<div id="jbrxx" class="xx"
							style="margin-bottom: 20px; padding-left: 20px; font-size: 18px; display: none;">
							<div class="xx01" style="margin-bottom: 10px">
								经办人:<span id="jbrname"></span>
							</div>
							<div class="xx02" style="margin-bottom: 10px">
								联系号码:<span id="jbrtel"><a href=""></a></span>
							</div>

						</div>
						<div style="padding-left: 20px; margin-bottom: 5px;">
							<span style="font-size: 20px">请选择通知方式</span>
						</div>
						<div style="padding-left: 20px; margin-bottom: 5px;" class="ctn">
							<label class="radio-inline"> <input type="radio"
								checked="checked" value="0" name="NoticeStyle"> 仅微信通知
							</label>
						</div>
						<div style="padding-left: 20px; margin-bottom: 5px;" class="ctn">
							<label class="radio-inline"> <input type="radio"
								value="1" name="NoticeStyle"> 仅短信通知
							</label>
						</div>
						<div style="padding-left: 20px; margin-bottom: 5px;" class="ctn">
							<label class="radio-inline"> <input type="radio"
								value="2" name="NoticeStyle"> 微信和短信通知
							</label>
						</div>
						<div style="padding-left: 20px; margin-bottom: 5px;" class="ctn">
							<label class="radio-inline"> <input type="radio"
								value="3" name="NoticeStyle">不通知微信和短信
							</label>
						</div>
					<div class="modal-footer xsmargin">
						<button class="btn btn-default" type="button" id="closedig">取消通知拉货</button>
						<button class="btn btn-primary" type="button" id="confimdig">通知拉货</button>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<!-- 	修改订单数量和单价 -->
	<div style="display: none;" id="editNum">
		<div style="display: block;" class="modal-first">
			<div class="modal-dialog">
				<div class="modal-content modal-height"
					style="max-height: 450px; overflow-y: scroll">
					<div class="modal-header">
						<button data-dismiss="modal" class="close" type="button">
							<span aria-hidden="true">×</span> <span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">修改订单
						<c:if test="${sessionScope.auth.editOrderNum!=null}">
						数量
						</c:if>
						<c:if test="${sessionScope.auth.editOrderPrice!=null}">
						单价
						</c:if>
						</h4>
					</div>
					<div style="padding: 10px;" class="modal-body">
						<form class="form-horizontal" style="margin-bottom: 20px">
							<c:if test="${sessionScope.auth.editOrderNum!=null}">
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">订单数量</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="number" class="form-control" id="sd_oq" data-number="num2"
										maxlength="10">
								</div>
							</div>
							</c:if>
							<c:if test="${sessionScope.auth.edit_order_send_sum!=null}">
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">已发货数量</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="number" class="form-control" id="send_sum"  data-number="num2"
										maxlength="10" readonly="readonly">
								</div>
							</div>
							</c:if>
							<c:if test="${sessionScope.auth.edit_order_send_qty!=null}">
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">本次发货数量</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="number" class="form-control" id="send_qty" data-number="num2"
										maxlength="10">
								</div>
							</div>
							</c:if>
							<span style="display: none;" id="pack_unit"></span>
							<span style="display: none;" id="editOrderNum">${sessionScope.auth.editOrderNum}</span>
							<span style="display: none;" id="editOrderPrice">${sessionScope.auth.editOrderPrice}</span>
							<span style="display: none;" id="edit_order_send_qty">${sessionScope.auth.edit_order_send_qty}</span>
							<span style="display: none;" id="edit_order_send_sum">${sessionScope.auth.edit_order_send_sum}</span>
							<span style="display: none;" id="seeds_id"></span>
<!-- 							<div style="padding-left: 8px; margin-bottom: 5px;" -->
<!-- 								class="form-group"> -->
<!-- 								<label class="col-lg-2 text-right" style="line-height: 30px">折算数量</label> -->
<!-- 								<div class="col-lg-10" style="line-height: 30px"> -->
<!-- 									<input type="number" class="form-control" id="zsnum" maxlength="10" -->
<!-- 										data-number="num2"> -->
<!-- 								</div> -->
<!-- 							</div> -->
							<c:if test="${sessionScope.auth.editOrderPrice!=null}">
<!-- 							修改单价 -->
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">订单单价</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="number" class="form-control" id="price" maxlength="10"
										data-number="num2">
								</div>
							</div>
							</c:if>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">备注</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="text" class="form-control" id="c_memo">
								</div>
							</div>
							<div style="padding-left: 8px; margin-bottom: 5px;"
								class="form-group">
								<label class="col-lg-2 text-right" style="line-height: 30px">消息通知职务</label>
								<div class="col-lg-10" style="line-height: 30px">
									<input type="text" class="form-control" id="zhiwu" maxlength="20" placeholder="消息通知职务,多个职务使用英文逗号隔开,为空就不通知" value="采购,内勤">
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer xsmargin">
						<button class="btn btn-default" type="button" id="closedig">取消修改</button>
						<button class="btn btn-primary" type="button" id="confimEdit">确认修改</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	 <span id='urlPrefix' style="display: none;">${requestScope.urlPrefix}</span>
      <span id='com_id' style="display: none;">${requestScope.com_id}</span>
<%@include file="../chehuachu.jsp" %>
<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="../pc/js/employee/order_gz_new.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/evaluation.js${requestScope.ver}"></script>
</body>
</html>