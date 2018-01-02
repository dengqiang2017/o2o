<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>O2O营销服务平台</title>
	<%@include file="../res.jsp" %>
	<script src="../js/o2otree.js${requestScope.ver}"></script>
	<script src="../js/o2od.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../jSignature/jSignature.min.js"></script>
	<script type="text/javascript" src="../pc/js/customer/accountStatement.js${requestScope.ver}"></script>
</head>
<body>
<div class="bg"></div>
<div class="header">
	<ol class="breadcrumb">
	  <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../customer.do">客户首页</a></li>
	  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>对账单</li>
	</ol>
	<div class="header-title">对账单
		<a href="../customer.do" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>	
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
<!-- 				            <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导出</button> -->
				            <!-- <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导入</button> -->
				        </div>
						<form action="" style="clear:both;overflow:hidden;">
						<input type="hidden" name="client_id" value="${sessionScope.customerInfo.upper_customer_id}">
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
				            <div class="col-sm-3 col-lg-2 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<button type="button" class="btn btn-danger btn-sm" style="margin-top:25px;"><span class="glyphicon glyphicon-share-alt"></span> 导出</button> -->
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
								       <th>操作</th>  
								       <th>单号</th>  
								       <th>发生日期</th>  
								       <th>业务类型</th> 
								       <th>结算方式</th>   
								       <th>应收金额</th> 
								       <th>实收金额</th> 
								       <th>欠款金额</th>   
								       <th>产品简称</th> 
								       <th>数量</th> 
 								       <th>对账时间</th>
 								       <th>摘要备注</th>
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
	<button type="button" class="btn btn-danger center-block btn-size qs_btn" style="margin-top: 20px;margin-bottom: 20px;">确认无误签字</button>

				</div>
			</div>
		</div>
	</div>
</div>
<div>
</div>
<div class="modal" id="addbeizhu" style="display: none;">
<div class="modal-dialog" style="height: 100px;width: 300px;">
	<div class="modal-content">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	<h4 class="modal-title">添加备注</h4>
	</div>
	<div class="modal-body">
<textarea rows="3" cols="35" maxlength="50"></textarea>
<div>
<button type="button" class="btn btn-primary" id="savebeizhu">确定</button>
<button type="button" class="btn btn-primary closedig">取消</button>
</div>
</div>
</div>
</div>
</div>
	<div class="modal" id="mymodal2">
	<div class="modal-dialog" style="height:100%;margin:0;width:100%">
	<div class="modal-content" style="height:100%">
	<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	<h4 class="modal-title">确认无误在此签字确认</h4>
	</div>
	<div class="modal-body">
	<div id="qianzi">
	<img src=""  style="width: 100%;height: 230px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px">
	<div id="signature"  style="width: 100%;height: 300px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px"></div>
	<button type="button" class="btn btn-success pull-right" onclick="$('#signature').jSignature('clear')" id="clear">清除</button>
	<button class="btn btn-success pull-right btnsize" >提交推送至华神木业</button>
	<div style="clear:both"></div>
	</div>
	</div>
	<div class="modal-footer">
	<a class="btn btn-default gb2" data-dismiss="modal">关闭</a>
	</div>
	</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

<div class="footer">
	客户:${sessionScope.customerInfo.clerk_name}
	<div class="btn-gp">
	<!-- 			<button class="btn btn-info">保存</button> -->
	<a href="../customer.do" class="btn btn-primary">返回</a>
	</div>
</div>
</body>
</html>

