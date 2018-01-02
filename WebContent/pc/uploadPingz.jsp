<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first" style="display:none;"></div>
<div class="modal-first" style="display:none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请上传支付凭证</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传凭证
			<input type="file" name="imgFile" id="imgFile" onchange="imgUpload(this);">
			<input type="hidden" id="filepath">
			</a>
			<button type="button" id="scpz"  class="btn btn-primary btn-sm m-t-b">上传凭证</button>
			<div class="showimg">
			<img src="">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="scpzpc">确定</button>
			</div>
		</div>
	</div>
</div>