<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>营销文案编辑</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="bianji/css/edit_modal.css">
<link rel="stylesheet" href="bianji/css/font-awesome.min.css">
<link href="../css/popUpBox.css" rel="stylesheet">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src='../js/ajaxfileupload.js${requestScope.ver}'></script>
<script type="text/javascript" src='../cmsjs/fileUpload.js${requestScope.ver}'></script>
<script type="text/javascript" src='js/edithtml.js${requestScope.ver}'></script>
<script type="text/javascript" src="bianji/js/nicEdit.js${requestScope.ver}"></script>
</head>
<body>
<div class="col-lg-4">
                    <div class="form_group">
                        <div class="col-lg-2">
                        <label class="form_label">文案标题</label>
                        </div>
                        <div class="col-lg-10">
                        <input type="text" class="form_input_lg form-control" id="title" maxlength="60">
                            </div>
                    </div><div class="form_group">
                    <div class="col-lg-2">
                    <label class="form_label">关键词</label>
                        </div>
                    <div class="col-lg-10">
                    <input type="text" class="form_input_lg form-control" id="gjc">
                        </div>
                </div><div class="form_group">
                    <div class="col-lg-2">
                        <label class="form_label">发布时间</label>
                        </div>
                    <div class="col-lg-10">
                        <input type="text" class="form_input_lg form-control Wdate" onfocus="WdatePicker();">
                        </div>
                    </div>
                    <div class="form_group">
                        <div class="col-lg-2">
                        <label class="form_label">发布人</label>
                            </div>
                        <div class="col-lg-10">
                        <input type="text" class="form_input_lg form-control" id="publisher" maxlength="20">
                            </div>
                    </div>
                    <div class="form_group">
                        <div class="col-lg-2">
                        <label class="form_label">编辑器中图片宽度</label>
                            </div>
                        <div class="col-lg-10">
                        <input type="number" class="form_input_lg form-control" id="imgwidth" maxlength="4" data-num="num">
                            </div>
                    </div>
                    <div class="form_group">
                        <div class="col-lg-2">
                        <label class="form_label">编辑器中图片高度</label>
                            </div>
                        <div class="col-lg-10">
                        <input type="number" class="form_input_lg form-control" id="imgheight" maxlength="4" data-num="num">
                            </div>
                    </div>
                    <div class="form_group">
                        <div class="col-lg-2">
                        <label class="form_label">置顶</label>
                            </div>
                        <div class="col-lg-10">
                        <input type="checkbox" class="form_input_lg form-control" id="zhiding">
                            </div>
                    </div>
                <div class="form_group">
                    <div class="col-lg-2">
                    <label class="form_label">封面类型</label>
                        </div>
                    <div class="col-lg-10" style="margin-top: 5px">
                        <div class="" style="width: 400px;margin-left: 15px;">
                            <lable>
                                <input type="radio" name="filetype" value="0" checked="checked">图片
                            </lable>
                            <lable>
                            <input type="radio" name="filetype" value="1">视频
                            </lable>
                        </div>
                    </div>
                </div>
                    <div id="imgdiv">
                    <div class="form_group">
                    <div class=" col-lg-2">
                        <label class="form_label">封面图片</label>
                    </div>
                        <div class="col-lg-10">
                            <div class="img_style">
                                <input class="" type="file" accept="image/*" name="imgFile" id="imgFile" onchange="imgonlyUpload(this);" style="position: absolute;width: 100%;height: 100%;opacity: 0;cursor: pointer">
                            </div>
                        <!--<input type="text" class="form_input_float" id="imginput" onchange="imgonlyUpload(this);">-->

                        <span class="form_tips_gray">图片尺寸为：318*230</span>
                            </div>
                    </div>
                    <div class="form_group">
                        <div class=" col-lg-2">
                        <label class="form_label">缩略图</label>
                            </div>
                        <div class="col-lg-10">
                        <div class="logo_image">
                            <img src="/pc/images/sxt.png" id="imgUr">
                            <input type="hidden" id="filepath">
                        </div>
                            </div>
                    </div>
                    </div>

                  <div id="videodiv" style="display: none">
                    <div class="form_group">
                        <div class=" col-lg-2">
                        <label class="form_label">本地视频</label>
                            </div>
                        <div class="col-lg-10">
                            <div class="img_style">
                                <input class="" type="file" accept="video/*" name="videoFile" id="videoFile" onchange="videoUpload(this);" style="position: absolute;width: 100%;height: 100%;opacity: 0;cursor: pointer">
                            </div>
                        </div>
                    </div>
                    <div class="form_group">
                        <div class=" col-lg-2">
                        <label class="form_label">本地或者外链视频地址</label>
                            </div>
                        <div class="col-lg-10">
                        <input type="text" class="form_input_lg form-control" id="videoaddress">
                            </div>
                    </div>
                    <div class="form_group">
                        <div class=" col-lg-2">
                        <label class="form_label">视频封面图片</label>
                            </div>
                        <div class="col-lg-10">
                        <!--<input type="text" class="form_input_float" id="videoimginput" onchange="videoimgUpload(this);">-->
                        <!--<input class="" type="file" name="videoimgFile" id="videoimgFile" onchange="videoimgUpload(this);">-->
                            <div class="img_style">
                                <input class="" type="file" accept="image/*" name="videoimgFile" id="videoimgFile" onchange="videoimgUpload(this);" style="position: absolute;width: 100%;height: 100%;opacity: 0;cursor: pointer">
                            </div>
                            <span class="form_tips_gray">图片尺寸为：宽高大于300</span>
                            </div>
                    </div>
                    <div class="form_group">
                        <div class=" col-lg-2">
                        <label class="form_label">视频缩略图</label>
                            </div>
                        <div class="col-lg-10">
                        <div class="logo_image">
                            <img src="/pc/images/sxt.png" id="videoimgUr">
                            <input type="hidden" id="videofilepath">
                        </div>
                            </div>
                    </div>
                  </div>
