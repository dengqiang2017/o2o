<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block; top: 2%;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">选择计划</h4>
			</div>
			<div class="modal-body" style="max-height:300px; overflow-y: scroll;">
				<div class="form-group" style="overflow:hidden">
					<label for="" style="float:left; width:40px;">日期</label>
					<input type="date" class="form-control input-sm Wdate" value="${requestScope.beginTime }"
					onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d',minDate:'%y-%M-{%d-${requestScope.begin}}',dateFmt:'yyyy-MM-dd'})" 
					style="float:left; margin-left:2%; width:30%;">
					<span style="float:left; margin-left:2%">~</span>
					<input type="date" class="form-control input-sm Wdate" 
					onfocus="WdatePicker({skin:'whyGreen',maxDate:'%y-%M-%d',minDate:'%y-%M-{%d-${requestScope.endTime}}',dateFmt:'yyyy-MM-dd'})" style="float:left; margin-left:2%; width:30%;">
				</div>
				<div class="form-group" style="overflow:hidden">
<!-- 					<label for="" style="float:left; width:40px;">关键词</label> -->
					<input type="text" class="form-control input-sm" style="float:left; margin-left:2%; width:30%;" placeholder="请输入搜索关键词" id="plangjc">
					<button type="button" class="btn btn-primary btn-sm"  style="float:left; margin-left:2%;" id="planfind">搜索</button>
				</div>
<!-- 				 -->
				<div class="ctn">
					
				</div>
				<div class="ctn">
		            <button class="btn_add_plan" type="button">点击加载更多</button>
		        </div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" id="planclose">返回</button>
				<button type="button" class="btn btn-primary" id="planSave">提交</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
 