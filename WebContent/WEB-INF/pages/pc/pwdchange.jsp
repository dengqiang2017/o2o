<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/function.css${requestScope.ver}">
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.md5.js"></script>
<script src="../pc/js/pwchange.js${requestScope.ver}"></script>
</head>
<body>
	<div class="bg"></div>
	<%@include file="header.jsp"%>
	<div class="container">
      <div class="ctn-fff box-ctn" style="min-height:800px;">
		<div class="box-head">
			修改密码
		</div>
		<div class="box-body">
			<form action="">
				<div class="ctn">
					<div class="col-lg-4 col-xs-6 m-t-b">
		              <div class="form-group">
		                <label for="">当前密码</label>
		                <input type="password" placeholder="请输入当前密码" class="form-control input-sm" id="old_pwd" maxlength="20">
		              </div>
		            </div>
				</div>
				<div class="ctn">
					<div class="col-lg-4 col-xs-6 m-t-b">
		              <div class="form-group">
		                <label for="">新密码</label>
		                <input type="password" placeholder="6-16位，由数字、字母和标点符号组成" class="form-control input-sm" id="new_pwd" maxlength="20">
		              </div>
		            </div>
				</div>
				<div class="ctn">
					<div class="col-lg-4 col-xs-6 m-t-b">
		              <div class="form-group">
		                <label for="">重复新密码</label>
		                <input type="password" placeholder="6-16位，由数字、字母和标点符号组成" class="form-control input-sm" id="re_new_pwd" maxlength="20">
		              </div>
		            </div>
				</div>
				<span id="errorMsg" class="pwdchg-tips"></span>
				<div class="ctn">
					<button id="submit" type="button" class="btn btn-primary">确定</button>
					<button id="cancel" type="button" class="btn btn-primary">取消</button>
				</div>
			</form>
		</div>
      </div>
    </div>

    <div class="footer">
    <c:if test="${sessionScope.customerInfo!=null}">
       客户:${sessionScope.customerInfo.clerk_name}
    </c:if>
    <c:if test="${sessionScope.userInfo!=null}">
    员工:${sessionScope.userInfo.clerk_name}
    </c:if><span class="glyphicon glyphicon-earphone"></span>
    </div>
</body>
</html>