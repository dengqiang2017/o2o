<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <script type="text/javascript" src="../pc/js/saiyu/spalread.js"></script>
   <style type="text/css">
	@media(min-width: 770px){
		.ctn-fff{
			margin-top: 50px;
		}
	}
</style>
   <div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a>
                &emsp;用户中心-><span><a href="javaScript:backOa();">我的协同</a>-></span><span>审批详细查看</span></div>
		<div class="ctn-fff box-ctn" >
		<input type="hidden" id="spNo" value="${requestScope.ivt_oper_listing}">
			<div class="box-head">
				<div class="panel panel-danger">
					<div class="panel-heading">
						<span>标题:报修审批</span>
					</div>
					<div class="panel-body">
						<p>报修信息:<span id="info"></span></p>
						<p>报修时间:<span id="store_date"></span></p>
						<p>报修单号:<span id="bxNo"></span></p>
						<input type="hidden" id="spNo">
						<p id="sqfujian">附件:
							<span class="glyphicon glyphicon-save table-dld"></span>
			            	<span class="glyphicon glyphicon-search table-dld"></span>
			            </p>
					</div>
				</div>
			</div>
			<div class="box-body">
				<h5>审批记录</h5>
			</div>
				<div id="spjlitem" style="display: none;">
					<div class="alert alert-success">
						<div class="ctn">
							<div class="col-sm-2 m-t-b" style="font-weight:700;"  id="OA_who_item"></div>
							<div class="col-sm-1 m-t-b" style="font-weight:700;" id="OA_what"></div>
							<div class="col-sm-5 m-t-b" id="store_date_item"></div>
							<div class="col-sm-2 m-t-b" style="fong-size:12px; color:#858585;" id="approval_YesOrNo"></div>
<!-- 							<div class="col-sm-2 m-t-b"> -->
<!-- 								<button type="button" class="btn btn-primary">附件</button> -->
<!-- 							</div> -->
						</div>
					</div>
				</div>
		</div>
