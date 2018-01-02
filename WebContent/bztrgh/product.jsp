<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@page import="com.qianying.controller.BaseController"%>
<%
BaseController.checkClientLogin(request, response);
BaseController.getVer(request);
BaseController.getPctype(request);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>产品首页</title>
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/product_home.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
  <!------------头部---------------->
     <div class="header">
              <div class="col-xs-12 header_left btn_style" style="padding: 10px 0;border-right:1px solid #FFFFFF;cursor: pointer">在线咨询</div>
              <a class="col-xs-6 header_center" style="padding: 10px 0;border-right:1px solid #FFFFFF;cursor: pointer;color: #FFFFFF;display: none">查看市场价</a>
<!--               <div class="col-xs-4" style="padding: 10px 0;cursor: pointer">分享</div> -->
         <div class="clear"></div>
     </div>
  <!------------内容---------------->
     <div class="container">
          <div class="body_01">
              <div class="body_01_left">要求交货日期：</div>
              <div class="body_01_right">
                  <input class="form-control Wdate" id="tihuoDate" maxlength="40" type="date" onfocus="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd',isShowClear:false})">
              </div>
              <div class="clear"></div>
          </div>
         <div class="body_02">
             <div class="body_02_left">
                 编辑定制需求
             </div>
             <div class="body_02_right">
                 <textarea class="form-control" style="width: 100%;height: 100%"></textarea>
             </div>
         </div>
         <div class="body_03">
             <p>拍照上传定制需求照片</p>
             <div class="filek">
             <div class="file_box">
                 <a class="head_portrait_amend" style="display: none;" id="scxq"></a>
                 <a class="head_portrait_amend" id="upload-btn">
                     <input type="hidden" name="typeImg" id="filePath">
                     <input type="file" class="ct input-upload" name="imgFile" id="imgFile" onchange="imgUpload(this);">
                 </a>
             </div>
             <div id="imglist">
             </div>
                 <div class="clear"></div>
             </div>
         </div>
         <a class="body_04" id="postxuqiu">
             确定
         </a>
         <div style="height: 150px"></div>
         <div class="closed" style="width: 100%;height: 100%;position: fixed;left: 0;top: 0;display: none"></div>
         <div class="kefu" id="kefulist" style="display: none">
             <input type="hidden" id="platformsHeadship" value="客服">
             <ul></ul>
         </div>
     </div>
     <div class="logo_container"></div>
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
                          <ul>
                          </ul>
                      </div>
                  </div>
                  <div class="modal-footer" style="display: none">
                      <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                      <button type="button" class="btn btn-primary">保存</button>
                  </div>
              </div> 
          </div> 
      </div>
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="cms/js/head.js${requestScope.ver}"></script>
<script type="text/javascript" src="trghjs/producthome.js${requestScope.ver}"></script>
</body>
</html>