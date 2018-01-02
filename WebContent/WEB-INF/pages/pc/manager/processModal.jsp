<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first "></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">增加审批步骤</h4>
			</div>
			<div class="modal-body" style="max-height:320px; overflow-y:scroll;">
				<form>
		          <div class="form-group">
		            <label class="control-label">审批人</label>
		            <div class="input-group">
						<span class="form-control input-sm"  title="点击浏览选择员工" id="clerk_name"></span>
							<span class="input-group-btn">
						<input type="hidden"  name="clerk_id" id="clerk_id">
						<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm" type="button">浏览</button>
					    </span>
					</div>
		          </div>
		          <div class="form-group">
		            <label class="control-label">审批部门</label>
		            <div class="input-group">
						<span class="form-control input-sm"  title="点击浏览选择部门"  id="dept_name"></span>
						<span class="input-group-btn">
							<input type="hidden" name="dept_id" id="deptId">
							<button class="btn btn-default btn-sm" type="button">X</button>
						    <button class="btn btn-success btn-sm" type="button">浏览</button>
					    </span>
					</div>
		          </div>
		          <div class="form-group">
		            <label class="control-label">审批步骤</label>
		            <span class="form-control input-sm" id="approval_step" ></span>
<!-- 		            <input type="text" class="form-control input-sm" data-number="num" name="approval_step" id="approval_step" > -->
		          </div>
		          <div class="form-group">
		            <label class="control-label">可否跳过?</label>
		            <select type="text" class="form-control input-sm" name="if_skip" id="ifSkip">
		            	<option value="否">否</option>
		            	<option value="是">是</option>
		            </select>
		          </div>
		          <input type="hidden" id="item_id">
		        </form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" id="closeDiv">取消</button>
				<button type="button" class="btn btn-primary" id="saveprocess">确定</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
