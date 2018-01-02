<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <script src="../js/o2otree.js${requestScope.ver}"></script> --%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h5 style="display:inline-block;">选择联系人</h5>
				<button type="button" class="btn btn-primary" style="displaly: inline-block;">所有人</button>
			</div>
			<div class="modal-body">
		        <ul class="nav nav-tabs">
				    <li class="active"><a>员工</a></li>
				    <li style="display: none;"><a>部门</a></li>
				    <li><a>客户</a></li>
				    <li style="display: none;"><a>供应商</a></li>
				</ul>
				
				<div class="tabs-content" style="height:240px;">
					<form class="form-inline m-t-b">
			          <div class="form-group">
			            <label for="recipient-name" class="control-label">关键词</label>
			            <div class="input-group">
							<input type="text" class="form-control input-sm" name="searchKey" maxlength="20">
							<span class="input-group-btn">
						        <button class="btn btn-success btn-sm find" type="button">搜索</button>
						    </span>
						</div>
			          </div>
			        </form>
					<div class="table-responsive" style="height:190px; overflow-y:scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th><div class="checkbox"></div></th>  
							       <th>姓名</th>
							       <th>部门</th>
							       <th>手机号</th>
							       <th>微信号</th>
							       <th>微信账号</th>
							    </tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>

				<div class="tabs-content" style="height:240px;display: none;">
					<form class="form-inline m-t-b">
			          <div class="form-group">
			            <label for="recipient-name" class="control-label">关键词</label>
			            <div class="input-group">
							<input type="text" class="form-control input-sm">
							<span class="input-group-btn">
						        <button class="btn btn-success btn-sm find" type="button">搜索</button>
						    </span>
						</div>
			          </div>
			        </form>
					<div class="tree" style="height:190px; overflow-y:scroll;">
						<ul>
							<li>
						   		<span><i class="glyphicon glyphicon-folder-open"></i> 经销商</span> 
						   		<ul>
						    		<li>
						      			<span><i class="glyphicon glyphicon-minus-sign"></i> 分销商</span> 
						     			<ul>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
						      				</li>
						     			</ul>
						    		</li>
						    		<li>
						      			<span><i class="glyphicon glyphicon-minus-sign"></i> 分销商</span> 
						    			<ul>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
						      				</li>
						      				<li>
						        				<span><i class="glyphicon glyphicon-minus-sign"></i> 终端客户</span> 
						       					<ul>
						        					<li>
						          						<span><i class="glyphicon glyphicon-minus-sign"></i> 终端客户</span> 
						           							<ul>
													            <li>
													              <span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
													            </li>
													            <li>
													              <span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
													            </li>
						            						</ul>
						        					</li>
											        <li>
											          <span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
											        </li>
											        <li>
											          <span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
											        </li>
						       					</ul>
						      				</li>
						      				<li>
						        				<span><i class="glyphicon glyphicon-leaf"></i> 终端客户</span> 
						      				</li>
						    			</ul>
						    		</li>
						   		</ul>
						  	</li>
						  	<li>
						   		<span><i class="glyphicon glyphicon-folder-open"></i> 总经销</span> 
						   		<ul>
						    		<li>
						      			<span><i class="glyphicon glyphicon-leaf"></i> 分销商</span> 
						      		</li>
						     	</ul>
						  	</li>
						</ul>
					</div>
				</div>

				<div class="tabs-content" style="height:240px;">
					<form class="form-inline m-t-b">
			          <div class="form-group">
			            <label for="recipient-name" class="control-label">关键词</label>
			            <div class="input-group">
							<input type="text" class="form-control input-sm" name="searchKey" maxlength="20">
							<span class="input-group-btn">
						        <button class="btn btn-success btn-sm find" type="button">搜索</button>
						    </span>
						</div>
			          </div>
			        </form>
					<div class="table-responsive" style="height:190px; overflow-y:scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th><div class="checkbox"></div></th>  
							       <th>姓名</th>
							       <th>部门</th>
							       <th>手机号</th>
							       <th>微信号</th>
							       <th>微信账号</th>
							    </tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="tabs-content" style="height:240px;display: none;">
<!-- 				供应商 -->
					<form class="form-inline m-t-b">
			          <div class="form-group">
			            <label for="recipient-name" class="control-label">关键词</label>
			            <div class="input-group">
							<input type="text" class="form-control input-sm" name="searchKey" maxlength="20">
							<span class="input-group-btn">
						        <button class="btn btn-success btn-sm find" type="button">搜索</button>
						    </span>
						</div>
			          </div>
			        </form>
					<div class="table-responsive" style="height:190px; overflow-y:scroll;">
						<table class="table table-bordered">
							<thead>
								<tr>  
							       <th><div class="checkbox"></div></th>  
							       <th>姓名</th> 
							       <th>手机号</th>  
							       <th>微信号</th>  
							       <th>QQ号</th>  
							       <th>编号</th> 
							    </tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default btn-sm" id="close">取消</button>
				<button type="button" class="btn btn-primary btn-sm">确定</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->