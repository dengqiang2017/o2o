<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>
<%-- <script src="../js/O2O.js${requestScope.ver}"></script> --%>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/zepto.min.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
<script charset="utf-8"
	src="http://map.qq.com/api/js?v=2.exp&key=KDPBZ-MLJCV-A4TP2-UF7RY-NEU2E-MDF34"></script>
<script src="../pc/js/employee/sellerSign.js${requestScope.ver}"></script>
<style type="text/css">
tbody tr {
	cursor: default;
}

@media ( min-width :770px) {
	.xx {
		width: 130px !important;
	}
}

@media ( max-width :770px) {
	.hh {
		width: 111px !important;
	}
}
</style>
</head>
<body>
	<div id="personneList">
		<div class="bg"></div>
		<%@include file="../header.jsp" %>
		<div class="cover"></div>
		<div class="left-hide-ctn">
			<form class="form-inline" style="overflow: hidden;">
				<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
					<div class="form-group" style="width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">输入关键词</label>
						</div>
						<div class="col-lg-9">
							<input type="text" class="form-control input-sm xx"
								id="searchKey" name="searchKey" maxlength="20"
								placeholder="请输入搜索关键词">
						</div>
					</div>
				</div>
				<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
					<div class="form-group" style="width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">签到状态</label>
						</div>
						<div class="col-lg-9">
							<select id="type" class="form-control xx">
								<option value="">全部</option>
								<option value="1">已签到</option>
								<option value="0">未签到</option>
							</select>
						</div>
					</div>
				</div>
				<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
					<div class="form-group" style="margin-bottom: 15px; width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">签到开始日期</label>
						</div>
						<div class="col-lg-9">
							<input type="date"
								class="form-control input-sm Wdate xx begindate hh"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
								style="float: left;"><span
								style="float: left; margin: 6px 10px;">~</span><input
								type="time" class="form-control input-sm Wdate xx begintime hh"
								onfocus="WdatePicker({dateFmt:'HH:mm:ss'})" style="float: left;">
							<div style="clear: both"></div>
						</div>
					</div>
					<div class="form-group" style="width: 100%">
						<div class="col-lg-3">
							<label for="" style="margin-top: 7px;">签到结束日期</label>
						</div>
						<div class="col-lg-9">
							<input type="date"
								class="form-control input-sm Wdate xx enddate hh"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
								style="float: left;"><span
								style="float: left; margin: 6px 10px;">~</span><input
								type="time" class="form-control input-sm Wdate xx endtime hh"
								onfocus="WdatePicker({dateFmt:'HH:mm:ss'})" style="float: left;">
							<div style="clear: both"></div>
						</div>
					</div>
				</div>
				<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
					<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
				</div>
			</form>
			<div class="tree">
				<ul>
					<li><span id="treeAll"><i
							class="glyphicon glyphicon-folder-open"></i>所有</span>
						<ul>
							<c:forEach items="${requestScope.depts}" var="personnel">
								<li class="parent_li"><span class="client_tree"><i
										class="glyphicon glyphicon-minus-sign"></i>${personnel.dept_name}
										<input type="hidden" value="${personnel.sort_id}"></span></li>
							</c:forEach>
						</ul>
				</ul>
			</div>
		</div>
		<div class="container" style="margin-bottom: 50px">
			<div class="ctn-fff box-ctn" style="">
				<div class="box-head">
					<button type="button" id="manager_expand"
						class="btn btn-primary btn-sm m-t-b">展开搜索</button>
					<c:if test="${sessionScope.auth.excel!=null}">
						<button type="button" class="btn btn-danger btn-sm m-t-b excel">导出</button>
					</c:if>
				</div><span id="pingfen" style="display: none;">${sessionScope.auth.pingfen}</span>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>
								   <th width="200" data-name="dept_name">部门</th>
							       <th width="200" data-name="headship">职务</th>
								   <th width="200" data-name="clerk_name">姓名</th>
								   <th width="200" data-name="movtel">电话</th>
							       <th width="200" data-name="signDate">日期</th>
							       <th width="200" data-name="signTime">签到时间</th>
							       <th width="200" data-name="address">地址</th>
							       <th width="200" data-name="c_memo">备注</th>
							       <th width="200" data-name="customer_id">客户名称</th>
							       <th width="200" data-name="rizhi">日志</th>
							       <th width="200" data-name="pingfen">评分</th>
								   <th width="200" data-name="clerk_id">员工内码</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>

				<div class="box-footer" style="border: none;">
					<div class="form-group pull-left">
						<label>合计</label> <span>0</span>
					</div>
					<div class="pull-right">
						<input type="text" data-number="num" id="page" value="0"
							style="width: 50px;"> <span>总页数:<span
							id="totalPage">0</span></span>
						<button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
						<button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
						<button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
						<button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
					</div>
				</div>
				<div class="box-footer" style="border: none; margin-top: 36px;">
					<!-- 		<div> <textarea rows="5" cols="40" id="log" style="width: auto;" wrap="soft"></textarea> </div> -->
					<div class="form-group">
						<div
							style="width: 803px; height: 500px; color: black; float: left;"
							id="container"></div>
						<div class="" id="img" style="padding: 20px 0; float: left;">
							多图片显示区 <img src='' style='width: 50px; height: 50px;'>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}</div>
		
<div id="modal_smsSelect" style="display: none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">日志评分</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  <input type="tel" data-num="num" maxlength="2" placeholder="请输入分数">
					</label>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
<div style="display:none;" id="rizhidialog">
<div class="modal-cover-first"></div>
<div class="modal-first">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请上传日志</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传日志
			<input type="file" name="imgFile" id="imgFile"  onchange="imgUpload(this);">
			</a> 
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>

