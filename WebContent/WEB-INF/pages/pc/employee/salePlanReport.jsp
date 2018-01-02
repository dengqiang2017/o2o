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
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售计划报表</li>
	</ol>
	<div class="header-title">员工-销售计划报表
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container-fluid" >
	<div class="row">
		<div class="col-lg-4 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head">
					<form class="form-inline">
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>姓名</label>
					    		<input type="text" class="form-control input-sm">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>部门</label>
					    		<input type="text" class="form-control input-sm">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>手机号</label>
					    		<input type="text" class="form-control input-sm">
					  		</div>
						</div>
					  	<div class="col-sm-6 m-t-b">
					  		<button type="button" class="btn btn-primary btn-sm">查询</button>
					  	</div>
					</form>
				</div>
				<div class="box-body">
					<div class="tree lg-tree">
						<ul>
							<li>
						   		<span><i class="glyphicon glyphicon-folder-open"></i>&nbsp;总部1</span> 
						   		<ul>
						    		<li>
						      			<span><i class="glyphicon glyphicon-minus-sign"></i>&nbsp;分部1</span> 
						     			<ul>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工1</span> 
						      				</li>
						     			</ul>
						    		</li>
						    		<li>
						      			<span><i class="glyphicon glyphicon-minus-sign"></i>&nbsp;分部2</span> 
						    			<ul>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工2</span> 
						      				</li>
						      				<li>
						        				<span><i class="glyphicon glyphicon-minus-sign"></i>&nbsp;员工3</span> 
						       					<ul>
						        					<li>
						          						<span><i class="glyphicon glyphicon-minus-sign"></i>&nbsp;小组1</span> 
						           							<ul>
													            <li>
													              <span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工5</span> 
													            </li>
													            <li>
													              <span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工6</span> 
													            </li>
						            						</ul>
						        					</li>
											        <li>
											          <span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工7</span> 
											        </li>
											        <li>
											          <span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工8</span> 
											        </li>
						       					</ul>
						      				</li>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i>&nbsp;员工1</span> 
						      				</li>
						    			</ul>
						    		</li>
						   		</ul>
						  	</li>
						  	<li>
						   		<span><i class="glyphicon glyphicon-folder-open"></i>&nbsp;总部3</span> 
						   		<ul>
						    		<li>
						      			<span><i class="glyphicon glyphicon-leaf"></i>&nbsp;分部1</span> 
						      		</li>
						     	</ul>
						  	</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-8 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">员工列表</h4>
				<div class="pull-right">
					<a href="salePlanAccuracy.do" class="btn btn-success">查看销售计划报表</a>
				</div>
		  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>员工姓名</th>  
							       <th>员工编码</th> 
							       <th>员工账号</th>  
							       <th>性别</th> 
							       <th>所属部门</th>  
							       <th>记忆码</th> 
							       <th>工作状态</th>  
							       <th>手机号</th> 
							    </tr>
							</thead>
							<tbody>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
								<tr>
									<td><a href="gly-ygxx.html">员工1</a></td>
									<td>Y0000004</td>
									<td>13890011120</td>
									<td>男</td>
									<td>销售部</td>
									<td>YGY</td>
									<td>在职</td> 
									<td>15276777456</td> 
								</tr>
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

 