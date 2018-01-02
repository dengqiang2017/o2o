<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../pcxy_res.jsp"%>
	<script src="../js/o2od.js${requesrScope.ver}"></script>
	<script src="../js/o2otree.js${requesrScope.ver}"></script>
	<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
	<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
	<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/dept.js${requesrScope.ver}"></script>
</head>
<body>
<div id="listpage">
<div class="bg"></div>
<%@include file="../header.jsp" %>
	<input type="hidden" id="edit_hi" value="${requestScope.auth.edit_maintenance!=null}">
<input type="hidden" id="del_hi" value="${requestScope.auth.del_maintenance!=null}">
<div class="cover"></div><div class="left-hide-ctn">
<div class="box-head">
	<form class="form-inline">
		<div class="col-sm-6 m-t-b">
			<div class="form-group">
				<input type="text" class="form-control input-sm" name="searchKey" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
			</div>
		</div>
		<div class="col-sm-6 m-t-b">
			<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
		</div>
	</form>
	</div>
	<div class="tree">
		<ul>
		<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span></li>
		</ul>
	</div>
</div><div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head">
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
			<a id="addDept" class="btn btn-success btn-sm m-t-b">增加</a>
			<c:if test="${requestScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
			<input type="file" id="xlsdepartment" name="xlsdepartment" onchange="excelImport(this,'department');"></a>
			</c:if>
			<c:if test="${requestScope.auth.excel!=null}">
			<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('department');">导出</button>
			</c:if>
	  	</div>
		<div class="box-body">
			<div class="table-responsive lg-table">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">操作</th>
					       <%@include file="list.jsp"%>
					    </tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>

		<div class="box-footer">
		</div>	
	</div>
</div><div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</div>
<script type="text/javascript" src="../pc/js/deptEdit.js${requestScope.ver}"></script>
<div id="editpage"></div>
</body>
</html>

 
 