<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixininvite.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/driver.js${requestScope.ver}"></script>
</head>
<body>
<div id="listpage">
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="header" style="display: none;">
	<ol class="breadcrumb">
	  <li><a href="../employee.do">${sessionScope.indexName}</a></li>
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager/client.do">客户维护</a></li>
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="javascript:history.go(-1);">客户详细</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户司机维护</li>
	</ol>
	<div class="header-title">
	客户司机维护<a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
	</div>
</div>
<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-12 col-xs-12 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
	  			<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  		</div>
		</div> 
	</form>
</div>
<div class="cover"></div>
<div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head" style="display: none;">
	  		<h4 class="pull-left"></h4>
	  		<h4 class="pull-left">联系电话:<a href=""></a></h4><br>
  		</div><br>
		<div class="box-head">
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
				<c:if test="${requestScope.auth.add_maintenance!=null}">
			<a class="btn btn-success btn-sm m-t-b" id="addDriveInfo">增加</a></c:if>
			<c:if test="${requestScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
		    <input type="file" id="xlsdriver" name="xlsdriver" onchange="excelImport(this,'driver');"></a>
			</c:if>
			<c:if test="${requestScope.auth.excel!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('driver');">导出</button>
		    </c:if>
		   <c:if test="${sessionScope.auth.edit_maintenance!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b" onclick="editUtils.updateWeixinState('drive');">更新司机微信状态</button>
		    </c:if>
		    <button type="button" class="btn btn-danger btn-sm m-t-b" id="addDrive" style="display: none;">选择司机</button>
  		</div>
  					<input type="hidden" id="del_hi" value="${requestScope.auth.del_maintenance!=null}">
			<input type="hidden" id="edit_hi" value="${requestScope.auth.edit_maintenance!=null}">
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">操作</th>
					       <%@include file="list.jsp" %>
					    </tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="box-footer">
			<div class="form-inline">
				<div class="form-group pull-left">
				    <label>总共:</label>
				    <span id="totalRecord"></span>
				</div>
			</div>
			<div class="pull-right">
			当前页<input type="tel" id="page" value="0" data-number="num" style="width: 50px;">
			总页数<span id="totalPage"></span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>	
		</div>	
	</div>
</div>
<%@include file="../footer.jsp" %>
</div>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/manager/driverEdit.js${requestScope.ver}"></script>
<div id="editpage"></div>
</body>

</html>