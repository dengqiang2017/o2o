<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>文件查看</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css">
<link rel="stylesheet" href="../css/popUpBox.css">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
   <style>
       ul>li{
           list-style: none;
           margin-bottom: 10px;
       }
   </style>

</head>
<body>
<div class="bg"></div>
<div class="header">
    <ol class="breadcrumb">
        <li><a href="../employee.do">员工首页</a></li>
        <li><a href="../employee/collectionConfirm.do"><span class="glyphicon glyphicon-triangle-right"></span>客户收款确认</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>查看摘要</li>
    </ol>
    <div class="header-title">
        员工首页-查看摘要<a class="header-back" href="../employee/collectionConfirm.do"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
</div>
    <div class="container" style="margin-top:10px;">
    <input type="hidden" id="com_id" value="${requestScope.com_id}">
       <div class="ctn-fff box-ctn">
           <ul> 
           </ul>
       </div>
   </div>
   <script type="text/javascript">
$.get("${requestScope.url}?"+Math.random(),function(data){
	var ds=data.split(",");
		$("ul").append("<li>"+ds[0]+"</li>");
		if(ds[1].indexOf("订单编号:")>=0){
			var msg=data.split("订单编号:")[1];
			var orders;
			if(msg.indexOf("[")<0){
	  		orders=$.parseJSON("["+msg+"]");
			}else{
	 		 orders=$.parseJSON(msg);
			}
	var com_id=$.trim($("#com_id").val());
	for (var i = 0; i < orders.length; i++) {
		var order=orders[i];
		if(com_id==$.trim(order.com_id)||com_id=="001"){
		$("ul").append("<li>产品名称:"+ifnull(order.item_name)+"</li>");
		$("ul").append("<li>单价:"+order.sd_unit_price+"</li>");
		if (order.sd_oq) {
		$("ul").append("<li>数量:"+order.sd_oq+"</li>");
		$("ul").append("<li>金额:"+numformat2(order.sd_unit_price*order.sd_oq)+"</li>");
		}else{
		$("ul").append("<li>数量:"+order.zsum+"</li>");
		$("ul").append("<li>金额:"+numformat2(order.sd_unit_price*order.zsum)+"</li>");
		}
		$("ul").append("<li>运营商编码:"+order.com_id+"</li>");
		$("ul").append("<li>------------------------</li>");
		}
	}
}
});
</script>
</body>
</html>