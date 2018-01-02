<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>生产计划跟踪</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	 <%@include file="../res.jsp" %>
	<link rel="stylesheet" type="text/css" href="../pc/pmcss/productionTrackingQry.css">
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../js/o2otree.js"></script>
    <script type="text/javascript" src="../js/ajaxfileupload.js"></script>
    <script type="text/javascript" src="../pc/pmjs/productionTrackingQry.js${requestScope.ver}"></script>
</head>
<body style="background-color: #C8D6DF">
<div class="header">
	<ol class="breadcrumb">
		<li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
		<li class="active"><span class="glyphicon glyphicon-triangle-right"></span>生产计划跟踪</li>
	</ol>
	<div class="header-title">
		员工-生产计划跟踪 <a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
	</div>
	<input type="hidden" id="isAutoFind" value="false">
	<div class="header-logo"></div>
</div>
<!-------------------------------secition------------------------------------------------------------------------------>
<div class="secition">
	<div class="secition_01">
            <div class="col-lg-4 col-sm-4 col-xs-12 margin">
                        <label for="inputEmail3" class="left_lable col-lg-3 col-xs-3">关键词</label>
                        <div class="right_div col-lg-9 col-xs-9">
                        	<input type="text" class="form-control" id="searchKey" placeholder="请输入关键词" maxlength="20" style="border: 1px solid #067FBC">
                        </div>
                    </div>
                    <div class="col-lg-4 col-sm-4 col-xs-12 margin">
                        <label for="inputEmail3" class="left_lable col-lg-3 col-xs-3">计划日期</label>
                        <div class="right_div col-lg-9 col-xs-9">
                        	<input  id="d4311" class="Wdate form-control"
				            	onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:true})" name="send_date" placeholder="请输入计划日期" style="border: 1px solid #067FBC">
                        </div>
                    </div>
                    <div class="col-lg-4 col-sm-4 col-xs-12 margin">
                        <label for="inputEmail3" class="left_lable col-lg-3 col-xs-3">结束日期</label>
                        <div class="right_div col-lg-9 col-xs-9">
                            <input  id="d4312" class="Wdate form-control"
								onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:true})" name="plan_end_date" placeholder="请输入结束日期" style="border: 1px solid #067FBC">
                        </div>
                    </div>
                    <div class="col-lg-4 col-sm-4 col-xs-12 margin lg-margin">
						<div class="form-group">
					    	<label class="left_lable col-lg-3 col-xs-3">工序类别</label>
	                        <div class="right_div col-lg-9 col-xs-9">
					    	<select class="form-control input-sm" id="working_procedure_section" name="working_procedure_section" style="border: 1px solid #067FBC">
					    	<c:forEach items="${requestScope.working_procedure_section}" var="prop">
								<option value="${prop}">${prop}</option>
							</c:forEach>
					    	</select>
	                    </div>
					  	</div>
					</div>
                    <div class="col-lg-4 col-sm-4 col-xs-12 margin lg-margin">
						<div class="form-group">
					    	<label class="left_lable col-lg-3 col-xs-3">状态</label>
	                        <div class="right_div col-lg-9 col-xs-9">
					    	<select class="form-control input-sm" id="status" style="border: 1px solid #067FBC">
								<option value="0" selected="selected">未生产</option>
								<option value="1">生产中</option>
								<option value="2">已完成</option>
								<option value="">全部</option>
					    	</select>
	                    </div>
					  	</div>
					</div>
		<div class="clear"></div>
	</div>
	<div class="secition_02">
		<div class="pull-left">
			<span style="float: left">标识颜色说明：</span>
			<div class="explain">
				<div class="explain01">
					<div class="explain01_a bck01"></div><span style="float: left">尚未通知员工生产</span>
				</div>
				<div class="explain02">
					<div class="explain01_b bck02"></div><span style="float: left">员工正在生产/质检</span>
				</div>
				<div class="explain03">
					<div class="explain01_c bck03"></div><span style="float: left">产品生产质检已完成</span>
				</div>
				<div class="explain04"></div>
			</div>
		</div>
		<div class="pull-right">
		<button type="button" class="btn btn-primary margin btn-style notice">通知工人</button>
		<button type="button" class="btn btn-primary margin btn-style find">查询</button>
			<a style="display: none;" id="upload-btn" class="btn btn-primary m-t-b btn-style">导入
				<input type="file" id="xlsquotationSheet" name="xlsquotationSheet" onchange="excelImport(this,'quotationSheet');"></a>
		</div>
		<div class="clear"></div>
	</div>

		    <div id="td0" style="display: none;">
 			<span style="float: left;margin-top: 24px;margin-right: 10px;margin-left: 10px">1</span>
			<div style="float: left"><img src="../pc/images/up(1).png" style="display: block"><img src="../pc/images/down2.png" style="display: block;margin-top: 10px"></div>
			<div class="clear"></div>
	    </div>
	    <div id="td1" style="display: none;">
	    	<div class="pro-check center-block jz" style="margin-top: 10px"></div>
	    </div>

	    <div class="secition_03 table-responsive">
                    <table class="table table-bordered  ta">
                    <thead style="background-color: #36A0AC;color: #FFFFFF;">
	                    <tr>
