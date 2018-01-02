<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    request.setAttribute("type",request.getParameter("type"));
    %>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/mymima.css">
<script src="../js_lib/jquery.md5.js"></script> 
<script src="../pc/js/pwchange.js"></script> 
 <form class="form-horizontal form-prop">
 <input type="hidden" id="type" value="${requestScope.type}">
    <div class="form-group">
        <label class="col-lg-2" style="line-height: 45px;text-align: center">输入原始密码</label>
        <div class="col-lg-10">
            <input type="password" placeholder="请输入当前密码" id="old_pwd" maxlength="20" class="form-control input-lg">
        </div>
    </div>
    <div class="form-group">
        <label class="col-lg-2" style="line-height: 45px;text-align: center">输入新密码</label>
        <div class="col-lg-10">
            <input type="password" placeholder="6-16位，由数字、字母和标点符号组成" id="new_pwd" maxlength="20" class="form-control input-lg">
        </div>
    </div>
    <div class="form-group">
        <label class="col-lg-2" style="line-height: 45px;text-align: center">再次确认新密码</label>
        <div class="col-lg-10">
            <input type="password" placeholder="6-16位，由数字、字母和标点符号组成" id="re_new_pwd" maxlength="20" class="form-control input-lg">
        </div>
    </div>
    <div class="form-group" id="errorMsg" style="color: red;">
    </div>
    <div class="form-group">
        <button type="button" class="btn btn-lg btn-primary btn-block btn-margintop" id="submit">确认修改</button>
    </div>
</form>