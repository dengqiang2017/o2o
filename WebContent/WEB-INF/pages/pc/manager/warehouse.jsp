<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript"  src="../pc/js/warehouse.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="container-fluid" >
	<div class="row">
		<div class="col-lg-4 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head">
					<form class="form-inline">
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>库房名称</label>
					    		<input type="text" class="form-control input-sm" id="store_struct_name">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>记忆码</label>
					    		<input type="text" class="form-control input-sm" id="easy_id">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>库房类型</label>
					    		<select id="store_struct_type" class="form-control input-sm" title="选择库房类别">
					    		<option value=""></option>
					    		<option value="公司库房">公司库房</option>
					    		<option value="渠道虚拟库房">渠道虚拟库房</option>
					    		</select>
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>托管部门</label>
					    		<input type="text" class="form-control input-sm" id="dept_name">
					  		</div>
						</div>
					  	<div class="col-sm-6 m-t-b">
					  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
					  	</div>
					</form>
				</div>
				<div class="box-body">
					<div class="tree lg-tree">
					<ul>
						<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.warehouses}" var="cls">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-minus-sign"></i>${cls.store_struct_name}
					<input type="hidden" value="${cls.sort_id}"></span></li>
					</c:forEach>
					</ul>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-8 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">库房列表</h4>
				<div class="pull-right">
				<c:if test="${sessionScope.auth.add_maintenance!=null}">
				<a href="warehouseEdit.do" class="btn btn-success">增加</a>
				</c:if>
				<c:if test="${sessionScope.auth.edit_maintenance!=null}">
				<button type="button" id="editClient" class="btn btn-primary">修改 </button>
				</c:if>
				<c:if test="${sessionScope.auth.del_maintenance!=null}">
				<button type="button" id="delClient" class="btn btn-danger">删除</button>
				</c:if>
				<c:if test="${sessionScope.auth.excelImp!=null}">
				<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
				<input type="file" id="xlswarehouse" name="xlswarehouse" onchange="excelImport(this,'warehouse');"></a>
				</c:if>
				<c:if test="${sessionScope.auth.excel!=null}">
				<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('warehouse');">导出</button>
				</c:if>
				</div>
		  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
					<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>库房名称</th>  
							       <th>库房编码</th> 
							       <th>库房类型</th>  
							       <th>负责人</th> 
							       <th>托管部门</th>  
							       <th>行政区划</th> 
							    </tr>
							</thead>
							<tbody>
								<c:forEach items="${requestScope.pages.rows}"  var="warehouse">
								<tr>
									<td>${warehouse.store_struct_name}</td>
									<td><input type="hidden" id="id" value="${warehouse.sort_id}">${warehouse.store_struct_id}</td>
									<td>${warehouse.store_struct_type}</td>
									<td>${warehouse.clerk_name}</td>
									<td>${warehouse.dept_name}</td>
									<td>${warehouse.regionalism_id}</td>
								</tr>								
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
	
				<div class="box-footer" style="display: none;">
					<form class="form-inline">
						<div class="form-group pull-left">
						    <label>合计</label>
						    <input type="text" class="form-control">
						</div>
					</form>
<!-- 					<div class="pull-right"> -->
<!-- 					    <button type="button" class="btn btn-info btn-sm">首页</button> -->
<!-- 					    <button type="button" class="btn btn-info btn-sm">上一页</button> -->
<!-- 					    <button type="button" class="btn btn-info btn-sm">下一页</button> -->
<!-- 					    <button type="button" class="btn btn-info btn-sm">末页</button> -->
<!-- 					</div>	 -->
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

    