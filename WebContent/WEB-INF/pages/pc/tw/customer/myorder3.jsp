<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="container" >
	<div class="row">
		<div class="ctn">
			<div class="ctn-fff box-ctn" style="min-height:750px;">
				 
				<div class="box-body">
					<!-- 分客户 -->
						<div class="folding-btn m-t-b">
					            <button type="button" class="btn btn-primary btn-folding btn-sm" id="expand">展开搜索</button> 
					        </div>
							<%@include file="../../orderTrackingFind.jsp" %>					
						<div class="ctn">
							<div class="text-center">
								<h3>订单跟踪</h3>
							</div>
							<div class="table-responsive">
								<table class="table table-bordered">
									<thead>
										<tr>
									       <th>产品简称</th> 
									       <th>订单数</th> 
									       <th>单位</th> 
									       <th>订货日期</th>
									       <th>应收金额</th>  
									       <th>状态</th> 
									       <th>订单号</th>  
									    </tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
							<div class="pull-right"> 
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
</div>