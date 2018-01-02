<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script> 
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixininvite.js${requestScope.ver}"></script>
<script src="../pc/js/employeeList.js${requestScope.ver}"></script>
</head>
<body>
<div id="listpage">
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="cover"></div>
<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-6 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" name="searchKey" maxlength="20"  placeholder="请输入搜索关键词">
	  		</div>
		</div>
	  	<div class="col-sm-6 m-t-b">
	  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  	</div>
	</form>
	<div class="tree">
		<ul>
			<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
			<ul>
			<c:forEach items="${requestScope.depts}" var="personnel">
			<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-minus-sign"></i>${personnel.dept_name}
			<input type="hidden" value="${personnel.sort_id}"></span></li>
			</c:forEach>
			</ul>
			</li>
		</ul>
	</div>
</div>
<div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head">
		<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
		<c:if test="${requestScope.auth.add_maintenance!=null}">
			<a id="addpersonnel" class="btn btn-success">增加</a>
		</c:if>
<!-- 			<button type="button" onclick="weixininvitemore(5,6);" class="btn btn-danger btn-sm m-t-b">邀请列表中员工关注</button> -->
<!-- 			<button type="button" onclick="employeeToWeixin('employee');" class="btn btn-danger btn-sm m-t-b">备份数据到微信</button> -->
			 <c:if test="${requestScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
			<input type="file" id="xlsemployee" name="xlsemployee" onchange="excelImport(this,'employee');"></a>
			</c:if>
			<c:if test="${requestScope.auth.excel!=null}">
			<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('employee');">导出</button>
			</c:if>
			<c:if test="${sessionScope.auth.edit_maintenance!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b" onclick="editUtils.updateWeixinState('employee');">更新员工微信状态</button>
		    </c:if>
  	</div>
		<div class="box-body">
			<div class="table-responsive lg-table">
			<input type="hidden" id="select_treeId">
			<input type="hidden" id="qxcopy_hi" value="${requestScope.auth.qxcopy!=null}">
			<input type="hidden" id="qxfp_hi" value="${requestScope.auth.qxfp!=null}">
			<input type="hidden" id="del_hi" value="${requestScope.auth.del_maintenance!=null}">
			<input type="hidden" id="edit_hi" value="${requestScope.auth.edit_maintenance!=null}">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="200" data-name="clerk_name">姓名</th>
					       <th width="200" data-name="movtel">账号</th> 
					       <th width="200" data-name="dept_name">部门</th>  
					       <th width="200" data-name="headship">职务</th>   
					       <c:if test="${requestScope.auth.qxcopy!=null||requestScope.auth.qxfp!=null}">
					       <th width="200" data-name="quanxian">权限</th>
					       </c:if>
					       <c:if test="${requestScope.auth.del_maintenance!=null||requestScope.auth.edit_maintenance!=null}">
					       <th width="200" data-name="caozuo">操作</th>
					       </c:if>
						    <th width="200" data-name="weixinID">微信通讯录账号</th> 
					       <th width="200" data-name="working_status">工作状态</th>
						   <th width="200" data-name="mySelf_Info">只看自己？</th>  
					       <th width="200" data-name="class">产品类别</th>
<!-- 					       <th width="200" data-name="client">可做客户</th> -->
					       <th width="200" data-name="dept">部门来源</th>
					       <th width="200" data-name="warehouse">库房来源</th>
<!-- 					       <th width="200" data-name="regionalism_name_cn">行政区划</th>  -->
<!-- 					       <th width="200" data-name="regionalism_id">行政区划</th>  -->
					       <th width="200" data-name="clerk_id">员工内码</th>
					       <th width="200" data-name="self_id">员工外码</th>
<!-- 					       <th width="200" data-name="weixinStatus">微信状态</th> -->
					    </tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>

		<div class="box-footer">
					<div class="form-inline" >
				<div class="form-group pull-left">
				    <label>合计</label>
				    <span id="totalRecord">${requestScope.pages.totalRecord}</span>
				</div>
				<div class="form-group pull-left">
				    <label>每页显示条数</label>
				    <select id="rows">
				    <option value="10">10</option>
				    <option value="20">20</option>
				    <option value="30">30</option>
				    <option value="50">50</option>
				    <option value="80">80</option>
				    <option value="100">100</option>
				    </select>
				</div>
			</div>
			<div class="pull-left">
			跳转到:<input type="text" id="page" value="0" style="width: 50px;">
			总页数<span id="totalPage">${requestScope.pages.totalPage}</span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>	
		</div>	
	</div>
</div></div>
<div id="cop"></div>
<div class="footer">
	 员工:${sessionScope.userInfo.clerk_name}<div></div><div></div>
</div>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/personnel.js${requestScope.ver}"></script>
<div id="editpage">
</div>
</body>
</html>

 