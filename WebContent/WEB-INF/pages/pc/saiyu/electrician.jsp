<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>电工维护</title> 
<%@include file="../pcxy_res.jsp" %>
<link rel="stylesheet" type="text/css" href="../pc/css/dianEdit.css">
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
<script type="text/javascript" src="../pc/js/weixin/weixininvite.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/dian.js${requestScope.ver}"></script>
</head>
<body>
<div id="listpage">
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><a href="../employee.do">员工首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>电工维护</li>
	</ol>
	<div class="header-title">
	员工首页-电工维护<a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
	</div>
</div>

<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-6 col-xs-6 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
	  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  		</div>
		</div> 
	</form>
</div>
<div class="cover"></div>
<div class="container">
<input type="hidden" id="del_hi" value="${requestScope.auth.del_maintenance!=null}">
<input type="hidden" id="edit_hi" value="${requestScope.auth.edit_maintenance!=null}">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head"><h4 class="pull-left">电工列表</h4>
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
			<a id="electricianEdit" class="btn btn-success btn-sm m-t-b">增加</a>
<!-- 			<button type="button" onclick="weixininvitemore(3,4);" class="btn btn-success btn-sm m-t-b">邀请列表中电工关注</button> -->
<!-- 			<button type="button" onclick="employeeToWeixin('dian');" class="btn btn-success btn-sm m-t-b">备份数据到微信</button> -->
			<c:if test="${requestScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
		    <input type="file" id="xlsdian" name="xlsdian" onchange="excelImport(this,'dian');"></a>
			</c:if>
			<c:if test="${requestScope.auth.excel!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('dian')">导出</button>
		    </c:if>
		    <c:if test="${sessionScope.auth.edit_maintenance!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b" onclick="editUtils.updateWeixinState('drive');">更新司机微信状态</button>
		    </c:if>
  		</div>
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">操作</th>
					        <%@include file="../manager/list.jsp" %>
<!-- 					       <th width="200" data-name="corp_sim_name">电工姓名</th> -->
<!-- 					       <th width="200" data-name="tel_no">电话号码</th>  -->
<!-- 					       <th width="200" data-name="weixinID">微信账号</th> -->
<!-- 					       <th width="200" data-name="weixinStatus">微信操作</th> -->
<!-- 					       <th width="200" data-name="corp_working_lisence">电工职称</th> -->
<!-- 					       <th width="200" data-name="license_type">证件类型</th> -->
<!-- 					       <th width="200" data-name="regionalism_name_cn">行政区划</th> -->
<!-- 					       <th width="200" data-name="working_status">工作状态</th> -->
<!-- 					       <th width="200" data-name="self_id">电工外码</th> -->
<!-- 					       <th width="200" data-name="customer_id">电工内码</th> -->
					    </tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="box-footer">
			<div class="form-inline">
				<div class="form-group pull-left">
				   <label>总共:</label>
				    <span id="totalRecord"></span>
				</div>
			</div>
			<div class="pull-right">
			当前页<input type="tel" id="page" value="0" data-number="num" style="width: 50px;">
			总页数<span id="totalPage"></span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>	
		</div>	
	</div>
</div>
<%@include file="../footer.jsp" %>
</div>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/manager/dianEdit.js${requestScope.ver}"></script>
<div id="editpage"></div>
</body>

</html>