<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <!--     <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title></title>
    <%@include file="../res.jsp"%>
<link rel="stylesheet" href="../pc/css/pay.css${requestScope.ver}">
<script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/customer/clientOrder2.js${requestScope.ver}"></script>
</head>
<body>
     <div class="bg"></div>
     <!----------------- header------------------>
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
     <input type="hidden" value="1" id="settlementModal">
     <!----------------- secition------------------>
      <div class="container">
          <div class="pay_body">
              <div class="paybody_center">
                  <p style="padding: 0 10px">请填写并核对订单信息</p>
                  <div class="paybody_form" style="margin-bottom: 30px">
                      <p style="margin-top: 30px;"><b>收货人地址：</b></p>
                      <div class="row">
                      <div class="col-lg-2 col-xs-12 paybody_margin">
                          <span>请填写收货人地址：</span>
                      </div>
                      <div class="col-lg-10 col-xs-12 paybody_marginright"><div class="paybody_marginleft" style="width: 80%;height: 100%;border-bottom: 1px solid #ddd">
                      <input name="FHDZ" placeholder="请填写地址" style="border: none;outline: none;width: 100%">
                      </div></div>
                      </div>
                      <div class="paybody_fg"></div>
                      <p><b>确认订单信息：</b></p>
                      <div class="paybody_list pro-list">
                          <ul>
                          </ul>
                          <div style="display: none;" id="liitem">
                              <li>
                                  <div class="col-lg-2">
                                      <div class="imgk">
                                          <div class="paybody_img">
                                              <img src="">
                                          </div>
                                      </div>
                                  </div>
                                  <div class="col-lg-5">
                                      <div class="wzk">
                                          <ul>
                                              <li>名称：<span class="msg"></span></li>
                                              <li>单价：￥<span id="sd_unit_price"></span>元</li>
                                              <li id="com_id">所属运营商:<span></span></li>
                                              <li style="line-height:30px">
                                                  <label style="float:left;">数量：</label>
                                                  <div class="num-input-xs" style="height: 30px;float: left;border: 1px solid #ddd;width: 130px;">
<!--                                                       <span class="sub" style="width: 25px;height: 30px;float: left;text-align: center;line-height: 30px;border-right:1px solid #ddd ">-</span> -->
<!--                                                       <span class="add" style="width: 25px;height: 30px;float: right;text-align: center;line-height: 30px;border-left:1px solid #ddd ">+</span> -->
                                                      <input type="text" class="num" id="pronum" data-number="n" style="width:100%;text-align:center;height:100%;outline: none;background-color: #F5F5F5;border: none">

                                                  </div>
    <span id="item_unit" style="margin-left:10px"></span>
                                                  <div style="clear: both;"></div>
                                              </li>
                                              <li style="line-height:30px"><div id="pack_unit" style="display: none;"></div>
                                                  <label style="float:left;">折算数量：</label>
                                                  <div class="num-input-xs" style="height: 30px;float: left;border: 1px solid #ddd;width: 130px;">
                                                      <input type="text" class="zsum"  readonly="readonly" style="width:100%;text-align:center;height:100%;outline: none;background-color: #F5F5F5;border: none">

                                                  </div>
    <span id="casing_unit" style="margin-left:10px"></span>
                                                  <div style="clear: both;"></div>
                                              </li>
                                          </ul>
                                      </div>
                                  </div>
                                  <div class="col-lg-5">
                                      <div class="wzk">
                                          <ul>
                                              <li><span class="left">商品金额：￥</span><span class="right" id="spje"></span>元</li>
                                              <li style="display: none"><span class="left">优惠卷：</span><span class="right"></span></li>
                                              <li style="display: none"><span class="left">运费：</span><span class="right">￥</span></li>
                                              <li style="color: #FF251A;display: none;" ><span class="left">实付款：</span><span class="right">￥</span></li>
                                          </ul>
                                      </div>
                                  </div>
                    <input type="hidden" id="ivt_oper_listing">
                    <input type="hidden" id="seeds_id">
                    <input type="hidden" id="item_id">
                                  <div style="clear: both;"></div>
                                  <img src="../pc/images/add.png" alt="删除" style="position: absolute;right: 5px;top:5px;cursor: pointer;">
                              </li>
                              <div style="clear: both;"></div>
                          </div>
                      </div>
                      <div class="paybody_fg" style="margin-bottom: 20px"></div>
                      <p style="margin-bottom: 30px;">截止<span id="nowdate"></span>，
                      您的累计应付款为&nbsp<span style="color: #FF251A" id="ysk">0.00</span>&nbsp元，账户可用余额为&nbsp<span style="color: #FF251A" id="zhye">0.00</span>&nbsp元
<!--                       <a target="_blank" href="accountStatement.do" class="btn btn-sm btn-default btn-margin">查看对账单</a> -->
                      </p>
                  </div>
              </div>
              <div class="paybody_footer">
                  <div class="paybody_footer_center">
                      <div class="pull-right">
                          应付金额：￥<span style="color: #FF251A;font-size: 20px" id="orderzje"></span><a class="btn btn-danger btn-sm" style="margin-left: 10px" id="saveOrder">提交订单</a><a href="javascript:history.go(-1);" class="btn btn-default btn-sm">返回</a>
                      </div>
                  </div>
              </div>
          </div>
      </div>
      <!-- ///////////////////////////////////////////////////////////////////////////////////////////////// -->
<div class="modal-cover"></div>
<div class="modal" style="display:none; top: 10%;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">提示</h4>
			</div>
			<div class="modal-body" style="max-height:240px; overflow-y:scroll;">
				<p>您的账户可用余额为&yen;<span id="mzhye">0</span>
					<br>本次支付金额为&yen;<span id="mzje">0</span>
					<br>由于余额不足，不能继续支付！</p>
			</div>
			<div class="modal-footer"  style="text-align:center;">
			<c:if test="${sessionScope.customerInfo.ifUseCredit=='是'}">
				<a href="iou.do" class="btn btn-danger">打欠条</a>
			</c:if>
				<a href="paymoney.do?order" id="paymoney" class="btn btn-danger">去支付</a>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog  javascript:history.go(-1); -->
</div><!-- /.modal -->
<%-- 客户:${sessionScope.customerInfo.clerk_name} --%>
<input type="hidden" value="${sessionScope.customerInfo.clerk_name}" id="customerName">
<input type="hidden" value="${sessionScope.customerInfo.ifUseCredit}" id="ifUseCredit">
</body>
</html>