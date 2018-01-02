<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>供应商-车号明细</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/collect.css">
    <link rel="stylesheet" href="../pc/css/query.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
</head>
<body>
<div id="listpage">
<div class="header">
    <a href="javascript:history.back(1)" class="pull-left">返回</a>
    车号明细
    <a class="pull-right check">
        <img src="../pc/images/search2.png">
    </a>
</div>
<div class="body">
    <ul>
    </ul>
</div>
<div id="item" style="display: none;">
<li>
  <div class="col-xs-4">
      <p class="col01"><span style="font-size: 20px" id="customer_name"></span></p>
<!--       <p class="col02"><span id="planDate">2016.08.06</span></p> -->
  </div>
<!--   <div class="col-xs-4"> -->
<!--       <p class="col01">订货量：<span id="num">100斤</span></p> -->
<!--   </div> -->
  <div class="col-xs-6">
      <p class="col01">金额：<span id="je"></span>元</p>
      <a class="btn btn-default">查看明细</a>
  </div>
    <div class="clearfix"></div>
</li>
</div>
    </div>
<div id="findlistpage" style="display: none;">
    <div class="header2">
        搜索 <a class="pull-left closed"
              style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer"
            >取消</a> <a class="pull-right find"
                       style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer">确认</a>
    </div>
    <div class="body">
        <ul>
         <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">关键词</div>
                <div class="col-xs-8">
                    <input type="text" id="searchKey" maxlength="20" class="form-control" placeholder="输入查询关键词">
                </div>
                <div class="clearfix"></div>
            </li>
            <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">起始日期</div>
                <div class="col-xs-8">
                    <input type="date" id="d4311"
                           class="form-control Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}'})" name="beginDate">
                </div>
                <div class="clearfix"></div>
            </li>
            <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">结束日期</div>
                <div class="col-xs-8">
                    <input type="date" id="d4312" class="form-control Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01'})" name="endDate">
                </div>
                <div class="clearfix"></div>
            </li>
        </ul>
    </div>
</div>
<div id="mingxi">
</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript" src="../pc/js/gys/collect.js"></script>
</body>
</html>