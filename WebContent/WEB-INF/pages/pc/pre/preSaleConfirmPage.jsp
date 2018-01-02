<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-查看明细</title>
    <link rel="stylesheet" href="../pc/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/detailbuy.css${requestScope.ver}">
    <link rel="stylesheet" href="../pc/css/imgshow.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<div style="width: 1px;height: 1px;">
    <img class="img-responsive center" src="../pc/images/logo.jpg?ver=001">
</div>
<div class="header">
    <a  href="../pc/dealbuy.html${requestScope.ver}" class="pull-left">返回</a>${requestScope.type}确认
</div>
<div class="body"> 
    <p>2016.06.08</p>
    <div class="ul_box">
        <ul>
            <li>
                <p><span></span><img src="../pc/images/phone3.png" style="width: 17px;margin-bottom: 5px;"></p>
                <p><span></span></p>
                <p><span></span></p>
				<p><span></span></p>
				<p><span></span></p>
				<p><span class="address"></span><img src="../pc/images/site.png" style="width: 17px;margin-bottom: 5px;"></p>
                <p><a class="btn pull-left" style="background-color: #3BC299;color: #ffffff" id="showImg">查看图片</a><div class="clearfix"></div></p>
            </li> 
        </ul>
    </div>
    <div class="btn_box">
        <a class="btn pull-left" style="background-color: #3BC299;color: #ffffff" id="save">确认</a>
<!--         <a class="btn pull-left" style="background-color: #3BC299;color: #ffffff" id="showImg">查看图片</a> -->
        <button type="button" class="btn pull-right btn-danger btn_style">联系业务员</button>
        <div class="clearfix"></div>
    </div>
</div>
<div class="image-zhezhao" style="display:none">
    <div class="zhezhao_left"></div>
    <div class="img-ku" style="margin-top: 10%">
    <div id="imshow"></div>
    </div>
    <div class="zhezhao_right"></div>
    <div class="gb" onclick="$('.image-zhezhao').hide();" >
    <img src="../pc/images/closed.png" style="width:20px">
    </div>
</div>
    <div class="modal fade" id="mymodal">
    <div class="modal-dialog" style="margin: 150px auto;width: 85%">
    <div class="modal-content">
    <div class="modal-header" style="display: none">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">模态弹出窗标题</h4>
    </div>
    <div class="modal-body" style="padding: 0">
    <div class="kefu" id="kefulist" style="opacity:1;">
    <input type="hidden" id="platformsHeadship" value="业务员">
    <h3>联系业务员</h3>
    <ul>
    <li><a></a><div class="clear"></div></li>
    </ul>
    </div>
    </div>
    <div class="modal-footer" style="display: none">
    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
    <button type="button" class="btn btn-primary">保存</button>
    </div>
    </div>
    </div>
    </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/bootstrap.min.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/twysjs/detailbuy.js${requestScope.ver}"></script>
</body>
</html>