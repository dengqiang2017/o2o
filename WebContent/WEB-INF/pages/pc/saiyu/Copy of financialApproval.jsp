<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/financialApproval.css${requestScope.ver}">
    <script src="../pc/../pc/js/saiyu/financialApproval.js${requestScope.ver}"></script>
    <div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a>
               &emsp;用户中心-><span><a href="javaScript:backOa();">我的协同</a>-></span><span>采购订单审批</span></div>
    <div class="container-one-heji">
 <div class="secition-one">
 <input type="hidden" id="seeds_id" value="${requestScope.seeds_id}"> 
 <input type="hidden" id="spNo" value="${requestScope.spNo}">
 <input type="hidden" id="customer_id" value="${requestScope.upper_customer_id}">
        <button type="button" class="btn btn-primary btn-lg center-block">点此查看报修信息</button>
    </div>
    <div class="container-one-lg">
    <div id="puritem" style="display: none;">
    	<div class="col-lg-4 col-sm-4">
            <ul>
                <li>雷士嵌入式双横插防雾筒灯:</li>
                <li>数量：<span id="pronum"></span><span id="casing_unit">支</span></li>
                <li>单价：<span id="sd_unit_price"></span>元</li>
            </ul>
        </div>
    </div>
        <div class="row"></div>
        <h3 class="center-h3">合计：¥<span id="sunSi"></span>元</h3>
        </div>
</div>
<h3 class="text-center" style="padding: 10px 0">采购【${requestScope.corp_sim_name}】电话：${requestScope.phone}</h3>
<div class="center-div">
<div class="form-group">
    <label>审批意见：</label>
    <select class="select-css" id="spyj">
        <option value="同意">同意</option>
        <option value="不同意">不同意</option>
    </select>
</div>
</div>
<div>
<button type="button" class="btn btn-sm center-block btn-primary center-btn" id="save">确认无误提交</button>
</div>