<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<form id="gzform" style="clear:both;overflow:hidden;">
<div class="col-sm-3 col-lg-2 m-t-b">
  <div class="form-group">
    <label for="">关键词</label>
    <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
  </div>
</div>
<div class="col-sm-3 col-lg-2 m-t-b">
  <div class="form-group">
    <label for="">起始日期</label>
    <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="beginDate">
  </div>
</div>
<div class="col-sm-3 col-lg-2 m-t-b">
  <div class="form-group">
    <label for="">结束日期</label>
    <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="endDate">
  </div>
</div>
<div class="col-sm-3 col-lg-2 m-t-b">
  <div class="form-group">
    <label for="">状态</label>
    <select class="form-control input-sm" name="type">
	<option value="00"></option>
	<option value="打欠条">打欠条</option>
<!-- 	<option value="预存款审批">预存款审批</option> -->
	<c:forEach items="${requestScope.processName}" var="name">
    <option value="${name}">${name}</option>
	</c:forEach>
<!--           	<option value="已结束">已结束</option> -->
          </select>
        </div>
      </div>
<div class="col-sm-3 col-lg-2 m-t-b" id=elecStateDiv style="display: none;">
  <div class="form-group">
    <label for="">安装状态</label>
    <select class="form-control input-sm" name="elecState">
			<option></option>
	        <option value="0">未预约</option>
	        <option value="1">已预约未安装</option>
	        <option value="2">已安装未验收评价</option>
	        <option value="3">已验收未支付</option>
	        <option value="4">已支付</option>
          </select>
        </div>
      </div>
      <div class="col-sm-12 m-t-b">
      	<button type="button" class="btn btn-primary btn-sm find">搜索</button> 
      </div>
      <input type="hidden" name="customer_id" value="${sessionScope.customerInfo.upper_customer_id}">
      <input type="hidden" name="seeds" value="${requestScope.seeds}">
      <input type="hidden" name="rows">
</form>