<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="../pcxy_res.jsp" %>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">计量单位</h4>
					<div class="pull-right">
						<button type="button" class="btn btn-success" >增加</button>
						<button type="button" class="btn btn-primary">修改</button>
						<button type="button" class="btn btn-primary">查询</button>
						<button type="button" class="btn btn-danger">删除</button>
					</div>
			  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<input type="hidden" id="select_treeId">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>计量单位编码</th>  
							       <th>计量单位</th>  
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
					<form style="margin-top: 10px;">
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>计量单位编码</label>
						    	<input type="text" class="form-control input-sm" title="自动生成" name="${sessionScope.prefix}" maxlength="40">
						  	</div>
						</div>
						<div class="col-lg-3 col-sm-4 m-t-b">
							<div class="form-group">
						    	<label>计量单位名称</label>
						    	<input type="text" class="form-control input-sm" title="输入结计量单位名称" name="${sessionScope.prefix}" maxlength="40">
						  	</div>
						</div>
						<div class="col-xs-12 m-t-b">
							<button type="button" class="btn btn-primary">保存</button>
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