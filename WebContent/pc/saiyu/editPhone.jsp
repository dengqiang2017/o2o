<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%
    request.setAttribute("type",request.getParameter("type"));
    %>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/myshouji.css">
<script type="text/javascript" src="../pc/js/saiyu/editPhone.js"></script>
<form class="form-horizontal form-prop">
 <input type="hidden" id="type" value="${requestScope.type}">
     <div class="form-group">
         <label class="col-lg-2" style="line-height: 45px;text-align: center">手机号</label>
         <div class="col-lg-10">
         <input type="text" class="form-control input-lg" placeholder="请输入您的新手机号" data-num="num" maxlength="11" name="phone">
         </div>
     </div>
     <div class="form-group">
         <button type="button" class="btn btn-primary btn-lg center-block" id="get_code" disabled="disabled">获取验证码</button>
     </div>
     <div class="form-group">
         <label class="col-lg-2" style="line-height: 45px;text-align: center">验证码</label>
         <div class="col-lg-10">
             <input type="text" class="form-control input-lg" placeholder="请输入您的验证码" maxlength="6" name="code" disabled="disabled">
         </div>
     </div>
     <div class="form-group" id="msgspan" style="color: red;">
     </div>
     <div class="form-group">
         <button type="button" class="btn btn-lg btn-primary btn-block btn-margintop" id="save">确认修改</button>
     </div>
 </form>
 