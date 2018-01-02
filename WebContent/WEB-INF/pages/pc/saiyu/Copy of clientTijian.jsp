<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>客户维护</title> 
<%@include file="../res.jsp" %>
<script src="../js/o2od.js"></script>   
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
 <script type="text/javascript" src="../js/o2otree.js?ver=${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/tijianList.js${requestScope.ver}"></script>
</head>
<body>
<div id="listpage">
	<div class="header">
		<ol class="breadcrumb">
		  <li><a href="../employee.do">员工首页</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户体检表</li>
		</ol>
	</div>
    <%@include file="../employee/selClient.jsp" %>
        <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
<!--           客户信息 -->
          <%@include file="../employee/showSelectClient.jsp" %>
        </div> 
      </div>
    </div>
<div class="container">
	<div class="ctn-fff box-ctn" style="margin-bottom: 30px;">
		<div class="box-head"><h4 class="pull-left">客户体检列表</h4>
				<div class="side-cover"></div>
	<div id="finding">
	<div class="form">
		<form id="findForm">
			<div class="col-sm-4 col-lg-3 m-t-b">
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control input-sm" maxlength="50"
							placeholder="请输入搜索关键词" id="searchKey"> <span
							class="input-group-btn">
							<button class="btn btn-success btn-sm find" type="button">搜索</button>
						</span>
					</div>
				</div>
			</div>
			<input type="hidden" id="page" name="page" value="0">
			<input type="hidden" id="totalPage" value="0">
		</form>
	</div>
</div>
		<a id="addTijian" class="btn btn-success btn-sm m-t-b">增加</a>
		<c:if test="${requestScope.auth.excelImp!=null}">
		<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
	    <input type="file" id="xlstijian" name="xlstijian" onchange="excelImport(this,'tijian');"></a>
		<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入图片
	    <input type="file" id="tijianimg" name="tijianimg" onchange="imgImport(this,'tijianimg');"></a>
		</c:if>
		<c:if test="${requestScope.auth.excel!=null}">
	    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('tijian');">导出</button>
	    </c:if>
  		</div>
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200">操作</th>
					       <th width="200">位置大类</th>  
					       <th width="200">位置小类</th> 
					       <th width="200">原配产品品牌</th>
					       <th width="200">原配产品名称</th>  
					       <th width="200">原配产品规格</th>
					       <th width="200">原配产品颜色</th>  
					       <th width="200">原配产品数量(套)</th> 
					       <th width="200">备注</th>
					       <th width="200">外编码</th>
					       <th width="200">内编码</th>
					    </tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="box-footer">
			<div class="pull-right">
			<input type="text" id="page" value="0" style="width: 50px;">
			总页数<span id="totalPage">${requestScope.pages.totalPage}</span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>
		</div>	
		<div class="row" style="margin-top: 70px">
               <div class="col-lg-4">
                   <h4 class="text-center">位置大类</h4>
                   <img class="center-block" alt="" src="../pcxy/image/upload-img.png" style="width: 200px;height: 300px;">
               </div>
               <div class="col-lg-4">
                   <h4 class="text-center">位置小类</h4>
                   <img class="center-block" alt="" src="../pcxy/image/upload-img.png" style="width: 200px;height: 300px;">
               </div>
               <div class="col-lg-4">
                   <h4 class="text-center">原配产品</h4>
                   <img class="center-block" alt="" src="../pcxy/image/upload-img.png" style="width: 200px;height: 300px;">
               </div>
            </div>
	</div>
</div>
<%@include file="../footer.jsp" %>
</div>
<div id="editpage"></div>
</body>

</html>