<!-- 	                    	<th>优先次序</th> -->
<!-- 	                    	<th>是否作废</th> -->
	                    	<th rowspan="2" data-name="corp_name">客户名称</th>
<!-- 	                    	<th>是否加急</th> -->
	                    	<th rowspan="2" data-name="send_date">下计划时间</th>
	                    	<th rowspan="2" data-name="plan_end_date">要求交货时间</th>
	                    	<th rowspan="2" data-name="PH">排产编号</th>
	                    	<th rowspan="2" data-name="item_sim_name">产品名称</th>
	                        <th rowspan="2" data-name="JHSL">计划数量</th>
	                        
	                        <th colspan="5">工序</th>
	                        <th rowspan="2" data-name="status">状态</th>
	                    </tr>
	                    <tr> 
	                    </tr>
                    </thead>
                    <tbody style="background-color: #ffffff;">
<!-- 	                    <tr> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="jz"> -->
<!-- 							<span style="float: left;margin-top: 24px;margin-right: 10px;margin-left: 10px">1</span> -->
<!-- 							<div style="float: left"><img src="../pc/images/up(1).png" style="display: block"><img src="../pc/images/down2.png" style="display: block;margin-top: 10px"></div> -->
<!-- 							<div class="clear"></div> -->
<!-- 							</div> -->
<!-- 						</td> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="pro-check center-block jz" style="margin-top: 10px"></div> -->
<!-- 						</td> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="jz">邓客户</div> -->
<!-- 						</td> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="jz">是</div> -->
<!-- 						</td> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="jz">2016-05-19</div> -->
<!-- 						</td> -->
<!-- 	                    <td class="zz"> -->
<!-- 							<div class="jz">NO.123456789</div> -->
<!-- 						</td> -->
<!-- 	                        <td class="zz"> -->
<!-- 								<div class="jz">FA00030加勒比卧房家具</div></td> -->
<!-- 	                        <td class="zz"> -->
<!-- 								<div class="jz">12</div> -->
<!-- 							</td> -->
<!-- 	                        <td class="zz"> -->
<!-- 								<button type="button" class="btn paigong jz" style="background-color: #36A0AC;width: 80px;color: #FFFFFF">派工</button> -->
<!-- 							</td> -->
<!-- 	                        <td class="zz" style="position: relative"><button type="button" class="btn paigong jz" style="background-color: #36A0AC;width: 80px;color: #FFFFFF">派工</button></td> -->
<!-- 	                        <td style="position: relative"> -->
<!-- 								<div class="gh"> -->
<!-- 	                        <div class="gh_top bck01"><span id="clerkName">周奇</span><span id="num">0</span></div> -->
<!-- 	                        <div class="gh_buttom"><span id="date">20160519</span><br><span id="wgnum">完工0</span></div> -->
<!-- 								</div> -->
<!-- 	                        </td> -->
<!-- 	                        <td style="position: relative"> -->
<!-- 								<div class="gh"> -->
<!-- 	                        <div class="gh_top bck02"><span id="clerkName">周2奇</span><span id="num">247</span></div> -->
<!-- 	                        <div class="gh_buttom"><span id="date">20160519</span><br><span id="wgnum">完工170</span></div> -->
<!-- 									</div> -->
<!-- 	                        </td> -->
<!-- 	                        <td style="position: relative"> -->
<!-- 								<div class="gh"> -->
<!-- 	                        <div class="gh_top bck03"><span id="clerkName">周3奇</span><span id="num">240</span></div> -->
<!-- 	                        <div class="gh_buttom"><span id="date">20160519</span><span id="wgnum">完工180</span></div> -->
<!-- 									</div> -->
<!-- 								<div class="gh"> -->
<!-- 	                        <div class="gh_top bck03"><span id="clerkName">周4奇</span><span id="num">241</span></div> -->
<!-- 	                        <div class="gh_buttom"><span id="date">20160519</span><br><span id="wgnum">完工181</span></div> -->
<!-- 	                        </div> -->
<!-- 								<div class="gh"> -->
<!-- 	                        <div class="gh_top bck03"><span id="clerkName">周5奇</span><span id="num">242</span></div> -->
<!-- 	                        <div class="gh_buttom"><span id="date">20160519</span><br><span id="wgnum">完工182</span></div> -->
<!-- 	                        </div> -->
<!-- 	                        </td> -->
<!-- 	                        <td class="zz"> -->
<!-- 								<div class="jz">已完成</div> -->
<!-- 							</td> -->
<!-- 	                    </tr> -->
                    </tbody>
                </table>
		</div>
</div>

