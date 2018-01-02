<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>牵引O2O营销服务平台</title>
    <link href="pcxy/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="pcxy/css/global.css">
    <link rel="stylesheet" href="pcxy/css/function.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="js_lib/jquery.11.js"></script>
	<script src="pcxy/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript" src="js/ajaxfileupload.js"></script> 
    <link rel="stylesheet" href="css/popUpBox.css">
	<script type="text/javascript" src="js/popUpBox.js"></script>
	<script type="text/javascript" src="pc/js/employee/finance_employee.js"></script>
  </head>
  <body>
    <div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a>财务内勤首页</a></li>
      </ol>
      <div class="header-title">财务内勤首页 
        <a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>
    </div>

    <div class="container">
      <div class="ctn-fff" style="min-height:800px;">
        <div class="col-sm-6">
          <div class="panel panel-success">
            <div class="panel-heading">财务中心</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="yg-mykh.html" class="function-icon">
                  <img src="pcxy/image/function-05.png" alt="">
                </a>
                <div class="function-name">客户订单收款确认</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-20.png" alt="">
                </a>
                <div class="function-name">收款确认</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-23.png" alt="">
                  <input type="file" onchange="excelimport(this);">
                </a>
                <div class="function-name">发货单导入</div>
              </div> 
            </div>
          </div>

          <div class="panel panel-success">
            <div class="panel-heading">资料维护</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-13.png" alt="">
                </a>
                <div class="function-name">员工</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="gly-jsfs.html" class="function-icon">
                  <img src="pcxy/image/function-20.png" alt="">
                </a>
                <div class="#">结算方式维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">产品维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-06.png" alt="">
                </a>
                <div class="function-name">期初维护</div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-sm-6">
          <div class="panel panel-success">
            <div class="panel-heading">报表中心</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-17.png" alt="">
                </a>
                <div class="function-name">客户对账单</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-27.png" alt="">
                </a>
                <div class="function-name">客户额度查询</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-28.png" alt="">
                </a>
                <div class="function-name">销量统计</div>
              </div>
            </div>
          </div>
          <div class="panel panel-success">
            <div class="panel-heading">个人中心</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="yg-grxx.html" class="function-icon">
                  <img src="pcxy/image/function-08.png" alt="">
                </a>
                <div class="function-name">个人信息</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="user/pwdchange.do?type=1" class="function-icon">
                  <img src="pcxy/image/function-09.png" alt="">
                </a>
                <div class="function-name">密码修改</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="employee/myOA.do" class="function-icon">
                  <img src="pcxy/image/function-10.png" alt="">
                  <span class="badge notice">${requestScope.oa}</span>
                </a>
                <div class="function-name">我的协同</div>
              </div> 
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="login/exitLogin.do" class="function-icon">
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
      员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
    </div>
  </body>
</html>