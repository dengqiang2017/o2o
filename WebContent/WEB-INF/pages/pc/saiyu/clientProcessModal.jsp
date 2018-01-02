<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first ">
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">增加协同步骤</h4>
			</div>
			<div class="modal-body" style="max-height:320px; overflow-y:scroll;">
				<form>
				<div class="form-group" style="text-align: center;">
		            <label class="radio-inline">
		                <input checked type="radio" name="inlineRadioOptions" value="0" data-approval="approval_man"> 协同人
		            </label>
		            <label class="radio-inline">
		                <input type="radio" name="inlineRadioOptions" value="1" data-approval="approval_role"> 协同角色
		            </label>
			        </div>
		          <div class="form-group" id="clerk_nameSelect">
		            <label class="control-label">协同人</label>
		            <div class="input-group" id="customer">
						<span class="form-control input-sm"  title="点击浏览选择客户所属成工" id="customer_name"></span>
							<span class="input-group-btn">
						<input type="hidden"  name="customer_id" id="customer_id">
						<button class="btn btn-default btn-sm" type="button">X</button>
						        <button class="btn btn-success btn-sm" type="button">选择客户的员工</button>
					    </span>
					</div>
		          </div>
		          <div class="form-group" style="display: none;" id="headshipselect">
		            <label class="control-label">协同角色</label>
		            <select class="form-control input-sm" name="headship" id="headship">
		            	<option value=""></option>
		            	<option value="内勤">内勤</option>
		            	<option value="采购">采购</option>
		            	<option value="财务">财务</option>
		            	<option value="经理">经理</option>
		            	<option value="会计">会计</option>
		            	<option value="出纳">出纳</option>
		            </select>
		          </div>
		          <div class="form-group">
		            <label class="control-label">协同部门</label>
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
		            <label class="control-label">协同步骤</label>
		            <span class="form-control input-sm" data-number="num"  id="approval_step"></span>
		          </div>
		          <div class="form-group" style="display: none;">
		            <label class="control-label">可否跳过?</label>
		            <select class="form-control input-sm" name="if_skip" id="ifSkip">
		            	<option value="否">否</option>
		            	<option value="是">是</option>
		            </select>
		          </div>
		          <div class="form-group">
		            <label class="control-label">推送结果通知?</label>
		            <select class="form-control input-sm" name="noticeResult" id="noticeResult">
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
</div>