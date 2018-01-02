<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="left-hide-ctn" style="display: none;">
	<h4>供应商信息</h4>
	<div class="form-group">
		<div class="input-group">
			<input type="text" class="form-control input-sm" maxlength="50"
				id="supplierkeyname" placeholder="请输入搜索关键词"> <span
				class="input-group-btn">
				<button class="btn btn-danger btn-sm" type="button" id="findclient">搜索</button>
			</span>
		</div>
	</div>
	<div class="hide-table">
		<ul class="hide-title">
			<li class="col-xs-6">供应商</li>
			<li class="last col-xs-6">手机号</li>
		</ul>
		<div>
			<ul class="hide-msg">
				<li class="col-xs-6"></li>
				<li class="last col-xs-6"></li>
				<li><input type="hidden"></li>
			</ul>
		</div>
	</div>
	<div class="ctn"> 
      <button class="btn btn_add_client" type="button">点击加载更多</button>
    </div>
</div>
<div class="cover" style="display: none;"></div>