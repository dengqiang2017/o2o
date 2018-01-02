<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="modal_smsSelect" style="display: none;">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请选择通知方式</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  <input type="radio" name="NoticeStyle" value="0" checked="checked">仅微信通知
					</label>
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  <input type="radio" name="NoticeStyle" value="1"> 仅短信通知
					</label>
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  <input type="radio" name="NoticeStyle" value="2"> 微信和短信通知
					</label>
				</div>
				<div class="ctn" style="padding-left:20px;margin-bottom:5px;">
					<label class="radio-inline">
					  <input type="radio" name="NoticeStyle" value="3">不通知微信和短信
					</label>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div>
	</div>
</div>
</div>