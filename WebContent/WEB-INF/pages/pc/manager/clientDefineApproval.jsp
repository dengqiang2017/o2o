<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 客户报修协同定义 -->
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/product.css${requestScope.ver}">
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/definition/clientDefineApproval.js${requestScope.ver}"></script>
<style type="text/css">
.ImmediatelyContact {
    background-color: #1e347b;
    border-radius: 8px;
    font-size: 15px;
    padding: 4px;
    position: absolute;
    right: 199px;
    text-align: center;
}
.client {
    background-color: #007cc2;
    border-radius: 5px;
    color: #ffffff;
    font-family: "΢���ź�";
    font-size: 23px;
    font-weight: normal;
    margin: 15px 0;
    padding-bottom: 5px;
    padding-left: 15px;
    padding-top: 5px;
}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
    	<div class="ctn-fff box-ctn" style="min-height:600px;">
            <div class="client">
		        <div class="client_name">
		            <span>客户名称：</span><span id="customerName"> </span>
		        </div>
		        <div class="client_tel">
		            <span>客户电话：</span><span id="telNo"></span><!-- <span class="ImmediatelyContact">联系客户</span> -->
		        </div>
		        <input type="hidden" id="customerId">
		    </div>
    		<div class="box-body">
    			<div class="ctn">
					<button type="button" class="btn btn-primary" >新增协同步骤</button>
					<input type="hidden" id="item_name" value="客户报修协同">
					<input type="hidden" id="item_id">
				</div>
				<div class="ctn" style="margin-top:10px;display: none;" id="item">
					<div class="col-lg-3 col-sm-4">
						<div class="panel panel-info sp-ctn">
						<input type="hidden" id="seeds_id">
							<div class="panel-heading sp-head">序号:1</div>
							<div class="panel-body sp-body">
								<div class="ctn">
									<div class="col-xs-4 sp-label">协同人</div>
									<div class="col-xs-8 sp-content" id="clerkName"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">协同部门</div>
									<div class="col-xs-8 sp-content" id="deptName"></div>
								</div>
								<div class="ctn">
									<div class="col-xs-4 sp-label">协同步骤</div>
									<div class="col-xs-8 sp-content" id="approvalStep"></div>
								</div>
								<div class="ctn" style="display: none;">
									<div class="col-xs-4 sp-label">是否可跳过</div>
									<div class="col-xs-8 sp-content" id="if_skip">否</div>
								</div>
								<div class="ctn">
                                <div class="col-xs-4 sp-label">推送结果通知</div>
                                <div class="col-xs-8 sp-content" id="noticeResult">否</div>
                            	</div>
							</div>
							<div class="panel-footer">
								<button type="button" class="btn btn-xs btn-info" id="upmove">上移</button>
								<button type="button" class="btn btn-xs btn-info" id="downmove">下移</button>
								<button type="button" class="btn btn-xs btn-primary" id="editprocess">编辑</button>
								<button type="button" class="btn btn-xs btn-danger" id="delprocess">删除</button>
							</div>
						</div>
					</div>
				</div>
				<div id="item01">
				</div>
    		</div>
    	</div>
    </div>
    <div class="footer">
 员工:${sessionScope.userInfo.personnel.clerk_name}
        <div class="btn-gp">
<!-- 			<button class="btn btn-info">保存</button> -->
			<a href="client.do" class="btn btn-primary">返回</a>
		</div>	
    </div>
</body>
</html>