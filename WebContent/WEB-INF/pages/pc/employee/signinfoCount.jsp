<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/O2O.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/signCount.js${requestScope.ver}"></script>
<style type="text/css">
tbody tr{
cursor: default;
}
	@media(min-width:770px){
	    .xx{
	width:130px !important;
	}
	}
	@media(max-width:770px){
	.hh{
	width:111px !important;
	}
	}
</style>
</head>
<body>
<div id="personneList">
<div class="bg"></div>
<%@include file="../header.jsp" %>
<div class="cover"></div>
<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
			<div class="form-group" style="width:100%">
	<div class="col-lg-3">
	<label for="" style="margin-top: 7px;">输入关键词</label>
	</div>
	<div  class="col-lg-9">
	<input type="text" class="form-control input-sm xx" id="searchKey" name="searchKey" maxlength="20"  placeholder="请输入搜索关键词">
	</div>
	  		</div>
		</div>
		<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
		<div class="form-group" style="margin-bottom:15px;width:100%">
	<div class="col-lg-3">
			<label for="" style="margin-top: 7px;">签到开始日期</label>
	</div>
		<div class="col-lg-9">
		<input type="date"  class="form-control input-sm Wdate xx begindate hh" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="float:left;">
	     <div style="clear:both"></div>
	</div>
		</div>
		<div class="form-group" style="width:100%">
	<div class="col-lg-3">
			<label for="" style="margin-top: 7px;">签到结束日期</label>
	</div>
	<div class="col-lg-9">
		<input type="date"  class="form-control input-sm Wdate xx enddate hh" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="float:left;">
	<div style="clear:both"></div>
	</div>
		</div>
		</div>
	  	<div class="col-sm-12 m-t-b" style="padding: 5px 0;">
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
		</ul>
	</div>
</div>
<div class="container" style="margin-bottom:50px">
	<div class="ctn-fff box-ctn" style=";">
		<div class="box-head">
		<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
			<c:if test="${sessionScope.auth.excel!=null}">
			<button type="button" class="btn btn-danger btn-sm m-t-b print">打印</button>
			</c:if>
			<button type="button" class="btn btn-danger btn-sm m-t-b" id=parambtn>签到查询时间段</button>
  	</div>
		<div class="box-body">
			<div class="table-responsive lg-table" >
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered" id="print">
					<thead>
						<tr> 
					       <th width="100" data-name="clerk_name">姓名</th>
					       <th width="100" data-name="dept_name">部门</th>
					       <th width="100" data-name="全部签到">全部签到</th>
					       <th width="100" data-name="正常签到">正常签到</th>
					       <th width="100" data-name="上午迟到">上午迟到</th>
					       <th width="100" data-name="下午签到">下午签到</th>
					       <th width="100" data-name="下班正常签到">下班正常签到</th>
					       <th width="100" data-name="早退">早退</th>
					       <th width="100" data-name="未签到 ">未签到</th>
					    </tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
	</div>
</div>


</div>
<div class="footer">
	 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
<div id="modal_smsSelect" style="display: none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">签到查询时间段</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					上午上班时间
					</label>
					<input type="time" id=morningBeginTime class="form-control input-sm Wdate xx" 
					onfocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" value="08:30:00">
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  上午迟到时间
					</label>
					<input type="time" id=morningLateTime class="form-control input-sm Wdate xx" 
					onfocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" value="09:30:00">
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  下午上班时间
					</label>
					<input type="time" id=afternoonBeginTime  class="form-control input-sm Wdate xx hh" 
					onfocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" value="12:00:00">
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  下午下班时间
					</label>
					<input type="time" id=afternoonEndTime class="form-control input-sm Wdate xx" 
					onfocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})" value="19:30:00">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>

 