<!--                 <div class="form_group"> -->
<!--                     <div class="col-lg-2"> -->
<!--                     <label class="form_label">文章编辑类型</label> -->
<!--                         </div> -->
<!--                     <div class="col-lg-10" style="margin-top: 5px"> -->
<!--                         <div class="" style="width: 400px;margin-left: 15px;"> -->
<!--                             <lable> -->
<!--                                 <input type="radio" name=article value="0" checked="checked">在线编辑 -->
<!--                             </lable> -->
<!--                             <lable> -->
<!--                             <input type="radio" name=article value="1">word上传 -->
<!--                             </lable> -->
<!--                         </div> -->
<!--                         <div class="col-lg-10" style="margin-top: 5px;display: none;" id='article'> -->
<!--                         <div class=" col-lg-2"> -->
<!--                         <label class="form_label">本地word</label> -->
<!--                             </div> -->
<!--                         <div class="col-lg-10"> -->
<!--                             <div class="img_style"> -->
<!--                                 <input class="" type="file" name="articleFile" id="articleFile" onchange="articleUpload(this);" style="position: absolute;width: 100%;height: 100%;opacity: 0;cursor: pointer"> -->
<!--                             </div> -->
<!--                             <span id="articleaddress"></span> -->
<!--                         </div> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                 </div> -->
                    <div class="modal_btn_group">
                    <button type="button" id="save">确定</button>
                    <button type="button" onclick="javascript:history.go(-1);">返回</button>
                </div></div>
                
                <div  class="col-lg-8" id="editarticle">
                    <script type="text/javascript">
					var hgt=$("body").height();
						$("textarea").css("height",hgt);
                        bkLib.onDomLoaded(function() {
                            new nicEditor({maxHeight : hgt,maxWidth : 400}).panelInstance('area');
                        });
                    </script>
                    <div style="height: 700px;overflow: scroll;">
                    <textarea style="height: 600px; width:100%;" cols="50" id="area"></textarea>
                </div></div>
<script type="text/javascript">
  <!--  
$("input[name='article']").click(function(){
   	var index=$(this).val();
   	if(index=="1"){
   		$("#article").show();
   		$("#editarticle").hide();
   	}else{
   		$("#article").hide();
   		$("#editarticle").show();
   	}
   });
  //-->
  </script>
  </body>
</html>
