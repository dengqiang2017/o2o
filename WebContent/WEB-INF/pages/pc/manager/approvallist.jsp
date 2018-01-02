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
<link rel="stylesheet" href="../pc/css/product.css${requestScope.ver}">
<link rel="stylesheet" href="../pc/css/list.css${requestScope.ver}">
<style>
.body{ margin-bottom:100px;}
</style>
</head>

<body>
<div class="background"></div>
<%@include file="../header.jsp" %>
	<h4 style="text-align:center;">定义【${requestScope.name}】审批流程</h4>
	<input type="hidden" id="type" value="${requestScope.type}">
    	<div class="btn-group">
        	<a class="btn btn-pink" href="approval.do?type=${requestScope.type}&name=${requestScope.name}">添加审批步骤</a>
        </div>
        <div>
	<div class="list-ctn">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">序号</div>
            <div class="col-12-8 bold">01</div>
            </div>
            <button class="btn btn-list">下移</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">是否可跳过</div>
                <div class="col-12-8 bold">
                	<div class="select-line">
                    	<select>
                        	<option>是</option>
                            <option>否</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批步骤</div>
                <div class="col-12-8 bold">经片区经理签担保</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批人</div>
                <div class="col-12-8 bold">张三</div>
            </div>
        </div>
    </div>
    
    <div class="list-ctn">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">序号</div>
            <div class="col-12-8 bold">02</div>
            </div>
            <button class="btn btn-list">上移</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">是否可跳过</div>
                <div class="col-12-8 bold">
                	<div class="select-line">
                    	<select>
                        	<option>是</option>
                            <option>否</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批步骤</div>
                <div class="col-12-8 bold">市场经理审批</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批人</div>
                <div class="col-12-8 bold">李四</div>
            </div>
        </div>
    </div>
    
    <div class="list-ctn">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">序号</div>
            <div class="col-12-8 bold">03</div>
            </div>
            <button class="btn btn-list">上移</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">是否可跳过</div>
                <div class="col-12-8 bold">
                	<div class="select-line">
                    	<select>
                        	<option>是</option>
                            <option>否</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批步骤</div>
                <div class="col-12-8 bold">财务审批</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批人</div>
                <div class="col-12-8 bold">王二</div>
            </div>
        </div>
    </div>
    <div class="list-ctn">
    	<div class="list-head">
        	<div class="row">
        	<div class="col-12-4">序号</div>
            <div class="col-12-8 bold">04</div>
            </div>
            <button class="btn btn-list">上移</button>
        </div>
        <div class="list-body">
        	<div class="row">
            	<div class="col-12-4">是否可跳过</div>
                <div class="col-12-8 bold">
                	<div class="select-line">
                    	<select>
                        	<option>是</option>
                            <option>否</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批步骤</div>
                <div class="col-12-8 bold">总经理审批</div>
            </div>
            <div class="row">
           	 	<div class="col-12-4">审批人</div>
                <div class="col-12-8 bold">周五</div>
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
