<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<title>牵引O2O营销服务平台</title>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>牵引O2O营销服务平台</title>
 	<%@include file="../res.jsp" %>
   	<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
   	<script type="text/javascript" src="../pc/js/pm/productionProcess.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>生产工序定义</li>
      </ol>
      <div class="header-title">员工-生产工序定义
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
    	<div class="ctn-fff box-ctn" style="min-height:600px;">
    		<div class="box-head">
    			生产工序定义
    		</div>
    		<div class="box-body">
    		<form action="">
    				<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>产品工序类别</label>
					    	<select class="form-control input-sm" id="working_procedure_section" name="working_procedure_section">
					    	<c:forEach items="${requestScope.working_procedure_section}" var="prop">
								<option value="${prop}">${prop}</option>
							</c:forEach>
					    	</select>
					  	</div>
					</div>
    			</form>
    			<div class="ctn">
    				<button type="button" class="btn btn-primary" id="addProcess">新增生产工序</button>
					<a type="button" class="btn btn-primary" id="find" style="display:none">查询</a>
				</div>
				<div class="ctn" id="productionProcess" style="margin-top:10px;">
					<div class="col-lg-3 col-sm-4" id="process">
						<div class="panel panel-info sp-ctn">
							<div class="panel-heading sp-head">序号:<span id="No_serial">1</span></div>
							<div class="panel-body sp-body">
								<div class="ctn">
									<div class="col-xs-4 sp-label">工序名称</div>
									<div class="col-xs-8 sp-content" id="work_name"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">工序类别</div>
									<div class="col-xs-8 sp-content" id="workname"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">工序价格</div>
									<div class="col-xs-8 sp-content" id="work_price"></div>
								</div>
								<div class="ctn" style="display: none;">
									<div class="col-xs-4 sp-label">所属上级工序</div>
									<div class="col-xs-8 sp-content" id="upper_work_id"></div>
								</div>
								<span style="display: none;" id="work_type"></span>
								<span style="display: none;" id="sort_id"></span>
								<span style="display: none;" id="work_id"></span>
								<span style="display: none;" id="easy_id"></span>
								<span style="display: none;" id="upper_work_id"></span>
							</div>
							<div class="panel-footer">
								<button type="button" class="btn btn-xs btn-info" id="upMove">上移</button>
								<button type="button" class="btn btn-xs btn-info" id="downMove">下移</button>
								<button type="button" class="btn btn-xs btn-primary" id="editProcess">编辑</button>
								<button type="button" class="btn btn-xs btn-danger" id="deleteProcess">删除</button>
							</div>
						</div>
					</div>
				</div>	
    		</div>
    	</div>
    </div>
    
    <div id="modal" style="display:none;">
    	<div class="modal-cover-first"></div>
		<div class="modal-first" style="display:block;">
    		<div class="modal-dialog">
        		<div class="modal-content">
            		<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title">增加生产工序</h4>
					</div>
					<div class="modal-body" style="max-height:320px; overflow-y:scroll;">
						<form>
							<div class="col-sm-6">
			          			<div class="form-group">
			            			<label class="control-label">序号</label>
									<input type="text" class="form-control input-sm" name="No_serial" maxlength="30">
			          			</div>	
							</div>
							<div class="col-sm-6">
								<div class="form-group">
					    			<label>工序类别</label>
					    			<select class="form-control input-sm" name="work_type">
					    			<option value="0">流程型</option>
					    			<option value="1">离散型</option>
					    			</select>
					  			</div>
							</div>
							<div class="col-sm-6">
			          			<div class="form-group">
			            			<label class="control-label">工序名称</label>
									<input type="text" class="form-control input-sm" name="work_name" maxlength="30">
			          			</div>	
							</div>
							<div class="col-sm-6">
			          			<div class="form-group">
			            			<label class="control-label">工序价格</label>
									<input type="tel" class="form-control input-sm" name="work_price" maxlength="6" data-number="num2">
			          			</div>	
							</div>
							<div class="col-sm-6">
			          			<div class="form-group">
			            			<label class="control-label">工序编码</label>
									<input type="tel" class="form-control input-sm" name="work_id" maxlength="20" placeholder="不填时自动生产">
									<input type="hidden"  name="sort_id">
			          			</div>	
							</div>
							<div class="col-sm-6">
			          			<div class="form-group">
			            			<label class="control-label">记忆码</label>
									<input type="tel" class="form-control input-sm" name="easy_id" maxlength="6"  placeholder="不填时自动生产">
			          			</div>	
							</div>
							<div class="col-sm-6" style="display: none;">
			          			<div class="form-group">
			            			<label class="control-label">所属上级工序</label>
									<input type="tel" class="form-control input-sm" name="upper_work_id" maxlength="6">
			          			</div>	
							</div>
		        		</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" id="closeDiv">取消</button>
						<button type="button" class="btn btn-primary" id="saveProcess">确定</button>
					</div>
				</div>
			</div>
		</div>
    </div>

    <div class="footer">
   		员工:${sessionScope.userInfo.personnel.clerk_name}
        <div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a href="../employee.do" class="btn btn-primary">返回</a>
		</div>	
    </div>
</body>
</html>