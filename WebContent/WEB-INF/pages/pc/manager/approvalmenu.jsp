<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>定义审批流程</title>
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<%@include file="../js_lib.jsp" %>
<link rel="stylesheet" href="../pc/css/menu.css${requestScope.ver}">
<style>
.body{ margin-bottom:50px;}
</style>
</head>

<body>
<div class="background"></div>
<%@include file="../header.jsp" %>
<div class="body">
	<div class="menu-group">
    	<div class="menu-head">业务类</div>
        <ul class="menu-body">
        	<a href="approvallist.do?type=1&name=使用额度"><li>使用额度<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=2&name=临时欠款"><li>临时欠款<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=3&name=提前使用预存款"><li>提前使用预存款<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=4&name=费用报销"><li class="last">费用报销<i class="fa fa-fw fa-arrow-right"></i></li></a>
        </ul>
    </div>
    <div class="menu-group">
    	<div class="menu-head">文牍类</div>
        <ul class="menu-body">
        	<a href="approvallist.do?type=5&name=用车办事"><li>用车办事<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=6&name=市场活动"><li>市场活动<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=7&name=请款报告"><li>请款报告<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=8&name=业务报告"><li>业务报告<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=9&name=项目建设"><li>项目建设<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=10&name=投资申请"> <li>投资申请<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=11&name=1天内请假"><li>1天内请假<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=12&name=3天内请假"><li>3天内请假<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=13&name=5天内请假"><li>5天内请假<i class="fa fa-fw fa-arrow-right"></i></li></a>
            <a href="approvallist.do?type=14&name=10天以上请假"><li class="last">10天以上请假<i class="fa fa-fw fa-arrow-right"></i></li></a>
        </ul>
    </div>
</div>
<div class="footer">
	<%@include file="footer.jsp" %>
</div>
</body>
</html>
