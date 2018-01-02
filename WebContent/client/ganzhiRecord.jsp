<%@page import="com.qianying.controller.BaseController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="客户感知记录查询">
    <meta name="keywords" content="客户感知,查询">
    <title>${requestScope.pageName}-${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link href="../css/popUpBox.css${requestScope.ver}">
    <style type="text/css">
        /*-----conmment-----*/
        *{font-family:'Microsoft YaHei',Arial,Helvetica,sans-serif;font-size: 18px;color: #000000;padding: 0;margin: 0}
        a{text-decoration: none}
        a:hover{text-decoration: none}
        ul{margin-bottom: 0}
        ul>li{list-style: none}
        body{padding-top: 0 !important;padding-bottom: 0 !important;}
        .bgT{background-color: #017AA5;position: fixed;left: 0;top: 0;right: 0;bottom: 0;z-index: -1}

        .header{text-align: center;padding: 20px 0;font-size: 25px;border-bottom: 1px solid #dddddd;z-index: 999;background-color: #FFFFFF}
        .time_box{padding: 10px 0;border-bottom: 1px solid #dddddd}
        .input-group{width: 250px}
        .contant_grid_header{padding:10px;background-color: #46B692;display:-moz-box;display:-webkit-box;display:box;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;}
        .left i{color: #ffffff;font-size: 30px;}
        .right{color: #ffffff;text-align: right;}
        .right span{display: block;color: #ffffff;font-size: 30px;}
        .contant_list{border: 1px solid #dddddd;border-top:none;height: 300px;overflow-y: scroll}
        .contant_list li{padding:10px;display:-moz-box;display:-webkit-box;display:box;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;}
        .contant_list li:not(:last-child){border-bottom: 1px solid #dddddd;}
        .secition{width: 80%;margin: auto}
        .contant{margin-top: 20px}
        .time_box label{font-size: 15px}
        .glyphicon{color: #337ab7;}
    </style>
</head>
<body>
    <div class="container">
	    <div class="header">
	    	<div class="pull-left">
	           <a href="../employee.do">${sessionScope.indexName}</a>&gt;
	           <span>${requestScope.pageName}</span>
	    	</div>
	    </div>
        <div class="time_box clearfix">
            <div class="col-md-3 col-sm-3">
                <div class="form-group">
                    <label for="">起始日期</label>
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-list-alt" aria-hidden="true"></i>
                        </div>
                        <input type="date" id="d4311" style="width: 80%"
    class="form-control input-sm Wdate"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}',isShowClear:false,onpicked:loadData})" name="beginDate">
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-3">
                <div class="form-group">
                    <label for="">结束日期</label>
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-list-alt" aria-hidden="true"></i>
                        </div>
                        <input type="date" id="d4312" class="form-control input-sm Wdate" style="width: 80%"
    onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01',isShowClear:false,onpicked:loadData})" name="endDate">
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-sm-6">
                <div class="form-group">
                    <label for="">关键词</label>
                <div class="input-group">
                    <div class="input-group-addon">
                        <i class="fa fa-search" aria-hidden="true"></i>
                    </div>
                    <input class="form-control" type="text" id="searchKey" style="float: left;" placeholder="请输入产品关键词" maxlength="20">
                    <div class="input-group-addon find" style="cursor: pointer;">搜索</div>
                </div>
                </div>
            </div> 
            </div>
        <div class="contant clearfix">
        <div class="panel panel-default">
  <!-- Default panel contents -->
  <div class="panel-heading">阅读记录</div>
  <div class="panel-body" style="overflow: auto;">
  <table class="table table-striped table-condensed" style="overflow: auto;">
    <thead>
    <tr>
    <th data-name="xuhao">序号</th>
    <th data-name="article_name">文章标题</th>
    <th data-name="readTime">开始阅读时间</th>
    <th data-name="endTime">结束时间</th>
    <th data-name="corp_name">客户名称</th>
    <th data-name="clerk_name">发送人</th>
    </tr>
    </thead>
    <tbody></tbody>
  </table>
  <nav aria-label="分页">
  <div style="float: left;" id="page">
  第1页/共3页
  </div>
  <ul class="pager" style="cursor: pointer;">
    <li><a><span class="glyphicon glyphicon-step-backward"></span>首页</a></li>
    <li><a><span class="glyphicon glyphicon-backward"></span>上一页</a></li>
    <li><a>下一页<span class="glyphicon glyphicon-forward"></span></a></li>
    <li><a>末页<span class="glyphicon glyphicon-step-forward"></span></a></li>
  </ul>
</nav>
  </div>
  <!-- Table -->
</div>
</div>
        </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/ganzhiRecord.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/page.js${requestScope.ver}"></script>
</body>
</html>