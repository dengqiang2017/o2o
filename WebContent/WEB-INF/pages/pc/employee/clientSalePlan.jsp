<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	   <%@include file="../res.jsp" %>
   <script src="../js/o2od.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户计划准确率</li>
	</ol>
	<div class="header-title">客户计划准确率
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-head"><h4 class="pull-left">客户生产计划详细</h4>
				<form action="" style="clear:both;overflow:hidden;">
					<div class="col-sm-3 col-lg-2 m-t-b">
		              <div class="form-group">
		                <label for="">客户名称</label>
		                <input type="text" class="form-control input-sm" name="item_name" maxlength="50">
		              </div>
		            </div>
		            <div class="col-sm-3 col-lg-2 m-t-b">
		              <div class="form-group">
		                <label for="">品名</label>
		                <input type="text" class="form-control input-sm" name="item_name" maxlength="50">
		              </div>
		            </div>
		            <div class="col-sm-3 col-lg-2 m-t-b">
		              <div class="form-group">
		                <label for="">日期</label>
		                <input type="text" class="form-control input-sm" name="" maxlength="50">
		              </div>
		            </div>
		            <div class="ctn">
		            	<button class="btn btn-sm btn-primary">查询</button>
		            </div>
				</form>
		  	</div>
				<div class="box-body">
					<div class="text-center">
						<h3>客户计划准确率报表</h3>
					</div>
					<div class="table-responsive lg-table">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>客户编码</th>  
							       <th>客户名称</th>  
							       <th>产品编码</th>  
							       <th>产品名称</th>  
							       <th>日期</th> 
							       <th>本日计划数</th> 
							       <th>本日提货数</th> 
							       <th>计划准确率</th>
							    </tr>
							</thead>
							<tbody>
								<tr>
									<td></td>
									<td>林氏木业有限公司</td>
									<td>113020109</td>
									<td>8201仔猪浓缩饲料(粉料42KG)</td>
									<td>2015-03-05</td>
									<td>75</td>
									<td>100</td>
									<td>75%</td>
								</tr>
								<tr>
									<td></td>
									<td>林氏木业有限公司</td>
									<td>113020109</td>
									<td>8201仔猪浓缩饲料(粉料42KG)</td>
									<td>2015-03-05</td>
									<td>75</td>
									<td>100</td>
									<td>75%</td>
								</tr>
								<tr>
									<td></td>
									<td>林氏木业有限公司</td>
									<td>113020109</td>
									<td>8201仔猪浓缩饲料(粉料42KG)</td>
									<td>2015-03-05</td>
									<td>75</td>
									<td>100</td>
									<td>75%</td>
								</tr>
								<tr>
									<td></td>
									<td>林氏木业有限公司</td>
									<td>113020109</td>
									<td>8201仔猪浓缩饲料(粉料42KG)</td>
									<td>2015-03-05</td>
									<td>75</td>
									<td>100</td>
									<td>75%</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="ctn">
						<div class="col-sm-6">
							<div class="tatable-responsive" style="margin-top:10px;">
								<table class="table table-bordered">
									<tbody>
										<tr>
											<td>客户</td>
											<td>产品品种</td>
											<td>提货数</td>
											<td>日期</td>
										</tr>
										<tr>
											<td>丁建中</td>
											<td>1003（2.0）</td>
											<td>5</td>
											<td>2015-08-05</td>
										</tr>
									</tbody>
								</table>
							</div>	
						</div>
						<div class="col-sm-6">
							<div class="tatable-responsive" style="margin-top:10px;">
								<table class="table table-bordered">
									<tbody>
										<tr>
											<td>客户</td>
											<td>产品品种</td>
											<td>计划数</td>
											<td>日期</td>
										</tr>
										<tr>
											<td>丁建中</td>
											<td>1003（2.0）</td>
											<td>10</td>
											<td>2015-08-02</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
	
				<div class="box-footer">
					<div class="pull-right">
					    <button type="button" class="btn btn-info btn-sm">首页</button>
					    <button type="button" class="btn btn-info btn-sm">上一页</button>
					    <button type="button" class="btn btn-info btn-sm">下一页</button>
					    <button type="button" class="btn btn-info btn-sm">末页</button>
					</div>	
				</div>	
			</div>
		</div>
	</div>
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
</div>
 
</body>
</html>

    