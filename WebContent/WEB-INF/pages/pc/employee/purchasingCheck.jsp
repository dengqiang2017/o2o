<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 采购入库单 -->
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
@media(max-width:770px){
.Wdate{display: inline-block !important;width: 45% !important;
}
select{display: inline-block !important;width: 80% !important;}
}
@media(min-width:770px){
#c_memo{margin-bottom: -4px;}
#cpDate{width: 400px;}
#findForm label{float:left; width:auto;margin-top:2px}
.Wdate{float:left; margin-left:2%; width:38%;height:27px;}
#findForm .col-sm-3{width: 160px;}
#findForm select{width:121px;float:left;height:30px;}
#findForm .col-md-3{width: 200px;}
}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
      	<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class="active"><a>产品列表</a></li>
			<li class=""><a>根据采购订单入库</a></li>
			<li class=""><a>入库单</a></li>
			</ul>
	<div class="side-cover"></div>
	<div id="finding">
	<%@include file="find.jsp" %>
		<div style="float: left;margin-top: 10px;">
			<div class="form-group">
			<button class="btn btn-success btn-sm mrstore" type="button">仓库选择</button>
			<button class="btn btn-success btn-sm mrcorp" type="button">供应商选择</button>
			</div>
		</div> 
</div>
		<div id="findPurOrder" style="display: none;">
		<div class="form">
		<form id="findForm">
			<div class="col-xs-12 col-sm-4 col-md-4" id="rkDate" style="margin-top:10px">
				<div class="form-group">
					<label for="" style="">查询日期</label>
					<div>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-4 col-md-3" style="margin-top:10px">
			  <div class="form-group">
			    <label for="">订单状态</label>
			    <select class="form-control input-sm" id="m_flag">
					<option value="2">已处理有货</option>
					<option value="9">已安排物流</option>
					<option value="4">已发货</option>
			     </select>
			   </div>
			 </div>
			 <div class="col-xs-12 col-sm-4 col-md-4" style="margin-top:10px;" id="search">
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control input-sm" maxlength="50"
							placeholder="请输入搜索关键词" id="searchKey"> <span
							class="input-group-btn">
						<button class="btn btn-success btn-sm find" type="button">搜索</button>
						</span>
					</div>
				</div>
			</div>
		</form>
		<div style="float: left;margin-top: 10px;">
			<div class="form-group">
			<button class="btn btn-success btn-sm mrstore" type="button">仓库选择</button>
			</div>
		</div> 
		</div>
		</div>
		<div id="finded" style="display: none;">
		<div class="form">
		<form id="findForm">
			<div class="col-xs-12 col-sm-4 col-md-4" id="rkDate" style="margin-top:10px">
				<div class="form-group">
					<label for="" style="">查询日期</label>
					<div>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-3 col-md-2" style="margin-top:10px">
			  <div class="form-group">
			    <label for="">状态</label>
			    <select class="form-control input-sm" id="comfirm_flag">
				        <option value="N">未审核</option>
				        <option value="Y">已审核</option>
			     </select>
			   </div>
			 </div>
			 <div class="col-xs-12 col-sm-4 col-md-4" style="margin-top:10px;" id="search">
				<div class="form-group">
					<div class="input-group">
						<input type="text" class="form-control input-sm" maxlength="50"
							placeholder="请输入搜索关键词" id="searchKey"> <span
							class="input-group-btn">
						<button class="btn btn-success btn-sm find" type="button">搜索</button>
						</span>
					</div>
				</div>
			</div>
		</form>
		</div>
		</div>
	   <!-- 列表区域 -->
       <div class="box-body">
           <div class="tabs-content" style="display: block;">
           <input type="checkbox" class="check" style="display: none;">
         		<div class="ctn">
                <%@include file="../jiaju/employee/rukudan.jsp" %>
                </div>
                <div id="list"></div>
                <div class="ctn" style="display: none;">
         		<button class="btn btn-add load" type="button">点击加载更多</button>
          		</div>
          </div>
         <div class="tabs-content" style="display: block;">
           		<div id="list"></div>
       			<div class="ctn" style="display: none;">
         			<button class="btn btn-add load" type="button">点击加载更多</button>
       			</div>
         </div>
         <div class="tabs-content" style="display: block;">
           		<div id="list"></div>
       			<div class="ctn" style="display: none;">
         			<button class="btn btn-add load" type="button">点击加载更多</button>
       			</div>
         </div>
       </div>
     </div>
   </div>
   <div class="back-top" id="scroll"></div>
   <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name}&emsp;<span class="glyphicon glyphicon-earphone"></span>
     <div class="btn-gp">
       <label><input type="checkbox" id="allcheck">全选</label>
       <c:if test="${sessionScope.auth.purchase_rukuConfirm!=null}">
       <button class="btn btn-info" id="saveAccount" style="display:none;">审核</button>
       </c:if>
       <c:if test="${sessionScope.auth.purchase_rukuNotConfirm!=null}">
       <button class="btn btn-info" id="return" style="display:none;">弃审</button>
       </c:if>
       <c:if test="${sessionScope.auth.purchase_rukuDel!=null}">
       <button type="button" class="btn btn-info" id="delete" style="display:none;">删除</button>
       </c:if>
       <button class="btn btn-info" id="saveOrder">提交</button>
       <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
     </div>
   </div>
   
<div id="info" style="display:none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">经办信息</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<form id="setReceivable">
			<div class="form-group">
		    	<label>经办部门</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="dept_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="deptId" type="hidden"  name="dept_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm dept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerk_name" aria-describedby="basic-addon2"></span>
					<span class="input-group-btn">
		    			<input id="clerkId" type="hidden"  name="clerk_id">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
			<div class="col-lg-12 col-sm-12">
			<div class="form-group">
				<label>备注</label>
				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="sure" class="btn btn-primary" style="margin-right:0">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
<script src="../js/o2od.js${requestScope.ver}"></script>   
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/purchasingCheck.js${requestScope.ver}"></script>
</body>
</html>