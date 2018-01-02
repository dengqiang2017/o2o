<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${sessionScope.o2o=='jiaju'}">
 <%@include file="../../jiaju/customer/myorder0.jsp"%>
</c:if>
<c:if test="${sessionScope.o2o=='tw'}">
 <%@include file="../../tw/customer/myorder0.jsp"%>
</c:if>