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
<title>${requestScope.pageName}-牵引互联</title>
<link rel="stylesheet" href="cms/css/bootstrap.css">
<link rel="stylesheet" href="css/manage.css${requestScope.ver}">
<link rel="stylesheet" href="bianji/css/edit_modal.css${requestScope.ver}">
<link rel="stylesheet" href="bianji/css/font-awesome.min.css">
<link rel="stylesheet" href="cms/css/flattingshow.css">
<link rel="stylesheet" href="css/edit.css" name="editjs">
<link href="images/logo.ico" type="image/x-icon" rel="shortcut icon" />
<link href="../css/popUpBox.css${requestScope.ver}" rel="stylesheet">
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
</style>
</head>
<body>
	<!--公用头部--> 
	<%@include file="../cmsjs/find.jsp" %>
	<div class="secition">
		<div class="secition_box">
			<div class="secition_box_top clearfix">
					<div class="fl x-active">案例展示<span class="ui_type" style="display: none;">1</span></div>
					<div class="fl">智慧</div>
					<div class="fl">新闻发布<span class="ui_type" style="display: none;">2</span></div>
					<div class="fl" style="display: none;"><a href="../pc/zhaopinRelease.html?projectName=p9">招聘信息</a><span class="ui_type" style="display: none;">3</span></div>
					<div class="fl" style="margin-right: 0">产品<span class="ui_type" style="display: none;">4</span></div>
			</div>
