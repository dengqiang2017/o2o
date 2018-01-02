<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 销售开单 -->
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
@media(max-width:770px){
.center_div{
width:100%;
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
}
@media(min-width:770px){
.center_div{
width:70%;
margin:auto;
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
.m-t-b .input-group{width: 100%}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
	<%@include file="selClient.jsp" %>
	 <div class="center_div">
		<div class="ctn-fff box-ctn">
			<div class="box-head">
				<%@include file="showSelectClient.jsp"%>
				<div class="form-inline">
					<div class="col-sm-4 col-lg-6 m-t-b">
						<div class="form-group"  style="width: 100%;">
							<label  for="exampleInputEmail1" style="color: red;">*仓库/提货地点(必选择项)</label>
							<div class="input-group">
								<input type="text" id="didian" class="form-control" placeholder="仓库选择">
								<span id="store_struct_id" style="display: none;"></span>
								<span class="input-group-btn">
									<button type="button" class="btn btn-info" id="thdixz">选择</button>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-4 col-lg-3 m-t-b">
						<div class="form-group" style="width: 100%;">
							<label for="exampleInputEmail1">结算方式</label> 
							<div class="input-group">
							<input type="text" class="form-control" id="settlement_type_name" placeholder="请选择结算方式">
							<span id="settlement_type_id" style="display: none;"></span>
							<span class="input-group-btn">
								<button type="button" class="btn btn-info" id="jiesuan">选择</button>
							</span>
							</div>
						</div>
					</div>
					<div class="col-sm-4 col-lg-3 m-t-b">
						<div class="form-group">
						<label  for="exampleInputEmail1">送货司机(可直接输入)</label>
						<div class="input-group">
							<input type="text" class="form-control" placeholder="送货司机姓名-电话" id="driverinfo">
							<span class="input-group-btn">
								<button type="button" class="btn btn-info" id="drivexz">选择</button>
							</span>
						</div>
						</div>
					</div>
					<div class="col-sm-4 col-lg-3 m-t-b">
						<div class="form-group">
						<label  for="exampleInputEmail1">车牌号</label>
						<input type="text" class="form-control" style="width: 100%" placeholder="车牌号" id="Kar_paizhao">
						</div>
					</div>
					<div class="col-sm-4 col-lg-3 m-t-b">
						<div class="form-group" style="width: 100%;">
							<label for="exampleInputEmail1">物流方式</label> 
							<select class="form-control" style="width: 100%;" id="wlfs">
								<optgroup label="公司库房">
									<option value="0-1" selected="selected">公司配送</option>
									<option value="0-2">客户自提</option>
									<option value="0-3">第三方物流配送</option>
								</optgroup>
								<optgroup label="供应商库房">
									<option value="1-1">公司配送</option>
									<option value="1-2">客户自提</option>
									<option value="1-3">第三方物流配送</option>
									<option value="1-4">供应商配送</option>
								</optgroup>
							</select>
						</div>
					</div>
					<div class="col-sm-4 col-lg-3 m-t-b">
					 <div class="form-group">
						<label  for="exampleInputEmail1">发货时间</label>
							<input type="datetime" style="width: 100%;" id="fhtime" class="form-control Wdate" placeholder="发货时间" 
							onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm'})">
						</div>
					</div>
				</div>
				<div class="form-inline">
				<div class="col-sm-4 col-lg-3 m-t-b">
					 <div class="form-group" style="width: 100%;">
						<label  for="exampleInputEmail1">收货人姓名-电话(可直接输入)</label>
						<div class="input-group">
							
							<div class="input-group-btn">
								<div class="dropup">
								  <button class="btn btn-default dropdown-toggle" type="button" disabled="disabled"
								  id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
								    选择
								    <span class="caret"></span>
								  </button>
								  <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
								  </ul>
								</div>
							</div>
							<input type="text" style="margin-left: -17px;" class="form-control" placeholder="收货人姓名-电话" id="fhr">
						</div>
						</div>
					</div>
					<div class="col-sm-4 col-lg-6 m-t-b">
						<label  for="exampleInputEmail1">收货地址(可直接输入)</label>
						<input type="text" style="width: 100%;" class="form-control" placeholder="收货地址" id="shdz">
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="center_div">
		<div class="ctn-fff box-ctn" style="min-height: 500px;">
			<div class="box-head" style="border:none">
			<ul class="nav nav-tabs" style="margin-top: 10px;">
			<li class=""><a>报价单</a></li>
			<li class=""><a>销售订单</a></li>
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
					<label for="">查询日期</label>
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
						<div style="display:none;" id="item">
						<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
		                <input type="hidden" id="ivt_num_detail">
		         <%@include file="proinfo.jsp" %>        
                <div style="border-bottom: 1px solid aqua;">
                  <div class="col-xs-12 col-sm-12 col-md-6">
                    <label for="sd_unit_price">单价</label>
                    <input type="number" id="sd_unit_price" data-num="num2">
                  </div>
                  <div class="col-xs-12 col-sm-12 col-md-6">
                    <label for="">折扣</label>
                    <input type="number" id="discount_rate" data-num="num">%
                  </div>
                    <div class="col-xs-12 col-sm-12 col-md-6" id="ddNum">
                    <label for="pronum">数量</label>
					<input type="number" class="num" id="pronum" data-num="num"> 
                    <span id="hav_rcv"></span><span class="item_unit"></span>
                  </div>
                  <div class="col-xs-12 col-sm-12 col-md-6">
					<label for="">折算数量</label>
					<span id="pack_unit" style="display: none;"></span>
					<input type="number" class="zsum" data-num="num2" disabled="disabled">
					<span id="casing_unit"></span>
				</div>
                   <div class="col-xs-12 col-sm-6 col-md-6" >
                    <label for="">单价</label>
                    <span id="sd_unit_price_o"></span>元
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">数量</label>
                    <span id="sd_oq"></span>/<span class="item_unit"></span>
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">折算数量</label>
                    <span id="zsum_o"></span>/<span class="casing_unit"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">折扣</label>
                    <span id="discountRate"></span>%
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">金额:</label>
                  	<span>¥</span><span id="sum_si"></span>元
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">仓库:</label>
                   	 <input type="hidden" id="store_struct_id">
                     <span id="store_struct_name"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6" >
                    <label for="">当前库存:</label>
                    <span id="kc" ></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">客户名称</label>
                    <span id="customer_name"></span>
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">单号</label>
                    <span id="ivt_oper_listing"></span>
                 </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">开单时间</label>
                    <span id="datetime"></span>
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="">开单人</label>
                    <span id="kd_name"></span>
                  </div>
                </div>
            </div>
            </div>
            <div id="list"></div>
			</div>
			<div class="ctn" style="display: none;">
	        <button class="btn btn-add" type="button">点击加载更多</button>
	        </div>
				</div>
                <div class="tabs-content" style="display: block;">
           		<div id="list"></div>
       			<div class="ctn" style="display: none;">
         			<button class="btn btn-add" type="button">点击加载更多</button>
       			</div>
         </div>
            </div>
			</div>
		</div>
		<div class="back-top" id="scroll"></div>
		<div class="footer">
		员工:${sessionScope.userInfo.personnel.clerk_name}<span
			class="glyphicon glyphicon-earphone"></span> <input type="hidden"
			id="customer_id">
		<div class="btn-gp">
			<label><input type="checkbox" id="allcheck">全选</label>
			<button class="btn btn-info" id="saveOrder">提交</button>
			<c:if test="${sessionScope.auth.salesOrder_kdConfirm!=null}">
				<button class="btn btn-info" id="confirm" style="display:none;">审核</button>
			</c:if>
			<c:if test="${sessionScope.auth.salesOrder_kdNotConfirm!=null}">
				<button class="btn btn-info" id="return" style="display:none;">弃审</button>
			</c:if>
			<c:if test="${sessionScope.auth.salesOrder_kdDel!=null}">
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
		    	<span class="form-control input-sm" id="dept_name" aria-describedby="basic-addon2">${sessionScope.userInfo.personnel.dept_name}</span>
					<span class="input-group-btn">
		    			<input id="deptId" type="hidden"  name="dept_id" value="${sessionScope.userInfo.personnel.dept_id}">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm dept" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
		  	<div class="form-group">
		    	<label>经办人</label>
		    	<div class="input-group">
		    	<span class="form-control input-sm" id="clerk_name" aria-describedby="basic-addon2">${sessionScope.userInfo.personnel.clerk_name}</span>
					<span class="input-group-btn">
		    			<input id="clerkId" type="hidden"  name="clerk_id" value="${sessionScope.userInfo.clerk_id}">
				        <button class="btn btn-default btn-sm" type="button">X</button>
				        <button class="btn btn-success btn-sm clerk" type="button">浏览</button>
				    </span>
			</div>
		  	</div>
<!-- 			<div class="col-lg-12 col-sm-12 m-t-b"> -->
<!-- 			<div class="form-group"> -->
<!-- 				<label>备注</label> -->
<!-- 				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm"> -->
<!-- 			</div> -->
<!-- 			</div> -->
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
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/xso2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/salesOrder.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/choiceCustomer.js${requestScope.ver}"></script>
</body>
</html>