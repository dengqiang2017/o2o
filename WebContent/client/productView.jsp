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
<head>
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="产品浏览记录报表">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="../jqChart/css/jquery.jqChart.css">
    <link rel="stylesheet" href="../jqChart/css/jquery.jqRangeSlider.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<!--     <script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>  -->
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../jqChart/js/jquery.jqChart.min.js"></script>
    <script type="text/javascript" src="../jqChart/js/jquery.jqRangeSlider.min.js"></script>
    <script type="text/javascript" src="../js_chart/commReport.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="js/productView.js${requestScope.ver}"></script>
    <style type="text/css">
         body{background-color: #ffffff;}
         .box{display: box;display: -webkit-box;display: -moz-box;}
         .box-pack{box-pack:justify;-webkit-box-pack:justify;-moz-box-pack:justify;}
         .box-align{box-align:center;-webkit-box-align:center;-moz-box-align:center;}
         .box-flex1{-moz-box-flex:1;-webkit-box-flex:1;box-flex:1;}
         .marginright{margin-right: 10px;}
         .seciton{margin-top: 30px;}
         .top{padding: 10px;background-color:#f4faff;  box-shadow: 0 0 5px rgba(0,0,0,0.3);overflow: hidden;border-radius: 3px;margin: 30px auto}
         .bottom{padding: 10px;background-color:#f4faff;  box-shadow: 0 0 5px rgba(0,0,0,0.3);overflow: hidden;border-radius: 3px;}
         .nav{border-bottom: 1px solid #ddd}
         .nav>li{float: left}
         .nav>.active>a{color: #555;cursor: default;background-color: #fff;border: 1px solid #ddd;border-bottom-color: transparent;}
         .nav>li>a{margin-right: 2px;line-height: 1.42857143;border: 1px solid transparent;border-radius: 4px 4px 0 0;padding: 5px 8px;}
         .copyright{text-align: center;margin: 10px auto}
         .header{padding: 20px 10px;font-size: 25px;border-bottom: 1px solid #dddddd;z-index: 999;background-color: #FFFFFF}
         @media (max-width: 769px) {
             .header {
                 font-size: 20px
             }
         }
     </style>
</head>
<body>
<div class="header">
    <div class="header-left" style="font-size: 16px">
        <a href="../employee.do">${sessionScope.indexName}</a>&gt;<span>${requestScope.pageName}</span>
    </div>
</div>
<div class="container">
    <div class="top">
<div class="seciton box">
<div class="box-flex1 marginright">
    <label>关键词</label>
    <input type="text" maxlength="30" id="searchKey" placeholder="请输入关键词" class="form-control input-sm">
</div>

<div class="box-flex1 marginright">
		<div class="form-group">
			<label for="">起始日期</label> <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate">
		</div>
	</div>
	<div class="box-flex1 marginright">
		<div class="form-group">
			<label for="">结束日期</label> <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
		</div>
	</div>
</div>
    <div class="search">
        <button type="button" class="btn btn-primary btn-sm find"
                style="margin-top: 25px;">搜索</button>
    </div>
    </div>
    <div class="bottom">
    <div class="bottom-header">
<ul class="nav">
<li class="active"><a>汇总记录</a></li>
<li><a>汇总图表</a></li>
<li>
    <a>明细记录</a>
</li>
</ul>
 </div>
 <div class="bottom-body">
 <div class="tabs-content">
<table class="table table-bordered">
<thead>
<tr>
<th data-name="item_sim_name">产品名称</th>
<th data-name="num">访问数量</th>
</tr>
</thead>
<tbody></tbody>
</table>
</div>
<div class="tabs-content">
<div id="jqChart" style="width: 80%; height: 500px;margin: auto;margin-top: 30px">
</div> 
<div id="jqChart_pre" style="width: 80%; height: 500px;margin: auto;margin-top: 30px">
</div> 
<div id="jqChart_zhu" style="width: 80%; height: 500px;margin: auto;margin-top: 30px">
</div> 
</div>
<div class="tabs-content">
<table class="table table-bordered">
<thead>
<tr>
<th data-name="item_sim_name">产品名称</th>
<th data-name="view_time">访问时间</th>
<th data-name="corp_sim_name">访问客户</th>
<th data-name="view_address">地址</th>
<!-- <th data-name="view_ip">IP地址</th> -->
</tr>
</thead>
<tbody></tbody>
</table>
<button type="button" class="nextPage btn btn-info center-block" style="display: none;">下一页</button>
</div>
</div>
</div>
</div>
</body>
</html>