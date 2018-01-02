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
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/tihuo.css">
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/common.js"></script>
    <script src="../js/o2od.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title">
        <a style="color: white;" data-title="phone">提货通知单</a>
        <a class="header-back" style="margin-top: 5px" href="../pc/index.html"><span class="glyphicon glyphicon-menu-left" style="color: white;"></span></a>
    </div>
</div>
<!----------------------secition------------------------>
<div class="section">
    <div class="container">
        <div class="container-one">
    <h4 style="color: #D81F1C;font-weight: bold">[标注：]请分享这个页面给拉货司机</h4>
        <c:if test="${requestScope.ordertype==null}">
        <c:forEach items="${requestScope.list}" var="item">
            <div style="margin-bottom:20px;border:1px solid #ddd">
            <h4 class="text-primary">提货地点</h4>
            <p class="text-muted pmargin" id="cmemo">${item.c_memo}</p>
            <h4 class="text-primary">提货时间</h4>
            <p class="text-muted pmargin" id="date"></p>
<!--             <h4 class="text-primary">物流联系人</h4> -->
<!--             <p class="text-muted pmargin">李五：186628288339</p> -->
            <h4 class="text-primary">收货联系人</h4>
            <p class="text-muted pmargin" id="shlxr">${item.corp_name}${item.movtel}</p>
<%--             <p class="text-muted pmargin">${item.c_memo.split("|")[1]}</p> --%>
            <h4 class="text-primary" id="shdz">收货地址</h4>
            <p class="text-muted pmargin">${item.FHDZ}</p>
            </div>
            </c:forEach>
            
            <a class="btn center-block btn_style" id="platformsPhone">通知内勤提前备货</a>
        	<input type="hidden" id="platformsHeadship" value="内勤">
        	
            <h4 class="text-primary pmargin">详细配送信息二维码：</h4>
            <img src="${requestScope.erweima}" class="center-block">
            <script type="text/javascript">
			var cmemo=$("#cmemo").text();
			$("#cmemo").html(cmemo.split("|")[0].split(',')[0]);
			$("#date").html(cmemo.split("|")[0].split(',')[1]);
			if($("#shlxr").text()==""&&cmemo.split("|")[1]){
				$("#shlxr").html(cmemo.split("|")[1].split(',')[0]);
				$("#shdz").html(cmemo.split("|")[1].split(',')[1]);
			}
            </script>
			<c:if test="${requestScope.Status_OutStore=='已发货'}">
			<button type="button" class="btn btn-primary center-block" style="width: 30%">用户收货</button>
			<script type="text/javascript">
			$(".bg-primary").click(function(){
				if (confirm("是否确认用户已收货,并通知发货管理员!")) {
					pop_up_box.postWait();
					$.get("noticeShippingManager.do",{
						"seeds_ids":"${requestScope.seeds_ids}",
						"type":"已结束"
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("提交成功!");
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
			</c:if>
            </c:if>
            <c:if test="${requestScope.ordertype!=null}">
            	订单已结束!
            </c:if>
        </div>
    </div>
</div>
 
</body>
</html>