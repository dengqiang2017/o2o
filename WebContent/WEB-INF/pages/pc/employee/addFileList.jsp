<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<%@include file="../res.jsp" %>
<style type="text/css">
.col-xs-12{border: 1px solid aqua;font-size: 18px;padding: 5px;background-color: white;}
.col-xs-12 .btn-info{margin-top: 5px;}
@media (max-width: 759px) {
.form-inline input{width:150px;display: inline-block; }
}
</style>
</head>
<body>
<div class="bg"></div>
	<%@include file="../header.jsp"%>
	    <%@include file="selClient.jsp" %>
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
<!--           客户信息 -->
          <%@include file="showSelectClient.jsp" %>
          <c:if test="${sessionScope.auth.newAddFile!=null}">
          			<a id="upload-btn" class="btn btn-success">增加客户订单附件
			<input type="file" name="imgFile" id="imgFile" onchange="fileLoad(this);">
			<input type="hidden" id="filepath">
			</a>
			<button type="button" class="btn btn-info" id="add">前往客户报价单为客户报价</button>
          </c:if>
        </div> 
      </div>
    </div>
	<div class="container">
	<p id=iphone style="display: none;color: red;">提示:苹果系统原因只能上传图片</p>
	<div class="form-inline">
	<input type="date" id="d4311"
    class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" name="beginDate">
    <input type="date" id="d4312" class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" name="endDate">
    <button type="button" class="btn btn-success find">查询</button>
	</div>
		<div id="list"></div>
		<div id="item" style="display: none;">
		  <div class="col-xs-12 col-sm-6 col-md-4">
			<div class="pull-left">
			<p>上传时间:<span id="time"></span></p>
			<p id='customerName'></p>
			</div>
			<div class="pull-right">
			<a target="_blank" class="btn btn-info">查看附件</a>
			<c:if test="${sessionScope.auth.delAddFile!=null}"><br>
			<button type="button" class="btn btn-info" onclick="delAddFile(this);">删除附件</button>
			</c:if>
			</div>
			</div>
		</div>
	</div>
	<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}
		 <div class="btn-gp">
			<a href="../employee.do" class="btn btn-info">返回</a>
			</div>
		<span id="clerk_id"
			style="display: none;">${sessionScope.userInfo.clerk_id}</span><span
			class="glyphicon glyphicon-earphone"></span>
			
	</div>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixin.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/addFileList.js${requestScope.ver}"></script>
</body>
</html>