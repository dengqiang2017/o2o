<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
</head>
<body>
<div id="listpage">
	<div class="header">
		<ol class="breadcrumb">
		  <li><a href="../employee.do">${sessionScope.indexName}</a></li>
		  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee/myOA.do">我的协同</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户报修体检表</li>
		</ol>
    <div class="header-title">
    客户报修体检表<a class="header-back" href="../employee.do"><span class="glyphicon glyphicon-menu-left"></span></a>
    </div>
	</div>
<div class="container" style="margin-top: 50px;margin-bottom: 50px;">
	<div class="ctn-fff box-ctn" style="margin-bottom: 30px;padding:0">
            <div class="box-head" style="border-bottom:none">
           	        <input type="hidden" id="spNo" value="${requestScope.spNo}">
           	        <input type="hidden" id="approval_step" value="${requestScope.approval_step}">
           	        <input type="hidden" id="customer_id" value="${requestScope.customer_id}">
<%--  		<c:if test="${requestScope.spNo==null}"> --%>
<!-- 		<a class="btn btn-success btn-sm m-t-b" onclick="tijian.addTdHtml();">增加</a> -->
<%-- 		</c:if> --%>
		<c:if test="${requestScope.spNo!=null}">
           <button type="button" class="btn btn-primary" id="qrtjProduct">确认推荐产品</button>
        </c:if>
    <button type="button" class="btn btn-primary btn-folding btn-sm  btn0" id="expand" style="display: inline-block;margin-bottom: 0;">查询</button>
            </div>
		<div class="box-body" style="padding:0">
			<div class="table-responsive" id="box">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered" id="tab">
					<thead>
					<%@include file="tijianthead.jsp" %>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="box-footer">
			<div class="pull-right">
<!-- 			<input type="text" id="page" value="0" style="width: 50px;"> -->
			总页数<span id="totalPage">${requestScope.pages.totalPage}</span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>
		</div>
	</div>
</div>
<%@include file="../footer.jsp" %>
</div>
<div id="editpage"></div>
<div class="image-zhezhao" style="display:none">
   <div style="width: 5%;float: left">
        <div class="img-left"></div>
   </div>
    <div style="width: 90%;float: left;height: 100%;">
        <div class="img-ku" style="float:left;">
            <div id="imshow">
            </div>
        </div>
    </div>
    <div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div>
    <div class="modal" id="mymodal">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">查询</h4>
    </div>
    <div class="modal-body">
    <div class="form">
    <form id="findForm">
    <div class="col-lg-12 col-sm-3">
    <label>位置大类</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="position_big">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>灯具名称</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="item_name">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>状态</label>
    <select class="form-control input-sm" id="workState">
    <option value="报修">报修</option>
    <option value="采购">采购</option>
    <option value="审批">审批</option>
    <option value="支付">支付</option>
    <option value="配送">配送</option>
    </select>
    </div>
    <div class="col-sm-3 col-lg-12">
    <div class="form-group">
    <div class="input-group">
    <label>&nbsp;</label>
    <input type="text" class="form-control input-sm" maxlength="50" placeholder="请输入搜索关键词" id="searchKey"> <span class="input-group-btn">
    <button class="btn btn-success btn-sm find" style="margin-top: 26px" type="button">搜索</button>
    </span>
    </div>
    </div>
    </div>
    <div style="clear:both"></div>
    </form>
    </div>
    </div>
    <div class="modal-footer">

    </div>
    </div>
    </div>
    </div>
    <script src="../js/o2od.js${requestScope.ver}"></script>   
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/tijianList.js${requestScope.ver}"></script>
    <script>
    $(function(){
    $(" .btn0").click(function(){
    $("#mymodal").modal("toggle");
    });
    });
    </script>
</body>

</html>