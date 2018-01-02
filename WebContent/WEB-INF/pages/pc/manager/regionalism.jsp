<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/regionalism.js${requestScope.ver}"></script>
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
					    		<label>行政区划</label>
					    		<input type="text" class="form-control input-sm" id="regionalism_name_cn" maxlength="20">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>记忆码</label>
					    		<input type="text" class="form-control input-sm" id="easy_id" maxlength="20">
					  		</div>
						</div>
<!-- 						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>库房类型</label>
					    		<input type="text" class="form-control input-sm">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>托管部门</label>
					    		<input type="text" class="form-control input-sm">
					  		</div>
						</div> -->
					  	<div class="col-sm-6 m-t-b" style="margin-top:15px">
					  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
					  	</div>
					</form>
				</div>
				<div class="box-body">
					<div class="tree lg-tree">
						<ul>
						<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-8 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">行政区划列表</h4>
				<div class="pull-right">
					<a href="regionalismEdit.do" class="btn btn-success">增加</a>
					<a id="addNextClient" class="btn btn-success">增加下级行政区划</a>
					<button type="button" id="editClient" class="btn btn-primary">修改 </button>
					<button type="button" id="delClient" class="btn btn-danger">删除</button>
					<c:if test="${requestScope.auth.excelImp!=null}">
					<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
					<input type="file" id="xlsregionalism" name="xlsregionalism" onchange="excelImport(this,'regionalism');"></a>
					</c:if>
					<c:if test="${requestScope.auth.excel!=null}">
					<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('regionalism');">导出</button>
					</c:if>
				</div>
		  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
					<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>行政区划</th>  
							       <th>行政区划编码</th> 
							       <th>所属销售部门</th>  
							       <th>记忆码</th> 
							       <th>市场类别</th>  
							       <th>是否用于统计</th> 
							    </tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
	
				<div class="box-footer">
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

 