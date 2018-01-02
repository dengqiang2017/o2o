<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <%@include file="../res.jsp"%>
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
</head>
<body>
<!----------------header----------------->
<div class="header">
    <div class="header-title">
        <a style="color: white;" data-title="title">收货通知单</a>
        <a class="header-back" style="margin-top: 5px" data-head="url">
            <span class="glyphicon glyphicon-menu-left" style="color: white;"></span>
        </a>
    </div>
</div>
<!----------------secition----------------->
<div class="section">
    <div class="col-lg-4 col-sm-6" style="background-color: #FFFFFF;margin: auto;margin-top: 10px;width: 95%;">
    <div>
    <div>供应商名称:<span id="gysname">${requestScope.gys.corp_name}</span></div>
    <div>手机号:<span id="phone">${requestScope.gys.user_id}</span></div>
    <div style="display: none;" id="weixinID">${requestScope.gys.weixinID}</div>
    </div>
    <c:forEach items="${requestScope.list}" var="item">
        <div class="div-bg">
            <div class="pro-check" style="float:left;margin-top:5px">
            <input type="hidden" value="${item_id}"></div>
            <ul style="padding-left:40px">
                <li>采购编号:<span>${item.st_auto_no}</span></li>
                <li>产品名称:${item.item_name}</li>
                <li>产品类型:${item.item_type}</li>
                <li>单价:${item.price}</li>
                <li>数量:${item.rep_qty}</li>
                <li>订单日期:${item.at_term_datetime}</li>
            </ul>
        </div>
    </c:forEach>
    </div> 
    <button class="btn btn-primary" id="allcheck">全选</button>
    <button class="btn btn-primary center-block">录入并通知采购</button>
</div>
<script type="text/javascript">
$(".btn-primary").click(function(){
	var items=$(".pro-checked");
	if(items&&items.length>0){
		var list=[];
		for ( var item in items) {
			var item=$(item).parent();
			var item_id=item.find("input").val();
			var st_auto_no=item.find("ul").find("span").html();
			var json={"item_id":"item_id","st_auto_no":st_auto_no};
			list.push(JSON.stringify(json));
		}
	pop_up_box.postWait();
	$.get("noticeReceipt.do",{
		"gysname":$("#gysname").html(),
		"phone":$("#phone").html(),
		"weixinID":$("#weixinID").html(),
		"headship":"采购",
		"store_struct_id":"WH000256",
		"gysheadship":"采购",
		"list":list
	},function(data){
		if (data.success) {
			pop_up_box.showMsg("提交成功!",function(){
				window.loaction.href="../employee.do";
			});
		} else {
			if (data.msg) {
				pop_up_box.showMsg("保存错误!" + data.msg);
			} else {
				pop_up_box.showMsg("保存错误!");
			}
		}
	});
	}else{
		pop_up_box.showMsg("请选择已经收货的产品!");
	}
});
$("#allcheck").bind("click",function(){
	var b=$(this).hasClass("pro-checked");
    if (b) {
    $(".pro-check").removeClass("pro-checked");
    }else{
    $(".pro-check").addClass("pro-checked");
    }
});
$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
	var b=$(this).hasClass("pro-checked");
	if (b) {
		$(this).removeClass("pro-checked");
	}else{
		$(this).addClass("pro-checked");
	}
});
</script>
</body>
</html>