<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
 	<%@include file="../res.jsp" %>
    <link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
 	<style type="text/css">
 	.tabs-content{margin-bottom: 30px;}
 	</style>
</head>
<body>
	<div class="bg"></div>
	
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
      </ol>
      <div class="header-title">${requestScope.pageName}
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
          	<ul class="nav nav-tabs" style="margin-top:10px;">
            	<li class="active"><a>根据销售订单下生产计划</a></li>
            	<li><a>直接下生产计划</a></li>
            	<li><a>已下计划</a></li>
          	</ul>
        </div>
        <div class="box-body">
            <%@include file="planlist.jsp" %>       
         	<div class="tabs-content">
         	<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">输入关键词</label>
                		<div class="input-group">
                  			<input type="text" class="form-control input-sm" id="searchKey" maxlength="40">
                  			<span class="input-group-btn">
                    			<button class="btn btn-success btn-sm find" type="button">搜索</button>
                  			</span>
                		</div>
              		</div>
            	</div>
          	</div>
         	<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">预计交货日期</label>
                		<input type="text" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" name="plan_end_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">备注</label>
                		<input type="text" class="form-control input-sm" id="c_memoMain" maxlength="50">
              		</div>
            	</div>
          	</div>
            	<div class="ctn" id="list">

            	
            	</div>
            	<div class="ctn" style="display: none;"> 
            		<button class="btn btn-add" type="button">点击加载更多</button>
         		</div>
          	</div>
         	<div class="tabs-content">
         	<div class="ctn">
         	<div class="pull-left">
				<div class="form-group">
				<label>类别</label>
				<select id="sort_name" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
				</div>
			</div>
			 <div class="pull-left">
				<div class="form-group">
				<label>物料来源</label>
				<select id="item_style" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
				</div>
			</div>
			<div class="pull-left">
				<div class="form-group">
				<label>品牌</label>
				<select id="class_card" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
				</div>
			</div>
			<div class="pull-left">
				<div class="form-group">
				<label>质量等级</label>
				<select id="quality_class" class="form-control input-sm" style="display: inline-block;width: auto;">
				</select>
				</div>
			</div>
			<div class="pull-left">
				<div class="form-group">
				<label>规格</label>
				<input type="text" id="item_spec" class="form-control input-sm" maxlength="30" style="display: inline-block;width: auto;">
				</div>
			</div>
            	<div class="pull-left">
              		<div class="form-group">
                		<div class="input-group">
                  			<input type="text" class="form-control input-sm" id="searchKey"
                  			placeholder="输入关键词"
                  			 maxlength="40" style="display: inline-block;width: auto;">
                  			<span class="input-group-btn">
                    			<button class="btn btn-success btn-sm find" type="button">搜索</button>
                  			</span>
                		</div>
              		</div>
            	</div><div class="clearfix"></div>
          	</div>
         	<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">预计交货日期</label>
                		<input type="text" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" name="plan_end_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">备注</label>
                		<input type="text" class="form-control input-sm" id="c_memoMain" maxlength="50">
              		</div>
            	</div>
          	</div>
            	<div class="ctn" id="list"></div>
            	<div class="ctn" style="display: none;"> 
            		<button class="btn btn-add" type="button">点击加载更多</button>
         		</div>
          	</div>
          	<div class="tabs-content">
          	         	<div class="ctn">
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">计划开始日期</label>
                		<input type="date" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'planned_delivery_date\')||\'2020-10-01\'}'})" id="store_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">计划结束日期</label>
                		<input type="text" class="form-control input-sm Wdate"
                		 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'store_date\')}',maxDate:'2020-10-01'})" id="planned_delivery_date">
              		</div>
            	</div>
            	<div class="col-sm-4 col-lg-3 m-t-b">
              		<div class="form-group">
                		<label for="">输入关键词</label>
                		<div class="input-group">
                  			<input type="text" class="form-control input-sm" id="searchKey" maxlength="40">
                  			<span class="input-group-btn">
                    			<button class="btn btn-success btn-sm find" type="button">搜索</button>
                  			</span>
                		</div>
              		</div>
            	</div>
          	</div> 
            	<div class="ctn">
              		<button type="button" class="btn btn-danger delete">删除</button>
            	</div>
            	<div class="ctn" id="list"></div> 
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
   		<span style="display: none;" id='com_id'>${sessionScope.userInfo.com_id}</span>
      	<div class="btn-gp">
        	<label><input type="checkbox" id="allcheck" style="width: 20px;height: 20px;">全选</label>
        	<button class="btn btn-info" id="save" disabled="disabled">提交</button>
        	<a href="../employee.do" class="btn btn-primary">返回</a>
      	</div>
    </div>
  	<script src="../js/o2od.js${requestScope.ver}"></script>
 	<script src="../js/o2otree.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../pc/pmjs/productionPlan.js${requestScope.ver}"></script>
 	<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
 </body>
</html>