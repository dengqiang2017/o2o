<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>生产质检</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <%@include file="../res.jsp" %>
    <link rel="stylesheet" type="text/css" href="../pc/pmcss/sczhijian.css">
    <link rel="stylesheet" type="text/css" href="../pc/pmcss/lurushuli.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css">
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/pmjs/qualityCheck.js${requestScope.ver}"></script>
</head>
    <style>
       @media (min-width:1200px){
       .section{
    width: 1138px;
    margin-top: 64px;
    margin-bottom: 20px;
    }
    }
    @media (max-width:770px){
    .section{
    width: 93%;
    margin-top: 64px;
    margin-bottom: 20px;
    }
    }
    </style>
<body style="background-color: #C8D6DF">
<div id=listpage>
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>生产质检</li>
    </ol>
    <div class="header-title">
        员工-生产质检 <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <input type="hidden" id="isAutoFind" value="false">
    <div class="header-logo"></div>
</div>
<section>
    <div class="section">
        <ul>
            <li>
                <label class="col-xs-3" style="margin-top: 7px">关键词</label>
                <div class="col-xs-9">
                    <input type="text" class="form-control" id="searchKey">
                </div>
                <div style="clear: both"></div>
            </li>
            <li>
                <label class="col-xs-3" style="margin-top: 7px">计划日期</label>
                <div class="col-xs-9">
                    <input class="form-control Wdate" maxlength="40" type="date" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',isShowClear:true})">
                </div>
                <div style="clear: both"></div>
            </li>
            <li>
                <label class="col-xs-3" style="margin-top: 7px">结束日期</label>
                <div class="col-xs-9">
                    <input class="form-control Wdate"  maxlength="40" type="date" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',isShowClear:true})">
                </div>
                <div style="clear: both"></div>
            </li>
            <li>
                <label class="col-xs-3" style="margin-top: 7px">状态</label>
                <div class="col-xs-9">
                    <select id="status" class="form-control">
                    <option value="2">已提请质检</option>
                    <option value="1">生产中</option>
                    <option value="3">已质检</option>
                    </select>
                </div>
                <div style="clear: both"></div>
            </li>
        </ul>
        <div style="clear: both"></div>
        <button type="button" class="btn btn-primary center-block find" style="margin-top: 16px;width: 100px">搜索</button>
    </div>
    <div class="container">
    <div class="table-responsive">
        <table class="table">
            <thead>
               <tr>
                   <th style="min-width: 50px"></th>
                   <th>排产编号</th>
                   <th>产品名称</th>
                   <th>工序</th>
                   <th>工人</th>
                   <th>数量</th>
                   <th style="min-width: 50px"></th>
               </tr>
            </thead>
            <tbody style="background-color: #F3F5F8">
            </tbody>
        </table>
    </div>
    </div>
</section>
</div>
<div id="qualityIn" style="display: none;">
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="sczj"><span class="glyphicon glyphicon-triangle-right"></span>生产质检</li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>录入质检数量</li>
    </ol>
    <div class="header-title">
        录入质检数量 <a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <div class="header-logo"></div>
</div>


<section class="container" style="margin-top: 50px;">
    <div class="section">
        <ul>
            <li>排产编号：<span id="PH"></span></li>
            <li>派工数量：<span id="PGSL"></span></li>
            <li>完工数量：<span id="WGSL"></span></li>
            <li>待质检数量：<span id="dzjsl"></span></li>
            <li>要求完工时间：<span id="plan_end_date"></span></li>
            <li>生产工序：<span id="work_name"></span></li>
            <li>生产工人：<span id="clerk_name"></span></li>
            <li>产品名称：<span id="item_name"></span></li>
            <li>制造要求：<span id="detailc_memo"></span></li>
            <li>工艺要求：<span id="memo_color"></span></li>
            <li>其他要求：<span id="memo_other"></span></li>
            <li>备注：<span id="c_memo"></span></li>
            <li style="margin-top: 64px;margin-bottom: 32px;"><button type="button" class="btn btn-primary showgximg">查看工艺图纸</button></li>
            <li style="margin-top: 64px;margin-bottom: 32px;">
                <label class="col-xs-5" style="margin-top: 7px">输入质检合格数量:</label>
                <div class="col-xs-7">
                    <input class="form-control" type="tel" maxlength="10" data-num="num">
                </div>
                <div style="clear: both"></div>
            </li>
        </ul>
    </div>
    <button type="button" class="btn btn-primary center-block" style="margin-top: 16px">质检通过</button>
</section>


     <div class="image-zhezhao" style="display:none">
   <div style="width: 5%;float: left">
        <div class="img-left"></div>
   </div>
    <div style="width: 90%;float: left;height: 100%;">
        <div class="img-ku" style="float:left;">
            <div id="imshow">
            </div>
        </div>
    </div>
    <div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div>
</div>
</body>
</html>