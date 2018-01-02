<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
    <%@include file="../res.jsp"%>
	<script type="text/javascript" src="../js/o2otree.js"></script>
	<script type="text/javascript" src="../pc/js/customer/clientOrder.js?ver=001"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span>订单支付</li>
      </ol>
      <div class="header-title">客户-订单支付
        <a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          订单详情
        </div>
        <div class="box-body">
          <div class="table-responsive lg-table">
            <table class="table table-bordered">
              <thead>
                <tr>  
                     <th>订单号</th>  
                     <th>产品名称</th>  
                     <th>数量</th>  
                     <th>合计</th>  
                  </tr>
              </thead>
              <tbody>
              </tbody>
            </table>
          </div>   
        </div>
      </div>
    </div>

    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          支付信息
        </div>
        <div class="box-body">
          <ul class="order-msg-title">
            <li>日期</li>
            <li>数量</li>
            <li>金额</li>
            <li>运费</li>
            <li>总金额</li>
          </ul>
          <ul class="order-msg">
            <li></li>
            <li></li>
            <li>&yen;<span>0</span></li>
            <li>&yen;<span>0</span></li>
            <li>&yen;<span>0</span></li>
          </ul>
          <form action="" style="overflow:hidden;">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">拉货方式 <span style="color:red;">*</span></label>
                <select class="form-control input-sm" name="transport_AgentClerk_Reciever">
                  <option value="客户自提">客户自提</option>
                  <option value="公路货运">公路货运</option>
                  <option value="铁路零担">铁路零担</option>
                  <option value="公司自运">公司自运</option>
                  <option value="第三方物流">第三方物流</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">司机姓名 <span style="color:red;">*</span></label>
                <input type="text" class="form-control input-sm" name="Kar_Driver" maxlength="20">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">司机手机 <span style="color:red;">*</span></label>
                <input type="text" class="form-control input-sm" name="Kar_Driver_Msg_Mobile" data-number="num" maxlength="11">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">车牌号 <span style="color:red;">*</span></label>
                <input type="text" class="form-control input-sm" name="Kar_paizhao" maxlength="20">
              </div>
            </div>
            <div class="col-xs-12" style="display: none;">
              <div class="form-group">
                <label for="">发货地址 <span style="color:red;">*</span></label>
                <textarea name="FHDZ" cols="30" rows="2" class="form-control"></textarea>
              </div>
            </div>
          </form>
          <!-- 所有情况均应提示！ -->
          <h4 style="color:#4b77be;">截止<span id="nowdate"></span>，您累计的应收款为<span id="ysk">0.00</span>元，账户余额为<span id="zhye">0.00</span>元。 <a target="_blank" href="accountStatement.do" class="btn btn-danger">查看对账单</a></h4>
 		 </div>
      </div>
    </div>
 
    <div class="footer">
      <div class="btn-gp">
        <a class="btn btn-info" style="text-indent:0;">提交</a>
        <a class="btn btn-primary" href="javascript:history.go(-1);">返回</a>
      </div>
		客户:${sessionScope.customerInfo.clerk_name}
		<input type="hidden" value="${sessionScope.customerInfo.clerk_name}" id="customerName">
		<input type="hidden" value="${sessionScope.customerInfo.ifUseCredit}" id="ifUseCredit">
    </div>
    
<div class="modal-cover"></div>
<div class="modal" style="display:block; top: 10%;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">提示</h4>
			</div>
			<div class="modal-body" style="max-height:240px; overflow-y:scroll;">
				<p>您的账户余额为&yen;<span id="mzhye">0</span>
					<br>本次支付金额为&yen;<span id="mzje">0</span>
					<br>由于余额不足，您本次支付将产生欠条，请点击打欠条按钮继续！</p>
			</div>
			<div class="modal-footer"  style="text-align:center;">
				<a href="iou.do" class="btn btn-danger">打欠条</a>
				<a href="paymoney.do" id="paymoney" target="_blank" class="btn btn-danger">去充值</a>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
    
</body>
</html>