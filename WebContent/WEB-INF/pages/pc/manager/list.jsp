<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
 <c:forEach items="${requestScope.fileds}" var="item">
<c:if test="${item.type!='fenge'}">
<c:if test="${item.list==true}">
<th width="200" data-name="<c:if test="${item.showName==''}">${item.filed}</c:if><c:if test="${item.showName!=null}">${item.showName}</c:if>">
${item.name}
</th>
</c:if>
</c:if>
</c:forEach>