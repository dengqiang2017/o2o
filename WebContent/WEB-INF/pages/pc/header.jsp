<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="header">
	<ol class="breadcrumb">
		<li><span class="glyphicon glyphicon-triangle-right"></span><a
			href="../employee.do">${sessionScope.indexName}</a></li>
		<li class="active"><span
			class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
	<div class="header-title">
		${requestScope.pageName} <a href="../employee.do" class="header-back"><span
			class="glyphicon glyphicon-menu-left"></span></a>
	</div>
	<div class="header-logo"></div>
	<input type="hidden" id='accnIvt' value="${requestScope.accnIvt}">
	<span style="display: none;" id="com_id">${sessionScope.userInfo.com_id}</span>
</div>