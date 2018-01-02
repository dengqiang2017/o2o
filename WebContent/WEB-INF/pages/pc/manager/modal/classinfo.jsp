<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <div class="modal-cover"></div>
<div class="modal" style="display:block; top: 5%;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">详细内容</h4>
			</div>
			<div class="modal-body">
				<ul class="nav nav-tabs">
				    <li class="active"><a href="#">查看</a></li>
				    <li><a href="#">新增</a></li>
				</ul>
				<div class="tabs-content" style="height:240px;">
					<form class="form-inline m-t-b">
			          <div class="form-group">
						<button type="button" class="btn btn-primary btn-sm m-t-b">确定</button>
						<button type="button" class="btn btn-default btn-sm m-t-b">关闭</button>
			          </div>
			        </form>
					<div class="modal-list" style="height:190px; overflow-y:scroll;">
						<ul class="modal-list-head">
							<li class="col-xs-4">名称</li>
							<li class="col-xs-4">编码</li>
							<li class="col-xs-4 last">操作</li>
						</ul>
						<c:if test="${requestScope.list==null}">
						<span>没有可查看内容</span>
						</c:if>
						<c:forEach items="${requestScope.list}" var="name">
						<ul class="modal-list-body">
							<li class="col-xs-4">${name.name}</li>
							<li class="col-xs-4">${name.bm}</li>
							<li class="col-xs-4 last">
								<button type="button" class="btn btn-link btn-sm" onclick="delUl(this);">
									<span class="glyphicon glyphicon-remove"></span>
								</button>
							</li>
						</ul>
						</c:forEach>
					</div>
				</div>
				<div class="tabs-content" style="height:240px;">
					<form class="form-inline m-t-b">
			          <div class="form-group">
			            <div class="input-group m-t-b">
							<input type="text" class="form-control input-sm" id="queryName" placeholder="关键词">
							<span class="input-group-btn">
						        <button class="btn btn-success btn-sm query" type="button">搜索</button>
						    </span>
						</div>
						<button type="button" class="btn btn-primary btn-sm m-t-b">确定</button>
						<button type="button" class="btn btn-default btn-sm m-t-b">关闭</button>
			          </div>
			        </form>
					<div class="table" style="height:190px; overflow-y:scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th><div class="checkbox"></div></th>  
							       <th>产品类别</th> 
							       <th>类别编号</th>  
							    </tr>
							</thead>
							<tbody>
								<tr>
									<td><div class="checkbox"></div></td>
									<td>禽料</td>
									<td>13890102025</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
 