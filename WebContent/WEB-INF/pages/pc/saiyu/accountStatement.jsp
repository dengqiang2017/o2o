<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script src="../js/o2otree.js?ver=001"></script>
<script src="../datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="../pc/js/customer/accountStatement.js" type="text/javascript"></script>
<div style="min-height:750px;" class="ctn-fff box-ctn">
				<div class="box-body">
					<!-- 所有sheet公用 -->
						<div class="folding-btn m-t-b">
				            <button id="expand" class="btn btn-primary btn-sm btn-folding" type="button">展开搜索</button>
				            <button class="btn btn-danger btn-sm" type="button"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
				            <!-- <button type="button" class="btn btn-danger btn-sm"><span class="glyphicon glyphicon-share-alt"></span> 导入</button> -->
				        </div>
						<form style="clear: both; overflow: hidden;" action="">
						<input type="hidden" value="CS1C001164" name="client_id">
				           <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">起始日期</label>
				                <input type="date" name="beginDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2020-10-01\'}',isShowClear:false})" class="form-control input-sm Wdate" id="d4311">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结束日期</label>
				                <input type="date" name="endDate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" class="form-control input-sm Wdate" id="d4312">
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">关键词</label>
				                <input type="text" placeholder="请输入关键词" maxlength="20" name="key_words" class="form-control input-sm">
				              </div>
				            </div> 
				            <div class="col-sm-3 col-lg-2 m-t-b">
				              <div class="form-group">
				                <label for="">结算方式</label>
				                <div class="input-group">
									<span id="settlement_name" class="form-control input-sm"></span>
									<span class="input-group-btn">
									<input type="hidden" name="settlement_sortID" id="settlement_id" class="form-control input-sm" value="">
										<button class="btn btn-default btn-sm" type="button">X</button>	
								        <button id="settlement" type="button" class="btn btn-success btn-sm">浏览</button>
								    </span>
								</div>
				              </div>
				            </div>
				            <div class="col-sm-3 col-lg-2 m-t-b">
				            	<button style="margin-top:25px;" class="btn btn-primary btn-sm find" type="button">搜索</button>
				            	<button style="margin-top:25px;" class="btn btn-danger btn-sm" type="button"><span class="glyphicon glyphicon-share-alt"></span> 导出</button>
				            </div>
						</form>
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
								       <th>结算方式</th>   
								       <th>应收金额</th> 
								       <th>实收金额</th> 
								       <th>欠款金额</th>   
								       <th>产品简称</th> 
								       <th>数量</th> 
 								       <th>摘要备注</th>
<!-- 								       <th>客户名称</th>  -->
<!-- 								   <th>厂价金额</th> 
								       <th>现场折扣及其它</th>  -->
								    </tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div style="display: none;" class="pull-right">
						    <button class="btn btn-info btn-sm" type="button">首页</button>
						    <button class="btn btn-info btn-sm" type="button">上一页</button>
						    <button class="btn btn-info btn-sm" type="button">下一页</button>
						    <button class="btn btn-info btn-sm" type="button">末页</button>
						</div>
				</div>
			</div>