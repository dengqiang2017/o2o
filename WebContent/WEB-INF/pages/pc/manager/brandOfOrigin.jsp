<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../pcxy_res.jsp" %>
    <link rel="stylesheet" href="css/function.css${requestScope.ver}">
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../../pc/js/brandOfOrigin.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="height:1100px;">
				<div class="box-head"><h4 class="pull-left">产地品牌</h4>
					<div class="pull-right">
						<button type="button" class="btn btn-success" id="add">增加</button>
						<button type="button" class="btn btn-primary" id="edit">修改</button>
						<button type="button" class="btn btn-primary" id="find">查询</button>
						<button type="button" class="btn btn-danger"  id="del">删除</button>
						<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
							<input type="file" id="xlsproducarea" name="xlsproducarea" onchange="excelImport(this,'producarea');">
						</a>
						<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('producarea');">导出</button>
					</div>
			  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>产地品牌编码</th>  
							       <th>产地品牌名称</th>  
							    </tr>
							</thead>
							<tbody>
								<tr>
								   <td><a href="gly-khxx.html" target="_blank">JD0000001</a></td>  
							       <td>个</td> 
								</tr>
								<tr>
									<td><a href="gly-khxx.html" target="_blank">JD0000002</a></td>  
							       <td>件</td> 
								</tr>
								<tr>
									<td><a href="gly-khxx.html" target="_blank">JD0000003</a></td>  
							       <td>套</td> 
								</tr>
								<tr>
									<td><a href="gly-khxx.html" target="_blank">JD0000004</a></td>  
							       <td>KG</td> 
								</tr>
							</tbody>
						</table>
					</div>
					<form style="margin-top: 10px;" id="addForm">
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>产地品牌编码</label>
						    	<input type="text" class="form-control input-sm" title="自动生成" name="${sessionScope.prefix}" maxlength="40" id="producarea_id">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>产地品牌名称</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40" id="producarea_name">
						  	</div>
						</div>
						<div class="col-xs-12 m-t-b">
							<button type="button" class="btn btn-primary" id="save">保存</button>
						</div>
					</form>
				</div>
			</div>
    </div>
    <div class="footer">
     	 后台管理员<span class="glyphicon glyphicon-earphone"></span>
    </div>
</body>
</html>