<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="../pcxy/css/function.css">
<div id="authority">
	<script type="text/javascript" src="../pc/js/authority.js"></script>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../manager.do">管理员首页</a></li>
	  <li class="active" id="personnel_li"><span class="glyphicon glyphicon-triangle-right"></span><a>员工维护</a></li>
	  <li class="active" id="authority_li"><span class="glyphicon glyphicon-triangle-right"></span><a>员工详细</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>员工功能权限</li>
	</ol>
	<div class="header-title">管理员-员工功能权限
		<a id="authority_a" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
<%@include file="authorityItem.jsp" %>
</div>