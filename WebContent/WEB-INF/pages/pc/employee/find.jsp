<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <div class="form">
		<form id="findForm">
<div class="pull-left"> 
  	  <div class="form-group" style="width: 260px;">
    <div class="input-group">
    <input id="type_id" type="hidden" name="type_id" value="">
    <span class="form-control" id="sort_name">产品类别</span>
      <div class="input-group-addon clear" style="cursor: pointer;">x</div>
      <div class="input-group-addon cls"  style="cursor: pointer;">浏览</div>
    </div>
  </div>
  	
</div>
 <div class="pull-left">
	<div class="form-group">
	<label>物料来源</label>
	<select id="item_style" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>品牌</label>
	<select id="class_card" class="form-control input-sm" style="display: inline-block;width: auto;"></select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>质量等级</label>
	<select id="quality_class" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>型号</label>
	<select id="item_type" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>结构</label>
	<select id="item_struct" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>颜色</label>
	<select id="item_color" class="form-control input-sm" style="display: inline-block;width: auto;">
	</select>
	</div>
</div>
<div class="pull-left">
	<div class="form-group">
	<label>规格</label>
	<input type="text" id="item_spec" class="form-control input-sm" maxlength="30" style="display: inline-block;width: auto;">
	</div>
</div>
<div class="pull-left">
	<div class="form-group" style="max-width: 220px;">
		<div class="input-group">
			<input type="text" class="form-control input-sm" maxlength="50"
				placeholder="请输入搜索关键词" id="searchKey"> <span
				class="input-group-btn">
				<button class="btn btn-success btn-sm find" type="button">搜索</button>
			</span>
		</div>
	</div>
</div><div class="clearfix"></div>
		</form>
	</div>