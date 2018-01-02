<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">销售收款单</h4>
			</div>
			<div class="modal-body" style="max-height:260px; overflow-y:scroll;">
				<form id="addFrom">
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">收款单号</label>
						<input type="text" class="form-control input-sm" name="recieved_id" maxlength="30" placeholder="不填时自动生成">
			          </div>	
					</div>
<!-- 					<div class="col-sm-6"> -->
<!-- 			          <div class="form-group"> -->
<!-- 			            <label class="control-label">客户名称</label> -->
<!-- 			            <div class="input-group"> -->
<!-- 							<span class="form-control input-sm" aria-describedby="basic-addon2"></span> -->
<!-- 								<span class="input-group-btn"> -->
					    			<input id="clientIdAdd" type="hidden" name="customer_id">
<!-- 							        <button class="btn btn-default btn-sm" type="button">X</button> -->
<!-- 							        <button class="btn btn-success btn-sm" type="button">浏览</button> -->
<!-- 							    </span> -->
<!-- 						</div> -->
<!-- 			          </div>	 -->
<!-- 					</div> -->
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">收款部门</label>
			            <div class="input-group">
			            	<span class="form-control input-sm" id="dept_name"></span>
							<span class="input-group-btn">
								<input type="hidden" name="dept_id" id="dept_id">
								<button type="button" class="btn btn-default btn-sm">X</button>
						        <button class="btn btn-success btn-sm" type="button">浏览</button>
					    	</span>
						</div>
			          </div>	
					</div>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">收款人</label>
			            <div class="input-group">
			            	<span class="form-control input-sm" id="clerk_name"></span>
							<span class="input-group-btn">
								<input type="hidden" name="clerk_id" id="clerk_id">
								<button type="button" class="btn btn-default btn-sm">X</button>
						        <button class="btn btn-success btn-sm" type="button">浏览</button>
						    </span>
						</div>
			          </div>	
					</div>
<!-- 					<div class="col-sm-6"> -->
<!-- 			          <div class="form-group"> -->
<!-- 			            <label class="control-label">应收金额</label> -->
<!-- 						<input type="tel" class="form-control input-sm" name="" data-number="num"  maxlength="30"> -->
<!-- 			          </div>	 -->
<!-- 					</div> -->
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">实收金额</label>
						<input type="tel" class="form-control input-sm" name="sum_si" data-number="n"  maxlength="30">
			          </div>	
					</div>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">结算方式</label>
			            <div class="input-group">
							<span class="form-control input-sm" id="settlement_name2"></span>
							<span class="input-group-btn">
							<input type="hidden" class="form-control input-sm"  id="paystyletxt" name="paystyletxt">
							<input type="hidden" class="form-control input-sm"  id="settlement_id2" name="rcv_hw_no">
								<button type="button" class="btn btn-default btn-sm">X</button>	
						        <button class="btn btn-success btn-sm" type="button">浏览</button>
						    </span>
						</div>
			          </div>
					</div>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">销售单号</label>
						<input type="text" class="form-control input-sm" name="rejg_hw_no" maxlength="30">
			          </div>	
					</div> 
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">备注</label>
						<input type="text" class="form-control input-sm" name="c_memo" maxlength="30">
			          </div>	
					</div> 
		        </form>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" id="close">取消</button>
				<button type="button" class="btn btn-primary" id="saveSales">确定</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal --> 