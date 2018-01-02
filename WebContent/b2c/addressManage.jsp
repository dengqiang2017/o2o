<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.getVer(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="description" content="达州创新家居电商平台主要经营家具,家居,沙发,茶几,桌子,装修">
    <meta name="keywords" content="家具,家居,沙发,茶几,桌子,装修">
    <title>管理收货地址</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/addressManage.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body><span id="com_id" style="display:none;">${sessionScope.customerInfo.com_id}</span>
<nav class="navbar navbar-default navbar-fixed-top">
<div class="header">
    <a  class="header_left">返回</a>
    管理收货地址
</div>
<div class="header" style="display: none;">
    <a onclick='$("#editPage,.header:eq(1)").hide();$("#infopage,.header:eq(0)").show();' class="header_left">返回</a>
    编辑地址
</div>
</nav>
<div class="container">
<div id="infopage" style="margin-top: 50px;">
<div class="secition">
    <ul>
        <li>
            <div class="manage_top">
                <div class="name"></div>
                <div class="cell"></div>
            </div>
            <div class="manage_center">
                <div class="site"></div>
            </div>
            <div class="manage_bottom">
                <div class="set"><i class="fa fa-check-square" aria-hidden="true"></i><span>默认地址</span></div>
                <div class="manage_bottom_right">
                    <div class="eidt">
                        <a>
                        <span class="fa fa-pencil-square-o"></span>编辑
                        </a>
                    </div>
                    <div class="del">
                        <span class="fa fa-trash"></span>删除
                    </div>
                </div>
            </div>
        </li>
    </ul>
</div>
<div class="manage_footer" style="text-align: center;">
    <a class="btn btn-info" id="addfhdz">添加新地址</a>
</div>
    </div>
    <div id="editPage" style="display: none;margin-top: 50px;">
    <form class="form-horizontal">
            <div class="form-group">
		    <label for="inputEmail3" class="col-sm-2 control-label">收货人</label>
		    <div class="col-sm-10">
		      <input type="text" name="lxr" maxlength="20" class="form-control">
		    </div>
		  </div>
            <div class="form-group">
		    <label for="inputEmail3" class="col-sm-2 control-label">联系电话</label>
		    <div class="col-sm-10">
		      <input type="tel" name="lxPhone" maxlength="11" data-num="num" class="form-control">
		    </div>
		  </div>
            <div class="form-group">
		    <label for="inputEmail3" class="col-sm-2 control-label">发货地址</label>
		    <div class="col-sm-10">
		      <textarea name="fhdz"  class="form-control"></textarea>
		    </div>
		  </div>
			<div class="set">
			    <div class="pull-left"><i class="fa fa-square-o" aria-hidden="true"></i></div>
			    <div class="pull-left">设为默认地址</div>
			    <div class="clearfix"></div>
			</div>
    </form>
<div style="text-align: center;margin-top: 50px;">
     <a class="btn btn-info" id="savefhdz">保存</a>
</div>
</div></div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="platformjs/swiper-3.3.1.jquery.min.js"></script>
<script type="text/javascript" src="platformjs/jquery.nicescroll.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/weixinAutoLogin.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/loaderweimaimg.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/addressManage.js${requestScope.ver}"></script>
</body>
</html>