<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>工人工价表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <%@include file="../res.jsp" %>
    <link rel="stylesheet" type="text/css" href="../pc/pmcss/grgongjia.css${requestScope.ver}">
    <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
	<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
    <script type="text/javascript" src="../pc/pmjs/workSumPrice.js${requestScope.ver}"></script>
</head>
<body style="background-color: #C8D6DF">
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>工价汇总统计</li>
    </ol>
    <div class="header-title">
        员工-工价汇总统计 <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <input type="hidden" id="isAutoFind" value="false">
    <div class="header-logo"></div>
</div>
<section class="container" style="margin-top: 71px">
    <div class="section_one">
        <ul>
            <li>
                <label class="col-xs-3" style="margin-top: 7px;text-align: center">关键词</label>
                <div class="col-xs-9"><input type="text"  id="searchKey" placeholder="请输入关键词" maxlength="20" class="form-control"></div>
            </li>
            <li>
                <label class="col-xs-3" style="margin-top: 7px;text-align: center">计划日期</label>
                <div class="col-xs-9">
                <input  id="d4311" class="Wdate form-control"
				            	onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')}'})" style="border: 1px solid #067FBC">
                
                </div>
            </li>
            <li>
                <label class="col-xs-3" style="margin-top: 7px;text-align: center">结束日期</label>
                <div class="col-xs-9">
                <input  id="d4312" class="Wdate form-control"
					onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}'})" style="border: 1px solid #067FBC">
                </div>
            </li>
            <div style="clear:both;"></div>
        </ul>
        <button type="button" class="btn btn-primary find" style="width: 100px;float: right;margin-top: 10px;margin-right: 16px;">查询</button>
        <button type="button" class="btn btn-primary print" style="width: 100px;float: right;margin-top: 10px;margin-right: 16px;">打印</button>
        <div style="clear:both;"></div>
    </div>
    <div class="section_two table-responsive" id=print style="overflow:hidden">
    <h1 style="text-align: center;">工价汇总</h1>
        <table class="table table-bordered">
            <thead style="background-color: #36A0AD;color: #FFFFFF;">
                 <tr>
                 	 <th>查看</th>
                     <th data-name="PH">排产编号</th>
                     <th data-name="corp_name">客户</th>
<!--                      <th data-name="pgdh">派工单号</th> -->
                     <th data-name="item_sim_name">产品名称</th>
                     <th data-name="JHSL">计划数量</th>
                     <c:forEach items="${requestScope.productionProcess}"  var="pp">
                     <th class="gx"><span>${pp.work_name}总价</span><span style="display: none;">${pp.sort_id}</span></th>
                     </c:forEach>
                     <th>汇总</th>
                 </tr>
            </thead>
            <tbody style="background-color: #FFFFFF">
                 <tr>
                     <td>T20160404256</td>
                     <td>工序A</td>
                     <td>晨冉装修公司</td>
                     <td>T20160404256</td>
                     <td>安全防护玻璃</td>
                     <td>200</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>800</td>
                 </tr>
                 <tr>
                     <td style="padding: 0;">
                         <div class="hz">汇总</div>
                     </td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td></td>
                     <td>200</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>150</td>
                     <td>800</td>
                 </tr>
            </tbody>
        </table>
    </div>
</section>
</body>
</html>