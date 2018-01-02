<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>验证提货信息</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/verify_driver.css">
    <script src="../js_lib/jquery.11.js"></script>
        <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<!------------header--------------->
<div class="header">
    <a class="a_style glyphicon glyphicon-chevron-left header_a" href="../employee.do"></a>
    验证司机信息</div>
<!------------body----------------->
<div class="body">
    <div class="body_box">
        <div class="body_box_logo">
            <img class="center-block" src="">
        </div>
        <div class="body_box_detail">
            <ul>
                <li>
                    <div class="col-xs-6 color" style="text-align: right">姓名：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="name">${requestScope.list.get(0).HYS}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-6 color" style="text-align: right">车牌号：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="cph">${requestScope.list.get(0).HYS}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-6 color" style="text-align: right">提货地点：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="cmemo">${requestScope.list.get(0).c_memo}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-6 color" style="text-align: right">提货时间：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="date"></span></div>
                    <div class="clear"></div>
                </li>
            </ul>
        </div>
        <c:if test="${requestScope.list.get(0).Status_OutStore=='司机拉货'}">
        <button class="btn btn-success center-block btn-style">确认司机通知库管接车</button>
        </c:if>
    </div>
</div>
<script type="text/javascript">
<!--
var cmemo=$("#cmemo").text();
$("#cmemo").html(cmemo.split("|")[0].split(',')[0]);
$("#date").html(cmemo.split("|")[0].split(',')[1]);
var name=$("#name").html().split(',')[0];
var customer_id=$("#name").html().split(',')[2];
$("#name").html(name.substring(0,name.indexOf("(")));
$("#cph").html(name.substring(name.indexOf("(")+1,name.length-1));
$(".center-block").attr("src","../001/evalimg/"+customer_id+"/You.jpg");
$(".btn-success").click(function(){
	//通知库管和司机
	pop_up_box.postWait();
	$.get("../employee/guardConfirmNotice.do",{
		"seeds_id":"${requestScope.seeds_id}",
		"customer_id":customer_id//司机编码
	},function(data){
		pop_up_box.loadWaitClose();
		pop_up_box.showMsg("通知成功!",function(){
			window.location.href="../employee.do";
		});
	});
});
//-->
</script>
</body>
</html>