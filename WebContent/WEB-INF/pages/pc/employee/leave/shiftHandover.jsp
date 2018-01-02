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
    <script type="text/javascript" src="../js/o2otree.js"></script>
    <script type="text/javascript" src="../pc/js/employee/leave.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="workHandover.do">工作交接</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span>换岗交接</li>
      </ol>
      <div class="header-title">员工-换岗交接
        <a href="workHandover.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>

    <div class="container">
    	<div class="ctn-fff box-ctn" style="height:750px;">
			<div class="box-body">
        		<div class="col-sm-6">
  					<div class="item-card item-card01">
	  					<div class="item-msg">
	  						<dl>
	  							<dt>员工姓名</dt>
	                			<dd></dd>
	  						</dl>
	  						<dl>
	  							<dt>部门</dt>
	                			<dd></dd>
	  						</dl>
	  						<dl>
	  							<dt>员工编号</dt>
	                			<dd></dd>
	  						</dl>
	  					</div>
  						<div class="item-head">
  							<a class="selectEmployee" >点击选择交接人</a>
  						</div>
  					</div>
        		</div>
        		<div class="col-sm-6">
          			<div class="item-card item-card01">
            			<div class="item-msg">
			              <dl>
			                <dt>员工姓名</dt>
			                <dd></dd>
			              </dl>
			              <dl>
			                <dt>部门</dt>
			                <dd></dd>
			              </dl>
			              <dl>
			                <dt>员工编号</dt>
			                <dd></dd>
			              </dl>
            			</div>
            			<div class="item-head">
              				<a class="selectEmployee" >点击选择被交接人</a>
            			</div>
          			</div>
        		</div>
				<div class="ctn text-center">
					<a  id="shifHandover" type="botton" class="btn btn-lg btn-primary">确认交接</a>
					<a href="workHandover.do" type="botton" class="btn btn-lg btn-primary">返回</a>
				</div>
			</div>
		</div>
    </div>

    <div class="footer">
      	员工:${sessionScope.userInfo.personnel.clerk_name}
    </div>
</body>
</html>