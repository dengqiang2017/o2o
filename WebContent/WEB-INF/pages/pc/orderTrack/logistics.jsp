<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>O2O运营及服务平台</title>
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.min.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <link rel="stylesheet" href="../pc/css/wsxi.css">
     <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
     <script type="text/javascript" src="../pc/js/orderTrack/logistics.js${requestScope.ver}"></script>
</head>
     <style>
       .header>a:hover{
    text-decoration: none;
    }
    </style>
<body style="padding-top:0">
    <div class="header" style="position:relative">
    <a class="glyphicon glyphicon-menu-left" style="position:absolute;left:12px;top:25px;color:#FFFFFF" onclick="javascript:history.go(-1);"></a>
    完善车牌及司机信息
    </div>
    <div class="container" style="margin-top: 35px">
        <div class="wsxx">
            <div style="margin-bottom:5px;" class="form-group">
                <label class="col-lg-2 text-right" style="line-height: 30px;padding-left: 0">司机姓名</label>
                <div class="col-lg-10" style="line-height: 30px;padding-left: 0">
                    <input type="text" class="form-control" maxlength="20" id="driveName">
                </div>
                <div class="clear"></div>
            </div>
            <div style="margin-bottom:5px;" class="form-group">
                <label class="col-lg-2 text-right" style="line-height: 30px;padding-left: 0">司机号码</label>
                <div class="col-lg-10" style="line-height: 30px;padding-left: 0">
                    <input type="tel" class="form-control"  maxlength="11" id="drivePhone" data-num="num">
                </div>
                <div class="clear"></div>
            </div>
            <div style="margin-bottom:5px;" class="form-group">
                <label class="col-lg-2 text-right" style="line-height: 30px;padding-left: 0">车牌号</label>
                <div class="col-lg-10" style="line-height: 30px;padding-left: 0">
                    <input type="text" class="form-control" maxlength="10" id="Kar_paizhao">
                </div>
                <div class="clear"></div>
            </div>
            <div style="margin-bottom:5px;" class="form-group">
                <label class="col-lg-2 text-right" style="line-height: 30px;padding-left: 0">物流方式</label>
                <div class="col-lg-10" style="line-height: 30px;padding-left: 0">
                    <select class="form-control"  id="wuliuname" disabled="disabled">
									<option value="0-1" selected="selected">公司配送</option>
									<option value="0-2">客户自提</option>
									<option value="0-3">第三方物流配送</option>
									<option value="1-1">公司配送</option>
									<option value="1-2">客户自提</option>
									<option value="1-3">第三方物流配送</option>
									<option value="1-4">公司配送</option>
								</select>
                </div>
                <div class="clear"></div>
            </div>
                    <div style="margin-bottom:5px;" class="form-group">
                        <label class="col-lg-2 text-right" style="line-height: 30px;padding-left: 0">预计提货时间</label>
                        <div class="col-lg-10" style="line-height: 30px;padding-left: 0">
                            <input type="date" class="form-control Wdate" id="tihuoDate" maxlength="23" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true})">
                        </div>
                        <div class="clear"></div>
                    </div>
            <div class="clear"></div>
        </div>
        <button type="button" class="btn btn-primary xs center-block" style="margin-bottom: 10px;margin-top: 10px">查看明细</button>

        <div class="seciton"> 
        </div>
        <div id="item" style="display: none;">
        <div class="secition01 col-xs-12 col-lg-4" style="padding-left: 0">
               <ul style="border:1px solid #ddd">
                        <li>订单编号：<span></span></li>
                        <li>客户姓名：<span></span></li>
                        <li>提货地点：<span></span> </li>
                        <li>产品名称：<span></span></li>
                        <li>规格：<span></span></li>
                        <li>型号：<span></span></li>
                        <li>数量：<span></span><span></span></li>
                        <div style="clear:both"></div>
                    </ul>
            </div>
        </div>
        <button type="button" class="btn btn-danger center-block" id="qrlah" style="margin-bottom: 10px;margin-top: 10px">确认拉货</button>
    </div>

</body>
</html>