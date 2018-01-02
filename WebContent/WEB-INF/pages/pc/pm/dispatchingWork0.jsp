<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
	<link rel="stylesheet" href="../pc/css/global.css">
	<link rel="stylesheet" href="../css/popUpBox.css">
	<link rel="stylesheet" href="../css/repair-paigong.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="../js/common.js"></script>
	<script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js"></script>
   	<script type="text/javascript" src="../pc/js/pm/dispatchingWork0.js"></script>
</head>
<body>
<!-------------------------------header----------------------------->
<div class="header header-title"><a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>生产派工</div>
<!-------------------------------secition----------------------------->
<div class="secition">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 secition-one" >
                <ul>
                    <li>生产计划单号：<span id="ivt_oper_listing"></span></li>
                    <li>排产编号：<span id="PH"></span></li>
                    <li>产品名称：<span id="item_name"></span></li>
                    <li>规格：<span id="item_spec"></span></li>
                    <li>颜色：<span id="item_color"></span></li>
                    <li>型号：<span id="item_type"></span></li>
                    <li>产地：<span id="vendor_id"></span></li>
                    <li>品牌：<span id="class_card"></span></li>
                    <li>计划数量：<span id="JHSL"></span></li>
                    <li>产品工序类别：<span id="work_type"></span></li>
                </ul>
            </div>
        </div>
        <div class="row smga">
            <div class="col-xs-12 ">
                <div class="secition-two">
                <form class="form-one">
                    <ul>
                    	<!-- 修改派工时需要用到 -->
                    	<li style="display:none;">
                            <div class="secition-two-a">行种子</div>
                            <div class="secition-two-b sm">
                                <input id="seeds_id" type="text" name="seeds_id" value="">
                            </div>
                        </li>
                        <li>
                            <div class="secition-two-a">工序</div>
                            <div class="secition-two-b sm">
                                <span id="work_name" aria-describedby="basic-addon2"></span>
                                <span>
                                	<input id="work_id" type="hidden" name="work_id" value="">
                                	<input id="No_serial" type="hidden" name="No_serial" value="">
                                    <button class="smg" type="button">浏览</button>
                                </span>
                            </div>
                        </li>
                        <li>
                            <div class="secition-two-a">派工单号</div>
                            <input class="secition-two-b" type="text" id="paigong_id" name="paigong_id" value="">
                        </li>
                        <li>
                            <div class="secition-two-a">生产工人</div>
                            <div class="secition-two-b sm">
                                <span id="clerk_name"  aria-describedby="basic-addon2"></span>
                                <span>
                                <input id="clerk_id" type="hidden" name="clerk_id" value="">
                                    <button class="smg" type="button">浏览</button>
                                </span>
                            </div>
                        </li>
                        <li>
                            <div class="secition-two-a">派工数量</div>
                            <div class="secition-two-h">
                            <input class="secition-two-bd" type="text" id="PGSL" name="PGSL" value="">
                                <button type="button" class="secition-two-hleft" id="reduce">-</button>
                                <button type="button" class="secition-two-hright" id="add">+</button>
                            </div>
                        </li>
                        <li>
                            <div class="secition-two-a">完工时间</div>
                            <div class="secition-two-b">
                                <input value="" type="date" class="Wdate" name="endDate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})">
                            </div>
                        </li>
                    </ul>
                </form>
                <div class="secition-two-c">
                	<button class="chakan" type="button">查看已派工</button>
        			<button class="paigong" type="button">保存</button>
        		</div>
                </div>
            </div>
        </div>
        
        <div class="cl">
            <div class="container-fluid">
                <div class="row clro">
                    <div class="col-xs-12 cl-1" id="props">
                        <div class="cl-2" id="prop">
                            <ul class="ul-mr">
                                <li class="text-center">已派工</li>
                                <!-- 隐藏域begin -->
                            	<li class="hide">行种子：<span id="m_seeds_id"></span></li>
                            	<li class="hide">工序编码：<span id="m_work_id"></span></li>
                            	<li class="hide">工序名称：<span id="m_work_name"></span></li>
                            	<li class="hide">工人编码：<span id="m_clerk_id"></span></li>
                            	<li class="hide">工人名称：<span id="m_clerk_name"></span></li>
                            	<li class="hide">派工单号：<span id="m_paigong_id"></span></li>
                            	<li class="hide">批次号：<span id="m_batch_mark"></span></li>
                            	<li class="hide">当前状态：<span id="m_status"></span></li>
                            	<li class="hide">生产计划单号：<span id="m_ivt_oper_listing"></span></li>
                            	<!-- 隐藏域end -->
                            	<li>排产编号：<span id="m_PH"></span></li>
                            	<li>派工单号：<span id="m_paigong_id"></span></li>
                            	<li>要求完工时间：<span id="m_WGSJ_10"></span></li>
                    			<li>产品名称：<span id="m_item_name"></span></li>
                    			<li>规格：<span id="m_item_spec"></span>&emsp;型号：<span id="m_item_type"></span></li>
                    			<li>产地：<span id="m_vendor_id"></span>&emsp;品牌：<span id="m_class_card"></span></li>
                    			<li>颜色：<span id="m_item_color"></span></li>
                    			<li>工序名称：<span id="m_work_name"></span>&emsp;工人名称：<span id="m_clerk_name"></span></li>
                    			<li>派工数量：<span id="m_PGSL"></span>&emsp;当前状态：<span id="m_status_trans"></span></li>
                            </ul>
                            <div class="cl-2-a">
                                <ul>
                                    <li><button class="a1" id="edit">编辑</button></li>
                                    <li class="li-1"><button class="a1" id="del">删除</button></li>
                                    <li><button class="a1" id="unuse">作废</button></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="cl-4">
                        <button class="cl-3s" type="button" id="sendInfo">微信通知</button>
                        <button class="cl-3" type="button" id="close">关闭</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div style="display:none;">
	<span class="PH">${requestScope.parameters.PH}</span>
	<span class="paigong_id">${requestScope.parameters.paigong_id}</span>
	<span class="PlanPush">${requestScope.parameters.PlanPush}</span>
</div>
</body>
</html>