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
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" type="text/css" href="../saiyu/personalCenter.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/fenjie.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title">
        <a style="color: white;" data-title="phone">物流分解通知单</a>
        <a class="header-back" style="margin-top: 5px" href="../pc/index.html"><span class="glyphicon glyphicon-menu-left" style="color: white;"></span></a>
    </div>
</div>
<!----------------------secition------------------------->
<div class="secition-one">
    <div class="container">
    <div class="secition-one-1">
        <p>请凭此（物流分解通知单）及金蝶K/3-ERP的销售出库单前往库房领料进行分解打包贴标签，做好发货准备</p>
    </div>
<div class="secition-two">
    <div class="secition-two-2">
        <c:forEach items="${requestScope.list}" var="item">
        <ul style="border:1px solid #ddd">
            <li>订单编号：${item.ivt_oper_listing}</li>
            <li>客户姓名：${item.corp_name}</li>
            <li>客户地址：${item.FHDZ}</li>
            <li>产品名称：${item.item_name}</li>
            <li>规格型号：${item.item_spec}</li>
            <li>数量：${item.sd_oq}${item.casing_unit}</li>
            <div style="clear:both"></div>
        </ul>
        </c:forEach>
    </div>
    <button type="button" class="btn btn-primary center-block" style="width: 30%" id="dabao">打包完成</button>
</div>
    </div>
</div>
<script type="text/javascript">
$("#dabao").click(function(){
	if (confirm("是否确认完成打包,并通知发货管理员!")) {
		pop_up_box.postWait();
		var processName=decode(getQueryString("processName"));
		$.get("noticeShippingManager.do",{
			"seeds_id":"${requestScope.seeds_ids}",
			"processName":processName
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!");
				window.close();
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