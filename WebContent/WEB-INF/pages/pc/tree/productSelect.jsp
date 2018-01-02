<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;"><!-- /.modal-dialog -->
<div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">产品选择</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline m-t-b">
		          <div class="form-group">
		            <label for="recipient-name" class="control-label">名称</label>
		            <input type="text" class="form-control" id="itemName">
		          </div>
		          <button type="button" class="btn btn-primary" id="findtree">搜索</button>
				 <button type="button" class="btn btn-primary" id="selectClient">确定</button>
		         <button type="button" id="closeTree" class="btn btn-default">取消</button>
		        </form>
<!-- 		        <ul class="nav nav-tabs" style="margin-top:10px;"> -->
<!-- 				    <li><a href="#">类型</a></li> -->
<!-- 				    <li class="active"><a href="#">产品</a></li> -->
<!-- 				</ul> -->
				<input type="hidden" id="item_id">
				<div class="tabs-content" style="height:400px;display: none;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.classtree}" var="product">
					<li class="parent_li"><span  class="product_tree">
					<i class="glyphicon glyphicon-leaf"></i>${product.sort_name}
					<input type="hidden" value="${product.sort_id}"></span></li>
					</c:forEach>
					</ul>
					</li>
					</ul>
					</div>
				</div>
				<div class="tabs-content" style="height:440px;">
					<div class="table" style="height:360px; overflow-y:scroll;margin-bottom:10px">
					<table class="table table-bordered">
							<thead>
								<tr>
							       <th>品牌</th>
							       <th>名称</th>
							       <th>可用库存</th>
							       <th>规格</th>
							       <th>型号</th>
							       <th>颜色</th>
							       <th>零售价</th>
							       <th>批发价</th>
							       <th>类型</th>
							       <th>外码</th>
							       <th>内码</th>
							    </tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
					<div class="btn-group">
						<!--<input type="text" id="page" value="0" data-number="num" style="width: 50px;">-->

					    <input type="hidden" id="totalPage" value="${requestScope.pages.totalPage}">
					    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
					    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
					    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
					    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
	<span id="page" style="width: 50px;height: 20px;text-align: center;line-height: 20px">当前页:0</span>
					</div>
				</div>
				
			</div>
		</div><!-- /.modal-content -->
		</div>
<script type="text/javascript" src="../pc/js/manager/productSelect.js"></script>
</div><!-- /.modal -->