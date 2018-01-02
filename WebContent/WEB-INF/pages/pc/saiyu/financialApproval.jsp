<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
<script src="../pc/js/saiyu/tijian.js${requestScope.ver}"></script>
<script src="../pc/js/saiyu/financialApproval.js${requestScope.ver}"></script>
<style>
    @media screen and (max-width:770px){
        .form-size{
            width:90%;margin: auto
        }
    }
    @media screen and (min-width:770px){
        .form-size{
            width: 25%;margin: auto
        }
    }
</style> 
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a>
          &emsp;用户中心-><span><a href="javaScript:backOa();">我的协同</a>-></span><span>协同审批</span></div>
 <input type="hidden" id="seeds_id" value="${requestScope.seeds_id}"> 
 <input type="hidden" id="spNo" value="${requestScope.spNo}">
 <input type="hidden" value="${requestScope.approval_step}" id="approval_step">
 <input type="hidden" id="customer_id" value="${requestScope.upper_customer_id}">
 <div class="col-xs-12" style="margin-bottom: 30px">
<div class="secition-two">
<button type="button" class="btn btn-primary btn0">查询</button>
<div class="ctn-fff box-ctn" style="display:none">
	<div class="box-head"><h4 class="pull-left">客户体检列表</h4>
    </div>
<input type="hidden" id="page" name="page" value="0">
<input type="hidden" id="totalPage" value="0">
<input type="hidden" id="customer_id" value="${requestScope.customer_id}">
<input type="hidden" id="spNo" value="${requestScope.spNo}">
</div>
<div class="box-body">
	<div class="table-responsive" id="box">
<input type="hidden" id="select_treeId">
	<table class="table table-bordered" id="tab">
		<thead>
			<%@include file="tijianthead.jsp" %>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>
<div class="box-footer">
	<div class="pull-right" style="margin-top: 20px">
<input type="text" id="page" value="0" style="width: 50px;">
总页数<span id="totalPage"></span>
    <button type="button" class="btn btn-info btn-sm" id="beginpage"  style="padding: 5px;margin-right: 5px;">首页</button>
	    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
	    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
	    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
	</div>
</div>
<!--      <div class="dc" > -->
<!--      <div class="secition-three-2" style="margin-top: 60px">有疑问？请联系我们 -->
<!--      <a onclick="zhixun();">联系赛宇</a> -->
<!-- 	</div> -->
<!--     </div> -->
</div>
</div>
<h4 class="center-h4">合计：¥<span id="sunSi"></span>元</h4>
<h4 class="text-center" style="padding: 10px 0">采购【${requestScope.corp_sim_name}】电话：${requestScope.phone}</h4>
<form class="form-horizontal form-size">
            <div class="form-group">
                <label class="col-lg-3 text-right" style="line-height: 30px">审批意见：</label>
                <div class="col-lg-9">
                <select class="select-css form-control" id="spyj">
                    <option value="同意">同意</option>
                    <option value="不同意">不同意</option>
                </select>
                </div>
            </div>
        </form>
<div>
<button type="button"  class="btn  center-block btn-lg btn-primary center-btn" id="save" style="margin-top: 20px">确认无误提交</button>
</div>
    <div class="modal" id="mymodal">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">查询</h4>
    </div>
    <div class="modal-body">
    <div class="form">
    <form id="findForm">
    <div class="col-lg-12 col-sm-3">
    <label>位置大类</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="position_big">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>灯具名称</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="item_name">
    </div>
    <div class="col-lg-12 col-sm-3" >
    <label>状态</label>
    <select class="form-control input-sm" id="workState">
    <option value="报修">报修</option>
    <option value="审批">审批</option>
    </select>
    </div>
    <div class="col-sm-3 col-lg-12">
    <div class="form-group">
    <div class="input-group">
    <label>&nbsp;</label>
    <input type="text" class="form-control input-sm" maxlength="50" placeholder="请输入搜索关键词" id="searchKey"> <span class="input-group-btn">
    <button class="btn btn-success btn-sm find" style="margin-top: 26px" type="button">搜索</button>
    </span>
    </div>
    </div>
    </div>
    <div style="clear:both"></div>
    </form>
    </div>
    </div>
    <div class="modal-footer">
    </div>
    </div>
    </div>
    </div>