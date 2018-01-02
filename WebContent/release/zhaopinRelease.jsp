<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>${requestScope.pageName}-${sessionScope.systemName}</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pc/css/manage.css${requestScope.ver}">
<link rel="stylesheet" href="../bianji/css/edit_modal.css${requestScope.ver}"">
<link rel="stylesheet" href="../bianji/css/font-awesome.min.css">
<link rel="stylesheet" href="../pc/css/flattingshow.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}" >
<link href="images/logo.ico" type="image/x-icon" rel="shortcut icon" />
<style type="text/css">
	.serve05 {
		text-align: center;
		margin-top: 50px;
		/*background-color: #FFFFFF;*/
		padding: 20px;
	}
	.serve05>.col-lg-4>img {
		width: 159px;
		margin-bottom: 15px;
	}
	.secition_box_bottom05{
		display: none;
		margin: auto;
		margin-top: 20px;
		width: 85%;
		background-color: #ffffff;
	}
	.serve05>.col-lg-4{
		color: #FFFFFF;
	}
	.boxed{
		width: 200px;
		margin: auto;
		padding: 10px;
		color: #FFFFFF;
		font-size: 18px;
	}
	.boxed img{
		margin-bottom: 10px;
	}
	.bq_box{
	height: 100px;
	}
	.secition_box_bottomtop_y4{
	display: none;
	}
	.selectColor{
	background-color: #bfe4f6;
	}
</style>
</head>
<body>
	<!--公用头部-->
	<div class="index01_top navbar-fixed-top">
		<div class="pull-left">
			<a><img
				class="img-responsive" src="../pc/images/logo.png"></a>
		</div>
	<div class="center">
		<ol class="breadcrumb pull-left">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">${sessionScope.indexName}</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>${requestScope.pageName}</li>
	</ol>
		<div class="clearfix"></div>
	</div>
</div>
	<div class="container secition">
		<div class="secition_box">
			 <div class="panel panel-primary" style="z-index: 9999; position: absolute;float: right;margin-top: 70px;">
				<div class="panel-heading">
				    <h3 class="panel-title" style="text-align: center;">操作项</h3>
				  </div>
				<div class="panel-body">
					<div class="form-group">
					<label>颜色</label>
					<input type="color" class="form-control">
					</div>
					<div class="form-group">
					<label>字体大小</label>
					<input type="number"  class="form-control" data-num="num" id="fontsize">
					</div>
					<div class="form-group">
					<label>字体</label>
					<label>
					<input type="radio" name="fontweight" value="bold">加粗
					</label>
					<label>
					<input type="radio" name="fontweight" value="normal">正常
					</label>
					</div>
					<div style="line-height: 45px;">
					<button type="button" class="btn btn-primary" id="delZhaopin">删除招聘</button>
					<button type="button" class="btn btn-primary" id="addZhaopin">增加招聘</button>
					<button type="button" class="btn btn-primary btn-lg btn-block" id="save">保存</button>
					<button type="button" class="btn btn-primary btn-lg btn-block" id="show">查看结果</button>
					<div style="width: 200px;word-break:break-all;line-height: 30px;color: red;">
					操作提示:增加时请编辑部分内容后先保存然后再操作,防止网络连接失败导致数据无法保存!<br>点击保存后新增生效或者彻底删除!
					</div>
					</div>
				</div>
				</div>
			<!-- 招聘 4-->
			<div class="secition_box_bottom" id="zhaoping">
				<div class="secition_box_bottom_x02">
					<div class="x-1 x-active"><label>APP开发工程师</label></div>
					<div class="clearfix"></div>
				</div>
				<div class="secition_box_bottomtop_y4">
					<div class="y-box">
						<div class="y-box-center">
							<h3 style="color: #0094DC; margin-bottom: 25px; text-align: center;">APP开发工程师</h3>
							<div class="bq_box">
								<div class="bq" contenteditable=true>带薪年假</div>
								<div class="bq" contenteditable=true>团队聚餐</div>
								<div class="bq">交通补助</div>
								<div class="bq">午餐补助</div>
								<div class="bq">五险一金</div>
								<div class="bq">技能培训</div>
								<div class="bq">节日礼物</div>
								<div class="bq">通讯津贴</div>
								<div class="bq">定期体检</div>
							</div>
							<button type="button" class="btn btn-primary addDaiyu" style="display: none;">增加</button>
							<div class="clearfix"></div>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">岗位职责：</p>
							<p>1.负责android手机端客户端软件的开发和维护</p>
							<p>2.参与客户端产品的需求分析以及架构设计</p>
							<p>3.从事核心架构部分代码的开发，并保证代码内部和外部质量</p>
							<p>4.紧跟移动互联网技术发展方向，做好技术积累，对产品升级进行规划并推进实施;</p>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">任职要求：</p>
							<p>1.计算机或相关专业本科以上学历，三年以上Android开发经验;</p>
							<p>2.熟悉面对对象思想，精通编程，调试和相关技术，良好的JAVA基础;</p>
							<p>3.熟悉Android SDK,并且开发过1~2款成熟的产品;熟悉Android平台网络数据传输，以及UI框架部分。</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}""></script>
<script type="text/javascript" src="../cmsjs/url.js${requestScope.ver}""></script>
<script type="text/javascript" src="../cmsjs/zhaoping.js${requestScope.ver}""></script>
<script type="text/javascript">
<!--
zhaoping.getZhaopin();
//-->
</script>
</body>
</html>