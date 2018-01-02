<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<tr>
<th rowspan="2">操作</th>
<th rowspan="2" width="100">状态 </th>
<th colspan="2">灯具安装位置</th>
<th rowspan="2">位置照片</th>
<th rowspan="2">灯具照片</th>
<th rowspan="2">灯具品牌</th>
<th rowspan="2">灯具名称</th>
<th rowspan="2">灯具型号</th>
<th rowspan="2" width="100">数量(套)</th>
<th rowspan="2">光源照片</th>
<th rowspan="2">光源型号</th>
<th rowspan="2">光源名称</th>
<th rowspan="2">光源颜色</th>
<th rowspan="2">数量/套（原配灯具）</th>
<th rowspan="2" style="color: red;">损坏数量</th>
<th colspan="${requestScope.colum}">光源品牌</th>
<th rowspan="2">电器照片</th>
<th rowspan="2">电器名称</th>
<th rowspan="2">电器型号</th>
<th rowspan="2">数量/套（原配灯具）</th>
<th rowspan="2" style="color: red;">损坏数量</th>
<th colspan="${requestScope.colum}">电器品牌</th>
<th rowspan="2" data-bm="bm">客户名称</th>
<%-- <c:if test="${requestScope.autr>=10}"> --%>
<th rowspan="2" data-bm="bm">客户编码</th>
<%-- </c:if> --%>
<%-- <c:if test="${requestScope.autr>=10}"> --%>
<th rowspan="2">体检数据编码</th>
<%-- </c:if> --%>
<th rowspan="2" data-id="seeds_id">id</th>
</tr>
<tr>
<th>大类</th>
<th>小类</th>

<c:if test="${requestScope.autr>=10}">
<th data-bm="bm">产品编码</th>
</c:if>
<th>产品名称</th>
<c:if test="${requestScope.autr>=2}">
<th>单价</th>
</c:if>
<th>推荐采购数量</th>
<c:if test="${requestScope.autr>=10}">
<th data-bm="bm">可用库存</th>
</c:if>

<c:if test="${requestScope.autr>=10}">
<th data-bm="bm">产品编码</th>
</c:if>
<th>产品名称</th>
<c:if test="${requestScope.autr>=2}">
<th>单价</th>
</c:if>
<th>推荐采购数量</th>
<c:if test="${requestScope.autr>=10}">
<th data-bm="bm">可用库存</th>
</c:if>
</tr>