<div id="paigongitem" title="表格操作内容模板" style="display: none;">
<button type="button" class="btn paigong jz" style="background-color: #36A0AC;width: 80px;color: #FFFFFF">派工</button>
</div>
<div id="emplitem" title="表格显示内容模板" style="display: none;">
	<div class="gh">
		<div class="gh_top"><span id="clerkName">周奇</span><span id="num">0</span>
		<span style="display: none;" id="clerkid"></span>
		<span style="display: none;" class="pgdh"></span>
		<span style="display: none;" id="plan_end_date"></span>
		</div>
		<div class="gh_buttom"><span id="WGSJ"></span><br><span id="wgnum">完工0</span></div>
	</div>
</div>


<div class="tck"></div>
<div class="tc">
	<div class="tc_divk">
		<div class="tc_div">
			<div class="tc_div01">
				<div class="tc_div01_left">工序</div>
				<div class="tc_div01_right gx" style="text-align: left;text-indent: 20px"></div>
				<div class="clear"></div>
			</div>
			<div class="tc_div02">
				<div class="tc_div01_left">派工单号</div>
				<div class="tc_div01_right pgdh" style="text-align: left;text-indent: 20px" title="自动生成"></div>
				<span id="PH" style="display: none;"></span>
				<span id="item_id" style="display: none;"></span>
				<span id="orderNo" style="display: none;"></span>
				<span id="ivt_oper_listing" style="display: none;"></span>
				<span id="customer_id" style="display: none;"></span>
				<div class="clear"></div>
			</div>
			<div class="tc_div03">
				<div class="tc_div03_left">生产工人</div>
				
				<div id="emplinfo" title="模板" style="display: none;">
				<div class="emplinfo"><span id="name">张三</span>
				<span id="num"></span>
				<span id="clerkid" style="display: none;"></span>
				<span id="pgdhc" style="display: none;"></span>
				</div>
				</div>
				
				<div class="tc_div03_right" style="text-align: left;text-indent: 20px">
				<div class="empl">
				</div>
					<div class="find_position02">
						<img src="../pc/images/Search.png">
					</div>
				</div>
			</div>
			<div class="tc_div04">
				<div class="tc_div01_left">总派工数量</div>
				<div class="tc_div01_right pgsl" style="text-align: left;text-indent: 20px">
				</div>
				<div class="clear"></div>
			</div>
			<div class="tc_div05">
				<div class="tc_div01_left" style="width: 35%;">要求完工时间</div>
				<div class="tc_div01_right" style="text-align: left;text-indent: 20px;width: 65%;">
					<input class="form-control Wdate" id="plan_end_date" maxlength="40" type="date" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false})">
				</div>
				<div class="clear"></div>
			</div>
			<div class="tc_div06">
				<div class="tc_div06_left">工艺图纸</div>
				<div class="tc_div06_right" style="text-align: left;text-indent: 20px">
					<div class="imgk">
<!--                         <img class="img-responsive" src="../pc/images/03产品首页_03.jpg"> -->
					</div>
					<span class="btn btn-default">选择文件
						<input type="file" class="input-upload" name="imgFile" id="imgFile" onchange="imgUpload(this);">
					</span>
				</div>
			</div>
			<div class="tc_div07">
				<button type="button" class="btn pull-left btn_style" style="margin-right: 0">取消</button>
				<button type="button" class="btn pull-right btn_style" style="margin-right: 0">保存</button>
				<div class="clear"></div>
			</div>
		</div>
	</div>
</div>
<div class="tc2">
	<div class="input_box">
	<div class="col-lg-10 col-xs-10">
	<input type="text" class="form-control" id=clerkword >
	</div>
	<label class="col-lg-2 col-xs-2" style="margin-top: 7px;cursor: pointer">
	<span class="clerkfind">搜索</span>
	</label>
	<div class="clearfix"></div>
	</div>
	<div id="workygitem" style="display: none;">
	<li>
			<div class="name_box">
                <div class="pro-check" style="position: absolute;left:5px;top: 5px;cursor: pointer"></div>
				<span data-name="clerk_name">gr.clerk_name</span><span data-name="clerk_id" style="display: none;">gr.clerk_id</span>
				<input data-num="num" type="text" style="color: initial;width: 100px;height: 30px;" placeholder="派工数量">
			</div>
		</li>
	</div>
	<ul>
<!-- 		<li> -->
<!-- 			<div class="name_box"> -->
<!-- 				<div class="pro-check" style="position: absolute;left:5px;top: 5px;cursor: pointer"></div> -->
<!-- 				赵四 -->
<!-- 			</div> -->
<!-- 		</li> -->
	</ul>
	<button type="button" class="btn btn_style02 clerkqd" style="margin-top: 10px">确定</button>
</div>
<div class="zz2">
		<img class="center-block" src="images/03产品首页_03.jpg">
</div>
<script type="text/javascript">
<!--

//-->
</script>
</body>
</html>