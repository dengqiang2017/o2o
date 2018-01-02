<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/tijianbiao.css${requestScope.ver}">
<style> 
@media(max-width:770px){
.hide_div{
 display:none;
}
.form-hide{
display:none;
}
.btn-folding{
display:block;
}
}
@media(min-width:770px){
.btn-folding{
display:none;
}
}
</style>
</head>
<body style="padding-top:0">
<div id="listpage">
<%@include file="../header.jsp" %>
        <div class="container" style="margin-top: 40px;">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
<button type="button" id="c-msg" class="btn btn-primary btn-sm m-t-b">客户信息</button>
<button type="button" id="seekh" class="btn btn-primary btn-sm m-t-b" onclick="selectclient();">选择客户</button>
<div class="sim-table" style="display: none;">
	<ul class="sim-title">
		<li class="col-xs-6">客户名称</li>
		<li class="last col-xs-6">手机号</li>
	</ul>
	<ul class="sim-msg">
		<li class="col-xs-6"></li>
		<li class="last col-xs-6"></li>
	</ul>
</div>
        </div> 
      </div>
<div>
    <button type="button" class="btn btn-primary btn-folding btn-sm  btn0" id="expand" style="display: inline-block;margin-bottom: 0;">查询</button>
 		<c:if test="${requestScope.spNo==null}">
		<a class="btn btn-success btn-sm m-t-b" onclick="tijian.addTdHtml();">增加</a>
		</c:if>
		<c:if test="${requestScope.spNo!=null}">
                  <button type="button" class="btn btn-primary" id="qrtjProduct">确认推荐产品</button>
              </c:if>
<%-- 		<c:if test="${requestScope.auth.excelImp!=null}"> --%>
<!-- 		<a id="upload-btn" class="btn btn-primary  btn-sm m-t-b">导入 -->
<!-- 	    <input type="file" id="xlstijian" name="xlstijian" onchange="excelImport(this,'tijian');"></a> -->
<%-- 		</c:if> --%>
<%-- 		<c:if test="${requestScope.auth.excel!=null}"> --%>
<!-- 	    <button type="button" class="btn btn-primary btn-sm m-t-b excel" onclick="excelExport('tijian');">导出</button> -->
<%-- 	    </c:if> --%>
    <input type="hidden" id="spNo" value="${requestScope.spNo}"> 
</div>
		<div class="box-body" style="position: relative;padding:0">
	<div class="ctn-fff box-ctn" style="margin-bottom: 0;padding:0">
    	<div class="box-head box-height" style="height:80px"></div>
    </div>
			<div class="table-responsive" id="box">
			<input type="hidden" id="select_treeId">
				<table class="table table-bordered" id="tab">
				<thead>
				<%@include file="tijianthead.jsp" %>
				</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		<div class="box-footer" style="height: 40px;padding-top: 5px;">
			<div class="pull-right">
<!-- 			<input type="text" id="page" value="1" style="width: 50px;"> -->
			总页数<span id="totalPage">${requestScope.pages.totalPage}</span>
			    <button type="button" class="btn btn-info btn-sm" id="beginpage">首页</button>
			    <button type="button" class="btn btn-info btn-sm" id="uppage">上一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="nextpage">下一页</button>
			    <button type="button" class="btn btn-info btn-sm" id="endpage">末页</button>
			</div>
		</div>
	</div>
<%-- <%@include file="../footer.jsp" %> --%>
</div>
<div id="editpage"></div>
<div class="image-zhezhao" style="display:none">
   <div style="width: 5%;float: left">
        <div class="img-left"></div>
   </div>
    <div style="width: 90%;float: left;height: 100%;">
        <div class="img-ku" style="float:left;">
            <div id="imshow">
            </div>
        </div>
    </div>
    <div style="width: 5%;float: left">
        <div class="img-right"></div>
        </div>
    <div class="gb" id="closeimgshow"></div>
</div>
    <div class="modal-first" id="mymodal">
    <div class="modal-dialog">
    <div class="modal-content">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">查询</h4>
    </div>
    <div class="modal-body">
    <div class="form">
    <form id="findForm">
    <div class="col-lg-12 col-sm-3">
    <label>位置大类</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="position_big">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>灯具名称</label>
    <input type="text" class="form-control input-sm" maxlength="20" id="item_name">
    </div>
    <div class="col-lg-12 col-sm-3">
    <label>状态</label>
    <select class="form-control input-sm" id="workState">
    <option value=""></option>
    <option value="运行">运行</option>
    <option value="报修">报修</option>
    <option value="采购">采购</option>
    <option value="审批">审批</option>
    <option value="支付">支付</option>
    <option value="配送">配送</option>
    </select>
    </div>
    <div class="col-sm-3 col-lg-12">
    <div class="form-group">
    <div class="input-group">
    <label>&nbsp;</label>
    <input type="text" class="form-control input-sm" maxlength="50" placeholder="请输入搜索关键词" id="searchKey"> <span class="input-group-btn">
    <button class="btn btn-success btn-sm find" style="margin-top: 26px" type="button">搜索</button>
    </span>
    </div>
    </div>
    </div>
    <div style="clear:both"></div>
    </form>
    </div>
    </div>
    <div class="modal-footer">
    </div>
    </div>
    </div>
    </div>
  <%@include file="imgupload.jsp"%>
<script src="../js/o2od.js${requestScope.ver}"></script>   
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
 <script type="text/javascript" src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/saiyu/tijianList.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
		var cMsg=$(".sim-table");
	$("#c-msg").click(function(){
		var height=document.body.clientHeight;
		height=height-100-40-40-40;
		if(cMsg.is(":hidden")){
			cMsg.show();
		}else{
			cMsg.hide();
			height=height+50;
		}
		$(".box-body").css("height",height+"px");
	});
	var height=document.body.clientHeight;
	height=height-100-40-40-55;
	$(".box-body").css("height",height+"px");
	$("#listpage").css("overflow","hidden");
	$(".box-body").css("height",height+"px");
	$("#tab").css("margin-bottom","5px");
	if(IsPC()){
		$("#box").css("height",(height-78)+"px");
	}else{
		$("#box").css("height",(height-78)+"px");
	}
//-->
</script>
</body>

</html>