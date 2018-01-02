<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>司机提货单</title>
    <link rel="stylesheet" type="text/css" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/personalCenter.css${requestScope.ver}">
    <link rel="stylesheet" type="text/css" href="../pc/saiyu/tihuo.css${requestScope.ver}">
     <link rel="stylesheet" href="../pc/css/kefutc.css${requestScope.ver}"> 
    <script src="../js_lib/jquery.11.js"></script>
    <script src="../pcxy/js/bootstrap.js"></script>
    <script src="../js/o2od.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript" src="../js/hideMenuItems.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
	<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/near/waybill.js${requestScope.ver}"></script>
    <style type="text/css">
    #imgList img{width: 100%;}
    </style>
</head>
<body>
<!------------------------header------------------------->
<div class="header">
    <div class="header-title" style="color: white;">
        <span style="font-weight: bold;">司机提货单</span>
        <a class="header-back" style="margin-top: 5px;color: white;"><span class="glyphicon glyphicon-menu-left"></span>返回</a>
    </div>
</div>
<!----------------------secition------------------------>
<span style="display: none;" id="com_id">${requestScope.com_id}</span>
<div class="section">
    <div>
        <div class="container-one">
        <c:if test="${requestScope.fenx}">
    	<h4 style="color: #D81F1C;font-weight: bold">[标注：]请分享这个页面给拉货司机</h4>
        </c:if>
        <c:if test="${requestScope.ordertype==null}">
        <div id="list">
        </div>
        <div id="item" style="display: none;">
        	<div style="margin-bottom:2px;border:1px solid #ddd">
	        <ul>
	        <li><label>提货地点:</label><span class="text-muted pmargin" id="cmemo"></span></li>
	        <li><label>提货时间:</label><span class="text-muted pmargin" id="date"></span></li>
	        <li><label>收货联系人:</label><span class="text-muted pmargin" id="shlxr"></span>
	        <span class="glyphicon glyphicon-earphone" style="color: blue;"></span><a id="tel_no"></a></li>
	        <li><label>收货地址:</label><span class="text-muted pmargin" id="shdz"></span></li>
	        </ul>
            <span id="Status_OutStore" style="display: none;"></span>
            </div>
        </div>
            <c:if test="${requestScope.type!='jin'}">
            <a class="btn btn-primary center-block btn_style home_footer_left" style="width: 45%;display: none;">通知内勤提前备货</a>
        	<input type="hidden" id="platformsHeadship" value="内勤">
            </c:if>
            <c:if test="${requestScope.type=='jin'}">
            </c:if>
            <h4 class="text-primary" style="text-align: center;z-index: 10; position: relative;">向库管出示此二维码进行提货</h4>
            <h5 class="text-primary" style="text-align: center;z-index: 10; position: relative;">点击电话号码可直接拨打电话</h5>
            <img src="${requestScope.erweima}" class="center-block" style="margin-top: -30px;">
			<c:if test="${requestScope.Status_OutStore=='已发货'}">
			<button type="button" class="btn btn-primary center-block" id="qrsh" style="width: 45%;display: ;">确认用户收货</button>
			</c:if>
            </c:if>
            <c:if test="${requestScope.ordertype!=null}">
<!--  订单已结束! -->
            	 <a id="upload-btn" class="btn btn-primary btn-sm m-t-b">上传客户已签字出库单
				<input type="file" name="imgFile" id="imgFile" onchange="fileLoad(this);">
				<input type="hidden" id="filepath">
				</a>
				<button type="button" id="scpz"  class="btn btn-primary btn-sm m-t-b">上传客户已签字出库单</button>
				<div id="imgList">
				
				</div>
            </c:if>
        </div>
    </div>
</div>
    <div class="modal fade" id="mymodal">
	    <div class="modal-dialog" style="margin: 150px auto;width: 85%">
		    <div class="modal-content" style="border-radius: 0">
			    <div class="modal-header" style="display: none">
				  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				  <h4 class="modal-title">模态弹出窗标题</h4>
			    </div>
			    <div class="modal-body" style="padding: 0">
				    <div class="kefu" id="kefulist" style="opacity:1;">
					  <input type="hidden" id="platformsHeadship" value="客服">
					  <ul></ul>
				    </div>
			    </div>
			    <div class="modal-footer" style="display: none">
				    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				    <button type="button" class="btn btn-primary">保存</button>
			    </div>
		    </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
   <div id="copy_bottom"></div>
   <div class="closed" style="width: 100%;height: 100%;position: fixed;left: 0;top: 0;display: none"></div>
</body>
</html>