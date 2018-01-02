<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>成功装货</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/success_loading.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<!------------header--------------->
<div class="header">
    <a class="a_style" onclick="javascript:history.go(-1);">返回</a>
    成功装货</div>
<!------------body----------------->
<div class="body">
    <div class="body_tick">
        <img class="center-block" src="../pc/images/05tick_logo.png">
    </div>
    <div class="body_hint">
        货物装车完毕
    </div>
    <div class="body_detail">
        <ul>
            <li>
            <div>订单编号：</div>
            <div><span id="ddbh" style="color: #000000">${requestScope.list.get(0).ivt_oper_listing}</span></div>
            </li>
            <li>
<%--             <div>货物重量:<span style="color: #000000">${requestScope.casing_unitzsl}</span>${requestScope.list.get(0).casing_unit}</div> --%>
            <div>货物重量:<span style="color: #000000">${requestScope.casing_unitzsl}</span>${requestScope.list.get(0).item_unit}</div>
<%--             <div>折算重量:<span id="hwzl" style="color: #000000">${requestScope.zsl}</span>${requestScope.list.get(0).item_unit}</div> --%>
            </li>
        </ul>
    </div>
    <span id="name" style="display: none;">${requestScope.list.get(0).HYS}</span>
    <span id="customer_id" style="display: none;">${requestScope.list.get(0).customer_id}</span>
    <c:if test="${requestScope.list.get(0).Status_OutStore=='通知收货'||requestScope.list.get(0).Status_OutStore=='已发货'}">
    <button class="btn btn-success center-block btn-size" style="margin-top: 60px">确认装车完毕</button>
    </c:if>
</div>
<script type="text/javascript">
<!--
$("#hwzl").html(numformat2($("#hwzl").html()));
var name=$("#name").html().split(',')[0];
var description=$("#name").html().split(',');
$(".btn-success").click(function(){
	//通知客户已出厂
	pop_up_box.postWait();
	$.get("../orderTrack/noticeOutedFactory.do",{
		"seeds_id":"${requestScope.seeds_id}",
		"customer_id":$.trim($("#customer_id").html()),
		"headship":"出纳",
		"Cheadship":"库管",
		"clerk_name":name,
		"msg":"司机确认重量并出厂通知",
		"addName":"description",
		"description":"司机已经确认重量并出厂,司机姓名:"+description[0]+description[1]
	},function(data){
		pop_up_box.loadWaitClose();
		pop_up_box.showMsg("通知成功!",function(){
			window.close();
			window.location.href="../pc/index.html";
		});
	});
});
//-->
</script>
</body>
</html>