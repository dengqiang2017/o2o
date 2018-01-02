<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>派工单</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <%@include file="../res.jsp" %>
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css">
    <link rel="stylesheet" type="text/css" href="../pc/pmcss/paigongdan.css">
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/pmjs/paigongdan.js${requestScope.ver}"></script>
</head>
     <style>
       @media(min-width:1200px){
         .qh2{
    width: 1149px;
    margin: auto;
    margin-top: 34px;
    }
    }
    @media(max-width:770px){
    .qh2{
    width: 95%;
    margin: auto;
    margin-top: 34px;
    }
    .margin00{
    margin-top:10px
    }
    }
    </style>
<body style="background-color: #C8D6DF">
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>我的生产</li>
    </ol>
    <div class="header-title">
        员工-我的生产<a href="../employee.do" class="header-back">
        <span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <input type="hidden" id="isAutoFind" value="false">
    <div class="header-logo"></div>
</div>
     <div id="item" style="display: none;">
         <div class="section">
             <ul>
                 <li>排产编号：<span id="PH"></span></li>
                 <li>派工数量：<span id="PGSL"></span></li>
                 <li>要求完工时间：<span id="plan_end_date"></span></li>
                 <li>质检通过数量：<span id="WGSL"></span></li>
                 <li>质检时间：<span id="JJSJ"></span></li>
                 <li>待生产数量：<span id="dzjsl"></span></li>
                 <li>生产工序：<span id="work_name"></span></li>
                 <li>生产工人：<span id=clerk_name></span></li>
                 <li>产品名称：<span id="item_name"></span></li>
                 <li>制造要求：<span id="detailc_memo"></span></li>
                 <li>工艺要求：<span id="memo_color"></span></li>
                 <li>其他要求：<span id="memo_other"></span></li>
                 <li>备注：<span id="c_memo"></span></li>
                 <li style="margin-top: 64px;margin-bottom: 32px;"><button type="button" class="btn btn-primary showgximg">查看工艺图纸</button></li>
             </ul>
             <div class="section_bottom2">
                 <div class="section_bottom2_left scz" style="display: none;">生产中...</div>
                 <button class="btn section_bottom2_right kssc" style="border-radius: 0;margin-right: 0;display: none;">开始生产</button>
                 <button class="btn section_bottom2_right tqzj" style="border-radius: 0;margin-right: 0;display: none;">提请质检</button>
             </div>
             <div style="clear: both"></div>
         </div>
     </div>
    <div class="qh2">
    <div class="search">
    <div class="col-xs-12 col-lg-3">
    <label for="">生产状态</label>
    <select class="form-control" id=status>
    <option value="">全部</option>
    <option value="0">未生产</option>
    <option value="1">生产中</option>
    <option value="2">质检中</option>
    <option value="3">已完成</option>
    </select>
    </div>

    <div class="col-xs-12 col-lg-3 margin00">
    <label for="">开始日期</label>
    <input type="text" class="form-control Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="beginDate">
    </div>

    <div class="col-xs-12 col-lg-3 margin00">
    <label for="">结束日期</label>
    <input type="text" class="form-control Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="endDate">
    </div>
    <div class="col-xs-12 col-lg-3" style="margin-top:23px">
    <input type="text" class="form-control" placeholder="请输入搜索关键词">
    <button type="button" class="btn btn-primary find" id="searchKey" style="right: -4px;top: 0;position: absolute;border-radius: 0;height: 100%;">搜索</button>
    </div>
    <div style="clear:both"></div>
    </div>
    </div>
     <section class="container">

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
</body>
</html>