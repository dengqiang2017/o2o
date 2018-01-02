<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<%@include file="../res.jsp" %>
	<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script src="../js/o2od.js${requestScope.ver}"></script>
	<script src="../pc/js/employee/findparms.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
<!-- 	<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script> -->
	<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/report/choiceSupplier.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/report/payProcurementReport.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="../employee/selSupplier.jsp"%>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
		  	 <div class="box-head">
				<%@include file="../employee/showSelectSupplier.jsp" %>
       		</div>
				<div class="box-body">
					<!-- 所有sheet公用 -->
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
				        </div>
						<form action="" style="clear:both;overflow:hidden;" id="gzform">
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">起始日期</label>
				                <input type="date" id="d4311"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:true})" name="beginDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结束日期</label>
				                <input type="date" id="d4312"
				class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:true})" name="endDate">
				              </div>
				            </div>
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">关键词</label> -->
<!-- 				                <input type="text" class="form-control input-sm" name="searchKey" maxlength="20" placeholder="请输入关键词"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
				             <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
 				            <div class="col-sm-12 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find">搜索</button>
				            </div>
						</form>
						<div class="text-center">
							<h3>付款统计报表</h3>
						</div>
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>付款单号</th> 
								       <th>供应商</th>  
								       <th>供应商电话</th>  
								       <th>付款日期</th>   
 								       <th>付款金额</th>   
								       <th>支付方式</th>   
								       <th>经办部门</th> 
								       <th>经办人</th> 
								       <th>凭证</th> 
								    </tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="pull-right">
							<span style="width: 50px;height: 20px;text-align: center;line-height: 20px" id="page">当前页:0</span>
					    	<input type="hidden" value="" id="totalPage">
						    <button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
							<button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
							<button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
							<button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
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
<!-- 	    <button class="btn btn-danger center-block" id="print">打印凭证</button> -->
    <div class="gb" id="closeimgshow"></div>
</div>
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

