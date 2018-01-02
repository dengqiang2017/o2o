<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<link rel="stylesheet" href="../pc/css/chehuachu.css">
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixininvite.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/clientList.js${requestScope.ver}"></script>
<style>
.modal_ul>li{
float:left;
list-style:none;
margin-right:9px;
width:70px;
text-align:center;
}
td input[type="checkbox"],th input[type="checkbox"]{
width: 50px;
height:20px;
display: inline-block;
}
.tc .glyphicon-remove{float: right;padding: 10px;}
.tc li>span{margin-left: 5px;}
.tc li{line-height: 30px;border: 1px solid aqua;}
.tc ul{overflow: auto;max-height: 500px;}
</style>
</head>
<body>
<div id="listpage">
<%@include file="../header.jsp" %>
<input type="hidden" id="emplName" value="${requestScope.emplName}"> 
<div class="left-hide-ctn">
	<form class="form-inline" style="overflow:hidden;">
		<div class="col-sm-6 col-xs-6 m-t-b">
			<div class="form-group">
	    		<input type="text" class="form-control input-sm" id="searchKey" maxlength="20" placeholder="请输入查询关键词">
	  		<button type="button" class="btn btn-primary btn-sm" id="find">查询</button>
	  		</div>
		</div> 
	  	<div class="col-sm-6 col-xs-6 m-t-b">
	  	</div>
	</form>
	<div class="tree">
		<ul>
		<li><span id="treeAll" style="display: none;"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
		</li>
		</ul>
		<ul>
		<c:forEach items="${requestScope.clients}" var="client">
		<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-leaf"></i>${client.corp_name}
		<input type="hidden" value="${client.customer_id}"></span></li>
		</c:forEach>
		</ul>
	</div>
</div>
<input type="hidden" id="edit_hi" value="${sessionScope.auth.edit_maintenance!=null}">
<input type="hidden" id="del_hi" value="${sessionScope.auth.del_maintenance!=null}">
<input type="hidden" id="edit_approval" value="${sessionScope.auth.edit_approval!=null}">
<div class="container">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head"><h4 class="pull-left">客户列表</h4>
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
		<c:if test="${sessionScope.auth.add_maintenance!=null}">
			<a id="addclient" class="btn btn-success btn-sm m-t-b">增加</a>
<!-- 			<button type="button" id="addNextClient" class="btn btn-success btn-sm m-t-b">增加下级</button> -->
		</c:if>
			<c:if test="${sessionScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
		    <input type="file" id="xlsclient" name="xlsclient" onchange="excelImport(this,'client');"></a>
			</c:if>
			<c:if test="${sessionScope.auth.excel!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('client');">导出</button>
		    </c:if>
		    <c:if test="${sessionScope.auth.edit_maintenance!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b" onclick="editUtils.updateWeixinState('client');">更新客户微信状态</button>
		    </c:if>
		    <c:if test="${sessionScope.auth.yxsms!=null}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b selectShow">向客户发送短信</button>
		    <c:if test="${requestScope.smsType=='0'}">
		    <button type="button" class="btn btn-danger btn-sm m-t-b smsyue">查看短信剩余数</button>
		    <a class="btn btn-danger btn-sm" href="http://222.73.66.76:8000" target="_blank" title="账户名密码:运营管理平台->管理模式驾驶舱->系统控制->营销类短信用户名和密码">查看最近短信发送状态</a>
		    </c:if>
		    </c:if>
  		</div>
		<div class="box-body">
			<div class="table-responsive" style="max-height:600px;overflow: auto;">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered">
					<thead>
						<tr>  
					       <th width="300"><label>操作
					       <c:if test="${sessionScope.auth.yxsms!=null}">
					       <input type="checkbox">
					       </c:if>
					       </label></th>
					        <%@include file="list.jsp" %>
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
</div>
<%@include file="../footer.jsp" %>
<div class="cover"></div>
	<div class="tc">
        <div class="">
        <button type="button" class="btn btn-default" onclick="$('.tc').hide();">关闭</button>
        <span style="font-size: 16px;font-weight: bold;">向客户发送短信</span>
        <button type="button" class="btn btn-info pull-right sendsms">发送</button>
        </div>
        <div class="tc_body">
        <c:if test="${requestScope.smsType=='0'}">
        <p>短信格式:【签名】+内容+退订回T</p>
        <p>系统已自动添加【签名】和[退订回T],请直接编辑短信内容即可.</p>
        <p>正式使用时每次发送短信数量不能少于500条,70个字等于1条短信,超过70字,每67个字算一条短信</p>
        </c:if>
        <textarea rows="5" cols="50" id="sms"></textarea>字数:<span id="smslen">0</span>
        <h4>已选择客户:<span id="selectCount"></span>
        <button type="button" class="btn btn-default btn-sm tableShow">表格回显</button>
        <button class="btn btn-default" type="button" onclick="$('.tc ul').html('');">清空已选客户</button>
        </h4>
        <div class="panel-body" style="font-size: 16px;">待发送客户:
        <label><input type="radio" name="selectType" checked="checked" value="1">所有已选择</label>
        <label><input type="radio" name="selectType" value="2">排除已选择</label>
        <label><input type="radio" name="selectType" value="0">所有客户</label>
        </div>
        <div class="panel-body" style="font-size: 16px;">待发送手机类型:
        <label><input type="checkbox" id="mobile" checked="checked">移动</label>
        <label><input type="checkbox" id="unicom" checked="checked">联通</label>
        <label><input type="checkbox" id="telecom">电信</label>
        </div>
        <ul></ul>
        </div>
    </div>
    <div class="zhezhao" style="position: fixed;left: 0;right: 0;top: 0;bottom: 0;background-color: #000;opacity: 0.6;z-index: 990;display: none;"></div></div>

<%-- <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script> --%>
<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/client.js${requestScope.ver}"></script>
<script type="text/javascript">
<!-- 
    $('.tc_top>button,.zhezhao').click(function(){
       $('.tc,.zhezhao').hide();
    });
//-->
</script>
<div id="editpage"></div>
</body>

</html>