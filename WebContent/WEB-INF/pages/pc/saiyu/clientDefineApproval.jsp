<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- <link rel="stylesheet" href="../pcxy/css/product.css"> -->
	<script src="../js/o2otree.js"></script>
	<script type="text/javascript"
		src="../pc/js/saiyu/clientDefineApproval.js"></script>
<div class="ctn-fff box-ctn" style="min-height: 600px;">
	<div class="box-body">
		<div class="ctn">
			<button type="button" class="btn btn-primary" style="display: none;">新增协同步骤</button>
			<input type="hidden" id="item_name" value="客户报修协同"> 
			<input type="hidden" id="item_id">
			<input type="hidden" id="customerId" value="${requestScope.upper_customer_id}">
		</div>
		<div class="ctn" style="margin-top: 10px; display: none;" id="item">
			<div class="col-lg-3 col-sm-4">
				<div class="panel panel-info sp-ctn">
					<input type="hidden" id="seeds_id">
					<div class="panel-heading sp-head">序号:</div>
					<div class="panel-body sp-body">
						<div class="ctn">
							<div class="col-xs-4 sp-label">协同人</div>
							<div class="col-xs-8 sp-content" id="clerkName"></div>
						</div>
						<div class="ctn">
							<div class="col-xs-4 sp-label">协同部门</div>
							<div class="col-xs-8 sp-content" id="deptName"></div>
						</div>
						<div class="ctn">
							<div class="col-xs-4 sp-label">协同步骤</div>
							<div class="col-xs-8 sp-content" id="approvalStep"></div>
						</div>
						<div class="ctn" style="display: none;">
							<div class="col-xs-4 sp-label">是否可跳过</div>
							<div class="col-xs-8 sp-content" id="if_skip">否</div>
						</div>
						<div class="ctn">
							<div class="col-xs-4 sp-label">推送结果通知</div>
							<div class="col-xs-8 sp-content" id="noticeResult">否</div>
						</div>
					</div>
					<div class="panel-footer" style="display: none;">
						<button type="button" class="btn btn-xs btn-info" id="upmove">上移</button>
						<button type="button" class="btn btn-xs btn-info" id="downmove">下移</button>
						<button type="button" class="btn btn-xs btn-primary"
							id="editprocess">编辑</button>
						<button type="button" class="btn btn-xs btn-danger"
							id="delprocess">删除</button>
					</div>
				</div>
			</div>
		</div>
		<div id="item01">
		</div>
	</div>
</div>