<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>牵引O2O营销服务平台</title>
    <%@include file="../../res.jsp" %>
    <link rel="stylesheet" href="../pcxy/css/function.css">
    <link rel="stylesheet" href="../pcxy/css/write-table.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span>工作交接</li>
      </ol>
      <div class="header-title">员工-工作交接
        <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
    	<div class="ctn-fff box-ctn" style="height:750px;">	  	
			<div class="box-body">
		 <div class="splc-ctn">
            <div class="splc-head">业务类</div>
            <ul class="splc-body">
              <li><a href="leaveOffice.do">员工离职<span class="glyphicon glyphicon-hand-right"></span></a></li>
              <li><a href="leaveTransfer.do">离职交接<span class="glyphicon glyphicon-hand-right"></span></a></li>
              <li class="last-li"><a href="shiftHandover.do">换岗交接<span class="glyphicon glyphicon-hand-right"></span></a></li>
            </ul>
         </div>
			<div class="ctn text-center" style="margin-top:30px;">
          		<a href="../employee.do" type="button" class="btn btn-primary btn-lg">返回首页</a>
        	</div>
		</div>
		</div>
    </div>

    <div class="footer">
    	员工:${sessionScope.userInfo.personnel.clerk_name}
    </div>
</body>
</html>