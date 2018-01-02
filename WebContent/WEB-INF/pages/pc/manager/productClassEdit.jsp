<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> --%>
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li class="tolistpage"><span class="glyphicon glyphicon-triangle-right"></span><a>产品类别</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>产品类别详细</li>
		</ol>
		<div class="header-title">产品类别详细
			<a class="header-back tolistpage"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container" style="margin-top:10px;">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body" style="min-height:500px;">
				<form id="editForm">
				<input type="reset" id="resetForm" style="display: none;">
				<input type="hidden" id="info" value="${requestScope.info}">
				<input type="hidden" id="sort_id" name="sort_id" value="${requestScope.sort_id}">
				<div class="form">
				 <%@include file="edit.jsp"%>
				</div>
				</form>
			</div>
		</div>
	</div>
	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<c:if test="${requestScope.info=='info' }">
			<button class="btn btn-warning" id="edit" type="button">修改</button>&emsp;&emsp;
			</c:if>
			<button class="btn btn-info" id="save" type="button">保存</button>&emsp;&emsp;
			<c:if test="${requestScope.info!='show' }">
			<button class="btn btn-primary tolistpage" type="button" >返回</button>&emsp;&emsp;
			</c:if>
			<c:if test="${requestScope.info=='show' }">
			<button class="btn btn-primary tolistpage"  type="button">关闭</button>&emsp;&emsp;
			</c:if>
		</div>	
	</div>
