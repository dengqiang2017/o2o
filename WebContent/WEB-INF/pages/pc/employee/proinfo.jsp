<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="proinfo">
<div class="imgdiv">
<input type="checkbox" id="check" style="width: 20px;height: 20px;position: absolute; left: 6px; top: -2px;">
<img src="" >
<!-- onerror="this.style.display='none';" -->
</div>
<div class='infodiv'>
<span id="item_id" style="display: none;"></span>
	<ul>
		<li style="display: block;">
		<div class="pull-left">
		<span id="item_name" style="font-weight: bold;" class="text-overflow"></span>
		</div>
		<div class="pull-left">
		<span onclick="upDownProInfo(this);" class="glyphicon glyphicon-chevron-up"></span>
		</div>
		<div class="clearfix"></div>
		</li>
		<li class="color-li"><label>颜色:</label><div id="item_color" class="xs"></div><div class="clearfix"></div></li>
		<li class="color-li"><label>型号:</label><div id="item_type" class="xs"></div><div class="clearfix"></div></li>
		<li><label>规格:</label><span	id="item_spec"></span></li>
		<li><label>品牌:</label><span id="class_card"></span></li>
		<li><label>质量等级:</label><span id="quality_class"></span></li>
	</ul>
</div>
<div class="clearfix"></div>
</div>