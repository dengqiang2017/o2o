<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<input type="hidden" name="math" id="math">
<c:forEach items="${requestScope.fileds}" var="item">
<c:choose>
<c:when test="${item.type=='fenge'}">
<div class="col-lg-12 col-sm-12 m-t-b"><h4>${item.name}</h4></div>
</c:when>
<c:when test="${item.type=='liulan' && item.edit==true}">
<div class="col-lg-3 col-sm-4 m-t-b">
		<div class="form-group">
	    	<label><c:if test="${item.required==true}">
<span style="color:red">*${item.name}</span>
</c:if>
<c:if test="${!item.required}">
${item.name}
</c:if></label>
<div class="input-group">
	<input id="${item.filedId}" type="hidden" name="${item.filed}">
<span class="form-control input-sm" aria-describedby="basic-addon2"  id="${item.showNameId}" ></span>
<span class="input-group-btn">
	<button class="btn btn-default btn-sm" type="button">X</button>
       <button class="btn btn-success btn-sm" type="button">浏览</button>
		    </span>
		</div>
  	</div>
</div>
</c:when>
<c:when test="${item.type=='select' && item.edit==true}">
<div class="col-lg-3 col-sm-4 m-t-b">
	<div class="form-group">
    	<label><c:if test="${item.required==true}">
<span style="color:red">*${item.name}</span>
</c:if>
<c:if test="${!item.required}">
${item.name}
</c:if></label>
<select name="${item.filed}" class="form-control input-sm">
<c:forEach items="${item.option}" var="op">
<option value="${op.opVal}" <c:if test="${op.selected=='selected'}">selected="${op.selected}"</c:if>>${op.opName}</option>
</c:forEach>
    	</select>
  	</div>
</div>
</c:when>
<c:when test="${item.type=='textarea' && item.edit==true}">
<div class="col-lg-4 col-sm-4 m-t-b">
	<div class="form-group">
    	<label><c:if test="${item.required==true}">
<span style="color:red">*${item.name}</span>
</c:if>
<c:if test="${!item.required}">
${item.name}
</c:if></label>
<textarea rows="4" cols="60" name="${item.filed}" maxlength="${item.len}"></textarea>
  	</div>
</div>
</c:when>
<c:when test="${item.filed=='headship' && item.edit==true}">
<div class="col-lg-3 col-sm-4 m-t-b" id=zhiwu>
<div class="form-group">
   	<label><span style="color:red">*职位</span></label>
                  <div class="input-group">
<div class="col-lg-10 col-xs-10">
    	<input type="text" class="form-control input-sm" id="headship" name="headship" maxlength="40" 
value="${requestScope.client.headship}"></div>
<div class="col-lg-2 col-xs-2">
		<button class="btn btn-primary btn-sm" type="button" id="liuzhiwu">浏览</button>
</div>
</div>
	<%@include file="modal/zhiwuSelect.jsp"%>
  	</div>
</div>
</c:when>
<c:when test="${(item.type=='date'||item.type=='datetime')&& item.edit==true}">
<div class="col-lg-3 col-sm-4 m-t-b">
<div class="form-group">
<label>
<c:if test="${item.required==true}">
<span style="color:red">*${item.name}</span>
</c:if>
<c:if test="${!item.required}">
${item.name}
</c:if>
</label>
<input type="${item.type}" class="form-control input-sm Wdate" name="${item.filed}" maxlength="${item.len}" 
<c:if test="${item.type=='date'}">
onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"
</c:if>
<c:if test="${item.type=='datetime'}">
onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
</c:if>
data-number="${item.dataNumber}">
  	</div>
</div>
</c:when>
<c:otherwise>
<c:if test="${item.name!=null && item.edit==true}">
<div class="col-lg-3 col-sm-4 m-t-b">
<div class="form-group">
<label>
<c:if test="${item.required==true}">
<span style="color:red">*${item.name}</span>
</c:if>
<c:if test="${!item.required}">
${item.name}
</c:if>
</label>
<input type="${item.type}" class="form-control input-sm" name="${item.filed}" maxlength="${item.len}" 
data-number="${item.dataNumber}">
  	</div>
</div>
</c:if>
</c:otherwise>
</c:choose>
</c:forEach>