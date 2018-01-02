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
 <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
 <script type="text/javascript" src="../pc/js/pm/productionTracking.js${requestScope.ver}"></script>
	
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>生产计划跟踪跟踪</li>
	</ol>
	<div class="header-title">员工-生产计划跟踪
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-body">
					<div class="tabs-content">	
						<div class="ctn">
							<div class="folding-btn m-t-b">
					            <button type="button" class="btn btn-primary btn-folding btn-sm">展开搜索</button>
					        </div>
							<form action="" style="clear:both;overflow:hidden;">
								<div class="col-sm-3 col-lg-2 m-t-b">
					              <div class="form-group">
					                <label for="">关键词</label>
					                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
					              </div>
					            </div>
					            <div class="col-sm-3 col-lg-2 m-t-b">
					              <div class="form-group">
					                <label for="">计划日期</label>
					                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" name="beginDate" maxlength="50">
					              </div>
					            </div>
					            <div class="col-sm-3 col-lg-2 m-t-b">
					              <div class="form-group">
					                <label for="">交货日期</label>
					                <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" value="" name="beginDate" maxlength="50">
					              </div>
					            </div>
					            <div class="col-sm-3 col-lg-2 m-t-b">
					              <div class="form-group">
					                <label for="">工段</label>
					                <select type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
					                	<option value="3">全工段</option>
					                	<option value="0">木工段</option>
					                	<option value="0">油漆段</option>
					                </select>
					              </div>
					            </div>
					            <div class="col-sm-12 m-t-b">
					            	<button type="button" class="btn btn-primary btn-sm find">搜索</button>
					            	<button type="button" class="btn btn-danger btn-sm" id="hide">导出</button>
					            </div>
							</form>
							<div class="text-center">
								<!-- <div class="ctn">
									<button type="button" class="btn btn-danger pull-right"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
								</div> -->
								<h3>生产计划跟踪</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>  
									       <th>计划日期</th>  
									       <th>产品简称</th> 
									       <th>数量</th>  
									       <th>单号</th> 
									       <th>批号</th> 
									       <th>开料人</th> 
									       <th>开料</th> 
									       <th>排钻</th> 
									       <th>铣型</th> 
									       <th>打磨</th> 
									       <th>压沙</th> 
									       <th>组装</th>   
									       <th>库存</th>  
									       <th>交货日期</th> 
									       <th>交货人</th> 
									       <th>备注</th> 
									    </tr>
									</thead>
									<tbody>
										<tr>
											<td><!-- <div class="checkbox"></div> -->2015.06.13</td>
											<td>0838#长门</td> 
											<td>240</td>
											<td>4733</td>
											<td>0615</td>
											<td>王天富</td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td>240</td>
											<td>2015.07.22</td>
											<td>黄龙</td>
											<td><a target="_blank" href="模态框-生产计划跟踪备注.html" type="button" class="btn btn-xs btn-danger">添加</a></td>
										</tr>
										<tr>
											<td><!-- <div class="checkbox"></div> -->2015.06.13</td>
											<td>1.2米铺板</td> 
											<td>84</td>
											<td>4745</td>
											<td></td>
											<td>陈静</td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td></td>
											<td><button type="button" class="btn btn-xs btn-danger">交货</button></td>
											<td>黄龙</td>
											<td>已交货42付6月18日<a target="_blank" href="模态框-生产计划跟踪备注.html" type="button" class="btn btn-xs btn-danger">添加</a></td>
										</tr>
										<tr>
											<td><!-- <div class="checkbox"></div> -->2015.06.13</td>
											<td>382#茶几抽面换件</td> 
											<td>17</td>
											<td>4746</td>
											<td></td>
											<td>陈静</td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><span class="glyphicon glyphicon-ok" style="color:green;"></span></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td><button type="button" class="btn btn-xs btn-danger">完成</button></td>
											<td>17</td>
											<td><button type="button" class="btn btn-xs btn-danger">交货</button></td>
											<td>黄龙</td>
											<td><a target="_blank" href="模态框-生产计划跟踪备注.html" type="button" class="btn btn-xs btn-danger">添加</a></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="pull-right">
							    <input type="text" data-number="num" id="page" value="0" style ="width: 50px;">
								<span>总页数:<span id="totalPage">0</span></span>
							    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
							    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
							</div>
						</div>
					</div>
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

    