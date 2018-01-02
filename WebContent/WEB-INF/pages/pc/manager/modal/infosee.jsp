<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <div class="modal-cover"></div>
<div class="modal" style="display:block; top: 10%;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">详细内容</h4>
			</div>
			<div class="modal-body" style="max-height:240px; overflow-y:scroll;">
			<c:if test="${requestScope.list==null}">
			<span>没有可查看内容</span>
			</c:if>
			<c:forEach items="${requestScope.list}" var="name">
				<span>${name.name}</span>
			</c:forEach>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">关闭</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
	<script type="text/javascript">
	$(".close,.btn-default").click(function(){
		$(".modal-cover,.modal").remove();
	});
	</script>
</div><!-- /.modal -->