<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../pcxy_res.jsp" %>
<script src="../js_lib/jquery-ui.js"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/proPageList.js${requestScope.ver}"></script>
<link rel="stylesheet" href="/product/contant.css${requestScope.ver}">
<style type="text/css">
.glyphicon-ok{color: red;}
.dropdown{display: inline-block;}
.dropdown-toggle{width: 20px;height: 20px;color: grey;}
.caret{margin-left: -3px !important;margin-top: -15px;}
.table-responsive{min-height: 400px;}
</style>
</head>
<body>
<div class="bg"></div>
<div id="listpage">
<%@include file="../header.jsp" %>
<div class="left-hide-ctn">
	<form id="findForm">
 <div class="pull-left">
	<div class="form-group">
	<label>物料来源</label>
	<select id="item_style" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>品牌</label>
	<select id="class_card" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>质量等级</label>
	<select id="quality_class" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>型号</label>
	<select id="item_type" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>结构</label>
	<select id="item_struct" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>颜色</label>
	<select id="item_color" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>规格</label>
	<input type="text" id="item_spec" class="form-control input-sm" maxlength="30" style="display: inline-block;width: auto;">
	</div>
</div>
<div class="pull-left">
	<div class="form-group" style="max-width: 220px;">
		<div class="input-group">
			<input type="text" class="form-control input-sm" maxlength="50"
				placeholder="请输入搜索关键词" id="searchKey"> <span
				class="input-group-btn">
				<button class="btn btn-success btn-sm find" type="button">搜索</button>
			</span>
		</div>
	</div>
</div><div class="clearfix"></div>
	</form>
	<div class="tree">
		<ul>
			<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
		<ul>
		<c:forEach items="${requestScope.clss}" var="cls">
		<li class="parent_li"><span  class="client_tree"><i class="glyphicon glyphicon-minus-sign"></i>${cls.sort_name}
		<input type="hidden" value="${cls.sort_id}"></span></li>
		</c:forEach>
		</ul>
		</ul>
	</div>
</div>
<div class="cover"></div>
<div class="contaner" id="dibu">
	<div class="ctn-fff box-ctn" style="height:750px;">
		<div class="box-head">
			<button type="button" id="manager_expand" class="btn btn-primary btn-sm m-t-b">展开搜索</button>
			<c:if test="${requestScope.auth.add_maintenance!=null}">
			<a id="addpro" class="btn btn-success btn-sm m-t-b">增加</a>
			</c:if>
		<c:if test="${requestScope.auth.excelImp!=null}">
			<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
			<input type="file" id="xlsprod" name="xlsprod" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" onchange="excelImport(this,'prod');"></a>
		</c:if>
			<c:if test="${requestScope.auth.excel!=null}">
			<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('prod');">导出</button>
		</c:if>
  		</div>
  					<input type="hidden" id="del_hi" value="${requestScope.auth.del_maintenance!=null}">
			<input type="hidden" id="edit_hi" value="${requestScope.auth.edit_maintenance!=null}">
		<div class="box-body">
			<div class="table-responsive lg-table">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered" id="table">
					<thead>
						<tr>  
					       <th width="100">操作 </th>
					       <%@include file="list.jsp" %>
					    </tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>

		<div class="box-footer">
			<div class="form-inline">
				<div class="form-group pull-left">
				    <label>总共:</label>
				    <span id="totalRecord"></span>
				</div>
			</div>
			<div class="pull-right">
			当前页:<input type="tel" id="page" value="0" data-number="num" style="width: 50px;">
			总页数<span id="totalPage"></span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>	
		</div>	
	</div>
</div>

<div class="footer">
	 员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</div>
<div style="display: none;" id="dropdown">
  <div class="dropdown">
  <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenu">
    <li><a><span class="glyphicon glyphicon-ok" data-val=""></span>&emsp;全部</a></li>
    <li role="separator" class="divider"></li>
    <li><a><span class="glyphicon" data-val="='0'"></span>&emsp;等于0</a></li>
    <li><a><span class="glyphicon" data-val=">'0'"></span>&emsp;大于0</a></li>
  </ul>
</div>
</div>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/editUtils.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/product.js${requestScope.ver}"></script>

<script type="text/javascript" charset="utf-8" src="/baidu/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="/baidu/ueditor.all.min.js"> </script>
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8" src="/baidu/lang/zh-cn/zh-cn.js"></script>
<div id="editpage"></div>
<div id="detailpage" style="display: none;">
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="header">
			<a class="header_left">返回</a> 产品详情图文编辑<div class="pull-right"><button type="button" class="btn btn-info" id="save">保存编辑</button></div>
		</div>
	</nav>
<div>
<h3>产品名称:<span id="item_name"></span></h3>
<script id="editor" type="text/plain" style="width:100%;"></script>
</div>
<script type="text/javascript">
<!--
$("#editor").css("height",window.screen.height-200);
//-->
</script>
<script type="text/javascript" src="/baidu/baiduedit.js${requestScope.ver}"></script>
<script type="text/javascript" src='/product/articleDialog.js${requestScope.ver}'></script>
</div>
</body>
</html>

