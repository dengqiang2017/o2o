<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate"> 
<meta http-equiv="expires" content="0">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="renderer" content="webkit">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/function.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/write-table.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>

<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="container" style="margin-bottom: 50px;">
        <%@include file="find.jsp" %>
          <div class="ctn">
          <a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
              <input type="file" id="xlsware" name="xlsware" onchange="excelImport(this,'ware');"></a>
          <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('ware');">导出</button>
          </div>
        <div class="box-body"> 
            <!-- 库存初始化-->
            <div class="tabs-content">
                <div class="write-table">
                    <ul class="table-head">
                        <li style="width: 15%;" data-name="store_structName">仓位名称</li>
                        <li style="width: 15%;" data-name="item_sim_name">产品名称</li>
                        <li style="width: 10%;" data-name="item_spec">规格</li>
                        <li style="width: 15%;" data-name="item_color">颜色</li>
                        <li style="width: 15%;" data-name="item_type">型号</li>
                        <li style="width: 5%;" data-name="item_unit">单位</li>
                        <li style="width: 5%;" data-name="use_oq">总数量</li>
                        <li style="width: 7%;" data-name="item_id">产品编码</li>
                        <li style="width: 13%;" data-name="store_struct_id">仓位编码</li>
<!--                         <li style="width: 10%;" data-name="casing_unit">包装单位</li> -->
<!--                         <li style="width: 10%;" data-name="">成本价</li> -->
<!--                         <li style="width: 10%;" data-name="">零售价</li> -->
<!--                         <li style="width: 10%;" data-name="">库存金额</li> -->
<!--                         <li style="width: 8%;" data-name="">负责部门</li> -->
<!--                         <li class='last' style="width: 8%;" data-name="">负责人</li> -->
                    </ul> 
                    <div id="tableBody">

                    </div>
                    <div class="btn-group">
						<!--<input type="text" id="page" value="0" data-number="num" style="width: 50px;">-->
						<span style="width: 200px;height: 20px;text-align: center;line-height: 20px;float:left;margin-top:6px" id="page">当前页:0</span>
					    <input type="hidden" value="" id="totalPage">
					    <button id="beginpage" class="btn btn-info btn-sm" type="button">首页</button>
					    <button id="uppage" class="btn btn-info btn-sm" type="button">上一页</button>
					    <button id="nextpage" class="btn btn-info btn-sm" type="button">下一页</button>
					    <button id="endpage" class="btn btn-info btn-sm" type="button">末页</button>
					</div>
                </div>
            </div>
        </div>
    </div>
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
    <script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script> 
    <script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script> 
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/employee/ware.js${requestScope.ver}"></script>
</body>
</html>