<!-- 案例 1-->
			<div class="secition_box_bottom clearfix" id="caselist">
				<div class="right-main-item">
					<div class="img imgvideo" data-title="推荐尺寸318*230px">
						<div class="imgk02">
							<a href="">
								<img data-bd-imgshare-binded="1" 
								alt=""> <video style="display: none;" src=""
									controls="controls" height="400" width="480"></video> <!--               <embed style="display: none;" src="" allowfullscreen="true" quality="high" allowscriptaccess="always" type="application/x-shockwave-flash" align="middle" height="400" width="480"> -->
							</a>
						</div>
						<!-- 虚线框 -->
						<div class="edit_default e_border_top"></div>
						<div class="edit_default e_border_right"></div>
						<div class="edit_default e_border_bottom"></div>
						<div class="edit_default e_border_left"></div>
						<div class="edit_default edit_btn">
							<button class="btn_edit" style="font-size: 16px;">编辑</button>
						</div>
					</div>
					<div class="msg articleedit">
						<a>
							<div class="msg-data-title articleedit_title"
								style="font-size: 18px;">我要定制：我的衣着形象，西装</div>
							<div class="msg-subtitle articleedit_keywords"></div>
							<div class="other">
								<span class="author articleedit_time">2016-05-26</span> <span
									class="date articleedit_author"></span>
							</div>
						</a>
						<!-- 虚线框 -->
						<div class="edit_article e_border_top"></div>
						<div class="edit_article e_border_right"></div>
						<div class="edit_article e_border_bottom"></div>
						<div class="edit_article e_border_left"></div>
						<div class="edit_article edit_btn">
							<button class="btn_edit" style="font-size: 16px;">编辑</button>
							<button class="btn_add" style="font-size: 16px;">新增</button>
							<button class="btn_del" style="font-size: 16px;">删除</button>
						</div>
					</div>
				</div>
			</div>
			<!--  智慧2-->
			<div class="secition_box_bottom">
				<div class="secition_box_bottom_x">
					<div class="x-1 x-active">互联网+思维？<span class="ui_type" style="display: none;">20</span></div>
					<div class="x-1">为什么？<span class="ui_type" style="display: none;">21</span></div>
					<div class="x-1">怎么做？<span class="ui_type" style="display: none;">22</span></div>
					<div class="clearfix"></div>
				</div>
				<div class="secition_box_bottomtop_y">
					<div class="y-box">
						<ul>
							<li class="msg articleedit"><span>梳理"价值链"：供应链上游、企业内部流程、渠道及流程设计、消费端拉动分析、设计与技术资源、第三方碎片化资源</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
							<li class="msg articleedit"><span>定制"IT"工具：运用创新和颠覆的信息技术和通讯技术，整合并优化您的盈利模式。</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
						</ul>
					</div>
				</div>
				<div id="item" style="display: none;">
							<li class="msg articleedit"><span class="articleedit_title"></span><span id="zhiding"></span>
							<span id="htmlname" style="display: none;"></span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
						 
				</div>
				<div class="secition_box_bottomtop_y">
					<div class="y-box">
						<ul>
							<li class="msg articleedit"><span>看看首先为什么您需要彻底的思维"创新和颠覆"</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
							<li class="msg articleedit"><span>这些企业是怎么没落的，另外一些新兴企业是怎样崛起的？</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
							<li class="msg articleedit"><span>设计商业流程和盈利流程为何至关重要？</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
						</ul>
					</div>
				</div>
				<div class="secition_box_bottomtop_y">
					<div class="y-box">
						<ul>
							<li class="msg articleedit"><span>"赛宇电器"如何做行业标准的制定者的？</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
							<li class="msg articleedit"><span>"通威"品牌战略与实施是怎么做到颠覆行业的？</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
							<li class="msg articleedit"><span>传统空调行业，即将掀起一场与消费者的对接，看看"美的"</span>
								<div class="edit_article edit_btn">
									<button class="btn_edit" style="font-size: 16px;">编辑</button>
									<button class="btn_add" style="font-size: 16px;">新增</button>
									<button class="btn_del" style="font-size: 16px;">删除</button>
								</div></li>
						</ul>
					</div>
				</div>
			</div>
			<!-- 新闻3-->
			<div class="secition_box_bottom" id="newslist">
			</div>
			<!-- 招聘 4-->
			<div class="secition_box_bottom" id="zhaoping">
				<div class="panel panel-default pull-right">
				<div class="panel-body">
				<div class="panel panel-primary">操作项</div>
					<div class="form-group">
					<label>颜色</label>
					<input type="color" class="form-control">
					</div>
					<div class="form-group">
					<label>字体大小</label>
					<select class="form-control" id="fontsize">
					<option value="8px">8</option>
					<option value="12px">12</option>
					<option value="14px">14</option>
					<option value="16px">16</option>
					<option value="18px">18</option>
					<option value="20px">20</option>
					<option value="22px">22</option>
					<option value="24px">24</option>
					</select>
					</div>
					<div class="form-group">
					<label>字体加粗</label>
					<select class="form-control" id="fontweight">
					<option value="bold">加粗</option>
					<option value="normal">正常</option>
					</select>
					</div>
					<button type="button" class="btn btn-primary btn-lg btn-block" id="save">保存结果</button>
				</div>
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
<!-- 								<div class="clearfix"></div> -->
							</div>
							<button type="button" class="btn addDaiyu" style="display: none;">增加</button>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">岗位职责：</p>
							<div>
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
				<div class="secition_box_bottomtop_y4">
					<div class="y-box">
						<div class="y-box-center">
							<h3
								style="color: #0094DC; margin-bottom: 25px; text-align: center;">JAVA工程师</h3>
							<div class="bq_box">
								<div class="bq">带薪年假</div>
								<div class="bq">团队聚餐</div>
								<div class="bq">交通补助</div>
								<div class="bq">午餐补助</div>
								<div class="bq">五险一金</div>
								<div class="bq">技能培训</div>
								<div class="bq">节日礼物</div>
								<div class="bq">通讯津贴</div>
								<div class="bq">定期体检</div>
<!-- 								<div class="clearfix"></div> -->
							</div>
							<button type="button" class="btn addDaiyu" style="display: none;">增加</button>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">岗位职责：</p>
							<p>1.负责公司核心系统相关的开发与维护</p>
							<p>2.参与项目的需求分析与讨论，负责项目的设计和开发</p>
							<p>3.负责解决项目中的技术难点和技术攻关</p>
							<p>4.负责项目的重构、优化及后期核心功能实现</p>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">任职要求：</p>
							<p>1.计算机或相关专业本科以上学历，3年以上Java实际开发经验（实习期除外）;</p>
							<p>2.熟悉MVC开发模式,掌握常用开发框架;</p>
							<p>3.熟练使用前端开发技术，JQuery等客户端开发技术，会编写一般的CSS、JS等前端效果。</p>
							<p>4.熟悉Oracle或者MySQL编程及优化。</p>
							<p>5.具有丰富的软件开发经验和理念，具体一定的系统分析设计能力。</p>
							<p>6.良好的工作态度和职业道德，责任心强，有良好的团队合作意识，善于沟通，能承担工作压力。</p>
							<p>7.有家具行业软件开发工作经验者优先考虑。</p>
						</div>
					</div>
				</div>
				<div class="secition_box_bottomtop_y4">
					<div class="y-box">
						<div class="y-box-center">
							<h3
								style="color: #0094DC; margin-bottom: 25px; text-align: center;">程序员</h3>
							<div class="bq_box">
								<div class="bq">带薪年假</div>
								<div class="bq">团队聚餐</div>
								<div class="bq">交通补助</div>
								<div class="bq">午餐补助</div>
								<div class="bq">五险一金</div>
								<div class="bq">技能培训</div>
								<div class="bq">节日礼物</div>
								<div class="bq">通讯津贴</div>
								<div class="bq">定期体检</div>
