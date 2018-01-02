<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../res.jsp" %>
	<script src="../js/O2O.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
	<script type="text/javascript"  src="../pc/js/settlement.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="container-fluid" >
	<div class="row">
		<div class="col-lg-4 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head">
					<form class="form-inline">
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>结算名称</label>
					    		<input type="text" class="form-control input-sm" id="settlement_sim_name" maxlength="20">
					  		</div>
						</div>
						<div class="col-sm-6 m-t-b">
							<div class="form-group">
					    		<label>记忆码</label>
					    		<input type="text" class="form-control input-sm" id="easy_id" maxlength="20">
					  		</div>
						</div>
					  	<div class="col-sm-6 m-t-b" style="margin-top:15px">
					  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
					  	</div>
					</form>
				</div>
				<div class="box-body">
					<div class="tree lg-tree">
					<ul>
						<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.settlements}" var="cls">
					<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-minus-sign"></i>${cls.settlement_sim_name}
					<input type="hidden" value="${cls.sort_id}"></span></li>
					</c:forEach>
					</ul>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-8 col-md-6">
			<div class="ctn-fff box-ctn" style="height:750px;">
				<div class="box-head"><h4 class="pull-left">结算方式列表</h4>
				<div class="pull-right">
					<a href="settlementEdit.do" class="btn btn-success">增加</a>
					<c:if test="${requestScope.auth.excelImp!=null}">
					<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
					<input type="file" id="xlssettlement" name="xlssettlement" onchange="excelImport(this,'settlement');"></a>
					</c:if>
					<c:if test="${requestScope.auth.excel!=null}">
					<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('settlement');">导出</button>
					</c:if>
				</div>
		  	</div>
				<div class="box-body">
					<div class="table-responsive lg-table">
					<input type="hidden" id="select_treeId">
					<span style="display: none;" id="guding">JS001,JS002,JS001JS003,JS001JS004</span>
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th>操作</th>  
							       <th>结算名称</th>  
							       <th>结算编码</th> 
							       <th>账户性质</th>  
							       <th>期初金额</th> 
							       <th>所属部门</th>  
							       <th>户头名称</th> 
							    </tr>
							</thead>
							<tbody>
								<c:forEach items="${requestScope.settlements}"  var="warehouse">
								<tr>
							<c:choose>  
									   <c:when test="${warehouse.sort_id=='JS001'||warehouse.sort_id=='JS002'||warehouse.sort_id=='JS001JS003'||warehouse.sort_id=='JS001JS004'}">  
									     <td>系统默认项</td>
									   </c:when>  
									   <c:otherwise>   
									<td>
										<button type="button" class="btn btn-danger btn-xs" style="margin-right:2px;" onclick='editSettlement(this);'>修改</button>
										<button type="button" class="btn btn-danger btn-xs" style="margin-right:2px;" onclick='delSettlement(this);'>删除</button>
								    </td>
									   </c:otherwise>  
									</c:choose> 
									<td>${warehouse.settlement_sim_name}</td>
									<td><input type="hidden" id="id" value="${warehouse.sort_id}">${warehouse.settlement_type_id}</td>
									<td>${warehouse.cheque_flag}</td>
									<td>${warehouse.i_Amount}</td>
									<td>${warehouse.dept_name}</td>
									<td>${warehouse.c_fullname}</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="footer">
	 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

    