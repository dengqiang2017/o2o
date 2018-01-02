<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <link rel="stylesheet" type="text/css" href="../css/productionTrackingQry.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="../js/common.js"></script>
	<script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js"></script>
   	<script type="text/javascript" src="../pc/js/pm/productionTrackingQry.js"></script>
</head>
<body>
<!-------------------------------header-------------------------------------------------------------------------------->
<div class="header header-title"><a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>生产计划跟踪</div>
<!-------------------------------secition------------------------------------------------------------------------------>
<div class="secition">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12">
                <form class="form-horizontal boot-form">
                    <div class="form-group">
                        <label for="inputEmail3" class="col-xs-4 control-label text-left la">关键词</label>
                        <div class="col-xs-8 boot">
                        	<input type="text" class="form-control input-sm secition-two-bd" id="searchKey" placeholder="请输入关键词">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail3" class="col-xs-4 control-label text-left la">计划日期</label>
                        <div class="col-xs-8 boot">
                        	<input type="date" id="d4311" class="form-control input-sm Wdate" 
				            	onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="send_date" placeholder="请输入计划日期">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputEmail3" class="col-xs-4 control-label text-left la">结束日期</label>
                        <div class="col-xs-8 boot">
                            <input type="date" id="d4312" class="form-control input-sm Wdate"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="plan_end_date" placeholder="请输入结束日期">
                        </div>
                    </div>
                    <button type="button" class="boot-sub center-block find">搜索</button>
                </form>
                <table class="table table-bordered ta" style="margin-bottom: 130px">
                    <thead>
	                    <tr>
	                    	<td>排产编号</td>
	                    	<td>产品名称</td>
	                        <td>数量</td>
	                        <td>状态</td>
	                    </tr>
                    </thead>
                    <tbody>
	                    <tr>
	                        <td>FA00030加勒比卧房家具</td>
	                        <td>2015-12-31</td>
	                        <td>12</td>
	                        <td>已完成</td>
	                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<div class="zz">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12">
                <div class="zz-1">
                    <div class="zz-1-a">
                        <ul>
                            <li>生产计划单号：<span id="ivt_oper_listing"></span></li>
                            <li>排产编号：<span id="PH"></span></li>
                            <li>产品名称|计划数量：<span id="item_name_JHSL"></span></li>
                            <li>计划日期：<span id="send_date"></span></li>
                            <li>完工日期：<span id="plan_end_date"></span></li>
                            <li>规格|型号：<span id="item_spec_type"></span></li>
                            <li>产地|品牌|颜色：<span id="vendor_id_class_card_color"></span></li>
                            <li>制造要求：<span id="c_memo"></span></li>
                            <li>工艺要求：<span id="memo_color"></span></li>
                            <li>其他要求：<span id="memo_other"></span></li>
                        </ul>
                    </div>
                    <div id="props">
                    	<div id="prop">
                    		<div class="zz-1-b">
                        		<ul>
                            		<li>&emsp;当前工序：<span id="work_name"></span></li>
                            		<li>&emsp;完工数量：<span id="JJSL"></span></li>
                        		</ul>
                    		</div>
                    	</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>