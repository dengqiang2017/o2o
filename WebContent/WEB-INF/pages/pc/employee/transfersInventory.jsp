<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp"%>
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
.pmsg-ctn>ul>li {
margin-bottom: 15px;
overflow: hidden;
text-overflow: ellipsis;
white-space: nowrap;
}
@media(max-width:770px){
.center_div{
width:100%;
}
.p-form label {
margin-top: 3px;
}
#ddCost{
   margin-bottom:5px
  }
.p-top ul{
padding-left:0;
}
.num-input-xs{
width:60%;
}
#cpDate label{
width:100%;
}
#cpDate .Wdate{
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
}
@media(min-width:770px){
.center_div{
width:70%;
margin:auto;
}
#rkDate{
margin-left:66px;
}
#cpDate label{
float:left; width:60px;margin-top:5px
}
#cpDate .Wdate{
float:left; margin-left:2%; width:28%;
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
   #cop{
    margin-bottom:63px !important;
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
			<li class=""><a>仓库产品</a></li>
			<li class=""><a>调拨单</a></li>
			</ul>
			<div class="side-cover"></div>
			<div id="finding">
			<%@include file="find.jsp" %>
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
			    <select class="form-control input-sm" id="confirm_flag" style="">
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
			<div class="box-body">
				<div class="tabs-content" style="display: block;">
				<input type="checkbox" class="check" style="display: none;">
					<div class="ctn">
						<div style="display:none;" id="item">
              	<div class="col-xs-12 col-sm-12 col-md-6 dataitem">
              			<%@include file="proinfo.jsp" %>
                <div style="border-bottom: 1px solid aqua;">
                   <div class="col-xs-12 col-sm-6 col-md-6" id="danjia">
                    <label for="">单价</label>
                    <span id="itemCost"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6" id="danjiaval">
                    <label for="">单价</label>
						<input type="number" id="item_cost" data-num="num2">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6" id="ddNum">
                    	<label for="" >调入数量</label>
						<input type="number" class="num" id="pronum" data-num="num"><span class="item_unit"></span>
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6" id="cgNum">
                    <label for="">调入数量</label>
                    <span id="hav_rcv"></span>/<span class="item_unit"></span>
                  </div>
                   <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="" >金额</label>
                  <span>¥</span><span id="sum_si"></span>元
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6">
                    <label for="" >调出仓库</label>
                   	 <input type="hidden" id="store_struct_id">
                     <span id="store_struct_name"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-3">
                    <label for="">当前库存</label>
                    <span id="kc"></span>
                  </div>
                    <div class="col-xs-12 col-sm-12 col-md-9" id="storeStruct">
                     <div class="form-group">
				    	<label style="float: left;">调入仓库</label>
				    	<div class="input-group" style="float: left;width: 80%;">
							<span class="form-control input-sm" id="store_name" aria-describedby="basic-addon2"></span>
							<span class="input-group-addon clearSelect" id="sizing-addon2">X</span>
							<span class="input-group-addon store" id="sizing-addon2" style="cursor: pointer;">浏览</span>
							<input id="storeId" type="hidden" name="store_id">
						</div>
						<div class="clearfix"></div>
				  	</div>
				</div>
               <div class="col-xs-12 col-sm-6 col-md-6" id="gysselect">
				  	<div class="form-group">
				    	<label style="float: left;">供应商</label>
				    	<div class="input-group" style="float: left;width: 80%;">
							<span class="form-control input-sm corp_name" aria-describedby="basic-addon2"></span>
							<span class="input-group-addon clearSelect" id="sizing-addon2">X</span>
							<span class="input-group-addon gys" id="sizing-addon2" style="cursor: pointer;">浏览</span>
							<input class="corp_id" type="hidden" name="corp_id">
						</div>
						<div class="clearfix"></div>
				  	</div>
				</div>
				<div class="col-xs-12 col-sm-6 col-md-6" id="drck">
                    <label for="">调入仓库</label>
                    <input id="storeId" type="hidden">
                    <span id="store_name"></span>
                  </div>
                <div class="col-xs-12 col-sm-6 col-md-6" id="gyshtml">
                  <label for="" >供应商</label>
                  <input type="hidden" class="corp_id" name="corp_id">
                  <span id="corp_name"></span>
                </div>
                <div class="col-xs-12 col-sm-6 col-md-6" id="dbdh">
                    <label for="" >调拨单号</label>
                    <span id="ivt_oper_listing"></span>
                 </div>
                   <div class="col-xs-12 col-sm-6 col-md-6" id="dbr">
                    <label for="" >调拨人</label>
                    <span id="db_name"></span>
                  </div>
                  <div class="col-xs-12 col-sm-6 col-md-6" id="cMemo">
					<label for="">备注</label>
					<span id="c_memo"></span>
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
         			<button class="btn btn-add load" type="button">点击加载更多</button>
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
			<c:if test="${sessionScope.auth.inventory_dbConfirm!=null}">
			<button class="btn btn-info" id="confirm" style="display:none;">审核</button>
			<button class="btn btn-info" id="return" style="display:none;">弃审</button>
			</c:if>
			<button type="button" class="btn btn-info" id="delete" style="display:none;">删除</button>
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
				<input id="c_memo" type="text" name="c_memo" class="form-control input-sm">
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

<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script> 
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/transfersInventory.js${requestScope.ver}"></script>
</body>
</html>