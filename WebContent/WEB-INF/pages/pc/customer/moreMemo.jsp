<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first moreMemo"></div>
<div class="modal-first moreMemo" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">要求</h4>
			</div>
			<div class="modal-body" style="max-height:260px; overflow-y:scroll;">
				<form>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">制造要求</label>
						<input type="text" class="form-control input-sm" name="c_memo" maxlength="30">
			          </div>	
					</div>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">工艺要求</label>
						<input type="text" class="form-control input-sm" name="memo_color" maxlength="30">
			          </div>	
					</div>
					<div class="col-sm-6">
			          <div class="form-group">
			            <label class="control-label">其它要求</label>
						<input type="text" class="form-control input-sm" name="memo_other" maxlength="30">
			          </div>	
					</div>
		        </form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="moreMemosave">确定</button>
				<button type="button" class="btn btn-primary" id="moreMemoClear">重置</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->