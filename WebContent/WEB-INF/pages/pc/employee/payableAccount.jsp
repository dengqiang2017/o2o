<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
	<script src="../js/o2otree.js?ver=001"></script>
	<script src="../js/o2od.js?ver=001"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../pc/js/customer/accountStatement.js?ver=001"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span><a
				href="../employee.do">员工首页</a></li>
	  <li><span class="glyphicon glyphicon-triangle-right"></span>应付明细账</li>
	</ol>
	<div class="header-title">应付明细账
		<a href="../employee.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
	</div>
	<div class="header-logo"></div> 
</div>
<div class="container">
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				<div class="box-body">
					<!-- 所有sheet公用 -->
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开搜索</button>
				            <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
				            <!-- <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导入</button> -->
				        </div>
						<form action="" style="clear:both;overflow:hidden;">
						<input type="hidden" name="client_id">
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
				                <input type="date" id="d4312" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">关键词</label>
				                <input type="text" class="form-control input-sm" name="key_words" maxlength="20" placeholder="请输入关键词">
				              </div>
				            </div> 
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">结算方式</label> -->
<!-- 				                <div class="input-group"> -->
<!-- 									<span class="form-control input-sm" id="settlement_name"></span> -->
<!-- 									<span class="input-group-btn"> -->
<!-- 									<input type="hidden" class="form-control input-sm"  id="settlement_id" name="settlement_sortID"> -->
<!-- 										<button type="button" class="btn btn-default btn-sm">X</button>	 -->
<!-- 								        <button class="btn btn-success btn-sm" type="button" id="settlement">浏览</button> -->
<!-- 								    </span> -->
<!-- 								</div> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
				            <div class="col-sm-3 col-lg-2 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
				            	<button type="button" class="btn btn-danger btn-sm" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
				            </div>
						</form>
						<div class="text-center">
							<h3>应付明细账</h3>
						</div>
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr> 
								       <th><div class="checkbox"></div></th> 
								       <th>付款单号</th>  
								       <th>付款日期</th>  
								       <th>应付金额</th>  
								       <th>已付金额</th>  
								       <th>呆坏金</th>  
								       <th>产品编码</th>  
								       <th>产品名称</th>   
								       <th>型号</th> 
								       <th>规格</th> 
								       <th>颜色</th>   
								       <th>包装数</th> 
								       <th>包装单位</th> 
								       <th>基本单位</th> 
								       <th>单价</th> 
 								       <th>折扣</th>   
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
<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
</body>
</html>

