<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	String send=BaseController.getPageNameByUrl(request,"send.jsp");
	request.setAttribute("sendName", send);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="keywords" content="文章库,编辑新文章,浏览历史文章">
    <meta name="description" content="文章库,编辑新文章,浏览历史文章">
    <title>${requestScope.pageName}-${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/check.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <style type="text/css">
    .activeTable{
    background-color: #d5f0c7;
    }
    tr{
    cursor: pointer;
    }
    .secition-top span{color: #019899;font-size: 16px}
    .col-xs-12{padding-top: 10px;}
    </style>
</head>
<body>
<span id="clerkId" style="display: none;">${sessionScope.userInfo.clerk_id}</span>
<span id="clerk_name" style="display: none;">${sessionScope.userInfo.clerk_name}</span>
  <div class="bgT"></div>
  <div class="container" style="margin-bottom: 20px">
      <div class="secition">
          <div class="secition-top" style="margin-bottom: 20px;font-size: 16px">
              <a href="../employee.do">${sessionScope.indexName}</a>&gt;
              <a href="send.jsp" style="display: none;" id="send">${requestScope.sendName}&gt;</a>
              <span>${requestScope.pageName}</span>
          </div>
          <div class="secition-center">
               <div class="query">
               <div class="col-xs-12 col-sm-6 col-md-5">
               <div class="input-group">
                               <input class="form-control" type="text" maxlength="20" id="clerkName">
                               <div class="input-group-addon">
                               <span id="clerkBtn" title="点击打开员工列表进选择">员工选择</span>
                               <span style="display: none;" id="clerk_id"></span>    
                               </div>
                           </div>
               </div>
               <div class="col-xs-12 col-sm-3 col-md-2">
                         <input type="date" id="d4311" class="form-control Wdate" 
                       onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" 
                       name="beginDate" placeholder="开始时间">
               </div>
               <div class="col-xs-12 col-sm-3 col-md-2">
<!--                            <div class="margin">-</div> -->
                           <input type="date" id="d4312" class="form-control Wdate" 
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" 
                           name="endDate" placeholder="结束时间">
               </div>
               <c:if test="${sessionScope.userInfo.com_id=='001'}">
               		<div class="col-xs-12 col-sm-3 col-md-2">
                       <select class="form-control" id="guanwan">
                       <option value="">内部编辑文案</option>
                       <optgroup label="官网p1文案">
	                       <option value="p1-2">案例</option>
	                       <option value="p1-3">口碑</option>
	                       <option value="p1-1">服务</option>
                       </optgroup>
                       <optgroup label="官网p2文案">
                       	   <option value="p2-2">案例</option>
	                       <option value="p2-3">口碑</option>
	                       <option value="p2-1">服务</option>
                       </optgroup>
                       <optgroup label="官网p8文案">
                       	   <option value="p8-2">案例</option>
	                       <option value="p8-3">口碑</option>
	                       <option value="p8-1">服务</option>
                       </optgroup>
                       <optgroup label="官网p9文案">
                       	   <option value="p9-1">案例</option>
	                       <option value="p9-2">新闻动态</option>
	                       <option value="p9-20">互联网+思维？</option>
	                       <option value="p9-21">为什么？</option>
	                       <option value="p9-22">怎么做？</option>
                       </optgroup>
                       </select>
               	</div>
               </c:if>
               <div class="col-xs-12 col-sm-5 col-md-3">
               <div class="col-xs-9 col-sm-9 col-md-9">
                   <input class="form-control" id="searchKey" type="text" placeholder="请输入标题名称关键词" maxlength="20">
               </div>
               <div class="col-xs-3 col-sm-3 col-md-3">
               		<button type="button" class="btn btn-default find"><i class="fa fa-search" aria-hidden="true"></i>搜索</button>
               	</div>
               </div>
               <div class="col-xs-12 col-sm-6 col-md-1">
               <div class="input-group">
               </div>
               </div>
               <div class="clearfix"></div>
               </div>
              <div class="news">
                  <div class="news-title">
                      <div class="news-title-right">
                          <div class="new" id="addArticle">
                              <a href="articleDialog.jsp"><i class="fa fa-pencil-square-o" aria-hidden="true">新建素材</i></a>
                          </div>
                          <button type="button" class="btn btn-default" id="confim">确定选择</button>
                          <div class="new">
                      	  <span style="font-size: 14px;">使用注意:只能在电脑端编辑删除登录人自己发布的文章,非电脑端只能用于发送文案时选择文案</span>
                      	  </div>
                      </div>
                  </div>
              </div>
              <div class="history-list">
              </div>
                  <div class="clearfix"></div>
              <div id="item" style="display: none;"> 
              		<div class="contant">
                      <div class="history-list-box">
                          <div class="box-title">
<!--                           <input type="checkbox" style="width: 20px;height: 20px;"> -->
                              <i class="fa fa-square check" aria-hidden="true" style="font-size: 20px;"></i>
                              <i class="fa fa-pencil-square-o edit" aria-hidden="true"></i>
                              <img src="images/deleteT.png" class="del">
                              <span id="title" class="articleedit_title">企业介绍</span>
                          </div>
                          <div class="box-img"><img src="" style="display: block;"></div>
                          <div class="box-span" id="gjc">这里是一些文字说明</div>
                          <span id="htmlname" style="display: none;"></span>
                      </div>
                      <div class="time">
                          <div class="time-left">创建时间:</div>
                          <div class="time-right articleedit_time" id="releaseTime"></div>
                      </div>
                      <div class="people">
                          <div class="people-left">创建人:</div>
                          <div class="people-right" id="publisher"></div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<!-- <script type="text/javascript" src="../js/bootstrap.min.js"></script> -->
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/articleHistory.js${requestScope.ver}"></script>
</body>
</html>