<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>O2O营销服务平台</title>
<link href="pcxy/css/bootstrap.css" rel="stylesheet">
<link rel="stylesheet" href="pcxy/css/global.css">
<link rel="stylesheet" href="pcxy/css/function.css">
<c:if test="${sessionScope.customerInfo.com_id=='001Y10'}">
<script type="text/javascript">
window.location.href="ds/personal_center.jsp";
</script>
</c:if>
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="pcxy///cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="pcxy///cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="js_lib/jquery.11.js"></script>
<script type="text/javascript" src="js_lib/jquery.cookie.js"></script>
<script src="pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<link rel="stylesheet" href="css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="pc/js/customer/customerpay.js${requestScope.ver}"></script>
</head>
<body>
    <div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="pc/index.html${requestScope.ver}">客户首页</a></li>
      </ol>
      <div class="header-title">客户首页
        <a href="pc/index.html${requestScope.ver}" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>
    </div>

    <div class="container" style="margin-bottom:30px">
      <div class="ctn-fff" style="min-height:800px;">
      <div class="col-sm-6" style="display: none;">
          <div class="panel panel-success" >
            <div class="panel-heading">采供管理</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
<!--               customer/order.do -->
                <a href="customer/order.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">下订单</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/myorder.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">我的订单</div>
              </div>
<!--               customer/clientPlan.do -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="pcxy/kh-plan.html" class="function-icon">
                  <img src="pcxy/image/function-26.png" alt="">
                </a>
                <div class="function-name">客户计划</div>
              </div>
              
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/paymoney.do" class="function-icon">
                  <img src="pcxy/image/function-20.png" alt="">
                </a>
                <div class="function-name">采购付款</div>
              </div>
            </div>
          </div>
          <div class="panel panel-success" style="display: none;">
            <div class="panel-heading">销售管理</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">代客户下订单</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/myClient.do" class="function-icon">
                  <img src="pcxy/image/function-05.png" alt="">
                </a>
                <div class="function-name">我的客户</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-18.png" alt="">
                </a>
                <div class="function-name">客户报价单</div>
              </div>
            </div>
          </div>
</div>
<div class="col-sm-6">
          <div class="panel panel-success">
            <div class="panel-heading">采购管理</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/order.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">下订单</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/plan.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">下计划</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/myorder.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">我的订单</div>
              </div>
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-26.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">生产计划</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn" id="addprologo"> -->
<!--                 <a href="customer/add.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-23.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">自助增加品种</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn" id="addprologo"> -->
<!--                 <a href="customer/orderConfirm.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-20.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">订单支付</div> -->
<!--               </div> -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/paymoney.do" class="function-icon">
                  <img src="pcxy/image/function-20.png" alt="">
                </a>
                <div class="function-name">账户充值</div>
              </div>
            </div>
          </div>
<!--                     <div class="panel panel-success"> -->
<!--             <div class="panel-heading">计划中心</div> -->
<!--             <div class="panel-body"> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="employee/quotaApproval.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-22.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">使用额度审批</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="#" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-22.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">退票审批</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="#" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-22.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">退货审批</div> -->
<!--               </div> -->
<!--             <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="employee/salePlan.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-16.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">销售计划</div> -->
<!--               </div> -->
<!--              <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="customer/clientPlan.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-16.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">下计划</div> -->
<!--               </div> -->
<!--             </div> -->
<!--           </div> -->
          
   <div class="panel panel-success" style="display: none;">
            <div class="panel-heading">报表中心</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/salePlanReport.do" class="function-icon">
                  <img src="pcxy/image/function-16.png" alt="">
                </a>
                <div class="function-name">销售计划报表</div>
              </div>
             
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/clientSalePlan.do" class="function-icon">
                  <img src="pcxy/image/function-29.png" alt="">
                </a>
                <div class="function-name">客户计划准确率</div>
              </div>
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="#" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-27.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">客户额度查询</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="#" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-28.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">销量统计</div> -->
<!--               </div> -->
            </div>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="panel panel-success">
            <div class="panel-heading">业务中心</div>
            <div class="panel-body">
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-27.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">账户查询</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="customer/salePlanReport.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-16.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">销售计划报表</div> -->
<!--               </div> -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="customer/accountStatement.do" class="function-icon">
                  <img src="pcxy/image/function-17.png" alt="">
                </a>
                <div class="function-name">对账单</div>
              </div>
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-07.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">订单变更</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-24.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">退票申请</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn" style="display: none;"> -->
<!--                 <a href="customer/quotaApplication.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-24.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">退货申请</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn" style="display: none;"> -->
<!--                 <a href="customer/quotaApplication.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-20.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">款项申请</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-21.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">投诉建议</div> -->
<!--               </div> -->
            </div>
          </div>

          <div class="panel panel-success">
            <div class="panel-heading">个人中心</div>
            <div class="panel-body">
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="customer/customerInfo.do " class="function-icon"> -->
<!--                   <img src="pcxy/image/function-08.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">个人信息</div> -->
<!--               </div> -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="user/pwdchange.do?type=2" class="function-icon">
                  <img src="pcxy/image/function-09.png" alt="">
                </a>
                <div class="function-name">密码修改</div>
              </div>
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!-- 				<a href="user/sendChatMsg.do" class="function-icon"> -->
<!-- 				<img src="pcxy/image/function-10.png" alt=""> -->
<!-- 				</a> -->
<!-- 				<div class="function-name">在线咨询</div> -->
<!-- 				</div> -->

<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="customer/todo.do" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-10.png" alt=""> -->
<!--                   <span class="badge notice">0</span> -->
<!--                 </a> -->
<!--                 <div class="function-name">我的协同</div> -->
<!--               </div> -->
				<div class="col-sm-4 col-xs-4 function-ctn">
					<a href="pc/message_center.html${requestScope.ver}" class="function-icon">
					<img src="pcxy/image/function-10.png" alt="">
					</a>
					<div class="function-name">我的消息</div>
				</div>
               <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="login/exitLogin.do?type=2" class="function-icon">
                  <img src="pcxy/image/function-30.png" alt="">
                </a>
                <div class="function-name">退出登录</div>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <div class="footer">
        客户:${sessionScope.customerInfo.clerk_name}
    </div>
  </body>

</html>