<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../pcxy_res.jsp" %>
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../../pc/js/accountingSubjects.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="height:1100px;">
				<div class="box-head"><h4 class="pull-left">会计科目</h4>
					<div class="pull-right">
						<button type="button" class="btn btn-success" id="add">增加</button>
						<button type="button" class="btn btn-primary" id="edit">修改</button>
						<button type="button" class="btn btn-primary" id="find">查询</button>
						<button type="button" class="btn btn-danger"  id="del">删除</button>
						<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
							<input type="file" id="xlsaccountingSubjects" name="xlsaccountingSubjects" onchange="excelImport(this,'accountingSubjects');">
						</a>
						<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('accountingSubjects');">导出</button>
					</div>
			  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>会计科目编码</th>  
							       <th>会计科目名称</th>
							       <th>科目类别</th>
							       <th>期初金额</th> 
							       <th style="display:none;">上级科目类别</th> 
							    </tr>
							</thead>
							<tbody>
								<tr>
								   <td>57086066</td>  
							       <td>银行存款</td> 
							       <td>流动资产</td> 
							       <td>10000.00</td>
							       <td style="display:none;">10000.00</td>
								</tr>
								<tr>
								   <td>57086068</td>  
							       <td>现金</td> 
							       <td>流动资产</td> 
							       <td>10000.00</td>
							       <td style="display:none;">10000.00</td>
								</tr>
							</tbody>
						</table>
					</div>
					<form style="margin-top: 10px;" id="addForm">
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>会计科目编码</label>
						    	<input type="text" class="form-control input-sm" title="自动生成" name="${sessionScope.prefix}" maxlength="40" id="expenses_id">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>会计科目名称</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40" id="expenses_name">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>科目类别</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40" id="subject_type_id">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>期初金额</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40" id="expenses_unitprice">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>上级科目</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40" id="upper_expenses_id">
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