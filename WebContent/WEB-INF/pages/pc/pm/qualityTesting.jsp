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
    <link rel="stylesheet" type="text/css" href="../css/qualityTesting.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
	<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="../js/common.js"></script>
	<script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js"></script>
   	<script type="text/javascript" src="../pc/js/pm/qualityTesting.js"></script>
</head>
<body>
<!-------------------------------header------------------------------------------------------------------ ------------->
<div class="header header-title"><a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>质检</div>
<!-------------------------------secition------------------------------------------------------------------------------>
<div class="secition">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12">
                <div class="secition-one">
                    <ul>
                        <li>
                            <div class="kk">
                            <div class="wz1">生产计划单号：</div>
                            <div class="wz2" id="ivt_oper_listing"></div>
                        </div>
                            </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">排产编号：</div>
                                <div class="wz2" id="PH"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">派工单号：</div>
                                <div class="wz2" id="paigong_id"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">工序|派工数量：</div>
                                <div class="wz2" id="work_name_PGSL"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">要求完成时间：</div>
                                <div class="wz2" id="WGSJ"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">产品名称：</div>
                                <div class="wz2" id="item_name"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">规格|型号：</div>
                                <div class="wz2" id="item_spec_type"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">品牌|颜色：</div>
                                <div class="wz2" id="calss_card_item_color"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">产地：</div>
                                <div class="wz2" id="vendor_id"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">制造要求：</div>
                                <div class="wz2" id="c_memo"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">工艺要求：</div>
                                <div class="wz2" id="memo_color"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wz1">其他要求：</div>
                                <div class="wz2" id="memo_other"></div>
                            </div>
                        </li>
                        <li>
                            <div class="kk">
                                <div class="wzl">输入通过数量：</div>
                                <div class="shuru">
                                    <div class="shuruleft"  id="less">-</div>
                                    <div class="shururight" id="more">+</div>
                                    <input type="text" id="JJSL">
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!---------------footer--------------->
<div class="footer_buttom" id="qualityTesting">质检通过</div>
<div style="display:none;">
	<span id="seeds_id">${requestScope.parameters.seeds_id}</span>
</div>
</body>
</html>