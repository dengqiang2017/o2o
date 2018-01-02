<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
 <%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>库房详细-${sessionScope.systemName}</title>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<%@include file="../pcxy_res.jsp" %>
	<script src="../js/o2od.js${requestScope.ver}"></script>
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/warehouseEdit.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="warehouse.do">库房维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>库房详细</li>
		</ol>
		<div class="header-title">库房详细
			<a href="warehouse.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body" style="min-height:500px;">
				<div class="form">
				<form id="wareForm" action="save.do" method="get">
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>库房编码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" 
					    	name="${sessionScope.prefix}store_struct_id" maxlength="30" data-num="zimu" value="${requestScope.ware.store_struct_id}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>库房名称</label>
					    	<input type="text" class="form-control input-sm" title="输入库房名称" 
					    	name="${sessionScope.prefix}store_struct_name" maxlength="15" value="${requestScope.ware.store_struct_name}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>记忆码</label>
					    	<input type="text" class="form-control input-sm" title="自动生成" 
					    	name="${sessionScope.prefix}easy_id" maxlength="30" value="${requestScope.ware.easy_id}">
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>库房类别</label>
					    	<select name="${sessionScope.prefix}store_struct_type" class="form-control input-sm" title="选择库房类别">
					    	<c:if test="${requestScope.ware.store_struct_type==null||requestScope.ware.store_struct_type=='公司库房'}">
					    		<option value="公司库房">公司库房</option>
					    		<option value="渠道虚拟库房">渠道虚拟库房</option>
					    	</c:if>
					    	<c:if test="${requestScope.ware.store_struct_type=='渠道虚拟库房'}">
					    		<option value="公司库房">公司库房</option>
					    		<option value="渠道虚拟库房" selected="selected">渠道虚拟库房</option>
					    	</c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>上级库房</label>
					    	<div class="input-group">
								<span class="form-control input-sm" id="upper_storestruct_name" title="点击浏览选择上级库房"
								   >${requestScope.ware.upper_storestruct_name}</span>
								<span class="input-group-btn">
					    			<input type="hidden" name="${sessionScope.prefix}upper_storestruct" id="upper_storestruct"  value="${requestScope.ware.upper_storestruct}">
							        <button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>托管部门</label>
					    	<div class="input-group">
								<span  class="form-control input-sm" id="dept_name" title="点击浏览选择托管部门"
								 >${requestScope.ware.dept_name}</span>
								<span class="input-group-btn">
					    			<input type="hidden" name="${sessionScope.prefix}dept_id" id="deptId"  value="${requestScope.ware.dept_id}">
							        <button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>责任人员</label>
					    	<div class="input-group">
								<span class="form-control input-sm" id="clerk_name" title="点击浏览选择负责人员"
							 >${requestScope.ware.clerk_name}</span>
								<span class="input-group-btn">
							    	<input type="hidden" name="${sessionScope.prefix}clerk_id" id="clerkId"  value="${requestScope.ware.clerk_id}">
							        <button class="btn btn-default btn-sm" type="button">X</button>
							        <button class="btn btn-success btn-sm" type="button">浏览</button>
							    </span>
							</div>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b">
						<div class="form-group">
					    	<label>行政区划</label>
					    	<div class="input-group">
					    	<input type="text" class="form-control input-sm" name="${sessionScope.prefix}regionalism_id" value="${requestScope.ware.regionalism_id}">
<!-- 								<span class="form-control input-sm" disabled="disabled" title="点击浏览选择行政区划" -->
<%-- 								id="regionalism_name_cn" value="${requestScope.ware.regionalism_name_cn}">${requestScope.ware.regionalism_name_cn}</span> --%>
<!-- 								<span class="input-group-btn"> -->
<%-- 									<input type="hidden" name="${sessionScope.prefix}regionalism_id" id="regionalismId"  value="${requestScope.ware.regionalism_id}"> --%>
<!-- 							        <button class="btn btn-default btn-sm" type="button">X</button> -->
<!-- 							        <button class="btn btn-success btn-sm" type="button">浏览</button> -->
<!-- 							    </span> -->
							</div>
					  	</div>
					</div>
