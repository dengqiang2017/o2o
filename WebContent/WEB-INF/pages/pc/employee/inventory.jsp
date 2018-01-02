<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp"%>
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
	<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
	<script type="text/javascript" src="../pc/js/employee/inventory.js"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>期初库存报表</li>
	</ol>
	<div class="header-title">员工-期初库存报表
		<a href="function-gly.html" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>

<div class="container">
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-body">
					<!-- 所有sheet公用 -->
					<div class="tabs-content">
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
				        </div>
						<form action="" style="clear:both;overflow:hidden;" id="gzform">
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">关键词</label> -->
<!-- 				                <input type="text" class="form-control input-sm" id="searchKey" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label>库房</label>
						    	<div class="input-group">
						    		<input id="store_struct_id" type="hidden" name="store_struct_id" value="">
									<span class="form-control input-sm" aria-describedby="basic-addon2"  id="store_struct_name"></span>
									<span class="input-group-btn">
										<button class="btn btn-default btn-sm" type="button">X</button>
								        <button id="a" class="btn btn-success btn-sm" type="button">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label>产品</label>
						    	<div class="input-group">
						    		<input id="item_id" type="hidden" name="item_id" value="">
									<span class="form-control input-sm" aria-describedby="basic-addon2"  id="item_name"></span>
									<span class="input-group-btn">
										<button class="btn btn-default btn-sm" type="button">X</button>
								        <button id="a" class="btn btn-success btn-sm" type="button">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">产品</label> -->
<!-- 				                <input type="text" class="form-control input-sm" id="item_id" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">规格</label> -->
<!-- 				                <input type="text" class="form-control input-sm" id="item_spec" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">型号</label> -->
<!-- 				                <input type="text" class="form-control input-sm" id="item_type" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
				            <div class="col-sm-3 col-lg-2 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<span  id="upload-btn" class="btn btn-sm btn-danger" style="margin-top:25px;">导入 -->
<!-- 									<input type="file" id="xlsware" name="xlsware" onchange="excelImport(this,'ware');"> -->
<!-- 								</span> -->
<!-- 			            		<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;">导出</button> -->
				            </div>
						</form>
						<div class="text-center">
							<h3>期初库存报表</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>库房</th>  
								       <th>产品类别</th>  
								       <th>排产编号</th>  
								       <th>产品编码</th> 
 								       <th>产品名称</th>   
								       <th>规格</th>   
								       <th>型号</th> 
								       <th>配色</th> 
								       <th>品牌</th> 
								       <th>单位</th>   
								       <th>期初数量</th> 
								       <th>成本单价</th> 
								       <th>成本金额</th> 
								       <th>其他备注</th> 
								       <th>库房编码</th> 
								    </tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="pull-right">
							<span style="width: 50px;height: 20px;text-align: center;line-height: 20px" id="page">当前页:0</span>
					    	<input type="hidden" value="" id="totalPage">
							<button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
							<button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
							<button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
							<button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}<!-- <span class="glyphicon glyphicon-earphone"></span> -->
</div>

</body>
</html>

