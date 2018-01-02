<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
 	<%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
 	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
 	<script type="text/javascript" src="../pc/js/pm/productionPlan1.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>生产计划</li>
      </ol>
      <div class="header-title">生产计划
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
        	<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">生产计划单号</label>
                		<input type="text" class="form-control input-sm" id="sd_order_id">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">批次号</label>
                		<input type="text" class="form-control input-sm" id="batch_mark">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">计划日期</label>
                		<input type="date" id="d4311" class="form-control input-sm Wdate" 
                			onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="send_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">计划交货日期</label>
                		<input type="date" id="d4312" class="form-control input-sm Wdate"
							onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="plan_end_date">
              		</div>
            	</div>
          	</div>
          
          	<ul class="nav nav-tabs" style="margin-top:10px;">
            	<li class="active"><a>下计划</a></li>
            	<li><a>已下计划</a></li>
          	</ul>
          
          	<div class="form filter">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">输入关键词</label>
                		<div class="input-group">
                  			<input type="text" class="form-control input-sm" id="searchKey" maxlength="40">
                  			<span class="input-group-btn">
                    			<button class="btn btn-success btn-sm find" type="button">搜索</button>
                    			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">产品
								<input type="file" id="xlsproductionPlanSheet" name="xlsproductionPlanSheet" onchange="excelImport(this,'productionPlanSheet');"></a>
								<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">材料
								<input type="file" id="xlsmaterialproductionPlanSheet" name="xlsmaterialproductionPlanSheet" onchange="excelImport(this,'materialproductionPlanSheet');"></a>
								<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('productionPlan');">导出</button>
                  			</span>
                		</div>
              		</div>
            	</div>
          	</div>
        </div>

        <div class="box-body">
         	<div class="tabs-content">
         		<div class="ctn">
            		<%@include file="planlist.jsp" %>         
            	</div>
            	<div class="ctn" style="display: none;"> 
            		<button class="btn btn-add" type="button">点击加载更多</button>
         		</div>
          	</div>
          	<div class="tabs-content">
            	<div class="ctn">
              		<button type="button" class="btn btn-danger delete">删除</button>
            	</div>
            	<div class="ctn">
            		<div class="col-sm-6" id="item01"></div>
					<div class="col-sm-6" id="item02"></div>  
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
   		员工:${sessionScope.userInfo.personnel.clerk_name}
      	<div class="btn-gp">
        	<button class="btn btn-info" id="allcheck" disabled="disabled">全选</button>
        	<button class="btn btn-info" id="save" disabled="disabled">提交</button>
        	<a href="../employee.do" class="btn btn-primary">返回</a>
      	</div>
    </div>
    <div style="display:none;">
		<span class="sd_order_id">${requestScope.parameters.sd_order_id}</span>
		<span class="ivt_oper_listing">${requestScope.parameters.sd_order_id}</span>
	</div>
 </body>
</html>