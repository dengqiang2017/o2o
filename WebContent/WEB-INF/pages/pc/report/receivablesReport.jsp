<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../res.jsp" %>
	<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script src="../js/o2od.js${requestScope.ver}"></script>
		<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
	<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
		<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/report/receivablesReport.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="../employee/selClient.jsp" %>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
		  	 <div class="box-head">
				<%@include file="../employee/showSelectClient.jsp" %>
       		</div>
				<div class="box-body">
					<!-- 所有sheet公用 -->
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
<!-- 				            <a class="btn btn-primary btn-sm btn-folding addNo">新增</a> -->
				            <button type="button" class="btn btn-danger btn-sm"><!-- <span class="glyphicon glyphicon-share-alt"></span> -->导出</button>
				            <!-- <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导入</button> -->
				        </div>
						<form action="" style="clear:both;overflow:hidden;">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">起始日期</label>
				                <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" name="beginDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结束日期</label>
				                <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">关键词</label>
				                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词">
				              </div>
				            </div>
				             <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结算方式</label>
				                <div class="input-group">
									<span class="form-control input-sm" id="settlement_name"></span>
									<span class="input-group-btn">
									<input type="hidden" class="form-control input-sm"  id="settlement_id" name="rcv_hw_no">
										<button type="button" class="btn btn-default btn-sm">X</button>	
								        <button class="btn btn-success btn-sm" type="button" id="settlement">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
 				            <div class="col-sm-6 col-lg-4 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<a class="btn btn-primary btn-sm addNo" style="margin-top:25px;">新增</a> -->
				            	<span id="upload-btn" class="btn btn-sm btn-danger" style="margin-top:25px;">导入
									<input type="file">
								</span>
				            	<button type="button" class="btn btn-danger btn-sm" id="hide" style="margin-top:25px;">导出</button>
				            </div>
						</form>
						<div class="text-center">
							<h3>销售收款报表</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>收款日期</th>   
								       <th>客户名称</th>  
 								       <th>实收金额</th>   
								       <th>结算方式</th>   
								       <th>支付方式</th>   
								       <th>收款单号</th>  
								       <th>收款部门</th> 
								       <th>收款人</th> 
								       <th>销售订单号</th> 
								       <th>查看</th> 
								    </tr>
								</thead>
								<tbody>
									 
								</tbody>
							</table>
						</div>
						<div class="pull-right" style="display: none;">
						    <button type="button" class="btn btn-info btn-sm">首页</button>
						    <button type="button" class="btn btn-info btn-sm">上一页</button>
						    <button type="button" class="btn btn-info btn-sm">下一页</button>
						    <button type="button" class="btn btn-info btn-sm">末页</button>
						</div>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="image-zhezhao" style="display:none">
        <div class="img-ku">
            <div id="imshow"></div>
        </div>
	    <button class="btn btn-danger center-block" id="print">打印凭证</button>
    <div class="gb" id="closeimgshow"></div>
</div>
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

