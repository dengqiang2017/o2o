<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>供应商上报产品信息确认列表</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/verify.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="../pc/css/query.css${requestScope.ver}">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/gys/upItemInfoList.js${requestScope.ver}"></script>
    <style type="text/css">
@media screen and (min-width: 768px){
#mymodal img{
    height: 96%;
    margin-top: 4%;
    width: auto;
    }
}
@media screen and (max-width: 768px){
    #mymodal img{
    margin-top: 10%;width: 100%;height: 80%;
    }
}
    
</style>
</head>
<body>
<div id="listpage">
<div class="header">
    <a href="../employee.do" class="pull-left">返回</a>
    供应商上报产品信息确认
    <a class="pull-right check">
        <img src="../pc/images/search2.png" style="width: 30px;">
    </a>
</div>
<div class="body">
    <ul>
        <li>
            <div class="box">
                <div class="box01">
                    <span style="font-weight: bold;font-size: 20px;margin-right: 10px" id="item_name"></span>
                </div>
                <div class="box02">
                    <div class="pull-left" style="width: 97px;position: relative">
                        <img class="img-responsive" src="../pc/images/addimg.png" onerror="this.src='../pc/images/addimg.png'">
                    </div>
                    <div class="pull-right" style="width: 198px">
                        <div class="blue">
                            <div class="blue_left">库存</div>
                            <div class="blue_center">
                                <span id="num">30</span>
                            </div>
                            <div class="blue_right item_unit"></div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="blue" style="margin-top: 10px">
                            <div class="blue_left">单价</div>
                            <div class="blue_center">
                                <span id="price">50</span>
                            </div>
                            <div class="blue_right">元/<span class="item_unit" style="color: #ffffff"></span></div>
                            <div class="clearfix"></div>
                        </div>
                    </div>
                    <!--<a class="btn btn_a">确认并上传</a>-->
                    <div class="clearfix"></div>
                </div>
                <div class="btn_box">
                    <div class="col-xs-3">
                        <button class="btn btn-success center-block">通过</button>
                    </div>
                    <div class="col-xs-3">
                        <button class="btn btn-success center-block">不通过</button>
                    </div>
                    <div class="col-xs-3">
                        <button class="btn btn-success center-block">修改单价</button>
                    </div>
                    <div class="col-xs-3">
                        <button class="btn btn-success center-block" onclick="$(this).parents('li').remove();">隐藏</button>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="date_box">
                    <span></span>
                </div>
            </div>
        </li>
    </ul>
</div>
</div>
<div class="modal fade" id="mymodal">
            <img src="" class="center-block">
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
            <li style="display: none;">
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

</body>
</html>