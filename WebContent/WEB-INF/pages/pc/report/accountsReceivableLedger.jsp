<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/report/accountsReceivableLedger.js${requestScope.ver}"></script>
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
					<div class="tabs-content">
						<div class="folding-btn m-t-b">
				            <button type="button" class="btn btn-primary btn-sm btn-folding" id="expand">展开</button>
<!-- 				            <a href="模态框-应收款总账.html" target="_blank" class="btn btn-primary btn-sm btn-folding">新增</a> -->
				            <button type="button" class="btn btn-danger btn-sm excel">导出</button>
				            <!-- <button type="button" class="btn btn-danger btn-sm find"><span class="glyphicon glyphicon-share-alt"></span> 导入</button> -->
				        </div>
						<form style="clear:both;overflow:hidden;">
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
				                <input type="text" id="d4312" class="form-control input-sm Wdate"
				onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2020-10-01',isShowClear:false})" name="endDate">
				              </div>
				            </div>
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">其它条件</label> -->
<!-- 				                <input type="text" class="form-control input-sm" name="myWhere" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div>	 -->
				            <div class="col-sm-3 col-lg-2 m-t-b">
			           		   <div class="form-group">
				               		 <label for="">期末为零？</label> <select id="Zero"
										class="form-control input-sm"  name="Zero" >	
										<option value="">全部</option>								
										<option value="0">期末金额为零的</option>
										<option value="1">期末金额不为零的</option>
					                </select>
				               </div>
				            </div>
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 			           		   <div class="form-group"> -->
<!-- 				               		 <label for="">汇总方式：</label>  -->
<!-- 				               		 <select id="tjfs" -->
<!-- 										class="form-control input-sm"  name="tjfs" > -->
<!-- 										<option value="0">全部</option> -->
<!-- 										<option value="1">按行政区划统计</option> -->
<!-- 										<option value="2">按销售部门统计</option>	 -->
<!-- 										<option value="2">按销售人员统计</option>																			 -->
<!-- 					                </select> -->
<!--                                        ctl+ :删除选中行 -->
<!-- 				               </div>				                -->
<!-- 				            </div>		 -->
                            <input type="hidden" class="form-control input-sm" id="customer_id" name="client_id">
				            <div class="col-sm-3 col-lg-2 m-t-b">
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

				            		            			            
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">关键词</label> -->
<!-- 				                <input type="text" class="form-control input-sm" name="key_words" maxlength="50"> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
<!-- 				            <div class="col-sm-3 col-lg-2 m-t-b"> -->
<!-- 				              <div class="form-group"> -->
<!-- 				                <label for="">行政区划</label> -->
<!-- 				                <div class="input-group"> -->
<!-- 									<span class="form-control input-sm" title="点击浏览选择" id="regionalism_name_cn"></span> -->
<!-- 									<span class="input-group-btn"> -->
<!-- 									    <input type="hidden" id="regionalismId" name="regionalism_id"> -->
<!-- 										<button type="button" class="btn btn-default btn-sm">X</button>	 -->
<!-- 								        <button class="btn btn-success btn-sm" type="button">浏览</button> -->
<!-- 								    </span> -->
<!-- 								</div> -->
<!-- 				              </div> -->
<!-- 				            </div> -->
				            
				            <div class="col-sm-6 col-lg-4 m-t-b">
				            	<button type="button" class="btn btn-primary btn-sm find" style="margin-top:25px;">搜索</button>
<!-- 				            	<a href="模态框-应收款总账.html" target="_blank" class="btn btn-primary btn-sm" style="margin-top:25px;">新增</a> -->
				            	<span id="upload-btn" class="btn btn-sm btn-danger" style="margin-top:25px;">导入
									<input type="file">
								</span>
				            	<button type="button" class="btn btn-danger btn-sm" id="hide" style="margin-top:25px;">导出</button>
				            </div>
						</form>
						<div class="text-center">
							<h3>应收款总账</h3>
						</div>
						<!-- 以收款员进行分类，每个收款员结束后进行合计 -->
						<div class="table-responsive">
							<table class="table table-bordered">
								<thead>
								    <tr>  
								       <th>客户名称</th>  
 								       <th>期初金额</th>   
 								       <th>应收金额</th>   
 								       <th>已收金额</th>   
 								       <th>呆坏金额</th>   
 								       <th>期末金额</th>   
 								       <th>行政区划</th>   
								       <th>授信额度</th>   
								       <th>账期（天）</th>  
								       <th>最大可发货余额</th> 
								    </tr>
								</thead>
								<tbody>
									<tr>

									</tr>
								</tbody>
							</table>
						</div>
						<div class="pull-right">
							<input type="hidden" id="page">
				            <input type="hidden" id="count">
				            <input type="hidden" id="totalPage">
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
</div>

<div class="footer">
	员工:${sessionScope.userInfo.personnel.clerk_name}
</div>
 
</body>
</html>

    