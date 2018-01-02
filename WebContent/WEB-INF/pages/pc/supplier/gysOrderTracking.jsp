<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache" >
    <meta http-equiv="Expires" content="-1" />
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>牵引O2O营销服务平台</title>
    <link rel="stylesheet" href="../../pcxy/css/product.css?ver=002">
 <%@include file="../res.jsp"%>
    <script type="text/javascript" src="../../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../../pc/js/gys/gysOrderTracking.js?ver=437708"></script>
</head>
<style>
    ul>li{
        list-style: none;
    }
    ul{
        padding-left: 0;
    }
    .lg-size>ul>li{
        padding:7px 0;
    }
    .clear{
        clear: both;
    }
    .modalcover>ul>li{
        padding: 10px 0;
    }
    @media (max-width: 770px) {
        .lg-size{
            padding: 10px 0 10px 60px;background-color: #BFD9C0;position: relative;width: 100%;margin-bottom: 35px
        }
        .modalcover{
            width: 100%;height: 100%;background-color: #E5E5E5;position: absolute;left: 0;top:0;display: none
        }
    }
    @media (min-width: 770px) {
        .modal-size{
            width:1200px;
        }
        .lg-size{
            padding: 10px 0 10px 60px;background-color: #BFD9C0;position: relative;width: 30%;float: left;margin-right: 35px;margin-bottom: 35px
        }
        .modalcover{
            width: 337px;height: 823px;background-color: #E5E5E5;position: absolute;left: 0;top:0;display: none
        }
    }
</style>
<body>
<div class="bg"></div>
<div class="header">
    <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a
                href="../employee.do">员工首页</a></li>
        <li class="active"><span
                class="glyphicon glyphicon-triangle-right"></span>采购订单跟踪</li>
    </ol>
    <div class="header-title">
        员工-采购订单 <a href="../employee.do" class="header-back"><span
            class="glyphicon glyphicon-menu-left"></span></a>
    </div>
    <div class="header-logo"></div>
</div>

<div class="container">
    <div class="ctn-fff box-ctn" style="min-height: 500px;">

        <!-- 列表区域 -->
        <div class="box-body">
            <div class="tabs-content" style="display: block;">
                <div id="item01">
                    <div class="ctn">
                        <div class="folding-btn m-t-b">
                            <button type="button" class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button>
                        </div>


                        <form id="gzform" style="clear:both;overflow:hidden;">
                            <div class="col-sm-3 col-lg-2 m-t-b">
                                <div class="form-group">
                                    <label for="">关键词</label>
                                    <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
                                </div>
                            </div>
                            <div class="col-sm-3 col-lg-2 m-t-b">
                                <div class="form-group">
                                    <label for="">订单起始日期</label>
                                    <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="beginDate">
                                </div>
                            </div>
                            <div class="col-sm-3 col-lg-2 m-t-b">
                                <div class="form-group">
                                    <label for="">结束日期</label>
                                    <input type="date" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" name="endDate">
                                </div>
                            </div>
                            <div class="col-sm-3 col-lg-2 m-t-b">
                                <div class="form-group">
                                    <label for="">状态</label>
                                    <select class="form-control input-sm" name="type">
			                            <option></option>
			                            <option value="0">待处理</option>
			                            <option value="2">已处理有货</option>
			                            <option value="3">已处理无货</option>
			                            <option value="4">已发货</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-12 m-t-b" >
                                <button type="button" class="btn btn-primary btn-sm find" style="margin-top: 10px">搜索</button>
                                <button type="button" class="btn btn-danger btn-sm excel" style="margin-top: 10px">导出</button>
                                <button type="button" class="btn btn-primary btn-sm" id="zuofei" style="margin-top: 10px">作废</button>
                            </div>
                            <input type="hidden" name="customer_id" value="">
                        </form>
                        <div class="text-center">
                            <h3>采购订单跟踪</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th><div class="pro-checkbox"></div></th>
                                    <th>供应商</th>
                                    <th>产品简称</th>
                                    <th>订单数量</th>
                                    <th>基本单位</th>
                                    <th>订货日期</th>
                                    <th>应收金额</th>
                                    <th>追溯</th>
                                    <th>状态</th>
                                    <th>订单号</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <div class="pull-right">
                            <button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
                            <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
                            <button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
                            <button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
                        </div>
                    </div>
                </div>
                <div class="ctn" style="display: none;">
                    <button class="btn btn-add" type="button">点击加载更多</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="back-top" id="scroll"></div>

<div class="footer">
    员工:${sessionScope.userInfo.personnel.clerk_name}<span
        class="glyphicon glyphicon-earphone"></span> 
</div>
<script>
    $(function(){
        $(".tb").click(function(){
            $("#mymodal").modal("toggle");
        });
        $(".btn-check").click(function(){
            $(".modalcover").toggle()
        });
        $(".gb").click(function(){
            $(".modalcover").hide()
        });
        $('.modalcover>ul>li').click(function(){
            $('.modalcover>ul>li').css({border: '2px solid #D2D2D2'})
            $(this).css({border: '2px solid #000000'})
        })
    });
</script>
</body>
</html>