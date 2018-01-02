<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/cashierPayment.css${requestScope.ver}">
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script src="../pc/js/saiyu/tijian.js${requestScope.ver}"></script>
<script src="../pc/js/saiyu/cashierPayment.js${requestScope.ver}"></script>
<style>
   @media(max-width: 770px){
       .margin{
           margin-top: 20px;
       }
   }
   @media(max-width: 770px){
       .margin{
           margin-top: 60px;
       }
   }
</style> 
<div>
<div>
   <input type="hidden" id="seeds_id" value="${requestScope.seeds_id}">
      <button type="button" class="btn btn-primary btn0" style="display:block">查询</button>
      <div class="ctn-fff box-ctn" style="padding:0">
<div class="box-head" style="display:none"><h4 class="pull-left">客户体检列表</h4>
</div>
<input type="hidden" id="page" name="page" value="0">
<input type="hidden" id="totalPage" value="0">
<input type="hidden" id="customer_id" value="${requestScope.customer_id}">
<input type="hidden" id="spNo" value="${requestScope.spNo}">
<input type="hidden" id="orderNo" value="${requestScope.orderNo}">
<input type="hidden" value="${requestScope.approval_step}" id="approval_step">
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
<!-- <input type="text" id="page" value="0" style="width: 50px;"> -->
总页数<span id="totalPage"></span>
    <button type="button" class="btn btn-info btn-sm" id="beginpage"  style="padding: 5px;margin-right: 5px;">首页</button>
	    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
	    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
	    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
	</div>
</div>
            </div>
            <div class="secition-two" style="margin-top:90px">
                   <input type="hidden" id="spNo">
                   <input type="hidden" id="customerName" value="${sessionScope.customerInfo.upper_corp_name}">
                   <input type="hidden" id="customer_id" value="${requestScope.upper_customer_id}">
           <div id="puritem" style="display: none;">
               <div class="col-lg-6 col-sm-6 col-border">
                   <input type="hidden" id="item_id">
                   <ul>
                       <li>雷士嵌入式双横插防雾筒灯</li>
                       <li>单价：<span id="sd_unit_price"></span>元
                       <span id="pack_unit" style="display: none;"></span><span id="item_unit" style="display: none;"></span></li>
                       <li>数量：<span id="pronum"></span><span id="casing_unit"></span>
                       </li>
                   </ul>
               </div>
           </div>
           <div class="row">
           </div>
           <h3 class="center-h3" style="font-weight: bold;font-size:16px">订单编号:<span id="orderNo" style="font-size:16px">${requestScope.orderNo}</span></h3>
       <h3 class="center-h3" style="font-weight: bold;font-size:16px">合计：¥<span id="sumSi" style="font-size:16px"></span>元</h3>
<!--            <div class="dc"> -->
<!--                <div class="secition-three-1">有疑问？请联系我们</div> -->
<!--                <a  onclick="zhixun();" class="secition-three-2">联系赛宇</a> -->
<!--             </div> -->
        </div>
<div class="span-left">
          <ul>
              <li><span style="font-weight: bold">发货地址</span></li>
         </ul>
       </div>
       <textarea class="form-control text-art" rows="4" id="fhdz" style="margin-bottom:70px">${requestScope.fhdz}</textarea>
       <button type="button" class="footer2 btn btn-primary center-block" >￥<span id=sumSi></span>确认支付</button>
   </div>
   <form action="alipay.do" method="post" target="_blank" style="display: none;">
		<div class="pay-form">
			<span class="pay-label">充值单号</span>
			<input type="text" readonly="readonly" class="payinput" name="orderNo" id="xsskNo">
		</div>
		<div class="pay-form">
			<span class="pay-label">充值金额</span>
			<input class="payinput" name="amount" data-number="n" maxlength="15" type="tel">
		</div>
		<input type="hidden" name="attach" value="订单支付">
		<input type="hidden" name="body" value="订单支付">
		</form>
<div class="process-zz" style="z-index:99">
   <ul>
<!--        <li> -->
<!--            <div class="zf center-block"><span>第三方网银线下支付</span> -->
<!--                <div class="dw"> -->
<!--                    <img class="img-responsive" src="../process-images/gou.png"> -->
<!--                </div> -->
<!--            </div> -->
<!--        </li> -->
<!--        <li> -->
<!--            <div class="zf center-block"><span>支付宝支付</span> -->
<!--                <div class="dw"> -->
<!--                    <img class="img-responsive" src="../process-images/gou.png"> -->
<!--                </div></div> -->
<!--        </li> -->
       <li>
           <div class="zf center-block"><span>微信支付</span>
               <div class="dw">
                   <img class="img-responsive" src="../process-images/gou.png">
               </div></div>
       </li>
       <li>
           <div class="zf center-block"><span>线下支付</span>
               <div class="dw">
                   <img class="img-responsive" src="../process-images/gou.png">
               </div></div>
       </li>
       <c:if test="${sessionScope.customerInfo.ifUseCredit=='是'}">
	   <li>
	       <div class="zf center-block"><span>打欠条</span>
	           <div class="dw">
	               <img class="img-responsive" src="../process-images/gou.png">
	           </div></div>
	   </li>
   </c:if>
</ul>
<!--     <button type="button" class="ljzf center-block" id="saveOrder">立即支付</button> -->
<!-- <div class="modal-cover-first" style="display:none;"></div> -->
<!-- <div class="modal-first" style="display:none;"> -->
<!--     <div class="modal-dialog"> -->
<!--         <div class="modal-content"> -->
<!--             <div class="modal-header"> -->
<!-- 				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span> -->
<!-- 				<span class="sr-only">Close</span></button> -->
<!-- 				<h4 class="modal-title">请上传支付凭证</h4> -->
<!-- 			</div> -->
<!-- 			<div class="modal-body" style="overflow-y:scroll; padding: 10px;"> -->
<!-- 	<a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传凭证 -->
<!-- 	<input type="file" name="imgFile" id="imgFile" onchange="imgUpload(this);"> -->
<!-- 	<input type="hidden" id="filepath"> -->
<!-- 	</a> -->
<!-- 	<div class="showimg"> -->
<!-- 	<img src=""> -->
<!-- 	</div> -->
<!-- 			</div> -->
<!-- 			<div class="modal-footer"> -->
<!-- 				<button type="button" class="btn btn-default">取消</button> -->
<!-- 				<button type="button" class="btn btn-primary" id="certificateBtn">确定</button> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
<!-- </div> -->
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