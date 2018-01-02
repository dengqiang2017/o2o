<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>牵引O2O营销服务平台</title>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/product.css">
<script src="../js/o2od.js"></script>   
<script src="../js/o2otree.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/employee/rukudan.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>采购入库单</li>
      </ol>
      <div class="header-title">员工-采购入库单
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
      	<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class="active"><a>增加采购入库单</a></li>
			<li class=""><a>已增加入库单</a></li>
			</ul>
       	<div id="finding">
	<div class="form">
		<form id="findForm">
			<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
				    	<label>供应商</label>
				    	<div class="input-group">
							<span class="form-control input-sm" aria-describedby="basic-addon2"  id="vendor_name" ></span>
							<span class="input-group-btn">
								<input id="vendorId" type="hidden" name="vendor_id">
								<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm corp" type="button">浏览</button>
						    </span>
						</div>
				  	</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
					<label for="">付款金额</label><input type="text"
						class="form-control input-sm" data-number="n" >
					</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
					<label for="">未付金额</label><input type="text"
						class="form-control input-sm" data-number="n" >
					</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
					<label for="">总金额</label><input type="text"
						class="form-control input-sm" data-number="n" >
					</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
					<label for="">付款日期</label><input type="date"
						class="form-control input-sm Wdate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
					</div>
				</div>
				<div class="col-lg-3 col-sm-4 m-t-b">
					<div class="form-group">
					<label for="">备注</label><input type="text"
						class="form-control input-sm">
					</div>
				</div>
			<div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px">
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control input-sm" maxlength="50"
							placeholder="请输入搜索关键词" id="searchKey"> <span
							class="input-group-btn">
							<button class="btn btn-success btn-sm find" type="button">搜索</button>
						</span>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
       <div class="box-body">
           <div class="tabs-content" style="display: block;">
           <input type="checkbox" class="check" style="display: none;">
         		<div class="ctn">
             <%@include file="../jiaju/employee/rukudan.jsp" %>
             </div>
                <div class="ctn">
         <button class="btn btn-add" type="button">点击加载更多产品</button>
         </div>
         </div>
           <div class="tabs-content" style="display: block;">
             		<div class="ctn">
             		  <button type="button" class="btn btn-danger" id="deladd">删除</button>
             		</div>
              <div class="col-sm-6" id="item01"></div>
			<div class="col-sm-6" id="item02"></div>
         <div class="ctn">
           <button class="btn btn-add" type="button">点击加载更多</button>
         </div>
             </div>
         </div>
       </div>
     </div>
   <div class="back-top" id="scroll"></div>
   <div class="cover" style="display: block;"></div>
   <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name}&emsp;v1.0.30<span class="glyphicon glyphicon-earphone"></span>
     <div class="btn-gp">
       <button class="btn btn-info" id="allcheck">全选</button>
       <button class="btn btn-info" id="add">提交</button>
       <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
     </div>
   </div>
    
</body>
</html>