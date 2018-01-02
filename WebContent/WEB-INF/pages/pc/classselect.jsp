<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="box-head">
<div class="col-sm-3">
  <div class="form-group">
      <div class="input-group">
        <input type="text" class="form-control input-sm" maxlength="20" placeholder="请输入搜索关键词" id="searchKey">
        <span class="input-group-btn">
          <button class="btn btn-success btn-sm find" type="button">搜索</button>
        </span>
      </div>
    </div>
</div>
  <button type="button" class="btn btn-primary btn-sm" id="product-check">筛选</button>
<div class="side-cover" style="display: none;"></div>
<div class="cover" style="display: block;"></div>
<div class="product-check" style="display: block;">
<div class="p-c-header" style="display: none;">
  <span class="title">筛选</span>
  <span class="left-btn">取消</span>
  <span class="right-btn">确定</span>
</div>
<div class="p-c-body">
  <div class="p-c-group">
    <div class="p-c-title active">
      <span>品牌</span>
    </div>
    
  </div>
  <div class="p-c-group">
    <div class="p-c-title">
      <span>用途</span>
    </div>
  </div>
  <div class="p-c-group">
    <div class="p-c-title">
      <span>类别</span>
    </div>
  </div>
  <div class="p-c-group">
    <div class="p-c-title">
      <span>店铺</span>
    </div>
  </div>
  <div class="p-c-group">
    <div class="p-c-title">
      <span>价格区间</span>
    </div>
  </div>
</div>
<div class="p-c-content">
  <ul style="display: block;">
  <li class="active">
    <span>全部品牌</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
  <li class="active">
    <span>林氏木业</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li> 
</ul>
<ul style="display: none;">
  <li>
    <span>全部用途</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
  <li>
    <span>用途1</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
</ul>
<ul style="display: none;">
  <li>
    <span>全部类别</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
  <li>
    <span>沙发</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li> 
</ul>
<ul style="display: none;">
  <li>
    <span>所有店铺</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
  <li>
    <span>店铺1</span>
    <i class="glyphicon glyphicon-ok"></i>
  </li>
</ul>
<ul style="display: none;">
    <li>
      <span>全部价格</span>
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>1-100</span><input type="hidden" value="1-100">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
     <li>
      <span>100-300</span><input type="hidden" value="100-300">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>300-1000</span><input type="hidden" value="300-1000">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>1000-1500</span><input type="hidden" value="1000-1500">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>1500-2000</span><input type="hidden" value="1500-2000">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>2000-2500</span><input type="hidden" value="2000-2500">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    <li>
      <span>2500-3000</span><input type="hidden" value="2500-3000">
      <i class="glyphicon glyphicon-ok"></i>
    </li>
    
  </ul>
</div>
<div class="clear-ctn" style="display: none;">
        <div class="clear-btn">清除选项</div>
      </div>
    </div>
</div>