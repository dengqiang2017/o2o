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
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="salePlanReport.do">销售计划报表</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售计划详细</li>
	</ol>
	<div class="header-title">员工-销售计划详细
		<a href="salePlanReport.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head">
					<ul class="nav nav-tabs" style="margin-top:10px;">
					    <li class="active"><a href="#">日计划</a></li>
					    <li><a href="#">周计划</a></li>
					    <li><a href="#">月计划</a></li>
					</ul>
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
		                <input type="text" class="form-control input-sm"  maxlength="50">
		              </div>
		            </div>
		            <div class="ctn">
		            	<button class="btn btn-sm btn-primary">查询</button>
		            </div>
				</form>
		  	</div>
				<div class="box-body">
					<div class="text-center">
						<div class="ctn">
							<button type="button" class="btn btn-default pull-right"><span class="glyphicon glyphicon-save"></span> 下载</button>
							<button type="button" class="btn btn-default pull-right"><span class="glyphicon glyphicon-print"></span> 打印</button>
						</div>
						<h3>销售计划准确率报表</h3>
					</div>
					<p>员工:<span>***</span></p>
					<div class="tabs-content">	
						<div class="table-responsive lg周table">
							<table class="table table-bordered">
								<thead>
									<tr>  
								       <th>客户名称</th>  
								       <th>产品编码</th>  
								       <th>产品名称</th>   
								       <th>计划日期</th> 
								       <th>计划类型</th>  
								       <th>计划数</th> 
								       <th>订货数</th> 
								       <th>计划准确率</th> 
								    </tr>
								</thead>
								<tbody>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>日计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>日计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>日计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>日计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
								</tbody>
							</table>
						</div>


						<div class="ctn">
							<h5>该记录明细</h5>
							<div class="col-sm-6">
								<div class="tatable-responsive" style="margin-top:10px;">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th>客户</th>
												<th>产品品种</th>
												<th>提货数数</th>
												<th>日期</th>
											</tr>
										</thead>
										<tbody>
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
										<thead>
											<tr>
												<th>客户</th>
												<th>产品品种</th>
												<th>计划数</th>
												<th>日期</th>
											</tr>
										</thead>
										<tbody>
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
					<div class="tabs-content">
						<div class="table-responsive lg-table">
							<table class="table table-bordered">
								<thead>
									<tr>  
								       <th>客户名称</th>  
								       <th>产品编码</th>  
								       <th>产品名称</th>   
								       <th>计划日期</th> 
								       <th>计划类型</th>  
								       <th>计划数</th> 
								       <th>订货数</th> 
								       <th>计划准确率</th> 
								    </tr>
								</thead>
								<tbody>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>周计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>周计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>周计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>周计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="tabs-content">
						<div class="table-responsive lg-table">
							<table class="table table-bordered">
								<thead>
									<tr>  
								       <th>客户名称</th>  
								       <th>产品编码</th>  
								       <th>产品名称</th>   
								       <th>计划日期</th> 
								       <th>计划类型</th>  
								       <th>计划数</th> 
								       <th>订货数</th> 
								       <th>计划准确率</th> 
								    </tr>
								</thead>
								<tbody>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>月计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>月计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>月计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
									<tr>
										<td>林氏木业有限公司</td>
										<td>113020109</td>
										<td>8201仔猪浓缩饲料(粉料42KG)</td>
										<td>2015-03-05</td>
										<td>月计划</td> 
										<td>75</td>
										<td>100</td>
										<td>75%</td>
									</tr>
								</tbody>
							</table>
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