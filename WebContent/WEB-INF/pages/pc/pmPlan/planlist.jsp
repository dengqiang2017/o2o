<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div style="display: none;" id="item">
            	<div class="col-xs-12 col-sm-12 col-md-6 dataitem" style="border: 1px solid aqua;">
            	<%@include file="../employee/proinfo.jsp"%>
            	<div style="border-bottom: 1px solid aqua;">
            	<div class="col-xs-12 col-sm-12 col-md-6">
					<label style="float: left;">计划数量:</label>
					<div class="num-input-xs">
						<span class="sub"></span> <input type="tel" class="num"
							id="pronum" data-num="num"> <span class="add"></span>
					</div>
					<div class="clearfix"></div>
				</div>
            	 <div class="col-xs-6 col-sm-6 col-md-6">
					<label>订单数量:</label><span id="sd_oq"></span>/<span class="item_unit"></span>
				</div>
            	<div class="col-xs-6 col-sm-6 col-md-6">
					<label>库存数量:</label><span id="use_oq"></span>/<span class="item_unit"></span>
				</div>
	            	<div class="col-xs-12 col-sm-12 col-md-6">
						<label>客户名称:</label> <span id="corp_sim_name"></span>
					</div>
					<div class="col-xs-12 col-sm-12 col-md-6">
						<label>客户电话:</label> <span id="movtel"></span>
					</div>
					<div class="col-xs-12 col-sm-12 col-md-6">
						<label>交货时间:</label> <span id="plan_end_date"></span>
					</div>
					<div class="col-xs-12 col-sm-12 col-md-6">
						<label>单号:</label> <span id="ivt_oper_listing"></span>
					</div>
					<div class="col-xs-12 col-sm-12 col-md-6">
						<label>排产编号:</label> <span id="PH"></span>
					</div>
				<div class="col-xs-12 col-sm-6 col-md-6">
				<label>备注:</label>
				<span id="c_memo"></span>
				</div>
				<div class="col-xs-12 col-sm-6 col-md-6">
				<label>备注:</label>
				<span id="detailc_memo"></span>
				</div>
				<div class="col-xs-12 col-sm-12 col-md-12">
				<label>特殊工艺备注:</label>
            	<span id="memo_color"></span>
            	<span id="memo_other"></span>
				</div>
            		<div class="clearfix"></div>
            	</div>
            	<span class="p-class" id="seeds_id" style="display: none;"></span> 
            	<div><button type="button" id="moreMemo" class="btn btn-primary btn-sm">排产信息</button>
            	</div>
            	
            	</div>
</div>
<!-- <div style="display: none;" id=itemmoban> -->
<!-- 	<div class="col-xs-6 col-sm-6 col-md-6" style="border: 1px solid aqua;"> -->
<!-- 		<input type="hidden" id="sid"> -->
<!-- 		<input type="hidden" id="ivt_oper_bill">  -->
<!-- 		<input type="hidden" id="clerk_id_sid"> -->
<!-- 		<span id="customer_id" style="display: none;"></span> -->
<!-- 		<div class="p-top" style="height: 160px;"> -->
<!-- 			<div class="col-sm-3 col-xs-5 pimg-ctn" style="height: 130px;"> -->
<!-- 	            <a><img class="pimg" src="" alt=""></a> -->
<!-- 	        </div> -->
<!-- 	        <div class="col-sm-9 col-xs-7 pmsg-ctn"> -->
<!--                 <span class="p-name" id="item_name"></span> -->
<!--                 <div class="ctn"> -->
<!-- 	            	<span class="p-class" id="item_spec"></span> -->
<!-- 	            	<span class="p-class" id="item_type"></span> -->
<!-- 	            	<span class="p-class" id="item_color"></span> -->
<!-- 	            	<span class="p-class" id="class_card"></span> -->
<!-- 	            	<span class="p-class" id="PH"></span> -->
<!-- 	            	<span class="p-class" id="c_memo"></span> -->
<!-- 	            	<span class="p-class" id="memo_color"></span> -->
<!-- 	            	<span class="p-class" id="memo_other"></span> -->
<!-- 	            	<span class="p-class" id="status_trans"></span>  -->
<!-- 	            	<span class="p-class" id="corp_sim_name"></span>  -->
<!-- 	            	<span class="p-class" id="detailauto_mps_id"></span>  -->
<!-- 	            	<span class="p-class" id="plan_end_date"></span>  -->
	            	
<!--                 </div> -->
                
<!--              </div> -->
<!-- 		</div> -->
<!-- 		<div class="p-middle"> -->
<!--         	<div class="pro-check  col-sm-1" style="position:relative;"></div> -->
<!--         	<div class="p-form col-sm-6"> -->
<!-- 					<label for="">数量</label>  -->
<!-- 					<div class="num-input-xs"> -->
<!--                       <span class="add"></span> -->
<!--                       <span class="sub"></span> -->
<!-- 						<input type="text" class="num" id="pronum" data-number="n">  -->
<!--                     </div> -->
<!-- 						<span class="p-content-xs" id="item_unit"></span> -->
<!-- 				</div> -->
<!--           	<div class="p-form col-sm-6" style="display: none;"> -->
<!-- 	            <label for="">折算数量</label>  -->
<!-- 	            <span id="pack_unit" style="display: none;"></span>  -->
<!-- 	            <input type="text" class="p-xs zsum" data-number="n" disabled="disabled">  -->
<!-- 	            <span id="item_unit"></span> -->
<!--           	</div> -->
<!--            	<div><button type="button" id="moreMemo" class="btn btn-primary btn-sm">排产信息</button></div> -->
<!--         </div> -->
<!--         <div class="p-middle"> -->
<!--         	<span><span>报价单编号:</span><span id="item_id"></span></span><span>订单编号:</span><span id="ivt_oper_listing"></span> -->
<!--         </div> -->
<!-- 	</div> -->
<!-- </div> -->

<div id="modal" style="display:none;">
   	<div class="modal-cover-first"></div>
	<div class="modal-first" style="display:block;">
   		<div class="modal-dialog">
       		<div class="modal-content">
           		<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title">排产信息</h4>
				</div>
				<div class="modal-body" style="max-height:320px; overflow-y:scroll;">
					<form>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">排产编号</label>
								<input type="text" class="form-control input-sm" name="PH" maxlength="14" 
								placeholder="最大长度14位,请保持每个产品不重复">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">制造要求</label>
								<input type="text" class="form-control input-sm" name="c_memo" maxlength="70">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">工艺要求</label>
								<input type="text" class="form-control input-sm" name="memo_color" maxlength="70">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">其他要求</label>
								<input type="text" class="form-control input-sm" name="memo_other" maxlength="70">
		          			</div>	
						</div>
	        		</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeDiv">取消</button>
					<button type="button" class="btn btn-primary" id="saveMoreMemo">确定</button>
				</div>
			</div>
		</div>
	</div>
</div>
