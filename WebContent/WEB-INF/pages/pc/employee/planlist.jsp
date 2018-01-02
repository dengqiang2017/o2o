<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <%@include file="../res.jsp" %>
   <link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
     <link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
    <script src="../js/o2od.js${requestScope.ver}"></script>
     <script src="../js/o2otree.js${requestScope.ver}"></script>
  <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
  <script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
  <script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/employee/planlistcom.js${requestScope.ver}"></script>
  <script type="text/javascript" src="../pc/js/employee/planlist.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="selClient.jsp" %>
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          <%@include file="showSelectClient.jsp" %>
        </div>
        <div class="box-body">
          <div class="ctn">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">计划类型</label>
                <select class="form-control input-sm" id="sd_order_direct" >
                  <option value="日计划">日计划</option>
                  <option value="周计划">周计划</option>
                  <option value="月计划">月计划</option>
                </select>
              </div> 
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b" id="ti">
              <div class="form-group">
                <label for="">预计提货日期</label>
                <input type="date" class="form-control input-sm Wdate" value="${requestScope.N1Time}" id="at" 
                onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'%y-%M-{%d+1}',onpicked:pickedFunc})">
                <span id="n1time" style="display: none;">${requestScope.N1Time}</span>
              </div> 
            </div>
          </div>
           <p style="color:#af3444; font-size:18px;display: none;" id="chadan">您正在紧急插单！</p>
           <div class="form-group"  id="chadantext">
            <label for="">备注</label>
            <textarea class="form-control input-sm"></textarea>
          </div> 
        </div>  
      </div>
    </div>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
          <%@include file="../find.jsp"%>
        </div>
        <div class="box-body">
          <div class="tabs-content">
            <div id="list"></div>
          <div class="ctn" style="display: none;"> 
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
          <div class="tabs-content">
            <div class="ctn">
            <c:if test="${sessionScope.auth.plan_del!=null}">
              <button type="button" class="btn btn-danger" id="plandel">删除</button>
              </c:if>
              <span id="timespan">以${requestScope.time},之前的为今天的计划,之后的明天的计划</span>
            </div>
            <div id="list">
<!--                 产品模块显示区 -->
            </div>
          <div class="ctn" style="display: none;"> 
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
        </div>
        </div>
      </div> 

    <div class="back-top" id="scroll"></div>

    <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name} 
      <div class="btn-gp">
        <label><input type="checkbox" style="width: 20px;height: 20px;" id="allcheck">全选</label>
        <button class="btn btn-info" id="save" disabled="disabled">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-info">返回</a>
      </div>
    </div>
    
    <div style="display: none;" id="item">
	<div class="col-xs-12 col-sm-12 col-md-6 dataitem" >
    <span id="clerk_id_sid" style="display: none;"></span>
    <span id="ivt_oper_bill" style="display: none;"></span>
    <span id="seeds_id" style="display: none;"></span>
     <span id="item_id" style="display: none;"></span>
    <%@include file="proinfo.jsp" %>
		<div  style="border-bottom: 1px solid aqua;">
        	<div class="col-xs-12 col-sm-12 col-md-6">
	            <label for="">数量</label> 
	            <input type="number" class="p-xs num" data-num="num" id="pronum"> 
	            <span id="item_unit"></span>
        	</div>
          	<div class="col-xs-12 col-sm-12 col-md-6">
	            <label for="">折算数量</label>
	            <span id="pack_unit" style="display: none;"></span>
	            <input type="number" class="p-xs zsum" data-num="num" disabled="disabled"> 
	            <span id="casing_unit"></span>
          	</div>
          	<c:if test="${requestScope.moreMemo}">
          	<div>
           		<button type="button"  class="btn btn-info" id="moreMemo">特殊工艺备注</button>
           		<span id="c_memo"></span>
           		<span id="memo_color"></span>
           		<span id="memo_other"></span>
           </div>
           </c:if>
           <div id="so_consign_date" class="pull-left"></div>
           <div id="ivt_oper_listing" class="pull-left"></div>
           <c:if test="${sessionScope.auth.plan_del!=null}">
           	  <button type="button" class="btn btn-info" id="saveEdit">保存修改</button>
           </c:if>
        </div>
	</div>
</div>
</body>
</html>