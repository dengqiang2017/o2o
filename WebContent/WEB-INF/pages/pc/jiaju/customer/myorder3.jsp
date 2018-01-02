<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

		<div class="ctn">
			<div class="ctn-fff box-ctn">
				 
				<div class="box-body">
					<!-- 分客户 -->
						<div class="folding-btn m-t-b">
					            <button type="button" class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button> 
					        </div>
							<%@include file="../../orderTrackingFind.jsp" %>
								<button type="button" class="btn btn-primary btn-folding btn-sm" id="qrsh" style="display: none;margin-top: 10px;">确认收货</button>
<!-- 							<button type="button" class="btn btn-primary btn-folding btn-sm" id="showsh" style="display: none;">查看收货</button>					 -->
<!-- 							<button type="button" class="btn btn-primary btn-folding btn-sm" id="pjdd" style="display: none;">评价订单</button> -->
						<div class="ctn">
							<div class="text-center">
								<h3>订单跟踪</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>
									       <th>操作</th>  
									       <th>产品简称</th> 
									       <th>订单数量</th> 
									       <th>单位</th> 
									       <th>折算数量</th> 
									       <th>折算单位</th> 
									       <th>单价</th> 
									       <th>金额</th>  
									       <th>订货日期</th>
									       <th>状态</th> 
									       <th>订单号</th>  
									       <th>车牌号</th>
									       <th>司机</th>
<!-- 									       <th>物流方式</th> -->
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
							<div class="pull-right" style="margin-top:10px">
							    <button type="button" class="btn btn-info btn-sm" id="onePage">首页</button>
							    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="nextPage">下一页</button>
							    <button type="button" class="btn btn-info btn-sm" id="endPage">末页</button>
							</div>
						</div>
					
				</div>
			</div>
		</div>
