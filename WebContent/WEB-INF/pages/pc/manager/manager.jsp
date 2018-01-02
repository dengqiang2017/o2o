<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>牵引O2O营销服务平台</title>
    <link href="css/bootstrap.css" rel="stylesheet">
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
        <li><span class="glyphicon glyphicon-triangle-right"></span><a>管理员首页</a></li>
      </ol>
      <div class="header-title">管理员首页
        <a class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    <div class="container">
      <div class="ctn-fff" style="min-height:800px;">
        <div class="col-sm-6">


          <div class="panel panel-success">
            <div class="panel-heading">组织机构</div>
            <div class="panel-body">
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-11.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">运营商</div> -->
<!--               </div> -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/dept.do" class="function-icon">
                  <img src="pcxy/image/function-12.png" alt="">
                </a>
                <div class="function-name">部门</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/personnel.do" class="function-icon">
                  <img src="pcxy/image/function-13.png" alt="">
                </a>
                <div class="function-name">员工</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a class="function-icon">
                  <img src="pcxy/image/function-23.png" alt="">
                  <input type="file" name="xls" id="xls" onchange="excelimport(this);">
                </a>
                <div class="function-name">发货单导入</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a class="function-icon" onclick="sendSms();">
                  <img src="pcxy/image/function-23.png" alt="">
                </a>
                <div class="function-name">短信发送</div>
              </div>
             <div class="col-sm-4 col-xs-4 function-ctn">
                <a class="function-icon">
                  <img src="pcxy/image/function-23.png" alt="">
                  <input type="file" name="xlsard" id="xlsard" onchange="excelimport(this,'ard');">
                </a>
                <div class="function-name">收款单导入</div>
             </div>
             <div class="col-sm-4 col-xs-4 function-ctn">
                <a class="function-icon">
                  <img src="pcxy/image/function-23.png" alt="">
                  <input type="file" name="xlsarf" id="xlsarf" onchange="excelimport(this,'arf');">
                </a>
                <div class="function-name">期初应收导入</div>
             </div>
              
            </div>
          </div>

          <div class="panel panel-success">
            <div class="panel-heading">系统控制</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/systemParams.do" class="function-icon">
                  <img src="pcxy/image/function-14.png" alt="">
                </a>
                <div class="function-name">管理模式驾驶舱</div>
              </div>
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-15.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">会计核算期</div> -->
<!--               </div> -->
<!--               <div class="col-sm-4 col-xs-4 function-ctn"> -->
<!--                 <a href="phone/waiting.html" class="function-icon"> -->
<!--                   <img src="pcxy/image/function-16.png" alt=""> -->
<!--                 </a> -->
<!--                 <div class="function-name">操作日志</div> -->
<!--               </div> -->
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-18.png" alt="">
                </a>
                <div class="function-name">短信系统参数</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-17.png" alt="">
                </a>
                <div class="function-name">备份与恢复</div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-sm-6">
          <div class="panel panel-success">
            <div class="panel-heading">基础设置</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/regionalism.do" class="function-icon">
                  <img src="pcxy/image/function-01.png" alt="">
                </a>
                <div class="function-name">行政区划</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/meteringUnit.do" class="function-icon">
                  <img src="pcxy/image/function-02.png" alt="">
                </a>
                <div class="function-name">计量单位</div>
              </div>
              
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/settlement.do" class="function-icon">
                  <img src="pcxy/image/function-20.png" alt="">
                </a>
                <div class="function-name">结算方式维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-32.png" alt="">
                </a>
                <div class="function-name">供应商维护</div>
              </div>
              
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/productClass.do" class="function-icon">
                  <img src="pcxy/image/function-03.png" alt="">
                </a>
                <div class="function-name">产品类别</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/productlist.do" class="function-icon">
                  <img src="pcxy/image/function-04.png" alt="">
                </a>
                <div class="function-name">产品维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/client.do" class="function-icon">
                  <img src="pcxy/image/function-05.png" alt="">
                </a>
                <div class="function-name">客户维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/warehouse.do" class="function-icon">
                  <img src="pcxy/image/function-31.png" alt="">
                </a>
                <div class="function-name">库房维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-06.png" alt="">
                </a>
                <div class="function-name">期初维护</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="manager/definitionProcess.do" class="function-icon">
                  <img src="pcxy/image/function-07.png" alt="">
                </a>
                <div class="function-name">定义协同流程</div>
              </div>

            </div>
          </div>

          <div class="panel panel-success" style="display: none;">
            <div class="panel-heading">用户授权</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-19.png" alt="">
                </a>
                <div class="function-name">用户组及其权限</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-19.png">
                </a>
                <div class="function-name">用户及其权限</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-09.png" alt="">
                </a>
                <div class="function-name">修改用户密码</div>
              </div>
            </div>
          </div>
                    <div class="panel panel-success">
            <div class="panel-heading">个人中心</div>
            <div class="panel-body">
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="phone/waiting.html" class="function-icon">
                  <img src="pcxy/image/function-08.png" alt="">
                </a>
                <div class="function-name">个人信息</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="user/pwdchange.do?type=0" class="function-icon">
                  <img src="pcxy/image/function-09.png" alt="">
                </a>
                <div class="function-name">密码修改</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="#" class="function-icon">
                  <img src="pcxy/image/function-10.png" alt="">
                </a>
                <div class="function-name">我的协同</div>
              </div>
              <div class="col-sm-4 col-xs-4 function-ctn">
                <a href="login/exitLogin.do?type=0" class="function-icon">
                  <img src="pcxy/image/function-30.png" alt="">
                </a>
                <div class="function-name">退出登录</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-6">
        </div>
      </div>
    </div>
    <div class="footer">
      后台管理员<span class="glyphicon glyphicon-earphone">${sessionScope.managerInfo.name}</span>
    </div>
  </body>
</html>