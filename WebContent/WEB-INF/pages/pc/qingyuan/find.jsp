<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style type="text/css">
   td>span{
   float:left;
}
td>button{
 float:right;
}
@media(max-width:770px){
.minwidth{
       min-width:220px;
}
}
</style>
<div class="folding-btn m-t-b">
	<button type="button" class="btn btn-primary btn-folding btn-sm" style="margin-bottom:10px;display:block;">展开搜索</button>
<!-- 	<button type="button" class="btn btn-danger btn-sm print"><span class="glyphicon glyphicon-share-alt"></span> 打印</button> -->
<c:if test="${sessionScope.auth.plan_excel!=null}">
	<button type="button" class="btn btn-danger btn-sm excel"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
	<button type="button" class="btn btn-danger btn-sm xlsx" style="display: none;"><span class="glyphicon glyphicon-share-alt"></span>导出Excel文件</button>
	</c:if>
</div>
<form style="clear: both; overflow: hidden;">
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">关键词</label> <input type="text"
				class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
		</div>
	</div>
	<div class="col-lg-3 col-sm-4 m-t-b">
		<div class="form-group">
	    	<label>店面</label>
	    	<div class="input-group">
				<span class="form-control input-sm" aria-describedby="basic-addon2" id="clientName" style="max-width: "></span>
				<span class="input-group-btn">
					<button class="btn btn-default btn-sm" type="button">X</button>
			        <button class="btn btn-success btn-sm" type="button" id="clientBtn">浏览</button>
			    </span>
			</div>
	  	</div>
	</div>
	<div class="col-lg-3 col-sm-4 m-t-b">
		<div class="form-group">
	    	<label>供应商</label>
	    	<div class="input-group">
				<span class="form-control input-sm" aria-describedby="basic-addon2" id="vendorName" style="max-width: "></span>
				<span class="input-group-btn">
					<button class="btn btn-default btn-sm" type="button">X</button>
			        <button class="btn btn-success btn-sm" type="button" id="vendorBtn">浏览</button>
			    </span>
			</div>
	  	</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">计划日期</label> <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')}',isShowClear:false})" name="beginDate">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b">
		<div class="form-group">
			<label for="">计划结束日期</label> <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',isShowClear:false})" name="endDate">
		</div>
	</div>
	<div class="col-sm-3 col-lg-2 m-t-b" style="display: none;" id=zhuijia>
		<div class="form-group">
			<label>追加时间点</label>
			<input type="time"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'HH:mm:ss',isShowClear:false})">
		</div>
	</div> 
	<div class="col-sm-3 col-lg-12 m-t-b">
		<button type="button" class="btn btn-primary btn-sm find"
			style="margin-top: 25px;margin-bottom:10px;display:block;">搜索</button>
			<c:if test="${sessionScope.auth.plan_excel!=null}">
<!-- 			<button type="button" class="btn btn-danger btn-sm print" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>打印</button> -->
			<button type="button" class="btn btn-danger btn-sm excel" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span>导出</button>
			<button type="button" class="btn btn-danger btn-sm xlsx" style="margin-top:25px;display: none;"><span class="glyphicon glyphicon-share-alt"></span>导出Excel文件</button>
			</c:if> 
	</div> 
</form>
