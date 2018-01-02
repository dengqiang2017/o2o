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
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="keywords" content="向客户发送图文消息">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css">
<link rel="stylesheet" href="css/send.css${requestScope.ver}">
<link rel="stylesheet" href="css/contant.css${requestScope.ver}">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
 .activeTable{
   	background-color: #d5f0c7;
   }
   tr{
   	cursor: pointer;
   }
   .member{
       position: relative;
   }
   .member i{
       position: absolute;
       right: 0;
       top: 3px;
   }
   .member{
     overflow: hidden;
     text-overflow: ellipsis;
     white-space: nowrap;}
   .member span{font-size: 14px}
   .secition-top span{color: #019899;font-size: 16px}
   .text-overflow {
	display:block;/*内联对象需加*/
	width:190px;
	word-break:keep-all;/* 不换行 */
	white-space:nowrap;/* 不换行 */
	overflow:hidden;/* 内容超出宽度时隐藏超出部分的内容 */
	text-overflow:ellipsis;/* 当对象内文本溢出时显示省略标记(...) ；需与overflow:hidden;一起使用。*/
	}
	.word-list-box{
	padding: 5px;
	}
</style>
</head>
<body>
     <div class="bgT"></div>
     <div class="container" style="margin-bottom: 20px">
         <div class="secition">
             <div class="secition-top" style="margin-bottom: 20px;font-size: 16px">
                 <a href="../employee.do">${sessionScope.indexName}</a>&gt;
                 <a href="clientList.jsp" id="khlb" style="display: none;">客户列表&gt;</a>
                 <a href="#" id="khbf" style="display: none;">客户拜访&gt;</a>
                 <span>${requestScope.pageName}</span>
             </div>
              <div class="check">
                  <ul>
                      <li class="clearfix" style="display: none;">
                          <div class="li-left">选择员工</div>
                          <div class="li-center">
                          </div>
                          <button class="btn btn-default btn-sm btn-style" id="employeeSelect" type="button">
                              <img src="images/add.png">
                          </button>
                      </li>
                      <li class="clearfix">
                          <div class="li-left">选择客户</div>
                          <div class="li-center"></div>
                          <button class="btn btn-default btn-sm btn-style" id="clientSelect" type="button">
                              <img src="images/add.png">
                          </button>
                      </li>
                      <li class="clearfix" style="display: none;">
                          <div class="li-left">选择供应商</div>
                          <div class="li-center"></div>
                          <button class="btn btn-default btn-sm btn-style" id="gysSelect" type="button">
                              <img src="images/add.png">
                          </button>
                      </li>
                  </ul>
                  <div id="item" style="display: none;">
                  	<div class="member" style="cursor: pointer;">
                          <span id="name"></span>
                          <span id="weixinID" style="display: none;"></span>
                          <span id="customerId" style="display: none;"></span>
                          <i class="fa fa-times" aria-hidden="true" style="float: right;margin-top: 2px"></i>
                      </div>
                  </div>
              </div>
             <div class="word">
                 <div class="word-title">
                 <div class="word-left">
                     <div>消息发送方式:
                     <label><input type="radio" id="service" name="weixintype" value="service">服务号</label>
                     <label><input type="radio" id="qiyehao" name="weixintype" value="qiyehao" checked="checked">企业号</label>
                     <label style="display: none;"><input type="radio" id="sms" name="weixintype" value="sms">短信</label>
                     <label><input type="checkbox" id="all">所有人</label>
                     </div>
                  <p style="color: red;display: none;">注意事项:使用微信服务号发消息时,只有在48小时之内通过任意菜单项进入系统或者发送过消息的客户才能成功接收消息</p>
                                              已选文章列表：<span style="color: red;">（每次发送文章在1到8条之间组合发送，多出的部分系统自动舍弃）</span>
                        <a class="btn btn-info" style="color: white;" href="articleHistory.jsp?type=select">文章选择</a>
                 </div>
                 <div class="word-right">
                     <button type="button" class="btn btn-info" id="send">发送</button>
                 </div>
                     <div class="clearfix"></div>
                 </div>
                 <div class="word-list clearfix">
                 </div>
             </div>
                 <div class="clearfix"></div>
             <div id="imgItem" style="display: none;">
            	 <div class="word-list-box col-md-3">
                   <div class="box-title" style="background-color: #707070;"><span id="title" class="text-overflow">企业介绍</span><img src="images/deleteT.png" style="display: block"></div>
                   <div class="box-img"><img src=""></div>
                   <span id="htmlname" style="display: none;"></span>
                   <span id="projectName" style="display: none;"></span>
<!--                    <div class="box-span" id="gjc">这里是一些文字说明</div> -->
               </div>
             </div>
         </div>
     </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/send.js${requestScope.ver}"></script>
</body>
</html>