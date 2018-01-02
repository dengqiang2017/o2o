<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>定义审批流程</title>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<%@include file="../js_lib.jsp" %>
<link rel="stylesheet" href="../pc/css/formStyle.css${requestScope.ver}">
<link rel="stylesheet" href="../pc/css/list.css${requestScope.ver}">
<link rel="stylesheet" href="../pc/css/message.css${requestScope.ver}">
<style>
.body{ margin-bottom:90px;}
</style>
</head>

<body>
<div class="background"></div>
<%@include file="../header.jsp" %>
<div class="body">
	<div class="panel">
    	<div class="panel-head">添加【${requestScope.name}】审批步骤</div>
        <div class="panel-body">
        	<div class="container form-group-default">
                <div class="col-12-3 gray text-right form-label">序号</div>
                <div class="col-12-8 pull-12-1">
                    <input type="text" class="input-line" value="06">
                </div>
            </div>
            <div class="container form-group-default">
                <div class="col-12-3 gray text-right form-label">是否可跳过</div>
                <div class="col-12-8 pull-12-1">
                    <div class="select-line">
                    <select>
                        <option>是</option>
                        <option>否</option>
                    </select>
                    </div>
                </div>
            </div>
            
            <div class="container form-group-default">
                <div class="col-12-3 gray text-right form-label">审批步骤</div>
                <div class="col-12-8 pull-12-1">
                    <input type="text" class="input-line">
                </div>
            </div>
            <div class="container form-group-default">
                <div class="col-12-3 gray text-right form-label">审批人</div>
                <div class="col-12-8 pull-12-1">
                    <input type="text" class="input-line">
                </div>
            </div>
        </div>
    </div>
    
</div>
<div class="footer">
	<div class="btn-group"><button type="button" onclick="alert('提交成功!');window.location.href='../manager.do';" class="btn btn-red">提交</button></div>
    <%@include file="footer.jsp" %>
</div>
</body>
</html>
