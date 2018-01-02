<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>供应商-首页</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/supplier-index.css">
</head>
<body>
<div class="header">
    <a href="../login/exitLogin.do?type=2"  class="pull-left">返回</a>
    首页
</div>
<div class="body">
    <div class="row">
        <div class="col-xs-6">
            <a class="box center-block btn" href="uploading.do">
                上报
                价格
            </a>
        </div>
        <div class="col-xs-6">
            <a class="box center-block btn" href="detail.do">
            产品
            明细
                </a>
        </div>
    </div>
    <div class="row" style="margin-top: 20px">
        <div class="col-xs-6">
            <a class="box center-block btn" href="collect.do">
                车号
                明细
            </a>
        </div>
        <div class="col-xs-6">
            <a class="box center-block btn" href="gather.do">
            产品
            汇总
                </a>
        </div>
    </div>
</div>
<script src="../js_lib/jquery.11.js"></script>
<script>
     $('.box').click(function(){
         $('.box').css({'color':'color: #3ABB92;'})
     });
</script>
</body>
</html>