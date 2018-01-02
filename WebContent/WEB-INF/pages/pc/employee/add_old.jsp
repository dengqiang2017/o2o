<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
 <%@include file="../res.jsp" %>
  <link rel="stylesheet" href="../pcxy/css/product.css">
   <script src="../js/o2od.js"></script>   
   <script src="../js/o2otree.js"></script>
  <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
  <script type="text/javascript" src="../pc/js/employee/add_old.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="selectClient.do?type=0">选择客户</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>为客户增加品种</li>
      </ol>
      <div class="header-title">员工-为客户增加品种
        <a href="selectClient.do?type=0" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          客户信息
        </div>
        <div class="box-body">
          <ul class="sim-msg">
            <li></li> 
          </ul>     
        </div>  
      </div>
    </div>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
      
        <%@include file="../find.jsp" %>
        
        <div class="box-body">
            <div class="tabs-content" style="display: block;">
          		<div class="ctn">
              <%@include file="../list/employee/add.jsp" %>
              </div>
                 <div class="ctn">
          <input type="hidden" id="page">
          <input type="hidden" id="count">
          <input type="hidden" id="totalPage">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
            <div class="tabs-content" style="display: block;">
              		<div class="ctn">
              		  <button type="button" class="btn btn-danger">删除</button>
              		</div>
               <div class="col-sm-6" id="item01"></div>
				<div class="col-sm-6" id="item02"></div>
              </div>
          </div>
          <div class="ctn">
          <input type="hidden" id="paged">
          <input type="hidden" id="counted">
          <input type="hidden" id="totalPaged">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
        </div>
      </div>
    <div class="back-top" id="scroll"></div>
<div class="left-hide-ctn" style="display: block;">
      <h4>客户信息</h4>
      <div class="hide-table"> 
        <ul class="hide-title">
          <li class="col-xs-6">客户名称</li>
          <li class="last col-xs-6">编码</li>
        </ul>
        <ul class="hide-msg">
          <li class="col-xs-6"></li>
          <li class="last col-xs-6"></li>
        </ul>
      </div>    
    </div>
    <div class="cover" style="display: block;"></div>
    <div class="footer">
      员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button class="btn btn-info" id="allcheck">全选/取消</button>
        <button class="btn btn-info" id="add">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
    </div>
    
</body>
</html>