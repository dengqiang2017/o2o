<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%-- 销售退货${requestScope.ver} --%>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
@media(max-width:770px){
.center_div{
width:100%;
}
.p-top ul{
padding-left:0;
}
.num-input-xs{
width:60%;
}
.p-form label {
margin-top: 3px;
}
#rkDate label{
width:100%;
}
#rkDate .Wdate{
float:left; margin-left:2%; width:45%;height:27px
}
#findForm label{
float:left; width:100%;margin-top:2px
}
#findForm .Wdate{
float:left; margin-left:2%; width:45%;height:27px
}
#findForm select{
width:100%
}
/* .pimg-ctn img{ */
/* width: 100%; */
/* height: 200px; */
/* } */
/* .pmsg-ctn ul{margin-left:10px;} */
}
@media(min-width:770px){
/* .pimg-ctn img{ */
/* width: 100%; */
/* height: 200px; */
/* } */
/* .pmsg-ctn ul{ */
/* list-style: none;line-height: 10px;margin-left: -25px;margin-right: 15px; */
/* } */
.p-form{margin-bottom:5px}
.center_div{
width:70%;
margin:auto;
}
#rkDate{
margin-left:66px;
}
#rkDate label{
float:left; width:60px;margin-top:5px
}
#rkDate .Wdate{
float:left; margin-left:2%; width:28%;height:27px
}
#findForm label{
float:left; width:60px;margin-top:2px
}
#findForm .Wdate{
float:left; margin-left:2%; width:28%;height:27px
}
#findForm select{
width:121px;float:left;height:27px
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
	<div class="center_div">
		<div class="ctn-fff box-ctn" style="min-height: 500px;">
			<div class="box-head" style="border:none">
			<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class="active"><a>销售订单</a></li>
			<li class=""><a>销售退货单</a></li>
			</ul>
			<div class="side-cover"></div>
			<div id="finding">
			<div class="form">
				<form id="findForm">
					<div class="col-sm-4 col-lg-3 m-t-b" style="margin-top:20px">
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
					<div class="col-sm-4" style="margin-top:20px;height:30px;" id="rkDate">
						<div class="form-group m-t-b">
							<label for="" style="">查询日期</label>
							<input type="date" class="form-control input-sm Wdate" 
							onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
							style="">
							<span style="float:left; margin-left:2%">~</span>
							<input type="date" class="form-control input-sm Wdate"
							onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
							style="">
						</div>
					</div>
				</form>
			</div>
			</div>
			<div id="finded" style="display: none;">
		<div class="form">
		<form id="findForm">
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
			<div class="col-sm-4" style="margin-top:20px;height:30px;" id="rkDate">
				<div class="form-group m-t-b">
					<label for="" style="">查询日期</label>
					<input type="date" class="form-control input-sm Wdate" 
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
					style="">
					<span style="float:left; margin-left:2%">~</span>
					<input type="date" class="form-control input-sm Wdate"
					onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'})" 
					style="">
				</div>
			</div>
			<div class="col-sm-4" style="margin-top:20px">
			  <div class="form-group m-t-b">
			    <label for="" style="">状态</label>
			    <select class="form-control input-sm" id="confirm_flag">
				        <option value="1">未审核</option>
				        <option value="2">已审核</option>
			     </select>
			   </div>
			 </div>
		</form>
		</div>
		</div>
			</div>
			
			<!-- 列表区域 -->
			<div class="box-body" style="margin-bottom: 100px;">
				<div class="tabs-content" style="display: block;">
				<input type="checkbox" class="check" style="display: none;">
					<div class="ctn">
						
            <div id="list"></div>
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
            <div style="display:none;" id="item">
			<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
		                <input type="hidden" id="ivt_num_detail">
		                <%@include file="proinfo.jsp" %>  
                <div style="border-bottom: 1px solid aqua;">
                <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">单价:</label>
                    <span id="sd_unit_price"></span>元
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">退货数量:</label>
                    <span id="sd_oq_t"></span>/<span class="item_unit"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">销售数量:</label>
	                    <span id="sd_oq"></span>/<span class="item_unit"></span>
	                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">折扣:</label>
                    <span id="discount_rate"></span>%
                  </div>
	              <div class="col-xs-12 col-sm-12 col-md-6">
                    <label for="" data-num="num">退货数量:</label>
					<input type="number" class="num" id="pronum" data-num="num2"> 
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
	                  <label for="">销售金额:</label>
	                  <span>¥</span>
	                  <span class="red" id="sum_si"></span>元
	              </div>
	                  <div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">客户名称:</label>
	                    <input type="hidden" id="customer_id">
	                    <span id="customer_name"></span>
	                  </div>
	                  <div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">退货人:</label>
	                    <span id="kd_name"></span>
	                  </div>
	                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">当前库存:</label>
                    <span id="kc"></span>
                  	</div>
                  	<div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">仓库:</label>
	                   	 <input type="hidden" id="store_struct_id">
	                     <span id="store_struct_name"></span>
	                  </div>
	                  <div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">单号:</label>
	                    <input type="hidden" id="st_hw_no">
	                    <span id="ivt_oper_listing"></span>
	                  </div>
	                  <div class="col-xs-12 col-sm-6 col-md-6">
	                    <label for="">开单时间:</label>
	                    <span id="datetime"></span>
	                  </div>
	             </div>
            </div>
			</div>
		</div>
		<div class="back-top" id="scroll"></div>
		<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span>
			<input type="hidden" id="customer_id">
		<div class="btn-gp">
			<label><input type="checkbox" id="allcheck">全选</label>
			<button class="btn btn-info" id="saveOrder">提交</button>
			 <c:if test="${sessionScope.auth.salesOrder_tuihuoConfirm!=null}">
				<button class="btn btn-info" id="confirm" style="display:none;">审核</button>
			</c:if>
			 <c:if test="${sessionScope.auth.salesOrder_tuihuoNotConfirm!=null}">
			    <button class="btn btn-info" id="return" style="display:none;">弃审</button>
			 </c:if>
			 <c:if test="${sessionScope.auth.salesOrder_tuihuoDel!=null}">
			<button type="button" class="btn btn-info" id="delete" style="display:none;">删除</button>
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
<!-- 			<div class="col-lg-6 col-sm-4 m-t-b"> -->
<!-- 			<div class="form-group"> -->
<!-- 				<label>备注</label> -->
<!-- 				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm"> -->
<!-- 			</div> -->
<!-- 			</div> -->
			<div class="modal-footer">
				<button type="button" class="btn btn-default qx">取消</button>
				<button type="button" id="sure" class="btn btn-primary">确定</button>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
</div>
</div></div>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/salesReturn.js${requestScope.ver}"></script>
</body>
</html>