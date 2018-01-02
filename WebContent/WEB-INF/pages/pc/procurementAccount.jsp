<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<form id="gzform" style="clear:both;overflow:hidden;">
<!-- <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!--   <div class="form-group"> -->
<!--     <label for="">关键词</label> -->
<!--     <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词"> -->
<!--   </div> -->
<!-- </div> -->
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
<!-- <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!--   <div class="form-group"> -->
<!--     <label for="">订单状态</label> -->
<!--     <select class="form-control input-sm" name="elecState"> -->
<!-- 			<option></option> -->
<!-- 	        <option value="0">未处理</option> -->
<!-- 	        <option value="2">已处理有货</option> -->
<!-- 	        <option value="3">已处理无货</option> -->
<!-- 	        <option value="4">已发货</option> -->
<!-- 	        <option value="5">已收货</option> -->
<!--           </select> -->
<!--         </div> -->
<!--       </div> -->
      <div class="col-sm-12 m-t-b">
      	<button type="button" class="btn btn-primary btn-sm find">搜索</button> 
      </div>
      <input type="hidden" name="customer_id" value="${sessionScope.customerInfo.upper_customer_id}">
      <input type="hidden" name="seeds" value="${requestScope.seeds}">
</form>