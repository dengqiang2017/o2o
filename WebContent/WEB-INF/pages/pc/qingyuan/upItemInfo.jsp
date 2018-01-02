<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>供应商上报产品信息确认</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/verify.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
    <script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/gys/upItemInfo.js${requestScope.ver}"></script>
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
<div class="header">
    <a href="../employee.do" class="pull-left">返回</a>
    供应商上报产品信息确认
</div>
<div class="body">
    <ul>
        <li>
            <div class="box">
                <div class="box01">
                    <span style="font-weight: bold;font-size: 20px;margin-right: 10px" id="item_name">青菜</span>
                </div>
                <div class="box02">
                    <div class="pull-left" style="width: 97px;position: relative">
                        <img class="img-responsive" src="../pc/images/addimg.png" onerror="this.src='../pc/images/addimg.png'">
                    </div>
                    <div class="pull-right" style="width: 198px">
                        <div class="blue">
                            <div class="blue_left">
                                库存
                            </div>
                            <div class="blue_center">
                                <span id="num">30</span>
                            </div>
                            <div class="blue_right item_unit"></div>
                            <div class="clearfix"></div>
                        </div>
                        <div class="blue" style="margin-top: 10px">
                            <div class="blue_left">
                                单价
                            </div>
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
                    <div class="col-xs-4">
                        <button class="btn btn-success center-block">通过</button>
                    </div>
                    <div class="col-xs-4">
                        <button class="btn btn-success center-block">不通过</button>
                    </div>
                    <div class="col-xs-4">
                        <button class="btn btn-success center-block">修改单价</button>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <div class="date_box">
                    <span>2016.08.06</span>
                </div>
            </div>
        </li>
    </ul>
</div>
<div class="modal fade" id="mymodal">
            <img src="" class="center-block">
</div>
</body>
</html>