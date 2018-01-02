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
    <meta name="keywords" content="发送消息历史记录查询">
    <title>${requestScope.pageName}-${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/history.css${requestScope.ver}">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <style type="text/css">
    .activeTable{
    background-color: #d5f0c7;
    }
    tr{
    cursor: pointer;
    }
    </style>
</head>
<body>
      <div class="bgT"></div>
      <div class="container" style="margin-bottom: 10px;">
          <div class="secition">
          <div class="secition-top" style="margin-bottom: 20px;font-size: 16px">
                 <a href="../employee.do">${sessionScope.indexName}</a>&gt;
                 <span>${requestScope.pageName}</span>
             </div>
              <div class="secition-center">
                   <div class="query">
                       <ul>
                           <li>
                               <div class="input-group">
                                   <div class="input-group-addon">
                                       <i class="fa fa-search" aria-hidden="true"></i>
                                   </div>
                                   <input type="text" class="form-control" id="searchKey" maxlength="20" placeholder="请输入关键词">
                               </div>
                           </li>
                           <li>
                               <div class="input-group">
                                   <div class="input-group-addon">
                                   <span id="clerkBtn">员工选择</span>
                                   <span style="display: none;" id="clerk_id"></span>    
                                   </div>
                                   <input class="form-control" type="text" maxlength="20" id="clerkName">
                               </div>
                           </li>
                           <li>
                               <input type="date" id="d4311" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" name="beginDate">
                               <div class="margin">-</div>
                               <input type="date" id="d4312" class="form-control input-sm Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" name="endDate">
                           </li>
                           <li style="float: right">
                               <button type="button" class="btn btn-default find">搜索</button>
                           </li>
                           <div class="clearfix"></div>
                       </ul>
                   </div>
                  <div class="news">
                      <div class="news-title">
                          <div class="news-title-left">历史消息:</div>
                      </div>
                  </div>
                  <div class="history-list">
                  </div>
                      <div class="clearfix"></div>
                      <div id="item" style="display: none;">
                      	<div class="contant">
                          <div class="history-list-box">
                              <div class="box-title">
                                  <span id="title"></span>
                              </div>
                              <div class="box-img"><img style="display: block;"></div>
                              <div class="box-span" id="gjc"></div>
                          </div>
                          <div class="time">
                              <div class="time-left">发送时间:</div>
                              <div class="time-right" id="sendTime"></div>
                          </div>
                          <div class="people">
                              <div class="people-left">接收人员:</div>
                              <div class="people-right" id="recRen"></div>
                          </div>
                          <div class="result">
                              <div class="result-left">服务号发送结果:</div>
                              <div class="result-right" id="serviceRet"></div>
                          </div>
                          <div class="result">
                              <div class="result-left">企业号发送结果:</div>
                              <div class="result-right" id="ret"></div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/sendHistory.js${requestScope.ver}"></script>
</body>
</html>