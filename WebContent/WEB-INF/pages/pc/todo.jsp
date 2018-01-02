<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>待办事项</title>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<%@include file="js_lib.jsp" %>
<link rel="stylesheet" href="../pc/css/formStyle.css">
<link rel="stylesheet" href="../pc/css/product.css">
<link rel="stylesheet" href="../pc/css/list.css">
<style>
.body{ margin-bottom:50px;}
</style>
</head>

<body>
<div class="background"></div>
<div class="header">
	<a href="javascript:history.go(-1);" class="goback"></a>
	<span>待办事项</span>
</div>
<div class="body">
	<div class="row" style="font-size:12px; margin:10px 3%;">
    	<div class="col-12-3">
        	<span class="tagbox-red"></span>
            待办
        </div>
        <div class="col-12-3">
        	<span class="tagbox-green"></span>
            已办
        </div>
    </div>
	<div class="list-ctn list-green">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">日期</div>
            <div class="col-12-8 bold">2015-6-26</div>
            </div>
            <button class="btn btn-list">查看</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">角色</div>
                <div class="col-12-8 bold">客户-昌州云县家具有限公司</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">催办人</div>
                <div class="col-12-8 bold">王文</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">事由</div>
                <div class="col-12-8 bold">申请使用额度款</div>
            </div>
        </div>
    </div>
    
    <div class="list-ctn list-red">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">日期</div>
            <div class="col-12-8 bold">2015-6-26</div>
            </div>
            <button class="btn btn-list">办理</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">角色</div>
                <div class="col-12-8 bold">员工-市场经理</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">催办人</div>
                <div class="col-12-8 bold">李四</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">事由</div>
                <div class="col-12-8 bold">3日内请假</div>
            </div>
        </div>
    </div>
    
    <div class="list-ctn list-red">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">日期</div>
            <div class="col-12-8 bold">2015-6-26</div>
            </div>
            <button class="btn btn-list">办理</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">角色</div>
                <div class="col-12-8 bold">客户-昌州云县家具有限公司</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">催办人</div>
                <div class="col-12-8 bold">王文</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">事由</div>
                <div class="col-12-8 bold">申请使用额度款</div>
            </div>
        </div>
    </div>
    
    <div class="list-ctn list-green">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">日期</div>
            <div class="col-12-8 bold">2015-6-26</div>
            </div>
            <button class="btn btn-list">查看</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">角色</div>
                <div class="col-12-8 bold">客户-昌州云县家具有限公司</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">催办人</div>
                <div class="col-12-8 bold">王文</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">事由</div>
                <div class="col-12-8 bold">申请使用额度款</div>
            </div>
        </div>
    </div>
</div>
<div class="footer">
<!--     <div class="row"> -->
<!--         <span class="identity">员工&emsp;总经理-唐宫</span> -->
<!--         <span class="phone"><img src="../phone/image/phone.png"></span> -->
<!--     </div> -->
</div>
</body>
</html>
