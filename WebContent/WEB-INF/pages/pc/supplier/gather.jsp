<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>青清源供应商-产品汇总</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/gather.css">
    <link rel="stylesheet" href="../pc/css/query.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
</head>
<body>
<div id="listpage">
<div class="header">
    <a class="pull-left">返回</a>
    产品汇总
    <a class="pull-right check">
        <img src="../pc/images/search2.png">
    </a>
</div>
<span id="rows" style="display: none;">1000</span>
<div class="body">
    <div class="body_cut">
        <div class="cut_box center-block">
            <ul>
                <li class="active">按车号排序</li>
                <li>按产品排序</li>
            </ul>
            <div class="clearfix"></div>
        </div>
    </div><span id="adress_id" style="display: none"></span>
    </div><span id="item_id" style="display: none"></span>
    <div class="body_table table-responsive">
        <table class="table table-bordered">
            <thead>
                 <tr>
                     <th data-name="customer_name">车号</th>
                     <th data-name="item_name">产品名称</th>
                     <th data-name="hav_rcv">数量</th>
                     <th data-name="item_unit">单位</th>
                     <th data-name="price">采购价（元）</th>
                     <th data-name="je">金额</th>
                 </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
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
<script src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript" src="../pc/js/gys/gather.js"></script>
</body>
</html>