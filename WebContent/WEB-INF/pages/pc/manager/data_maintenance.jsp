<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<dl>
	<dt>
		<span class="pro-check ${requestScope.auth.data_maintenance}">
<span style="display: none;">data_maintenance</span>
	</span>
	资料维护
</dt>
<dd>
	<div class="pro-check ${requestScope.auth.dept_maintenance}">
<span style="display: none;">dept_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-12.png" alt="">
	</div>
	<span class="dltitle">部门维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.queryInventory}">
<span style="display: none;">queryInventory</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">期末库存查询</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.personnel_maintenance}">
<span style="display: none;">personnel_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-13.png" alt="">
	</div>
	<span class="dltitle">员工维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.weixinsyn}">
<span style="display: none;">weixinsyn</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-13.png" alt="">
	</div>
	<span class="dltitle">同步微信账号的员工中</span>
</dd>
	<dd>
	<div class="pro-check ${requestScope.auth.settlement_maintenance}">
<span style="display: none;">settlement_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-40.png" alt="">
	</div>
	<span class="dltitle">结算方式维护</span>
</dd>
 <dd>
	<div class="pro-check ${requestScope.auth.quhua_maintenance}">
<span style="display: none;">quhua_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-01.png" alt="">
	</div>
	<span class="dltitle">行政区划</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.client_maintenance}">
<span style="display: none;">client_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-05.png" alt="">
	</div>
	<span class="dltitle">客户维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.room_maintenance}">
<span style="display: none;">room_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-31.png" alt="">
	</div>
	<span class="dltitle">库房维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.class_maintenance}">
<span style="display: none;">class_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-03.png" alt="">
	</div>
	<span class="dltitle">产品类别</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.product_maintenance}">
<span style="display: none;">product_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-03.png" alt="">
	</div>
	<span class="dltitle">产品维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.gys_maintenance}">
<span style="display: none;">gys_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-31.png" alt="">
	</div>
	<span class="dltitle">供应商维护</span>
</dd>
<c:if test="${sessionScope.o2o=='jiaju'}">
<dd>
	<div class="pro-check ${requestScope.auth.operate_maintenance}">
<span style="display: none;">operate_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-31.png" alt="">
	</div>
	<span class="dltitle">运营商维护</span>
</dd>
</c:if>
<dd>
	<div class="pro-check ${requestScope.auth.qichu_maintenance}">
<span style="display: none;">qichu_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">期初维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.siji_maintenance}">
<span style="display: none;">siji_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">司机维护</span>
</dd>
<c:if test="${sessionScope.o2o=='jiaju'}">
<dd>
	<div class="pro-check ${requestScope.auth.dian_maintenance}">
<span style="display: none;">dian_maintenance</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">电工维护</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.brandOfOrigin}">
<span style="display: none;">brandOfOrigin</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">产地品牌</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.accountingSubjects}">
<span style="display: none;">accountingSubjects</span>
	</div>
	<div class="dlimg">
		<img src="../pcxy/image/xs-function-06.png" alt="">
	</div>
	<span class="dltitle">会计科目</span>
</dd>
</c:if>
<dd>
	<div class="pro-check ${requestScope.auth.add_maintenance}">
<span style="display: none;">add_maintenance</span>
	</div>
	<span class="dltitle">增加</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.edit_maintenance}">
<span style="display: none;">edit_maintenance</span>
	</div>
	<span class="dltitle">修改</span>
</dd>
<dd>
	<div class="pro-check ${requestScope.auth.del_maintenance}">
<span style="display: none;">del_maintenance</span>
		</div>
		<span class="dltitle">删除</span>
	</dd>
	
</dl>



