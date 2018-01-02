<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
	<div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">员工首页</a></li>
		  <li class="tolistpage"><span class="glyphicon glyphicon-triangle-right"></span><a>部门维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>部门详细</li>
		</ol>
		<div class="header-title">部门详细
			<a class="header-back tolistpage"><span class="glyphicon glyphicon-menu-left"></span></a>	
		</div>
		<div class="header-logo"></div>  
	</div>
	<div class="container">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<h4 class="pull-left">基本信息</h4>
			</div>
			<div class="box-body">
			<form id="editForm">
				<div class="form">
				<%@include file="edit.jsp"%>
				</div>
			    <input type="hidden" name="sort_id" id="sort_id" value="${requestScope.sort_id}">
				</form>				
			</div>
		</div>

	</div>
	<div class="footer">
		 员工:${sessionScope.userInfo.personnel.clerk_name}
		<div class="btn-gp">
			<button class="btn btn-info" type="button">保存</button>
			<a class="btn btn-primary tolistpage">返回</a>
		</div>	
	</div> 
