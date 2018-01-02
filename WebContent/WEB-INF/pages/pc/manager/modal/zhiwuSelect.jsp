<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="modal_smsSelect" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">请选职务</h4>
</div>
<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
	<ul class="modal_ul">
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>采购</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>客服</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>出纳</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>库管</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>内勤</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>工程</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>发货管理员</span>
	</li>
	<li>
	<div class="pro-check" style="width:30px;margin:auto"></div><span>物流打包员</span>
	</li>
	</ul>
			</div>
			<div class="modal-footer">
	           <div class="pro-check" style="float:left" id="allchecked"><span style="line-height:30px;margin-left:30px">全选</span></div>
				<button type="button" class="btn btn-default guanbizhiwu" id="zhiwuClose">取消</button>
				<button type="button" class="btn btn-primary guanbizhiwu" id="zhiwuSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>