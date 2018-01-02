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
    <link rel="stylesheet" href="../pc/css/verify.css">
    <link rel="stylesheet" href="../pc/css/verify_driver.css">
    <script src="../js_lib/jquery.11.js"></script>
        <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<!------------header--------------->
<div class="header">
    <a class="a_style glyphicon glyphicon-chevron-left header_a"  href="../employee.do"></a>
    验证提货信息</div>
<!------------body----------------->
<div class="body">
    <div class="body_box">
        <div class="body_box_logo">
            <img class="center-block" src="">
        </div>
    </div>
        <div class="body_box_detail">
            <ul>
                <li>
                    <div class="col-xs-5 color" style="text-align: right">姓名：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="name">${requestScope.list.get(0).HYS}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-5 color" style="text-align: right">车牌号：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="cph">${requestScope.list.get(0).HYS}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-5 color" style="text-align: right">提货时间：</div>
                    <div class="col-xs-6" style="text-align: center"><span id="date">${requestScope.list.get(0).date}</span></div>
                    <div class="clear"></div>
                </li>
                <li>
                    <div class="col-xs-5 color" style="text-align: right">应提货：</div>
<%--                     <div class="col-xs-6" style="text-align: center;color: #FE0001"><span>${requestScope.casing_unitzsl}</span>${requestScope.list.get(0).casing_unit}</div> --%>
                    <div class="col-xs-6" style="text-align: center;color: #FE0001"><span>${requestScope.casing_unitzsl}</span>${requestScope.list.get(0).item_unit}</div>
                    <div class="clear"></div>
                </li>
<!--                 <li> -->
<!--                     <div class="col-xs-5 color" style="text-align: right">折算重量：</div> -->
<%--                     <div class="col-xs-6" style="text-align: center;color: #FE0001"><span id="yth">${requestScope.zsl}</span>${requestScope.list.get(0).item_unit}</div> --%>
<!--                     <div class="clear"></div> -->
<!--                 </li> -->
                <li>
                    <div class="col-xs-5 color" style="text-align: right">实提货：</div>
                    <div class="col-xs-6">
                    <input style="width: 80%;height: 100%;border: 1px solid #5CA04B;text-align: center;" 
                    placeholder="请输入过磅重量" type="tel" value="${requestScope.casing_unitzsl}" id="zsl">${requestScope.list.get(0).item_unit}</div>
                    <div class="clear"></div>
                </li>
            </ul>
        </div>
        <c:if test="${requestScope.list.get(0).Status_OutStore=='通知收货'||requestScope.list.get(0).Status_OutStore=='已发货'}">
		<!-- 门卫和司机同步操作,司机操作后数据状态会变成已发货,所以需要判断两种情况 -->
        <button class="btn btn-success center-block btn-style" style="margin-bottom: 10px">确定</button>
        </c:if>
    </div>
<script type="text/javascript">
<!--
// var cmemo=$("#cmemo").text();
// $("#cmemo").html(cmemo.split("|")[0].split(',')[0]);
// $("#date").html(cmemo.split("|")[0].split(',')[1]);
$("#yth").html(numformat2($("#yth").html()));
$("#zsl").val(numformat2($("#zsl").val()));
var name=$("#name").html().split(',')[0];
var description=$("#name").html().split(',');
var customer_id=$("#name").html().split(',')[2];
$("#name").html(name.substring(0,name.indexOf("(")));
$("#cph").html(name.substring(name.indexOf("(")+1,name.length-1));
$(".center-block").attr("src","../001/evalimg/"+customer_id+"/You.jpg");
$(".btn-success").click(function(){
	var zsl=$.trim($("#zsl").val());
	if (zsl==""||zsl=="0") {
		pop_up_box.showMsg("请输入实提货重量");
		return;
	}
	//通知内勤司机已出厂
	pop_up_box.postWait();
	$.get("../orderTrack/noticeNeiqing.do",{
		"seeds_id":"${requestScope.seeds_id}",
		"headship":"内勤",
		"zsl":"${requestScope.zsl}${requestScope.list.get(0).item_unit}",
		"msg":"门卫确认司机出厂通知",
		"description":"司机"+$("#name").html()+",门卫已经确认重量并出厂,重量:"+zsl+"${requestScope.list.get(0).item_unit},司机姓名:"+description[0]+description[1]
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