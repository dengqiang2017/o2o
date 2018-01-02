<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-sm-6" id="item01"></div>
<div class="col-sm-6" id="item02"></div>
<div style="display: none;">
	<div class="p-ctn" id="item">
		<input type="hidden" id="item_id">
		<input type="hidden" id="sid">
		<input type="hidden" id="ivt_oper_bill"> 
		<input type="hidden" id="clerk_id_sid">
		<div class="p-top" style="height: 160px;">
			<div class="col-sm-3 col-xs-5 pimg-ctn" style="height: 130px;">
	            <a><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a>
	        </div>
	        <div class="col-sm-9 col-xs-7 pmsg-ctn">
                <span class="p-name" id="item_name"></span>
                <div class="ctn">
	            	<span class="p-class" id="item_spec"></span>
	            	<span class="p-class" id="item_type"></span>
	            	<span class="p-class" id="item_color"></span>
	            	<span class="p-class" id="class_card"></span>
	            	<span class="p-class" id="PH"></span>
	            	<span class="p-class" id="c_memo"></span>
	            	<span class="p-class" id="memo_color"></span>
	            	<span class="p-class" id="memo_other"></span>
	            	<span class="p-class" id="status_trans"></span> 
	            	<span class="p-class" id="seeds_id" style="display: none;"></span> 
	            	<div><button type="button" id="moreMemo" class="btn btn-primary btn-sm">排产信息</button></div>
                </div>
             </div>
		</div>
		<div class="p-middle">
        	<div class="pro-check"></div>
        	<div class="p-form col-sm-6">
	            <label for="">数量</label> 
	            <input type="text" id="oper_oq" class="p-xs num" data-number="n"> 
	            <span id="casing_unit"></span>
        	</div>
          	<div class="p-form col-sm-6">
	            <label for="">折算数量</label> 
	            <span id="pack_unit" style="display: none;"></span> 
	            <input type="text" class="p-xs zsum" data-number="n" disabled="disabled"> 
	            <span id="item_unit"></span>
          	</div>
        </div>
        <div class="p-middle" id="ivt_oper_listing"></div>
	</div>
</div>

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
								<input type="text" class="form-control input-sm" name="PH">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">制造要求</label>
								<input type="text" class="form-control input-sm" name="c_memo">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">工艺要求</label>
								<input type="text" class="form-control input-sm" name="memo_color">
		          			</div>	
						</div>
						<div class="col-sm-6">
		          			<div class="form-group">
		            			<label class="control-label">其他要求</label>
								<input type="text" class="form-control input-sm" name="memo_other">
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
