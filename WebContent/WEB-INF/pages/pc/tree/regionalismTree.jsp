<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal-cover"></div>
<div class="modal" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">行政区划选择</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline m-t-b">
		          <div class="form-group">
		            <label for="recipient-name" class="control-label">名称</label>
		            <input type="text" class="form-control" id="recipient-name">
		          </div>
		          <button type="button" class="btn btn-primary" id="findtree">搜索</button>
				<button type="button" class="btn btn-primary" id="selectClient">确定</button>
		          <button type="button" id="closeTree" class="btn btn-default">取消</button>
		        </form>
		        <ul class="nav nav-tabs" style="margin-top:10px;">
				    <li class="active"><a href="#">树形展示</a></li>
<!-- 				    <li style="display: none;"><a href="#" id="table">列表展示</a></li> -->
				</ul>
				<input type="hidden" id="select_customer_id">
				<div class="tabs-content" style="height:400px;">
					<div class="tree" style="height:400px; overflow-y:scroll;">
<!-- 					//////树形列表区 -->
					<ul>
					<li><span id="treeAll"><i class="glyphicon glyphicon-folder-open"></i>所有</span>
					<ul>
					<c:forEach items="${requestScope.regionalismTrees}" var="regionalism">
					<li class="parent_li"><span  class="reg_tree"><i class="glyphicon glyphicon-leaf"></i>${regionalism.regionalism_name_cn}
					<input type="hidden" value="${regionalism.regionalism_id}"></span></li>
					</c:forEach>
					</ul>
					</li>
					</ul>
					</div>
				</div>
			</div> 
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
<script type="text/javascript">
regionalism={
		init:function(func){ 
			o2otree.treeSelectInit();
			var treeId=$(".modal").find(".activeT").find("input").val();
			var treeName=$(".modal").find(".activeT").find("i").html();
			regionalism.slectTreeVal(treeId,"行政区划",function(){
				if(func){
					func(treeId,treeName);
				}
				}); 
			regionalism.regionalism_init(); 
		},
		regionalism_init:function(){
			$(".tabs-content").find(".reg_tree").unbind("click");
			$(".tabs-content").find(".reg_tree").click(function(){
				$(".modal").find(".tree li span").removeClass('activeT');
				$(this).addClass('activeT');
				regionalism.regioninit(this,function(n){
					return regionalism.treeli(n.regionalism_name_cn,n.regionalism_id);
				});
			});
		},
		slectTreeVal:function(treeId,name,func){
			$(".modal").find("#selectClient").click(function(){
				if(treeId&&treeId==""){
					alert("请选择一个"+name);
				}else{
					if (func) {
						func();
					}
					$(".modal,.modal-cover").remove();
				}
			});
		},
		regioninit:function(t,treeli){
			var treeId=$(t).find("input").val();
			var t=$(t);
			if(t.next("ul").length>0){
				t.next("ul").remove();
			}else{
				pop_up_box.loadWait();
				$.get("../tree/getTree.do",{"treeId":treeId,"employeeId":$("#employeeId").val(),"type":"regionalism","ver":Math.random()},function(data){
					var ulli="";
					if (data.length>1) {
						ulli="<ul>";
					}
					for (var i = 0; i < data.length; i++) {
						var n=data[i];
						if (i>0) {
							ulli+=treeli(n);
						}
					}
					if (data.length>1) {
						ulli+="</ul>";
						t.after(ulli);
					}
					pop_up_box.loadWaitClose();
					regionalism.regionalism_init();
				});
			}
			
		},treeli:function (sort_name,treeId){
			if (sort_name&&treeId) {
				return "<li class='parent_li'><span class='reg_tree'><i class='glyphicon glyphicon-leaf'>"+
				sort_name+"</i><input type='hidden' value='"+treeId+"'></span></li>";
				}else{
					return "";
				}
			}
}
</script>
</div><!-- /.modal -->