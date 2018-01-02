<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pcxy/css/global.css?ver=729103">
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/accountStatement.js${requestScope.ver}"></script>
<style type="text/css">
.radio{
float:left;
margin-top:10px;
margin-right:10px;
}
</style>
</head>
<body>
<div class="bg"></div>
<%@include file="../header.jsp" %>
<%@include file="../employee/selClient.jsp" %>
<div class="container">
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
<!-- 				            <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导出</button> -->
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
				            <div class="col-sm-3 col-lg-2 m-t-b" style="display: none;">
				              <div class="form-group">
				                <label for="">结算方式</label>
				                <div class="input-group">
									<span class="form-control input-sm" id="settlement_name"></span>
									<span class="input-group-btn">
									<input type="hidden" class="form-control input-sm"  id="settlement_id" name="settlement_sortID">
										<button type="button" class="btn btn-default btn-sm">X</button>	
								        <button class="btn btn-success btn-sm" type="button" id="settlement">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b" style="display: none;">
				              <div class="form-group">
				                <label for="">是否赠料</label>
				                <select class="form-control input-sm" name="if_LargessGoods">
				                	<option value=""></option>
				                	<option value="否">否</option>
				                	<option value="是">是</option>
				                </select>
				              </div>
				            </div>
				            <div class="col-sm-6 col-lg-6 m-t-b">
				            <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<button type="button" class="btn btn-danger btn-sm" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span> 导出</button> -->
				            	<a class="btn btn-danger btn-sm" style="margin-top:25px;" id="printdzd">打印客户对账单</a>
				            	<button type="button" class="btn btn-danger btn-sm" style="margin-top:25px;" id="cuikuan">催款</button>
				            	<button type="button" class="btn btn-danger btn-sm" style="margin-top:25px;" id="yqdz">邀请客户对账</button>
				            </div>
						</form>
	<div class="radio-group">
	<div class="radio">
	<label class="radio-inline">
	<input type="radio" value="全部" name="if_check" checked="checked">全部
	</label>
	</div>
	<div class="radio" style="margin-top:10px">
	<label class="radio-inline">
	<input type="radio" value="已对账" name="if_check">已对账
	</label>
	</div>
	<div class="radio" style="margin-top:10px">
	<label class="radio-inline">
	<input type="radio" value="未对账" name="if_check">未对账
	</label>
	</div>
	<div style="clear:both"></div>
	</div>
						<div class="text-center">
							<h3>客户对账单</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>单号</th>  
								       <th>发生日期</th>  
								       <th>业务类型</th> 
 								       <th>摘要备注</th>   
								       <th>结算方式</th>   
								       <th>应收金额</th> 
								       <th>实收金额</th> 
								       <th>欠款金额</th>   
								       <th>产品简称</th> 
								       <th>数量</th> 
								       <th>客户名称</th> 
								       <th>对账时间</th>
								       <th>备注</th>
<!-- 								   <th>厂价金额</th> 
								       <th>现场折扣及其它</th>  -->
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
				<img alt="" src="" id="qianming">
			</div>
		</div>
	</div>
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}<!-- <span class="glyphicon glyphicon-earphone"></span> -->
</div>
 
</body>
</html>

