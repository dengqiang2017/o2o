<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<!--    <script src="../js/o2od.js"></script> -->
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="min-height:600px;">
    		<div class="box-head">
    			协同流程
    		</div>
    		<div class="box-body">
    			<div class="splc-ctn" style="display: none;">
    				<div class="splc-head">业务类</div>
    				<ul class="splc-body">
<!--     					<li><a href="definitionProcessDetail.do?type=额度款&type_id=1">使用额度<span class="glyphicon glyphicon-hand-right"></span></a></li> -->
    					<li><a href="definitionProcessDetail.do?type=预存款&type_id=1">提前使用预存款<span class="glyphicon glyphicon-hand-right"></span></a></li>
<!--     					<li><a href="definitionProcessDetail.do?type=临时赊欠&type_id=1">临时赊欠<span class="glyphicon glyphicon-hand-right"></span></a></li> -->
    					<li><a href="definitionProcessDetail.do?type=客户欠条审批&type_id=1">客户欠条审批<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=插单计划审批&type_id=1">插单计划审批<span class="glyphicon glyphicon-hand-right"></span></a></li>
<!--     					<li class="last-li"><a href="definitionProcessDetail.do?type=费用报销&type_id=1">费用报销<span class="glyphicon glyphicon-hand-right"></span></a></li> -->
    				</ul>
    			</div>
    			<div class="splc-ctn" >
    				<div class="splc-head">文牍类</div>
    				<ul class="splc-body">
    					<li><a href="definitionProcessDetail.do?type=用车办事&type_id=2">用车办事<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=市场活动&type_id=2">市场活动<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=请款报告&type_id=2">请款报告<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=业务报告&type_id=2">业务报告<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=项目建设&type_id=2">项目建设<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=投资申请&type_id=2">投资申请<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=一天内请假&type_id=2">一天内请假<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=3天内请假&type_id=2">3天内请假<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li><a href="definitionProcessDetail.do?type=5天内请假&type_id=2">5天内请假<span class="glyphicon glyphicon-hand-right"></span></a></li>
    					<li class="last-li"><a href="definitionProcessDetail.do?type=10天以上请假&type_id=2">10天以上请假<span class="glyphicon glyphicon-hand-right"></span></a></li>
    				</ul>
    			</div>
    		</div>
    	</div>
    </div>
    <div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
        <div class="btn-gp">
			<button class="btn btn-info">保存</button>
			<a href="../employee.do" class="btn btn-primary">返回</a>
		</div>	
    </div>
</body>
</html>