<!-- 					<div class="col-lg-3 col-sm-4 m-t-b"> -->
<!-- 						<div class="form-group"> -->
<!-- 					    	<label>所属客户</label> -->
<!-- 					    	<div class="input-group"> -->
<!-- 								<span type="text" class="form-control input-sm" disabled="disabled" title="点击浏览选择所属客户" -->
<%-- 								id="upper_corp_name" value="${requestScope.ware.clerk_name}">${requestScope.ware.clerk_name}</span> --%>
<!-- 								<span class="input-group-btn"> -->
<%-- 									<input type="hidden" name="${sessionScope.prefix}customer_id" id="clientId"  value="${requestScope.ware.customer_id}"> --%>
<!-- 							        <button class="btn btn-default btn-sm" type="button">X</button> -->
<!-- 							        <button class="btn btn-success btn-sm" type="button">浏览</button> -->
<!-- 							    </span> -->
<!-- 							</div> -->
<!-- 					  	</div> -->
<!-- 					</div> -->
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>默认调入仓位</label>
					    	<select name="${sessionScope.prefix}counting_style" id="" class="form-control input-sm" title="选择默认调入仓位">
					    	<c:if test="${requestScope.ware.counting_style==null||requestScope.ware.counting_style=='0'}">
					    		<option value="0">是</option>
					    		<option value="1">否</option>
					    	</c:if>
					    	<c:if test="${requestScope.ware.counting_style=='1'}">
					    		<option value="0">是</option>
					    		<option value="1" selected="selected">否</option>
					    	</c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-3 col-sm-4 m-t-b" style="display: none;">
						<div class="form-group">
					    	<label>该仓位是否是Pos仓位</label>
					    	<select name="${sessionScope.prefix}safety_class" id="" class="form-control input-sm" title="选择Pos仓位">
					    	<c:if test="${requestScope.ware.safety_class==null||requestScope.ware.safety_class=='是'}">
					    		<option value="是">是</option>
					    		<option value="否">否</option>
					    	</c:if>
					    	<c:if test="${requestScope.ware.safety_class=='否'}">
					    		<option value="是">是</option>
					    		<option value="否" selected="selected">否</option>
					    	</c:if>
					    	</select>
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="form-group">
					    	<label>详细地址</label>
					    	<textarea rows="2" class="form-control" name="${sessionScope.prefix}addr" maxlength="50">${requestScope.ware.addr}</textarea>
					  	</div>
					</div>
					<div class="col-lg-12 m-t-b">
						<div class="btn-gp">
<%-- 							<c:if test="${requestScope.info=='info' }"> --%>
<!-- 							<button type="button" class="btn btn-warning" id="edit">修改</button>&emsp;&emsp; -->
<%-- 							</c:if> --%>
							<c:if test="${requestScope.info==null}">
							<button type="button" class="btn btn-info">保存</button>&emsp;&emsp;
							</c:if>
							<c:if test="${requestScope.info!='show' }">
							<button type="button" class="btn btn-primary" onclick="window.location.href='warehouse.do';">返回</button>&emsp;&emsp;
							</c:if>
							<c:if test="${requestScope.info=='show' }">
							<button type="button" class="btn btn-primary" onclick="window.close();">关闭</button>&emsp;&emsp;
							</c:if>
						</div>
					</div>
					<input type="hidden" name="${sessionScope.prefix}sort_id" value="${requestScope.ware.sort_id}">
					</form>
				</div>
			</div>
		</div>

	</div>

	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
<%-- 			<c:if test="${requestScope.info=='info' }"> --%>
<!-- 			<button type="button" class="btn btn-warning" id="edit">修改</button>&emsp;&emsp; -->
<%-- 			</c:if> --%>
<%-- 			<c:if test="${requestScope.info==null}"> --%>
<!-- 			<button type="button" class="btn btn-info">保存</button>&emsp;&emsp; -->
<%-- 			</c:if> --%>
<%-- 			<c:if test="${requestScope.info!='show' }"> --%>
<!-- 			<button type="button" class="btn btn-primary" onclick="window.location.href='warehouse.do';">返回</button>&emsp;&emsp; -->
<%-- 			</c:if> --%>
<%-- 			<c:if test="${requestScope.info=='show' }"> --%>
<!-- 			<button type="button" class="btn btn-primary" onclick="window.close();">关闭</button>&emsp;&emsp; -->
<%-- 			</c:if> --%>
		</div>	
	</div>
</body>
</html>