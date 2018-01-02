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
<script type="text/javascript" src="../pc/js/manager/vendor.js${requestScope.ver}"></script>
<link rel="stylesheet" type="text/css" href="../pc/css/vendorEdit.css${requestScope.ver}">
</head>
<body>
<div id="listpage">
<%@include file="../header.jsp" %>
<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-6 col-xs-6 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
	  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  		</div>
		</div>
	  	<div class="col-sm-6 col-xs-6 m-t-b">
	  	</div>
	</form>
	<div class="tree" style="display: none;">
		<ul>
		<li><span id="treeAll" style="display: none;"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
		</li>
		</ul>
		<ul>
		<c:forEach items="${requestScope.vendors}" var="vendor">
		<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${vendor.corp_sim_name}
		<input type="hidden" value="${vendor.corp_id}"></span></li>
		</c:forEach>
		</ul>
	</div>
</div>
<div class="cover"></div>
<div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head"><h4 class="pull-left">供应商列表</h4>
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
		 <c:if test="${sessionScope.auth.add_maintenance!=null}">
			<a onclick="loadPage('vendorEdit.do?');" class="btn btn-success btn-sm m-t-b">增加</a>
		</c:if>
			<c:if test="${sessionScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
		    <input type="file" id="xlsvendor" name="xlsvendor" onchange="excelImport(this,'vendor');"></a>
			</c:if>
			<c:if test="${sessionScope.auth.excel!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('vendor');">导出</button>
		    </c:if>
		    <c:if test="${sessionScope.auth.edit_maintenance!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b" onclick="editUtils.updateWeixinState('gys');">更新供应商微信状态</button>
		    </c:if>
  		</div>
  		<input type="hidden" id="del_hi" value="${sessionScope.auth.del_maintenance!=null}">
		<input type="hidden" id="edit_hi" value="${sessionScope.auth.edit_maintenance!=null}">
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">操作</th>
					       <%@include file="list.jsp"%>
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
				    <span class="form-control" id="totalRecord"></span>
				</div>
			</div>
			<div class="pull-right">
			当前页:<input type="text" id="page" value="0" style="width: 50px;">
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
<script type="text/javascript" src="../pc/js/manager/editUtils.js?ver=${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/vendorEdit.js?ver=${requestScope.ver}"></script>
<div id="editpage"></div>
</body>

</html>