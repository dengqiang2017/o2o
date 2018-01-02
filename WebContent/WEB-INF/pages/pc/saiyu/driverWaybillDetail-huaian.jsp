<%@ page language="java" contentType="text/html; charset=UTF-8"
			 pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <!--     <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.min.css">
    <link rel="stylesheet" href="../pcxy/css/global.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/fenjie.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <link rel="stylesheet" href="../css/popUpBox.css">
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
	<style>
	    ul>li{
	   list-style:none;
	}
	</style>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title">
        <a  data-title="phone">提货产品单</a>
        <a class="header-back" style="margin-top: 5px" href="../employee.do"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
</div>
<!----------------------secition------------------------->
<div class="secition-one">
    <div class="container">
<div class="secition-two">
    <div class="secition-two-2">
        <c:forEach items="${requestScope.list}" var="item">
        <ul style="border:1px solid #ddd">
			<div class="pro-check"></div>
            <li>订单编号：${item.ivt_oper_listing}</li>
            <li>客户姓名：${item.corp_name}</li>
            <li>客户地址：
            <c:if test="${item.FHDZ!=null}">
            ${item.FHDZ}
            </c:if>
            <c:if test="${item.FHDZ==null}">
            ${item.FHDZ2}
            </c:if>
            </li>
            <li>产品名称：${item.item_name}</li>
            <li>规格：${item.item_spec}</li>
            <li>型号：${item.item_type}</li>
            <li>数量：${item.sd_oq}${item.item_unit}
            <span id="seeds_id" style="display: none;">${item.seeds_id}</span></li>
            <div style="clear:both"></div>
        </ul>
        </c:forEach>
        
    </div>
</div>
		<c:if test="${requestScope.type=='beihuo'}">
			<c:if test="${requestScope.list.get(0).Status_OutStore=='司机拉货'}">
			<div>
				<span>司机提货仓门</span>
				<input type="text" id="didian">
			</div>
			<button type="button" class="btn bg-primary" id="beihuo" style="margin-top: 10px">备货完成</button>
			</c:if>
		</c:if>
		<div class="footer2" >
			<button type="button" class="btn bg-primary" id="tzfhgly" style="display: none;">请点此通知发货管理员产品已出库</button>
			<c:if test="${requestScope.list.size()>0}">
			<c:if test="${requestScope.type!='beihuo'}">
<%-- 			<c:if test="${requestScope.list.get(0).Status_OutStore=='司机拉货'}"> --%>
				<button type="button" class="btn bg-primary" id="tzdrive" style="margin-top: 10px">装车完成</button>
<%-- 				</c:if> --%>
			</c:if>
			</c:if>
		</div>
    </div>

</div>
<!--  margin-left:100px; -->

<script type="text/javascript">
$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
	var b=$(this).hasClass("pro-checked");
	if (b) {
		$(this).removeClass("pro-checked");
	}else{
		$(this).addClass("pro-checked");
	}
});
$("#beihuo").click(function(){
	var didian=$.trim($("#didian").val());
	if(didian==""){
		pop_up_box.showMsg("请输入司机提货仓门号");
		return;
	}
	pop_up_box.postWait();
	$.get("../orderTrack/noticeDrive.do",{
		"seeds_id":"${requestScope.seeds_id}",
		"didian":didian,
		"Status_OutStore":"司机拉货",
		"title":"详细提货地点通知",
		"description":"司机:@hys,库管已经完成备货,拉货仓门:"+didian
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			pop_up_box.showMsg("提交成功!",function(){
				window.location.href="../employee.do";
			});
		} else {
			if (data.msg) {
				pop_up_box.showMsg("提交错误!" + data.msg);
			} else {
				pop_up_box.showMsg("提交错误!");
			}
		}
	});
});
$("#tzdrive").click(function(){
	if (confirm("是否确认装车完成,并通知司机过磅!")) {
		pop_up_box.postWait();
		$.get("../employee/noticeDriveGuard.do",{
			"seeds_id":"${requestScope.seeds_id}",
			"shipped":"已发货",
			"title":"装车完成,通知司机过磅",
			"description":"司机:@hys,库管已经完成装车请过磅"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					window.location.href="../employee.do";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	}
});
$("#tzfhgly").click(function(){
	if (confirm("是否确认出库,并通知发货管理员!")) {
		pop_up_box.postWait();
		$.get("noticeShippingManager.do",{
			"seeds_id":"${requestScope.seeds_id}",
			"type":"未通知收货"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					window.location.href="../employee.do";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	}
});

</script>
</body>
</html>