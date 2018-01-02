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
	<script type="text/javascript" src="../pc/js/clientOrder.js"></script>
</head>
<body>
	<div class="bg"></div>
	<div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="myorder.do">我的订单</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span>订单支付</li>
      </ol>
      <div class="header-title">客户-订单支付
        <a href="myorder.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
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
                     <th>件数</th>  
                     <th>合计</th>  
                  </tr>
              </thead>
              <tbody>
                <tr>
                   <td><a target="_blank"></a></td> 
                     <td></td>  
                     <td></td>  
                     <td></td>
                </tr> 
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
            <li>件数</li>
            <li>金额</li>
            <li>运费</li>
            <li>总金额</li>
          </ul>
          <ul class="order-msg">
            <li>2015-07-22</li>
            <li>15</li>
            <li>&yen;<span></span></li>
            <li>&yen;<span>0</span></li>
            <li>&yen;<span></span></li>
          </ul>
          <div class="table-responsive lg-table">
            <table class="table table-bordered">
              <thead>
                <tr>  
                     <th>结算方式<input type="hidden"></th>  
                     <th>账户性质</th>
                     <th>余额</th>  
                     <th width="10%">申请金额</th>
                  </tr>
              </thead>
              <tbody>
                <tr>
                   <td>账上款</td>  
                   <td>账上款</td>  
                   <td>130.00</td>  
                </tr>
              </tbody>
            </table>
          </div> 
          <h4 class="red" style="display: none;">您的账上款余额足够，无需选择结算方式！</h4>
          <h4 class="red" style="display: none;">您的账上款余额不足，您需要申请提前使用"预存款"，或申请“额度款”！<br>
请设置好“拉货方式”、“发货地址”并选择“结算方式”及申请的金额后，进入我公司核准流程！
</h4>  
<h4 class="red" style="display: none;">您的账上款和预存款余额不足，无法完成本次支付，请充值！<a href="paymoney.do" class="btn btn-warning">立即充值</a></h4>
          <form action="" style="overflow:hidden;">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">拉货方式</label>
                <select class="form-control input-sm" id="transport_AgentClerk_Reciever">
                  <option value="第三方物流">第三方物流</option>
                  <option value="公路货运">公路货运</option>
                  <option value="铁路零担">铁路零担</option>
                  <option value="公司自运">公司自运</option>
                  <option value="客户自提">客户自提</option>
                </select>
              </div>
            </div>
            <div class="col-xs-12">
              <div class="form-group">
                <label for="">发货地址</label>
                <textarea  id="fhdz" cols="30" rows="2" class="form-control"></textarea>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
 
    <div class="footer">
      <div class="btn-gp"> 
        <button class="btn btn-info">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
      客户:${sessionScope.customerInfo.user_id}<span class="glyphicon glyphicon-earphone"></span>
    </div>
</body>
</html>