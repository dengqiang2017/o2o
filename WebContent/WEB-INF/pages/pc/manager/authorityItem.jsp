<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="container">
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height: 750px;">
<div class="box-head">
	<ul>
		<li>您正在为&emsp;<span></span>&emsp;授权
		</li>
	</ul>
	<ul class="qx-list">
<%-- 						<li><div class="pro-check ${requestScope.auth.add}"> --%>
<!-- 								<span style="display: none;">add</span> -->
<!-- 							</div> -->
<!-- 							<span>增加</span></li> -->
<%-- 						<li><div class="pro-check ${requestScope.auth.del}"> --%>
<!-- 								<span style="display: none;">del</span> -->
<!-- 							</div> -->
<!-- 							<span>删除</span></li> -->
<%-- 						<li><div class="pro-check ${requestScope.auth.edit}"> --%>
<!-- 								<span style="display: none;">edit</span> -->
<!-- 							</div> -->
<!-- 							<span>修改</span></li> -->
<li><div class="pro-check auth" id="excelImp">
	<span style="display: none;">excelImp</span>
	</div>
	<span>导入</span></li>
<li><div class="pro-check auth" id="excel">
	<span style="display: none;">excel</span>
	</div>
	<span>导出</span></li>
<li><div class="pro-check auth" id="comfirm_flag">
	<span style="display: none;">comfirm_flag</span>
	</div>
	<span>审核</span></li>
<li><div class="pro-check auth" id="qxfp">
	<span style="display: none;">qxfp</span>
	</div>
	<span>权限分配</span></li>
<li><div class="pro-check auth" id="qxcopy">
	<span style="display: none;">qxcopy</span>
	</div>
	<span>权限复制</span></li>
<li><div class="pro-check auth" id="uploadHelpFile">
	<span style="display: none;">uploadHelpFile</span>
	</div>
	<span>上传帮助文件</span></li>
<li><div class="pro-check auth" id="delHelpFile">
	<span style="display: none;">delHelpFile</span>
			</div>
			<span>删除帮助文件</span></li>
	</ul>
</div>
<div class="box-body">
	<div class="">
<c:forEach items="${requestScope.auths}" var="auth">
<c:if test="${auth.checked==true}">
<dl class="col-sm-3">
<c:if test="${auth.nextClass!=null}">
<!-- 上级权限 -->
<dt>
	<span class="pro-check auth" id="${auth.name}"><span style="display: none;">${auth.name}</span></span>${auth.name_ch}
</dt>
<c:forEach items="${auth.nextClass}" var="nextauth">
<!-- 下级权限 -->
<c:if test="${nextauth.checked==true&&nextauth.name!=''}">
    <dd>
	<div class="pro-check auth" id="${nextauth.name}">
		<span style="display: none;">${nextauth.name}</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-33.png" alt="">
	</div>
	<span class="dltitle">${nextauth.name_ch}</span>
	</dd>
</c:if>
</c:forEach>
</c:if>
</dl>
</c:if>
</c:forEach>
</div>
				</div>
			</div>
		</div>
	</div>
</div>