<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 采购退货单 -->
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
@media(max-width:770px){
.Wdate{display: inline-block !important;width: 45% !important;
}
select{display: inline-block !important;width: 80% !important;}
}
@media(min-width:770px){
#cpDate{width: 400px;}
#cpDate label{float:left; width:60px;margin-top:5px}
#findForm label{float:left; width:auto;margin-top:2px}
.Wdate{float:left; margin-left:2%; width:40%;height:27px;}
#findForm .col-sm-3{width: 160px;}
#findForm select{width:121px;float:left;height:30px;}
@media(max-width:769px){
#cpDate label{
width:100%;
} 
#findForm select{
width:100%
}
.label {
margin-top: 3px;
}
}
.modal-footer button{
 margin-top:10px;
}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
     <div class="container" id="excel" style="display:none;">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
        	<a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
			<input type="file" id="xlspurchasingSheet" name="xlspurchasingSheet" onchange="excelImport(this,'purchasingSheet');"></a>
			<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('purchasingSheet');">导出</button>
        </div> 
      </div>
    </div>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
      	<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class="active"><a>入库单</a></li>
			<li class=""><a>采购退货单</a></li>
			</ul>
		<div class="side-cover"></div>
		<div id="finding">
		<div class="form">
			<form id="findForm">
			<div class="col-sm-6" style="margin-top:20px;" id="cpDate">
			<div class="form-group m-t-b">
				<label for="" style="">查询日期</label>
				<div>
				<input type="date" class="form-control input-sm Wdate" 
				onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
				<input type="date" class="form-control input-sm Wdate"
				onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
				</div>
			</div>
		</div>
			<div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px;" id="search">
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
	   <div id="findPlan" style="display:none;">
			<div class="form">
			<form id="findForm">
			<div class="col-sm-4" style="margin-top:20px;" id="cpDate">
				<div class="form-group m-t-b">
					<label for="">查询日期</label>
					<div>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})">
					</div>
				</div>
			</div>
			<div class="col-sm-3" style="margin-top:20px">
			  <div class="form-group m-t-b">
			    <label for="" >状态</label>
			    <select class="form-control" id="confirm_flag" >
				        <option value="1">未审核</option>
				        <option value="2">已审核</option>
			     </select>
			   </div>
			 </div>
			 <div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px;" id="search">
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
                
				<div id="list">
				</div>
                </div>
                <div class="ctn" style="display: none;">
         		<button class="btn btn-add" type="button">点击加载更多</button>
          		</div>
          </div>
       		<div class="tabs-content" style="display: block;">
           		<div id="list"></div>
       			<div class="ctn" style="display: none;">
         			<button class="btn btn-add load" type="button">点击加载更多</button>
       			</div>
         </div>
       <div id="item" style="display: none;">
				<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
	                <input type="hidden" id="sid">
	                <input type="hidden" id="seeds_id">
	                <input type="hidden" id="mps_id">
	                <%@include file="proinfo.jsp" %>
					<div style="border-bottom: 1px solid aqua;">
			            <div class="col-xs-6 col-sm-6 col-md-6" id="getPrice">
		                    <label for="">单价</label>
		                    <span id="price"></span>元
			            </div>
			            <div class="col-xs-6 col-sm-6 col-md-6">
							<label>入库数量</label><span id="rukuNum"></span>/<span class="item_unit"></span>
						</div>
			            <div class="col-xs-6 col-sm-6 col-md-6">
							<label>采购数量</label><span id="cgsl"></span>/<span class="item_unit"></span>
						</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<label>当前库存</label><span id="use_oq"></span>/<span class="item_unit"></span>
						</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<label>退货数量</label><span id="threp_qty"></span>/<span class="item_unit"></span>
						</div>
						<div class="col-xs-5 col-sm-6 col-md-6">
							<label>折扣</label><span id="zk"></span>% 
						</div>
			            <div class="col-xs-7 col-sm-12 col-md-6">
							<label for="">退货数量</label> 
							<input type="number" class="num" name="rep_qty" data-num="num2" id="repQty">
							<input type="hidden" name="pack_unit" id="pack_unit">
						</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<label>金额</label><span>¥</span><span id="thst_sum"></span>元
						</div>
							<div class="col-xs-6 col-sm-6 col-md-6">
							<label>退货金额</label><span>¥</span><span id="stSum"></span>元
							</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<input type="hidden" id="vendor_id">
							<label>供应商</label><span id="corp_name"></span>
						</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<label>电话</label><span id="movtel"></span>
						</div>
							<div class="col-xs-12 col-sm-6 col-md-6">
							<input type="hidden" id="store_struct_id">
							<label>所在仓库</label><span id="storeStruct" style="font-size: 14px;"></span>
						</div>
							<div class="col-xs-12 col-sm-6 col-md-6">
							<label for="">入库单号</label><span id="st_auto_no"></span>
							</div>
							<div class="col-xs-8 col-sm-6 col-md-6">
								<label>入库日期</label><span id="rukuTime"></span> 
							</div>
							<div class="col-xs-4 col-sm-6 col-md-6">
	                  			<label for="">经办人</label>
	                  			<span id="jb_name"></span>
	                			</div>
						<div class="col-xs-12 col-sm-6 col-md-6">
							<label>订货单号</label><span id="cgno"></span>
						</div>
						<div class="col-xs-6 col-sm-6 col-md-6">
							<label>订货日期</label><span id="cgrq" style="font-size: 12px;"></span>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-6">
							<input type="hidden" id="st_auto_no">
							<label for="">退货单号</label><span id="thrcv_auto_no"></span>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-6">
							<label>退货日期</label><span id="thDate" style="font-size: 12px;"></span> 
						</div>
						<div class="col-xs-12 col-sm-6 col-md-6">
							<label>备注</label><span id="c_memo"></span>
						</div>
					</div>
				</div>
		</div></div>
     </div>
   </div>
   <div class="back-top" id="scroll"></div>
   <div class="footer">
     员工:${sessionScope.userInfo.personnel.clerk_name}&emsp;<span class="glyphicon glyphicon-earphone"></span>
		<div class="btn-gp">
       <label><input type="checkbox" id="allcheck">全选</label>
       <button class="btn btn-info" id="returnOrder">提交</button>
       <c:if test="${sessionScope.auth.purchase_tuihuoConfirm!=null}">
        <button class="btn btn-info" id="confirm"  style="display:none;">审核</button>
        </c:if>
       <c:if test="${sessionScope.auth.purchase_tuihuoNotConfirm!=null}">
         <button class="btn btn-info" id="return" style="display:none;">弃审</button>
       </c:if>
       <c:if test="${sessionScope.auth.purchase_tuihuoDel!=null}">
       <button class="btn btn-info" id="delete" style="display:none;">删除</button>
       </c:if>
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
			<div class="col-lg-12 col-sm-12 m-t-b">
			<div class="form-group">
				<label>备注</label>
				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm" maxlength="100">
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
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/purchaseReturn.js${requestScope.ver}"></script>
</body>
</html>