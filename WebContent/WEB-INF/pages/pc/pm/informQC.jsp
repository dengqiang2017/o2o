<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap-theme.min.css">
    <link rel="stylesheet" type="text/css" href="../pc/css/global.css">
    <link rel="stylesheet" type="text/css" href="../css/popUpBox.css">
    <link rel="stylesheet" type="text/css" href="../css/informQC.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="../js/common.js"></script>
	<script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
 	<script type="text/javascript" src="../pc/js/pm/informQC.js"></script>
</head>
<body>
<!-------------------------------header----------------------------->
<div class="header header-title"><a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>派工单</div>
<!-------------------------------secition----------------------------->
<div class="secition">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12" id="props">
                <!-- 
                	<div class="secition-wz1">当前工序：木工段A</div>
                	<div  class="secition-wz2">当前工人：张三</div> 
                -->
                <div class="secition-one" id="prop">
                    <div class="secition-one-1">
                        <ul>
                        	<!-- 隐藏域begin -->
                        	<li class="hide">seeds_id：<span id="seeds_id"></span></li>
                        	<li class="hide">work_id：<span id="work_id"></span></li>
                        	<li class="hide">work_type：<span id="work_type"></span></li>
                        	<li class="hide">No_serial：<span id="No_serial"></span></li>
                        	<li class="hide">item_id：<span id="item_id"></span></li>
                        	<!-- 隐藏域end -->
                            <li>生产计划单号：<span id="ivt_oper_listing"></span></li>
                            <li>排产单号：<span id="PH"></span></li>
                            <li>派工单号：<span id="paigong_id"></span></li>
                            <li>工序：<span id="work_name"></span>&emsp;工人：<span id="clerk_name"></span></li>
                            <li>派工数量：<span id="PGSL"></span>&emsp;要求完工时间：<span id="WGSJ"></span></li>
                            <li>产品名称：<span id="item_name"></span></li>
                            <li>规格：<span id="item_spec"></span>&emsp;型号：<span id="item_type"></span></li>
                            <li>产地：<span id="vendor_id"></span>&emsp;品牌：<span id="class_card"></span></li>
                            <li>颜色：<span id="item_color"></span></li>
                            <li>制造要求：<span id="c_memo"></span></li>
                            <li>工艺要求：<span id="memo_color"></span></li>
                            <li>其他要求：<span id="memo_other"></span></li>
                            <li id="gytz" style="margin-left:5px;"><button class="btn btn-info btn-sm" onclick="seegytz(this)">查看工艺图纸</button></li>
                        </ul>
                        <button class="tq center-block" type="button" id="beginWork">开始生产</button>
                        <button class="tq center-block" type="button" id="sendInformQC">提请质检</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="hide">
	<span id="PlanSource">${requestScope.parameters.PlanSource}</span>
	<span id="clerk_id">${requestScope.parameters.userInfo.clerk_id}</span>
	<span id="clerk_name">${requestScope.parameters.userInfo.clerk_name}</span>
	<span id="work_id"></span>
	<span id="work_name"></span>
</div>
</body>
</html>