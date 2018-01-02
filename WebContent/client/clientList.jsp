<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
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
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="客户列表">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/sort.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
	<div class="bgT"></div>
	<div class="container" style="margin-bottom: 20px">
		<div class="secition">
		<div class="secition-top" style="margin-bottom: 20px;font-size: 16px;float: left;">
                 <a href="../employee.do">${sessionScope.indexName}</a>&gt;
                 <span>${requestScope.pageName}</span>
             </div>
			<div class="secition_header clearfix">
				<div class="pull-right clearfix">
					<div class="input-group">
						<div class="input-group-addon">
							<i class="fa fa-search" aria-hidden="true" style="color: #9D9D9D"></i>
						</div>
						<input class="form-control" type="text" id="searchKey"
							placeholder="请输入客户名称关键词" maxlength="20">
					</div>
				</div>
			</div>
			<div class="secition_body"></div>
			<div id="item" style="display: none;">
				<div class="body_box">
					<div class="secition_body_title"></div>
					<div class="secition_body_list">
						<ul></ul>
					</div>
				</div>
			</div>
			<div class="location">
				<ul>
					<li style="display: none;">1</li>
					<li>A</li>
					<li>B</li>
					<li>C</li>
					<li>D</li>
					<li>E</li>
					<li>F</li>
					<li>G</li>
					<li>H</li>
					<li>I</li>
					<li>J</li>
					<li>K</li>
					<li>L</li>
					<li>M</li>
					<li>N</li>
					<li>O</li>
					<li>P</li>
					<li>Q</li>
					<li>R</li>
					<li>S</li>
					<li>T</li>
					<li>U</li>
					<li>V</li>
					<li>W</li>
					<li>X</li>
					<li>Y</li>
					<li>Z</li>
				</ul>
			</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/clientList.js${requestScope.ver}"></script>
</body>
</html>