<!-- 								<div class="clearfix"></div> -->
							</div>
							<button type="button" class="btn addDaiyu" style="display: none;">增加</button>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">岗位职责：</p>
							<p>1.建立和完善公司工作平台系统（软件开发）</p>
							<p>2.管理维护公司网站、网络系统、网络规划管理等工作</p>
							<p>3.公司网络日常维护</p>
							<p>4.开发公司网站建设及相关工作</p>
							<p>5.熟悉APP开发语言，有项目经验者优先</p>
							<p style="margin-bottom: 25px; margin-top: 25px; font-size: 19px">任职要求：</p>
							<p>1.计算机或相关专业本科以上学历，有2年以上网络维护相关工作经验,掌握各种网络环境搭建，能独立完成软件开发、网站建设，精通PHP等编程语言，具备较强的技术基础;</p>
							<p>2.熟悉网络设备、服务器、小型机的安装、调试、维护;熟悉计算机网络和网络安全的调试;具备网络故障的分析、判断、解决能力</p>
							<p>3.有较强的沟通协调能力及高度责任心</p>
						</div>
					</div>
				</div>
			</div>
			
				<div id="imgitem" style="display: none;">
					<div class="col-lg-3">
					<div class="right-main-item">
						<div class="img imgvideo" data-title="推荐尺寸318*230px">
							<div class="imgk02">
								<a> <img data-bd-imgshare-binded="1"
									src="" alt=""> <video
										style="display: none;" src="" controls="controls" height="400"
										width="480"></video> <!--               <embed style="display: none;" src="" allowfullscreen="true" quality="high" allowscriptaccess="always" type="application/x-shockwave-flash" align="middle" height="400" width="480"> -->
								</a>
							</div>
						</div>
						<div class="msg articleedit">
						<div style="display: none;" id="htmlname"></div>
								<div class="msg-data-title articleedit_title"
									style="font-size: 18px;"></div><span id="zhiding"></span>
								<div class="msg-subtitle articleedit_keywords"></div>
								<div class="other">
									<span class="author articleedit_time"></span> <span
										class="date articleedit_author"></span>
								</div>
						</div>
					</div>
					</div>
				</div>

			<!-- 产品 5 -->
            <div class="secition_box_bottom05">
				<div class="serve05">
					<div class="col-lg-4 col-xs-4">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y1.png">
					<span id="htmlname" style="display: none;">qiyewangzhan.html</span>
						<span class="articleedit_title">企业网站</span>
						</div>
					</div>
					<div class="col-lg-4 col-xs-4">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y2.png">
					<span id="htmlname" style="display: none;">dianshangwangzhan.html</span>
						<span class="articleedit_title">电商平台</span>
							</div>
					</div>
					<div class="col-lg-4 col-xs-4">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y3.png">
					<span id="htmlname" style="display: none;">OAxietong.html</span>
						<span class="articleedit_title">协同平台</span>
							</div>
					</div>
					<div class="col-lg-4 col-xs-4" style="margin-top: 25px">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y4.png">
					<span id="htmlname" style="display: none;">qiyeERP.html</span>
						<span class="articleedit_title">企业ERP</span>
							</div>
					</div>
					<div class="col-lg-4 col-xs-4" style="margin-top: 25px">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y5.png">
					<span id="htmlname" style="display: none;">caiwusoft.html</span>
						<span class="articleedit_title">财务软件</span>
							</div>
					</div>
					<div class="col-lg-4 col-xs-4" style="margin-top: 25px">
						<div class="boxed msg articleedit">
						<img class="img-responsive center-block" src="images/y6.png">
					<span id="htmlname" style="display: none;">fujinfuwu.html</span>
						<span class="articleedit_title">附近服务</span>
							</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../cmsjs/url.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/urlParam.js${requestScope.ver}"></script>
<script type="text/javascript" src="../cmsjs/edithtml.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/manageList.js${requestScope.ver}"></script>
</body>
</html>